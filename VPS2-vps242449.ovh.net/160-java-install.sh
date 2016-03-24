#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=java-install
config_default_install=no
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

#
# JAVA
#
# instalation de java 8 + configuration


# check if java is already installed
java_version=`$SSHCMD "java -version 2> /dev/null | grep version | awk '{print $3}' | sed 's/\"//g'"`
#_d "Java version <${java_version}> detected"

if [ -z "$java_version" ] ; then

    _d "Java not detected"

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
    java_version=`$SSHCMD "java -version 2> /dev/null | grep version | awk '{print $3}' | sed 's/\"//g'"`

    _eal "Java version ${java_version} installed"
else
    _eal "Java version ${java_version} already installed"
fi # java not already installed

