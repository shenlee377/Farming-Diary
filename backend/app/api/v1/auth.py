"""
認證與 Token 交換端點
"""

from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel

router = APIRouter()


class TokenExchangeRequest(BaseModel):
    code: str
    code_verifier: str
    redirect_uri: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    expires_in: int = 3600
    user_id: str
    display_name: str


@router.post("/exchange", response_model=TokenResponse)
async def exchange_token(req: TokenExchangeRequest):
    """
    透過 OAuth Authorization Code + PKCE 交換內部 Session Token
    """
    if req.code == "dev_mock_code":
        return TokenResponse(
            access_token="token_user_lin_01",
            user_id="user-lin-01",
            display_name="林家豪 (青農返鄉)",
        )
    
    # 待對接正式咖啡廳 OAuth 伺服器
    raise HTTPException(
        status_code=status.HTTP_400_BAD_REQUEST,
        detail="未知的授權代碼 (Invalid authorization code)",
    )


@router.get("/me")
async def get_me():
    """回傳當前登入者資訊"""
    return {
        "user_id": "user-lin-01",
        "display_name": "林家豪",
        "email": "lin.farm@example.tw",
        "role": "OWNER",
    }
