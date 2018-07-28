#!/bin/bash

# welcome message
cat /etc/motd

# Update application user id and group id
groupadd -g $APPLICATION_GROUP_ID $APPLICATION_GROUP || true
useradd -m -s /bin/bash -u $APPLICATION_USER_ID -g $APPLICATION_GROUP $APPLICATION_USER || true
usermod -u $APPLICATION_USER_ID $APPLICATION_USER
groupmod -g $APPLICATION_GROUP_ID $APPLICATION_GROUP
chown -R $APPLICATION_USER_ID:$APPLICATION_GROUP_ID /home/$APPLICATION_USER

# Get environment variables to show up in SSH session
eval $(printenv | grep -v -e '^PWD\|^OLDPWD\|^HOME\|^USER\|^TERM' | awk -F= '{print "export " $1"=\""$2"\"" }' > /etc/profile.d/dockerenv.sh)

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
mkdir -p /var/lock/apache2
mkdir -p /var/run/apache2
mkdir -p /var/log/apache2
/usr/sbin/apache2ctl -D FOREGROUND
