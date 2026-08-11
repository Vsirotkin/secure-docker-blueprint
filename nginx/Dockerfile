FROM nginx:1.25-alpine

RUN rm -rf /usr/share/nginx/html/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY security-headers.conf /etc/nginx/conf.d/security-headers.conf

# Создаем все необходимые директории, включая поддиректории для временных файлов
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

USER nginx

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]