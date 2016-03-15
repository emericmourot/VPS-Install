#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=dist-upgrade
config_default_install=no
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# update packages
_re "apt-get -y update" "done apt-get update" "apt-get update failed"

# upgrade
_re "apt-get -y upgrade" "done apt-get upgrade" "apt-get upgrade failed"

# dist upgrade
# TODO: failed, blocked in the middle of the dist-upgrade process
#_re "apt-get -y dist-upgrade" "done apt-get dist-upgrade" "apt-get dist-upgradefailed"
