#!/bin/sh

# if zram is already enabled, no-op
if cat /proc/swaps | grep -q "zram"; then
  return
fi

readonly zram_disksize=`getprop persist.zram.disksize`

echo "Enabling zram with swap size $zram_disksize"
echo $zram_disksize > /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon /dev/block/zram0
