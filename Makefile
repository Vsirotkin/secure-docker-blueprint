.PHONY: help build up down restart logs ps secrets scan sbom rebuild format lint typecheck test audit check

# Цвета для вывода
GREEN := \033[0;32m
BLUE := \033[0;34m
NC := \033[0m # No Color

help: ## Показать это сообщение
	@echo "$(BLUE)Доступные команды:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

build: ## Собрать все Docker образы
	docker compose build

up: ## Запустить все контейнеры (с пересборкой)
	docker compose up -d --build

down: ## Остановить и удалить контейнеры
	docker compose down

restart: ## Перезапустить контейнеры
	docker compose down && docker compose up -d

logs: ## Показать логи всех контейнеров
	docker compose logs -f

ps: ## Показать статус контейнеров
	docker compose ps

secrets: ## Сканировать код на утечку секретов (Gitleaks)
	@echo "$(BLUE)Сканирование на утечки секретов...$(NC)"
	gitleaks detect --source . --no-git --config .gitleaks.toml -v

scan: ## Сканировать Docker-образы на уязвимости (Trivy)
	@echo "$(BLUE)Сканирование образа nginx...$(NC)"
	trivy image --severity CRITICAL,HIGH secure-docker-blueprint-nginx:latest
	@echo ""
	@echo "$(BLUE)Сканирование образа backend...$(NC)"
	trivy image --severity CRITICAL,HIGH secure-docker-blueprint-backend:latest
	@echo ""
	@echo "$(BLUE)Сканирование образа postgres...$(NC)"
	trivy image --severity CRITICAL,HIGH postgres:16-bookworm

sbom: ## Генерировать SBOM для всех Docker-образов (Syft)
	@mkdir -p sbom
	@echo "$(BLUE)Генерация SBOM для nginx...$(NC)"
	syft scan secure-docker-blueprint-nginx:latest -o cyclonedx-json > sbom/nginx-sbom.json
	@echo "$(GREEN)✓ Сохранено: sbom/nginx-sbom.json$(NC)"
	@echo ""
	@echo "$(BLUE)Генерация SBOM для backend...$(NC)"
	syft scan secure-docker-blueprint-backend:latest -o cyclonedx-json > sbom/backend-sbom.json
	@echo "$(GREEN)✓ Сохранено: sbom/backend-sbom.json$(NC)"
	@echo ""
	@echo "$(BLUE)Генерация SBOM для postgres...$(NC)"
	syft scan postgres:16-bookworm -o cyclonedx-json > sbom/postgres-sbom.json
	@echo "$(GREEN)✓ Сохранено: sbom/postgres-sbom.json$(NC)"
	@echo ""
	@echo "$(GREEN)Все SBOM сгенерированы в папке sbom/$(NC)"

rebuild: ## Полная пересборка всех образов (удаление и сборка заново)
	docker compose down --rmi all
	docker compose up -d --build

# ============================================
# Code Quality Commands (работают локально через uv)
# ============================================
format: ## Отформатировать код с помощью Ruff
	@echo "$(BLUE)Форматирование кода...$(NC)"
	cd backend && uv run ruff format .
	@echo "$(GREEN)✓ Код отформатирован$(NC)"

lint: ## Проверить код с помощью Ruff
	@echo "$(BLUE)Проверка стиля кода...$(NC)"
	cd backend && uv run ruff check .
	@echo "$(GREEN)✓ Проверка стиля пройдена$(NC)"

typecheck: ## Проверить типы с помощью MyPy
	@echo "$(BLUE)Проверка типов...$(NC)"
	cd backend && uv run mypy .
	@echo "$(GREEN)✓ Проверка типов пройдена$(NC)"

test: ## Запустить тесты
	@echo "$(BLUE)Запуск тестов...$(NC)"
	cd backend && uv run pytest -v
	@echo "$(GREEN)✓ Все тесты пройдены$(NC)"

audit: ## Проверить зависимости на уязвимости
	@echo "$(BLUE)Проверка зависимостей на уязвимости...$(NC)"
	cd backend && uv run pip-audit
	@echo "$(GREEN)✓ Проверка зависимостей завершена$(NC)"

check: ## Запустить все проверки (format + lint + typecheck + test + audit)
	@echo "$(BLUE)Запуск полной проверки кода...$(NC)"
	@make format
	@make lint
	@make typecheck
	@make test
	@make audit
	@echo "$(GREEN)✓ Все проверки пройдены успешно!$(NC)"