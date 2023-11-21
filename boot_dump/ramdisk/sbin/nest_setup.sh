#!/bin/sh

# nldaemon folder structure
mkdir -p /data/misc/libdaemon/run

# nldaemon settings.config and provision info
mkdir -p /data/nestlabs

# Tuntap needed for the weave tunnel
mkdir -p /dev/net
chmod 0770 /dev/net
chown root:root /dev/net
mknod /dev/net/tun c 10 200
chmod 0666 /dev/net/tun
