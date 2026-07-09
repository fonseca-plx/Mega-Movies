# MegaMovies API

API simples de autenticacao de usuarios para app Android, feita com FastAPI, SQLite e JWT.

## Requisitos

- Python 3.10+

## Instalar dependencias

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Rodar a API

```bash
uvicorn app.main:app --reload
```

A documentacao interativa fica em:

- `http://127.0.0.1:8000/docs`
- `http://127.0.0.1:8000/redoc`

## Variaveis de ambiente

- `DATABASE_URL`: URL do banco. Padrao: `sqlite:///./megamovies.db`
- `JWT_SECRET_KEY`: chave usada para assinar tokens. Troque em producao.
- `JWT_ALGORITHM`: algoritmo JWT. Padrao: `HS256`
- `ACCESS_TOKEN_EXPIRE_MINUTES`: expiracao do token. Padrao: `60`

## Rotas

- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/logout`
- `GET /auth/me`

O login envia o token no cabecalho da resposta:

```http
Authorization: Bearer <token>
```

## Testes

```bash
pytest
```
