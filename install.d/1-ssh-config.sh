#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=ssh-init
config_default_install=yes
config_copysshkeytoremote=yes
config_sshkeyfile="~/.ssh/id_rsa.pub"
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

# check connexion
_re_exit "$SSHCMD" "uname -a" "Ssh connexion configured for ${username}@${hostname}" "Ssh connexion failed for ${username}@${hostname}"

# copy public key to remote for current user
if [ "$config_copysshkeytoremote" = "yes" ] ; then

    # check if ssh pub key exists
    sshkeyfile="${config_sshkeyfile/#\~/$HOME}"
    _d "[ssh key   = $sshkeyfile] "
    if [ ! -f "$sshkeyfile" ] ; then
        _error_exit "Missing local ssh key, [$sshkeyfile] not found > generate one with ssh-keygen."
    fi

    # copy local ssh key to grant access without password if not already copied
    sshkey=`cat $sshkeyfile`
    $SSHCMD "cat ~/.ssh/authorized_keys 2> /dev/null | grep -q '$sshkey'" && _log "$sshkeyfile already copied to ${hostname}" ||
    cat $SSHKEYFILE | _re "mkdir ~/.ssh 2> /dev/null; cat >> ~/.ssh/authorized_keys" "$sshkeyfile copied to ${hostname}" "copy of key $sshkeyfile failed"

    _e "$sshkeyfile key file copied to destination ${hostname}"

fi