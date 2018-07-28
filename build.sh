#!/usr/bin/env bash
set -x -e

# parse arguments
if [ "$1" = "" ] || ([ "$2" != "" ] && [ "$2" != "--no-cache" ])
then
    echo "Usage: $0 DOCKER_USERNAME [ --no-cache ]"
    exit 1
fi
DOCKER_USERNAME="$1"
NO_CACHE_PARAM="$2"

# login
DOCKER_ALREADY_LOGGED_IN_USERNAME="$(docker info | grep 'Username:' | sed 's/Username: //')"
if [ "$DOCKER_ALREADY_LOGGED_IN_USERNAME" = "" ] || [ "$DOCKER_ALREADY_LOGGED_IN_USERNAME" != "$DOCKER_USERNAME" ]
then
    docker login -u "$DOCKER_USERNAME"
fi

# generate build number
buildnumber=$(date -u +"%Y%m%d_%H%M")

# build
docker build $NO_CACHE_PARAM -t joschi127/php-plus-nvm:5.6.36-apache_"$buildnumber" ./5.6.36-apache
docker tag joschi127/php-plus-nvm:5.6.36-apache_"$buildnumber" joschi127/php-plus-nvm:5.6.36-apache_latest

docker build $NO_CACHE_PARAM -t joschi127/php-plus-nvm:7.2.1-apache_"$buildnumber" ./7.2.1-apache
docker tag joschi127/php-plus-nvm:7.2.1-apache_"$buildnumber" joschi127/php-plus-nvm:7.2.1-apache_latest

docker push joschi127/php-plus-nvm:7.2.1-apache_"$buildnumber"
docker push joschi127/php-plus-nvm:7.2.1-apache_latest
