#!/bin/sh

set -e

#getprop
local counter="$(fts -g boot.counter)"

if [ -z "$counter" ]; then
  #initial reboot count
  counter=1
else
  #increment boot count
  counter=$(( counter + 1 ))
fi

#setprop
fts -s boot.counter $counter
