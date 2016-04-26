#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=discourse-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# Force to allow all outgoing connexions
$SSHCMD "/usr/mine/firewall stop"

_re "mkdir /var/discourse && git clone https://github.com/discourse/discourse_docker.git /var/discourse" "Discourse files cloned" "Discourse files clone failed"
_copy2root "822-discourse-install/app.yml" "/var/discourse/containers/"
_re "/var/discourse/launcher bootstrap app" "Bootstraped discourse docker container ok" "Bootstraped discourse docker container failed"
_re "/var/discourse/launcher start app" "Discourse docker container started" "Discourse docker container start failed"

# Reset firewall with secure rules (outgoing)
$SSHCMD "/etc/init.d/firewall start"

