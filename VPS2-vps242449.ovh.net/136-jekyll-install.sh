#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=jekyll-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install ruby
_re "apt-get install -y ruby" "Ruby installed" "Ruby installation failed"
_re "gem install jekyll" "Jekyll installed" "Jekyll installation failed"

