# ==============================================================================
# Stage 1: Build the Vue 3 application
# ==============================================================================
FROM node:20-alpine AS build

WORKDIR /app

# Копируем только package.json для кэширования зависимостей
COPY package*.json ./

# Устанавливаем зависимости (ci гарантирует воспроизводимость)
RUN npm ci

# Копируем исходный код и собираем продакшн-билд
COPY . .
RUN npm run build

# ==============================================================================
# Stage 2: Serve with Nginx (Production-ready, minimal attack surface)
# ==============================================================================
FROM nginx:1.27-alpine AS production

# Копируем собранные статические файлы из этапа build
COPY --from=build /app/dist /usr/share/nginx/html

# Копируем кастомную конфигурацию nginx (создадим её на следующем шаге)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Nginx в alpine по умолчанию запускается от пользователя nginx (non-root)
# Дополнительно усиливаем безопасность
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

EXPOSE 80

USER nginx

CMD ["nginx", "-g", "daemon off;"]
