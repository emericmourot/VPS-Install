#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=users-config
config_default_install=no
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

#
# Create users
#
# installation of apg password generator
# install dialog
_re "apt-get install -y apg" "apg password generator installed" "apg password generator installation failed"
password=`$SSHCMD "apg -a 1 -m 14 -x 14 -n 1 -q"`
echo "password: $password"
#$SSHCMD "user=emo;passwd=`apg -a 1 -m 14 -x 14 -n 1 -q`; useradd --create-home --password $passwd --shell /bin/bash --gid users --no-user-group ${user}; echo "$user : $passwd""

