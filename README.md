# Wait for TCP services on Docker

Docker image that waits for TCP services to be available.

Docker Hub repository: [mattsyms/wait-for](https://hub.docker.com/r/mattsyms/wait-for).

GitHub repository: [MattSyms/wait-for](https://github.com/MattSyms/wait-for).

## Usage

```txt
docker run mattsyms/wait-for <host:port> -t <seconds>
```

## Help

```txt
Wait for TCP services to be available.

Usage:
  wait-for [OPTIONS] <host:port> [<host:port>...]
  wait-for -h | --help

Arguments:
  <host:port>   Hostname (or IP address) and port number

Options:
  -t, --timeout <seconds>   Timeout in seconds
  -h, --help                Show help message

Exit status:
  0   Services available
  1   Timeout exceeded
```

## Examples

### Waiting for a TCP service

Checking the availability of `google.com` on port `443`, with no timeout:

```txt
docker run mattsyms/wait-for google.com:443
```

```txt
Waiting for services (no timeout)...
✓ google.com:443 (available after 0 seconds)
```

### Waiting for Docker services

Starting an `app` service when `mysql` and `redis` are available, with a timeout of `30` seconds:

```yml
services:
  app:
    image: alpine
    entrypoint: echo App started!
    depends_on:
      wait-for-services:
        condition: service_completed_successfully

  mysql:
    image: mysql
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: 1

  redis:
    image: redis

  wait-for-services:
    image: mattsyms/wait-for
    command: mysql:3306 redis:6379 -t 30
    depends_on:
      mysql:
        condition: service_started
      redis:
        condition: service_started
```

```txt
docker compose run app
```

```txt
Waiting for services (timeout: 30 seconds)...
✓ redis:6379 (available after 1 seconds)
✓ mysql:3306 (available after 8 seconds)
```

```txt
App started!
```

### Waiting for Docker services using a healthcheck

Starting an `app` service when `mysql` and `redis` are available, with a timeout of `30` seconds:

```yml
services:
  app:
    image: alpine
    entrypoint: echo App started!
    depends_on:
      wait-for-services:
        condition: service_healthy

  mysql:
    image: mysql
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: 1

  redis:
    image: redis

  wait-for-services:
    image: mattsyms/wait-for
    entrypoint: wait-forever
    healthcheck:
      test: wait-for mysql:3306 redis:6379
      timeout: 30s
      interval: 1s
      retries: 1
    depends_on:
      mysql:
        condition: service_started
      redis:
        condition: service_started
```

```txt
docker compose run app
```

```txt
Waiting forever...
```

```txt
Waiting for services (no timeout)...
✓ redis:6379 (available after 1 seconds)
✓ mysql:3306 (available after 8 seconds)
```

```txt
App started!
```
