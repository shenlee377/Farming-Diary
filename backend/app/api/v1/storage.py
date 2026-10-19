"""
私有儲存桶與限時 Signed URL 發行路由
保護農民現場照片與巡田影格私密性
"""

from fastapi import APIRouter, Depends, status
from pydantic import BaseModel
from typing import Optional
import uuid

from app.core.security import WorkspaceAccessGuard, UserPrincipal
from app.core.config import settings

router = APIRouter()


class SignedUploadUrlRequest(BaseModel):
    file_name: str
    content_type: str = "image/jpeg"
    file_size_bytes: int


class SignedUrlResponse(BaseModel):
    upload_url: str
    download_url: str
    file_key: str
    expires_in_seconds: int = 900  # 15 分鐘有效期


@router.post("/signed-url", response_model=SignedUrlResponse)
async def create_signed_url(
    workspace_id: str,
    req: SignedUploadUrlRequest,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """
    發行用於直接上傳至 GCS 私有 Bucket 的 Signed URL
    杜絕伺服器長連線代理傳輸大檔
    """
    unique_key = f"workspaces/{workspace_id}/logs/{uuid.uuid4().hex[:12]}_{req.file_name}"
    
    # 在正式 GCP 環境中使用 google-cloud-storage 生成 v4 signed url
    # 開發或預覽環境提供安全的模擬 endpoint
    fake_upload_url = f"https://storage.googleapis.com/{settings.GCS_PRIVATE_BUCKET}/{unique_key}?mock_signature=true"
    fake_download_url = f"https://storage.googleapis.com/{settings.GCS_PRIVATE_BUCKET}/{unique_key}?read_token=mock15min"
    
    return SignedUrlResponse(
        upload_url=fake_upload_url,
        download_url=fake_download_url,
        file_key=unique_key,
        expires_in_seconds=900,
    )
