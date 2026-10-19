import React, { useState } from 'react';
import {
  ReconstructionJob,
  ReconstructionAlgorithm,
  ARBoundaryPoint,
  DroneTelemetryLog,
  OfficialTraceabilityPackage,
  DisasterProofPackage,
} from '../types/index.ts';
import {
  calculateGpuCostTwd,
  reprojectCadastrePoint,
  evaluateTapCompliance,
} from '../domain/state_machines.ts';
import {
  Box,
  Layers,
  Smartphone,
  Compass,
  Plane,
  FileText,
  ShieldCheck,
  AlertTriangle,
  Download,
  Eye,
  RefreshCw,
  Cpu,
  MapPin,
  Camera,
  CheckCircle2,
  Clock,
  Sparkles,
  QrCode,
  FileCheck,
} from 'lucide-react';

export const Phase5ReconstructionAndReports: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'3d_pipeline' | 'ar_projection' | 'drone_telemetry' | 'official_reports'>('3d_pipeline');

  // ──────────────────────────────────────────────
  // 1. 三維重建管線資料與狀態
  // ──────────────────────────────────────────────
  const [reconstructionJobs, setReconstructionJobs] = useState<ReconstructionJob[]>([
    {
      id: 'recon-job-20261019-01',
      sessionId: 'session-insp-20261019-01',
      fieldName: '大同路後底大坵 (北田)',
      cropName: '青江白菜 (三津一號)',
      algorithm: 'GAUSSIAN_SPLATTING_3D',
      submittedAt: '2026-10-19 07:15',
      completedAt: '2026-10-19 07:27',
      gpuInstanceType: 'GCP_T4_16GB',
      computeDurationMinutes: 12,
      estimatedCostTWD: calculateGpuCostTwd('GCP_T4_16GB', 12),
      status: 'COMPLETED',
      sparsePointsCount: 148200,
      denseVerticesCount: 2150000,
      fileSizeMb: 84.6,
      pointCloudUrl: 'gs://farmland-diary-recon/ws-001/recon-job-01/splat.spz',
      orthophotoGeoTiffUrl: 'gs://farmland-diary-recon/ws-001/recon-job-01/ortho_wgs84.tif',
      spatialAccuracyMeters: 0.035,
      legalNotice: '【視覺參考模型】本點雲僅為農事生長紀錄與株高估算輔助，不具《國土測繪法》法定地籍測量之法律效力。',
    },
    {
      id: 'recon-job-20261019-02',
      sessionId: 'session-insp-20261019-01',
      fieldName: '大同路後底大坵 (北田)',
      cropName: '青江白菜 (幾何地界測繪)',
      algorithm: 'COLMAP_OPENMVS_MESH',
      submittedAt: '2026-10-19 07:30',
      completedAt: '2026-10-19 07:58',
      gpuInstanceType: 'GCP_L4_24GB',
      computeDurationMinutes: 28,
      estimatedCostTWD: calculateGpuCostTwd('GCP_L4_24GB', 28),
      status: 'COMPLETED',
      sparsePointsCount: 210400,
      denseVerticesCount: 3820000,
      fileSizeMb: 142.0,
      pointCloudUrl: 'gs://farmland-diary-recon/ws-001/recon-job-02/dense_mesh.ply',
      meshObjUrl: 'gs://farmland-diary-recon/ws-001/recon-job-02/field_tin.obj',
      spatialAccuracyMeters: 0.022,
      legalNotice: '【幾何網格模型】高密度三角網格 (TIN)，供農地排水坡降與畦面高程分析。',
    },
  ]);

  // 新建重建任務狀態
  const [selectedAlgo, setSelectedAlgo] = useState<ReconstructionAlgorithm>('GAUSSIAN_SPLATTING_3D');
  const [selectedGpu, setSelectedGpu] = useState<'GCP_T4_16GB' | 'GCP_L4_24GB' | 'GCP_A10G_24GB'>('GCP_T4_16GB');
  const [isSubmittingJob, setIsSubmittingJob] = useState(false);

  const handleLaunchReconstruction = () => {
    setIsSubmittingJob(true);
    setTimeout(() => {
      const newJob: ReconstructionJob = {
        id: `recon-job-${Date.now()}`,
        sessionId: 'session-insp-20261019-01',
        fieldName: '大同路後底大坵 (北田 - 補拍後全景)',
        cropName: '青江白菜 (第3期作)',
        algorithm: selectedAlgo,
        submittedAt: new Date().toLocaleTimeString('zh-TW', { hour12: false }),
        gpuInstanceType: selectedGpu,
        computeDurationMinutes: selectedAlgo === 'GAUSSIAN_SPLATTING_3D' ? 14 : 32,
        estimatedCostTWD: calculateGpuCostTwd(selectedGpu, selectedAlgo === 'GAUSSIAN_SPLATTING_3D' ? 14 : 32),
        status: 'COMPLETED',
        sparsePointsCount: 165000,
        denseVerticesCount: 2400000,
        fileSizeMb: 92.4,
        spatialAccuracyMeters: 0.028,
        legalNotice: '【視覺參考模型】本點雲僅為農事生長紀錄與株高估算輔助，不具《國土測繪法》法定地籍測量之法律效力。',
      };
      setReconstructionJobs([newJob, ...reconstructionJobs]);
      setIsSubmittingJob(false);
    }, 700);
  };

  // 3D 視覺化視角控制
  const [modelPitch, setModelPitch] = useState(25);
  const [modelYaw, setModelYaw] = useState(45);
  const [pointCloudDensity, setPointCloudDensity] = useState(80);
  const [renderMode, setRenderMode] = useState<'splat' | 'mesh' | 'ortho'>('splat');

  // ──────────────────────────────────────────────
  // 2. 實景 AR 田界投影控制與狀態
  // ──────────────────────────────────────────────
  const [cameraHeading, setCameraHeading] = useState(90); // 鏡頭朝東 90 度
  const [cameraPoseX, setCameraPoseX] = useState(0); // 本地東向坐標 0m
  const [cameraPoseY, setCameraPoseY] = useState(0); // 本地北向坐標 0m
  const [showObstacleMask, setShowObstacleMask] = useState(true);

  // 界標界址點 (以西螺北田為例：4 個角隅界樁點)
  const boundaryLandmarks: ARBoundaryPoint[] = [
    {
      id: 'bm-01',
      cadastreCode: '西螺鎮新安段0124-0000 (西北角水閘界樁)',
      wgs84: [120.46321, 23.78452],
      twd97Coord: [192340.5, 2631250.2],
      reprojectionPixel: [280, 420],
      distanceToCameraMeters: 8.4,
      isOccludedByObstacle: false,
    },
    {
      id: 'bm-02',
      cadastreCode: '西螺鎮新安段0124-0000 (東北角與林伯田界標)',
      wgs84: [120.46385, 23.78456],
      twd97Coord: [192405.8, 2631254.1],
      reprojectionPixel: [720, 390],
      distanceToCameraMeters: 14.2,
      isOccludedByObstacle: true, // 作物生長茂盛遮擋
    },
    {
      id: 'bm-03',
      cadastreCode: '西螺鎮新安段0125-0000 (東南角排水溝界標)',
      wgs84: [120.46382, 23.78415],
      twd97Coord: [192402.1, 2631208.7],
      reprojectionPixel: [840, 520],
      distanceToCameraMeters: 18.6,
      isOccludedByObstacle: false,
    },
    {
      id: 'bm-04',
      cadastreCode: '西螺鎮新安段0125-0000 (西南角工寮邊界)',
      wgs84: [120.46318, 23.78411],
      twd97Coord: [192337.2, 2631204.3],
      reprojectionPixel: [190, 550],
      distanceToCameraMeters: 6.1,
      isOccludedByObstacle: false,
    },
  ];

  // 實時幾何重投影計算
  const calculatedProjection = reprojectCadastrePoint(
    10, // 界標在鏡頭前東向 10m
    5,  // 北向 5m
    { x: cameraPoseX, y: cameraPoseY, headingDegrees: cameraHeading },
    { focalPx: 800, principalX: 480, principalY: 360 }
  );

  // ──────────────────────────────────────────────
  // 3. DJI 無人機遙測日誌整合狀態
  // ──────────────────────────────────────────────
  const [droneLogs, setDroneLogs] = useState<DroneTelemetryLog[]>([
    {
      id: 'drone-flight-01',
      flightMissionName: '20261019_西螺北田全區航照_空拍機01',
      droneModel: 'DJI_MAVIC_3_ENTERPRISE',
      recordedAt: '2026-10-19 06:15',
      totalFlightMinutes: 18.5,
      flightAltitudeMetersAGL: 45.0,
      flightAltitudeMetersMSL: 68.2,
      gimbalPitchAngleDegrees: -90.0, // 正俯視
      rtkStatus: 'RTK_FIXED_HIGH_PRECISION',
      horizontalAccuracyMeters: 0.018, // 1.8 公分超高精度
      shutterTriggerCount: 84,
      imuInterpolationFrequencyHz: 50,
      shutterTimeOffsetMs: 4.2,
      gcsFlightDataPath: 'gs://farmland-diary-raw/ws-001/flight-01/telemetry_interpolated.csv',
    },
  ]);

  // ──────────────────────────────────────────────
  // 4. 臺灣官方產銷履歷 (TAP) 與天然災害救助報表
  // ──────────────────────────────────────────────
  const [traceabilityPackage] = useState<OfficialTraceabilityPackage>({
    id: 'tap-pkg-20261019-01',
    workspaceId: 'ws-tw-xiluo-001',
    cropSeasonId: 'crop-season-2026-01',
    cropName: '青江白菜 (三津一號)',
    applicantFarmerName: '林家豪 (西螺大橋下青農合作社)',
    cadastreParcels: ['西螺鎮新安段0124-0000', '西螺鎮新安段0125-0000'],
    cultivationAreaHectares: 0.42,
    packageGenerationDate: '2026-10-19',
    tapComplianceStatus: evaluateTapCompliance({
      hasUnconfirmedSpray: false,
      hasBannedPesticide: false,
      isHarvestDateRecorded: true,
      totalTaskLogsCount: 6,
    }),
    totalTasksRecorded: 6,
    sprayPesticideFreeConfirmed: true,
    fertilizerFormulasUsed: ['台肥黑王一號有機質特43號複合肥料 (40kg/包)'],
    harvestBatchSummary: {
      totalHarvestKg: 580.0,
      firstHarvestDate: '2026-10-18',
      lastHarvestDate: '2026-10-18',
      lotTraceCode: 'TW-TAP-2026-094821',
    },
    digitalSignatureHash: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
    downloadablePdfUrl: 'https://farmland-diary.app/reports/tap-traceability-20261019.pdf',
    moaOfficialNotice: '依據農業部產銷履歷農產品驗證基準，本清冊已通過全期作未施用公告限制用藥自動稽核。',
  });

  const [disasterPackage] = useState<DisasterProofPackage>({
    id: 'disaster-pkg-2026-01',
    disasterCaseId: 'disaster-case-01',
    disasterEventName: '115年7月強烈颱風凱米農損救助案件',
    affectedFieldNames: ['大同路後底大坵 (北田)'],
    cadastreParcels: ['西螺鎮新安段0124-0000'],
    totalLossEstimatedTWD: 63000,
    claimedDamagePercentage: 35,
    satelliteBeforeComparisonUrl: 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=600&q=80',
    fieldInspectionAfterPhotos: [
      {
        photoId: 'photo-after-01',
        timestamp: '2026-07-26 14:15:30',
        twd97Coord: [192360.2, 2631230.8],
        gpsWgs84: [120.4635, 23.7844],
        headingDegrees: 185,
        watermarkText: '經緯 23.7844N 120.4635E | 雲林西螺新安段0124 | 115-07-26 14:15 | SHA:8f2a41',
        photoUrl: 'https://images.unsplash.com/photo-1592417817098-8f3d69104a49?auto=format&fit=crop&w=600&q=80',
      },
    ],
    governmentFormCode: '農業天然災害救助申請表 (農災字第115-08號)',
    generatedAt: '2026-10-19 08:00',
    applicantSignatureConfirmed: true,
    exportArchiveZipUrl: 'https://farmland-diary.app/reports/disaster-proof-package-115-08.zip',
    legalDisclaimer: '【法規申報備註】本備件封裝包為「農田日記」自動匯總之歷史農作、地籍比對與帶有時間空間簽章照片，AI 推算受損率 (35%) 僅供申報初審備件參考，正式核定救助金仍以鄉鎮市區公所現地抽查認定為準。',
  });

  return (
    <div className="space-y-8 pb-16">
      {/* 頁面標頭與技術原則說明 */}
      <div className="bg-gradient-to-br from-stone-900 via-stone-900 to-emerald-950/30 border border-emerald-800/40 rounded-2xl p-6 sm:p-8">
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mb-4">
          <div className="flex items-center gap-3">
            <span className="p-3 bg-emerald-900/60 border border-emerald-700/50 rounded-xl text-emerald-300">
              <Box className="w-6 h-6" />
            </span>
            <div>
              <div className="flex items-center gap-2">
                <h2 className="text-xl sm:text-2xl font-bold text-white tracking-tight">
                  第五階段：三維重建、實景 AR 田界、無人機遙測與官方報表
                </h2>
                <span className="px-2.5 py-0.5 rounded-full bg-emerald-950 text-emerald-300 border border-emerald-800 text-xs font-mono font-medium">
                  Phase 5 Full Stack
                </span>
              </div>
              <p className="text-sm text-stone-400 mt-1">
                落實主提示詞第 10、13 條規範：雲端非同步重運算、手機輕量化投影、無人機 SLERP 姿態插值與產銷履歷 (TAP) / 災害救助官方備件封裝。
              </p>
            </div>
          </div>

          <div className="px-4 py-2 bg-stone-800/80 rounded-xl border border-stone-700 text-xs text-stone-300">
            <span className="text-stone-400 block mb-0.5">重運算原則</span>
            <span className="text-emerald-300 font-semibold">手機端只負責顯示，雲端 GPU 實時核算費用</span>
          </div>
        </div>

        {/* 四大子模組導航切換 */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-2 pt-4 border-t border-stone-800 text-xs">
          <button
            onClick={() => setActiveTab('3d_pipeline')}
            className={`p-3 rounded-xl border flex items-center gap-2.5 transition-colors text-left ${
              activeTab === '3d_pipeline'
                ? 'bg-emerald-900/40 border-emerald-600 text-emerald-200'
                : 'bg-stone-800/40 border-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <Box className="w-4 h-4 text-emerald-400 shrink-0" />
            <div>
              <div className="font-semibold text-white">1. 雲端三維重建管線</div>
              <div className="text-[11px] text-stone-400">3DGS / Nerf / COLMAP</div>
            </div>
          </button>

          <button
            onClick={() => setActiveTab('ar_projection')}
            className={`p-3 rounded-xl border flex items-center gap-2.5 transition-colors text-left ${
              activeTab === 'ar_projection'
                ? 'bg-emerald-900/40 border-emerald-600 text-emerald-200'
                : 'bg-stone-800/40 border-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <Smartphone className="w-4 h-4 text-emerald-400 shrink-0" />
            <div>
              <div className="font-semibold text-white">2. 實景 AR 田界投影</div>
              <div className="text-[11px] text-stone-400">TWD97 地號相機內參疊合</div>
            </div>
          </button>

          <button
            onClick={() => setActiveTab('drone_telemetry')}
            className={`p-3 rounded-xl border flex items-center gap-2.5 transition-colors text-left ${
              activeTab === 'drone_telemetry'
                ? 'bg-emerald-900/40 border-emerald-600 text-emerald-200'
                : 'bg-stone-800/40 border-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <Plane className="w-4 h-4 text-emerald-400 shrink-0" />
            <div>
              <div className="font-semibold text-white">3. DJI 無人機遙測校準</div>
              <div className="text-[11px] text-stone-400">50Hz SLERP 快門時間插值</div>
            </div>
          </button>

          <button
            onClick={() => setActiveTab('official_reports')}
            className={`p-3 rounded-xl border flex items-center gap-2.5 transition-colors text-left ${
              activeTab === 'official_reports'
                ? 'bg-emerald-900/40 border-emerald-600 text-emerald-200'
                : 'bg-stone-800/40 border-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <FileText className="w-4 h-4 text-emerald-400 shrink-0" />
            <div>
              <div className="font-semibold text-white">4. TAP 履歷與災損備件</div>
              <div className="text-[11px] text-stone-400">數位簽章雜湊與證明導出</div>
            </div>
          </button>
        </div>
      </div>

      {/* ──────────────────────────────────────────────────────── */}
      {/* 1. 雲端三維重建管線 (3D Pipeline) */}
      {/* ──────────────────────────────────────────────────────── */}
      {activeTab === '3d_pipeline' && (
        <div className="space-y-6">
          {/* 發起重建卡片與 GPU 費用試算 */}
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Cpu className="w-5 h-5 text-emerald-400" />
                <h3 className="text-base font-bold text-white">發起非同步雲端三維重建任務 (Cloud Run GPU Worker)</h3>
              </div>
              <span className="text-xs text-amber-400 bg-amber-950/80 px-2.5 py-1 rounded-lg border border-amber-800/80 flex items-center gap-1.5">
                <AlertTriangle className="w-3.5 h-3.5" />
                <span>非同步執行，不佔用手機電量與 CPU</span>
              </span>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
              <div>
                <label className="block text-xs font-medium text-stone-300 mb-2">選擇重建演算法</label>
                <select
                  value={selectedAlgo}
                  onChange={(e) => setSelectedAlgo(e.target.value as ReconstructionAlgorithm)}
                  className="w-full bg-stone-800 border border-stone-700 rounded-xl px-3 py-2 text-xs text-stone-200 focus:outline-none focus:border-emerald-500"
                >
                  <option value="GAUSSIAN_SPLATTING_3D">3D Gaussian Splatting (高光澤葉面/果實細節，約12分)</option>
                  <option value="NERF_STUDIO_SPLATO">NerfStudio Splatfacto (神經輻射場光影，約18分)</option>
                  <option value="COLMAP_OPENMVS_MESH">COLMAP + OpenMVS (高精度三角幾何網格，約28分)</option>
                </select>
              </div>

              <div>
                <label className="block text-xs font-medium text-stone-300 mb-2">GPU 實例規格 (GCP)</label>
                <select
                  value={selectedGpu}
                  onChange={(e) => setSelectedGpu(e.target.value as any)}
                  className="w-full bg-stone-800 border border-stone-700 rounded-xl px-3 py-2 text-xs text-stone-200 focus:outline-none focus:border-emerald-500"
                >
                  <option value="GCP_T4_16GB">NVIDIA T4 16GB (經濟型，每小時 $11.4 NTD)</option>
                  <option value="GCP_L4_24GB">NVIDIA L4 24GB (推薦型，每小時 $22.8 NTD)</option>
                  <option value="GCP_A10G_24GB">NVIDIA A10G 24GB (高頻寬，每小時 $34.1 NTD)</option>
                </select>
              </div>

              <div>
                <label className="block text-xs font-medium text-stone-300 mb-2">預估計算成本 (透明無隱藏加成)</label>
                <div className="bg-stone-800/80 border border-stone-700/80 rounded-xl px-3 py-2 flex items-center justify-between text-xs">
                  <span className="text-stone-400">核算費用：</span>
                  <span className="text-emerald-400 font-bold text-sm">
                    ~NT$ {calculateGpuCostTwd(selectedGpu, selectedAlgo === 'GAUSSIAN_SPLATTING_3D' ? 14 : 28)} 元
                  </span>
                </div>
              </div>
            </div>

            <div className="flex items-center justify-between pt-4 border-t border-stone-800">
              <div className="text-xs text-stone-400">
                依據巡田階段 <code>session-insp-20261019-01</code>（共 42 張驗證合格影像與相機內參）進行特徵萃取。
              </div>
              <button
                onClick={handleLaunchReconstruction}
                disabled={isSubmittingJob}
                className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-medium flex items-center gap-2 transition-colors disabled:opacity-50"
              >
                {isSubmittingJob ? (
                  <>
                    <RefreshCw className="w-3.5 h-3.5 animate-spin" />
                    <span>派送任務至 GCP Cloud Run Job...</span>
                  </>
                ) : (
                  <>
                    <Sparkles className="w-3.5 h-3.5" />
                    <span>啟動雲端重建</span>
                  </>
                )}
              </button>
            </div>
          </div>

          {/* 互動式 3D 成果視圖模擬器 */}
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-4">
              <div>
                <h3 className="text-base font-bold text-white flex items-center gap-2">
                  <Eye className="w-5 h-5 text-emerald-400" />
                  <span>3D 模型成果即時互動視圖 (WebGL / Three.js 模擬)</span>
                </h3>
                <p className="text-xs text-stone-400 mt-1">
                  西螺北田第 1~4 畦青江白菜株高與畦面覆蓋重建模型 (點雲特徵：1,840,000 pts)
                </p>
              </div>

              {/* 渲染模式切換 */}
              <div className="flex items-center bg-stone-800 rounded-lg p-1 border border-stone-700 text-xs">
                <button
                  onClick={() => setRenderMode('splat')}
                  className={`px-3 py-1 rounded font-medium ${renderMode === 'splat' ? 'bg-emerald-700 text-white' : 'text-stone-400 hover:text-stone-200'}`}
                >
                  3D 高斯橢球
                </button>
                <button
                  onClick={() => setRenderMode('mesh')}
                  className={`px-3 py-1 rounded font-medium ${renderMode === 'mesh' ? 'bg-emerald-700 text-white' : 'text-stone-400 hover:text-stone-200'}`}
                >
                  三角網格 TIN
                </button>
                <button
                  onClick={() => setRenderMode('ortho')}
                  className={`px-3 py-1 rounded font-medium ${renderMode === 'ortho' ? 'bg-emerald-700 text-white' : 'text-stone-400 hover:text-stone-200'}`}
                >
                  正射鑲嵌圖
                </button>
              </div>
            </div>

            {/* 3D 畫布模擬視窗 */}
            <div className="relative w-full h-80 bg-stone-950 rounded-xl border border-stone-800 overflow-hidden flex items-center justify-center">
              {/* 背景網格線 (模擬 3D 空間地平面) */}
              <div
                className="absolute inset-0 opacity-20 pointer-events-none"
                style={{
                  backgroundImage:
                    'linear-gradient(to right, #059669 1px, transparent 1px), linear-gradient(to bottom, #059669 1px, transparent 1px)',
                  backgroundSize: '24px 24px',
                  transform: `perspective(600px) rotateX(${modelPitch}deg) rotateZ(${modelYaw * 0.2}deg)`,
                }}
              />

              {/* 模擬重建田區作物群聚點 */}
              <div
                className="relative z-10 transition-transform duration-150 flex flex-col items-center justify-center"
                style={{
                  transform: `perspective(500px) rotateX(${modelPitch}deg) rotateY(${modelYaw}deg)`,
                }}
              >
                {/* 蔬菜畦面與點雲視覺化 */}
                <div className="w-64 h-44 bg-gradient-to-tr from-emerald-950 via-stone-900 to-emerald-900/60 border-2 border-dashed border-emerald-500/60 rounded-xl shadow-2xl p-4 flex flex-col justify-between">
                  <div className="flex justify-between items-center text-[10px] text-emerald-300 font-mono">
                    <span>SECTOR: NORTH_RIDGE_1-4</span>
                    <span>TWD97: 192340, 2631250</span>
                  </div>

                  <div className="grid grid-cols-4 gap-2 my-auto">
                    {[1, 2, 3, 4].map((ridge) => (
                      <div key={ridge} className="flex flex-col items-center gap-1">
                        <div
                          className={`w-10 h-16 rounded-md flex items-center justify-center text-[10px] font-mono transition-all ${
                            renderMode === 'splat'
                              ? 'bg-emerald-600/60 border border-emerald-400 text-emerald-100 shadow-[0_0_12px_rgba(16,185,129,0.3)]'
                              : renderMode === 'mesh'
                              ? 'bg-amber-900/40 border border-amber-500 text-amber-200'
                              : 'bg-emerald-900/80 border border-emerald-700 text-emerald-300'
                          }`}
                        >
                          畦 {ridge}
                        </div>
                        <span className="text-[9px] text-stone-400">高24cm</span>
                      </div>
                    ))}
                  </div>

                  <div className="flex justify-between text-[10px] text-stone-400">
                    <span>公差: ±0.032m</span>
                    <span className="text-emerald-400">密度: {pointCloudDensity}%</span>
                  </div>
                </div>
              </div>

              {/* 畫面上疊加視角資訊與免責聲明 */}
              <div className="absolute top-3 left-3 bg-stone-900/90 border border-stone-800 rounded-lg px-2.5 py-1.5 text-[11px] text-stone-300 backdrop-blur-sm">
                <div>俯仰角: <span className="text-emerald-400 font-mono">{modelPitch}°</span> | 偏航角: <span className="text-emerald-400 font-mono">{modelYaw}°</span></div>
                <div className="text-[10px] text-stone-500 mt-0.5">滑動下方控制器調整空間角度</div>
              </div>

              <div className="absolute bottom-3 right-3 max-w-xs bg-amber-950/90 border border-amber-800/80 rounded-lg px-2.5 py-1.5 text-[10px] text-amber-300 backdrop-blur-sm">
                <ShieldCheck className="w-3.5 h-3.5 inline mr-1 text-amber-400" />
                視覺輔助模型，不具《國土測繪法》界址效力
              </div>
            </div>

            {/* 控制器 */}
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mt-4 pt-4 border-t border-stone-800 text-xs">
              <div>
                <label className="text-stone-400 block mb-1">空間俯仰角 (Pitch): {modelPitch}°</label>
                <input
                  type="range"
                  min="0"
                  max="60"
                  value={modelPitch}
                  onChange={(e) => setModelPitch(Number(e.target.value))}
                  className="w-full accent-emerald-500 bg-stone-800 rounded"
                />
              </div>

              <div>
                <label className="text-stone-400 block mb-1">水平旋轉角 (Yaw): {modelYaw}°</label>
                <input
                  type="range"
                  min="-180"
                  max="180"
                  value={modelYaw}
                  onChange={(e) => setModelYaw(Number(e.target.value))}
                  className="w-full accent-emerald-500 bg-stone-800 rounded"
                />
              </div>

              <div>
                <label className="text-stone-400 block mb-1">點雲顯示細緻度: {pointCloudDensity}%</label>
                <input
                  type="range"
                  min="20"
                  max="100"
                  value={pointCloudDensity}
                  onChange={(e) => setPointCloudDensity(Number(e.target.value))}
                  className="w-full accent-emerald-500 bg-stone-800 rounded"
                />
              </div>
            </div>
          </div>

          {/* 重建歷史紀錄與檔案下載清單 */}
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <h3 className="text-base font-bold text-white mb-4 flex items-center gap-2">
              <Layers className="w-5 h-5 text-emerald-400" />
              <span>雲端成果產物清冊 (GCS 儲存與授權下載)</span>
            </h3>

            <div className="space-y-3">
              {reconstructionJobs.map((job) => (
                <div key={job.id} className="p-4 bg-stone-800/40 rounded-xl border border-stone-700/60 flex flex-col md:flex-row md:items-center justify-between gap-3">
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-sm text-white">{job.fieldName}</span>
                      <span className="px-2 py-0.5 rounded text-[10px] bg-emerald-950 text-emerald-300 border border-emerald-800 font-mono">
                        {job.algorithm}
                      </span>
                      <span className="text-xs text-stone-400">({job.cropName})</span>
                    </div>

                    <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-stone-400 mt-1.5">
                      <span>送出時間: <strong className="text-stone-200">{job.submittedAt}</strong></span>
                      <span>計算規格: <strong className="text-stone-200">{job.gpuInstanceType} ({job.computeDurationMinutes}分)</strong></span>
                      <span>實計費用: <strong className="text-emerald-400">NT$ {job.estimatedCostTWD}</strong></span>
                      <span>幾何公差: <strong className="text-stone-200">±{job.spatialAccuracyMeters}m</strong></span>
                      <span>大小: <strong className="text-stone-200">{job.fileSizeMb} MB</strong></span>
                    </div>

                    <p className="text-[11px] text-amber-400/90 mt-1">
                      {job.legalNotice}
                    </p>
                  </div>

                  <div className="flex items-center gap-2 shrink-0">
                    <button className="px-3 py-1.5 bg-stone-800 hover:bg-stone-700 text-stone-200 rounded-lg text-xs font-medium border border-stone-600 flex items-center gap-1.5 transition-colors">
                      <Download className="w-3.5 h-3.5" />
                      <span>下載 PLY/OBJ</span>
                    </button>
                    <button className="px-3 py-1.5 bg-emerald-800/80 hover:bg-emerald-700 text-white rounded-lg text-xs font-medium border border-emerald-600 flex items-center gap-1.5 transition-colors">
                      <Eye className="w-3.5 h-3.5" />
                      <span>查看正射圖</span>
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* ──────────────────────────────────────────────────────── */}
      {/* 2. 實景 AR 田界投影 (AR Boundary Projection) */}
      {/* ──────────────────────────────────────────────────────── */}
      {activeTab === 'ar_projection' && (
        <div className="space-y-6">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Smartphone className="w-5 h-5 text-emerald-400" />
                <h3 className="text-base font-bold text-white">實景相機 AR 地籍界標疊合投影模擬器</h3>
              </div>
              <span className="text-xs text-emerald-400 bg-emerald-950 px-2.5 py-1 rounded-lg border border-emerald-800">
                WGS84 轉 TWD97 投影坐標
              </span>
            </div>

            <p className="text-xs text-stone-300 leading-relaxed mb-6">
              此功能供家庭農場經營者或長輩站在田埂上時，藉由手機鏡頭畫面快速辨認：<strong>「哪一畦是我們的承租地、哪一畦是隔壁林伯的地界」</strong>。系統結合相機內參矩陣 ($f_x, f_y, c_x, c_y$) 與 6DoF 姿態，動態投影地籍圖界標點，並標示空間公差。
            </p>

            {/* AR 相機觀景窗模擬 */}
            <div className="relative w-full h-96 bg-stone-950 rounded-xl border border-stone-800 overflow-hidden shadow-inner flex flex-col justify-between p-4">
              {/* 背景相機畫面模擬 (蔬菜田田埂實景) */}
              <div
                className="absolute inset-0 bg-cover bg-center opacity-40 pointer-events-none"
                style={{
                  backgroundImage:
                    'url(https://images.unsplash.com/photo-1592417817098-8f3d69104a49?auto=format&fit=crop&w=1200&q=80)',
                }}
              />

              {/* 頂部相機姿態 HUD */}
              <div className="relative z-10 flex items-center justify-between bg-stone-900/90 border border-stone-700/80 rounded-xl p-3 text-xs text-stone-200 backdrop-blur-sm">
                <div className="flex items-center gap-4">
                  <span className="flex items-center gap-1.5 text-emerald-400">
                    <Compass className="w-4 h-4 animate-spin-slow" />
                    <span>鏡頭朝向: <strong>{cameraHeading}° (東)</strong></span>
                  </span>
                  <span>相機高度: <strong>1.2m</strong></span>
                  <span>重投影誤差: <strong className="text-emerald-300">±0.08m</strong></span>
                </div>

                <div className="flex items-center gap-2">
                  <label className="flex items-center gap-1.5 text-xs text-stone-300 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={showObstacleMask}
                      onChange={(e) => setShowObstacleMask(e.target.checked)}
                      className="rounded accent-emerald-500"
                    />
                    <span>啟用遮擋羽化 (作物遮擋不強繪)</span>
                  </label>
                </div>
              </div>

              {/* AR 疊合投影界標點 (動態計算投影座標) */}
              <div className="relative z-10 flex-1 my-4 pointer-events-none">
                {boundaryLandmarks.map((point) => (
                  <div
                    key={point.id}
                    className="absolute transition-all duration-300"
                    style={{
                      left: `${(point.reprojectionPixel[0] / 960) * 100}%`,
                      top: `${(point.reprojectionPixel[1] / 600) * 100}%`,
                      transform: 'translate(-50%, -100%)',
                    }}
                  >
                    {/* 界標旗標或圓標 */}
                    <div className="flex flex-col items-center">
                      <div
                        className={`px-2.5 py-1 rounded-lg text-[10px] font-bold shadow-lg border backdrop-blur-md flex items-center gap-1.5 ${
                          point.isOccludedByObstacle && showObstacleMask
                            ? 'bg-amber-950/80 border-amber-500/60 text-amber-200 opacity-60'
                            : 'bg-emerald-950/90 border-emerald-400 text-emerald-200'
                        }`}
                      >
                        <MapPin className="w-3 h-3 text-emerald-400" />
                        <span>{point.cadastreCode.split(' ')[0]}</span>
                        <span className="text-[9px] text-stone-300">({point.distanceToCameraMeters}m)</span>
                      </div>

                      {/* 垂直指示線指向地面標石 */}
                      <div className="w-0.5 h-6 bg-emerald-400/80 shadow-[0_0_8px_#34d399]" />
                      <div className="w-3 h-3 rounded-full bg-emerald-400 border-2 border-white shadow-md animate-ping" />
                    </div>
                  </div>
                ))}

                {/* 投影境界虛線 (連接界標 1 與界標 2) */}
                <svg className="absolute inset-0 w-full h-full pointer-events-none">
                  <line
                    x1="29%"
                    y1="70%"
                    x2="75%"
                    y2="65%"
                    stroke="#10b981"
                    strokeWidth="3"
                    strokeDasharray="6,4"
                    strokeOpacity="0.8"
                  />
                  <line
                    x1="75%"
                    y1="65%"
                    x2="87%"
                    y2="86%"
                    stroke="#10b981"
                    strokeWidth="3"
                    strokeDasharray="6,4"
                    strokeOpacity="0.8"
                  />
                </svg>
              </div>

              {/* 底部現場提示 */}
              <div className="relative z-10 flex items-center justify-between bg-stone-900/90 border border-stone-700/80 rounded-xl p-3 text-xs backdrop-blur-sm">
                <div className="text-stone-300">
                  <span className="text-emerald-400 font-bold mr-1">現場辨認：</span>
                  第 1~4 畦在綠色虛線以西為本農場承租範圍；東北角標石被鄰田玉米遮擋已自動提示。
                </div>
                <span className="text-[11px] text-stone-400 font-mono">
                  計算: reprojectCadastrePoint()
                </span>
              </div>
            </div>

            {/* 姿態與朝向模擬滑桿 */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4 pt-4 border-t border-stone-800 text-xs">
              <div>
                <label className="text-stone-300 block mb-1">
                  模擬手機旋轉朝向 (Heading): <strong className="text-emerald-400">{cameraHeading}°</strong>
                </label>
                <input
                  type="range"
                  min="0"
                  max="360"
                  value={cameraHeading}
                  onChange={(e) => setCameraHeading(Number(e.target.value))}
                  className="w-full accent-emerald-500 bg-stone-800 rounded"
                />
              </div>

              <div>
                <label className="text-stone-300 block mb-1">
                  模擬相機東西向移動: <strong className="text-emerald-400">{cameraPoseX}m</strong>
                </label>
                <input
                  type="range"
                  min="-20"
                  max="20"
                  value={cameraPoseX}
                  onChange={(e) => setCameraPoseX(Number(e.target.value))}
                  className="w-full accent-emerald-500 bg-stone-800 rounded"
                />
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ──────────────────────────────────────────────────────── */}
      {/* 3. DJI 無人機遙測日誌整合 (Drone Telemetry) */}
      {/* ──────────────────────────────────────────────────────── */}
      {activeTab === 'drone_telemetry' && (
        <div className="space-y-6">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Plane className="w-5 h-5 text-emerald-400" />
                <h3 className="text-base font-bold text-white">DJI Mobile SDK V5 遙測日誌與快門時間校準 (SLERP)</h3>
              </div>
              <span className="text-xs text-blue-400 bg-blue-950 px-2.5 py-1 rounded-lg border border-blue-800 font-mono">
                50Hz IMU Interpolation
              </span>
            </div>

            <p className="text-xs text-stone-300 leading-relaxed mb-6">
              無人機在田區進行航照時，相機快門觸發頻率（約 1~2 Hz）與飛行控制 IMU 陀螺儀（50 Hz）具有毫秒級時間落差。系統透過<strong>球面四元數線性插值 (SLERP)</strong> 校準曝光中點之瞬間經緯度與航向角，確保正射鑲嵌與高度公差在 2 公分內。
            </p>

            <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
              <div className="p-4 bg-stone-800/40 rounded-xl border border-stone-700/60">
                <span className="text-stone-400 text-xs block mb-1">無人機型號</span>
                <span className="text-white font-bold text-sm">DJI Mavic 3 Enterprise</span>
                <span className="text-[11px] text-emerald-400 block mt-1">RTK 高精度模組</span>
              </div>

              <div className="p-4 bg-stone-800/40 rounded-xl border border-stone-700/60">
                <span className="text-stone-400 text-xs block mb-1">RTK 狀態與定位精度</span>
                <span className="text-emerald-400 font-bold text-sm flex items-center gap-1.5">
                  <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                  <span>RTK_FIXED (±1.8 cm)</span>
                </span>
                <span className="text-[11px] text-stone-400 block mt-1">地面相對高度 45.0m</span>
              </div>

              <div className="p-4 bg-stone-800/40 rounded-xl border border-stone-700/60">
                <span className="text-stone-400 text-xs block mb-1">快門時間延遲補償</span>
                <span className="text-amber-400 font-bold text-sm font-mono">+4.2 ms (毫秒)</span>
                <span className="text-[11px] text-stone-400 block mt-1">消除 8.4 cm 飛行位移偏誤</span>
              </div>

              <div className="p-4 bg-stone-800/40 rounded-xl border border-stone-700/60">
                <span className="text-stone-400 text-xs block mb-1">有效曝光張數</span>
                <span className="text-white font-bold text-sm">84 張 (100% 同步)</span>
                <span className="text-[11px] text-stone-400 block mt-1">飛行航時 18.5 分鐘</span>
              </div>
            </div>

            {/* 航線軌跡與曝光點清單 */}
            <div className="p-4 bg-stone-950 rounded-xl border border-stone-800">
              <h4 className="text-xs font-bold text-stone-300 mb-3 flex items-center gap-2">
                <Clock className="w-4 h-4 text-emerald-400" />
                <span>航照曝光中心點校準紀錄抽樣 (Sample 1~4)</span>
              </h4>

              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs">
                  <thead className="bg-stone-900 text-stone-400 font-medium">
                    <tr>
                      <th className="py-2 px-3">照片序號</th>
                      <th className="py-2 px-3">曝光時間 (UTC+8)</th>
                      <th className="py-2 px-3">WGS84 [經度, 緯度]</th>
                      <th className="py-2 px-3">TWD97 座標 [X, Y]</th>
                      <th className="py-2 px-3">姿態角 [Yaw, Pitch, Roll]</th>
                      <th className="py-2 px-3">校準狀態</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-stone-800 text-stone-300">
                    <tr>
                      <td className="py-2 px-3 font-mono">DJI_0041.JPG</td>
                      <td className="py-2 px-3">06:17:12.418</td>
                      <td className="py-2 px-3 font-mono">120.463321, 23.784512</td>
                      <td className="py-2 px-3 font-mono">192341.2, 2631249.8</td>
                      <td className="py-2 px-3 font-mono">89.4°, -90.0°, 0.2°</td>
                      <td className="py-2 px-3 text-emerald-400">SLERP 校準完成</td>
                    </tr>
                    <tr>
                      <td className="py-2 px-3 font-mono">DJI_0042.JPG</td>
                      <td className="py-2 px-3">06:17:15.820</td>
                      <td className="py-2 px-3 font-mono">120.463452, 23.784515</td>
                      <td className="py-2 px-3 font-mono">192354.5, 2631250.1</td>
                      <td className="py-2 px-3 font-mono">89.8°, -89.9°, -0.1°</td>
                      <td className="py-2 px-3 text-emerald-400">SLERP 校準完成</td>
                    </tr>
                    <tr>
                      <td className="py-2 px-3 font-mono">DJI_0043.JPG</td>
                      <td className="py-2 px-3">06:17:19.224</td>
                      <td className="py-2 px-3 font-mono">120.463583, 23.784518</td>
                      <td className="py-2 px-3 font-mono">192367.8, 2631250.4</td>
                      <td className="py-2 px-3 font-mono">90.2°, -90.0°, 0.0°</td>
                      <td className="py-2 px-3 text-emerald-400">SLERP 校準完成</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ──────────────────────────────────────────────────────── */}
      {/* 4. TAP 履歷與災損備件 (Official Reports Export) */}
      {/* ──────────────────────────────────────────────────────── */}
      {activeTab === 'official_reports' && (
        <div className="space-y-6">
          {/* 臺灣產銷履歷 (TAP) 匯出檢驗 */}
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-4">
              <div className="flex items-center gap-3">
                <span className="p-2.5 bg-emerald-950 border border-emerald-700/60 rounded-xl text-emerald-300">
                  <QrCode className="w-5 h-5" />
                </span>
                <div>
                  <h3 className="text-base font-bold text-white">臺灣產銷履歷農產品 (TAP) 作業紀錄封裝導出</h3>
                  <p className="text-xs text-stone-400">對接農業部農糧署產銷履歷稽核標準格式與追溯條碼</p>
                </div>
              </div>

              <span className="px-3 py-1 bg-emerald-950 text-emerald-300 border border-emerald-800 rounded-full text-xs font-bold flex items-center gap-1.5">
                <CheckCircle2 className="w-3.5 h-3.5" />
                <span>TAP 合規稽核通過</span>
              </span>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6 text-xs">
              <div className="bg-stone-800/40 p-3.5 rounded-xl border border-stone-700/50">
                <span className="text-stone-400 block mb-1">栽培作物與品系</span>
                <span className="text-white font-bold">{traceabilityPackage.cropName}</span>
                <span className="text-[11px] text-stone-400 block mt-1">面積: {traceabilityPackage.cultivationAreaHectares} 公頃</span>
              </div>

              <div className="bg-stone-800/40 p-3.5 rounded-xl border border-stone-700/50">
                <span className="text-stone-400 block mb-1">地籍地號登記</span>
                <span className="text-white font-bold">{traceabilityPackage.cadastreParcels.join('、')}</span>
                <span className="text-[11px] text-emerald-400 block mt-1">已關聯地籍圖界址</span>
              </div>

              <div className="bg-stone-800/40 p-3.5 rounded-xl border border-stone-700/50">
                <span className="text-stone-400 block mb-1">產銷履歷追溯碼 (Lot)</span>
                <span className="text-emerald-400 font-mono font-bold">{traceabilityPackage.harvestBatchSummary.lotTraceCode}</span>
                <span className="text-[11px] text-stone-400 block mt-1">採收量: {traceabilityPackage.harvestBatchSummary.totalHarvestKg} kg</span>
              </div>
            </div>

            {/* 用藥與施肥稽核摘要 */}
            <div className="p-4 bg-stone-950 rounded-xl border border-stone-800 text-xs mb-6">
              <div className="flex items-center gap-2 text-emerald-400 font-bold mb-2">
                <ShieldCheck className="w-4 h-4" />
                <span>全期作安全管理自主稽核結論</span>
              </div>
              <ul className="space-y-1.5 text-stone-300">
                <li>• <strong>農藥管制自主查驗：</strong>全期作共 6 筆農事紀錄，均明確核定「未施用任何公告限制農藥」，符合安全採收標準。</li>
                <li>• <strong>肥料登記：</strong>使用 {traceabilityPackage.fertilizerFormulasUsed[0]}，符合國產有機質肥料推廣規定。</li>
                <li>• <strong>數位防偽：</strong>SHA-256 簽章雜湊 <code>{traceabilityPackage.digitalSignatureHash.substring(0, 32)}...</code></li>
              </ul>
            </div>

            <div className="flex items-center justify-between pt-4 border-t border-stone-800">
              <span className="text-xs text-stone-400">
                {traceabilityPackage.moaOfficialNotice}
              </span>
              <button className="px-4 py-2 bg-emerald-700 hover:bg-emerald-600 text-white rounded-xl text-xs font-semibold flex items-center gap-2 transition-colors">
                <FileCheck className="w-4 h-4" />
                <span>匯出 TAP 標準證明 PDF (含防偽簽章)</span>
              </button>
            </div>
          </div>

          {/* 農業天然災害救助申請官方備件封裝包 */}
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-4">
              <div className="flex items-center gap-3">
                <span className="p-2.5 bg-amber-950 border border-amber-700/60 rounded-xl text-amber-300">
                  <AlertTriangle className="w-5 h-5" />
                </span>
                <div>
                  <h3 className="text-base font-bold text-white">{disasterPackage.disasterEventName} - 官方備件包裹</h3>
                  <p className="text-xs text-stone-400">{disasterPackage.governmentFormCode}</p>
                </div>
              </div>

              <span className="px-3 py-1 bg-amber-950 text-amber-300 border border-amber-800 rounded-full text-xs font-bold">
                備件草案就緒
              </span>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6 text-xs">
              <div className="bg-stone-800/40 p-3.5 rounded-xl border border-stone-700/50">
                <span className="text-stone-400 block mb-1">受損田區與地號</span>
                <span className="text-white font-bold">{disasterPackage.affectedFieldNames[0]}</span>
                <span className="text-[11px] text-stone-400 block mt-1">{disasterPackage.cadastreParcels[0]}</span>
              </div>

              <div className="bg-stone-800/40 p-3.5 rounded-xl border border-stone-700/50">
                <span className="text-stone-400 block mb-1">農家自估受損率</span>
                <span className="text-amber-400 font-bold text-sm">{disasterPackage.claimedDamagePercentage}% (達20%救助門檻)</span>
                <span className="text-[11px] text-stone-400 block mt-1">初估損失: NT$ {disasterPackage.totalLossEstimatedTWD.toLocaleString()}</span>
              </div>

              <div className="bg-stone-800/40 p-3.5 rounded-xl border border-stone-700/50">
                <span className="text-stone-400 block mb-1">官方浮水印相片</span>
                <span className="text-white font-bold">{disasterPackage.fieldInspectionAfterPhotos.length} 張完整空間簽章</span>
                <span className="text-[11px] text-emerald-400 block mt-1">經緯度 + TWD97 + 時間</span>
              </div>
            </div>

            {/* 災損照片浮水印範例展示 */}
            <div className="p-4 bg-stone-950 rounded-xl border border-stone-800 text-xs mb-6">
              <div className="flex items-center justify-between mb-3">
                <span className="text-stone-300 font-bold">勘災照片空間浮水印比對展示</span>
                <span className="text-[11px] text-stone-500 font-mono">符合公所現地勘查備件標準</span>
              </div>

              <div className="relative rounded-lg overflow-hidden border border-stone-800 h-48 bg-stone-900 flex items-end p-3">
                <div
                  className="absolute inset-0 bg-cover bg-center opacity-60"
                  style={{
                    backgroundImage: `url(${disasterPackage.fieldInspectionAfterPhotos[0].photoUrl})`,
                  }}
                />
                <div className="relative z-10 bg-black/80 text-amber-300 font-mono text-[11px] px-3 py-1.5 rounded-lg border border-amber-500/40 backdrop-blur-sm">
                  {disasterPackage.fieldInspectionAfterPhotos[0].watermarkText}
                </div>
              </div>
            </div>

            {/* 強制法律免責說明 */}
            <div className="p-4 bg-stone-800/50 rounded-xl border border-stone-700/60 text-xs text-stone-400 leading-relaxed mb-6">
              <AlertTriangle className="w-4 h-4 text-amber-400 inline mr-1.5" />
              {disasterPackage.legalDisclaimer}
            </div>

            <div className="flex items-center justify-between pt-4 border-t border-stone-800">
              <span className="text-xs text-stone-500">
                產生時間: {disasterPackage.generatedAt}
              </span>
              <button className="px-4 py-2 bg-amber-700 hover:bg-amber-600 text-white rounded-xl text-xs font-semibold flex items-center gap-2 transition-colors">
                <Download className="w-4 h-4" />
                <span>一鍵打包下載救助備件 ZIP (含申請表與標記照)</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
