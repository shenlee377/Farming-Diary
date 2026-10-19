"""
手機巡田單機採集、多裝置能力分級與雲端品質閉環 API
落實九階段狀態機：LOCAL_SAVED -> READY
"""

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import List, Optional
import uuid

from app.core.security import WorkspaceAccessGuard, UserPrincipal

router = APIRouter()

# 巡田工作階段資料庫 (記憶體示範)
SESSIONS_DB = [
    {
        "id": "session-insp-20261019-01",
        "workspace_id": "ws-tw-xiluo-001",
        "field_id": "field-north-01",
        "field_name": "大同路後底大坵 (北田)",
        "operator_name": "林家豪",
        "started_at": "2026-10-19 06:45",
        "device_tier": "TIER_1_DEPTH_AR",  # iOS ARKit / Android ARCore Depth
        "total_frames_captured": 42,
        "valid_frames_count": 40,
        "quality_status": "PASSED",  # 採集通過 (上傳完成不等於採集通過，採集通過不等於成果就緒)
        "reshoot_tasks": [
            {
                "id": "reshoot-01",
                "session_id": "session-insp-20261019-01",
                "field_segment": "北田第 4 畦西側田埂",
                "reason": "PERSON_OCCLUSION_UNREPLACEABLE",
                "missing_content_description": "工班人員提桶經過遮蔽作物中心，且無其他真實相鄰影格可替代",
                "suggested_heading_degrees": 285,
                "priority": "HIGH",
                "status": "RESOLVED",
                "resolved_frame_id": "frame-041",
            }
        ],
        "cloud_quality_report": {
            "coverage_percent": 94.5,
            "average_blur_score": 182.4,
            "occlusion_handled_ratio": "3處遮擋：2處替代真實影格，1處完成補拍",
            "is_ready_for_3d_or_ai": True,
        },
    }
]


class StartSessionRequest(BaseModel):
    field_id: str
    device_tier: str  # TIER_1_DEPTH_AR / TIER_2_POSE_TRACKING / TIER_3_BASIC_CAMERA_GPS


class FrameUploadNotify(BaseModel):
    frame_id: str
    timestamp: str
    blur_score: float
    is_person_occluded: bool
    heading_deg: float


@router.get("/sessions")
async def list_inspection_sessions(
    workspace_id: str,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """查詢巡田工作階段與品質審核報告"""
    return [s for s in SESSIONS_DB if s["workspace_id"] == workspace_id]


@router.post("/sessions", status_code=status.HTTP_201_CREATED)
async def start_inspection_session(
    workspace_id: str,
    req: StartSessionRequest,
    user: UserPrincipal = Depends(WorkspaceAccessGuard()),
):
    """啟動新的單機巡田採集工作階段"""
    new_session = {
        "id": f"session-{uuid.uuid4().hex[:8]}",
        "workspace_id": workspace_id,
        "field_id": req.field_id,
        "field_name": "指定田區",
        "operator_name": user.user_id,
        "started_at": "2026-10-19 12:00",
        "device_tier": req.device_tier,
        "total_frames_captured": 0,
        "valid_frames_count": 0,
        "quality_status": "LOCAL_SAVED",
        "reshoot_tasks": [],
    }
    SESSIONS_DB.append(new_session)
    return new_session
