FROM public.ecr.aws/unicc/lap83-alpine:stable

COPY . /var/www/

COPY unicc/php/php-dev.ini /unicc/php/php-dev.ini
COPY unicc/php/php-test.ini /unicc/php/php-test.ini
COPY unicc/php/php-prod.ini /unicc/php/php-prod.ini

WORKDIR /var/www

USER root

RUN rm -rf html
RUN apk add --update --no-cache \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    libwebp-dev \
    libmemcached-dev \
    zlib-dev \
    icu-dev \
    g++ \
    icu \
    icu-data-full \
    mysql-client \
    git \
    graphicsmagick

RUN docker-php-ext-configure intl && \
    docker-php-ext-install -j$(nproc) intl

RUN mkdir -p /run/apache2 /unicc

RUN ln -s /var/www/public html && \
    mkdir -p /var/www/typo3temp && \
	composer install --no-dev --no-ansi --no-interaction --no-progress --prefer-dist --optimize-autoloader

RUN bin/typo3 install:fixfolderstructure

RUN chmod ugo-w -R /var/www && \
    chmod ugo+w -R /var/www/var && \
    chmod ugo+w -R /var/www/public/fileadmin && \
    chmod ugo+w -R /var/www/public/typo3temp

RUN date > public/date.txt

COPY --chown=nobody:nobody postDeploy.sh /var/www/
RUN chmod 777 postDeploy.sh


USER nobody

