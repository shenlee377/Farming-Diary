"""
應用程式設定檔 (支援環境變數與 Google Secret Manager)
"""

from typing import List
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    ENVIRONMENT: str = "development"
    PROJECT_ID: str = "farmland-diary-prod"
    
    # 咖啡廳 OAuth 串接設定 (最小權限 account.read)
    CAFE_OAUTH_TOKEN_URL: str = "https://api.coffeeshop.tw/oauth/token"
    CAFE_OAUTH_VERIFY_URL: str = "https://api.coffeeshop.tw/oauth/verify"
    CAFE_CLIENT_ID: str = "tw.farmland.diary.flutter"
    
    # 資料庫連線 (Cloud SQL PostgreSQL + PostGIS)
    DATABASE_URL: str = "postgresql://postgres:postgres@localhost:5432/farmland_diary"
    
    # Google Cloud Storage 私有儲存桶
    GCS_PRIVATE_BUCKET: str = "farmland-diary-private-media"
    
    # CORS 允許來源
    CORS_ORIGINS: List[str] = [
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "farmlanddiary://",
    ]

    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
