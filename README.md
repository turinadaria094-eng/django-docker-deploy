# Практическая работа 20 — публикация Django-приложения

Django-проект (магазин `shopapp`, блог `blogapp`, авторизация `myauth`), опубликованный на виртуальной машине Timeweb через Docker и Docker Compose.

## Что сделано

- Зависимости управляются через **Poetry** (`pyproject.toml`, `poetry.lock`).
- **Docker-образ** (`Dockerfile`): зависимости ставятся Poetry, при этом виртуальное окружение **не создаётся** — `POETRY_VIRTUALENVS_CREATE=false` и `poetry config virtualenvs.create false`.
- **Docker Compose** (`docker-compose.yml`): сервис `web` с политикой `restart: always`, порт `80 -> 8000`, постоянное хранилище (БД и загруженные файлы) в volume `app_data`.
- Настройки Django читаются из переменных окружения (`.env`): `DJANGO_DEBUG`, `DJANGO_SECRET_KEY`, `DJANGO_ALLOWED_HOSTS` и др. Для работы статики приложение запускается с `DJANGO_DEBUG=1`.
- Доступ к серверу и GitHub — по **SSH-ключам**.

## Запуск локально

```bash
cp .env.example .env
docker compose up -d --build
```

Приложение: http://localhost (для локального запуска добавьте `localhost` в `DJANGO_ALLOWED_HOSTS`, он там уже есть по умолчанию).

## Запуск без Docker (для разработки)

```bash
poetry install
cd mysite
python manage.py migrate
DJANGO_DEBUG=1 python manage.py runserver
```

## Деплой на сервер

```bash
ssh -i ~/.ssh/timeweb-server -p 2022 root@201.34.158.119
git clone git@github.com:<логин>/<репозиторий>.git app && cd app
cp .env.example .env && nano .env
docker compose up -d --build
```

## Полезные команды

```bash
docker compose ps            # статус
docker compose logs -f web   # логи
docker compose restart web   # перезапуск
docker compose down          # остановка
```

## Разделы приложения

| URL | Что там |
|-----|---------|
| `/` | редирект на `/shop/` |
| `/shop/` | магазин, товары, заказы |
| `/shop/api/products/` | REST API товаров |
| `/blog/` | статьи блога |
| `/myauth/` | авторизация |
| `/admin/` | админ-панель |
