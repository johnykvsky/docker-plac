# PHP Docker Environments

A lightweight local Docker setup for serving PHP applications on port `80`.

## Directory Overview

- **`current/`**: The active working directory used to run your current container setup. Contains the active compose file, run script, and document root (`www/`).
- **`configs/`**: Ready-to-use reference configurations:
  - **`apache`**: Real Apache web server using `php:8.4-apache` (single container).
  - **`nginx`**: Production-style stack with `php:8.4-fpm` + `nginx:alpine` (two containers).
  - **`small`**: Lightweight setup using PHP's built-in server on Debian (`php:8.4-cli`).
  - **`tiny`**: Ultra-compact setup using PHP's built-in server on Alpine (`php:8.4-cli-alpine`, ~111 MB).
  - **`mini`**: Bare-minimum setup with no Dockerfile or Compose file, running directly via a single script on Alpine.
  - Detailed comparisons and benchmarks can be found in [configs/info.md](configs/info.md) and [configs/benchmark.md](configs/benchmark.md).
- **`scripts/`**: Management scripts: project cleanup ([`prune_plac.sh`](scripts/prune_plac.sh)) and global scripts (`stop_all.sh`, `remove_all.sh`, `prune_all.sh`).

## Quick Start

1. Select a configuration from `configs/` and copy its files into `current/` (or use the currently selected configuration).
2. Start the server from `current/`:

   Using Docker Compose:
   ```sh
   cd current
   docker compose up
   ```

   Or using the helper script:
   ```sh
   cd current
   ./docker-small.sh
   ```

3. Open [http://localhost](http://localhost) in your browser.

> **Note:**
> - All configurations bind to host port `80`. Make sure to stop any running configuration before starting another.
> - The `docker-*.sh` helper scripts use `docker run --rm`, which automatically removes the container instance when you stop it (`Ctrl+C`) to prevent container name conflicts. This **only** removes the temporary container instance—downloaded Docker images (like `php:8.4-cli-alpine`) remain cached locally and are not re-downloaded on subsequent runs (unless you run [`scripts/prune_all.sh`](scripts/prune_all.sh)).
