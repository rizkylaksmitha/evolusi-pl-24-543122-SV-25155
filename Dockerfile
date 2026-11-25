FROM php:8.2-cli-alpine

WORKDIR /var/www

# 1. Pasang dependensi sistem, ekstensi PHP Laravel, dan Composer
RUN apk add --no-cache git unzip libzip-dev sqlite-dev oniguruma-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_sqlite mbstring zip bcmath

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 2. Salin daftar dependensi dulu dan pasang sebelum kode aplikasi disalin (agar layer cache bekerja)
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

# 3. Salin seluruh kode aplikasi (layer yang paling sering berubah ditaruh di bawah)
COPY . .

# 4. Selesaikan autoloader dan siapkan izin direktori storage & SQLite
RUN composer dump-autoload --optimize \
    && mkdir -p database storage/framework/cache storage/framework/sessions storage/framework/views storage/logs bootstrap/cache \
    && touch database/database.sqlite \
    && chmod -R 775 storage bootstrap/cache database

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]