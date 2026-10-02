# Docker Config Summary

This summary compares the five Docker configs in `configs/apache`,
`configs/nginx`, `configs/small`, `configs/tiny`, and `configs/mini`.

## Image sizes

| Config | Images | Total size |
| --- | --- | ---: |
| `apache` | `php:8.4-apache` | 508.5 MB |
| `nginx` | `php:8.4-fpm` + `nginx:alpine` | 560.4 MB |
| `small` | `php:8.4-cli` | 539.3 MB |
| `tiny` | `php:8.4-cli-alpine` | 111.2 MB |
| `mini` | `php:8.4-cli-alpine` | 111.2 MB |

Breakdown:

- `php:8.4-apache`: 508.5 MB
- `php:8.4-fpm`: 498.0 MB
- `php:8.4-cli`: 539.3 MB
- `nginx:alpine`: 62.3 MB
- `php:8.4-cli-alpine`: 111.2 MB

## Quick benchmark

Method:

- started each config separately
- sent 100 sequential requests to `http://127.0.0.1/`
- measured `curl` `time_total`
- stopped each config before starting the next one

Results:

| Config | Avg | Min | Max |
| --- | ---: | ---: | ---: |
| `apache` | 0.637 ms | 0.438 ms | 10.291 ms |
| `nginx` | 0.673 ms | 0.594 ms | 1.359 ms |
| `small` | 0.435 ms | 0.383 ms | 0.640 ms |
| `tiny` | 0.453 ms | 0.374 ms | 0.758 ms |

## Notes

- The benchmark is a simple local smoke test, not a real load test.
- For this tiny PHP page, the performance differences are small enough to treat
  as noise.
- The original Debian-based images are close in size, but `tiny` is much
  smaller because it uses the Alpine-based `php:8.4-cli-alpine` image.

## Recommendation

Use `apache` as the practical default if the goal is a simple real web server
setup.

Keep `nginx` only if the goal is to demonstrate or test an nginx + PHP-FPM
architecture.

Use `small` for minimal local development only. It is fastest in this small
test, but it uses PHP's built-in development server and is less representative
of a real deployment.

Use `tiny` if image size matters most. It behaves like `small`, but uses Alpine
and reduces the image size from 539.3 MB to 111.2 MB.

Use `mini` if you want the absolute most minimal implementation: single run script,
using Alpine, with no Dockerfile or Docker Compose setup.
