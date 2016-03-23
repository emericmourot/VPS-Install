#!/usr/bin/env bash
#################################################################
#                                                               #
#                           Init SSH                            #
#                                                               #
#################################################################

rm -f ~/.ssh/known_hosts 2>&1 > /dev/null

# First ssh connexion as root
#SSHCMD="ssh -o StrictHostKeyChecking=no root@${hostname}"
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