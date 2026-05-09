"""
config.py — Loads environment variables for Sapience AI Backend.
All secrets come from .env — never hardcode them here.
"""

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    APP_NAME: str = "Sapience AI Backend"
    ENVIRONMENT: str = "development"
    # Empty defaults so the server starts even without a .env file.
    # Supabase endpoints will return a clear error until these are set.
    SUPABASE_URL: str = ""
    SUPABASE_KEY: str = ""

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


# Single shared instance — import this everywhere
settings = Settings()
