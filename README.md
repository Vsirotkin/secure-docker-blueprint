```markdown
# 🔒 Secure Docker Blueprint

[![CI/CD Pipeline](https://github.com/Vsirotkin/secure-docker-blueprint/actions/workflows/ci.yml/badge.svg)](https://github.com/Vsirotkin/secure-docker-blueprint/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Python 3.12](https://img.shields.io/badge/Python-3.12-green.svg)](https://www.python.org/downloads/)
[![Docker Compose](https://img.shields.io/badge/Docker-Compose-blue.svg)](https://docs.docker.com/compose/)

**Security-first Docker Compose stack for production-grade DevSecOps applications.**

A pet project demonstrating enterprise-level container orchestration with security best practices, automated testing, and comprehensive CI/CD pipeline.

---

## 📖 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Security Features](#-security-features)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Development](#-development)
- [Portfolio Purpose](#-portfolio-purpose)

---

## ✨ Features

- 🔐 **Security-First Design**: Non-root containers, read-only filesystems, network segmentation
- ️ **Automated Security Scanning**: Gitleaks, Trivy, pip-audit integration
- 🧪 **Comprehensive Testing**: pytest suite with 4+ tests, strict type checking with MyPy
- 📦 **Multi-Stage Builds**: Optimized Docker images with minimal attack surface
- 🔄 **CI/CD Automation**: GitHub Actions workflow with quality gates
-  **Production Ready**: Health checks, security headers, proper logging

---

## ️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Nginx 1.27                           │
│                    (Reverse Proxy)                          │
│              Security Headers + SSL/TLS                     │
└─────────────────────────┬───────────────────────────────────┘
                          │
                ┌─────────┴─────────┐
                │   Frontend Net    │
                └─────────┬─────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│                    Django 5.2 LTS                           │
│                  (Uvicorn ASGI Server)                      │
│              Read-Only + Non-Root User                      │
└─────────────────────────┬───────────────────────────────────┘
                          │
                ┌─────────┴─────────┐
                │   Backend Net     │
                └─────────┬─────────┘
                          │
─────────────────────────▼───────────────────────────────────┐
│                  PostgreSQL 16                              │
│                 (Debian Bookworm)                           │
│              Isolated Database Network                      │
─────────────────────────────────────────────────────────────┘
```

### Network Segmentation

- **Frontend Network**: Nginx ↔ Django communication
- **Backend Network**: Django ↔ PostgreSQL communication
- **Database Network**: PostgreSQL isolation (no direct external access)

---

## 🛠️ Tech Stack

### Backend
- **Python 3.12** - Latest stable Python
- **Django 5.2 LTS** - Long-term support release
- **Uvicorn** - ASGI server for async performance
- **uv** - Fast Python package manager (local development)

### Database
- **PostgreSQL 16** - Production-grade RDBMS
- **Debian Bookworm** - Minimal, secure base image

### Infrastructure
- **Docker Compose** - Container orchestration
- **Nginx 1.27** - High-performance reverse proxy
- **GitHub Actions** - CI/CD automation

### Security Tools
- **Gitleaks** - Secrets detection in code
- **Trivy** - Container vulnerability scanning
- **Syft** - SBOM (Software Bill of Materials) generation
- **pip-audit** - Python dependency auditing

### Code Quality
- **Ruff** - Lightning-fast linter and formatter
- **MyPy** - Strict static type checking
- **pytest** - Testing framework with django extension
- **pre-commit** - Git hooks automation

---

##  Security Features

### Container Security
- ✅ **Non-root user**: All containers run as unprivileged user (UID 1000)
- ✅ **Read-only filesystem**: Prevents runtime modifications
- ✅ **No new privileges**: `no-new-privileges:true` prevents privilege escalation
- ✅ **Dropped capabilities**: Minimal Linux capabilities
- ✅ **Multi-stage builds**: Smaller images, fewer vulnerabilities

### Network Security
- ✅ **Network segmentation**: Three isolated networks
- ✅ **No unnecessary ports**: Only essential ports exposed
- ✅ **Internal services**: Database not accessible from outside

### Application Security
- ✅ **Security headers**: HSTS, CSP, X-Frame-Options in Nginx
- ✅ **Health checks**: Container health monitoring
- ✅ **Environment variables**: Secrets via `.env` (not hardcoded)
- ✅ **Dependency scanning**: Automated vulnerability detection

### CI/CD Security
- ✅ **Pre-commit hooks**: Automated code quality checks
- ✅ **Secrets detection**: Gitleaks on every commit
- ✅ **Vulnerability scanning**: Trivy on Docker images
- ✅ **Branch protection**: Required status checks before merge

---

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose installed
- Make (optional, but recommended)
- Python 3.12+ (for local development)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Vsirotkin/secure-docker-blueprint.git
cd secure-docker-blueprint

# 2. Copy environment variables
cp .env.example .env

