#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=lpe-website-install
config_default_install=yes
config_git_password=4BG29cbk7ZDk
config_target=production
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# Switch to user
SSHCMD="ssh ${username}@${hostname}"
_d "[ssh cmd   = $SSHCMD]"
set -x
# get lpe-web sources
_re "cd ~/; git clone https://EmericMourot:${config_git_password}@bitbucket.org/EmericMourot/lpe-web.git lpe-web" "sources cloned successfully" "sources clone failed"

# npm install
_re "cd ~/lpe-web; npm install" "NPM packages installed" "NPM packages installation failed"

# bower install
_re "cd ~/lpe-web; bower install  --allow-root" "Bower packages installed" "Bower packages installation failed"

# gulp for building all sources and generating all images
_re "cd ~/lpe-web; gulp generate --${config_target}" "site generated in dist folder" "failed to generate dist"

# server side
$SSHCMD "cd ~/lpe-web; cp -r rest-api-server /var/"

# npm install (server side)
_re "cd /var/rest-api-server/; npm install" "NPM packages installed for REST API server" "NPM packages installation failed for REST API server"

# start server
# pm2 start server.js -- --stage


# ln -s /etc/nginx/sites-available/stage.lespetitsentrepreneurs.com /etc/nginx/sites-enabled/
#sudo ln -s /etc/nginx/sites-available/site1 /etc/nginx/sites-enabled/site1
# sudo service nginx restart
