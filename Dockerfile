FROM richarvey/nginx-php-fpm:latest

COPY . .

ENV SKIP_COMPOSER=1
ENV WEBROOT=/var/www/html/public
ENV PHP_ERRORS_STDERR=1
ENV RUN_SCRIPTS=1
ENV REAL_IP_HEADER=1
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN composer install --optimize-autoloader --no-dev --no-scripts --no-interaction

CMD php artisan config:clear && php artisan cache:clear && php artisan migrate --force && /start.sh