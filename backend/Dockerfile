# ============================================
# Stage 1: Builder - устанавливаем зависимости
# ============================================
FROM python:3.12-slim AS builder

# Устанавливаем системные зависимости для сборки psycopg2
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Копируем только файл зависимостей (для кеширования слоя)
COPY pyproject.toml .

# Устанавливаем зависимости в виртуальное окружение
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir .

# ============================================
# Stage 2: Runtime - минимальный production образ
# ============================================
FROM python:3.12-slim

# Устанавливаем только runtime зависимости (без build-tools)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libpq5 \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Создаем non-root пользователя
RUN groupadd -g 1000 django && \
    useradd -u 1000 -g django -m -s /bin/bash django

WORKDIR /app

# Копируем виртуальное окружение из builder stage
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Копируем код приложения
COPY manage.py .
COPY app ./app

# Создаем директории с правильными правами
RUN mkdir -p /app/staticfiles /app/logs && \
    chown -R django:django /app

# Переключаемся на non-root пользователя
USER django

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8000/api/health/ || exit 1

EXPOSE 8000

# Запуск через Uvicorn (ASGI)
CMD ["uvicorn", "app.asgi:application", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]