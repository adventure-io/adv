##
# Authentication Functions
#

# check_authenticated
#
# figure out whether data exists on the system that will
# authenticate the current user
#
# @exports
#   adv_authenticated
#   whether the user is authenticated
#
check_authenticated(){
  if [ -z $adv_authenticated ]
  then
    load_user_data
    if [[ -z "$adv_user_email" || -z "$adv_user_api_key" ]]
    then
      adv_authenticated=false
    else
      adv_authenticated=true
    fi
  fi
}

# login
#
# Login a user and get an api key
#
# @exports
#   adv_user_email
#   email for user account
#
# @exports
#   adv_user_api_key
#   api key for user account
#
login(){
  echo "Enter your email to login..."
  read -p '> ' adv_user_email
  echo "BLOWING UP NOW :)"
  # fetch_api_key
  return 1
}
