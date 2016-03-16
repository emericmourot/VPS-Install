#!/usr/bin/env bash
#################################################################
#                                                               #
#                           Init SSH                            #
#                                                               #
#################################################################

# First ssh connexion as root

# First ssh connexions require sshpass, install it on Mac OS X usgin homebrew
# From https://gist.github.com/arunoda/7790979
# Install howebrew
#ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
read -s -p "Enter root password: " rootpassword

SSHCMD="sshpass -p ${rootpassword} ssh -q -o StrictHostKeyChecking=no root@${hostname}"

# Try to Connect
_re_exit "uname -a" "SSH connexion ok for root" "SSH connexion failed for root"

# Change root password
# apg blocked on Ubuntu 15.10
#_re "apt-get install -y apg" "apg password generator installed" "apg password generator installation failed"
#rootpassword=$($SSHCMD "apg -a 1 -m 14 -x 14 -n 1 -q -M NCL")
_re "apt-get install -y pwgen" "pwgen password generator installed" "pwgen password generator installation failed"
rootpassword=$($SSHCMD "pwgen -c -B 16 1")
echo "new root password: $rootpassword"

# Added a new user (username)
#userpassword=$($SSHCMD "apg -a 1 -m 14 -x 14 -n 1 -q -M NCL")
userpassword=$($SSHCMD "pwgen -c -B 16 1")
echo "user password: $userpassword"
_re_exit "useradd --password ${userpassword} --home /home/${username} --create-home --gid users --groups users ${username}" "user [${username}] added" "failed to add user [${username}]"
_re "adduser ${username} sudo" "sudo power for ${username}" "failed to add ${username} to sudoers"

# Force ssh authentication with pub key if not
_re "sed 's/PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config > /etc/ssh/sshd_config" "SSH pub key auth allowed" "Failed to allow ssh pub key auth"

# Send key to host to allow ssh connexion without password
# copy public key to remote for current user
# check if ssh pub key exists
sshkeyfile="${config_sshkeyfile/#\~/$HOME}"
_d "[ssh key   = $sshkeyfile] "
if [ ! -f "$sshkeyfile" ] ; then
    _error_exit "Missing local ssh key, [$sshkeyfile] not found > generate one with ssh-keygen."
fi

# copy local ssh key to grant access without password if not already copied
sshkey=`cat $sshkeyfile`
_re "mkdir /home/${username}/.ssh 2> /dev/null; echo ${sshkey} >> /home/${username}/.ssh/authorized_keys" "$sshkeyfile copied to ${hostname} for ${username}" "copy of key $sshkeyfile failed for ${username}"

# Finally forbidden root login with ssh
#_re "sed 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config > /etc/ssh/sshd_config" "SSH root login forbidden" "Failed to forbid ssh root login"
# Changed ssh default port
# you should NEVER EVER use a non-privileged port for running your SSH server.
# https://www.adayinthelifeof.nl/2012/03/12/why-putting-ssh-on-another-port-than-22-is-bad-idea/
#_re "sed 's/Port 22/Port ${sshport}/g' /etc/ssh/sshd_config > /etc/ssh/sshd_config && service ssh restart" "SSH port changed to ${sshport}" "Failed to change ssh port to ${sshport}"

#### END OF SSH CONNEXION AS ROOT ####

# Now set ssh connexion with new user and new port
#SSHCMD="ssh ${username}@${hostname} -p ${sshport}"
SSHCMD="ssh ${username}@${hostname}"
_d "[ssh cmd   = $SSHCMD]"

# check connexion
_re_exit "uname -a" "SSH connexion configured for ${username}@${hostname}" "SSH connexion failed for ${username}@${hostname}"