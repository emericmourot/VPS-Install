#!/usr/bin/env bash

# <START OF CONFIG>
config.app_name=gethostinfo
config.default_install=yes
# <END OF CONFIG>

# get system information
_re "apt-get install lsb-release" "lsb-release installed" "lsb-release failed to install"
data="$($SSHCMD "lsb_release -da 2> /dev/null")" && _e "SYSTEM: $data"

