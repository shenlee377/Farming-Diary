"""
領域資料模型 (Pydantic 2 Schemas)
嚴格落實：
1. 田區多對多關聯地號
2. 土地自填未查證標記
3. 外部雇工無 App 帳號標記、工作限制與工資快照
4. 農務回報「一包半」原文留存與換算
5. 施藥安全狀態嚴格判定
"""

from typing import List, Optional
from pydantic import BaseModel, Field


# 1. 土地與田區
class CadastralParcelSchema(BaseModel):
    cadastral_number: str = Field(..., description="地政地號，如雲林縣西螺鎮公館段0451-0000號")
    area_sq_meters: float = Field(..., description="登記面積 (平方公尺)")


class LandRelationshipSchema(BaseModel):
    owner_name: str = Field(..., description="所有權人名稱 (自填)")
    is_shared_ownership: bool = Field(False, description="是否共有")
    tenant_name: str = Field(..., description="承租人")
    actual_operator: str = Field(..., description="實際經營管理者")
    lease_period_start: Optional[str] = None
    lease_period_end: Optional[str] = None
    annual_rent_twd: Optional[float] = None
    special_agreements: Optional[str] = Field(None, description="水權分配或特約事項")
    verification_status: str = Field(
        "SELF_REPORTED_UNVERIFIED",
        description="確認狀態：SELF_REPORTED_UNVERIFIED / CONFIRMED"
    )
    confirmed_date: Optional[str] = None


class FieldCreateSchema(BaseModel):
    name: str = Field(..., description="田區慣用稱呼，如：溪底大坵")
    area_hectares: float = Field(..., description="管理面積 (公頃)")
    area_source: str = Field("MANUAL_INPUT", description="計算方法來源")
    cadastral_parcels: List[CadastralParcelSchema] = []
    land_relationship: LandRelationshipSchema
    water_source_description: str = Field("", description="水源與灌溉說明")
    assembly_point_description: str = Field("", description="集合點與出入口")
    boundary_coordinates: List[List[float]] = []  # [[lng, lat], ...]


class FieldResponseSchema(FieldCreateSchema):
    id: str
    workspace_id: str
    boundary_version: int = 1
    is_archived: bool = False


# 2. 期作
class CropSeasonCreateSchema(BaseModel):
    field_id: str
    season_code: str = Field(..., description="例如：115年春季一期作")
    crop_name: str = Field(..., description="作物名稱，例如：青江白菜")
    variety: str = Field("", description="品種")
    seedling_source: str = Field("", description="苗株來源")
    seedling_batch_number: Optional[str] = None
    planned_planting_date: str
    actual_planting_date: Optional[str] = None
    planned_harvest_date: str
    actual_harvest_date: Optional[str] = None
    status: str = Field("ACTIVE", description="PLANNING / ACTIVE / HARVESTING / CLOSED / FALLOW")
    notes: str = ""


class CropSeasonResponseSchema(CropSeasonCreateSchema):
    id: str
    workspace_id: str


# 3. 外部工作聯絡人 (免裝 App)
class WorkContactCreateSchema(BaseModel):
    full_name: str
    nickname: str = Field(..., description="慣用俗稱，如：阿吉叔")
    phone: str = Field(..., description="優先電話聯絡號碼")
    preferred_contact_method: str = "PHONE_CALL"
    group_leader_name: Optional[str] = None
    work_restrictions: str = Field("", description="本人確認工作限制，如不能久跪或搬重")
    default_daily_wage_twd: Optional[float] = None
    default_hourly_wage_twd: Optional[float] = None
    notes: str = ""


class WorkContactResponseSchema(WorkContactCreateSchema):
    id: str
    workspace_id: str
    has_app_account: bool = False  # 長輩或雇工無 App 帳號


# 4. 工作與派工安排
class TaskAssignmentSchema(BaseModel):
    contact_id: str
    contact_name: str
    status: str = Field("UNCONTACTED", description="UNCONTACTED / CONTACTED_PENDING / CONFIRMED / DECLINED / CHECKED_IN / COMPLETED")
    rate_snapshot_twd: float = Field(..., description="派工當次費率快照")
    paid_status: str = "UNPAID"


class FarmTaskCreateSchema(BaseModel):
    field_id: str
    crop_season_id: str
    title: str
    task_type: str = "FERTILIZING"
    planned_date: str
    assembly_time: str
    assembly_location: str
    required_workers_count: int = 1
    assignments: List[TaskAssignmentSchema] = []
    prepared_tools_notes: str = ""
    weather_adjustment_notes: Optional[str] = None


class FarmTaskResponseSchema(FarmTaskCreateSchema):
    id: str
    workspace_id: str
    field_name: str
    crop_name: str
    status: str = "SCHEDULED"


# 5. 農務回報與資材
class MaterialUsageSchema(BaseModel):
    material_name: str = Field(..., description="商品名或俗稱")
    specification: str = Field(..., description="包裝規格，如 40公斤/包")
    raw_input_quantity_text: str = Field(..., description="原始回報說法，如：一包半")
    is_specification_confirmed: bool = False
    standard_amount_kg: Optional[float] = None
    batch_number: Optional[str] = None


class FarmWorkLogCreateSchema(BaseModel):
    task_id: Optional[str] = None
    field_id: str
    crop_season_id: str
    activity_type: str
    actual_start_time: str
    actual_end_time: str
    operator_names: List[str]
    work_area_description: str
    materials_used: List[MaterialUsageSchema] = []
    spray_applied: bool = False
    chemical_details_complete: bool = False
    manager_confirmed_not_applied: bool = False
    photo_urls: List[str] = []
    original_raw_input: str = Field(..., description="口述或長輩原始回報原文")


class FarmWorkLogResponseSchema(BaseModel):
    id: str
    workspace_id: str
    field_name: str
    crop_name: str
    activity_type: str
    actual_start_time: str
    actual_end_time: str
    operator_names: List[str]
    work_area_description: str
    materials_used: List[MaterialUsageSchema]
    spraying_status: str  # CONFIRMED_NOT_APPLIED / APPLIED / PENDING_CONFIRMATION / INCOMPLETE_RECORD
    photo_urls: List[str]
    original_raw_input: str
    status: str = "CONFIRMED"
