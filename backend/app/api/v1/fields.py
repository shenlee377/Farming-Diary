"""
田區、地號多對多關聯與土地共有關係管理
"""

from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
import uuid

from app.core.security import WorkspaceAccessGuard, UserPrincipal
from app.domain.models import FieldCreateSchema, FieldResponseSchema

router = APIRouter()

# 示範儲存庫
FIELDS_DB = [
    {
        "id": "field-north-01",
        "workspace_id": "ws-tw-xiluo-001",
        "name": "大同路後底大坵 (北田)",
        "area_hectares": 0.85,
        "area_source": "GPS_TRACK_ESTIMATE",
        "land_relationship": {
            "owner_name": "陳黃阿雀 (祭祀公業管理人)",
            "is_shared_ownership": True,
            "tenant_name": "林慶忠 (阿忠伯)",
            "actual_operator": "林家豪 (青農返鄉)",
            "lease_period_start": "2024-01-01",
            "lease_period_end": "2028-12-31",
            "annual_rent_twd": 32000.0,
            "special_agreements": "三期水稻後需種植田菁綠肥以滋養地力，水圳清理費用雙方各半。",
            "verification_status": "CONFIRMED_WITH_LANDOWNER",
            "confirmed_date": "2024-02-15",
        },
        "cadastral_parcels": [
            {"cadastral_number": "雲林縣西螺鎮公館段 0451-0000 號", "area_sq_meters": 5200.0},
            {"cadastral_number": "雲林縣西螺鎮公館段 0452-0000 號", "area_sq_meters": 3300.0},
        ],
        "water_source_description": "濁水溪引水道第五支線 + 備用深井馬達",
        "assembly_point_description": "北側農路三叉路口鐵皮工寮前榕樹下",
        "boundary_version": 3,
        "boundary_coordinates": [[120.4632, 23.7845], [120.4645, 23.7848], [120.4648, 23.7832]],
        "is_archived": False,
    }
]


@router.get("", response_model=List[FieldResponseSchema])
async def list_fields(
    workspace_id: str,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """取得田區清單 (強制執行租戶隔離)"""
    return [f for f in FIELDS_DB if f["workspace_id"] == workspace_id and not f["is_archived"]]


@router.post("", response_model=FieldResponseSchema, status_code=status.HTTP_201_CREATED)
async def create_field(
    workspace_id: str,
    data: FieldCreateSchema,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """新增管理田區 (支援地號多對多與自填土地確權標記)"""
    new_field = data.model_dump()
    new_field.update({
        "id": f"field-{uuid.uuid4().hex[:6]}",
        "workspace_id": workspace_id,
        "boundary_version": 1,
        "is_archived": False,
    })
    FIELDS_DB.append(new_field)
    return new_field
