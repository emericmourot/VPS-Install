#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=nginx-install
config_default_install=yes
config_target=stage
config_nginx_root=/var/www/lespetitsentrepreneurs.com/stage
config_nginx_server_name=stage.lespetitsentrepreneurs.com
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

tmpfile=/tmp/fs$$
content=`cat 120-nginx-install/nginx.conf`
sed -i 's/TOKChV4-Server-Name/${config_nginx_server_name}/g' 120-nginx-install/nginx.conf > ${tmpfile}
sed -i 's/TOKChV4-Root/${config_nginx_root}/g' ${tmpfile} > ${tmpfile}

_copy "${tmpfile}" "/etc/nginx/sites-available/${config_nginx_server_name}"
_re "ln -s /etc/nginx/sites-available/${config_nginx_server_name} /etc/nginx/sites-enabled/" "Nginx config deployed" "Nginx config deployement failure"
rm -f ${tmpfile}
$SSHCMD “service nginx restart"