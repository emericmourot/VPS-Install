#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=ssh-init
config_default_install=yes
config_copysshkeytoremote=yes
config_sshkeyfile="~/.ssh/id_rsa.pub"
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

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
    #alreadycopied=$($SSHCMD "cat ~/.ssh/authorized_keys 2> /dev/null | grep -q '$sshkey'" && _log "$sshkeyfile already copied to ${hostname}")
    if [ "$config_copysshkeytoremote_done" != "yes" ] ; then # else skip
        cat $sshkeyfile| _re "mkdir ~/.ssh 2> /dev/null; cat >> ~/.ssh/authorized_keys" "$sshkeyfile copied to ${hostname}" "copy of key $sshkeyfile failed"
    fi
    #cat $SSHKEYFILE | $SSHCMD "mkdir ~/.ssh 2> /dev/null; cat >> ~/.ssh/authorized_keys"
    #_e "$sshkeyfile key file copied to destination ${hostname}"

fi

# check connexion
_re_exit "uname -a" "SSH connexion configured for ${username}@${hostname}" "SSH connexion failed for ${username}@${hostname}"

# says to var.cfg that the key has been copied
# TODO: check the actual ssh connection result, then copy, replace var.cfg by a variable
# new line first
if [ "$config_copysshkeytoremote_done" != "yes" ] ; then
    echo "" >> var.cfg
    echo "config_copysshkeytoremote_done=yes" >> var.cfg
fi