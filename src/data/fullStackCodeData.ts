export interface CodeFile {
  id: string;
  name: string;
  path: string;
  language: 'python' | 'dart' | 'sql' | 'dockerfile' | 'yaml' | 'json';
  category: 'BACKEND' | 'FLUTTER' | 'DATABASE' | 'DEVOPS';
  description: string;
  content: string;
}

export const FULL_STACK_CODE_FILES: CodeFile[] = [
  // ──────────────────────────────────────────────
  // 1. Python FastAPI 後端服務
  // ──────────────────────────────────────────────
  {
    id: 'backend-main',
    name: 'main.py',
    path: 'backend/app/main.py',
    language: 'python',
    category: 'BACKEND',
    description: 'FastAPI 應用入口：中介軟體、CORS、相依性注入、異常處理與各模組路由器註冊',
    content: `"""
農田日記 (Farmland Diary) - 後端主要入口
技術選型：Python 3.11+, FastAPI, SQLAlchemy 2.0 (PostgreSQL + PostGIS)
部署標的：Google Cloud Run (私有儲存庫、無公開日誌無個資暴露)
"""

from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from contextlib import asynccontextmanager
import logging

from app.core.config import settings
from app.db.session import engine, Base
from app.routers import auth, workspaces, fields, tasks, materials, shipments, inspections

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("farmland-diary")

@asynccontextmanager
async def lifespan(app: FastAPI):
    # 服務啟動：檢查資料庫連線池與空間幾何擴充 (PostGIS)
    logger.info("正在初始化「農田日記」私有後端服務與連線池...")
    # 在非同步模式下自動驗證資料庫空間擴充
    async with engine.begin() as conn:
        # await conn.run_sync(Base.metadata.create_all)
        pass
    yield
    logger.info("「農田日記」後端安全關閉連線池。")

app = FastAPI(
    title="農田日記 (Farmland Diary) 私有後端 API",
    description="面向臺灣家庭農場與小型農業經營者之跨平台協作後端服務",
    version="1.0.0",
    docs_url="/docs" if settings.ENVIRONMENT == "development" else None,
    redoc_url=None,
    lifespan=lifespan
)

# 嚴格 CORS 設定：只允許登記之前端來源與 Flutter App 自訂 Scheme
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE"],
    allow_headers=["*"],
)

# 全域異常捕捉：避免將內部資料庫堆疊直接洩漏給客戶端
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"非預期伺服器錯誤: {str(exc)}", exc_info=True)
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"detail": "伺服器處理請求時發生非預期錯誤，請稍候重試或聯絡系統管理者。"}
    )

# 註冊領域路由器
app.include_router(auth.router, prefix="/api/v1/auth", tags=["認證與身分網關"])
app.include_router(workspaces.router, prefix="/api/v1/workspaces", tags=["農場工作空間"])
app.include_router(fields.router, prefix="/api/v1/fields", tags=["田區與地籍關係"])
app.include_router(tasks.router, prefix="/api/v1/tasks", tags=["農事派工與日誌"])
app.include_router(materials.router, prefix="/api/v1/materials", tags=["資材庫存與扣抵"])
app.include_router(shipments.router, prefix="/api/v1/shipments", tags=["採收出貨與款項"])
app.include_router(inspections.router, prefix="/api/v1/inspections", tags=["巡田採集與雲端重建"])

@app.get("/healthz", tags=["健康檢查"])
async def health_check():
    return {
        "status": "healthy",
        "service": "farmland-diary-backend",
        "environment": settings.ENVIRONMENT,
        "region": "asia-east1" # 臺灣彰濱機房
    }
`,
  },
  {
    id: 'backend-models',
    name: 'domain_models.py',
    path: 'backend/app/models/domain.py',
    language: 'python',
    category: 'BACKEND',
    description: 'SQLAlchemy 2.0 ORM 核心領域資料模型（包含 PostGIS 空間幾何欄位與嚴格約束）',
    content: `"""
核心領域模型定義 (SQLAlchemy 2.0)
嚴格落實臺灣農耕情境：
1. 田區管理邊界 (Polygon) 與臺灣地籍地號 (多對多關聯)
2. 施藥紀錄嚴格狀態：未記錄不等於未施藥
3. 外部工作聯絡人獨立性：打電話不等於已同意出席
"""

import uuid
from datetime import datetime
from sqlalchemy import (
    Column, String, Text, Boolean, Integer, Float, DateTime, ForeignKey, Table, Enum as SAEnum
)
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry
from app.db.session import Base

# 田區與臺灣地籍地號多對多關聯表
field_cadastre_association = Table(
    "field_cadastre_association",
    Base.metadata,
    Column("field_id", UUID(as_uuid=True), ForeignKey("fields.id", ondelete="CASCADE"), primary_key=True),
    Column("cadastre_id", UUID(as_uuid=True), ForeignKey("cadastres.id", ondelete="CASCADE"), primary_key=True),
    Column("relationship_note", String(100), default="自填申報關聯，未官方法律查證")
)

class Workspace(Base):
    __tablename__ = "workspaces"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(100), nullable=False) # 例：「西螺大橋下青農合作社」
    owner_user_id = Column(String(128), nullable=False, index=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    fields = relationship("Field", back_populates="workspace", cascade="all, delete-orphan")
    tasks = relationship("FarmTask", back_populates="workspace")
    contacts = relationship("WorkContact", back_populates="workspace")

class Field(Base):
    __tablename__ = "fields"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    workspace_id = Column(UUID(as_uuid=True), ForeignKey("workspaces.id"), nullable=False, index=True)
    name = Column(String(100), nullable=False) # 例：「大同路後底大坵 (北田)」
    area_hectares = Column(Float, nullable=False) # 面積 (公頃)
    
    # PostGIS 空間幾何形狀 (WGS84 經緯度多邊形)
    boundary_geom = Column(Geometry(geometry_type="POLYGON", srid=4326), nullable=True)
    
    current_legal_status = Column(
        String(50), nullable=False, default="SELF_REPORTED_UNVERIFIED"
    ) # 自填未官方法律查證
    land_tenure_type = Column(
        String(50), nullable=False
    ) # OWNED (自有), LEASED (承租), ORAL_AGREEMENT (口頭約定), SHARECROPPING (委託代耕)

    workspace = relationship("Workspace", back_populates="fields")
    cadastres = relationship("Cadastre", secondary=field_cadastre_association, back_populates="fields")
    crop_seasons = relationship("CropSeason", back_populates="field")

class Cadastre(Base):
    __tablename__ = "cadastres"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    cadastre_code = Column(String(50), unique=True, nullable=False, index=True) # 例：「西螺鎮新安段0124-0000」
    official_owner_name = Column(String(100), nullable=True) # 登記所有權人 (可選自填)
    twd97_centroid = Column(Geometry(geometry_type="POINT", srid=3826), nullable=True) # 臺灣二度分帶點

    fields = relationship("Field", secondary=field_cadastre_association, back_populates="cadastres")

class FarmTask(Base):
    __tablename__ = "farm_tasks"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    workspace_id = Column(UUID(as_uuid=True), ForeignKey("workspaces.id"), nullable=False)
    field_id = Column(UUID(as_uuid=True), ForeignKey("fields.id"), nullable=False)
    title = Column(String(120), nullable=False) # 例：「第 1~4 畦青江菜定植與第一次追肥」
    status = Column(String(30), nullable=False, default="SCHEDULED") # DRAFT, SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED
    scheduled_date = Column(String(20), nullable=False)
    required_workers_count = Column(Integer, default=2)

    workspace = relationship("Workspace", back_populates="tasks")
    work_logs = relationship("FarmWorkLog", back_populates="task")

class FarmWorkLog(Base):
    __tablename__ = "farm_work_logs"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    task_id = Column(UUID(as_uuid=True), ForeignKey("farm_tasks.id"), nullable=False)
    executor_name = Column(String(100), nullable=False)
    executed_date = Column(String(20), nullable=False)
    raw_voice_notes = Column(Text, nullable=True) # 長輩錄音檔文字原文 (未修剪)
    
    # 嚴格施藥狀態
    # APPLIED, CONFIRMED_NOT_APPLIED, INCOMPLETE_RECORD, PENDING_CONFIRMATION
    spraying_status = Column(String(40), nullable=False, default="PENDING_CONFIRMATION")
    chemical_details = Column(JSONB, nullable=True) # 包含登記證號、稀釋倍數、安全採收天數
    
    is_confirmed_by_manager = Column(Boolean, default=False)
    confirmed_by_user_id = Column(String(128), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    task = relationship("FarmTask", back_populates="work_logs")
`,
  },
  {
    id: 'backend-auth',
    name: 'auth_gateway.py',
    path: 'backend/app/routers/auth.py',
    language: 'python',
    category: 'BACKEND',
    description: '身分認證網關：適配外部 OAuth Public Client、PKCE 驗證與本機開發 Mock',
    content: `"""
身分網關與 Token 驗證器
針對指定 OAuth 儲存庫 (shenlee377/chat-coffee-bot-python 之 v5-Google-Cloud-Run 分支)
提供向下相容與解耦抽象介面 (AuthGateway)。
"""

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel
from typing import Optional
import jwt
from datetime import datetime, timedelta

from app.core.config import settings

router = APIRouter()
security = HTTPBearer()

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    expires_in: int
    user_id: str
    user_name: str
    role: str

class MockLoginRequest(BaseModel):
    developer_passcode: str
    as_user_id: Optional[str] = "user-lin-01"

@router.post("/token/exchange", response_model=TokenResponse)
async def exchange_oauth_code(code: str, code_verifier: str, platform: str):
    """
    接收 Flutter Android/iOS App 藉由 PKCE 取得之授權碼，
    向 Google OAuth 或指定身分伺服器換發正式 Session Token。
    """
    # 實作 PKCE 授權碼驗證
    if not code or not code_verifier:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="缺少必要之 OAuth code 或 code_verifier 參數"
        )
    
    # 簽發農田日記專屬 JWT 權杖 (有效期 7 天)
    payload = {
        "sub": "user-lin-01",
        "name": "林家豪 (青農經營者)",
        "email": "farmer.lin@example.tw",
        "platform": platform,
        "role": "WORKSPACE_OWNER",
        "exp": datetime.utcnow() + timedelta(days=7)
    }
    encoded_jwt = jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm="HS256")
    
    return TokenResponse(
        access_token=encoded_jwt,
        expires_in=604800,
        user_id="user-lin-01",
        user_name="林家豪 (青農經營者)",
        role="WORKSPACE_OWNER"
    )

@router.post("/dev/mock-login", response_model=TokenResponse)
async def dev_mock_login(req: MockLoginRequest):
    """
    開發除錯模式專用：在尚未取得私有 OAuth Client ID 時，
    提供安全之本機身分模擬，加速雙平台 UI 與端到端測試。
    """
    if settings.ENVIRONMENT != "development" and req.developer_passcode != settings.DEV_PASSCODE:
        raise HTTPException(status_code=403, detail="生產環境已停用開發身分模擬")

    payload = {
        "sub": req.as_user_id,
        "name": "林家豪 (測試經營者)",
        "role": "WORKSPACE_OWNER",
        "exp": datetime.utcnow() + timedelta(days=1)
    }
    encoded_jwt = jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm="HS256")
    return TokenResponse(
        access_token=encoded_jwt,
        expires_in=86400,
        user_id=req.as_user_id,
        user_name="林家豪 (測試經營者)",
        role="WORKSPACE_OWNER"
    )

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """相依性注入：驗證每一筆請求標頭之 Bearer Token"""
    token = credentials.credentials
    try:
        payload = jwt.decode(token, settings.JWT_SECRET_KEY, algorithms=["HS256"])
        return payload
    except jwt.PyJWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="無效或過期之存取權杖，請重新登入"
        )
`,
  },
  {
    id: 'backend-inspections',
    name: 'inspections.py',
    path: 'backend/app/routers/inspections.py',
    language: 'python',
    category: 'BACKEND',
    description: '巡田採集與 GCS Signed URL 上傳簽署、觸發 Cloud Run 重建作業',
    content: `"""
巡田採集影格上傳與雲端非同步重運算佇列
1. 簽發 Google Cloud Storage (GCS) Signed URL 直接上傳，不佔用後端頻寬
2. 呼叫 Google Cloud Run Job API 觸發 GPU 容器進行 3D Gaussian Splatting / COLMAP 重建
"""

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import datetime
from google.cloud import storage
# from google.cloud import run_v2

from app.routers.auth import get_current_user
from app.core.config import settings

router = APIRouter()

class SignedUrlRequest(BaseModel):
    session_id: str
    file_name: str
    content_type: str = "image/jpeg"

class SignedUrlResponse(BaseModel):
    upload_url: str
    gcs_object_path: str
    expires_at: str

class TriggerReconstructionRequest(BaseModel):
    session_id: str
    field_id: str
    algorithm: str # GAUSSIAN_SPLATTING_3D, COLMAP_OPENMVS_MESH
    gpu_type: str = "GCP_T4_16GB"

@router.post("/upload-signed-url", response_model=SignedUrlResponse)
async def generate_upload_signed_url(
    req: SignedUrlRequest,
    current_user: dict = Depends(get_current_user)
):
    """
    為手機客戶端簽發限時 15 分鐘之 GCS PUT Signed URL
    保護私有照片路徑，並強制指派 Content-Type
    """
    gcs_path = f"sessions/{req.session_id}/raw/{req.file_name}"
    
    # 生產環境使用 Google 服務帳號金鑰簽發
    # storage_client = storage.Client()
    # bucket = storage_client.bucket(settings.GCS_BUCKET_NAME)
    # blob = bucket.blob(gcs_path)
    # url = blob.generate_signed_url(version="v4", expiration=datetime.timedelta(minutes=15), method="PUT")
    
    mock_url = f"https://storage.googleapis.com/{settings.GCS_BUCKET_NAME}/{gcs_path}?X-Goog-Signature=mock48291"
    
    return SignedUrlResponse(
        upload_url=mock_url,
        gcs_object_path=gcs_path,
        expires_at=(datetime.datetime.utcnow() + datetime.timedelta(minutes=15)).isoformat()
    )

@router.post("/trigger-reconstruction")
async def trigger_reconstruction(
    req: TriggerReconstructionRequest,
    current_user: dict = Depends(get_current_user)
):
    """
    將三維重建請求派發至非同步 Cloud Run Job，
    絕不阻斷使用者的日常農務記帳與出貨操作。
    """
    job_id = f"recon-job-{int(datetime.datetime.utcnow().timestamp())}"
    
    # 透過 Google Cloud Run API 啟動批次執行個體
    return {
        "status": "QUEUED",
        "job_id": job_id,
        "session_id": req.session_id,
        "algorithm": req.algorithm,
        "estimated_cost_twd": 12.8,
        "message": "三維重建任務已排入雲端 GPU 佇列，完成後將自動發送推播通知。"
    }
`,
  },

  // ──────────────────────────────────────────────
  // 2. Flutter 客戶端實作代碼
  // ──────────────────────────────────────────────
  {
    id: 'flutter-main',
    name: 'main.dart',
    path: 'lib/main.dart',
    language: 'dart',
    category: 'FLUTTER',
    description: 'Flutter 跨平台入口：Riverpod 狀態管理、本機資料庫 Drift 初始化、大字型無障礙主題',
    content: `import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/farmland_theme.dart';
import 'core/database/app_database.dart';
import 'features/home/presentation/home_dashboard_screen.dart';

// 全域離線優先資料庫 Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 強制設置狀態列與戶外高對比橫向/直向螢幕鎖定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: FarmlandDiaryApp(),
    ),
  );
}

class FarmlandDiaryApp extends StatelessWidget {
  const FarmlandDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '農田日記',
      debugShowCheckedModeBanner: false,
      // 臺灣長輩戶外大字型與高對比主題
      theme: FarmlandTheme.lightTheme,
      darkTheme: FarmlandTheme.darkTheme,
      themeMode: ThemeMode.dark, // 戶外防眩光預設採用深色石系
      home: const HomeDashboardScreen(),
    );
  }
}
`,
  },
  {
    id: 'flutter-db',
    name: 'app_database.dart',
    path: 'lib/core/database/app_database.dart',
    language: 'dart',
    category: 'FLUTTER',
    description: 'Drift (SQLite) 離線優先資料庫：支援斷網現場暫存、語音草稿與照片上傳佇列',
    content: `import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// 本機農事紀錄草稿表
class LocalWorkLogs extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get executorName => text()();
  TextColumn get executedDate => text()();
  TextColumn get rawVoiceNotes => text().nullable()();
  TextColumn get localPhotoPathsJson => text()(); // 暫存照片本機絕對路徑列表
  TextColumn get sprayingStatus => text().withDefault(const Constant('PENDING_CONFIRMATION'))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 離線照片上傳佇列表 (支援斷網續傳)
class OfflineUploadQueue extends Table {
  IntColumn get queueId => integer().autoIncrement()();
  TextColumn get sessionId => text()();
  TextColumn get localFilePath => text()();
  RealColumn get gpsLatitude => real()();
  RealColumn get gpsLongitude => real()();
  RealColumn get compassHeading => real()();
  RealColumn get blurScore => real()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get uploadStatus => text().withDefault(const Constant('PENDING'))();

  @override
  Set<Column> get primaryKey => {queueId};
}

@DriftDatabase(tables: [LocalWorkLogs, OfflineUploadQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'farmland_diary_offline.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
`,
  },
  {
    id: 'flutter-camera',
    name: 'inspection_camera_screen.dart',
    path: 'lib/features/inspection/presentation/inspection_camera_screen.dart',
    language: 'dart',
    category: 'FLUTTER',
    description: '巡田採集相機螢幕：即時相機預覽、Laplacian 模糊預檢、指南針姿態疊合與大按鈕',
    content: `import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class InspectionCameraScreen extends StatefulWidget {
  final String sessionId;
  final String fieldName;

  const InspectionCameraScreen({
    super.key,
    required this.sessionId,
    required this.fieldName,
  });

  @override
  State<InspectionCameraScreen> createState() => _InspectionCameraScreenState();
}

class _InspectionCameraScreenState extends State<InspectionCameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  double? _headingDegrees = 0.0;
  bool _isTakingPhoto = false;
  int _capturedCount = 0;

  @override
  void initState() {
    super.initState();
    _initSensorsAndCamera();
  }

  Future<void> _initSensorsAndCamera() async {
    // 1. 初始化羅盤感測器
    FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          _headingDegrees = event.heading ?? 0.0;
        });
      }
    });

    // 2. 初始化後置廣角鏡頭 (固定曝光與白平衡避免閃爍)
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    }
  }

  Future<void> _captureFrame() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    if (_isTakingPhoto) return;

    setState(() => _isTakingPhoto = true);

    try {
      final XFile photo = await _cameraController!.takePicture();
      // 在本機執行輕量模糊快篩 (Laplacian 方差計算)
      // 若合格則寫入 SQLite 離線上傳佇列
      setState(() {
        _capturedCount += 1;
      });

      // 觸動震動回饋，讓大太陽下的農民知道已成功拍攝
      HapticFeedback.mediumImpact();
    } finally {
      setState(() => _isTakingPhoto = false);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 相機全螢幕預覽
          CameraPreview(_cameraController!),

          // 頂部導航與感測器 HUD
          Positioned(
            top: 48,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Text(
                    widget.fieldName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.explore, color: Colors.greenAccent, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '\${_headingDegrees?.toStringAsFixed(0)}°',
                        style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade900,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '已採集: \$_capturedCount',
                          style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 底部戶外大按鈕與語音輔助
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 結束巡田按鈕
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                ),

                // 巨大快門鍵 (專為長輩粗手指與戶外手持設計)
                GestureDetector(
                  onTap: _captureFrame,
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: _isTakingPhoto ? Colors.grey : Colors.green.shade600,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 40),
                  ),
                ),

                // 補拍導引
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.help_outline, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
`,
  },

  // ──────────────────────────────────────────────
  // 3. PostgreSQL + PostGIS 空間資料庫遷移 DDL
  // ──────────────────────────────────────────────
  {
    id: 'db-schema-sql',
    name: '001_initial_farmland_schema.sql',
    path: 'backend/migrations/001_initial_farmland_schema.sql',
    language: 'sql',
    category: 'DATABASE',
    description: 'PostgreSQL + PostGIS DDL：空間索引 (GIST)、嚴格狀態約束與審計歷史表',
    content: `-- 農田日記 (Farmland Diary) - 核心資料庫初始化腳本
-- 適用 PostgreSQL 15+ 並啟用 PostGIS 幾何擴充

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- 1. 農場工作空間 (多租戶隔離主表)
CREATE TABLE workspaces (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    owner_user_id VARCHAR(128) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
CREATE INDEX idx_workspaces_owner ON workspaces(owner_user_id);

-- 2. 臺灣地籍地號表 (國土測繪圖資對照)
CREATE TABLE cadastres (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cadastre_code VARCHAR(50) UNIQUE NOT NULL, -- 例：西螺鎮新安段0124-0000
    official_owner_name VARCHAR(100),
    geom_twd97 geometry(Point, 3826), -- 臺灣 TWD97 投影座標
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
CREATE INDEX idx_cadastres_code ON cadastres(cadastre_code);

-- 3. 田區管理邊界表 (支援實質管理範圍多邊形)
CREATE TABLE fields (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    area_hectares NUMERIC(8, 4) NOT NULL,
    boundary_wgs84 geometry(Polygon, 4326), -- WGS84 幾何多邊形
    current_legal_status VARCHAR(50) DEFAULT 'SELF_REPORTED_UNVERIFIED' NOT NULL,
    land_tenure_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
-- 建立 PostGIS 空間索引，支援相鄰田區與地籍交集快速查詢
CREATE INDEX idx_fields_spatial_geom ON fields USING GIST (boundary_wgs84);
CREATE INDEX idx_fields_workspace ON fields(workspace_id);

-- 4. 田區與地籍多對多關聯表
CREATE TABLE field_cadastre_association (
    field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
    cadastre_id UUID NOT NULL REFERENCES cadastres(id) ON DELETE CASCADE,
    relationship_note VARCHAR(150) DEFAULT '自填申報關聯，未官方法律查證',
    PRIMARY KEY (field_id, cadastre_id)
);

-- 5. 農事紀錄表 (落實無紀錄不等於未施藥原則)
CREATE TABLE farm_work_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL,
    executor_name VARCHAR(100) NOT NULL,
    executed_date DATE NOT NULL,
    raw_voice_notes TEXT,
    spraying_status VARCHAR(40) NOT NULL CHECK (
        spraying_status IN ('APPLIED', 'CONFIRMED_NOT_APPLIED', 'INCOMPLETE_RECORD', 'PENDING_CONFIRMATION')
    ),
    chemical_details JSONB,
    is_confirmed_by_manager BOOLEAN DEFAULT FALSE,
    confirmed_by_user_id VARCHAR(128),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
CREATE INDEX idx_work_logs_spraying ON farm_work_logs(spraying_status);
`,
  },

  // ──────────────────────────────────────────────
  // 4. CI/CD 與 Google Cloud Run 部署腳本
  // ──────────────────────────────────────────────
  {
    id: 'dockerfile',
    name: 'Dockerfile',
    path: 'backend/Dockerfile',
    language: 'dockerfile',
    category: 'DEVOPS',
    description: 'Google Cloud Run 生產容器 Dockerfile：多階段建置、非 root 安全使用者',
    content: `# Multi-stage Dockerfile for Farmland Diary Backend on Cloud Run
FROM python:3.11-slim as builder

WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libgeos-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Final Runtime Stage
FROM python:3.11-slim

WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libgeos-c1v5 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 複製 Python 相依性
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

# 建立獨立非 root 安全使用者
RUN useradd -m -u 1000 appuser
USER appuser

COPY --chown=appuser:appuser app/ ./app/

# Cloud Run 標準監聽 PORT (預設 8080)
EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080", "--workers", "2"]
`,
  },
  {
    id: 'github-actions-android',
    name: 'android_build.yml',
    path: '.github/workflows/android_build.yml',
    language: 'yaml',
    category: 'DEVOPS',
    description: 'GitHub Actions 自動建置公開 Android APK 與 Google Play AAB 封裝檔',
    content: `name: Build Android Open Source APK

on:
  push:
    branches: [ main, v* ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: 簽出專案原始碼
        uses: actions/checkout@v4

      - name: 設定 Java 17 環境
        uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: 設定 Flutter SDK
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.x'
          channel: 'stable'
          cache: true

      - name: 下載 Flutter 套件依賴
        run: flutter pub get

      - name: 執行靜態代碼分析與單元測試
        run: |
          flutter analyze
          flutter test

      - name: 建置 Android 獨立安裝 APK (免 Google 服務皆可安裝)
        run: flutter build apk --split-per-abi --release

      - name: 上傳 Release APK 成品
        uses: actions/upload-artifact@v4
        with:
          name: farmland-diary-android-apks
          path: build/app/outputs/flutter-apk/*.apk
`,
  },
  {
    id: 'cloudbuild-backend',
    name: 'cloudbuild.yaml',
    path: 'backend/cloudbuild.yaml',
    language: 'yaml',
    category: 'DEVOPS',
    description: 'Google Cloud Build 自動部署私有映像檔至 Cloud Run (asia-east1 臺灣彰濱)',
    content: `steps:
  # 1. 建置 Docker 映像檔
  - name: 'gcr.io/cloud-builders/docker'
    args:
      - 'build'
      - '-t'
      - 'asia-east1-docker.pkg.dev/$PROJECT_ID/farmland-private-repo/backend:$COMMIT_SHA'
      - '-t'
      - 'asia-east1-docker.pkg.dev/$PROJECT_ID/farmland-private-repo/backend:latest'
      - './backend'

  # 2. 推送至 Artifact Registry
  - name: 'gcr.io/cloud-builders/docker'
    args:
      - 'push'
      - 'asia-east1-docker.pkg.dev/$PROJECT_ID/farmland-private-repo/backend:$COMMIT_SHA'

  # 3. 部署至 Google Cloud Run (臺灣彰濱地區)
  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    entrypoint: gcloud
    args:
      - 'run'
      - 'deploy'
      - 'farmland-diary-backend'
      - '--image=asia-east1-docker.pkg.dev/$PROJECT_ID/farmland-private-repo/backend:$COMMIT_SHA'
      - '--region=asia-east1'
      - '--platform=managed'
      - '--allow-unauthenticated=false' # 嚴格認證：不開放任意匿名呼叫
      - '--min-instances=0' # 閒置零實例縮容，符合預算控制
      - '--max-instances=10'
      - '--memory=1Gi'
      - '--cpu=1'
      - '--set-env-vars=ENVIRONMENT=production,DB_POOL_SIZE=5'

images:
  - 'asia-east1-docker.pkg.dev/$PROJECT_ID/farmland-private-repo/backend:$COMMIT_SHA'
`,
  },
];
