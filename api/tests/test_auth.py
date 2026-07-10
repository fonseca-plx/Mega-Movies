from collections.abc import Generator

import pytest
from fastapi import HTTPException, Response
from fastapi.security import HTTPAuthorizationCredentials
from pydantic import ValidationError
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy.pool import StaticPool

from app.auth import get_current_user, get_token_payload
from app.database import Base
from app.routes.auth import login_user, logout_user, register_user
from app.schemas import UserCreate, UserLogin


@pytest.fixture()
def db() -> Generator[Session, None, None]:
    engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    Base.metadata.create_all(bind=engine)

    session = TestingSessionLocal()
    try:
        yield session
    finally:
        session.close()
        Base.metadata.drop_all(bind=engine)


def user_create(email: str = "ana@example.com") -> UserCreate:
    return UserCreate(
        full_name="Ana Silva",
        email=email,
        password="secret123",
        photo="https://example.com/ana.jpg",
    )


def register_sample_user(db: Session, email: str = "ana@example.com"):
    return register_user(user_create(email=email), db)


def login_sample_user(db: Session, password: str = "secret123") -> tuple[Response, object]:
    response = Response()
    user = login_user(UserLogin(email="ana@example.com", password=password), response, db)
    return response, user


def credentials_from_response(response: Response) -> HTTPAuthorizationCredentials:
    header = response.headers["authorization"]
    scheme, token = header.split(" ", 1)
    return HTTPAuthorizationCredentials(scheme=scheme, credentials=token)


def test_register_user_with_valid_data(db: Session) -> None:
    user = register_sample_user(db)

    assert user.id is not None
    assert user.full_name == "Ana Silva"
    assert user.email == "ana@example.com"
    assert user.photo == "https://example.com/ana.jpg"
    assert user.joined_at is not None
    assert user.password_hash != "secret123"


def test_register_rejects_duplicate_email(db: Session) -> None:
    register_sample_user(db)

    with pytest.raises(HTTPException) as exc_info:
        register_sample_user(db)

    assert exc_info.value.status_code == 409


def test_register_rejects_missing_required_fields() -> None:
    with pytest.raises(ValidationError):
        UserCreate.model_validate({"email": "ana@example.com"})


def test_login_with_valid_credentials_returns_token_header(db: Session) -> None:
    register_sample_user(db)

    response, user = login_sample_user(db)

    assert response.headers["authorization"].startswith("Bearer ")
    assert user.email == "ana@example.com"


def test_login_rejects_invalid_password(db: Session) -> None:
    register_sample_user(db)

    with pytest.raises(HTTPException) as exc_info:
        login_sample_user(db, password="wrong-password")

    assert exc_info.value.status_code == 401


def test_me_returns_logged_user_with_valid_token(db: Session) -> None:
    register_sample_user(db)
    response, _ = login_sample_user(db)
    credentials = credentials_from_response(response)

    payload = get_token_payload(credentials=credentials, db=db)
    current_user = get_current_user(payload=payload, db=db)

    assert current_user.email == "ana@example.com"


def test_me_rejects_missing_token(db: Session) -> None:
    with pytest.raises(HTTPException) as exc_info:
        get_token_payload(credentials=None, db=db)

    assert exc_info.value.status_code == 401


def test_logout_revokes_current_token(db: Session) -> None:
    register_sample_user(db)
    response, _ = login_sample_user(db)
    credentials = credentials_from_response(response)
    payload = get_token_payload(credentials=credentials, db=db)

    logout_response = logout_user(credentials=credentials, payload=payload, db=db)

    assert logout_response.message == "Logout successful"
    with pytest.raises(HTTPException) as exc_info:
        get_token_payload(credentials=credentials, db=db)
    assert exc_info.value.status_code == 401
