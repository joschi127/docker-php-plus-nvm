FROM php:7.3-apache
MAINTAINER joschi127 <127.joschi@gmail.com>

# Environment variables that can be changed on runtime
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_DOCUMENT_ROOT /app/web
ENV APP_ROOT /app
ENV APPLICATION_USER "application"
ENV APPLICATION_USER_ID "1000"
ENV APPLICATION_GROUP "application"
ENV APPLICATION_GROUP_ID "1000"
ENV POST_DEPLOYMENT_SCRIPT /app/deploy-post-deployment.sh

# Environment variables that cannot (yet?) be changed on runtime
ENV NODE_VERSION=10.14.1
ENV GULP_VERSION=3.9.1
ENV JSPM_VERSION=0.16.53
ENV NVM_DIR=/usr/local/nvm
ENV PATH ${PATH}:${APP_ROOT}/bin:${APP_ROOT}/scripts:${APP_ROOT}/app

# Install extra packages, PHP extensions, ...
RUN a2enmod rewrite expires include deflate proxy headers ssl
RUN a2ensite default-ssl
RUN mkdir -p /usr/share/man/man1/ /usr/share/man/man7/          # fix for postgresql-client install
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libpng-dev \
        libjpeg-dev \
        libwebp-dev \
        libjpeg62-turbo-dev \
        libxpm-dev \
        libfreetype6-dev \
        libpq-dev \
        libmcrypt-dev \
        libldap2-dev \
        libldb-dev \
        libicu-dev \
        libgmp-dev \
        libmagickwand-dev \
        libxml2-dev \
        libzip-dev \
        build-essential \
        libssl-dev \
        openssh-server \
        ca-certificates=20200601~deb9u1 \
        python2.7 \
        webp \
        imagemagick \
        git \
        vim \
        nano \
        curl \
        wget \
        rsync \
        unzip \
        inetutils-ping \
        tcptraceroute \
        screen \
        bash-completion \
        mysql-client \
        postgresql-client \
        ssl-cert \
    && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1 \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick-beta \
    && pecl install mcrypt-1.0.3 \
    && pecl install xdebug \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-webp-dir \
        --with-jpeg-dir \
        --with-png-dir \
        --with-zlib-dir \
        --with-xpm-dir \
        --with-freetype-dir \
        --enable-gd-native-ttf \
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
        sockets \
        soap \
        sysvsem \
    && docker-php-ext-enable imagick mcrypt \
    && make-ssl-cert generate-default-snakeoil

COPY motd /etc/motd
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
COPY vhost-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY init_container.sh /bin/

RUN chmod 777 /var/log \
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

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install nodejs / npm via nvm
RUN mkdir -p $NVM_DIR \
    && curl https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install gulp@$GULP_VERSION -g \
    && npm install jspm@$JSPM_VERSION -g

# Setup bashrc
RUN echo | tee -a /etc/skel/.bashrc >> /etc/bash.bashrc \
    && echo ". /etc/profile.d/dockerenv.sh" | tee -a /etc/skel/.bashrc >> /etc/bash.bashrc \
    && echo "cd \$APP_ROOT" | tee -a /etc/skel/.bashrc >> /etc/bash.bashrc \
    && echo ". \$NVM_DIR/nvm.sh" | tee -a /etc/skel/.bashrc >> /etc/bash.bashrc \
    && echo | tee -a /etc/skel/.bashrc >> /etc/bash.bashrc

# Create user
RUN groupadd -g $APPLICATION_GROUP_ID $APPLICATION_GROUP \
    && useradd -m -s /bin/bash -u $APPLICATION_USER_ID -g $APPLICATION_GROUP $APPLICATION_USER

WORKDIR ${APP_ROOT}

ENTRYPOINT ["/bin/init_container.sh"]
