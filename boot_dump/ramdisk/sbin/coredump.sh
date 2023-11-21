#!/bin/sh

# This script reads coredump data from stdin.
#
# If the coredump directory exists and it is a non-user build, then it
# compresses the coredump and writes it to the coredump directory.
# Otherwise, if live_crash_reporter is installed, it lets live_crash_reporter
# read the coredump from stdin and convert it to a minidump for uploading
# to go/crash.
#
# Note that there is no stderr in this environment (only stdout).
#
# arguments:
#   $1    coredump directory
#   $2    executable filename
#   $3    PID
#   $4    hostname
#   $5    signal
#   $6    time

# program running from kernel space doesn't have environment variables set up,
# may not find shared libraries
export LD_LIBRARY_PATH=/system/vendor/lib:/system/lib:/usr/lib:/lib

# Android system properties uses a file descriptor opened by init, but if we
# were called by the kernel, we can't see directly. Grab the path and
# property area size from the ueventd process and pass them with an env var.
# The glibc-bridge was updated to use the KERNEL_DUMPSTATE env variable.
UEVENTD_PID=$(ps | grep ueventd | sed 's/\s\s*/ /g' | cut -d' ' -f2)
ANDROID_ENV=$(cat /proc/${UEVENTD_PID}/environ | grep -z ANDROID_PROPERTY_WORKSPACE | cut -d = -f 2)
PROPERTIES_PATH="/proc/$UEVENTD_PID/fd/$(echo ${ANDROID_ENV} | cut -d , -f 1)"
PROPS_SIZE=$(echo ${ANDROID_ENV} | cut -d , -f 2)
export KERNEL_DUMPSTATE="${PROPERTIES_PATH},${PROPS_SIZE}"

# Argument $2 (which corresponds to the %e specifier in the core_pattern), is
# the comm value for the crashing thread. While this value is often the same as
# the executable filename, it can be modified, usually to differentiate threads
# in a  multithreaded process. Therefore we should log both the thread comm
# value ($2) and the executable filename retrieved from the PID to make it
# easier to triage the crash.
# See the man pages core(5) and proc(5) for more information.
EXECUTABLE=$(/bin/basename $(/bin/readlink /proc/$3/exe))
SIGNAL=$(/sbin/busybox kill -l $5)
/bin/log -p e "Crash occurred. Executable: $EXECUTABLE, PID: $3, Thread: $2," \
  "Signal: $SIGNAL"

CORE_DIR=$1
if /bin/exists ${CORE_DIR}; then
    CORE_FILE=core.$2.$3.$4.$5.$6.gz
    DUMPSTATE_FILE=dumpstate.$2.$3.$4.$5.$6.log
    # check if it is non-user build by checking "console" in boot command.
    if grep "\bconsole\b" < /proc/cmdline; then
        dumpstate -w coredump.sh > ${CORE_DIR}/${DUMPSTATE_FILE}
        gzip > ${CORE_DIR}/${CORE_FILE}
    fi
elif /bin/exists /system/chrome/bin/live_crash_reporter; then
  /bin/logwrapper /system/chrome/bin/live_crash_reporter \
    --bin-dir=/system/chrome --home-dir=/data/chrome --pid=$3 \
    --minidump-dir=/tmp --metrics-dir=/data/share/chrome/metrics
fi
