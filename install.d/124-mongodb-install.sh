#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=mongodb-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install dialog
_re "apt-get install -y mongodb" "MongoDB installed" "MongoDB installation failed"

# https://docs.mongodb.org/manual/administration/production-checklist/
# https://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/
$SSHCMD "mkdir /var/mongodb-data"


# configuration file /etc/mongod.conf
# https://docs.mongodb.org/manual/reference/configuration-options/

# start the server
$SSHCMD "service mongodb start"
