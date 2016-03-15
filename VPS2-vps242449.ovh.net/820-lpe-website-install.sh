#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=lpe-website-install
config_default_install=yes
config_git_password=4BG29cbk7ZDk
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# get lpe-web sources
$SSHCMD "cd ~/; git clone https://EmericMourot:${config_git_password}@bitbucket.org/EmericMourot/lpe-web.git lpe-web"

# npm install
$SSHCMD "cd ~/lpe-web; npm install"

# gulp install
$SSHCMD "cd ~/lpe-web; gulp install"

# gulp for building all sources and generating all images
$SSHCMD "cd ~/lpe-web; gulp"
