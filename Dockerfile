# NAME: nginx-php
# Basic Nginx PHP-FPM Build
FROM alpine:3.5
COPY repositories /etc/apk/repositories
#Environment
ENV PHP_PATH=/usr/bin/php5
ENV PHP_CONFIG_PATH=/etc/php5
#RUN apk update
RUN apk --no-cache add \
    autoconf \
    ca-certificates \
    curl \
    g++ \
    git \
    libressl \
    make \
    musl \
    musl-dev \
    musl-utils \
    nginx \
    libwebp \
    php5 \
    php5-apcu \
    php5-dom@community \
    php5-fpm \
    php5-openssl \
    php5-mcrypt \
    php5-memcache \
    php5-zlib \
    php5-ctype \
    php5-curl \
    php5-bz2 \
    php5-gd \
    php5-iconv \
    php5-json \
    #php5-mbstring@community \
    php5-mysqli \
    php5-opcache \
    php5-openssl \
    php5-pdo \
    php5-pdo_mysql \
    php5-phar \
    #php5-session@community \
    php5-xdebug@v3.5-community \
    shadow@community \
    tar \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
    #&& ln -s /usr/bin/php5 /usr/bin/php


# Install Composer
RUN mkdir -p /etc/ssl/certs/ \
    && update-ca-certificates --fresh \
    && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

#install newrelic php agent and daemon
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
# Copy config files
COPY etc /etc
# Create www-data user
RUN adduser -S www-data -G www-data \
  && usermod -u 1000 www-data
