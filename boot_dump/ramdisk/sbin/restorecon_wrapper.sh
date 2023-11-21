#!/bin/sh
# Run restorecon if it exists

if /bin/exists /bin/restorecon; then
  restorecon $@
fi

