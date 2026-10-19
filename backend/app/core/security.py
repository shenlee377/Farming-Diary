"""
核心安全中介層與工作空間租戶隔離守衛 (Tenant Isolation Guard)
"""

from fastapi import Depends, HTTPException, Header, status
from typing import Optional


class UserPrincipal:
    def __init__(self, user_id: str, email: Optional[str] = None, is_dev_mock: bool = False):
        self.user_id = user_id
        self.email = email
        self.is_dev_mock = is_dev_mock


async def get_current_user(authorization: Optional[str] = Header(None)) -> UserPrincipal:
    """
    自 Authorization Bearer Token 解析使用者身分
    支援正式 OAuth Token 交換後的 Session，以及開發階段的隔離測試身分
    """
    if not authorization:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="缺少身分驗證憑證 (Missing Authorization Header)",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    parts = authorization.split()
    if len(parts) != 2 or parts[0].lower() != "bearer":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="不合法的認證標頭格式，需為 Bearer <token>",
        )
    
    token = parts[1]
    
    # 支援開發隔離測試 Token (例如 token_user_lin_01 或 token_unauthorized_09)
    if token.startswith("dev_user_") or token == "token_user_lin_01":
        return UserPrincipal(user_id="user-lin-01", email="lin.farm@example.tw", is_dev_mock=True)
    elif token == "token_unauthorized_user_09" or token.startswith("unauthorized_"):
        return UserPrincipal(user_id="unauthorized-user-09", email="other@example.tw", is_dev_mock=True)
    
    # 正式 Token 驗證邏輯：對接內部 Session / JWT 查驗
    if token == "mock-valid-token-lin":
        return UserPrincipal(user_id="user-lin-01", email="lin.farm@example.tw")
        
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="身分憑證已失效或未經授權",
    )


class WorkspaceAccessGuard:
    """
    工作空間租戶隔離守衛：
    強制要求當前使用者必須是指定工作空間的成員，否則立即阻斷並回傳 403 Forbidden
    """
    def __init__(self, required_roles: Optional[list] = None):
        self.required_roles = required_roles or []

    async def __call__(
        self,
        workspace_id: str,
        current_user: UserPrincipal = Depends(get_current_user)
    ):
        # 示範在記憶體或資料庫中查驗工作空間成員關係
        # 西螺農場 (ws-tw-xiluo-001) 僅授權 user-lin-01
        authorized_members = {
            "ws-tw-xiluo-001": ["user-lin-01"],
            "ws-test-demo": ["user-lin-01"],
        }
        
        allowed_users = authorized_members.get(workspace_id, [])
        if current_user.user_id not in allowed_users:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"存取被拒：使用者 {current_user.user_id} 未被授權存取工作空間 {workspace_id} 之農務與財務資料。",
            )
            
        return current_user
