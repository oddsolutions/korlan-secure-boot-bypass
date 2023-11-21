#!/bin/sh
# Creates the necessary directories for fluoride and fixes the file permissions

# Accessed in hardware/broadcom/libbt/src/bt_vendor_brcm.c
chown bluetooth:bluetooth /dev/ttyS1
chmod 660 /dev/ttyS1
chown bluetooth:bluetooth  /sys/devices/platform/bt-dev/rfkill/*/type
chmod 660 /sys/devices/platform/bt-dev/rfkill/*/type
chown bluetooth:bluetooth /sys/devices/platform/bt-dev/rfkill/*/state
chmod 660 /sys/devices/platform/bt-dev/rfkill/*/state

MISC=/data/misc
BLUEDROID_DIR=${MISC}/bluedroid
HCI_DIR=/data/bt_hci

mkdir -p ${HCI_DIR}
chmod 770 ${HCI_DIR}
chown bluetooth:net_bt_stack ${HCI_DIR}

# If directory is not empty then do nothing.
ls ${BLUEDROID_DIR}/* && exit 0

# Previous builds may have a symlink to /tmp, so we need to remove it.
# See b/23080068
rm -r ${BLUEDROID_DIR}
mkdir -p ${BLUEDROID_DIR}
chmod 755 ${MISC}
chmod 750 ${BLUEDROID_DIR}
chown bluetooth:bluetooth ${BLUEDROID_DIR}
