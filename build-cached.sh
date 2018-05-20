#!/usr/bin/env bash
set -x -e

if test "$1" = "" || test "$2" = "" || test "$3" = ""
then
    echo "Usage: $0 DOCKER_HUB_REPOSITORY DOCKER_HUB_USER DOCKER_HUB_PASSWORD"
    exit 1
fi

buildnumber=$(date -u +"%Y%m%d_%H%M")

docker build -t "$1"/php-plus-nvm:7.2.1-apache_"$buildnumber" ./7.2.1-apache
docker tag "$1"/php-plus-nvm:7.2.1-apache_"$buildnumber" "$1"/php-plus-nvm:7.2.1-apache_latest

docker login -u "$2" -p "$3"

docker push "$1"/php-plus-nvm:7.2.1-apache_"$buildnumber"
docker push "$1"/php-plus-nvm:7.2.1-apache_latest

docker logout
