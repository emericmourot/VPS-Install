#!/usr/bin/env bash

# <START OF CONFIG>
config.app_name=upgrade
config.default_install=yes
# <END OF CONFIG>

# update packages
_re "apt-get update" "done apt-get update" "apt-get update failed"

# upgrade
$SSHCMD "apt-get upgrade"
_e "done apt-get upgrade"
$SSHCMD "apt-get dist-upgrade"
_e "done apt-get dist-upgrade"