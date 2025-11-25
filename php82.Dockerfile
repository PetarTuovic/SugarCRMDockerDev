FROM php:8.2.19-apache

RUN apt-get update && apt-get install -qq -y wget openssl curl libcurl4-openssl-dev libffi-dev libldb-dev libldap2-dev libonig-dev libxslt-dev bash nano coreutils libc-client-dev libkrb5-dev libpng-dev libsodium-dev libgmp-dev libzip-dev libargon2-dev libxml2-dev && rm -r /var/lib/apt/lists/*

RUN apt-get update && apt-get install -qq -y xvfb xauth xfonts-base xfonts-75dpi fontconfig

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb && dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb

RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb && apt install -y ./wkhtmltox_0.12.6-1.buster_amd64.deb

RUN docker-php-ext-install bcmath ctype curl dom exif ffi fileinfo filter ftp gd gettext

RUN docker-php-ext-install gmp iconv mbstring mysqli opcache

RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so

RUN docker-php-ext-install ldap && docker-php-ext-enable ldap

RUN docker-php-ext-install pdo pdo_mysql phar session

RUN docker-php-ext-install xsl zip

RUN docker-php-ext-install soap && docker-php-ext-enable soap

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap

RUN pecl install xdebug-3.3.2 && docker-php-ext-enable xdebug

COPY conf/php/php.ini "$PHP_INI_DIR/php.ini"

RUN rm "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"

COPY conf/php/conf.d/docker-php-ext-xdebug.ini "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"

RUN mkdir /var/log/php/ && touch /var/log/php/error.log

RUN ln -s /var/log/php/error.log /var/www/html/php-error.log

RUN a2enmod rewrite
