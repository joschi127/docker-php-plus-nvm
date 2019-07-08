docker php-plus-nvm
===================

Docker php image with extra features and integrated nvm based nodejs
support.

* Docker Hub URL:
  https://hub.docker.com/r/joschi127/php-plus-nvm/

* GitHub URL for Dockerfiles and build script:
  https://github.com/joschi127/docker-php-plus-nvm

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
  If set to 'auto', the user id will be detected based on the owner of
  the APP_ROOT folder.


* APPLICATION_GROUP (default: application)

  The group name of the application user.


* APPLICATION_GROUP_ID (default: 1000)

  The group id of the application user.
  If set to 'auto', the group id will be detected based on the owner of
  the APP_ROOT folder.


* POST_DEPLOYMENT_SCRIPT (default: /app/deploy-post-deployment.sh)

  Script that will be executed after deployment / during container
  startup.


Xdebug:
-------

The php xdebug extension is installed but not enabled by default. If
enabled, it makes things much slower, especially when running
`composer update` or `cache:clear` on a bigger project.

To (temporarily) enable xdebug, add to your php.ini:

        zend_extension                 = xdebug.so


Build:
------

* To build the images and push them to docker hub:

        # build
        ./build.sh DOCKER_USERNAME [ --no-cache ]


Run for testing:
----------------

* Run a container from the created image:

        # run container
        docker run --name test --detach --env MYVAR=foo joschi127/php-plus-nvm:7.2-apache_latest

        # show logs
        docker logs test [ -f ]

        # open shell
        docker exec -i -t test /bin/bash

        # stop and remove
        docker stop test && docker rm test
