#!/bin/bash

# If the assistant executable isn't present, libassistant.so is being used and
# run as part of cast_receiver.sh, so this script is intentionally a no-op.
if /bin/exists /system/chrome/bin/assistant
then
    setprop ctl.start assistant
fi
