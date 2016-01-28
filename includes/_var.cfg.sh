#!/usr/bin/env bash

# import toolbox, then could use functions
# first check if toolbox.sh is present
if [ ! -f "toolbox.sh" ] ; then
    echo "ERROR: failed to import toolbox.sh"
else
    source 'toolbox.sh'
fi

function should_install() {
    if [ "$config_default_install" != "yes" ] ; then
        _eal "WARNING: $config_app_name was not installed, config_default_install is set to $config_default_install"
        exit 0
    fi
}

function check_parameters() {

    # check if script is sourced or invoked from command line
    if [[ "${BASH_SOURCE[0]}" != "${0}" ]] ; then
        _d "script ${BASH_SOURCE[0]} is being sourced ..."
    else
        # parse args from command line
        while [ "$1" != "" ] ; do

        case "$1" in
            -h|-help)
	        echo "Usage: $program [options]"
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
#            if [ "$hostname" = "" ] ; then
#                hostname="$1"
#            elif [ "$username" = "" ] ; then
#                username="$1"
#            fi
            shift
            ;;
        esac
        done
    fi
}

# launch everytime
should_install
check_parameters
_eal "Lauching script $config_app_name"