# 農田日記 (Farmland Diary) - Python FastAPI 私有後端

> ⚠️ **私人儲存庫聲明**：本儲存庫為「農田日記」私有伺服器端核心程式碼，僅供私人維護與 Google Cloud Run 部署使用，不對外公開。

---

## 🛠️ 技術架構
- **API 框架：** Python 3.11 + FastAPI + Pydantic v2
- **空間與資料庫：** PostgreSQL + PostGIS + SQLAlchemy
- **檔案物件儲存：** Google Cloud Storage (私有儲存桶，15 分鐘 Signed URL 限時讀寫)
- **部署目標：** Google Cloud Run (Container Service / Jobs)
- **身分整合：** 咖啡廳 OAuth 2.0 PKCE (`account.read` 最小權限，內部獨立 pairwise sub 對應)

---

## 🚀 本地開發啟動

### 1. 建立虛擬環境與安裝依賴
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 2. 啟動本機伺服器
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```
- API 文件：`http://localhost:8080/docs`
- 健康檢查端點：`http://localhost:8080/healthz`

### 3. 執行單元與安全測試
```bash
pytest backend/tests/
```

---

## 🐳 Docker 與 Google Cloud Run 部署

### 1. 本機建置 Docker 映像檔
```bash
docker build -t gcr.io/YOUR_PROJECT_ID/farmland-diary-api:v1.0.0 .
```

### 2. 推送至 Google Artifact Registry / Container Registry
```bash
docker push gcr.io/YOUR_PROJECT_ID/farmland-diary-api:v1.0.0
```

### 3. 部署至 Google Cloud Run
```bash
gcloud run deploy farmland-diary-api \
    --image gcr.io/YOUR_PROJECT_ID/farmland-diary-api:v1.0.0 \
    --platform managed \
    --region asia-east1 \
    --allow-unauthenticated \
    --min-instances 0 \
    --max-instances 5 \
    --memory 512Mi \
    --cpu 1 \
    --set-env-vars ENVIRONMENT=production,GCS_PRIVATE_BUCKET=farmland-diary-prod-media
```

---

## 🔒 核心安全規範
1. **租戶隔離守衛：** 每個 API 端點均經由 `WorkspaceAccessGuard` 攔截，若跨租戶存取一律回傳 `403 Forbidden`。
2. **施藥安全鐵律：** 沒有施藥紀錄絕對不可推論為沒有施用；未施用必須具備經營者切結。
3. **資材換算留存：** 原始語音或長輩口述「一包半」一律留存原文，僅在規格確認後方能換算公斤數。
