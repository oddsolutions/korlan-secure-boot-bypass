#!/bin/sh

logfile_dir="/cache/recovery"
logfile_path="${logfile_dir}/flash_recovery.log"
if test -z "$1"
then
  partition_name="recovery"
else
  partition_name="$1"
fi
source_image_path="/system/boot/recovery.img"

flash_image_args="$partition_name $source_image_path"

# If FTS is directing us to boot into recovery,
# but we're on the main image (not recovery), something
# is probably wrong with the recovery image.
# Ensure it gets rewritten on corruption anywhere.
if grep bootloader.command=boot-recovery /proc/fts ; then
  flash_image_args="--scan-all $flash_image_args"
fi

mkdir -p "$logfile_dir"
/bin/flash_image $flash_image_args >> $logfile_path 2>&1

# After flash recovery.img, we will set next boot to normal boot. This will prevent
# user booting into recovery mode when they just want to normally reboot it.
# If the update process is stopped by this, there will be another update checking
# when it is in the normal boot mode.

if grep bootloader.command=boot-recovery /proc/fts ; then
  fts -s "bootloader.command" ""
fi
