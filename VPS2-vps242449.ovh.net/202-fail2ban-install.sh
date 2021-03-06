#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=fail2ban-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install dialog
_re "apt-get install -y fail2ban" "fail2ban installed" "fail2ban installation failed"