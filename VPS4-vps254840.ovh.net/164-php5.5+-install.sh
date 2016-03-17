#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=php5.5+-install
config_default_install=no
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

#
# Install PHP > 5.5+
#

# check if php > 5.5 is already installed
php_version=`$SSHCMD "php -v|grep --only-matching --perl-regexp \"5\.\\d+\.\\d+\""`
_d "PHP version <${php_version}> detected"

if [ -z "$php_version" ] ; then

    _d "PHP 5 not detected"

    _eal "PHP version ${php_version} installed"
else
    _eal "PHP version ${php_version} already installed"
fi # php5 not already installed

