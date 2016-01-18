#!/usr/bin/env bash

# <START OF CONFIG>
config.app_name=java
config.default_install=yes
# <END OF CONFIG>

source "ssh-access.sh"

#
# JAVA
#
# instalation de java 8 + configuration


# check if java is already installed
java_version=`$SSHCMD "java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}'"`
if [ -z "$java_version" ] ; then

# install dialog
_re "apt-get install -y dialog" "dialog installed" "dialog installation failed"
# install software-properties-common
_re "apt-get install -y software-properties-common" "software-properties-common installed" "software-properties-common installation failed"
#
$SSHCMD "echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections"
$SSHCMD "echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections"
$SSHCMD "apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886"
if [ "$debian" = "True" ] ; then
    _re "add-apt-repository -y ppa:webupd8team/java && apt-get update" "java repository added to apt-get" "failed to add java repository to apt-get"
else
    _re "add-apt-repository -y ppa:webupd8team/java && apt-get update" "java repository added to apt-get" "failed to add java repository to apt-get"
fi
_re "apt-get install -y oracle-java8-installer oracle-java8-set-default" "java8 installed" "failed to install java8"
# configure JAVA_HOME
_re "echo JAVA_HOME=/usr/lib/jvm/java-8-oracle >> /etc/environment" "JAVA_HOME configured" "failed to configure JAVA_HOME"
java_version=`$SSHCMD "java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}'"`

    _e "Java version ${java_version} installed"
else
    _e "Java version ${java_version} already installed"
fi # java not already installed
