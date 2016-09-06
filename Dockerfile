# NAME: nginx-php
# Basic Nginx PHP-FPM Build
FROM alpine:3.4
COPY repositories /etc/apk/repositories

#Environment
ENV PHP=php-7.0.10
ENV PHP_PATH=/usr/bin/php7
ENV PHP_CONFIG_PATH=/etc/php7
ENV NGINX nginx-1.11.3
RUN apk --update add \
    autoconf \
    #bzip2-dev \
    ca-certificates \
    curl \
    #freetype-dev \
    #gettext-dev \
    g++ \
    git \
    #gmp-dev \
    #krb5-dev \
    #libjpeg-turbo-dev \
    #libjpeg \
    #libmcrypt-dev \
    #libxpm-dev \
    #libxml2-dev \
    #libwebp-dev \
    make \
    musl@edge \
    musl-dev@edge \
    musl-utils@edge \
    nginx \
    #openssl-dev \
    #perl \
    php7@community \
    php7-dom@community \
    php7-fpm@community \
    php7-openssl@community \
    php7-mcrypt@community \
    php7-zlib@community \
    php7-ctype@community \
    php7-curl@community \
    php7-bz2@community \
    php7-gd@community \
    php7-iconv@community \
    php7-json@community \
    php7-mbstring@community \
    php7-mysqli@community \
    php7-openssl@community \
    php7-phar@community \
    php7-session@community \
    php7-redis@testing \
    php7-xdebug@testing \
    #composer@testing \
    shadow@community \
    supervisor \
    tar \
    && rm /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php


# Install Composer
RUN mkdir -p /etc/ssl/certs/ \
    && update-ca-certificates --fresh \
    && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

#install newrelic php agent and daemon
#ADD https://download.newrelic.com/php_agent/archive/6.5.0.166/newrelic-php5-6.5.0.166-linux-musl.tar.gz /
ENV NR_INSTALL_SILENT=FALSE
ENV NR_INSTALL_KEY=${}
ENV NR_INSTALL_USE_CP_NOT_LN=/usr/bin/newrelic-php/
ENV NR_INSTALL_PATH=/newrelic-php5-6.5.0.166-linux-musl
RUN wget "http://download.newrelic.com/php_agent/archive/6.5.0.166/newrelic-php5-6.5.0.166-linux-musl.tar.gz" \
  && gzip -dc newrelic-php5-6.5.0.166-linux-musl.tar.gz | tar xf - \
  && cd newrelic-php5-6.5.0.166-linux-musl \
  && ./newrelic-install install \
  && rm -rf /newrelic-php5-6.5.0.166-linux-musl \
  && rm -rf /newrelic-php5-6.5.0.166-linux-musl.tar.gz \
  && mkdir -p /var/log/newrelic \
  && mkdir -p /var/run/newrelic

# Ensure $HOME is set
ENV HOME /root
# Create www-data user
RUN adduser -S www-data -G www-data \
  && usermod -u 1000 www-data
# Copy config files
COPY nginx/default /etc/nginx/sites-enabled/default
COPY php/php.ini $PHP_CONFIG_PATH/php.ini
COPY php/www.conf $PHP_CONFIG_PATH/conf.d/www.conf
COPY php/php-fpm.conf $PHP_CONFIG_PATH/php-fpm.d/php-fpm.conf
#Set up services
COPY php/php-fpm /etc/init.d/php-fpm
RUN chown root:root /etc/init.d/php-fpm
