#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name='users'
config_default_install='yes'
# <END OF CONFIG>


#
# Create users
#
# installation of apg password generator
$SSHCMD "apt-get install -y apg"
password=`$SSHCMD "apg -a 1 -m 14 -x 14 -n 1 -q"`
echo "password: $password"
#$SSHCMD "user=emo;passwd=`apg -a 1 -m 14 -x 14 -n 1 -q`; useradd --create-home --password $passwd --shell /bin/bash --gid users --no-user-group ${user}; echo "$user : $passwd""

