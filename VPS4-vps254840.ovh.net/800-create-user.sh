#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=create-user
config_default_install=yes
config_sshkeyfile="~/.ssh/id_rsa.pub"
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# Add a new user (username)
userpassword=$($SSHCMD "pwgen -c -B 16 1")
_d "user password: $userpassword"
_re_exit "useradd --password ${userpassword} --home /home/${username} --create-home --gid users --groups users ${username}" "user [${username}] added" "failed to add user [${username}]"
_re "adduser ${username} sudo" "sudo power for ${username}" "failed to add ${username} to sudoers"

# copy local ssh key to grant access without password if not already copied
sshkeyfile="${config_sshkeyfile/#\~/$HOME}"
_d "[ssh key   = $sshkeyfile] "
if [ ! -f "$sshkeyfile" ] ; then
    _error_exit "Missing local ssh key, [$sshkeyfile] not found > generate one with ssh-keygen."
fi
sshkey=`cat $sshkeyfile`
_re "mkdir -p /home/${username}/.ssh 2> /dev/null; echo ${sshkey} >> /home/${username}/.ssh/authorized_keys;" "$sshkeyfile copied to ${hostname} for ${username}" "copy of key $sshkeyfile failed for ${username}"
_re "chmod 700 /home/${username}/.ssh ; chmod 600 /home/${username}/.ssh/authorized_keys; chown -R ${username}: /home/${username}" "permission set to /home/${username}/.ssh/authorized_keys" "failed to set permission to /home/${username}/.ssh/authorized_keys"

# Now set ssh connexion with new user
SSHCMD="ssh ${username}@${hostname}"
_d "[ssh cmd   = $SSHCMD]"

# check connexion
_re_exit "uname -a" "SSH connexion configured for ${username}@${hostname}" "SSH connexion failed for ${username}@${hostname}"

# Re-Switch to root for the installation process
SSHCMD="ssh root@${hostname}"
_d "[ssh cmd   = $SSHCMD]"

# check connexion
_re_exit "uname -a" "SSH connexion configured for root@${hostname}" "SSH connexion failed for root@${hostname}"

_eal "*****************************************************************************************************"
_eal ""
_eal "   A user [$username] (sudoer) has been added with password: $userpassword"
_eal ""
_eal "*****************************************************************************************************"