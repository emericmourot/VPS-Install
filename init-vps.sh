#!/usr/bin/env bash
################################################################
#                                                              #
#                       Init VPS SSH                           #
#                                                              #
# Usage: vps-init [options] shortname hostname username        #
#   Options:                                                   #
#      -d      : debug mode on                                 #
#      -h      : this help                                     #
#      -p      : set ssh port (default 22) for creating access #
#      -nojava : do not install java                           #
#      -debian : default is ubuntu                             #
#                                                              #
################################################################

# set -x

# import toolbox, then could use functions
# first check if includes/toolbox.sh is present
if [ ! -f "includes/toolbox.sh" ] ; then
        echo "ERROR: failed to import includes/toolbox.sh, does ./includes exists?"
    else
        source 'includes/toolbox.sh'
fi

# parse args from command line
while [ "$1" != "" ] ; do

case "$1" in
  -h|-help)
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
        else
            # drop
            extra="$extra $1";
        fi
        shift
        ;;
esac
done

if [ "$shortname" = "" ]  || [ "$hostname" = "" ]  || [ "$username" = "" ] ; then
  _error_exit "Missing arguments, can't do anything. Use $program -help for more info."
fi

# make imports
_import_exec 'includes/default.cfg' # from includes/

# debug parameters
_d "[hotsname  = $hostname] "
_d "[username  = $username] "
_d "[path      = $the_path] "
_d "[dirname   = $dirname] "

# SSH init
_import_exec 'install.d/ssh-init.sh'

# create dedicated directory, copy and generate stuff
_wconfig $hostname $shortname