# 3. Edit .env with your credentials
nano .env

# 4. Build and start services
make build    # Build Docker containers
make up       # Start services
```

### Makefile Commands

| Command | Description |
|---------|-------------|
| `make build` | Build Docker containers |
| `make up` | Start all services |
| `make down` | Stop all services |
| `make ps` | Show container status |
| `make logs` | View logs |
| `make rebuild` | Rebuild and restart |
| `make format` | Auto-format code with Ruff |
| `make lint` | Check code style |
| `make typecheck` | Run MyPy type checking |
| `make test` | Run pytest test suite |
| `make audit` | Check dependencies for vulnerabilities |
| `make scan` | Run security scanners (Gitleaks, Trivy) |
| `make sbom` | Generate Software Bill of Materials |
| `make check` | Run all quality checks |

### Verify Installation

```bash
# Check if services are running
make ps

# Test API endpoint
curl http://localhost:8000/api/health

# View logs
make logs
```

---

##  Project Structure

```
secure-docker-blueprint/
├── .github/workflows/
│   └── ci.yml                 # CI/CD pipeline configuration
├── backend/
│   ├── Dockerfile             # Multi-stage Django build
│   ├── requirements.txt       # Python dependencies
│   ├── manage.py              # Django management script
│   └── config/                # Django project settings
│       ├── __init__.py
│       ├── asgi.py
│       ├── settings.py        # Security-hardened settings
│       ├── urls.py
│       └── wsgi.py
├── frontend/
│   └── (static files)         # Frontend assets
├── nginx/
│   ├── Dockerfile             # Nginx configuration
│   ── nginx.conf             # Security headers config
── .env.example               # Environment variables template
── .gitleaks.toml             # Gitleaks configuration
├── .pre-commit-config.yaml    # Pre-commit hooks
├── compose.yml                # Docker Compose configuration
├── Makefile                   # Automation commands
├── README.md                  # This file
└── LICENSE                    # MIT License
```

---

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

The pipeline runs on every push to `main` branch:

```yaml
jobs:
  test:
    - Run pytest test suite
    - Code quality checks (Ruff, MyPy)

  security:
    - Gitleaks: Secrets detection
    - Trivy: Container vulnerability scan
    - pip-audit: Dependency audit

  build:
    - Build Docker images
    - Generate SBOM with Syft
    - Push to registry (optional)
```

### Quality Gates

- ✅ All tests must pass
- ✅ No critical vulnerabilities
- ✅ No secrets detected
- ✅ Code style compliance
- ✅ Type checking passed

---

## 💻 Development

### Local Setup

```bash
# Install pre-commit hooks
pre-commit install

# Install dependencies (local)
uv sync

# Run tests
make test

# Run linter
make lint

# Run type checker
make typecheck
```

### Pre-Commit Hooks

Automatically run before each commit:
- ✅ Trailing whitespace removal
- ✅ End-of-file fixer
- ✅ YAML validation
- ✅ Ruff linting & formatting
- ✅ Gitleaks secrets detection

---

## 🎯 Portfolio Purpose

This project demonstrates:

1. **DevSecOps Best Practices**: Security integrated throughout the development lifecycle
2. **Container Security**: Hardened Docker configurations
3. **CI/CD Automation**: Automated testing and security scanning
4. **Infrastructure as Code**: Reproducible, version-controlled infrastructure
5. **Code Quality**: Strict linting, typing, and testing standards

### Key Achievements

- 🏆 **Zero critical vulnerabilities** in production images
-  **100% test coverage** of critical paths
- 🏆 **Production-grade security** headers and configurations
-  **Automated quality gates** preventing bad code from merging

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

This is a portfolio project. Contributions, feedback, and suggestions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📬 Contact

**Viktor Sirotkin**
📧 vsirotkin15@gmail.com
🐙 https://github.com/Vsirotkin

---

<div align="center">

**Built with ❤️ and security best practices**

[⬆ Back to Top](#-secure-docker-blueprint)

</div>
```

---

## 🇺 РУССКАЯ ВЕРСИЯ (для русскоязычных работодателей)

```markdown
---

## 📖 О Проекте (Russian Version)

**Secure Docker Blueprint** — это security-first Docker Compose стек для демонстрации навыков DevSecOps.

Пет-проект, демонстрирующий контейнерную оркестрацию корпоративного уровня с лучшими практиками безопасности, автоматизированным тестированием и комплексным CI/CD пайплайном.

###  Ключевые Возможности

-  **Безопасность прежде всего**: Контейнеры без root, read-only файловые системы, сегментация сетей
- 🛡️ **Автоматизированное сканирование**: Gitleaks, Trivy, pip-audit
- 🧪 **Тестирование**: pytest suite, строгая проверка типов MyPy
-  **Многоступенчатые сборки**: Оптимизированные Docker образы
- 🔄 **CI/CD автоматизация**: GitHub Actions с quality gates
- 🚀 **Production готовность**: Health checks, security headers

### 🏗️ Архитектура

```
┌─────────────────────────────────────────┐
│        Nginx 1.27 (Reverse Proxy)       │
│      Security Headers + SSL/TLS         │
└──────────────────┬──────────────────────┘
                   │
         ┌─────────┴─────────┐
         │   Frontend Net    │
         └─────────┬─────────┘
                   │
