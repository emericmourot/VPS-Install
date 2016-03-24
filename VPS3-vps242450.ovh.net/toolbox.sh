#!/usr/bin/env bash

# from Writing Robust Bash Shell Scripts
# http://www.davidpashley.com/articles/writing-robust-shell-scripts/
# exit if you try to use an uninitialised variable
# set -u
# This tells bash that it should exit the script if any statement returns a non-true return value
set -e

# variables
declare -i True=1
declare -i False=0
declare -i debug=0
program="${0##*/}"

# constants
declare -r SEPARATOR="-----------------------------------------------------------------"
declare -r SOC="# <START OF CONFIG>"
declare -r EOC="# <END OF CONFIG>"

# log with timestamp
function _log {
    timestamp=`date +%d/%m/%Y-%H:%M:%S`
    echo [$timestamp] $1 >> ${logfile}
}

# output debug to std if debug set, and log to file anyway
function _d {
    if [ $debug ] ; then
        echo "[debug] $1"
    fi
    _log "$1"
}

# echo: echo a pretty message and log
function _e {
    echo $SEPARATOR
    _eal "$1"
}

# output error to std output and exit
function _error {
    echo;echo  "<<<<<<<<<<"
    echo "ERROR: $1"
    echo ">>>>>>>>>>>";echo
    _log ">>>> ERROR: $1"
}

function _error_exit {
    _error "$1"
    exit 0
}

# echo and log: echo to std output and to log file
function _eal {
    _log "$1"
    echo "> $1"
}

# check error: echo first string only if exit status is zero
# args: err message_ok message_error error
function _ce {
    #_d "previous cmd returns with exit status $1"
    if [ "$1" -ne "0" ] ; then
        if [ -n "$4" ] ; then # if there a non empty third args (string)
            _error "ERROR: check process [$2] with error $4"
        else
            _error "ERROR: check process [$2]"
        fi
    else
        _e "$2 -> $4"
    fi
}

# remote execute and catch error if any
# @args remotecmd message_ok message_error
function _re {
    if [ -z "$SSHCMD" ] ; then
        _error_exit "SSHCMD not set"
    fi
    _d "remote exec: [$SSHCMD $1 2>&1]"
    result=$($SSHCMD "$1" 2>&1)
    _ce `echo $?` "$2" "$3" "$result"
}

# remote execute and catch error if any
# @args remotecmd app_name
function _re_app_ins {
    if [ -z "$SSHCMD" ] ; then
        _error_exit "SSHCMD not set"
    fi
    _d "remote exec: [$SSHCMD $1 2>&1]"
    result=$($SSHCMD "$1" 2>&1)
    _ce `echo $?` "$2 installed" "failed to install $2" "$result"
}

# _re and exit on error
# @args remotecmd message_ok message_error
function _re_exit {
    if [ -z "$SSHCMD" ] ; then
        _error_exit "SSHCMD not set"
    fi
    _d "remote exec & exit: [$SSHCMD $1 3>&1 2>&1]"
    result=$($SSHCMD "$1" 3>&1 2>&1)
    errno=`echo $?`
    _ce $errno "$2" "$3" "$result"
    if [ "$errno" -ne "0" ] ; then
        exit 0
    fi
}

# import other scripts, should declare path relative to script that called toolbox.sh
function _import_exec {
    if [ ! -f "$1" ] ; then
        _error_exit "failed to import ${1}"
    else
        source "${1}"
        _d "${1} imported"
    fi
}

# set log file name
# @args shortname hostname
function _setlog {
    logfile="$1-$2/vps-init.log"
}

# read propreties key=value between tokens
# @args file key
# return to stdout the value found for key
function _readconfig() {
  file="$1"
  # keep only variables between the two tokens « start of config » and « end of config »
  awk "/$SOC/{flag=1;next}/$EOC/{flag=0}flag" "$file" | while IFS="=" read -r key value; do
    case "$key" in
      '#'*) ;;
      $2)
        echo $value
        ;;
      *)
        #_d "_reaconfig $key=\"$value\""
    esac
  done
}

# read config var from $ifile and copy to $ofile
# @args ifile ofile
# @return an eval of keys, so $key contains the value
function _copyconfig() {
  ifile="$1"
  ofile="$2"
  # keep only variables between the two tokens « start of config » and « end of config »
  awk "/$SOC/{flag=1;next}/$EOC/{flag=0}flag" "$ifile" | while IFS="=" read -r key value; do
    case "$key" in
      '#'*) ;;
      'config_app_name'*)
        echo "config_script=${ifile##*/}" >> $ofile
        ;;
      'config_'*)
        echo "$key=\"$value\"" >> $ofile
        ;;
      *)
        # eval all key value pairs
        #eval "$key=\"$value\""
    esac
  done
}

# return the absolute path for any relative path
# if need to transform dir="~/somedir" to absulute path, use ${dir/#\~/$HOME}
# @args rpath
function _abspath(){
  local thePath
  if [[ ! "$1" =~ ^/ ]];then
    thePath="$PWD/$1"
  else
    thePath="$1"
  fi
  echo "$thePath"|(
  IFS=/
  read -a parr
  declare -a outp
  for i in "${parr[@]}";do
    case "$i" in
    ''|.) continue ;;
    ..)
      len=${#outp[@]}
      if ((len==0));then
        continue
      else
        unset outp[$((len-1))]
      fi
      ;;
    *)
      len=${#outp[@]}
      outp[$len]="$i"
      ;;
    esac
  done
  echo /"${outp[*]}"
)
}

function _replaceconfig() {
  echo ""
}