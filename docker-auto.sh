#!/usr/bin/env bash

#export CERTBOT_CERTS_PATH=/etc/letsencrypt
#export CERTBOT_HOST=dev.sangah.com
#export CERTBOT_EMAIL=pmis@sangah.com
#export CERTBOT_WEBROOT=/var/www

set -e

SCRIPT_BASE_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$SCRIPT_BASE_PATH"

IMAGE_NAME="$IMAGE_NAME"
if [ -z "$IMAGE_NAME" ]; then
    IMAGE_NAME="$(cat .env | awk 'BEGIN { FS="="; } /^IMAGE_NAME/ {sub(/\r/,"",$2); print $2;}')"
fi
REGISTRY_URL="$REGISTRY_URL"
if [ -z "$REGISTRY_URL" ]; then
    REGISTRY_URL="$(cat .env | awk 'BEGIN { FS="="; } /^REGISTRY_URL/ {sub(/\r/,"",$2); print $2;}')"
fi

usage() {
echo "Usage:  $(basename "$0") [MODE] [OPTIONS] [COMMAND]"
echo 
echo "Mode:"
echo "  --prod             Production mode with no web server"
echo "  --dev              Development mode with no web server"
echo "  --dev-standalone   Development mode with web server included"
echo "  --prod-standalone  Production mode with web server included"
echo
echo "Options:"
echo "  --help          Show this help message"
echo
echo "Commands:"
echo "  up              Start the services"
echo "  down            Stop the services"
echo "  ps              Show the status of the services"
echo "  logs            Follow the logs on console"
echo "  remove-all      Remove all containers"
echo "  stop-all        Stop all containers running"
echo "  build           Build the image"
echo "  publish         Publish the image to the registry"
}

CONF_ARG="-f docker-compose-prod.yml"

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

for i in "$@"; do
    case $i in
        --prod)
            CONF_ARG="-f docker-compose-prod.yml"
            shift
            ;;
        --dev)
            CONF_ARG="-f docker-compose.yml"
            shift
            ;;
        --prod-standalone)
            CONF_ARG="-f docker-compose-prod-standalone.yml"
            shift
            ;;
        --dev-standalone)
            CONF_ARG="-f docker-compose-standalone.yml"
            shift
            ;;
        --help|-h)
            usage
            exit 1
            ;;
        *)
            ;;
    esac
done

echo "Arguments: $CONF_ARG"
echo "Command: $@"

if [ "$1" == "up" ]; then
    docker-compose $CONF_ARG pull
    docker-compose $CONF_ARG build --pull
    docker-compose $CONF_ARG up -d --remove-orphans
    exit 0

elif [ "$1" == "stop-all" ]; then
    if [ -n "$(docker ps --format {{.ID}})" ]
    then docker stop $(docker ps --format {{.ID}}); fi
    exit 0

elif [ "$1" == "remove-all" ]; then
    if [ -n "$(docker ps -a --format {{.ID}})" ]
    then docker rm $(docker ps -a --format {{.ID}}); fi
    exit 0

elif [ "$1" == "logs" ]; then
    shift
    docker-compose $CONF_ARG logs -f --tail 200 "$@"
    exit 0

elif [ "$1" == "build" ]; then
    if [ -z "$REGISTRY_URL" ]; then echo "REGISTRY_URL not defined."; exit 1; fi
    if [ -z "$IMAGE_NAME" ]; then echo "IMAGE_NAME not defined."; exit 1; fi
    
    docker build -t $REGISTRY_URL/$IMAGE_NAME was
    exit 0

elif [ "$1" == "publish" ]; then
    if [ -z "$REGISTRY_URL" ]; then echo "REGISTRY_URL not defined."; exit 1; fi
    if [ -z "$IMAGE_NAME" ]; then echo "IMAGE_NAME not defined."; exit 1; fi
    
    docker login $REGISTRY_URL
    docker push $REGISTRY_URL/$IMAGE_NAME
    exit 0
fi

docker-compose $CONF_ARG "$@"
