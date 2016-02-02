#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=ssh-connect
config_default_install=yes
# <END OF CONFIG>

source "var.cfg" 2>&1 /dev/null
_eal "Starting a ssh connexion to $hostname with user $username..."
$SSHCMD