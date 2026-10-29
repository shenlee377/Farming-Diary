import React, { useState } from 'react';
import { FULL_STACK_CODE_FILES, CodeFile } from '../data/fullStackCodeData.ts';
import {
  Code2,
  Terminal,
  Server,
  Smartphone,
  Database,
  Cloud,
  Copy,
  Check,
  Send,
  FileCode,
  FolderTree,
  ShieldCheck,
  Play,
  Download,
  Sparkles,
} from 'lucide-react';

export const Phase6FullStackDeployment: React.FC = () => {
  const [selectedCategory, setSelectedCategory] = useState<'ALL' | 'BACKEND' | 'FLUTTER' | 'DATABASE' | 'DEVOPS'>('ALL');
  const [selectedFileId, setSelectedFileId] = useState<string>('backend-main');
  const [copied, setCopied] = useState(false);

  // API 測試器狀態
  const [activeApiTest, setActiveApiTest] = useState<'auth' | 'fields' | 'work_log' | 'signed_url' | 'health'>('fields');
  const [apiResponse, setApiResponse] = useState<any>(null);
  const [isLoadingApi, setIsLoadingApi] = useState(false);

  const filteredFiles = selectedCategory === 'ALL'
    ? FULL_STACK_CODE_FILES
    : FULL_STACK_CODE_FILES.filter((f) => f.category === selectedCategory);

  const currentFile = FULL_STACK_CODE_FILES.find((f) => f.id === selectedFileId) || FULL_STACK_CODE_FILES[0];

  const handleCopyCode = () => {
    navigator.clipboard.writeText(currentFile.content);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const runApiTest = (endpointType: 'auth' | 'fields' | 'work_log' | 'signed_url' | 'health') => {
    setActiveApiTest(endpointType);
    setIsLoadingApi(true);

    setTimeout(() => {
      let mockRes = {};
      if (endpointType === 'health') {
        mockRes = {
          status: "healthy",
          service: "farmland-diary-backend",
          environment: "production",
          region: "asia-east1 (臺灣彰濱)"
        };
      } else if (endpointType === 'auth') {
        mockRes = {
          access_token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyLWxpbi0wMSIsIm5hbWUiOiLmnpflrrbohawiLCJyb2xlIjoiV09SS1NQQUNFX09XTkVSIiwiZXhwIjoxNzkzMTIwMDAwfQ...",
          token_type: "bearer",
          expires_in: 604800,
          user_id: "user-lin-01",
          user_name: "林家豪 (青農經營者)",
          role: "WORKSPACE_OWNER"
        };
      } else if (endpointType === 'fields') {
        mockRes = {
          workspace_id: "ws-tw-xiluo-001",
          total_fields: 2,
          fields: [
            {
              id: "field-north-01",
              name: "大同路後底大坵 (北田)",
              area_hectares: 0.42,
              land_tenure_type: "LEASED",
              current_legal_status: "SELF_REPORTED_UNVERIFIED",
              cadastres: [
                {
                  code: "西螺鎮新安段0124-0000",
                  note: "承租自林伯，租約至117年12月"
                },
                {
                  code: "西螺鎮新安段0125-0000",
                  note: "工寮所在地號，共有持分"
                }
              ]
            }
          ]
        };
      } else if (endpointType === 'work_log') {
        mockRes = {
          work_log_id: "log-20261019-99",
          task_id: "task-01",
          executor_name: "林家豪",
          executed_date: "2026-10-19",
          raw_voice_notes: "早上六點半開始，巡視北田排水，並補種第二畦缺苗30株。",
          spraying_status: "CONFIRMED_NOT_APPLIED",
          is_confirmed_by_manager: true,
          notice: "系統已嚴格留存主管確認標記：未施用農藥"
        };
      } else if (endpointType === 'signed_url') {
        mockRes = {
          upload_url: "https://storage.googleapis.com/farmland-diary-raw-asia-east1/sessions/session-insp-01/raw/DJI_0041.JPG?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=service-account%40farmland.iam.gserviceaccount.com&X-Goog-Expires=900...",
          gcs_object_path: "sessions/session-insp-01/raw/DJI_0041.JPG",
          expires_at: "2026-10-19T13:45:00Z"
        };
      }
      setApiResponse(mockRes);
      setIsLoadingApi(false);
    }, 450);
  };

  return (
    <div className="space-y-8 pb-16">
      {/* 標頭導言卡片 */}
      <div className="bg-gradient-to-br from-stone-900 via-stone-900 to-emerald-950/30 border border-emerald-800/40 rounded-2xl p-6 sm:p-8">
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mb-4">
          <div className="flex items-center gap-3">
            <span className="p-3 bg-emerald-900/60 border border-emerald-700/50 rounded-xl text-emerald-300">
              <Terminal className="w-6 h-6" />
            </span>
            <div>
              <div className="flex items-center gap-2">
                <h2 className="text-xl sm:text-2xl font-bold text-white tracking-tight">
                  第六階段：全端系統代碼實作規格與部署架構
                </h2>
                <span className="px-2.5 py-0.5 rounded-full bg-emerald-950 text-emerald-300 border border-emerald-800 text-xs font-mono font-medium">
                  Phase 6 Ready for Git
                </span>
              </div>
              <p className="text-sm text-stone-400 mt-1">
                落實主提示詞第 2、14、18、19 條發布策略：Flutter 雙平台公開客戶端、Python FastAPI 私有後端、PostGIS 空間遷移腳本與 Cloud Run 部署設定。
              </p>
            </div>
          </div>

          <div className="px-4 py-2 bg-stone-800/80 rounded-xl border border-stone-700 text-xs text-stone-300">
            <span className="text-stone-400 block mb-0.5">儲存庫邊界</span>
            <span className="text-emerald-300 font-semibold">Flutter (公開 GitHub) / 後端 (私人獨立維護)</span>
          </div>
        </div>

        {/* 檔案目錄分類切換 */}
        <div className="flex flex-wrap items-center gap-2 pt-4 border-t border-stone-800 text-xs">
          <button
            onClick={() => setSelectedCategory('ALL')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              selectedCategory === 'ALL'
                ? 'bg-emerald-800 text-emerald-100 border border-emerald-600'
                : 'bg-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            全部代碼 ({FULL_STACK_CODE_FILES.length})
          </button>
          <button
            onClick={() => setSelectedCategory('BACKEND')}
            className={`px-3 py-1.5 rounded-lg font-medium flex items-center gap-1.5 transition-colors ${
              selectedCategory === 'BACKEND'
                ? 'bg-emerald-800 text-emerald-100 border border-emerald-600'
                : 'bg-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <Server className="w-3.5 h-3.5 text-blue-400" />
            <span>Python FastAPI 後端</span>
          </button>
          <button
            onClick={() => setSelectedCategory('FLUTTER')}
            className={`px-3 py-1.5 rounded-lg font-medium flex items-center gap-1.5 transition-colors ${
              selectedCategory === 'FLUTTER'
                ? 'bg-emerald-800 text-emerald-100 border border-emerald-600'
                : 'bg-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <Smartphone className="w-3.5 h-3.5 text-cyan-400" />
            <span>Flutter (Android/iOS) 客戶端</span>
          </button>
          <button
            onClick={() => setSelectedCategory('DATABASE')}
            className={`px-3 py-1.5 rounded-lg font-medium flex items-center gap-1.5 transition-colors ${
              selectedCategory === 'DATABASE'
                ? 'bg-emerald-800 text-emerald-100 border border-emerald-600'
                : 'bg-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <Database className="w-3.5 h-3.5 text-amber-400" />
            <span>PostGIS 資料庫 DDL</span>
          </button>
          <button
            onClick={() => setSelectedCategory('DEVOPS')}
            className={`px-3 py-1.5 rounded-lg font-medium flex items-center gap-1.5 transition-colors ${
              selectedCategory === 'DEVOPS'
                ? 'bg-emerald-800 text-emerald-100 border border-emerald-600'
                : 'bg-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <Cloud className="w-3.5 h-3.5 text-purple-400" />
            <span>Cloud Run & GitHub Actions</span>
          </button>
        </div>
      </div>

      {/* ──────────────────────────────────────────────────────── */}
      {/* 核心雙欄：左側檔案樹與說明，右側代碼檢視器 */}
      {/* ──────────────────────────────────────────────────────── */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* 左側檔案清單 */}
        <div className="lg:col-span-4 space-y-3">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-4">
            <div className="flex items-center gap-2 mb-3 text-xs font-bold text-stone-300">
              <FolderTree className="w-4 h-4 text-emerald-400" />
              <span>實作源碼檔案樹 (點選檢視)</span>
            </div>

            <div className="space-y-1.5">
              {filteredFiles.map((file) => {
                const isSelected = file.id === currentFile.id;
                return (
                  <button
                    key={file.id}
                    onClick={() => setSelectedFileId(file.id)}
                    className={`w-full text-left p-3 rounded-xl border text-xs transition-colors flex flex-col gap-1 ${
                      isSelected
                        ? 'bg-emerald-950/60 border-emerald-600 text-emerald-200'
                        : 'bg-stone-800/40 border-stone-800 text-stone-300 hover:bg-stone-800/80 hover:text-white'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <span className="font-mono font-bold text-xs flex items-center gap-1.5">
                        <FileCode className={`w-3.5 h-3.5 ${isSelected ? 'text-emerald-400' : 'text-stone-500'}`} />
                        {file.name}
                      </span>
                      <span className="text-[0.625rem] uppercase font-mono px-1.5 py-0.5 rounded bg-stone-900 text-stone-400">
                        {file.language}
                      </span>
                    </div>
                    <span className="text-[0.6875rem] font-mono text-stone-500 truncate">{file.path}</span>
                  </button>
                );
              })}
            </div>
          </div>

          {/* 當前檔案設計規範對照說明 */}
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-4 text-xs">
            <h4 className="font-bold text-white mb-2 flex items-center gap-1.5">
              <ShieldCheck className="w-4 h-4 text-emerald-400" />
              <span>臺灣農業規範與技術落實說明</span>
            </h4>
            <p className="text-stone-400 leading-relaxed">
              {currentFile.description}
            </p>
          </div>
        </div>

        {/* 右側代碼檢視器 */}
        <div className="lg:col-span-8 bg-stone-900 border border-stone-800 rounded-2xl overflow-hidden flex flex-col">
          {/* 代碼標頭 */}
          <div className="px-5 py-3.5 bg-stone-950 border-b border-stone-800 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <span className="text-xs font-mono font-bold text-emerald-400">{currentFile.path}</span>
              <span className="text-[0.6875rem] text-stone-500">
                ({currentFile.content.split('\n').length} 行)
              </span>
            </div>

            <button
              onClick={handleCopyCode}
              className="px-3 py-1 bg-stone-800 hover:bg-stone-700 text-stone-300 rounded-lg text-xs font-medium border border-stone-700 flex items-center gap-1.5 transition-colors"
            >
              {copied ? (
                <>
                  <Check className="w-3.5 h-3.5 text-emerald-400" />
                  <span className="text-emerald-400">已複製到剪貼簿</span>
                </>
              ) : (
                <>
                  <Copy className="w-3.5 h-3.5" />
                  <span>複製源碼</span>
                </>
              )}
            </button>
          </div>

          {/* 代碼內容區塊 (具行號) */}
          <div className="p-4 bg-stone-950 overflow-x-auto text-xs font-mono text-stone-300 max-h-[580px] scrollbar-thin">
            <pre className="leading-relaxed">
              {currentFile.content.split('\n').map((line, index) => (
                <div key={index} className="table-row">
                  <span className="table-cell pr-4 text-stone-600 select-none text-right w-10">
                    {index + 1}
                  </span>
                  <span className="table-cell">{line || ' '}</span>
                </div>
              ))}
            </pre>
          </div>
        </div>
      </div>

      {/* ──────────────────────────────────────────────────────── */}
      {/* 互動式 REST API 端點測試器 */}
      {/* ──────────────────────────────────────────────────────── */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-2">
            <Server className="w-5 h-5 text-emerald-400" />
            <h3 className="text-base font-bold text-white">私有 FastAPI 後端端點即時模擬測試 (Live API Inspector)</h3>
          </div>
          <span className="text-xs text-stone-400">
            驗證資料契約與 JSON 響應規格
          </span>
        </div>

        <p className="text-xs text-stone-300 mb-6">
          此測試面板可直接模擬 Flutter App 與後端 API 通訊，展示土地確權、身分交換、農事紀錄審核與 GCS Signed URL 的實際回傳格式：
        </p>

        {/* 測試按鈕列 */}
        <div className="flex flex-wrap gap-2 mb-4">
          <button
            onClick={() => runApiTest('fields')}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors flex items-center gap-1.5 ${
              activeApiTest === 'fields'
                ? 'bg-emerald-950 border-emerald-600 text-emerald-200'
                : 'bg-stone-800 border-stone-700 text-stone-400 hover:text-white'
            }`}
          >
            <span className="text-emerald-400 font-mono font-bold">GET</span>
            <span>/api/v1/workspaces/fields (田區地號關聯)</span>
          </button>

          <button
            onClick={() => runApiTest('auth')}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors flex items-center gap-1.5 ${
              activeApiTest === 'auth'
                ? 'bg-emerald-950 border-emerald-600 text-emerald-200'
                : 'bg-stone-800 border-stone-700 text-stone-400 hover:text-white'
            }`}
          >
            <span className="text-blue-400 font-mono font-bold">POST</span>
            <span>/api/v1/auth/token/exchange (PKCE 驗證)</span>
          </button>

          <button
            onClick={() => runApiTest('work_log')}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors flex items-center gap-1.5 ${
              activeApiTest === 'work_log'
                ? 'bg-emerald-950 border-emerald-600 text-emerald-200'
                : 'bg-stone-800 border-stone-700 text-stone-400 hover:text-white'
            }`}
          >
            <span className="text-amber-400 font-mono font-bold">POST</span>
            <span>/api/v1/tasks/work-logs (嚴格施藥回報)</span>
          </button>

          <button
            onClick={() => runApiTest('signed_url')}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors flex items-center gap-1.5 ${
              activeApiTest === 'signed_url'
                ? 'bg-emerald-950 border-emerald-600 text-emerald-200'
                : 'bg-stone-800 border-stone-700 text-stone-400 hover:text-white'
            }`}
          >
            <span className="text-purple-400 font-mono font-bold">POST</span>
            <span>/api/v1/inspections/upload-signed-url (GCS 簽章)</span>
          </button>

          <button
            onClick={() => runApiTest('health')}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors flex items-center gap-1.5 ${
              activeApiTest === 'health'
                ? 'bg-emerald-950 border-emerald-600 text-emerald-200'
                : 'bg-stone-800 border-stone-700 text-stone-400 hover:text-white'
            }`}
          >
            <span className="text-emerald-400 font-mono font-bold">GET</span>
            <span>/healthz (健康檢查)</span>
          </button>
        </div>

        {/* 響應視窗 */}
        <div className="bg-stone-950 border border-stone-800 rounded-xl p-4 font-mono text-xs text-stone-300">
          <div className="flex items-center justify-between pb-2 mb-3 border-b border-stone-800 text-[0.6875rem] text-stone-500">
            <span className="text-emerald-400 flex items-center gap-1">
              <Play className="w-3 h-3 fill-emerald-400" />
              <span>HTTP 200 OK (延遲 ~38ms)</span>
            </span>
            <span>Content-Type: application/json; charset=utf-8</span>
          </div>

          {isLoadingApi ? (
            <div className="py-6 flex items-center justify-center gap-2 text-stone-500">
              <span className="w-2 h-2 rounded-full bg-emerald-500 animate-ping"></span>
              <span>後端處理中...</span>
            </div>
          ) : (
            <pre className="text-emerald-300/90 overflow-x-auto leading-relaxed">
              {JSON.stringify(apiResponse || { message: "點選上方按鈕執行端點測試" }, null, 2)}
            </pre>
          )}
        </div>
      </div>
    </div>
  );
};
