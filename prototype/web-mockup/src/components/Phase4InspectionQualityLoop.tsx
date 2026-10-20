import React, { useState } from 'react';
import {
  DeviceCapabilityTier,
  FrameCaptureContract,
  ReshootTask,
  InspectionSession,
} from '../types/index.ts';
import {
  Camera,
  Smartphone,
  ShieldCheck,
  AlertTriangle,
  Compass,
  CheckCircle2,
  RefreshCw,
  Eye,
  Sliders,
  Cloud,
  Layers,
  ArrowRight,
  UserX,
  Target,
} from 'lucide-react';

export const Phase4InspectionQualityLoop: React.FC = () => {
  // 1. 裝置能力分級狀態
  const [selectedTier, setSelectedTier] = useState<DeviceCapabilityTier>('TIER_1_DEPTH_AR');

  // 2. 當前巡田工作階段狀態 (九階段狀態機)
  const [currentSession, setCurrentSession] = useState<InspectionSession>({
    id: 'session-insp-20261019-01',
    workspaceId: 'ws-tw-xiluo-001',
    fieldId: 'field-north-01',
    fieldName: '大同路後底大坵 (北田)',
    operatorName: '林家豪 (青農經營者)',
    startedAt: '2026-10-19 06:45',
    deviceTier: 'TIER_1_DEPTH_AR',
    totalFramesCaptured: 42,
    validFramesCount: 40,
    qualityStatus: 'RESHOOT_REQUIRED', // 初始展示偵測到遮擋，發布補拍任務
    reshootTasks: [
      {
        id: 'reshoot-01',
        sessionId: 'session-insp-20261019-01',
        fieldSegment: '北田第 4~5 畦西側田埂 (近工寮端)',
        reason: 'PERSON_OCCLUSION_UNREPLACEABLE',
        missingContentDescription: '工班提工具桶遮擋第 4 畦生長點，且相鄰前後影格均無法完整替代',
        suggestedHeadingDegrees: 285,
        priority: 'HIGH',
        status: 'PENDING',
      },
    ],
    cloudQualityReport: {
      coveragePercent: 88.5,
      averageBlurScore: 178.2,
      occlusionHandledRatio: '3處遮擋：2處替代真實影格，1處需補拍',
      isReadyFor3DOrAI: false,
    },
  });

  // 3. 採集影格模擬
  const [mockFrames, setMockFrames] = useState<FrameCaptureContract[]>([
    {
      frameId: 'frame-001',
      sessionId: 'session-insp-20261019-01',
      timestamp: '06:45:10',
      deviceTier: 'TIER_1_DEPTH_AR',
      focalLengthPx: [1024, 1024],
      principalPointPx: [512, 384],
      gpsCoordinate: [120.4633, 23.7845],
      gpsAccuracyMeters: 3.2,
      compassHeadingDegrees: 90,
      blurScore: 195.4,
      isBlurry: false,
      isPersonOccluded: false,
      hasAlternateCleanFrame: false,
      uploadStatus: 'UPLOADED',
    },
    {
      frameId: 'frame-012 (人物遮擋)',
      sessionId: 'session-insp-20261019-01',
      timestamp: '06:47:22',
      deviceTier: 'TIER_1_DEPTH_AR',
      gpsCoordinate: [120.4639, 23.7847],
      gpsAccuracyMeters: 2.8,
      compassHeadingDegrees: 120,
      blurScore: 180.1,
      isBlurry: false,
      isPersonOccluded: true,
      hasAlternateCleanFrame: true, // 雲端判定：相鄰 frame-013 有拍到，直接替代！
      uploadStatus: 'UPLOADED',
    },
    {
      frameId: 'frame-028 (重要遮擋未覆蓋)',
      sessionId: 'session-insp-20261019-01',
      timestamp: '06:50:05',
      deviceTier: 'TIER_1_DEPTH_AR',
      gpsCoordinate: [120.4642, 23.7848],
      gpsAccuracyMeters: 3.0,
      compassHeadingDegrees: 280,
      blurScore: 165.0,
      isBlurry: false,
      isPersonOccluded: true,
      hasAlternateCleanFrame: false, // 無法替代，發布補拍任務！
      uploadStatus: 'UPLOADED',
    },
    {
      frameId: 'frame-035 (模糊警示)',
      sessionId: 'session-insp-20261019-01',
      timestamp: '06:52:18',
      deviceTier: 'TIER_1_DEPTH_AR',
      gpsCoordinate: [120.4645, 23.7846],
      gpsAccuracyMeters: 4.1,
      compassHeadingDegrees: 180,
      blurScore: 68.2, // 模糊分數低於 100
      isBlurry: true,
      isPersonOccluded: false,
      hasAlternateCleanFrame: true,
      uploadStatus: 'UPLOADED',
    },
  ]);

  // 模擬使用者完成補拍
  const handleResolveReshoot = () => {
    setCurrentSession({
      ...currentSession,
      qualityStatus: 'PASSED', // 補拍通過 -> 採集通過
      reshootTasks: currentSession.reshootTasks.map(t => ({
        ...t,
        status: 'RESOLVED',
        resolvedFrameId: 'frame-043-reshoot',
      })),
      cloudQualityReport: {
        coveragePercent: 96.0,
        averageBlurScore: 185.0,
        occlusionHandledRatio: '100% 完整覆蓋 (補拍通過)',
        isReadyFor3DOrAI: true,
      },
    });
  };

  // 模擬推進至成果可用 (READY)
  const handleStartProcessing = () => {
    setCurrentSession({
      ...currentSession,
      qualityStatus: 'PROCESSING',
    });
    setTimeout(() => {
      setCurrentSession(prev => ({
        ...prev,
        qualityStatus: 'READY',
      }));
    }, 800);
  };

  return (
    <div className="space-y-6 pb-16">
      {/* 頂部引導卡片 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Camera className="w-5 h-5 text-emerald-400" />
            <h2 className="text-base font-bold text-white">
              第四階段手機巡田採集與品質閉環 (Phase 4 Inspection Quality Loop)
            </h2>
          </div>
          <span className="text-xs px-2.5 py-1 rounded-full bg-emerald-950 text-emerald-300 border border-emerald-800 font-mono">
            Phase 4 Active
          </span>
        </div>
        <p className="text-xs text-stone-400 mt-2 leading-relaxed">
          包含：<strong>多裝置能力分級 (不綁定高階硬體)、手機端防手震/模糊快篩、雲端遮擋判定與替代影格選擇、離場前引導補拍任務、九階段閉環狀態機</strong>。
        </p>

        {/* 核心原則標籤 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-3 pt-4 border-t border-stone-800 text-xs">
          <div className="bg-stone-950 p-3 rounded-xl border border-stone-800">
            <span className="text-stone-400 block font-medium">單一手機採集</span>
            <span className="text-emerald-300 font-semibold">不強制 RTK 外接量測或無人機</span>
          </div>
          <div className="bg-stone-950 p-3 rounded-xl border border-stone-800">
            <span className="text-stone-400 block font-medium">不頻繁折返原則</span>
            <span className="text-blue-300 font-semibold">相鄰真實影格優先替代，離場前統一查核</span>
          </div>
          <div className="bg-stone-950 p-3 rounded-xl border border-stone-800">
            <span className="text-stone-400 block font-medium">防偽鐵律</span>
            <span className="text-amber-300 font-semibold">嚴禁生成式 AI 補圖偽造現場</span>
          </div>
        </div>
      </div>

      {/* 1. Android / iOS 裝置能力分級選擇器 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="text-sm font-bold text-white flex items-center gap-2">
              <Smartphone className="w-4 h-4 text-emerald-400" />
              裝置硬體能力動態分級 (Hardware Capability Tiers)
            </h3>
            <p className="text-xs text-stone-400 mt-0.5">
              依現場手機實際感測能力自動降級適配，保障低階機型基本採集可靠性。
            </p>
          </div>
          <span className="text-xs px-2.5 py-0.5 rounded font-mono bg-stone-800 text-emerald-300 border border-stone-700">
            當前偵測：{selectedTier}
          </span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
          <button
            onClick={() => setSelectedTier('TIER_1_DEPTH_AR')}
            className={`p-4 rounded-xl text-left border transition-all ${
              selectedTier === 'TIER_1_DEPTH_AR'
                ? 'bg-emerald-950/60 border-emerald-500 text-white'
                : 'bg-stone-950 border-stone-800 text-stone-400 hover:border-stone-700'
            }`}
          >
            <div className="font-bold text-xs text-emerald-300 mb-1">等級一：深度與 AR (Tier 1)</div>
            <div className="text-xs font-semibold text-white">iOS ARKit / Android ARCore Depth</div>
            <div className="text-[11px] text-stone-400 mt-1">
              具備相機內參、6DoF 姿態追蹤與密集/稀疏深度圖，支援高精度公尺級空間定位。
            </div>
          </button>

          <button
            onClick={() => setSelectedTier('TIER_2_POSE_TRACKING')}
            className={`p-4 rounded-xl text-left border transition-all ${
              selectedTier === 'TIER_2_POSE_TRACKING'
                ? 'bg-emerald-950/60 border-emerald-500 text-white'
                : 'bg-stone-950 border-stone-800 text-stone-400 hover:border-stone-700'
            }`}
          >
            <div className="font-bold text-xs text-blue-300 mb-1">等級二：姿態追蹤 (Tier 2)</div>
            <div className="text-xs font-semibold text-white">6DoF 姿態估計 (無深度圖)</div>
            <div className="text-[11px] text-stone-400 mt-1">
              具備相機與視覺慣性里程計 (VIO) 軌跡，無密集深度，以多視角幾何交會計算位置。
            </div>
          </button>

          <button
            onClick={() => setSelectedTier('TIER_3_BASIC_CAMERA_GPS')}
            className={`p-4 rounded-xl text-left border transition-all ${
              selectedTier === 'TIER_3_BASIC_CAMERA_GPS'
                ? 'bg-emerald-950/60 border-emerald-500 text-white'
                : 'bg-stone-950 border-stone-800 text-stone-400 hover:border-stone-700'
            }`}
          >
            <div className="font-bold text-xs text-amber-300 mb-1">等級三：基礎相機 (Tier 3)</div>
            <div className="text-xs font-semibold text-white">相機 + GPS + 電子羅盤 (通用最低要求)</div>
            <div className="text-[11px] text-stone-400 mt-1">
              相容老舊或長輩平價手機，保存經緯度與鏡頭朝向角度，重度計算完全交給雲端。
            </div>
          </button>
        </div>
      </div>

      {/* 2. 巡田採集閉環狀態與進度 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-stone-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-sm font-bold text-white">{currentSession.fieldName}</span>
              <span className={`text-xs px-2.5 py-0.5 rounded font-mono font-bold border ${
                currentSession.qualityStatus === 'READY' ? 'bg-emerald-950 text-emerald-300 border-emerald-800' :
                currentSession.qualityStatus === 'PASSED' ? 'bg-blue-950 text-blue-300 border-blue-800' :
                currentSession.qualityStatus === 'RESHOOT_REQUIRED' ? 'bg-amber-950 text-amber-300 border-amber-800' :
                'bg-purple-950 text-purple-300 border-purple-800'
              }`}>
                階段：{currentSession.qualityStatus}
              </span>
            </div>
            <div className="text-xs text-stone-400 mt-1">
              工作階段 ID：{currentSession.id} ｜ 巡田作業員：{currentSession.operatorName} ｜ 開始時間：{currentSession.startedAt}
            </div>
          </div>

          <div className="flex items-center gap-2">
            {currentSession.qualityStatus === 'RESHOOT_REQUIRED' && (
              <button
                onClick={handleResolveReshoot}
                className="px-3 py-1.5 bg-amber-600 hover:bg-amber-500 text-white rounded-xl text-xs font-semibold flex items-center gap-1.5"
              >
                <Target className="w-3.5 h-3.5" /> 模擬執行補拍 (完成驗收)
              </button>
            )}
            {currentSession.qualityStatus === 'PASSED' && (
              <button
                onClick={handleStartProcessing}
                className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-semibold flex items-center gap-1.5"
              >
                <Cloud className="w-3.5 h-3.5" /> 啟動成果產出 (START_PROCESSING)
              </button>
            )}
            {currentSession.qualityStatus === 'READY' && (
              <span className="text-xs text-emerald-400 font-bold flex items-center gap-1">
                <CheckCircle2 className="w-4 h-4" /> 巡田成果全數就緒！
              </span>
            )}
          </div>
        </div>

        {/* 雲端品質分析報告 */}
        {currentSession.cloudQualityReport && (
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
            <div className="bg-stone-950 p-3 rounded-xl border border-stone-800">
              <span className="text-stone-400 block mb-1">田區幾何覆蓋率</span>
              <span className="text-emerald-400 font-bold text-base">{currentSession.cloudQualityReport.coveragePercent}%</span>
            </div>
            <div className="bg-stone-950 p-3 rounded-xl border border-stone-800">
              <span className="text-stone-400 block mb-1">平均清晰度分數</span>
              <span className="text-white font-mono font-bold text-base">{currentSession.cloudQualityReport.averageBlurScore}</span>
            </div>
            <div className="bg-stone-950 p-3 rounded-xl border border-stone-800">
              <span className="text-stone-400 block mb-1">有效影格數</span>
              <span className="text-emerald-400 font-bold text-base">{currentSession.validFramesCount} / {currentSession.totalFramesCaptured} 幀</span>
            </div>
            <div className="bg-stone-950 p-3 rounded-xl border border-stone-800">
              <span className="text-stone-400 block mb-1">後續運算狀態</span>
              <span className="text-purple-300 font-bold text-base">
                {currentSession.cloudQualityReport.isReadyFor3DOrAI ? '具備分析資格' : '待補拍'}
              </span>
            </div>
          </div>
        )}
      </div>

      {/* 3. 補拍任務派發與離場前指引卡片 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-sm font-bold text-white flex items-center gap-2">
            <Target className="w-4 h-4 text-amber-400" />
            離場前補拍任務清單 (Reshoot Tasks)
          </h3>
          <span className="text-xs text-stone-400">
            {currentSession.reshootTasks.filter(t => t.status === 'PENDING').length} 項待補拍
          </span>
        </div>

        <div className="space-y-3">
          {currentSession.reshootTasks.map((task) => (
            <div
              key={task.id}
              className={`p-4 rounded-xl border transition-all ${
                task.status === 'RESOLVED'
                  ? 'bg-stone-950/80 border-stone-800 opacity-70'
                  : 'bg-amber-950/30 border-amber-800/80'
              }`}
            >
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-xs font-bold text-white">{task.fieldSegment}</span>
                    <span className="text-[10px] px-2 py-0.5 rounded font-mono bg-red-950 text-red-300 border border-red-800">
                      原因：{task.reason}
                    </span>
                    <span className={`text-[10px] px-2 py-0.5 rounded font-bold ${
                      task.status === 'RESOLVED' ? 'bg-emerald-950 text-emerald-300 border border-emerald-800' : 'bg-amber-950 text-amber-300 border border-amber-800'
                    }`}>
                      {task.status === 'RESOLVED' ? '已完成補拍' : '待補拍'}
                    </span>
                  </div>
                  <div className="text-xs text-stone-300 mt-1.5">
                    <strong>缺失說明：</strong>{task.missingContentDescription}
                  </div>
                </div>

                <div className="flex items-center gap-3 bg-stone-900 p-2.5 rounded-lg border border-stone-800 text-xs shrink-0">
                  <Compass className="w-4 h-4 text-emerald-400" />
                  <div>
                    <div className="text-stone-400 text-[10px]">建議鏡頭朝向</div>
                    <div className="font-mono font-bold text-emerald-300">{task.suggestedHeadingDegrees}° (西北西)</div>
                  </div>
                </div>
              </div>

              {task.resolvedFrameId && (
                <div className="text-xs text-emerald-400 mt-2 flex items-center gap-1.5">
                  <CheckCircle2 className="w-3.5 h-3.5" /> 已由補拍影格 {task.resolvedFrameId} 完成特徵閉環！
                </div>
              )}
            </div>
          ))}
        </div>
      </div>

      {/* 4. 採集影格審計與遮擋決策流水帳 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
        <h3 className="text-sm font-bold text-white flex items-center gap-2">
          <Eye className="w-4 h-4 text-emerald-400" />
          採集影格審查與遮擋處理策略 (Frame Screening Audit)
        </h3>
        <p className="text-xs text-stone-400">
          呈現手機端防手震快篩、雲端人物遮擋判定（替代真實影格 vs 發起補拍），拒絕生成式偽造。
        </p>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          {mockFrames.map((frame) => (
            <div key={frame.frameId} className="bg-stone-950 p-3.5 rounded-xl border border-stone-800 text-xs space-y-2">
              <div className="flex items-center justify-between">
                <span className="font-mono font-bold text-white">{frame.frameId}</span>
                <span className="text-[11px] text-stone-500">{frame.timestamp}</span>
              </div>

              <div className="text-stone-300 space-y-1">
                <div>坐標：[{frame.gpsCoordinate.join(', ')}] ｜ 精度：±{frame.gpsAccuracyMeters}m</div>
                <div>相機朝向：{frame.compassHeadingDegrees}° ｜ 清晰分數：{frame.blurScore}</div>
              </div>

              <div className="pt-2 border-t border-stone-800 flex items-center justify-between text-[11px]">
                {frame.isBlurry ? (
                  <span className="text-red-400 font-bold flex items-center gap-1">
                    <AlertTriangle className="w-3.5 h-3.5" /> 模糊度過高 (手機快篩標記)
                  </span>
                ) : frame.isPersonOccluded ? (
                  <span className={frame.hasAlternateCleanFrame ? 'text-blue-300 font-medium' : 'text-amber-400 font-bold'}>
                    {frame.hasAlternateCleanFrame ? '人物遮擋 (已由相鄰真實影格替代)' : '人物遮擋 (無替代影格，發布補拍)'}
                  </span>
                ) : (
                  <span className="text-emerald-400 font-medium flex items-center gap-1">
                    <CheckCircle2 className="w-3.5 h-3.5" /> 影格品質良好 (通過)
                  </span>
                )}
                <span className="font-mono text-stone-400">{frame.uploadStatus}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
