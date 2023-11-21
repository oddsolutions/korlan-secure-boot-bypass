#!/bin/sh
# This script concats all saved logs from logcatd.
# arguments:
#   $1    directory where logcatd outputs logs

usage() {
  1>&2 echo "Usage: $0 log_output_directory"
}

if test -z "$1"; then
  usage
  exit 1
fi

SAVED_LOG_DIR=$1

ls ${SAVED_LOG_DIR}/* |
  sort -ru |
  grep "logcat[.]*[0-9]*\$" |
  xargs cat
