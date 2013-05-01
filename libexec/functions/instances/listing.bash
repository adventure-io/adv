##
# Listing instances functions
#

# list_instances
#
# Print a list of instances and their data
#
list_instances(){
  prepare_adv_host

  set +e

  local ret
  ret=$(
      curl \
        -s -L -G \
        --data-urlencode "user[email]"="$adv_user_email" \
        --data-urlencode "user[api_key]"="$adv_user_api_key" \
        "$adv_host/instances" 2>&1
    )

  if [[ $? > 0 ]]
  then
    fail "Unable to list your instances at this time!"
  else
    echo "$ret"
  fi

  set -e
}
