#!/bin/sh
# This script compiles and prints logs from both logcat and logcatd.
# It compiles the logs temporarily in /data/logs_tmp.

readonly LOG_DIR=/data/misc/logd

# If the timestamp doesn't have YEAR, logcat may not behave as intended when the
# month rolls over from 12 to 1.
latest_logcat=`ls ${LOG_DIR}/* | sort -u | grep "logcat[.]*[0-9]*\$" | head -n 1`
last_timestamp=`tail -n 1 "${latest_logcat}" | cut -d" " -f 1-2`

# Timestamp should be in the form "YYYY-MM-DD HH:MM:SS.mmm". Using regex
# wildcards for readability.
timestamp_format_regex="/^....-..-.. ..:..:..\....$/p"
is_timestamp_format=`echo ${last_timestamp} | sed -n "${timestamp_format_regex}"`

# Must dump persistent logs *after* saving timestamp to avoid gaps between
# logpersist_cat and logcat.
/sbin/logpersist_cat.sh ${LOG_DIR}

if test -z "${is_timestamp_format}"; then
  echo "------Couldn't find last persistent log timestamp. Printing full logcat."
  logcat -d -v threadtime
else
  echo "------beginning of logcat logs after ${last_timestamp}"
  logcat -d -v threadtime -t "${last_timestamp}"
fi
