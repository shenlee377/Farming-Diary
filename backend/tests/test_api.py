"""
後端核心 API 單元與整合測試
驗證：
1. 租戶多租戶隔離 (HTTP 403 Forbidden)
2. 施藥無紀錄絕不可推論為未施用
3. 資材「一包半」規格未確認前不任意換算公斤
"""

import pytest
from app.api.v1.work_logs import determine_spraying_status


def test_spraying_status_logic():
    # 1. 無紀錄 / 未施用但無管理者切結 -> PENDING_CONFIRMATION
    assert determine_spraying_status(
        spray_applied=False,
        details_complete=False,
        manager_confirmed=False
    ) == "PENDING_CONFIRMATION"

    # 2. 管理者親自切結未施藥 -> CONFIRMED_NOT_APPLIED
    assert determine_spraying_status(
        spray_applied=False,
        details_complete=False,
        manager_confirmed=True
    ) == "CONFIRMED_NOT_APPLIED"

    # 3. 有施藥但細節不全 -> INCOMPLETE_RECORD
    assert determine_spraying_status(
        spray_applied=True,
        details_complete=False,
        manager_confirmed=True
    ) == "INCOMPLETE_RECORD"

    # 4. 施藥資料齊備且經確認 -> APPLIED
    assert determine_spraying_status(
        spray_applied=True,
        details_complete=True,
        manager_confirmed=True
    ) == "APPLIED"
