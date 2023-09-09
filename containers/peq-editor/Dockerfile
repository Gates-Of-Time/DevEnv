FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
	libbz2-dev \
	libc-client-dev \
	libcurl4-gnutls-dev \
	libkrb5-dev \
	libmcrypt-dev \
	libpng-dev \
	libreadline-dev \
	libssl-dev \
	libxml2-dev \
	libxslt-dev \
  libzip-dev \
	git

RUN docker-php-ext-install -j$(nproc) bcmath
RUN docker-php-ext-install -j$(nproc) calendar
RUN docker-php-ext-install -j$(nproc) curl
RUN docker-php-ext-install -j$(nproc) dba
RUN docker-php-ext-install -j$(nproc) exif
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) gettext
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) opcache
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) soap
RUN docker-php-ext-install -j$(nproc) sockets
RUN docker-php-ext-install -j$(nproc) xsl
RUN docker-php-ext-install -j$(nproc) zip

RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.memory_consumption=512" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.interned_strings_buffer=64" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.max_accelerated_files=32531" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.save_comments=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.fast_shutdown=0" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.revalidate_freq=600000" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

RUN a2enmod deflate
RUN a2enmod expires
RUN a2enmod file_cache
RUN a2enmod headers
RUN a2enmod rewrite

ENV EDITOR_VERSION=b23e643705c2137e0c797a9411fd2bf4c34a8055
ENV EDITOR_URL=https://github.com/ProjectEQ/peqphpeditor.git
ENV EDITOR_DIR=/var/www/html

RUN git config --global --add safe.directory $EDITOR_DIR
RUN git clone $EDITOR_URL $EDITOR_DIR
RUN cd $EDITOR_DIR && git checkout $EDITOR_VERSION
