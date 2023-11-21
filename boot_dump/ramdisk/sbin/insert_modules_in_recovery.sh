#!/bin/sh

# Run insmod in a script. This can avoid blocking recovery process when mod is
# missing
insmod /lib/modules/mali.ko
