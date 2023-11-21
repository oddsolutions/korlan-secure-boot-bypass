#!/bin/sh
#
# Derive serial number from wifi mac address and populate /factory/serial.txt

MAC_ADDR=$(cat /sys/class/net/wlan0/address)

# The OUI (first 6 characters of MAC address) doesn't add to uniqueness
# Remove the first 2 to make a alphanumeric unique serial number of length 10
SERIAL_NUMBER=$(echo ${MAC_ADDR} | sed s/://g | cut -c 3-)
SERIAL_FILE=/factory/serial.txt
echo ${SERIAL_NUMBER} > ${SERIAL_FILE}
