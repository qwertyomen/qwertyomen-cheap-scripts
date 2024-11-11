#!/bin/bash

#Website to check

HOSTNAME="fqdn"

echo $HOSTNAME
curl --insecure -v https://$HOSTNAME 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' | grep expire | awk '{ print $4,$5,$7 }'

