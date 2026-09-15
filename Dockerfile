FROM dunglas/frankenphp:latest-php8.4

RUN apt-get update && apt-get install -y \
    git zip unzip libpq-dev libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql zip \
    && apt-get clean

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install --optimize-autoloader --no-dev --no-scripts --no-interaction
RUN chmod -R 775 storage bootstrap/cache

ENV SERVER_NAME=":8080"
EXPOSE 8080

CMD php artisan config:clear && php artisan cache:clear && php artisan migrate --force && frankenphp run --config /etc/caddy/Caddyfile