#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=nginx-install
config_default_install=yes
config_nginx_domain_name=lespetitsentrepreneurs.com
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

config_nginx_root=/var/www/${config_nginx_domain_name}/${target}

if [ "${target}" == "production" ]; then
    config_nginx_server_name=${config_nginx_domain_name}
else
    config_nginx_server_name=${target}.${config_nginx_domain_name}
fi

function _escape {
    echo "$1" | sed -e 's/[\/&]/\\&/g'
}

tmpfile=/tmp/fs$$
#content=`cat 120-nginx-install/nginx.conf`
full_server_name=$(_escape "${config_nginx_server_name}" )
if [ "${target}" == "production" ]; then
    full_server_name=$(_escape "${config_nginx_domain_name} www.${config_nginx_domain_name}")
fi

server_name=$(_escape "${config_nginx_server_name}")
root=$(_escape "${config_nginx_root}")

sed -e "s/TOKChV4-Full-Server-Name/${full_server_name}/g" -e "s/TOKChV4-Server-Name/${serveur_name}/g" -e "s/TOKChV4-Root/${root}/g" 121-nginx-conf-lpe/nginx.conf > ${tmpfile}

_copy2root "${tmpfile}" "/etc/nginx/sites-available/${config_nginx_server_name}"
_re "ln -s /etc/nginx/sites-available/${config_nginx_server_name} /etc/nginx/sites-enabled/" "Nginx config deployed" "Nginx config deployement failure"
rm -f ${tmpfile}

_re "mkdir -p ${config_nginx_root}" "${config_nginx_root} created" "${config_nginx_root} creation failed"

$SSHCMD "service nginx restart"