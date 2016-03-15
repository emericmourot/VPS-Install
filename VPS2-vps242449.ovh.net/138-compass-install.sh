#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=compass-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install compass
_re "gem install compass" "Compass installed" "Compass installation failed"

