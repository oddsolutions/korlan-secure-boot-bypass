#!/bin/sh
# Script to start network-related services.

if grep -w "test_mode=true" < /proc/cmdline; then
  echo "All network services disabled in test mode."
  exit 0
fi

#persist.use.wpa_supplicant=1 -> always use wpa_supplicant
use_wpasup=$(getprop persist.use.wpa_supplicant)
fw_wpa_supplicant=$(getprop ro.build.fw_wpa_supplicant)
if test -z "${fw_wpa_supplicant}" -o "${use_wpasup}" = "1" ; then
  start wpa_supplicant
fi

# Anritsu is used for RF test.
ANRITSU_MODE="$(getprop persist.anritsu_mode)"
WPA_CONF=/data/wifi/wpa_supplicant.conf

case "${ANRITSU_MODE}" in
"true"|"1")
  # Wifi configuration for ANRITSU.
  rm "${WPA_CONF}"
  echo ctrl_interface=/data/wifi >> "${WPA_CONF}"
  echo update_config=1 >> "${WPA_CONF}"
  echo country=US >> "${WPA_CONF}"
  echo "network={" >> "${WPA_CONF}"
  echo ssid=\"ANRITSU\" >> "${WPA_CONF}"
  echo scan_ssid=1 >> "${WPA_CONF}"
  echo key_mgmt=NONE >> "${WPA_CONF}"
  echo "}" >> "${WPA_CONF}"
  chmod 444 "${WPA_CONF}"

  # static IP for bluetest DUT.
  ifconfig "$(getprop wifi.interface)" 192.168.0.100

  # Trigger scan.
  wpa_cli scan

  start ipthroughput

  exit 0
  ;;
*) ;; # just to make shellcheck happy
esac

# Pre-create this file and make it readable to all. This is intentional
# to allow multiple processes to access this lock file using flock to
# synchronize on /etc/resolv.conf. Without pre-creation, different process may
# create this file if non-existent, resulting in uncertain ownership and
# permission.
touch /tmp/resolv.conf.lock
chmod 0444 /tmp/resolv.conf.lock

start net_mgr
start dhcpcd

demo_mode=$(getprop persist.demo_mode)
if test -n "${demo_mode}" ; then
  echo "Bluetooth is disabled in demo mode."
else
  start bluetoothtbd
fi

setprop wifi.setup 1
