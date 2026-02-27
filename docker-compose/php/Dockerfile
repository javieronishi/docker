# Utilizar una imagen base de PHP
FROM php:8.2-apache

# Instalar dependencias del sistema y herramientas de ping
RUN apt-get update && apt-get install -y \
    iputils-ping \
    libpng-dev \
    libzip-dev \
    zip \
    unzip

# Instalar extensiones de PHP
RUN docker-php-ext-install pdo pdo_mysql mysqli gd zip

# Habilitar mod_rewrite para Apache (común en aplicaciones PHP)
RUN a2enmod rewrite

# Exponer el puerto 80 para el servidor web
EXPOSE 80