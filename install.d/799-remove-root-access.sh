#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=remove-root-acess
config_default_install=yes
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# Change root password
_re "apt-get install -y pwgen" "pwgen password generator installed" "pwgen password generator installation failed"
rootpassword=$($SSHCMD "pwgen -c -B 16 1")
_d "new root password: $rootpassword"

# Finally forbidden root login with ssh
#_re "sed 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config > /etc/ssh/sshd_config" "SSH root login forbidden" "Failed to forbid ssh root login"
# Changed ssh default port
# you should NEVER EVER use a non-privileged port for running your SSH server.
# https://www.adayinthelifeof.nl/2012/03/12/why-putting-ssh-on-another-port-than-22-is-bad-idea/
#_re "sed 's/Port 22/Port ${sshport}/g' /etc/ssh/sshd_config > /etc/ssh/sshd_config && service ssh restart" "SSH port changed to ${sshport}" "Failed to change ssh port to ${sshport}"

#### END OF SSH CONNEXION AS ROOT ####

# Now set ssh connexion with new user and new port
#SSHCMD="ssh ${username}@${hostname} -p ${sshport}"
#SSHCMD="ssh ${username}@${hostname}"
#_d "[ssh cmd   = $SSHCMD]"

_eal "*****************************************************************************************************"
_eal ""
_eal "   Root password SHOULD be changed with this new password: $rootpassword"
_eal ""
_eal "*****************************************************************************************************"