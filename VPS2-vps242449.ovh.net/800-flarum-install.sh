#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=flarum-install
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install flarum sources
$SSHCMD "apt-get install -y php5-cli php5-curl"
$SSHCMD "mkdir -p /var/www/non-secure/flarum"
_re_app_ins "cd /var/www/non-secure/ ; curl -sS https://getcomposer.org/installer | php" "composer"
_re_app_ins "cd /var/www/non-secure/flarum ; ../composer.phar config --global github-oauth.github.com 96d709a7f82aa66d174bab6899621ba33c6d6f41" "GitHub Token"
_re_app_ins "cd /var/www/non-secure/flarum ; ../composer.phar create-project flarum/flarum . --stability=beta" "flarum"

# config nginx
_copy "${0%.*}/nginx.conf" "/etc/nginx/sites-available/forum-flarum.lespetitsentrepreneurs.com"
$SSHCMD "chown -R www-data:www-data /var/www/non-secure/"
$SSHCMD "chmod 755 /var/www/non-secure/"
$SSHCMD "ln -s /etc/nginx/sites-available/forum-flarum.lespetitsentrepreneurs.com /etc/nginx/sites-enabled/"
$SSHCMD "service nginx restart"
