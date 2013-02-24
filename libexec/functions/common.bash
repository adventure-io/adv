##
# Common Functions
#

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
  if [ -e "$path" ]
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
  adv_user_data_paths=("/etc/advrc" "~/.advrc" "$PWD/.advrc")

  if [[ ! -z $ADV_ADVRC ]]
  then
    adv_user_data_paths=("${adv_user_data_paths[@]}" "$ADV_ADVRC")
  fi
}
