# ==========================================
# STAGE 1: Builder (Pasang Dependensi)
# ==========================================
FROM composer:2.8 AS builder

WORKDIR /app

# Salin daftar dependensi terlebih dahulu agar layer cache optimal
COPY composer.json composer.lock ./

RUN composer install \
    --no-dev \
    --no-scripts \
    --no-autoloader \
    --prefer-dist \
    --ignore-platform-reqs

# Salin seluruh kode aplikasi dan bangun autoloader optimal
COPY . .
RUN composer dump-autoload --optimize --no-dev


# ==========================================
# STAGE 2: Runtime (Image Produksi Ringan)
# ==========================================
FROM php:8.2-cli-alpine AS runtime

WORKDIR /var/www

# Pasang hanya pustaka runtime dan ekstensi PHP yang diperlukan Laravel
RUN apk add --no-cache sqlite-libs libzip oniguruma \
    && apk add --no-cache --virtual .build-deps sqlite-dev libzip-dev oniguruma-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_sqlite mbstring zip bcmath \
    && apk del .build-deps

# Buat user & group non-root agar container tidak berjalan sebagai root
RUN addgroup -g 1000 -S appgroup \
    && adduser -u 1000 -S appuser -G appgroup

# Salin hasil build (kode + vendor) dari stage builder dengan kepemilikan appuser
COPY --from=builder --chown=appuser:appgroup /app /var/www

# Siapkan direktori writable Laravel & file SQLite
RUN mkdir -p database storage/framework/cache storage/framework/sessions storage/framework/views storage/logs bootstrap/cache \
    && touch database/database.sqlite \
    && chown -R appuser:appgroup database storage bootstrap/cache \
    && chmod -R 775 database storage bootstrap/cache

# Beralih ke user non-root
USER appuser

EXPOSE 8000

# Healthcheck memeriksa kesiapan endpoint /api/bmi di dalam container
HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -qO- http://127.0.0.1:8000/api/bmi > /dev/null || exit 1

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]