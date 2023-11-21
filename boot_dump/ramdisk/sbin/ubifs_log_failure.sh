#!/bin/sh
# Increments count for ubifs failure within fts

set -e

ubifs_fts_key=$(/bin/printf "ubifs_%s_failure_count" $1)

if /sbin/fts -g ${ubifs_fts_key} | grep "[0-9][0-9]*"; then
  failure_count=$(/sbin/fts -g ${ubifs_fts_key})
  failure_count=$((failure_count + 1))
  /sbin/fts -s ${ubifs_fts_key} ${failure_count}
else
  /sbin/fts -s ${ubifs_fts_key} 1
fi
