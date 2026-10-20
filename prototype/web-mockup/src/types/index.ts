/**
 * 農田日記 (Farmland Diary) - 核心領域型別定義
 */

export interface Workspace {
  id: string;
  name: string; // 例如：「山水青農合作社」或「阿忠伯家庭果園」
  ownerUserId: string;
  createdAt: string;
  userRole: 'OWNER' | 'ADMIN' | 'MANAGER' | 'WORKER' | 'ACCOUNTANT' | 'READONLY';
}

export interface LandRelationship {
  ownerName: string; // 所有權人 (自填，標示非官方查證)
  isSharedOwnership: boolean; // 是否共有
  tenantName: string; // 承租人
  actualOperator: string; // 實際經營人
  leasePeriodStart?: string;
  leasePeriodEnd?: string;
  annualRentTWD?: number;
  specialAgreements?: string; // 特殊約定 (如灌溉水權或田埂整理)
  verificationStatus: 'SELF_REPORTED_UNVERIFIED' | 'CONFIRMED_WITH_LANDOWNER' | 'OFFICIAL_DOCUMENT_ATTACHED';
  confirmedDate?: string;
}

export interface FieldParcel {
  cadastralNumber: string; // 地號，例如：「雲林縣西螺鎮公館段 0123-0000 號」
  areaSqMeters: number;
}

export interface Field {
  id: string;
  workspaceId: string;
  name: string; // 慣用稱呼：「溪底大坵」、「工寮後方北田」
  areaHectares: number;
  areaSource: 'MANUAL_INPUT' | 'GPS_TRACK_ESTIMATE' | 'CADASTRAL_SUM' | 'AIR_PHOTO_SURVEY';
  landRelationship: LandRelationship;
  cadastralParcels: FieldParcel[]; // 多對多關聯地號
  waterSourceDescription: string;
  assemblyPointDescription: string;
  boundaryVersion: number;
  boundaryCoordinates: [number, number][]; // 經緯度座標 [lng, lat]
  isArchived: boolean;
}

export interface CropSeason {
  id: string;
  fieldId: string;
  workspaceId: string;
  seasonCode: string; // 例如：「115年一期作」或「2026秋冬裡作」
  cropName: string; // 例如：「青蔥」、「苦瓜」、「玉女番茄」、「越光米」
  variety: string; // 品種
  seedlingSource: string; // 苗株來源
  seedlingBatchNumber?: string;
  plannedPlantingDate: string;
  actualPlantingDate?: string;
  plannedHarvestDate: string;
  actualHarvestDate?: string;
  status: 'PLANNING' | 'ACTIVE' | 'HARVESTING' | 'CLOSED' | 'FALLOW'; // FALLOW = 休耕
  notes: string;
}

export interface WorkContact {
  id: string;
  workspaceId: string;
  fullName: string;
  nickname: string; // 慣用俗稱，例如：「阿吉叔」、「六嬸」
  phone: string;
  preferredContactMethod: 'PHONE_CALL' | 'LINE_PROXY' | 'IN_PERSON';
  groupLeaderName?: string; // 帶班人或工班關係
  workRestrictions?: string; // 本人確認之工作限制，例如：「不能提超過25公斤」、「膝蓋不好不跪田」
  confirmedAvailableDays?: string[];
  defaultDailyWageTWD?: number;
  defaultHourlyWageTWD?: number;
  hasAppAccount: boolean; // 臨時工或長輩不需要 App 帳號
  notes: string;
}

export interface TaskAssignment {
  contactId: string;
  contactName: string;
  status: 'UNCONTACTED' | 'CONTACTED_PENDING' | 'CONFIRMED' | 'DECLINED' | 'CANCELLED' | 'CHECKED_IN' | 'COMPLETED';
  contactTime?: string;
  confirmedTime?: string;
  wageType: 'DAILY' | 'HOURLY' | 'PIECE_RATE' | 'VOLUNTEER';
  rateSnapshotTWD: number;
  actualHoursWorked?: number;
  paidStatus: 'UNPAID' | 'PAID' | 'DISPUTED';
}

