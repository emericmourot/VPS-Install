#!/usr/bin/env bash

# <START OF CONFIG>
config.app_name=ntpdate
config.default_install=yes
# <END OF CONFIG>

# set date/time
_re "apt-get install ntpdate" "ntpdate installed" "failed to install ntpdate"
_re "ntpdate fr.pool.ntp.org" "Server time set with ntpdate" "Failed to set date/time"
