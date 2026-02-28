FROM php:7.4-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-install mysqli pdo pdo_mysql gd zip intl

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Permisos correctos
RUN chown -R www-data:www-data /var/www/html