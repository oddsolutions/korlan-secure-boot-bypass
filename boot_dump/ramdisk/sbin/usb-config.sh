#!/bin/sh

# Datasheet link:
# https://drive.google.com/a/google.com/file/d/0BwU7eIsBShViYkphRzJkNkwxeVE/view?usp=sharing

tusb320h_reset () {
  i2cset -f -y 2 $1 0x0a 0x08
}

tusb320h_config () {
  i2cset -f -y 2 $1 0x08 0x40
  i2cset -f -y 2 $1 0x0a 0x20
}

# Configure GPIODV_20 as output high
echo 79 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio79/direction
echo 1 > /sys/class/gpio/gpio79/value
echo 79 > /sys/class/gpio/unexport

sleep 1

tusb320h_reset 0x47
tusb320h_config 0x47
