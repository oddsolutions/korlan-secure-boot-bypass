#!/bin/sh
# create /data/collectd/var/{lib,run}

mkdir -p /data/collectd/var/lib
mkdir -p /data/collectd/var/run
chmod -R 0770 /data/collectd