export interface FarmTask {
  id: string;
  workspaceId: string;
  fieldId: string;
  fieldName: string;
  cropSeasonId: string;
  cropName: string;
  title: string; // 例如：「田區北側整地並施基肥」
  taskType:
    | 'LAND_PREP'    // 整地
    | 'SEEDLING'     // 育苗/移植
    | 'IRRIGATION'   // 灌排水
    | 'WEEDING'      // 除草
    | 'PRUNING'      // 修剪/疏花
    | 'FERTILIZING'  // 施肥
    | 'PEST_CONTROL' // 施藥/防治
    | 'INSPECTION'   // 巡田
    | 'HARVEST'      // 採收
    | 'POST_HARVEST' // 採後
    | 'FACILITY';    // 設施維護
  plannedDate: string;
  assemblyTime: string;
  assemblyLocation: string;
  requiredWorkersCount: number;
  assignments: TaskAssignment[];
  preparedToolsNotes: string;
  weatherAdjustmentNotes?: string;
  status: 'DRAFT' | 'SCHEDULED' | 'IN_PROGRESS' | 'COMPLETED' | 'CANCELLED';
}

export interface MaterialUsage {
  materialName: string; // 俗稱或商品名，如「台肥黑王一號有機質特43號」
  specification: string; // 如「40公斤/包」
  rawInputQuantityText: string; // 原始回報說法：「一包半」
  isSpecificationConfirmed: boolean; // 是否已對應到標準規格
  standardAmountKg?: number; // 60 kg (僅在已確認時換算)
  batchNumber?: string;
}

export interface FarmWorkLog {
  id: string;
  workspaceId: string;
  taskId?: string;
  fieldId: string;
  fieldName: string;
  cropSeasonId: string;
  cropName: string;
  activityType: string;
  actualStartTime: string;
  actualEndTime: string;
  operatorNames: string[];
  workAreaDescription: string; // 作業範圍，如「北面第1~8畦」
  materialsUsed: MaterialUsage[];
  sprayingStatus: 'CONFIRMED_NOT_APPLIED' | 'APPLIED' | 'PENDING_CONFIRMATION' | 'INCOMPLETE_RECORD';
  photoUrls: string[];
  voiceNoteUrl?: string;
  originalRawInput: string; // 保存語音文字或長輩原始回報原文
  reportedByUserId: string;
  confirmedByManagerId?: string;
  confirmedAt?: string;
  status: 'DRAFT' | 'REPORTED' | 'CONFIRMED' | 'REJECTED_REVISION';
}

// ────────────────────────────────
// 第二階段 (Phase 2) 領域型別
// ────────────────────────────────

export interface InventoryItem {
  id: string;
  workspaceId: string;
  brandName: string; // 例如：「台灣肥料」
  productName: string; // 例如：「台肥黑王一號有機質特43號複合肥料」
  commonName: string; // 農民俗稱：「特43號」、「黑王」
  category: 'FERTILIZER' | 'PESTICIDE' | 'SEED' | 'MATERIAL';
  specification: string; // 例如：「40公斤/包」
  unit: string; // 「包」、「罐」、「公斤」
  totalStockQuantity: number; // 當前庫存總量
  safetyStockThreshold: number; // 安全庫存警示閥值
}

export interface InventoryTransaction {
  id: string;
  itemId: string;
  workspaceId: string;
  transactionType: 'PURCHASE_IN' | 'WORK_CONSUME' | 'RETURN' | 'LOSS' | 'SCRAP' | 'ADJUSTMENT';
  quantityChange: number; // 正數代表入庫，負數代表領用消耗
  resultingBalance: number;
  batchNumber: string;
  linkedWorkLogId?: string; // 扣抵連回之實際作業紀錄 ID
  operatorName: string;
  timestamp: string;
  notes: string;
}

export interface AttendanceRecord {
  id: string;
  workspaceId: string;
  taskId: string;
  contactId: string;
  contactName: string;
  workDate: string;
  checkInTime: string;
  checkOutTime: string;
  actualHoursWorked: number;
  wageType: 'DAILY' | 'HOURLY' | 'PIECE_RATE' | 'VOLUNTEER';
  rateSnapshotTWD: number;
  totalPayableTWD: number;
  isPaid: boolean;
  paidDate?: string;
  paymentMethod?: 'CASH' | 'BANK_TRANSFER';
  isFamilyLabor: boolean; // 區分自家工時估算與外部現金支出
}

export interface OfflineSyncItem {
  localId: string;
  entityType: 'WORK_LOG' | 'TASK' | 'INSPECTION' | 'INVENTORY';
  payloadSummary: string;
  localSavedAt: string;
  syncStatus: 'LOCAL_SAVED' | 'SYNCING' | 'SYNCED' | 'SYNC_FAILED' | 'CONFLICT_PENDING';
  retryCount: number;
  errorMessage?: string;
}

