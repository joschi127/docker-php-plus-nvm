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
DOCKER_ALREADY_LOGGED_IN_USERNAME="$(docker info | grep 'Username:' | sed 's/Username: //' | sed 's/ *$//g')"
if [ "$DOCKER_ALREADY_LOGGED_IN_USERNAME" = "" ] || [ "$DOCKER_ALREADY_LOGGED_IN_USERNAME" != "$DOCKER_USERNAME" ]
then
    docker login -u "$DOCKER_USERNAME"
fi

# generate build number
buildnumber=$(date -u +"%Y%m%d_%H%M")

# build
## - php 5.6
#docker build $NO_CACHE_PARAM -t joschi127/php-plus-nvm:5.6-apache_"$buildnumber" ./5.6-apache
#docker tag joschi127/php-plus-nvm:5.6-apache_"$buildnumber" joschi127/php-plus-nvm:5.6-apache_latest
#
#docker push joschi127/php-plus-nvm:5.6-apache_"$buildnumber"
#docker push joschi127/php-plus-nvm:5.6-apache_latest
#
## - php 7.1
#docker build $NO_CACHE_PARAM -t joschi127/php-plus-nvm:7.1-apache_"$buildnumber" ./7.1-apache
#docker tag joschi127/php-plus-nvm:7.1-apache_"$buildnumber" joschi127/php-plus-nvm:7.1-apache_latest
#
#docker push joschi127/php-plus-nvm:7.1-apache_"$buildnumber"
#docker push joschi127/php-plus-nvm:7.1-apache_latest
#
## - php 7.2
#docker build $NO_CACHE_PARAM -t joschi127/php-plus-nvm:7.2-apache_"$buildnumber" ./7.2-apache
#docker tag joschi127/php-plus-nvm:7.2-apache_"$buildnumber" joschi127/php-plus-nvm:7.2-apache_latest
#
#docker push joschi127/php-plus-nvm:7.2-apache_"$buildnumber"
#docker push joschi127/php-plus-nvm:7.2-apache_latest

# - php 7.3
docker build $NO_CACHE_PARAM -t joschi127/php-plus-nvm:7.3-apache_"$buildnumber" ./7.3-apache
docker tag joschi127/php-plus-nvm:7.3-apache_"$buildnumber" joschi127/php-plus-nvm:7.3-apache_latest

docker push joschi127/php-plus-nvm:7.3-apache_"$buildnumber"
docker push joschi127/php-plus-nvm:7.3-apache_latest

# - php 7.4
docker build $NO_CACHE_PARAM -t joschi127/php-plus-nvm:7.4-apache_"$buildnumber" ./7.4-apache
docker tag joschi127/php-plus-nvm:7.4-apache_"$buildnumber" joschi127/php-plus-nvm:7.4-apache_latest

docker push joschi127/php-plus-nvm:7.4-apache_"$buildnumber"
docker push joschi127/php-plus-nvm:7.4-apache_latest

# remove old local images, if they are not used
for old_image_id in $(docker images | grep joschi127/php-plus-nvm | grep -v _latest | grep -v _$buildnumber | awk '{print $3}')
do
    docker rmi $old_image_id || echo "Keeping image $old_image_id, seems to be still in use"
done

# final success message
echo "Successfully completed"
