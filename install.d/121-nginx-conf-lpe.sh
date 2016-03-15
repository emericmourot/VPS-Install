#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=nginx-install
config_default_install=no
config_target=stage
config_root=/var/www/lespetitsentrepreneurs.com/stage
config_server_name=stage.lespetitsentrepreneurs.com
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

tmpfile=/tmp/fs$$
content=`cat 120-nginx-install/nginx.conf`
sed -i 's/&!&server_name&!&/${config_server_name}/g' 120-nginx-install/nginx.conf > ${tmpfile}
sed -i 's/&!&root&!&/${config_root}/g' ${tmpfile} > ${tmpfile}

_copy "${tmpfile}" "/etc/nginx/site-available/${config_server_name}"

rm -f ${tmpfile}



