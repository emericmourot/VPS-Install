#!/usr/bin/env bash
#################################################################
#                                                               #
#                       Init VPS SSH                            #
#                                                               #
# Usage: vps-init [options] shortname hostname username         #
#   Options:                                                    #
#      -d      : debug mode on                                  #
#      -h      : this help                                      #
#      -p      : set ssh port (default 22) for creating access  #
#      -nojava : do not install java                            #
#      -debian : default is ubuntu                              #
#                                                               #
#################################################################

# boostrap by importing toolbox, then could use functions
# first check if includes/toolbox.sh is present
if [ ! -f "includes/toolbox.sh" ] ; then
        echo "ERROR: failed to import includes/toolbox.sh, does ./includes exists?"
    else
        logfile="${program%.*}.log"
        source 'includes/toolbox.sh'
fi

# resolve dir and dirname for current init-vps.sh directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dirname="${dir##*/}"
declare -r INCLUDESDIR="$dir/includes"
declare -r USRMINEDIR="$dir/usr-mine-bin"
declare -r INSTALL_SCRIPTS_DIR="$dir/install.d"
hostdir=''
install_cfg=''
config_sshkeyfile="~/.ssh/id_rsa.pub"

# parse args from command line
while [ "$1" != "" ] ; do

    case "$1" in
        -h|-help)
	        #echo "Usage: $program [options] shortname hostname username sshport"
            echo "Usage: $program [options] shortname hostname username"
            echo "  Options:"
            echo "      -d     : debug mode on."
            echo "      -h     : this help."
            echo ""
            exit 0
            ;;

        -d|-debug)
            debug=1;
            shift
            ;;
        *)
            if [ "$shortname" = "" ] ; then
                shortname="$1"
            elif [ "$hostname" = "" ] ; then
               hostname="$1"
            elif [ "$username" = "" ] ; then
                username="$1"
            #elif [ "$sshport" = "" ] ; then
            #    sshport="$1"
            else
                # drop
                extra="$extra $1";
            fi
        shift
        ;;
    esac

done

#if [ "$shortname" = "" ]  || [ "$hostname" = "" ]  || [ "$username" = "" ] || [ "$sshport" = "" ]; then
if [ "$shortname" = "" ]  || [ "$hostname" = "" ]  || [ "$username" = "" ] ; then
    _error_exit "Missing arguments, can't do anything. Use $program -help for more info."
fi

# debug parameters
_d "[hotsname     = $hostname]"
_d "[username     = $username]"
#_d "[sshport      = $sshport]"
_d "[dir          = $dir]"
_d "[dirname      = $dirname]"
_d "[log file     = $logfile] "
_d "[includes dir = $INCLUDESDIR] "
_d "[scripts dir  = $INSTALL_SCRIPTS_DIR] "


# write config by reading default options in each install.d scripts
# copy scripts from install.d
function _wconfig {

    # check if required args are passed
    if [ -z "$shortname" ] || [ -z "$hostname" ] ; then
        _error_exit "INTERNAL: hostname or shortname are not set in _wconfig"
    fi

    # Create new user, change ssh port, end root ssh connexion
    # exit if connexion cannot be done
    source includes/init-ssh.sh

    #### END OF SSH CONNEXION AS ROOT ####

    # create a new dir for this hostname
    hostdir="$dir/$shortname-$hostname"
    install_cfg="$hostdir/$shortname.cfg"
    var_cfg="$hostdir/var.cfg"

    if [ -f "$install_cfg" ] ; then
        _error_exit "$hostdir already exists!"
    else
        mkdir $hostdir 2>/dev/null
    fi

    if [ ! -w "$hostdir" ] ; then
        _error_exit "Cannot write into $hostdir"
    fi

    if [ -f "$install_cfg" ] ; then
        _error_exit "$install_cfg already exists, cannot overwrite!"
    fi

    # write shebang
    echo "#!/usr/bin/env bash" >> "$var_cfg"

    # new line
    echo "" >> "$var_cfg"

    echo "SSHCMD=\"$SSHCMD\"" >> "$var_cfg"

    # new line
    echo "" >> "$var_cfg"

    echo "# hostname details" >> "$var_cfg"
    # write info about the host
    ip=$(dig $hostname +short)
    #mem=$($SSHCMD "awk '/^MemTotal:/{print $2}' /proc/meminfo")
    #distinfo=$($SSHCMD "uname -a")
    #echo "memory=$mem" >> "$var_cfg"
    #echo "dist=$distinfo" >> "$var_cfg"

    echo "# hostname: $hostname" >> "$var_cfg"
    echo "#       ip: $ip" >> "$var_cfg"
    # new line
    echo "" >> "$var_cfg"
    echo "hostname=$hostname" >> "$var_cfg"
    echo "ip=$ip" >> "$var_cfg"
    echo "shortname=$shortname" >> "$var_cfg"
    echo "username=$username" >> "$var_cfg"

    # keep logged data and moved to the fresly created dir
    mv "$dir/$logfile" "$hostdir/actions.log"
    logfile="$hostdir/actions.log"
    echo "logfile='actions.log'" >> "$var_cfg"

    # create install.sh to the remote dir
    cat "$INCLUDESDIR/_install.sh" >> "$hostdir/install.sh"
    echo '' >> "$hostdir/install.sh"

    # get all files in install.d dir and gather config for each
    for file in "$INSTALL_SCRIPTS_DIR"/*.sh
    do
        _d "Processing $file"
        if [ -f "$file" ] ; then

           app_name=$(_readconfig $file "config_app_name")
           default_install=$(_readconfig $file "config_default_install")

            if [ -z "$app_name" ] || [ -z "$default_install" ] ; then
                _error_exit "config_app_name or config_default_install not declared in $file"
            fi

            echo "#-------------------------------------------------------------------------" >> "$install_cfg"
            echo "# $app_name" >> "$install_cfg"
            echo "#-------------------------------------------------------------------------" >> "$install_cfg"
            echo "$SOC - $app_name" >> "$install_cfg"
            _copyconfig $file $install_cfg
            echo "$EOC - $app_name" >> "$install_cfg"
            echo "" >> "$install_cfg"

            # copy all scripts into this new dir
            cp $file $hostdir
            chmod u+x ${file}
            echo "${file}" >> "$hostdir/install.sh"
        fi
    done

    # copy useful scripts toolbox
    cp $INCLUDESDIR/toolbox.sh $hostdir
    cp $INCLUDESDIR/ssh-connect.sh $hostdir
    chmod u+x $hostdir/*.sh
    mkdir $hostdir/tools
    cp $USRMINEDIR/search $hostdir/tools

    # add useful functions
    cat "$INCLUDESDIR/_var.cfg.sh" >> "$var_cfg"

}

# create dedicated directory, copy and generate stuff
_wconfig

_eal "*****************************************************************************************************"
_eal " Initialisation of VPS [$shortname] for host [$hostname] is completed"
_eal ""
_eal "   1. A new folder $hostdir has been created with default config"
_eal "   2. Edit or replace the config file $install_cfg"
_eal "      vi $install_cfg"
_eal "   3. Go to folder $hostdir"
_eal "      cd $hostdir"
_eal "   4. Run install"
_eal "      ./install.sh"
_eal "   5. Read log from $logfile"
_eal "      less $logfile"
_eal "   6. Start a ssh connexion with $hostname simply"
_eal "      ./ssh-connect.sh"
_eal ""
_eal "   Root password changed, please keep this new one in safe place: $rootpassword"
_eal "   A user [$username] (sudoer) has been added with password: $userpassword"
_eal ""
_eal "*****************************************************************************************************"