#!/usr/bin/env bash
#################################################################
#                                                               #
#                           Init SSH                            #
#                                                               #
#################################################################

# First ssh connexion as root
SSHCMD="ssh root@${hostname}"
_d "[ssh cmd   = $SSHCMD]"

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
_re "mkdir /root/.ssh 2> /dev/null; echo ${sshkey} >> /root/.ssh/authorized_keys" "$sshkeyfile copied to ${hostname} for root" "copy of key $sshkeyfile failed for root"

# Force ssh authentication with pub key if not
#_re "sed 's/PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config > /etc/ssh/sshd_config" "SSH pub key auth allowed" "Failed to allow ssh pub key auth"

# check connexion
_re_exit "uname -a" "SSH connexion configured for root@${hostname}" "SSH connexion failed for root@${hostname}"

# Change root password
_re "apt-get install -y pwgen" "pwgen password generator installed" "pwgen password generator installation failed"
rootpassword=$($SSHCMD "pwgen -c -B 16 1")
_d "new root password: $rootpassword"

# Add a new user (username)
userpassword=$($SSHCMD "pwgen -c -B 16 1")
_d "user password: $userpassword"
_re_exit "useradd --password ${userpassword} --home /home/${username} --create-home --gid users --groups users ${username}" "user [${username}] added" "failed to add user [${username}]"
_re "adduser ${username} sudo" "sudo power for ${username}" "failed to add ${username} to sudoers"

# copy local ssh key to grant access without password if not already copied
sshkey=`cat $sshkeyfile`
_re "mkdir -p /home/${username}/.ssh 2> /dev/null; echo ${sshkey} >> /home/${username}/.ssh/authorized_keys; chmod 700 /home/${username}/.ssh ; chmod 600 /home/${username}/.ssh/authorized_keys; chown -R ${username}: /home/${username}" "$sshkeyfile copied to ${hostname} for ${username}" "copy of key $sshkeyfile failed for ${username}"

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