from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, Response, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import jwt
from sqlalchemy.orm import Session

from app.auth import (
    JWT_ALGORITHM,
    JWT_SECRET_KEY,
    create_access_token,
    get_current_user,
    get_token_payload,
    hash_password,
    verify_password,
)
from app.database import get_db
from app.models import RevokedToken, User
from app.schemas import MessageResponse, UserCreate, UserLogin, UserPublic


router = APIRouter(prefix="/auth", tags=["auth"])
bearer_scheme = HTTPBearer()


@router.post("/register", response_model=UserPublic, status_code=status.HTTP_201_CREATED)
def register_user(payload: UserCreate, db: Session = Depends(get_db)) -> User:
    email = payload.email.lower()
    existing_user = db.query(User).filter(User.email == email).first()
    if existing_user is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email already registered",
        )

    user = User(
        full_name=payload.full_name,
        email=email,
        password_hash=hash_password(payload.password),
        photo=payload.photo,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@router.post("/login", response_model=UserPublic)
def login_user(payload: UserLogin, response: Response, db: Session = Depends(get_db)) -> User:
    email = payload.email.lower()
    user = db.query(User).filter(User.email == email).first()
    if user is None or not verify_password(payload.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )

    access_token = create_access_token(user)
    response.headers["Authorization"] = f"Bearer {access_token}"
    return user


@router.post("/logout", response_model=MessageResponse)
def logout_user(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    payload: dict = Depends(get_token_payload),
    db: Session = Depends(get_db),
) -> MessageResponse:
    token = credentials.credentials
    unverified_claims = jwt.get_unverified_claims(token)
    jti = payload["jti"]
    expires_at_timestamp = unverified_claims["exp"]
    expires_at = datetime.fromtimestamp(expires_at_timestamp, tz=timezone.utc)

    revoked_token = RevokedToken(jti=jti, expires_at=expires_at)
    db.add(revoked_token)
    db.commit()
    return MessageResponse(message="Logout successful")


@router.get("/me", response_model=UserPublic)
def get_logged_user(current_user: User = Depends(get_current_user)) -> User:
    return current_user
