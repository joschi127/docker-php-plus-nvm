docker php-plus-nvm
===================

Docker php image build with extra features and integrated nvm based
nodejs support.

Based on default docker php image and inspired by
https://github.com/webdevops/Dockerfile and
https://github.com/Azure-App-Service/php images.


Configuration options / environment variables:

* APACHE_RUN_USER (default: www-data)

  User under which apache will be started.
  

* APACHE_DOCUMENT_ROOT (default: /app/web)

  The document root for the apache web server.


* POST_DEPLOYMENT_SCRIPT (default: /app/deploy-post-deployment.sh)

  Script that will be executed after deployment / during container
  startup.
  

