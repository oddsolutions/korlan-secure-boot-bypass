#!/bin/sh
# If demo is set, clear it and reboot.
# Quickest is to just try deleting and let rm fail silently.
rm -f /data/property/persist.demo_mode

