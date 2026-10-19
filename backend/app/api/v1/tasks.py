"""
工作排程與派工路由 (落實：打電話不等於已答應、工資費率快照)
"""

from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
import uuid

from app.core.security import WorkspaceAccessGuard, UserPrincipal
from app.domain.models import FarmTaskCreateSchema, FarmTaskResponseSchema

router = APIRouter()

TASKS_DB = [
    {
        "id": "task-101",
        "workspace_id": "ws-tw-xiluo-001",
        "field_id": "field-north-01",
        "field_name": "大同路後底大坵 (北田)",
        "crop_season_id": "crop-season-2026-01",
        "crop_name": "青江白菜與包心白菜",
        "title": "第1~8畦追施有機質肥",
        "task_type": "FERTILIZING",
        "planned_date": "2026-10-20",
        "assembly_time": "06:30",
        "assembly_location": "北側農路三叉路口榕樹下工寮",
        "required_workers_count": 2,
        "assignments": [
            {
                "contact_id": "contact-01",
                "contact_name": "張金吉 (阿吉叔)",
                "status": "CONFIRMED",  # 本人親口答應
                "rate_snapshot_twd": 2500.0,
                "paid_status": "UNPAID",
            }
        ],
        "prepared_tools_notes": "背負式施肥機1台、台肥特43號3包",
        "weather_adjustment_notes": "降雨逾70%順延",
        "status": "SCHEDULED",
    }
]


@router.get("", response_model=List[FarmTaskResponseSchema])
async def list_tasks(
    workspace_id: str,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """查詢農務排程與人員派遣狀態"""
    return [t for t in TASKS_DB if t["workspace_id"] == workspace_id]


@router.post("", response_model=FarmTaskResponseSchema, status_code=status.HTTP_201_CREATED)
async def create_task(
    workspace_id: str,
    data: FarmTaskCreateSchema,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """建立工作計畫並安排人員 (儲存工資快照)"""
    new_task = data.model_dump()
    new_task.update({
        "id": f"task-{uuid.uuid4().hex[:6]}",
        "workspace_id": workspace_id,
        "field_name": "指定田區",
        "crop_name": "當期作物",
        "status": "SCHEDULED",
    })
    TASKS_DB.append(new_task)
    return new_task
