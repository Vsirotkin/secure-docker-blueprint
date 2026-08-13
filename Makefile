.PHONY: help build up down restart logs ps

# Цвета для вывода
GREEN := \033[0;32m
BLUE := \033[0;34m
NC := \033[0m # No Color

help: ## Показать это сообщение
	@echo "$(BLUE)Доступные команды:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

build: ## Собрать все Docker образы
	docker compose build

up: ## Запустить все контейнеры
	docker compose up -d

down: ## Остановить и удалить контейнеры
	docker compose down

restart: ## Перезапустить контейнеры
	docker compose down && docker compose up -d

logs: ## Показать логи всех контейнеров
	docker compose logs -f

ps: ## Показать статус контейнеров
	docker compose ps