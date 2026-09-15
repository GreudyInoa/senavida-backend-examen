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

RUN echo 'server { \n\
    listen 8080; \n\
    root /app/public; \n\
    index index.php; \n\
    location / { try_files $uri $uri/ /index.php?$query_string; } \n\
    location ~ \.php$ { \n\
        fastcgi_pass 127.0.0.1:9000; \n\
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \n\
        include fastcgi_params; \n\
    } \n\
}' > /etc/nginx/sites-available/default

EXPOSE 8080

CMD php artisan config:clear && php artisan cache:clear && php artisan migrate --force && php-fpm -D && nginx -g "daemon off;"