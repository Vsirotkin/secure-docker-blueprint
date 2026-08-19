# ==============================================================================
# Stage 1: Build Vue 3 frontend
# ==============================================================================
FROM node:20-alpine AS frontend-builder

WORKDIR /app

# Копируем только package.json для кэширования слоев Docker
COPY frontend/package*.json ./

# Устанавливаем зависимости с retry-логикой для стабильности сети
RUN npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 20000 && \
    npm config set fetch-retry-maxtimeout 120000 && \
    npm ci --prefer-offline --no-audit

# Копируем исходники и собираем production-билд
COPY frontend/ .
RUN npm run build

# ==============================================================================
# Stage 2: Production nginx (serves frontend + proxies API)
# ==============================================================================
FROM nginx:1.27-bookworm

# Устанавливаем curl для health check
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Удаляем дефолтный контент
RUN rm -rf /usr/share/nginx/html/* && \
    rm -rf /tmp/*

# Копируем собранный Vue из этапа frontend-builder
COPY --from=frontend-builder /app/dist /usr/share/nginx/html

# Копируем конфигурации
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/security-headers.conf /etc/nginx/conf.d/security-headers.conf

# Создаем необходимые директории и устанавливаем правильные права
RUN mkdir -p /var/cache/nginx/client_temp \
             /var/cache/nginx/proxy_temp \
             /var/cache/nginx/fastcgi_temp \
             /var/cache/nginx/scgi_temp \
             /var/cache/nginx/uwsgi_temp \
             /var/run/nginx \
             /var/log/nginx \
             /tmp/nginx && \
    chown -R nginx:nginx /var/cache/nginx /var/run/nginx /var/log/nginx /tmp/nginx /etc/nginx/conf.d && \
    chmod -R 755 /var/cache/nginx /var/run/nginx /var/log/nginx /tmp/nginx

# Переключаемся на non-root пользователя
USER nginx

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
