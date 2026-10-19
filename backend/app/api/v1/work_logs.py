"""
農務作業回報、資材俗稱規格換算與施藥安全判定路由
"""

from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
import uuid

from app.core.security import WorkspaceAccessGuard, UserPrincipal
from app.domain.models import FarmWorkLogCreateSchema, FarmWorkLogResponseSchema

router = APIRouter()

LOGS_DB = [
    {
        "id": "log-501",
        "workspace_id": "ws-tw-xiluo-001",
        "field_name": "大同路後底大坵 (北田)",
        "crop_name": "青江白菜與包心白菜",
        "activity_type": "中耕培土與基肥施用",
        "actual_start_time": "2026-10-15T06:30:00Z",
        "actual_end_time": "2026-10-15T11:00:00Z",
        "operator_names": ["林家豪", "張金吉 (阿吉叔)"],
        "work_area_description": "全區南側第1~6畦",
        "materials_used": [
            {
                "material_name": "台肥黑王一號有機質特43號複合肥料",
                "specification": "40公斤/包",
                "raw_input_quantity_text": "一包半 (現場拆封一整包加半包剩料)",
                "is_specification_confirmed": True,
                "standard_amount_kg": 60.0,
                "batch_number": "TF-202602-098",
            }
        ],
        "spraying_status": "CONFIRMED_NOT_APPLIED",
        "photo_urls": [
            "https://images.unsplash.com/photo-1592982537447-7440770cbfc9?auto=format&fit=crop&w=800&q=80"
        ],
        "original_raw_input": "阿吉叔今天早上6點半到，幫忙把南邊六畦培好土，用了特43一包半，沒有噴藥。",
        "status": "CONFIRMED",
    }
]


def determine_spraying_status(spray_applied: bool, details_complete: bool, manager_confirmed: bool) -> str:
    """
    施藥判定鐵律：
    無紀錄不等於未施用；
    未施用必須有管理者明確切結；
    有施用但缺少規格標為不完整。
    """
    if not spray_applied:
        if manager_confirmed:
            return "CONFIRMED_NOT_APPLIED"
        return "PENDING_CONFIRMATION"
    else:
        if details_complete and manager_confirmed:
            return "APPLIED"
        return "INCOMPLETE_RECORD"


@router.get("", response_model=List[FarmWorkLogResponseSchema])
async def list_work_logs(
    workspace_id: str,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """查詢正式農務紀錄履歷"""
    return [l for l in LOGS_DB if l["workspace_id"] == workspace_id]


@router.post("", response_model=FarmWorkLogResponseSchema, status_code=status.HTTP_201_CREATED)
async def create_work_log(
    workspace_id: str,
    data: FarmWorkLogCreateSchema,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """回報農務作業與資材扣抵"""
    calc_spray_status = determine_spraying_status(
        spray_applied=data.spray_applied,
        details_complete=data.chemical_details_complete,
        manager_confirmed=data.manager_confirmed_not_applied,
    )
    
    # 處理資材規格換算 (若規格未確認，則保持 standard_amount_kg 為 None，避免憑空猜測)
    processed_materials = []
    for m in data.materials_used:
        m_dict = m.model_dump()
        if not m.is_specification_confirmed:
            m_dict["standard_amount_kg"] = None
        processed_materials.append(m_dict)
    
    new_log = {
        "id": f"log-{uuid.uuid4().hex[:6]}",
        "workspace_id": workspace_id,
        "field_name": "指定田區",
        "crop_name": "當期作物",
        "activity_type": data.activity_type,
        "actual_start_time": data.actual_start_time,
        "actual_end_time": data.actual_end_time,
        "operator_names": data.operator_names,
        "work_area_description": data.work_area_description,
        "materials_used": processed_materials,
        "spraying_status": calc_spray_status,
        "photo_urls": data.photo_urls,
        "original_raw_input": data.original_raw_input,
        "status": "CONFIRMED",
    }
    LOGS_DB.append(new_log)
    return new_log
