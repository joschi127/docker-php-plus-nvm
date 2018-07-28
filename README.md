docker php-plus-nvm
===================

Docker php image build with extra features and integrated nvm based
nodejs support.

Based on default docker php image and inspired by
https://github.com/webdevops/Dockerfile and
https://github.com/Azure-App-Service/php images.


Configuration options / environment variables:
----------------------------------------------

* APACHE_RUN_USER (default: www-data)

  User under which apache will be started.
  

* APACHE_RUN_GROUP (default: www-data)

  Group under which apache will be started.


* APACHE_DOCUMENT_ROOT (default: /app/web)

  The document root for the apache web server.


* APP_ROOT (default: /app)

  The root of the application.


* APPLICATION_USER (default: application)

  The username of the application user.


* APPLICATION_USER_ID (default: 1000)

  The id of the application user.


* APPLICATION_GROUP (default: application)

  The group name of the application user.


* APPLICATION_GROUP_ID (default: 1000)

  The group id of the application user.


* POST_DEPLOYMENT_SCRIPT (default: /app/deploy-post-deployment.sh)

  Script that will be executed after deployment / during container
  startup.


Run for testing:
----------------

* Run a container from the created image:

        # run container
        docker run --name test --detach --env MYVAR=foo joschi127/php-plus-nvm:7.2.1-apache_latest

        # show logs
        docker logs test [ -f ]

        # open shell
        docker exec -i -t test /bin/bash

        # stop and remove
        docker stop test && docker rm test
