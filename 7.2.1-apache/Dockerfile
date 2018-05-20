FROM php:7.2.1-apache
MAINTAINER joschi127 <127.joschi@gmail.com>

RUN a2enmod rewrite expires include deflate proxy headers

# install the PHP extensions we need
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         libpng-dev \
         libjpeg-dev \
         libpq-dev \
         libmcrypt-dev \
         libldap2-dev \
         libldb-dev \
         libicu-dev \
         libgmp-dev \
         libmagickwand-dev \
         openssh-server vim curl wget tcptraceroute \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick-beta \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd \
         mysqli \
         opcache \
         pdo \
         pdo_mysql \
         pdo_pgsql \
         pgsql \
         ldap \
         intl \
         gmp \
         zip \
         bcmath \
         mbstring \
         pcntl \
         xml \
         simplexml \
         exif \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable mcrypt

COPY motd /etc/motd
COPY init_container.sh /bin/

RUN   \
   chmod 777 /var/log \
   && chmod 777 /var/run \
   && chmod 777 /var/lock \
   && chmod 777 /bin/init_container.sh

RUN { \
                echo 'opcache.memory_consumption=128'; \
                echo 'opcache.interned_strings_buffer=8'; \
                echo 'opcache.max_accelerated_files=4000'; \
                echo 'opcache.revalidate_freq=60'; \
                echo 'opcache.fast_shutdown=1'; \
                echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
                echo 'error_log=/var/log/apache2/php-error.log'; \
                echo 'display_errors=Off'; \
                echo 'log_errors=On'; \
                echo 'display_startup_errors=Off'; \
                echo 'date.timezone=Europe/Berlin'; \
    } > /usr/local/etc/php/conf.d/php.ini

EXPOSE 10022 10080 10443

ENV PORT 10080
ENV APACHE_RUN_USER www-data
ENV APACHE_DOCUMENT_ROOT /app/web
ENV APP_ROOT /app
ENV POST_DEPLOYMENT_SCRIPT /app/deploy-post-deployment.sh

ENV PATH ${PATH}:${APP_ROOT}/bin:${APP_ROOT}/scripts:${APP_ROOT}/app

RUN   \
    echo "cd /app" >> /etc/bash.bashrc

WORKDIR ${APP_ROOT}

ENTRYPOINT ["/bin/init_container.sh"]
