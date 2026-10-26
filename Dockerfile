FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VERSION=1.8.3 \
    # Poetry НЕ создаёт виртуальное окружение: контейнер сам является изолированной средой
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_NO_INTERACTION=1

RUN pip install --no-cache-dir "poetry==${POETRY_VERSION}" \
    && poetry config virtualenvs.create false

WORKDIR /app

# Сначала только файлы зависимостей — слой с установкой кэшируется
COPY pyproject.toml poetry.lock* ./
RUN poetry install --only main --no-root

# Код приложения
COPY mysite/ ./mysite/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /app/mysite
EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
