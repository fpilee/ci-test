# Set the base image for subsequent instructions
FROM php:7.2

# Update packages
RUN apt-get update

# Install PHP and composer dependencies
RUN apt-get install -yqq git libmcrypt-dev unzip libpq-dev libcurl4-gnutls-dev libicu-dev libvpx-dev libjpeg-dev libpng-dev libxpm-dev zlib1g-dev libfreetype6-dev libxml2-dev libexpat1-dev libbz2-dev libgmp3-dev libldap2-dev unixodbc-dev libsqlite3-dev libaspell-dev libsnmp-dev libpcre3-dev libtidy-dev

# Clear out the local repository of retrieved package files
RUN apt-get clean

# Install needed extensions
# Here you can install any other extension that you need during the test and deployment process
RUN docker-php-ext-install mbstring curl json intl gd xml zip bz2 opcache

RUN pecl install xdebug

RUN docker-php-ext-enable xdebug

# Install Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /usr/src/app

# Set the working directory to /app
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /app
COPY composer.json /usr/src/app
COPY composer.lock /usr/src/app

RUN composer install

COPY . /usr/src/app
