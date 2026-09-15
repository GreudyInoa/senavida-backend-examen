FROM php:8.4-fpm

RUN apt-get update && apt-get install -y \
    nginx git curl zip unzip libpq-dev libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql zip \
    && apt-get clean

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install --optimize-autoloader --no-dev --no-scripts --no-interaction
RUN chmod -R 775 storage bootstrap/cache

COPY nginx.conf /etc/nginx/sites-available/default

EXPOSE 8080

CMD php artisan config:clear && php artisan cache:clear && php artisan migrate --force && php-fpm -D && nginx -g "daemon off;"