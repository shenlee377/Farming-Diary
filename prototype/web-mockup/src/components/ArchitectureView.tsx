import React, { useState } from 'react';
import { Database, Server, Cloud, Shield, GitBranch, ArrowRight, Check, X } from 'lucide-react';

export const ArchitectureView: React.FC = () => {
  const [activeSubTab, setActiveSubTab] = useState<'db_compare' | 'system_arch' | 'repo_boundary' | 'cloud_jobs'>('db_compare');

  return (
    <div className="space-y-6 pb-16">
      {/* 子分頁選單 */}
      <div className="flex border-b border-stone-800 space-x-4">
        <button
          onClick={() => setActiveSubTab('db_compare')}
          className={`pb-3 text-sm font-medium border-b-2 transition-colors ${
            activeSubTab === 'db_compare'
              ? 'border-emerald-500 text-emerald-400'
              : 'border-transparent text-stone-400 hover:text-stone-200'
          }`}
        >
          🗄️ 資料庫選型比較與推薦
        </button>
        <button
          onClick={() => setActiveSubTab('system_arch')}
          className={`pb-3 text-sm font-medium border-b-2 transition-colors ${
            activeSubTab === 'system_arch'
              ? 'border-emerald-500 text-emerald-400'
              : 'border-transparent text-stone-400 hover:text-stone-200'
          }`}
        >
          🏗️ 系統架構圖 (Mermaid / 拓撲)
        </button>
        <button
          onClick={() => setActiveSubTab('repo_boundary')}
          className={`pb-3 text-sm font-medium border-b-2 transition-colors ${
            activeSubTab === 'repo_boundary'
              ? 'border-emerald-500 text-emerald-400'
              : 'border-transparent text-stone-400 hover:text-stone-200'
          }`}
        >
          🔒 公開前端與私有後端邊界
        </button>
        <button
          onClick={() => setActiveSubTab('cloud_jobs')}
          className={`pb-3 text-sm font-medium border-b-2 transition-colors ${
            activeSubTab === 'cloud_jobs'
              ? 'border-emerald-500 text-emerald-400'
              : 'border-transparent text-stone-400 hover:text-stone-200'
          }`}
        >
          ⚙️ 雲端工作排程與非同步回饋
        </button>
      </div>

      {/* 1. 資料庫選型比較與主要推薦 */}
      {activeSubTab === 'db_compare' && (
        <div className="space-y-6">
          <div className="bg-emerald-950/30 border border-emerald-800/50 rounded-2xl p-6">
            <div className="flex items-center gap-2 mb-2 text-emerald-400 font-bold">
              <Database className="w-5 h-5" />
              <h3 className="text-base font-semibold">首要推薦方案：Cloud SQL for PostgreSQL + PostGIS (+ Cloud Storage)</h3>
            </div>
            <p className="text-sm text-stone-300 leading-relaxed">
              經深入評估「農田日記」之業務核心（土地共有關係、地籍地號多對多關聯、多田區多期作分攤、工資與庫存嚴格扣抵、空間地理多邊形運算），
              <strong>強烈推薦採用方案 B (PostgreSQL + PostGIS) 作為主要正式資料來源</strong>。
              雖然 Firestore 具備零閒置伺服器成本優勢，但農務中的多表關聯、財務 ACID 事務以及空間 GIS 計算，在關聯式資料庫中具備壓倒性的可靠度與維護性。
            </p>
          </div>

          <div className="overflow-x-auto bg-stone-900 border border-stone-800 rounded-2xl shadow-sm">
            <table className="w-full text-left text-xs border-collapse">
              <thead>
                <tr className="bg-stone-800/80 text-stone-300 border-b border-stone-700">
                  <th className="p-3.5 font-bold w-1/4">評估維度</th>
                  <th className="p-3.5 font-bold w-3/8 text-emerald-300 bg-emerald-950/20">
                    方案 B：PostgreSQL + PostGIS (推薦 ⭐)
                  </th>
                  <th className="p-3.5 font-bold w-3/8 text-stone-400">
                    方案 A：Firestore + Firebase
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-stone-800 text-stone-300">
                <tr>
                  <td className="p-3.5 font-medium text-white">土地地號與複雜關聯</td>
                  <td className="p-3.5 bg-emerald-950/10">
                    <span className="text-emerald-400 font-bold">優異。</span>
                    支援自然的多對多關聯表 (<code>field_cadastral_parcels</code>)，外鍵完整性約束保證資料一致。
                  </td>
                  <td className="p-3.5 text-stone-400">
                    <span className="text-amber-400 font-bold">受限。</span>
                    需以反正規化或嵌入陣列處理；地號變更或共有關係修正時需多處同步更新，易產生孤立紀錄。
                  </td>
                </tr>
                <tr>
                  <td className="p-3.5 font-medium text-white">空間幾何計算 (GIS)</td>
                  <td className="p-3.5 bg-emerald-950/10">
                    <span className="text-emerald-400 font-bold">原生強大。</span>
                    原生 <code>ST_Area(geography)</code> 精確計算臺灣地表面積（公頃／分地），<code>ST_Intersects</code> 判斷巡田軌跡重疊。
                  </td>
                  <td className="p-3.5 text-stone-400">
                    <span className="text-amber-400 font-bold">極受限。</span>
                    僅支援 Geohash 單點半徑查詢，無法在資料庫層進行多邊形相交或精確地表面積投影計算。
                  </td>
                </tr>
                <tr>
                  <td className="p-3.5 font-medium text-white">庫存扣抵與工資財務一致性</td>
                  <td className="p-3.5 bg-emerald-950/10">
                    <span className="text-emerald-400 font-bold">完整 ACID。</span>
                    行級鎖與交易隔離；資材領用與期作成本分攤可一筆交易原子完成，杜絕負庫存。
                  </td>
                  <td className="p-3.5 text-stone-400">
                    需使用 Firestore <code>runTransaction</code>，當多人同時存取同一熱點文件時容易產生競態重試。
                  </td>
                </tr>
                <tr>
                  <td className="p-3.5 font-medium text-white">初期閒置成本</td>
                  <td className="p-3.5 bg-emerald-950/10">
                    小型實例 (db-f1-micro / shared-core) 約每月 $8~$15 美金；或採用 Cloud SQL for PostgreSQL 配合 scale-to-zero 開發環境。
                  </td>
                  <td className="p-3.5 text-emerald-400 font-bold">
                    免費額度內為 $0 美元 (50k 讀 / 20k 寫 / 1GB)。
                  </td>
                </tr>
                <tr>
                  <td className="p-3.5 font-medium text-white">備份、遷移與維運負擔</td>
                  <td className="p-3.5 bg-emerald-950/10">
                    標準 <code>pg_dump</code> 與 Alembic 遷移腳本；隨時可無縫遷移至本機 Docker 或任何雲端 VPS，無廠商鎖定。
                  </td>
                  <td className="p-3.5 text-stone-400">
                    高度綁定 GCP / Firebase 專屬匯出格式，資料結構遷移需依賴批次雲端函式。
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* 2. 系統架構圖 */}
      {activeSubTab === 'system_arch' && (
        <div className="space-y-6">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <h3 className="text-base font-bold text-white mb-2">系統架構拓撲 (End-to-End System Architecture)</h3>
            <p className="text-xs text-stone-400 mb-6">
              以 Flutter 跨平台前端 + Google Cloud Run (Python FastAPI) 為核心，劃分身分邊界、業務資料庫、非同步處理佇列與物件儲存。
            </p>

            <div className="bg-stone-950 p-6 rounded-xl border border-stone-800 font-mono text-xs text-stone-300 overflow-x-auto space-y-4">
              <div className="text-emerald-400 font-bold mb-2">// 系統架構結構圖 (Mermaid Topology)</div>
              <pre className="text-emerald-300/90 leading-relaxed">{`
┌────────────────────────────────────────────────────────┐
│             用戶端 (Flutter Android & iOS)             │
│  - 本機 SQLite / Hive (離線草稿與待同步佇列)            │
│  - 相機與感測器 (姿態 / GPS / 模糊快篩 / 補拍引導)     │
└───────────────┬────────────────────────┬───────────────┘
                │ 1. OAuth / Token 交換   │ 2. Signed URL 直傳大檔
                ▼                        ▼
┌───────────────────────────┐    ┌───────────────────────────┐
│  咖啡廳既有 OAuth 服務    │    │    Google Cloud Storage   │
│  (shenlee377/chat-coffee) │    │  - 現場照片 (私有儲存)    │
│  - account.read (sub)     │    │  - 語音檔案與巡田影格     │
└───────────────┬───────────┘    └─────────────▲─────────────┘
                │ Verify sub                   │ 讀寫
                ▼                              │
┌──────────────────────────────────────────────┴─────────────┐
│             Google Cloud Run: 農田日記主 API               │
│               (Python FastAPI 私有後端)                    │
│  - 認證與工作空間多租戶隔離 (Tenant Security Middleware)   │
│  - 田區管理 / 土地關係 / 期作 / 人員安排 / 資材履歷        │
│  - 狀態機轉換引擎 (Task / Staff / Log / Spray Validation)  │
│  - SSE / WebSocket 即時推播 (巡田進度與補拍任務反饋)       │
└───────────────┬──────────────────────────────┬─────────────┘
                │ ACID 事務讀寫                │ 派送重型作業
                ▼                              ▼
┌───────────────────────────┐    ┌───────────────────────────┐
│ Cloud SQL (PostgreSQL     │    │  Cloud Tasks / Cloud Run  │
│        + PostGIS)         │    │  Jobs (非同步重處理排程)  │
│ - 田區空間多邊形 WGS84    │    │ - 跨影格遮擋分析          │
│ - 土地地號多對多關聯      │    │ - 補拍任務幾何判定        │
│ - 財務工資與資材批次扣抵  │    │ - 三維重建與 AI 摘要排程  │
└───────────────────────────┘    └───────────────────────────┘
              `}</pre>
            </div>
          </div>
        </div>
      )}

      {/* 3. 公開前端與私有後端邊界 */}
      {activeSubTab === 'repo_boundary' && (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex items-center gap-2 mb-4 text-emerald-400 font-bold">
              <GitBranch className="w-5 h-5" />
              <h4>公開儲存庫：Flutter Android / iOS 客戶端</h4>
            </div>
            <ul className="space-y-3 text-xs text-stone-300">
              <li className="flex items-start gap-2">
                <span className="text-emerald-400 font-bold">●</span>
                <span><strong>開源透明：</strong>包含全套 Flutter 跨平台 UI、本地 SQLite 離線快取、感測器採集模組。</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-emerald-400 font-bold">●</span>
                <span><strong>嚴禁機密：</strong>絕不包含後端資料庫密碼、服務帳號私鑰 (Service Account Key) 或 Google Maps 未受限金鑰。</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-emerald-400 font-bold">●</span>
                <span><strong>發布支援：</strong>內含 Android 開源 GitHub Actions 自動化建置 APK，以及 iOS Fastlane App Store 打包腳本。</span>
              </li>
            </ul>
          </div>

          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex items-center gap-2 mb-4 text-blue-400 font-bold">
              <Shield className="w-5 h-5" />
              <h4>私有儲存庫：Cloud Run FastAPI 後端與處理器</h4>
            </div>
            <ul className="space-y-3 text-xs text-stone-300">
              <li className="flex items-start gap-2">
                <span className="text-blue-400 font-bold">●</span>
                <span><strong>權限強制執行：</strong>所有資料存取、租戶隔離、薪資合約查看由後端 JWT / Session 中介層強制作業。</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-blue-400 font-bold">●</span>
                <span><strong>商業邏輯核心：</strong>包含土地共有關係計算、資材庫存嚴格扣抵、農藥安全採收期驗證與審計歷史留存。</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-blue-400 font-bold">●</span>
                <span><strong>Secret Manager 整合：</strong>私密設定（資料庫連線字串、OAuth client 驗證密鑰）全數透過 Google Secret Manager 動態注入。</span>
              </li>
            </ul>
          </div>
        </div>
      )}

      {/* 4. 雲端工作排程與非同步回饋 */}
      {activeSubTab === 'cloud_jobs' && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <h3 className="text-base font-bold text-white mb-2">雲端工作排程與同步回饋機制 (Async Quality Feedback)</h3>
          <p className="text-xs text-stone-400 leading-relaxed">
            為杜絕「在單一長 HTTP 請求中等待重度影像或三維運算」所導致的逾時與資源浪費，系統採用<strong>「分塊上傳 → Cloud Tasks 派送 → Cloud Run Jobs 獨立執行 → SSE 即時狀態回饋」</strong>架構。
          </p>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 pt-4">
            <div className="bg-stone-800/40 border border-stone-700/60 p-4 rounded-xl">
              <div className="text-xs font-bold text-emerald-400 mb-1">1. 冪等上傳工作階段</div>
              <p className="text-xs text-stone-300">
                每次巡田建立 <code>InspectionSession</code>，每張照片取得獨立 Signed URL 直傳 GCS，帶有 MD5校驗碼，失敗自動重試。
              </p>
            </div>
            <div className="bg-stone-800/40 border border-stone-700/60 p-4 rounded-xl">
              <div className="text-xs font-bold text-emerald-400 mb-1">2. Cloud Tasks 限速佇列</div>
              <p className="text-xs text-stone-300">
                上傳完成後觸發輕量品質檢核。非同步排程至 Cloud Tasks，防止高並發巡田同時壓垮後端運算資源。
              </p>
            </div>
            <div className="bg-stone-800/40 border border-stone-700/60 p-4 rounded-xl">
              <div className="text-xs font-bold text-emerald-400 mb-1">3. SSE 即時推播補拍任務</div>
              <p className="text-xs text-stone-300">
                後端偵測出關鍵視角遮擋時，生成 <code>ReshootTask</code> 並透過 SSE 推播至手機，引導農民在離場前補拍。
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
