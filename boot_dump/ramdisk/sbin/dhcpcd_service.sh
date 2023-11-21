#!/bin/sh
# Script to start dhcpcd service

if test "$(getprop persist.use.fw_dhcpc)" = "1"; then
  managed_interfaces="eth0"
else
  managed_interfaces="eth0 wlan0 wlan1"
fi

# Check the existence of /system/gwifi to determine if this is a build with
# gWifi support. If so, add gwifi interfaces to managed_interfaces list.
# The gwifi interfaces are created with gwifi_create_interfaces.sh on boot
if /bin/exists /system/gwifi; then
  managed_interfaces="${managed_interfaces} br-lan br-guest"
fi

exec /bin/dhcpcd ${managed_interfaces} -B --noarp -h
