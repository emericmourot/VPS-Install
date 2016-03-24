#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=graphicsmagick-install
config_default_install=no
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install ruby
_re "apt-get install -y graphicsmagick" "Graphics Magick installed" "Graphics Magick installation failed"

