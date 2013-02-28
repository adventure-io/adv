##
# Provisioning functions
#

# provision_services
#
# Try and provision a service for each argument passed
#
provision_services(){
  echo "
==========================================
Provisioning...
==========================================
"

  for service
  do
    provision_service $service
  done

  echo "
==========================================
"
}

# provision_service
#
# Try and provision the service named like the argument
#
provision_service(){
  local service="$1"
  case $service in
    redis)
      provision_redis
      ;;
    *)
      provision_unknown $service
      ;;
  esac
}

# provision_redis
#
# Provision a redis instance
#
provision_redis(){
  prepare_adv_host

  set +e

  local ret
  ret=$(
      curl \
        -s -L --post301 --post302 \
        -F "user[email]"="$adv_user_email" \
        -F "user[api_key]"="$adv_user_api_key" \
        -F "service_slug"="redis" \
        "$adv_host/instances" 2>&1
    )

  if [[ $? > 0 ]]
  then
    fail "REDIS: Unable to create an instance at this time!"
  else
    echo "REDIS: $ret"
  fi

  set -e
}

# provision_unknown
#
# We don't know how to provision a service named like the argument
#
provision_unknown(){
  echo "We're not able to provision $1 for you quite yet."
}
