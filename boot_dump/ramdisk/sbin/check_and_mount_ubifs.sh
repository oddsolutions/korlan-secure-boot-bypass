#!/bin/sh

set -e

mtd_device_number=$1
name=$2
mtd_device=/dev/mtd/mtd${mtd_device_number}
mount_point=$3
bad_block_per_1024=$4

if grep "$3 ubifs" /proc/mounts ; then
  echo "$mount_point is already mounted"
  exit 0
fi

echo "Mounting mtd device ${mtd_device_number} as /${name}"
if /bin/exists /dev/ubi_ctrl; then : ; else
  echo "Cannot find /dev/ubi_ctrl. Is UBIFS support enabled on this kernel?"
  exit 1
fi

mkdir $mount_point || true

if /sbin/ubiattach /dev/ubi_ctrl -m $mtd_device_number -d $mtd_device_number -b $bad_block_per_1024 ; then : ; else
  /bin/sh /sbin/ubifs_log_failure.sh attach || true
  echo "Attach failed. Reseting mtd device ${mtd_device_number}"
  /sbin/ubidetach -m $mtd_device_number || true
  /sbin/ubiformat -y $mtd_device
  /sbin/ubiattach /dev/ubi_ctrl -m $mtd_device_number -d $mtd_device_number -b $bad_block_per_1024
  /sbin/ubimkvol /dev/ubi${mtd_device_number} -m -N ${name}
fi

if mount -t ubifs ubi${mtd_device_number}:${name} $mount_point -o noexec,rw,nosuid,nodev,noatime; then : ; else
  /bin/sh /sbin/ubifs_log_failure.sh mount || true
  echo "Mount failed. Reseting mtd device ${mtd_device_number}"
  /sbin/ubidetach -m $mtd_device_number || true
  /sbin/ubiformat -y $mtd_device
  /sbin/ubiattach /dev/ubi_ctrl -m $mtd_device_number  -d $mtd_device_number -b $bad_block_per_1024
  /sbin/ubimkvol /dev/ubi${mtd_device_number} -m -N ${name}
  mount -t ubifs ubi${mtd_device_number}:${name} $mount_point -o noexec,rw,nosuid,nodev,noatime
fi
