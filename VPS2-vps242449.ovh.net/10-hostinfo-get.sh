#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=hostinfo-get
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# get system information
_re "apt-get install lsb-release" "lsb-release installed" "lsb-release failed to install"
data="$($SSHCMD "lsb_release -da 2> /dev/null")" && _eal "SYSTEM: $data"