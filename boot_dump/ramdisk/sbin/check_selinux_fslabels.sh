#!/bin/sh
# This file checks if SELinux is enabled, and relabels the filesystem
# if it is enabled, but was not enabled at the last boot.
# This ensures that all files are appropriately labeled when an existing
# device is updated to support selinux.

readonly getenforce_path=/bin/getenforce
readonly selinux_flag_path=/data/selinux/was_enabled
readonly selinux_flag_parent_dir=/data/selinux

selinux_enforcing=false

if /bin/exists ${getenforce_path}; then
  readonly enforce_mode=$(exec ${getenforce_path} | tr '[:upper:]' '[:lower:]')
  if test -n "${enforce_mode}" -a "${enforce_mode}" != "disabled"; then
    selinux_enforcing=true
  fi
fi

if ${selinux_enforcing}; then
  echo "SELinux is enabled."
  if ! /bin/exists ${selinux_flag_path}; then
    echo "SELinux was not enabled last boot. Relabeling filesystem."
    mkdir -p ${selinux_flag_parent_dir}
    if restorecon -R /; then
      touch ${selinux_flag_path}
    else
      echo "ERROR: SELinux relabeling failed!!!"
      exit 1
    fi
  fi

else
  echo "SELinux is disabled."
  if /bin/exists ${selinux_flag_path}; then
    rm -f ${selinux_flag_path}
  fi
fi
