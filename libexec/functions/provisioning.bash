##
# Provisioning functions
#

# provision_services
#
# Try and provision a service for each argument passed
#
provision_services(){
  for service
  do
    provision_service $service
  done
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
  echo "provisioning redis"
}

# provision_unknown
#
# We don't know how to provision a service named like the argument
#
provision_unknown(){
  echo "don't know how to provision $1"
}
