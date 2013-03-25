##
# Sharing functions
#

# share_with
#
# Share adventure with a list of email addresses
#
share_with(){
  local emails="$@"
  prepare_adv_host

  set +e

  local ret
  ret=$(
      curl \
        -s -L --post301 --post302 \
        -F "user[email]"="$adv_user_email" \
        -F "user[api_key]"="$adv_user_api_key" \
        -F "emails"="$emails" \
        "$adv_host/shares" 2>&1
    )

  if [[ $? > 0 ]]
  then
    fail "Unable to share at this time!"
  else
    echo "Thanks for sharing Adventure!"
  fi

  set -e
}
