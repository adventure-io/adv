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
  true ${adv_authenticated:=0}

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

  fetch_api_key $adv_user_email
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
  fail
  curl \
    -L \
    --post301 --post302 \
    -F email="$1" \
    "localhost:8080"
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
  read -p '> ' adv_user_email
}
