#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=node-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install dialog
_re "apt-get install -y nodejs npm" "Node.js installed" "Node.js installation failed"

# The upstream name for the Node.js interpreter command is "node".
# In Debian the interpreter command has been changed to "nodejs".
# This causes conflicts during the npm install process
$SSHCMD "ln -s /usr/bin/nodejs /usr/bin/node"

_re "npm install pm2 -g" "PM2 installed" "PM2 installation failed"

