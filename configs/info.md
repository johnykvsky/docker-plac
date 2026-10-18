# Docker configs

This directory contains five separate Docker examples for running the PHP app.
Each folder is self-contained and has its own `www` directory with the files
served by that config.

All configs expose the app on host port `80`, so run only one of them at a
time.

## Folders

### `apache`

Apache-based setup using the official `php:8.4-apache` image.

Contains:

- `Dockerfile`
- `docker-compose.yaml.apache`
- `docker-apache.sh`
- `www/`

The compose file starts one container (`plac-apache`) with Apache and PHP in the same image. It
mounts `apache/www` to `/var/www/html` in the container and publishes port `80`.

Use this when you want the simplest full web server setup.

Run with Docker Compose:

```sh
cd configs/apache
docker compose -f docker-compose.yaml.apache up
```

Run with the helper script:

```sh
cd configs/apache
./docker-apache.sh
```

### `nginx`

Nginx + PHP-FPM setup.

Contains:

- `Dockerfile.php`
- `Dockerfile.nginx`
- `docker-compose.yaml.nginx`
- `docker-nginx.sh`
- `nginx.conf`
- `www/`

The compose file starts two containers:

- `plac-php` running `php:8.4-fpm`
- `plac-nginx` running `nginx:alpine`

Both containers mount `nginx/www` to `/var/www/html`. The nginx container also
mounts `nginx.conf` as its site config and forwards PHP requests to the PHP-FPM
container.

Use this when you want a setup closer to a common nginx + PHP-FPM environment.

Run with Docker Compose:

```sh
cd configs/nginx
docker compose -f docker-compose.yaml.nginx up
```

Run with the helper script:

```sh
cd configs/nginx
./docker-nginx.sh
```

### `small`

Small PHP-only setup using the built-in PHP development server.

Contains:

- `Dockerfile`
- `docker-compose.yaml.small`
- `docker-small.sh`
- `www/`

The compose file starts one `php:8.4-cli` container (`plac-php-small`), mounts `small/www` to
`/app`, and runs:

```sh
php -S 0.0.0.0:8000
```

Host port `80` is mapped to container port `8000`.

Use this for the lightest local development setup. The PHP built-in server is
intended for development only.

Run with Docker Compose:

```sh
cd configs/small
docker compose -f docker-compose.yaml.small up
```

Run with the helper script:

```sh
cd configs/small
./docker-small.sh
```

### `tiny`

Tiny PHP-only setup using the built-in PHP development server on Alpine Linux.

Contains:

- `Dockerfile`
- `docker-compose.yaml.tiny`
- `docker-tiny.sh`
- `www/`

This is similar to `small`, but starts container `plac-php-tiny` using `php:8.4-cli-alpine` instead of
`php:8.4-cli`, making the image much smaller.

Run with Docker Compose:

```sh
cd configs/tiny
docker compose -f docker-compose.yaml.tiny up
```

Run with the helper script:

```sh
cd configs/tiny
./docker-tiny.sh
```

### `mini`

Bare-minimum PHP-only setup using the built-in PHP development server on Alpine Linux.
No `Dockerfile` and no `docker-compose.yaml` required.

Contains:

- `docker-mini.sh`
- `www/`

This setup directly runs the lightweight `php:8.4-cli-alpine` image without any build step or compose overhead. Once pulled on the first run, `php:8.4-cli-alpine` stays cached locally—subsequent runs reuse the local image without downloading it again.

Run with the helper script:

```sh
cd configs/mini
./docker-mini.sh
```

## Differences

| Folder | Containers | Web server | PHP runtime | Best for |
| --- | ---: | --- | --- | --- |
| `apache` | 1 | Apache | Apache PHP module | Simple local web server |
| `nginx` | 2 | nginx | PHP-FPM | nginx/FPM-style environment |
| `small` | 1 | PHP built-in server | PHP CLI | Minimal local development |
| `tiny` | 1 | PHP built-in server | PHP CLI on Alpine | Smallest image with Compose |
| `mini` | 1 | PHP built-in server | PHP CLI on Alpine | Most minimal setup (single script, no Compose/Dockerfile) |

## Notes

- Run commands from inside the selected config folder so the relative `./www`
  mount points resolve correctly.
- The `docker-*.sh` scripts run containers with `--rm`, so the container
  instance is automatically removed when stopped (`Ctrl+C`). This only removes
  the temporary container; the underlying Docker images remain cached locally
  and will not be re-downloaded on future runs.
- Stop any running container before starting another config on port `80`.
- On SELinux-enabled systems, use the `:Z` volume label variant shown in the
  small, tiny, and mini config/script comments.

## `php:8.4-cli` vs `php:8.4-cli-alpine`

Both images run PHP in CLI mode. The main difference is the Linux base image
underneath.

| Image | Base OS | Size in this test | Main tradeoff |
| --- | --- | ---: | --- |
| `php:8.4-cli` | Debian | 539.3 MB | Larger, more compatible |
| `php:8.4-cli-alpine` | Alpine Linux | 111.2 MB | Much smaller, sometimes less compatible |

Key differences:

- `php:8.4-cli` uses Debian and glibc.
- `php:8.4-cli-alpine` uses Alpine Linux and musl libc.
- Alpine is much smaller because the base OS and system libraries are minimal.
- Debian images are usually easier when adding native extensions, prebuilt
  binaries, debugging tools, and common Linux packages.
- Alpine can require extra work for PHP extensions or packages that assume
  glibc or Debian-style system libraries.

For this project, `php:8.4-cli-alpine` is enough for the tiny built-in PHP
server. If the app later needs more PHP extensions, Composer packages with
native dependencies, image processing, database clients, or debugging tools, the
Debian-based `php:8.4-cli` image may be smoother to work with.
