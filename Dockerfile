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

RUN printf 'server {\n\
    listen 8080;\n\
    root /app/public;\n\
    index index.php index.html;\n\
    charset utf-8;\n\
    add_header Access-Control-Allow-Origin $http_origin always;\n\
    add_header Access-Control-Allow-Methods "GET, POST, PUT, PATCH, DELETE, OPTIONS" always;\n\
    add_header Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With" always;\n\
    if ($request_method = OPTIONS) { return 204; }\n\
    location / {\n\
        try_files $uri $uri/ /index.php?$query_string;\n\
    }\n\
    location = /favicon.ico { access_log off; log_not_found off; }\n\
    location = /robots.txt  { access_log off; log_not_found off; }\n\
    location ~ \\.php$ {\n\
        fastcgi_pass 127.0.0.1:9000;\n\
        fastcgi_index index.php;\n\
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;\n\
        fastcgi_param DOCUMENT_ROOT $realpath_root;\n\
        include fastcgi_params;\n\
    }\n\
    location ~ /\\.(?!well-known).* { deny all; }\n\
}\n' > /etc/nginx/sites-available/default

EXPOSE 8080

CMD php artisan config:clear && php artisan cache:clear && php artisan migrate --force && php-fpm -D && nginx -g "daemon off;"