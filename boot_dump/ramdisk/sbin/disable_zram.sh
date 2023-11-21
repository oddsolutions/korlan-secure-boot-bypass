#!/bin/sh

# no-op if zram is not enabled
if ! cat /proc/swaps | grep -q "zram"; then
  return
fi

echo "Disabling zram"
swapoff /dev/block/zram0
echo "1" > /sys/block/zram0/reset
