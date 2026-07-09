from contextlib import asynccontextmanager
from collections.abc import AsyncIterator

from fastapi import FastAPI

from app.database import init_db
from app.routes.auth import router as auth_router


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    init_db()
    yield


def create_app(*, init_database: bool = True) -> FastAPI:
    app_kwargs = {
        "title": "MegaMovies API",
        "version": "1.0.0",
        "description": "API de autenticacao de usuarios para app Android.",
    }
    if init_database:
        app_kwargs["lifespan"] = lifespan

    application = FastAPI(**app_kwargs)
    application.include_router(auth_router)
    return application


app = create_app()
