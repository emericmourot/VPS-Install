#!/usr/bin/env bash

# <START OF CONFIG>
config_app_name='ssh-init'
config_default_install='yes'
config_copysshkeytoremote='yes'
config_sshkeyfile="~/.ssh/id_rsa.pub"
# <END OF CONFIG>

# check if script is sourced or invoked from command line
if [[ "${BASH_SOURCE[0]}" != "${0}" ]] ; then
    _d "script ${BASH_SOURCE[0]} is being sourced ..."
else
    # parse args from command line
    while [ "$1" != "" ] ; do

    case "$1" in
        -h|-help)
	    echo "Usage: $program [options] hostname username"
        echo "  Options:"
        echo "      -h     : this help."
        echo ""
        exit 0
        ;;

        -d|-debug)
        debug=1;
        shift
        ;;

        *)
        if [ "$hostname" = "" ] ; then
            hostname="$1"
        elif [ "$username" = "" ] ; then
            username="$1"
        fi
        shift
        ;;
    esac
    done

    # load toolbox
    # import toolbox, then could use functions
    # first check if includes/toolbox.sh is present
    if [ ! -f "../includes/toolbox.sh" ] ; then
        echo "ERROR: failed to import includes/toolbox.sh, does ./includes exists?"
    else
        source '../includes/toolbox.sh'
    fi
fi

# set ssh command
SSHCMD="ssh ${username}@${hostname}"
_d "[ssh cmd   = $SSHCMD] "

# check connexion
_re_exit "$SSHCMD" "uname -a" "Ssh connexion configured for ${username}@${hostname}" "Ssh connexion failed for ${username}@${hostname}"

sshkeyfile="${config_sshkeyfile/#\~/$HOME}"
_d "[ssh key   = $sshkeyfile] "

if [ "$config_copysshkeytoremote" = "yes" ] ; then

    # check if ssh pub key exists
    if [ ! -f "$sshkeyfile" ] ; then
        _error_exit "Missing local ssh key, [$sshkeyfile] not found > generate one with ssh-keygen."
    fi

    # copy local ssh key to grant access without password if not already copied
    sshkey=`cat $sshkeyfile`
    $SSHCMD "cat ~/.ssh/authorized_keys 2> /dev/null | grep -q '$sshkey'" && _log "$sshkeyfile already copied to ${hostname}" ||
    cat $SSHKEYFILE | _re "mkdir ~/.ssh 2> /dev/null; cat >> ~/.ssh/authorized_keys" "$sshkeyfile copied to ${hostname}" "copy of key $sshkeyfile failed"

    _e "$sshkeyfile key file copied to destination ${hostname}"
fi