#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=firewall-config
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# install dialog
_re "apt-get install -y monit" "monit installed" "monit installation failed"

# iptables -I INPUT -p tcp --dport 1022 -j ACCEPT

# List The Open Ports And The Process That Owns Them
#sudo lsof -i
#sudo netstat -lptu
#sudo netstat -tulpn

# https://www.howtoforge.com/tutorial/how-to-scan-linux-for-malware-and-rootkits/
# apt-get install chkrootkit
# https://cisofy.com/lynis/
# https://github.com/CISOfy/lynis
