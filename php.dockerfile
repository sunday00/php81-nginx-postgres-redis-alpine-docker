FROM php:8.1-fpm-alpine

ENV PHPGROUP=laravel
ENV PHPUSER=laravel

RUN adduser -g ${PHPGROUP} -s /bin/sh -D ${PHPUSER}

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p "/var/www/html/current/public"
RUN mkdir -p "/docker/html/laravel/grayfield/src/current/storage/app/public"

RUN rm -rf /var/cache/apk/* && rm -rf /tmp/*
RUN apk --no-cache update &&  \
    && apk --no-cache upgrade \
    && apk add --no-cache libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pgsql pdo_pgsql

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
