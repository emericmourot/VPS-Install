#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=firewall-config
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands
# http://www.alsacreations.com/tuto/lire/622-Securite-firewall-iptables.html
# http://www.thegeekstuff.com/2011/06/iptables-rules-examples/

# get the rules from https://gist.github.com/thomasfr/9712418


# install
#_re "apt-get install -y iptables-persistent" "iptables-persistent installed" "iptables-persistent installation failed"

_copy "200-firewall-config/firewall" "/etc/init.d/firewall"
$SSHCMD "chmod +x /etc/init.d/firewall"

# Activate rules
$SSHCMD "/etc/init.d/firewall"

# When rules are ok, uncomment the following line, remove it with update-rc.d -f firewall remove
#$SSHCMD "update-rc.d firewall defaults"

#_re "invoke-rc.d iptables-persistent save" "iptables rules saved" "iptables rules save FAILED"

# List The Open Ports And The Process That Owns Them
#sudo lsof -i
#sudo netstat -lptu
#sudo netstat -tulpn

# https://www.howtoforge.com/tutorial/how-to-scan-linux-for-malware-and-rootkits/
# apt-get install chkrootkit
# https://cisofy.com/lynis/
# https://github.com/CISOfy/lynis
