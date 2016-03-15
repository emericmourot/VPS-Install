#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=gulp-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install
_re "npm install --global gulp-cli" "Gulp installed" "Gulp installation failed"
