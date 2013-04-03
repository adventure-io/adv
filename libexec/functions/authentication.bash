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
  true \
    ${adv_authenticated:=""} \
    ${adv_user_email:=""} \
    ${adv_user_api_key:=""}

  if [ -z $adv_authenticated ]
  then
    load_user_data
    if [[ ! -z "$adv_user_email" && ! -z "$adv_user_api_key" ]]
    then
      adv_authenticated=true
    else
      adv_authenticated=false
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
  if [ ! -z ${ADV_USER_EMAIL:-""} ]
  then
    adv_user_email=$ADV_USER_EMAIL
  else
    adv_user_email=""
  fi

  while [ -z $adv_user_email ]
  do
    read_user_email
    if [ -z $adv_user_email ]
    then
      echo "
You must enter an email to login!
"
    fi
  done

  adv_user_api_key="$(fetch_api_key $adv_user_email)"
  write_creds_to_advrc
}

# write_creds_to_advrc
#
# Write new user email and api key to ~/.advrc
#
write_creds_to_advrc(){
  echo "
adv_user_email="$adv_user_email"
adv_user_api_key="$adv_user_api_key"
" | tee -a ~/.advrc > /dev/null 2>&1
}

# fetch_api_key
#
# Make a curl request with the users email to get an api key
#
# @exports
#   adv_user_api_key
#   api key for user account
#
fetch_api_key(){
  prepare_adv_host

  set +e

  local ret
  ret="$(
      curl \
        -s -L --post301 --post302 \
        -F "user[email]"="$1" \
        "$adv_host/users"
    )"

  if [[ $? > 0 ]]
  then
    fail "Unable to fetch an API key for you at this time!"
  else
    echo "$ret"
  fi

  set -e
}

# read_user_email
#
# Allow the user to enter their email
#
# @exports
#   adv_user_email
#   email for user account
#
read_user_email(){
  echo "Please enter your email to login..."
  echo "(We'll send notifications and updates to this address)"
  read -p '> ' adv_user_email
}
