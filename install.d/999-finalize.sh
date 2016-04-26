#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=finalize
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# Activate firewall rules
$SSHCMD "/etc/init.d/firewall start"