#!/bin/bash

DOMAIN=$1
EXPIRY_DATE=$(echo | openssl s_client -connect ${DOMAIN}:443 -servername ${DOMAIN} 2>/dev/null | openssl x509 -noout -enddate)

# Extract the date
EXPIRY_DATE=$(echo $EXPIRY_DATE | cut -d'=' -f2)

# Convert to a timestamp for comparison
EXPIRY_TIMESTAMP=$(date -d "$EXPIRY_DATE" +%s)
CURRENT_TIMESTAMP=$(date +%s)

# Check if the certificate is expiring within 30 days
DAYS_LEFT=$(( (EXPIRY_TIMESTAMP - CURRENT_TIMESTAMP) / 86400 ))

if [ $DAYS_LEFT -le 30 ]; then
    echo "Certificate for $DOMAIN is expiring in $DAYS_LEFT days on $EXPIRY_DATE."
else
    echo "Certificate for $DOMAIN is valid for $DAYS_LEFT more days."
fi

