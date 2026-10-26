#!/bin/sh
set -e

DATA_DIR="${DATA_DIR:-/data}"
mkdir -p "$DATA_DIR"

# Первый запуск: кладём стартовые картинки в постоянное хранилище
if [ ! -d "$MEDIA_ROOT" ]; then
    cp -r /app/mysite/uploads "$MEDIA_ROOT"
fi

FIRST_RUN=0
[ -f "$SQLITE_PATH" ] || FIRST_RUN=1

python manage.py migrate --noinput

if [ "$FIRST_RUN" = "1" ]; then
    python manage.py loaddata shopapp/fixtures/products-fixture.json || true
    if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
        python manage.py createsuperuser --noinput \
            --email "${DJANGO_SUPERUSER_EMAIL:-admin@example.com}" || true
    fi
fi

exec "$@"
