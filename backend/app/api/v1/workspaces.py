"""
工作空間與租戶管理路由
"""

from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from pydantic import BaseModel
from app.core.security import get_current_user, UserPrincipal

router = APIRouter()


class WorkspaceCreate(BaseModel):
    name: str


class WorkspaceResponse(BaseModel):
    id: str
    name: str
    owner_user_id: str
    created_at: str
    user_role: str


# 記憶體示範儲存 (正式上線對接 PostgreSQL)
WORKSPACES_DB = [
    {
        "id": "ws-tw-xiluo-001",
        "name": "西螺大橋下青農合作社",
        "owner_user_id": "user-lin-01",
        "created_at": "2026-03-01T08:00:00Z",
        "user_role": "OWNER",
    }
]


@router.get("", response_model=List[WorkspaceResponse])
async def list_user_workspaces(current_user: UserPrincipal = Depends(get_current_user)):
    """列出當前使用者有權存取的工作空間"""
    return [ws for ws in WORKSPACES_DB if ws["owner_user_id"] == current_user.user_id]


@router.post("", response_model=WorkspaceResponse, status_code=status.HTTP_201_CREATED)
async def create_workspace(
    data: WorkspaceCreate,
    current_user: UserPrincipal = Depends(get_current_user),
):
    """建立新農場工作空間"""
    import uuid
    new_ws = {
        "id": f"ws-{uuid.uuid4().hex[:8]}",
        "name": data.name,
        "owner_user_id": current_user.user_id,
        "created_at": "2026-10-19T04:30:00Z",
        "user_role": "OWNER",
    }
    WORKSPACES_DB.append(new_ws)
    return new_ws
