#!/bin/sh

# bump the version number up to force removing font cache
font_version=ver.2

if /bin/exists /data/chrome/fontconfig/$font_version ; then /bin/exists; else
  # clean up font cache
  rm /data/chrome/fontconfig/*
  # create font version file
  touch /data/chrome/fontconfig/$font_version
fi
