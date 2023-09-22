# Use the official PHP 8.2.8 image with Apache as the base image
FROM php:8.2.8-apache

# Set the installation directory for the web application
ENV INSTALL_DIR /var/www/html

# Update the package lists and upgrade installed packages
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends wget unzip zip zlib1g-dev libfreetype6-dev libpng-dev libzip-dev libc-client-dev libjpeg-dev libkrb5-dev ghostscript

# Install additional utilities
RUN apt-get install -y telnet bind9-utils

# Clean up the package cache to reduce the image size
RUN apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Configure and install PHP extensions: IMAP, GD, ZIP, BCMath, Opcache, EXIF, MySQLi
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) imap gd zip bcmath opcache exif mysqli

# Copy the cmd.sh script into the container and set its permissions
COPY --chmod=755 cmd.sh /cmd.sh

# Set the user and group to run the container as (www-data is the Apache user)
USER www-data:www-data

# Set the working directory to the installation directory
WORKDIR $INSTALL_DIR

# Expose port 80 to allow external connections to the web server
EXPOSE 80

# Define the command to run when the container starts
CMD ["/cmd.sh"]
