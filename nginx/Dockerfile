# Используем Debian-based образ для лучшей поддержки безопасности
FROM nginx:1.27-bookworm

# Устанавливаем curl для health check
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Удаляем дефолтный контент
RUN rm -rf /usr/share/nginx/html/* && \
    rm -rf /tmp/*

# Копируем конфигурации
COPY nginx.conf /etc/nginx/nginx.conf
COPY security-headers.conf /etc/nginx/conf.d/security-headers.conf

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

# Health check для мониторинга
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]