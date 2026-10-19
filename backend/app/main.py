"""
農田日記 (Farmland Diary) - Python FastAPI 後端主程式
部署目標：Google Cloud Run (私有儲存庫)
"""

from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.v1 import (
    auth,
    workspaces,
    fields,
    crop_seasons,
    contacts,
    tasks,
    work_logs,
    storage,
    harvest,
    disasters,
    ai_assistant,
    inspection,
)
from app.core.config import settings

app = FastAPI(
    title="農田日記 (Farmland Diary) Core API",
    description="面向臺灣家庭農場與小型農業經營者的跨平台協作後端服務",
    version="1.0.0",
    docs_url="/docs" if settings.ENVIRONMENT != "production" else None,
    redoc_url=None,
)

# 跨域資源共享 (CORS) 設定
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 註冊 API 路由 (v1)
app.include_router(auth.router, prefix="/api/v1/auth", tags=["認證與身分"])
app.include_router(workspaces.router, prefix="/api/v1/workspaces", tags=["工作空間與租戶"])
app.include_router(fields.router, prefix="/api/v1/workspaces/{workspace_id}/fields", tags=["田區與土地關係"])
app.include_router(crop_seasons.router, prefix="/api/v1/workspaces/{workspace_id}/crop-seasons", tags=["期作與輪作"])
app.include_router(contacts.router, prefix="/api/v1/workspaces/{workspace_id}/contacts", tags=["外部工作聯絡人"])
app.include_router(tasks.router, prefix="/api/v1/workspaces/{workspace_id}/tasks", tags=["工作派工與人員安排"])
app.include_router(work_logs.router, prefix="/api/v1/workspaces/{workspace_id}/work-logs", tags=["農務作業回報與資材"])
app.include_router(storage.router, prefix="/api/v1/workspaces/{workspace_id}/storage", tags=["私有照片與檔案授權"])
app.include_router(harvest.router, prefix="/api/v1/workspaces/{workspace_id}/harvest", tags=["採收與出貨"])
app.include_router(disasters.router, prefix="/api/v1/workspaces/{workspace_id}/disasters", tags=["災害與保險案件"])
app.include_router(ai_assistant.router, prefix="/api/v1/workspaces/{workspace_id}/ai", tags=["AI農務助理"])
app.include_router(inspection.router, prefix="/api/v1/workspaces/{workspace_id}/inspection", tags=["巡田與品質閉環"])



@app.get("/healthz", status_code=status.HTTP_200_OK, tags=["系統維運"])
async def health_check():
    """Cloud Run 健康檢查端點"""
    return {"status": "ok", "app": "farmland-diary", "env": settings.ENVIRONMENT}
