#!/bin/bash
ADAPTER_IP="192.168.1.226"

echo "About to restart adapter with IP: ${ADAPTER_IP}"

CSRF=$(curl -s "http://${ADAPTER_IP}/assets/data.cfl" -H 'Accept: application/json, text/plain, */*' --insecure | grep CSRFTOKEN= | cut -d'=' -f 2)
if [ ! -z "$CSRF" ]; then
  echo "Obtained CSRF token: $CSRF"
  curl --fail -s "http://${ADAPTER_IP}/" -H 'Accept: application/json, text/plain, */*' -H 'Content-Type: application/x-www-form-urlencoded' --data-raw "SYSTEM.GENERAL.HW_RESET=1&.CSRFTOKEN=$CSRF" --insecure  > /dev/null && echo "SUCCESS!" && exit 0
  echo "There was an error sending the RESET request"
else
  echo "Couldn't obtain CSRF Token"
fi
echo "FAIL!"
exit 1
