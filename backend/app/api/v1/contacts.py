"""
外部工作聯絡人路由 (免裝 App、電話優先、工作限制與工資快照)
"""

from fastapi import APIRouter, Depends, status
from typing import List
import uuid

from app.core.security import WorkspaceAccessGuard, UserPrincipal
from app.domain.models import WorkContactCreateSchema, WorkContactResponseSchema

router = APIRouter()

CONTACTS_DB = [
    {
        "id": "contact-01",
        "workspace_id": "ws-tw-xiluo-001",
        "full_name": "張金吉",
        "nickname": "阿吉叔 (整地大師)",
        "phone": "0912-345-678",
        "preferred_contact_method": "PHONE_CALL",
        "group_leader_name": "西螺工班第一組",
        "work_restrictions": "不能久跪，不接挑重逾30公斤作業",
        "default_daily_wage_twd": 2500.0,
        "default_hourly_wage_twd": 320.0,
        "has_app_account": False,  # 外部長輩與工班無需 App 帳號
        "notes": "早上7點前打電話最容易聯絡到，慣用台語溝通。",
    }
]


@router.get("", response_model=List[WorkContactResponseSchema])
async def list_contacts(
    workspace_id: str,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """取得外部工作聯絡人清單"""
    return [c for c in CONTACTS_DB if c["workspace_id"] == workspace_id]


@router.post("", response_model=WorkContactResponseSchema, status_code=status.HTTP_201_CREATED)
async def create_contact(
    workspace_id: str,
    data: WorkContactCreateSchema,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """新增外部聯絡人 (免登入、記錄工作限制)"""
    new_contact = data.model_dump()
    new_contact.update({
        "id": f"contact-{uuid.uuid4().hex[:6]}",
        "workspace_id": workspace_id,
        "has_app_account": False,
    })
    CONTACTS_DB.append(new_contact)
    return new_contact
