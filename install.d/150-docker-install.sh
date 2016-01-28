#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=docker-install
config_default_install=no
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

#
# DOCKER
#
# last version installation

# check if docker is already installed
docker_version=`$SSHCMD "docker --version 2>&1 | head -n 1 | awk  '{print $3}'"`
# remove trailing ,
docker_version=${docker_version%,*}

if [ -z "$docker_version" ] ; then
    # install from wget (@see https://github.com/discourse/discourse/blob/master/docs/INSTALL-cloud.md)
    _re "wget -qO- https://get.docker.com/ | sh" "docker installed" "docker installation failed"
else
    _e "Docker version ${docker_version} already installed"
fi # docker not already installed