#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=monit-install
config_default_install=no
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install dialog
_re "apt-get install -y monit" "monit installed" "monit installation failed"