#!/bin/sh
# Watchdog-related setup. Argument is the processes to be monitored.
#
# Usage:
#   watchdog_setup [proc] ...
#
# Note:
#   1. proc is the basename of the program executed, for example,
#      PE_Single_CPU, not /bin/PE_Single_CPU.
#   2. this script must run after the launch of  processes that need to be
#      monitored.

WATCHDOG_DIR=/data/watchdog
PID_FILES_DIR=${WATCHDOG_DIR}/pid_files
LOG_DIR=${WATCHDOG_DIR}/log
WATCHDOG_DIR_IN=/etc
CONFIG_FILE_IN=${WATCHDOG_DIR_IN}/watchdog.conf.in
CONFIG_FILE=${WATCHDOG_DIR}/watchdog.conf

umask 077
rm -r ${PID_FILES_DIR}
mkdir -p ${WATCHDOG_DIR}
chown root:chrome ${WATCHDOG_DIR}
chmod 750 ${WATCHDOG_DIR}
mkdir -p ${LOG_DIR}
chown root:chrome ${LOG_DIR}
chmod 770 ${LOG_DIR}
mkdir -p ${PID_FILES_DIR}

cat ${CONFIG_FILE_IN} > ${CONFIG_FILE}

# traverse /proc/*/, find the processes to be monitored
# and append to configure file
if test "$*" != ""; then
  cd /proc/
  for i in `ls -d [0-9]*` ; do
    # loop over processes to be monitored
    for monitored in $@; do
      # exclude
      #   - logwrapper
      #   - self (this script)
      if cat $i/cmdline 2>/dev/null | grep -v $0 | grep -v logwrapper |\
          grep -w ${monitored} > /dev/null 2>&1; then
        # output to .pidfile and .conf file
        echo $i > ${PID_FILES_DIR}/${monitored}.pid
        echo pidfile = ${PID_FILES_DIR}/${monitored}.pid >> ${CONFIG_FILE}
      else
        # not match
      fi
    done
  done
fi

for monitored in $@; do
  if exists ${PID_FILES_DIR}/${monitored}.pid; then
  else
    # output an invalid PID, PID_MAX_LIMIT = 2^22 even for 64-bit system
    # this will automatically force watchdog to trigger reboot
    echo 4194304 > ${PID_FILES_DIR}/${monitored}.pid
    echo pidfile = ${PID_FILES_DIR}/${monitored}.pid >> ${CONFIG_FILE}
    # log the failure
    log -t watchdog_setup.sh  "Failed to setup monitor for $monitored"
  fi
done
