#!/bin/bash
set -e

if [ "$CERTBOT_STANDALONE" == "true" ]; then
  nginx
fi

echo "Generating certificate with the following settings:"
echo "- host:                 ${CERTBOT_HOST}"
echo "- email:                ${CERTBOT_EMAIL}"
echo "- standalone mode:      ${CERTBOT_STANDALONE}"
echo "- certificate location: ${CERTBOT_CERTS_PATH}"

if [ $# -eq 0 ]; then
    exec /bin/sh /certbot-auto certonly \
        -n --agree-tos --no-self-upgrade --email ${CERTBOT_EMAIL} --webroot \
        -w /usr/share/nginx/html -d ${CERTBOT_HOST} 
        #--force-renewal
fi

exec "$@"