#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=usrmine-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# create /usr/mine/bin
$SSHCMD  "mkdir -p /usr/mine/bin"

# add /usr/mine/bin to PATH
# for Ubuntu only
$SSHCMD "echo '#!/bin/sh' > /etc/profile.d/usrmine.sh ; echo 'export PATH=\$PATH:/usr/mine/bin' >> /etc/profile.d/usrmine.sh"

# copy tools
_copy "tools/search" "/usr/mine/bin"
$SSHCMD "chmod u+x /usr/mine/bin/*"
