# 🔒 Secure Docker Blueprint

[![CI/CD Pipeline](https://github.com/Vsirotkin/secure-docker-blueprint/actions/workflows/ci.yml/badge.svg)](https://github.com/Vsirotkin/secure-docker-blueprint/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**Security-first Docker Compose stack for production-grade DevSecOps applications.**

A pet project demonstrating enterprise-level container orchestration with security best practices, automated testing, and comprehensive CI/CD pipeline.

---

## ✨ Features
- 🔐 **Security-First Design**: Non-root containers, read-only filesystems, network segmentation
- 🛡️ **Automated Security Scanning**: Gitleaks, Trivy, pip-audit integration
- 🧪 **Comprehensive Testing**: pytest suite, strict type checking with MyPy
- 🔄 **CI/CD Automation**: GitHub Actions workflow with quality gates

---

## 🏗️ Architecture
- **Frontend Network**: Nginx ↔ Django
- **Backend Network**: Django ↔ PostgreSQL
- **Database Network**: PostgreSQL isolation

---

## 🛠️ Tech Stack
- **Backend**: Python 3.12, Django 5.2 LTS, Uvicorn
- **Database**: PostgreSQL 16 (Debian Bookworm)
- **Infrastructure**: Docker Compose, Nginx 1.27, GitHub Actions
- **Security**: Gitleaks, Trivy, Syft (SBOM), pip-audit

---

## 🛡️ Security Features
- ✅ **Non-root user**: All containers run as unprivileged user (UID 1000)
- ✅ **Read-only filesystem**: Prevents runtime modifications
- ✅ **No new privileges**: `no-new-privileges:true`
- ✅ **Network segmentation**: Three isolated networks

---

## 🚀 Quick Start
```bash
git clone https://github.com/Vsirotkin/secure-docker-blueprint.git
cd secure-docker-blueprint
cp .env.example .env
make build && make up
```

---

## 📁 Project Structure
- `.github/workflows/` — CI/CD pipeline
- `backend/` — Django application
- `nginx/` — Reverse proxy
- `compose.yml` — Docker Compose
- `Makefile` — Automation

---

## 🇷🇺 О Проекте (Russian Version)
**Secure Docker Blueprint** — security-first Docker Compose стек для демонстрации навыков DevSecOps.

### 🔑 Ключевые возможности
- 🔐 **Безопасность**: Контейнеры без root, read-only ФС, сегментация сетей
- 🛡️ **Сканирование**: Gitleaks, Trivy, pip-audit
- 🧪 **Тестирование**: pytest, строгая типизация MyPy
- 🔄 **CI/CD**: GitHub Actions с quality gates

---
**Контакты:** Виктор Сироткин | 📧 vsirotkin15@gmail.com | 🐙 [GitHub](https://github.com/Vsirotkin)
```
