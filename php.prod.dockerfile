FROM php:8.1-fpm-alpine

ENV PHPGROUP=laravel
ENV PHPUSER=laravel

RUN adduser -g ${PHPGROUP} -s /bin/sh -D ${PHPUSER}

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p "/var/www/html/current/public"

RUN rm -rf /var/cache/apk/* && rm -rf /tmp/*
RUN apk --no-cache update && apk --no-cache upgrade \
    && apk add --no-cache ${PHPIZE_DEPS} libpq-dev gcc g++ autoconf make php8-dev \
        freetype freetype-dev jpeg-dev libjpeg libjpeg-turbo-dev libpng libpng-dev libwebp libwebp-dev \
        libxml2-dev libzip-dev \
    && docker-php-ext-configure pgsql \
        --with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd exif pdo pgsql pdo_pgsql opcache

ADD php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

RUN pecl install redis \
    && docker-php-ext-enable redis \
    && rm -rf /tmp/pear/

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