// ────────────────────────────────
// 第三階段 (Phase 3) 領域型別
// ────────────────────────────────

export interface PreHarvestCheck {
  isSprayingRecordsComplete: boolean;
  isSafeHarvestPeriodPassed: boolean; // 安全採收期檢查
  hasPendingSprayConfirmation: boolean;
  inspectorName: string;
  checkedAt: string;
  checkPassed: boolean;
  notes: string;
}

export interface HarvestBatch {
  id: string;
  workspaceId: string;
  cropSeasonId: string;
  cropName: string;
  fieldId: string;
  fieldName: string;
  harvestDate: string;
  harvestAreaDescription: string;
  grossWeightKg: number;
  netWeightKg: number;
  gradeQuality: 'PREMIUM' | 'GRADE_A' | 'GRADE_B' | 'PROCESSING'; // 特級、優級、良級、加工
  preHarvestCheck: PreHarvestCheck;
  operatorNames: string[];
  notes: string;
}

export interface ShipmentRecord {
  id: string;
  workspaceId: string;
  harvestBatchId: string;
  cropName: string;
  buyerName: string; // 例如：「西螺果菜批發市場行口 (38號)」、「台北農產運銷 (二銷)」
  buyerType: 'WHOLESALE_MARKET' | 'DIRECT_CONSUMER' | 'SUPERMARKET' | 'COOPERATIVE';
  shipmentDate: string;
  packagesCount: number;
  packageType: string; // 例如：「30公斤竹簍裝」、「20公斤紙箱裝」
  unitAgreedPriceTWD: number;
  grossRevenueTWD: number;
  freightDeductionTWD: number; // 運費扣款
  marketFeeDeductionTWD: number; // 管理費/手續費扣款
  netReceivableTWD: number; // 應收款 (不等於已收到現金)
  actualReceivedCashTWD: number; // 實際已收現金
  receivedDate?: string;
  isFullySettled: boolean;
  notes: string;
}

export interface AnomalyIncident {
  id: string;
  workspaceId: string;
  fieldId: string;
  fieldName: string;
  cropSeasonId: string;
  title: string; // 例如：「第5畦葉背疑似出現小菜蛾幼蟲幼齡食痕」
  category: 'PEST' | 'DISEASE' | 'FACILITY_DAMAGE' | 'IRRIGATION_ISSUE' | 'WEED_OVERGROWTH' | 'WEATHER';
  severity: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
  discoveredAt: string;
  discoveredBy: string;
  photoUrls: string[];
  observedPhenomenon: string; // 客觀可觀察現象 (不擅自斷定病名)
  actionTaken?: string; // 採取措施 (人工捉蟲/摘除病葉/誘蟲盒)
  resolvedStatus: 'OPEN' | 'INVESTIGATING' | 'ACTION_TAKEN' | 'CLOSED';
  resolvedAt?: string;
}

export interface DisasterCase {
  id: string;
  workspaceId: string;
  disasterEventName: string; // 例如：「115年7月強烈颱風凱米農損救助案件」
  affectedFieldIds: string[];
  affectedCropName: string;
  damagedAreaHectares: number;
  damageRatioPercent: number; // 損害程度比率 (例: 35%)
  lossEstimatedTWD: number; // 內部自行估算受損金額 (非官方核定)
  photoEvidenceUrls: string[];
  
  // 政府天然災害救助狀態 (與保險分開)
  governmentReliefStatus: 'NOT_APPLIED' | 'APPLICATION_SUBMITTED' | 'OFFICIAL_SURVEYED' | 'APPROVED' | 'DISBURSED' | 'REJECTED';
  reliefOfficialAmountTWD?: number;
  reliefDisbursedDate?: string;

  // 農業保險理賠案件 (獨立存取)
  insurancePolicyNumber?: string;
  insuranceClaimStatus: 'NO_POLICY' | 'CLAIM_REPORTED' | 'SURVEY_IN_PROGRESS' | 'CLAIM_PAID' | 'CLAIM_DENIED';
  insurancePaidAmountTWD?: number;
  
  officialNotes: string; // 明確備註：AI 估損不得冒充官方認定
}

