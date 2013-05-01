##
# Destroying instances functions
#

# destroy_instance
#
# Given an instance id, send the destroy command
#
destroy_instance(){
  prepare_adv_host

  set +e

  local id=$1
  local ret
  ret=$(
      curl \
        -s -L \
        -X DELETE \
        --data-urlencode "user[email]"="$adv_user_email" \
        --data-urlencode "user[api_key]"="$adv_user_api_key" \
        "$adv_host/instances/$id" 2>&1
    )

  if [[ $? > 0 ]]
  then
    fail "Unable to list your instances at this time!"
  else
    echo "$ret"
  fi

  set -e
}

# destroy_instances
#
# Given a list of instance ids, destroy each
#
destroy_instances(){
  for instance_id
  do
    destroy_instance $instance_id
  done
}
