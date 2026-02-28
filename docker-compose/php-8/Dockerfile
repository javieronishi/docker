FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    zip unzip git curl \
    && docker-php-ext-install mysqli pdo pdo_mysql gd zip intl

RUN a2enmod rewrite

RUN chown -R www-data:www-data /var/www/html