export interface AiConsultationMessage {
  id: string;
  role: 'USER' | 'ASSISTANT';
  timestamp: string;
  fieldId?: string;
  cropSeasonId?: string;
  prompt: string;
  content: {
    knownFacts: string[]; // 1. 已知事實 (依授權正式紀錄)
    observablePhenomena: string[]; // 2. 可觀察現象
    possibleCauses: string[]; // 3. 可能原因 (非確診)
    missingInformation: string[]; // 4. 尚缺資訊 (需現場確認)
    suggestedNextSteps: string[]; // 5. 建議下一步 (安全規範)
  };
}

// ────────────────────────────────
// 第四階段 (Phase 4) 領域型別：巡田採集品質閉環
// ────────────────────────────────

export type DeviceCapabilityTier =
  | 'TIER_1_DEPTH_AR'         // iOS ARKit LiDAR / Android ARCore Depth API
  | 'TIER_2_POSE_TRACKING'     // 具備 6DoF 姿態追蹤但無深度圖
  | 'TIER_3_BASIC_CAMERA_GPS'; // 基礎相機 + GPS + 電子羅盤 (通用最低要求)

export interface FrameCaptureContract {
  frameId: string;
  sessionId: string;
  timestamp: string;
  deviceTier: DeviceCapabilityTier;
  focalLengthPx?: [number, number]; // 相機內參 fx, fy
  principalPointPx?: [number, number]; // cx, cy
  gpsCoordinate: [number, number]; // [lng, lat]
  gpsAccuracyMeters: number;
  compassHeadingDegrees: number;
  blurScore: number; // 模糊分數 (Laplacian 方差，<100 為模糊)
  isBlurry: boolean;
  isPersonOccluded: boolean;
  hasAlternateCleanFrame: boolean;
  uploadStatus: 'LOCAL_BUFFER' | 'UPLOADING' | 'UPLOADED' | 'FAILED';
  gcsObjectPath?: string;
}

export interface ReshootTask {
  id: string;
  sessionId: string;
  fieldSegment: string; // 田區區段，例如：「北田第 4~5 畦西側田埂」
  reason: 'EXCESSIVE_BLUR' | 'PERSON_OCCLUSION_UNREPLACEABLE' | 'ANGLE_GAP' | 'INSUFFICIENT_OVERLAP';
  missingContentDescription: string;
  suggestedHeadingDegrees: number; // 建議鏡頭朝向 (0~360度)
  priority: 'HIGH' | 'MEDIUM';
  status: 'PENDING' | 'RESOLVED' | 'DISMISSED_NOT_CRITICAL';
  resolvedFrameId?: string;
}

export interface InspectionSession {
  id: string;
  workspaceId: string;
  fieldId: string;
  fieldName: string;
  operatorName: string;
  startedAt: string;
  endedAt?: string;
  deviceTier: DeviceCapabilityTier;
  totalFramesCaptured: number;
  validFramesCount: number;
  qualityStatus:
    | 'LOCAL_SAVED'
    | 'SERVER_RECEIVED'
    | 'VALIDATING'
    | 'RESHOOT_REQUIRED'
    | 'PASSED'
    | 'PROCESSING'
    | 'READY'
    | 'PARTIAL'
    | 'FAILED';
  reshootTasks: ReshootTask[];
  cloudQualityReport?: {
    coveragePercent: number; // 田區幾何覆蓋率
    averageBlurScore: number;
    occlusionHandledRatio: string; // 遮擋處理率
    isReadyFor3DOrAI: boolean;
  };
}

// ────────────────────────────────
// 第五階段 (Phase 5) 領域型別：三維重建、AR田界投影、無人機與官方報表
// ────────────────────────────────

export type ReconstructionAlgorithm =
  | 'GAUSSIAN_SPLATTING_3D' // 3D Gaussian Splatting (高光澤、高密度葉面表現)
  | 'NERF_STUDIO_SPLATO'    // NerfStudio Splatfacto (神經輻射場光影重建)
  | 'COLMAP_OPENMVS_MESH';  // 傳統 SfM + MVS 稠密三角網格 (公差精度最高，適用地界測繪)

