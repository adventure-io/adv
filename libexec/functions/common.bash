##
# Common Functions
#

# fail
#
# Functiont that returns a bad status by default
#
fail(){
  if [[ ! -z $@ ]]
  then
    echo "$@"
  fi

  return 42
}

# load_functions
#
# Load function files for each argument passed
#
load_functions(){
  for fn
  do
    load_function $fn
  done
}

# load_function
#
# Load function file from $_ADV_ROOT/libexec/functions
#
load_function(){
  source "$_ADV_ROOT/libexec/functions/$1.bash"
}

# load_user_data
#
# Loads user data from rc files in known locations
#
load_user_data(){
  user_data_paths
  for path in ${adv_user_data_paths[@]}
  do
    load_user_data_from $path
  done
}

# load_user_data
#
# If file exists, source it
#
load_user_data_from(){
  local path="$1"
  if [[ -s "$path" ]]
  then
    source "$path"
  fi
}

# cache_run
#
# Cache the original script and arguments
#
# @exports
#   original_script
#   The expanded file path of the original script that was called
#
# @exports
#   original_args
#   The original command line arguments passed to the script
#
cache_run(){
  original_script=$1
  shift
  original_args=$@
}

# prepare_arguments
#
# Look for and remove debug flag in script args
#
# @exports
#   script_args
#   The usable command line arguments passed to the script
#
# @exports
#   adv_debug_flag
#   Equals one if --debug was passed on the command line
#
# @exports
#   adv_trace_flag
#   Equals one if --trace was passed on the command line
#
prepare_arguments(){
  script_args=("")

  true ${adv_trace_flag:=0} ${adv_debug_flag:=0}

  for arg
  do
    case $arg in
      --debug)
        adv_debug_flag=1
        start_debug
        ;;
      --trace)
        adv_trace_flag=1
        start_trace
        ;;
      *)
        script_args=("${script_args[@]}" "$arg")
        ;;
    esac
  done
}

# start_debug
#
# If the debug flag is set, set appropriate bash script options
#
start_debug(){
  if [[ $adv_debug_flag == 1 ]]
  then
    set -o nounset
    shopt -s extdebug
  fi
}

# start_trace
#
# If the trace flag is set, set appropriate bash script options
#
start_trace(){
  if [[ $adv_trace_flag == 1 ]]
  then
    set -o xtrace
    set -o errtrace
    set -o functrace
  fi
}

# rerun
#
# Exec into the current script again with the same arguments
#
rerun(){
  exec "$original_script" "$original_args"
}

# user_data_paths
#
# Set array of paths to look for user data in
#
# @exports
#   adv_user_data_paths
#   array of paths
#
user_data_paths(){
  adv_user_data_paths=("/etc/advrc" "$HOME/.advrc" "$PWD/.advrc")
  true ${ADV_ADVRC:=""}

  if [[ ! -z $ADV_ADVRC ]]
  then
    adv_user_data_paths=("${adv_user_data_paths[@]}" "$ADV_ADVRC")
  fi
}

# prepare_adv_host
#
# Setup adv_host server hostname for api calls
#
# @exports
#   adv_host
#   hostname for api calls
#
prepare_adv_host(){
  adv_host=${adv_host:-${ADV_HOST:-"http://0.0.0.0:3000"}}
}
