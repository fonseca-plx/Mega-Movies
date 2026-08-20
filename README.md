# 🎬 Mega Movies

> **Mega Movies** é uma aplicação completa de exibição, exploração e recomendação de filmes, desenvolvida com uma experiência imersiva baseada no Design System **"Cinematic Noir"**. O projeto combina uma interface moderna em **Flutter** para múltiplas plataformas com uma API de autenticação em **FastAPI**.

---

## 📌 Sumário

- [Visão Geral](#-visão-geral)
- [Estrutura do Repositório](#-estrutura-do-repositório)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação e Execução](#-instalação-e-execução)
  - [1. Backend (API FastAPI)](#1-backend-api-fastapi)
  - [2. Frontend (App Flutter)](#2-frontend-app-flutter)
- [Documentação da API e Testes](#-documentação-da-api-e-testes)
- [Design System](#-design-system)
- [Licença](#-licença)

---

## 🎨 Visão Geral

O Mega Movies foi projetado para cinefilos e amantes do cinema que buscam uma interface fluida, minimalista e elegante. A aplicação permite explorar lançamentos, filmes em alta, pesquisar títulos e consultar detalhes enriquecidos (através da integração com a API do TMDB), além de contar com suporte a contas de usuário e persistência local.

---

## 📂 Estrutura do Repositório

```text
mega-movies/
├── api/          # Backend RESTful desenvolvido em Python (FastAPI + SQLite + JWT)
├── app/          # Aplicação Frontend desenvolvida em Flutter (Android, iOS, Web, Desktop)
├── docs/         # Documentação técnica e diretrizes de Design System (DESIGN.md)
└── README.md     # Documentação principal do projeto
```

---

## 🛠️ Tecnologias Utilizadas

### **Frontend (`app/`)**
- **[Flutter](https://flutter.dev/)** / **Dart** (v3.11.5+)
- **Gerenciamento de Estado**: `Provider`
- **Navegação Declarativa**: `go_router`
- **Persistência Local**: `drift` & `drift_flutter` (SQLite)
- **Armazenamento Seguro**: `flutter_secure_storage`
- **Consumo de API**: `http` (Integração com TMDB API e API local)
- **Tipografia & Estilização**: `google_fonts` (Noto Serif & Be Vietnam Pro) e suporte a Material 3.

### **Backend (`api/`)**
- **[FastAPI](https://fastapi.tiangolo.com/)** (Python 3.10+)
- **Servidor ASGI**: `uvicorn`
- **Banco de Dados**: SQLite3
- **Autenticação**: Tokens JWT (`python-jose`) e hash de senhas (`passlib` + `bcrypt`)
- **Testes**: `pytest`

---

## ⚙️ Pré-requisitos

Certifique-se de ter instalado em sua máquina:
- **[Python](https://www.python.org/)** (v3.10 ou superior)
- **[Flutter SDK](https://docs.flutter.dev/get-started/install)** (v3.11.5 ou superior)
- **[Git](https://git-scm.com/)**

---

## 🚀 Instalação e Execução

Clone este repositório em sua máquina local:

```bash
git clone https://github.com/fonseca-plx/Mega-Movies.git
cd mega-movies
```

### 1. Backend (API FastAPI)

O servidor backend é responsável pelo gerenciamento de usuários e autenticação.

```bash
# Navegar até a pasta da API
cd api

# Criar e ativar o ambiente virtual
python3 -m venv .venv
source .venv/bin/activate  # No Windows: .venv\Scripts\activate

# Instalar dependências
pip install -r requirements.txt

# Executar o servidor de desenvolvimento
uvicorn app.main:app --reload
```

A API estará rodando em `http://127.0.0.1:8000`.

### 2. Frontend (App Flutter)

Abra um novo terminal para executar o app Flutter:

```bash
# Navegar até a pasta do app
cd app

# Instalar dependências do Flutter
flutter pub get

# Executar a aplicação (Web, Linux, Android, etc.)
flutter run
```

---

## 🧪 Documentação da API e Testes

### Documentação Interativa da API
Com o backend em execução (`api`), você pode acessar a documentação interativa gerada pelo Swagger/OpenAPI em:
- **Swagger UI**: `http://127.0.0.1:8000/docs`
- **ReDoc**: `http://127.0.0.1:8000/redoc`

### Executando Testes

- **Backend (Pytest)**:
  ```bash
  cd api
  pytest
  ```

- **Frontend (Flutter Test)**:
  ```bash
  cd app
  flutter test
  ```

---

## 🎭 Design System ("Cinematic Noir")

A identidade visual do **Mega Movies** segue os princípios definidos no arquivo [`docs/DESIGN.md`](docs/DESIGN.md):
- **Estética imersiva**: Combinação de Minimalismo e Glassmorphism sobre um fundo "True Dark" (`#121317`).
- **Cores de Destaque**: Ouro Luxuoso (`#C5A059`) para status e avaliações, e Azul Metálico (`#2C5EAD`) para chamadas de ação (CTAs).
- **Tipografia Cuidadosa**: **Noto Serif** para títulos de filmes e seções institucionais; **Be Vietnam Pro** para metadados, descrições e controles de UI.

---

## 📝 Licença

Este projeto é desenvolvido para fins educacionais e de estudo. Todos os direitos de dados de filmes pertencem à [TMDB API](https://www.themoviedb.org/).
