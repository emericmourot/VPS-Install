#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name=users-config
config_default_install=yes
config_sshkeyfile="~/.ssh/id_rsa.pub"
# <END OF CONFIG>

# required after <START OF CONFIG>/<END OF CONFIG> bloc
source "var.cfg" 2>&1 /dev/null

#
# Create users
#
# installation of apg password generator
# install dialog
_re "apt-get install -y apg" "apg password generator installed" "apg password generator installation failed"
password=`$SSHCMD "apg -a 1 -m 14 -x 14 -n 1 -q"`
echo "password: $password"
#$SSHCMD "user=emo;passwd=`apg -a 1 -m 14 -x 14 -n 1 -q`; useradd --create-home --password $passwd --shell /bin/bash --gid users --no-user-group ${user}; echo "$user : $passwd""
user=emeric
_re "useradd --password ${password} --home /home/${user} --create-home --gid users --groups users ${user}" "user [${user}] added" "failed to add user [${user}]"
_re "adduser ${user} sudo" "sudo power for ${user}" "failed to add ${user} to sudoers"


    # check if ssh pub key exists
    sshkeyfile="${config_sshkeyfile/#\~/$HOME}"
    _d "[ssh key   = $sshkeyfile] "
    if [ ! -f "$sshkeyfile" ] ; then
        _error_exit "Missing local ssh key, [$sshkeyfile] not found > generate one with ssh-keygen."
    fi

    # copy local ssh key to grant access without password if not already copied
    sshkey=`cat $sshkeyfile`
        cat $sshkeyfile| _re "mkdir /home/${user}/.ssh 2> /dev/null; cat >> /home/${user}/.ssh/authorized_keys" "$sshkeyfile copied to ${hostname}" "copy of key $sshkeyfile failed"
    fi

