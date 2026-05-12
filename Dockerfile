FROM dunglas/frankenphp:latest

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    zip

# Install PHP extensions
RUN install-php-extensions \
    pdo_pgsql \
    gd \
    intl \
    zip \
    exif \
    pcntl \
    redis

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Prepare Laravel
RUN cp .env.example .env

RUN php artisan key:generate

RUN php artisan storage:link

EXPOSE 10000

CMD php artisan migrate --force && \
    php artisan serve --host=0.0.0.0 --port=10000
