#!/usr/bin/env bash

SCRIPT_BASE_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "$SCRIPT_BASE_PATH"

#export CERTBOT_CERTS_PATH=/etc/letsencrypt
#export CERTBOT_STANDALONE=false
#export CERTBOT_HOST=dev.sangah.com
#export CERTBOT_EMAIL=pmis@sangah.com
#export CERTBOT_WEBROOT=/var/www

docker-compose up
