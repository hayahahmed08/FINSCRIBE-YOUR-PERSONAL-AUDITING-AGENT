from pydantic_settings import BaseSettings
from dotenv import load_dotenv
import secrets
import os

load_dotenv()  # Load environment variables from .env file
class Settings(BaseSettings):
    SECRET_KEY: str=secrets.token_urlsafe(32)
    MONGO_URI: str

    MONGO_DB: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int =  1440

settings = Settings()