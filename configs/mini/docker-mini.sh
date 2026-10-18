#!/bin/sh

docker run --rm --name plac-php-mini -w /app -v "$PWD/www:/app" -p 80:8000 php:8.4-cli-alpine php -S 0.0.0.0:8000

# If you are on Fedora/RHEL/CentOS with SELinux enabled, use the volume label variant:
# docker run --rm --name plac-php-mini -w /app -v "$PWD/www:/app:Z" -p 80:8000 php:8.4-cli-alpine php -S 0.0.0.0:8000
