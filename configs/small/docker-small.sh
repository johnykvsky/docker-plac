#!/bin/sh

docker build -t plac-php-small:latest .
docker run --rm --name plac-php-small -w /app -v "$PWD/www:/app" -p 80:8000 plac-php-small:latest php -S 0.0.0.0:8000

# If you are on Fedora/RHEL/CentOS with SELinux enabled, use the volume label variant:
# docker run --rm --name plac-php-small -w /app -v "$PWD/www:/app:Z" -p 80:8000 plac-php-small:latest php -S 0.0.0.0:8000