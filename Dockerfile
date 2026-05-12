FROM dunglas/frankenphp

WORKDIR /app

COPY . .

RUN install-php-extensions \
    pdo_pgsql \
    gd \
    intl \
    zip \
    exif \
    pcntl \
    redis

RUN composer install --no-dev --optimize-autoloader

RUN cp .env.example .env

RUN php artisan key:generate

RUN php artisan storage:link

EXPOSE 10000

CMD php artisan migrate --force && \
    php artisan serve --host=0.0.0.0 --port=10000
