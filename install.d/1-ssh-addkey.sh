#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=ssh-init
config_default_install=no
config_copysshkeytoremote=yes
config_sshkeyfile="~/.ssh/id_rsa.pub"
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

    # check if ssh pub key exists
    sshkeyfile="${config_sshkeyfile/#\~/$HOME}"
    _d "[ssh key   = $sshkeyfile] "
    if [ ! -f "$sshkeyfile" ] ; then
        _error_exit "Missing local ssh key, [$sshkeyfile] not found > generate one with ssh-keygen."
    fi

    # copy local ssh key to grant access without password if not already copied
    sshkey=`cat $sshkeyfile`
    cat $sshkeyfile| _re "mkdir ~/.ssh 2> /dev/null; cat >> ~/.ssh/authorized_keys" "$sshkeyfile copied to ${hostname}" "copy of key $sshkeyfile failed"

# check connexion
_re_exit "uname -a" "SSH connexion configured for ${username}@${hostname}" "SSH connexion failed for ${username}@${hostname}"

# ssh-keygen -t rsa -b 4096 -C "emeric.mourot@terden.com" -f ~/.ssh/id_rsa -P ''