#!/bin/sh
#
# Script to mount and umount USB drive (/dev/sda1) to
# /data/usb/

USB_DRIVE_BLOCK_DEV="/dev/block/sda1"
USB_DRIVE_PATH="/data/usb"
POLLING_PERIOD=5

mkdir -p ${USB_DRIVE_PATH}

while true ; do

  # watch /dev/block/sda1
  echo "waiting for plugging USB drive"
  while true ; do
    if /bin/exists ${USB_DRIVE_BLOCK_DEV}; then
      if mount -t vfat -o fmask=0000,dmask=0000 ${USB_DRIVE_BLOCK_DEV} ${USB_DRIVE_PATH} ; then
        break;
      fi # mount
      if mount -t ext4 ${USB_DRIVE_BLOCK_DEV} ${USB_DRIVE_PATH} ; then
        break;
      fi # mount
    fi # exists
    sleep ${POLLING_PERIOD};
  done # true
  echo "USB drive mounted"

  # watch /dev/block/sda1
  echo "waiting for unplugging USB drive"
  while true ; do
    if /bin/exists ${USB_DRIVE_BLOCK_DEV}; then
    else
      if umount ${USB_DRIVE_PATH} ; then
        break;
      else
        # check /proc/mounts to see if has been umounted (by user) already
        if grep ${USB_DRIVE_PATH} /proc/mounts; then
        else
          break;
        fi
      fi # umount
    fi # exists
    sleep ${POLLING_PERIOD};
  done # true

  echo "USB drive umounted"

done
