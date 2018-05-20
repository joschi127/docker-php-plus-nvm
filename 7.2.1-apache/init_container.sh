#!/bin/bash
cat >/etc/motd <<EOL 
       _                       _                                      
 _ __ | |__  _ __        _ __ | |_   _ ___       _ ____   ___ __ ___  
| '_ \| '_ \| '_ \ _____| '_ \| | | | / __|_____| '_ \ \ / / '_ ` _ \ 
| |_) | | | | |_) |_____| |_) | | |_| \__ \_____| | | \ V /| | | | | |
| .__/|_| |_| .__/      | .__/|_|\__,_|___/     |_| |_|\_/ |_| |_| |_|
|_|         |_|         |_|                                           
php-plus-nvm docker image

Documentation: https://github.com/joschi127/docker-php-plus-nvm/blob/master/README.md

EOL
cat /etc/motd

# Get environment variables to show up in SSH session
eval $(printenv | awk -F= '{print "export " $1"="$2 }' >> /etc/profile)

# Start ssh
service ssh start

# Run post deployment script
if [ "$POST_DEPLOYMENT_SCRIPT" != "" ]; then
    if [ -e "$POST_DEPLOYMENT_SCRIPT" ]; then
        echo "Running POST_DEPLOYMENT_SCRIPT: $POST_DEPLOYMENT_SCRIPT ..."
        echo "(errors will be ignored to avoid failing container startup)"
        bash $POST_DEPLOYMENT_SCRIPT || true
    else
        echo "No POST_DEPLOYMENT_SCRIPT found under path: $POST_DEPLOYMENT_SCRIPT"
    fi
else
    echo "No POST_DEPLOYMENT_SCRIPT defined"
fi

# Start webserver
APACHE_DOCUMENT_ROOT_ESCAPED="$(echo "$APACHE_DOCUMENT_ROOT" | sed "s/\//\\\\\//g")"
sed -i "s/{PORT}/$PORT/g" /etc/apache2/apache2.conf
sed -i "s/{APACHE_DOCUMENT_ROOT}/$APACHE_DOCUMENT_ROOT_ESCAPED/g" /etc/apache2/apache2.conf
sed -i "s/\/var\/www\/html/$APACHE_DOCUMENT_ROOT_ESCAPED/g" /etc/apache2/sites-available/000-default.conf
mkdir -p "$APACHE_DOCUMENT_ROOT"
mkdir -p /var/lock/apache2
mkdir -p /var/run/apache2
mkdir -p /var/log/apache2
/usr/sbin/apache2ctl -D FOREGROUND
