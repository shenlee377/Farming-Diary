# 農田日記 (Farmland Diary) - Python FastAPI 私有後端 Dockerfile
# 專為 Google Cloud Run 與 Cloud SQL (PostgreSQL+PostGIS) 最佳化

FROM python:3.11-slim

# 安裝 PostgreSQL 與 GDAL/GEOS 空間庫依賴
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libgeos-c1v5 \
    libgdal-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 先複製依賴清單利用 Docker 快取層
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 複製應用程式程式碼
COPY app ./app

# Cloud Run 預設監聽 PORT 環境變數 (預設 8080)
ENV PORT=8080
ENV PYTHONUNBUFFERED=1

EXPOSE 8080

CMD exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT} --workers 2
