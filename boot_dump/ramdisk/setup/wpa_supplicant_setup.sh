#!/bin/sh
# create /data/wpa_supplicant.conf if not exists.
# second /bin/exists is no-op.
CONFIG_FILE_IN=/etc/wpa_supplicant.conf.in
CONFIG_FILE=/data/wifi/wpa_supplicant.conf

if /bin/exists ${CONFIG_FILE} ; then /bin/exists; else
  /bin/cat ${CONFIG_FILE_IN} > ${CONFIG_FILE}
fi

# Copy if wpa_supplicant.conf is corrupted.
# When wpa_suppliacnt.conf is corrupted, possibly due to power
# failure during write or file system corruption, file size
# is truncated to 0. Check "ctrl_interface" to make sure it is
# configured and can talk to clients, such as eureka_shell.
if grep -w ctrl_interface ${CONFIG_FILE}; then /bin/exists; else
  /bin/cat ${CONFIG_FILE_IN} > ${CONFIG_FILE}
fi

chmod 0600 ${CONFIG_FILE}
chown wifi ${CONFIG_FILE}
