#!/bin/sh
# Writes the getprop output to a file on the usb.
# It is used for retail demo build to get the build information, because retail demo build
# do not have any other connectivity like internet, bt, adb etc.
#
# To get the build info, user plugs in the usb and boots the retail demo device and wait for about
# half a minute once the device has booted and then unplugs the usb to find the build information.

# Sleep for some time, so that usb is mounted and properties have been populated.
sleep 10

# Assuming /factory/serial.txt exists i.e. devices have been provisioned, which will be the case
# for the devices in the retail stores.
build_info_filename="build_info_$(cat /factory/serial.txt)"

# This build info might be dumped to a reflash recovery usb. Don't dump in the root usb folder,
# otherwise reflash factory images verification will fail
build_info_dir="/data/usb/build_info"
mkdir -p "$build_info_dir"

# If the usb is not mounted, it will simply write it to the cache partition, which is not an issue.
getprop > "${build_info_dir}/${build_info_filename}"

sync