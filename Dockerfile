# Use PHP 8.2 with Apache
FROM php:8.2-apache

# Install system dependencies including Node.js
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev zip git unzip curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Enable Apache mod_rewrite for Laravel
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Install Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Verify CSS files exist before build
RUN test -f /var/www/html/resources/css/app.css && \
    test -f /var/www/html/resources/css/orchid-custom.css && \
    echo "CSS files found"

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Install Node.js dependencies and build assets
RUN set -e && \
    npm ci && \
    npm run build && \
    echo "Build completed successfully" && \
    ls -la /var/www/html/public/build/ && \
    test -f /var/www/html/public/build/manifest.json && \
    echo "Manifest file exists" && \
    (grep -q "orchid-custom\|--bs-primary\|platform-aside" /var/www/html/public/build/assets/*.css 2>/dev/null && echo "Custom CSS found in build" || echo "Warning: Custom CSS may not be included") && \
    echo "Build verification complete"

# Set permissions for Laravel storage
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/public/build

# Set Apache document root to Laravel public/
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# Update Apache config
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]