┌──────────────────▼──────────────────────┐
│      Django 5.2 LTS (Uvicorn ASGI)      │
│    Read-Only + Non-Root User            │
└──────────────────┬──────────────────────┘
                   │
         ┌─────────┴─────────┐
         │   Backend Net     │
         └─────────┬─────────┘
                   │
┌──────────────────▼──────────────────────┐
│         PostgreSQL 16                    │
│      (Debian Bookworm)                  │
│    Isolated Database Network            │
└─────────────────────────────────────────┘
```

### 🛡️ Функции Безопасности

**Безопасность контейнеров:**
- ✅ **Non-root user**: Все контейнеры работают как непривилегированный пользователь (UID 1000)
- ✅ **Read-only filesystem**: Предотвращает изменения во время выполнения
- ✅ **No new privileges**: `no-new-privileges:true` предотвращает эскалацию привилегий
- ✅ **Multi-stage builds**: Меньшие образы, меньше уязвимостей

**Сетевая безопасность:**
- ✅ **Сегментация сетей**: Три изолированные сети
- ✅ **Без лишних портов**: Открыты только необходимые порты
- ✅ **Внутренние сервисы**: База данных недоступна извне

**Безопасность приложений:**
- ✅ **Security headers**: HSTS, CSP, X-Frame-Options в Nginx
- ✅ **Health checks**: Мониторинг состояния контейнеров
- ✅ **Переменные окружения**: Секреты через `.env` (не захардкожены)

###  Быстрый Старт

```bash
# 1. Клонировать репозиторий
git clone https://github.com/Vsirotkin/secure-docker-blueprint.git
cd secure-docker-blueprint

# 2. Скопировать переменные окружения
cp .env.example .env

# 3. Отредактировать .env
nano .env

# 4. Собрать и запустить сервисы
make build    # Собрать Docker контейнеры
make up       # Запустить сервисы
```

### 🔧 Команды Makefile

| Команда | Описание |
|---------|----------|
| `make build` | Собрать Docker контейнеры |
| `make up` | Запустить все сервисы |
| `make down` | Остановить все сервисы |
| `make ps` | Показать статус контейнеров |
| `make logs` | Просмотр логов |
| `make rebuild` | Пересобрать и перезапустить |
| `make format` | Автоформатирование кода Ruff |
| `make lint` | Проверка стиля кода |
| `make typecheck` | Проверка типов MyPy |
| `make test` | Запустить тесты pytest |
| `make audit` | Проверка зависимостей на уязвимости |
| `make scan` | Запустить сканеры безопасности |
| `make check` | Запустить все проверки качества |

###  Структура Проекта

```
secure-docker-blueprint/
├── .github/workflows/ci.yml    # CI/CD pipeline
├── backend/
│   ├── Dockerfile              # Django build
│   ├── requirements.txt
│   ├── manage.py
│   └── config/                 # Django settings
├── nginx/
│   ├── Dockerfile
│   └── nginx.conf              # Security headers
├── compose.yml                 # Docker Compose
├── Makefile                    # Automation
├── .pre-commit-config.yaml     # Git hooks
└── README.md
```

### 🔄 CI/CD Pipeline

**GitHub Actions запускается при каждом пуше:**

- **test**: pytest, Ruff, MyPy
- **security**: Gitleaks, Trivy, pip-audit
- **build**: сборка Docker образов, генерация SBOM

**Quality Gates:**
- ✅ Все тесты должны пройти
- ✅ Нет критических уязвимостей
- ✅ Секреты не обнаружены
- ✅ Стиль кода соответствует
- ✅ Проверка типов пройдена

### 🎯 Цель Портфолио

Этот проект демонстрирует:

1. **DevSecOps лучшие практики**: Безопасность на протяжении всего цикла разработки
2. **Безопасность контейнеров**: Hardened Docker конфигурации
3. **CI/CD автоматизация**: Автоматизированное тестирование и сканирование
4. **Infrastructure as Code**: Воспроизводимая инфраструктура
5. **Качество кода**: Строгий линтинг, типизация и тестирование

**Ключевые достижения:**
-  **Нуль критических уязвимостей** в production образах
-  **100% покрытие тестами** критических путей
- 🏆 **Production-grade безопасность** headers и конфигурации
- 🏆 **Автоматизированные quality gates**

---

**Контакты:**
Виктор Сироткин
📧 vsirotkin15@gmail.com
🐙 https://github.com/Vsirotkin
```

---
