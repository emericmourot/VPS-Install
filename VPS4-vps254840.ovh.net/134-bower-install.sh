#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=bower-install
config_default_install=no
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install
_re "npm install --global bower" "Bower installed" "Bower installation failed"
