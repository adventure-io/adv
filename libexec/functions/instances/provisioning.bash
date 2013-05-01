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
  prepare_adv_host

  set +e

  local ret
  ret=$(
      curl \
        -s -L --post301 --post302 \
        -F "user[email]"="$adv_user_email" \
        -F "user[api_key]"="$adv_user_api_key" \
        -F "instance[service_slug]"="$service" \
        "$adv_host/instances" 2>&1
    )

  if [[ $? > 0 ]]
  then
    fail "$service: Unable to create an instance at this time!"
  else
    echo "$service: $ret"
  fi

  set -e
}
