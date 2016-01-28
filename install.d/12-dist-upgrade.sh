#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=dist-upgrade
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# update packages
_re "apt-get update" "done apt-get update" "apt-get update failed"

# upgrade
$SSHCMD "apt-get upgrade"
_e "done apt-get upgrade"
$SSHCMD "apt-get dist-upgrade"
_e "done apt-get dist-upgrade"