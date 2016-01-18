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
logfile="${program%.*}.log"
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dirname="${dir##*/}"

# constants
declare -r SEPARATOR="-----------------------------------------------------------------"
declare -r INCLUDESDIR="$dir/includes" #$([[ ! -d "${BASH_SOURCE%/*}" ]] && echo "$PWD" || echo "${BASH_SOURCE%/*}") # the dir where this script is running from
declare -r INSTALL_SCRIPTS_DIR="install.d"
declare -r INSTALL_CFG="install.cfg"

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

# log with timestamp
function _log {
    timestamp=`date +%d/%m/%Y-%H:%M:%S`
    echo [$timestamp] $1 >> ${logfile}
}

# echo and log: echo to std output and to log file
function _eal {
    _log "$1"
    echo "> $1"
}

# output debug to std if debug set, and log to file anyway
function _d {
    if [ $debug ] ; then
        echo "[debug] $1"
    fi
    _log "$1"
}

# check error: echo first string only if exit status is zero
# args: err message_ok message_error error
function _ce {
    #_d "previous cmd return with exit status $1"
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
# @args sshcmd remotecmd message_ok message_error
function _re {
    result=`$1 $2 2>&1`
    _ce `echo $?` "$3" "$4" "$result"
}

# _re and exit on error
# @args sshcmd remotecmd message_ok message_error
function _re_exit {
    result=`$1 $2 2>&1`
    errno=`echo $?`
    _ce $errno "$3" "$4" "$result"
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

# read propreties key=value
# @args file key
# @return an eval of keys, so $key contains the value
function _readprop() {
  file="$1"
  while IFS="=" read -r key value; do
    case "$key" in
      '#'*) ;;
      $2)
        eval "$key=\"$value\""
        ;;
      *)
        # eval all key value pairs
        #eval "$key=\"$value\""
    esac
  done < "$file"
}

# read config var from $ifile and copy to $ofile
# @args ifile ofile
# @return an eval of keys, so $key contains the value
function _copyconfig() {
  ifile="$1"
  ofile="$2"
  while IFS="=" read -r key value; do
    case "$key" in
      '#'*) ;;
      'config.'*)
        echo "$key=\"$value\"" >> $ofile
        ;;
      *)
        # eval all key value pairs
        #eval "$key=\"$value\""
    esac
  done < "$ifile"
}

# write config by reading default options in each install.d scripts
# copy scripts from install.d
# @args shortname hostname (directory to write the install.cfg file)
function _wconfig {

    if [ -z "$1" ] || [ -z "$2" ] ; then
        _error_exit "INTERNAL: hostname or shortname are not set in _wconfig"
    fi

    mdir="$dir/$1-$2"
    if [ -f "$mdir/$INSTALL_CFG" ] ; then
        _error_exit "$mdir already exists!"
    else
        mkdir $mdir 2>/dev/null
    fi

    if [ ! -w "$mdir" ] ; then
        _error_exit "Cannot write into $mdir"
    fi

    if [ -f "$mdir/$INSTALL_CFG" ] ; then
        _error_exit "$mdir/$INSTALL_CFG already exists, cannot overwrite!"
    fi

    for file in "$INCLUDESDIR/$INSTALL_SCRIPTS_DIR"/*.sh
    do
        _d "Processing $file"
        if [ -f "$file" ] ; then
            _readprop $file "config.app_name"
            _readprop $file "config.default_install"
            if [ -z "$config.app_name" ] || [ -z "$config.default_install" ] ; then
                _error_exit "config.app_name or config.default_install not declared in $file"
            fi
            echo "$config.app_name=[" >> "$mdir/$INSTALL_CFG"
            _copyconfig $file $mdir/$INSTALL_CFG
            echo "]" >> "$mdir/$INSTALL_CFG"
        fi
    done

    logfile="$mdir/actions.log"
    echo "#!/usr/bin/env bash" > "$mdir/install.sh"
    echo '' >> "$mdir/install.sh"
    echo "logfile='$mdir/actions.log'" >> "$mdir/install.sh"
    cat "_install.sh" >> "$mdir/install.sh"

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