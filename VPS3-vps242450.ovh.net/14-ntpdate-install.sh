#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=ntpdate-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# set date/time
_re "apt-get install ntpdate" "ntpdate installed" "failed to install ntpdate"
_re "ntpdate fr.pool.ntp.org" "Server time set with ntpdate" "Failed to set date/time"
