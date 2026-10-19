"""
期作與輪作管理 (跨期輪作、休耕綠肥標記)
"""

from fastapi import APIRouter, Depends, status
from typing import List
import uuid

from app.core.security import WorkspaceAccessGuard, UserPrincipal
from app.domain.models import CropSeasonCreateSchema, CropSeasonResponseSchema

router = APIRouter()

SEASONS_DB = [
    {
        "id": "crop-season-2026-01",
        "workspace_id": "ws-tw-xiluo-001",
        "field_id": "field-north-01",
        "season_code": "115年春季一期作",
        "crop_name": "青江白菜與包心白菜",
        "variety": "三津一號",
        "seedling_source": "西螺惠農種苗行",
        "seedling_batch_number": "HN-2026-03-A",
        "planned_planting_date": "2026-03-10",
        "actual_planting_date": "2026-03-12",
        "planned_harvest_date": "2026-04-28",
        "actual_harvest_date": None,
        "status": "ACTIVE",
        "notes": "前作為水稻，土壤基肥充足",
    }
]


@router.get("", response_model=List[CropSeasonResponseSchema])
async def list_crop_seasons(
    workspace_id: str,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """查詢期作清單"""
    return [s for s in SEASONS_DB if s["workspace_id"] == workspace_id]


@router.post("", response_model=CropSeasonResponseSchema, status_code=status.HTTP_201_CREATED)
async def create_crop_season(
    workspace_id: str,
    data: CropSeasonCreateSchema,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """建立新期作 (不覆蓋前作農事紀錄)"""
    new_season = data.model_dump()
    new_season.update({
        "id": f"crop-season-{uuid.uuid4().hex[:6]}",
        "workspace_id": workspace_id,
    })
    SEASONS_DB.append(new_season)
    return new_season