export interface ReconstructionJob {
  id: string;
  sessionId: string;
  fieldName: string;
  cropName: string;
  algorithm: ReconstructionAlgorithm;
  submittedAt: string;
  completedAt?: string;
  gpuInstanceType: 'GCP_T4_16GB' | 'GCP_L4_24GB' | 'GCP_A10G_24GB';
  computeDurationMinutes: number;
  estimatedCostTWD: number; // 雲端 GPU 實時核算費用 (新台幣)
  status: 'QUEUED' | 'STRUCTURE_FROM_MOTION' | 'DENSE_TRAINING' | 'MESH_EXPORTING' | 'COMPLETED' | 'FAILED';
  sparsePointsCount: number; // 稀疏特徵點數 (例: 142,500 pts)
  denseVerticesCount: number; // 稠密幾何點數 (例: 1,840,000 pts)
  fileSizeMb: number;
  pointCloudUrl?: string; // .ply / .spz
  meshObjUrl?: string; // .obj / .glb
  orthophotoGeoTiffUrl?: string; // 正射鑲嵌圖 GeoTIFF
  spatialAccuracyMeters: number; // 幾何誤差 (例: ±0.035m)
  legalNotice: string; // 強制警示：純視覺輔助，非國土測繪法之法定界址
}

export interface ARBoundaryPoint {
  id: string;
  cadastreCode: string; // 臺灣地籍地號，例: "西螺鎮新安段0124-0000"
  wgs84: [number, number]; // [lng, lat]
  twd97Coord: [number, number]; // 臺灣二度分帶 TWD97 [X, Y]
  reprojectionPixel: [number, number]; // 當前相機畫面像素 [x, y]
  distanceToCameraMeters: number; // 鏡頭至界標距離 (米)
  isOccludedByObstacle: boolean; // 是否被作物或工寮遮擋
}

export interface DroneTelemetryLog {
  id: string;
  flightMissionName: string; // 例如：「20261019_西螺北田全區航照_空拍機01」
  droneModel: 'DJI_MAVIC_3_ENTERPRISE' | 'DJI_AIR_3' | 'AUTEL_EVO_MAX';
  recordedAt: string;
  totalFlightMinutes: number;
  flightAltitudeMetersAGL: number; // 相對地面高度 (米)
  flightAltitudeMetersMSL: number; // 絕對海拔高度 (米)
  gimbalPitchAngleDegrees: number; // 雲台俯仰角 (例: -90度正俯視 / -45度傾斜)
  rtkStatus: 'RTK_FIXED_HIGH_PRECISION' | 'GPS_FLOAT' | 'STANDALONE_GPS';
  horizontalAccuracyMeters: number; // 水平精度 (RTK: 0.02m / GPS: 1.2m)
  shutterTriggerCount: number; // 觸發拍照張數
  imuInterpolationFrequencyHz: number; // IMU SLERP 插值頻率 (50Hz)
  shutterTimeOffsetMs: number; // 快門中點校準時間差 (例: +4.2ms)
  gcsFlightDataPath: string;
}

export interface OfficialTraceabilityPackage {
  id: string;
  workspaceId: string;
  cropSeasonId: string;
  cropName: string;
  applicantFarmerName: string;
  cadastreParcels: string[]; // 地籍列表
  cultivationAreaHectares: number; // 栽培面積
  packageGenerationDate: string;
  tapComplianceStatus: 'COMPLIANT' | 'NEEDS_AUDIT' | 'IRREGULAR_RECORD';
  totalTasksRecorded: number;
  sprayPesticideFreeConfirmed: boolean;
  fertilizerFormulasUsed: string[];
  harvestBatchSummary: {
    totalHarvestKg: number;
    firstHarvestDate: string;
    lastHarvestDate: string;
    lotTraceCode: string; // 產銷履歷批號追溯碼
  };
  digitalSignatureHash: string; // SHA-256 數位簽章雜湊
  downloadablePdfUrl: string;
  moaOfficialNotice: string;
}

export interface DisasterProofPackage {
  id: string;
  disasterCaseId: string;
  disasterEventName: string;
  affectedFieldNames: string[];
  cadastreParcels: string[];
  totalLossEstimatedTWD: number;
  claimedDamagePercentage: number;
  satelliteBeforeComparisonUrl: string;
  fieldInspectionAfterPhotos: {
    photoId: string;
    timestamp: string;
    twd97Coord: [number, number];
    gpsWgs84: [number, number];
    headingDegrees: number;
    watermarkText: string;
    photoUrl: string;
  }[];
  governmentFormCode: string; // 例如：「農業天然災害救助申請表 (農災字第115-08號)」
  generatedAt: string;
  applicantSignatureConfirmed: boolean;
  exportArchiveZipUrl: string;
  legalDisclaimer: string;
}



