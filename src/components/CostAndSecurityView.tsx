import React from 'react';
import { DollarSign, Shield, Lock, FileCode, CheckCircle2, AlertTriangle, Database } from 'lucide-react';

export const CostAndSecurityView: React.FC = () => {
  return (
    <div className="space-y-6 pb-16">
      {/* 成本結構分析 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center gap-2 mb-2 text-emerald-400 font-bold">
          <DollarSign className="w-5 h-5" />
          <h3 className="text-base font-semibold">雲端成本架構、用量假設與上限控管 (Cost Governance & Quotas)</h3>
        </div>
        <p className="text-xs text-stone-400 leading-relaxed mb-6">
          依規範拒絕無依據之固定月費包裝。將支出嚴格拆解為「固定閒置基線」、「隨用量請求遞增」、「重度 AI/GPU 處理」與「開發對比正式環境」四大面向，並建立強制預算警報與斷流機制。
        </p>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {/* 1. 固定與最低成本 */}
          <div className="bg-stone-950 p-4 rounded-xl border border-stone-800 space-y-2">
            <div className="flex justify-between items-center">
              <span className="text-xs font-bold text-white">1. 服務固定 / 閒置最低成本 (Baseline)</span>
              <span className="text-[11px] px-2 py-0.5 rounded bg-stone-800 text-stone-300">每月固定</span>
            </div>
            <ul className="text-xs text-stone-300 space-y-1.5 leading-relaxed">
              <li>• <strong>Cloud Run (主 API)：</strong>設定 <code>min-instances = 0</code>（縮容至零），閒置期間 $0 元。</li>
              <li>• <strong>Cloud SQL (PostgreSQL)：</strong>開發期採用 scale-to-zero 開發實例；正式環境小型 shared-core (db-f1-micro) 約 $9 ~ $15 美元/月。</li>
              <li>• <strong>Cloud Storage：</strong>基本儲存桶無最低使用費，按實際 GB 計量。</li>
            </ul>
          </div>

          {/* 2. 隨流量與儲存成長 */}
          <div className="bg-stone-950 p-4 rounded-xl border border-stone-800 space-y-2">
            <div className="flex justify-between items-center">
              <span className="text-xs font-bold text-white">2. 請求與儲存遞增成本 (Usage-Based)</span>
              <span className="text-[11px] px-2 py-0.5 rounded bg-emerald-950 text-emerald-300 border border-emerald-800">隨規模彈性</span>
            </div>
            <ul className="text-xs text-stone-300 space-y-1.5 leading-relaxed">
              <li>• <strong>Cloud Run 呼叫費：</strong>每月前 200 萬次請求與 180,000 vCPU-秒在 GCP 免費層 (Free Tier) 內。</li>
              <li>• <strong>GCS 巡田照片儲存：</strong>標準儲存約 $0.026 美元/GB-月。以 100 處農場每月產生 20GB 相片計算，約 $0.52 美元/月。</li>
              <li>• <strong>外網頻寬 (Egress)：</strong>每月前 10GB 免費，後續亞太區域約 $0.12 美元/GB。</li>
            </ul>
          </div>

          {/* 3. AI 與重運算成本 */}
          <div className="bg-stone-950 p-4 rounded-xl border border-stone-800 space-y-2">
            <div className="flex justify-between items-center">
              <span className="text-xs font-bold text-white">3. AI 模型與 GPU 處理成本 (Heavy Compute)</span>
              <span className="text-[11px] px-2 py-0.5 rounded bg-amber-950 text-amber-300 border border-amber-800">嚴格設限</span>
            </div>
            <ul className="text-xs text-stone-300 space-y-1.5 leading-relaxed">
              <li>• <strong>Gemini 2.5 Flash：</strong>農務紀錄語音草稿轉文字與摘要查詢，每次呼叫成本約 $0.0001 ~ $0.0003 美元，單月千次約 $0.3 美元。</li>
              <li>• <strong>三維重建 GPU 控管：</strong>階段 5 之三維重建絕不常駐 GPU 伺服器，僅透過 Cloud Run Jobs 或 Spot VM 按需啟動，並設定單次最大運行時間 (15分鐘) 逾時強制中斷。</li>
            </ul>
          </div>

          {/* 4. 上限與配額策略 */}
          <div className="bg-stone-950 p-4 rounded-xl border border-stone-800 space-y-2">
            <div className="flex justify-between items-center">
              <span className="text-xs font-bold text-white">4. 預算防護與配額限制 (Hard Quotas)</span>
              <span className="text-[11px] px-2 py-0.5 rounded bg-red-950 text-red-300 border border-red-800">安全煞車</span>
            </div>
            <ul className="text-xs text-stone-300 space-y-1.5 leading-relaxed">
              <li>• <strong>GCP 預算通知與自動告警：</strong>設定每月 $20 / $50 美元雙層閥值，超過發送 Pub/Sub 告警。</li>
              <li>• <strong>每位使用者每日巡田上傳上限：</strong>限制單次巡田上傳最多 50 張、每工作空間每日最多 200 張相片，杜絕惡意灌檔。</li>
              <li>• <strong>AI 查詢速率限制 (Rate Limiting)：</strong>每分鐘最多 10 次農務助理查詢，防止迴圈無窮呼叫。</li>
            </ul>
          </div>
        </div>
      </div>

      {/* 資料安全、生命週期與 OAuth 檢查計畫 */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* 安全與隱私 */}
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
          <div className="flex items-center gap-2 text-blue-400 font-bold text-sm">
            <Shield className="w-4 h-4" />
            <span>資料治理與權限安全</span>
          </div>
          <ul className="space-y-2 text-xs text-stone-300 leading-relaxed">
            <li>• <strong>私有檔案限時存取：</strong>所有現場照片與語音檔存於私有 GCS Bucket，前端僅能透過 15 分鐘有效的 Signed URL 讀取。</li>
            <li>• <strong>工作空間軟刪除政策：</strong>刪除田區或期作採標記封存 (is_archived = true)，保留至少 180 天稽核期以備災害申報。</li>
            <li>• <strong>帳號移除獨立性：</strong>使用者若在農田日記刪除帳號，僅清除其在農務工作空間中的個人綁定，<strong>絕不連帶刪除</strong>其在咖啡廳或其他上游服務之帳號。</li>
          </ul>
        </div>

        {/* 既有 OAuth 指定分支核對計畫 */}
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
          <div className="flex items-center gap-2 text-emerald-400 font-bold text-sm">
            <FileCode className="w-4 h-4" />
            <span>既有 OAuth 指定分支審查規劃</span>
          </div>
          <p className="text-xs text-stone-400">
            針對 <code>shenlee377/chat-coffee-bot-python</code>（分支 <code>v5-Google-Cloud-Run</code>）：
          </p>
          <ul className="space-y-2 text-xs text-stone-300 leading-relaxed">
            <li>• <strong>獨立 Client 註冊：</strong>提案註冊 <code>farmland-flutter-client</code>，不共用或冒用 <code>chatcoffee-ios</code>。</li>
            <li>• <strong>最小權限 Scope：</strong>僅申請 <code>account.read</code> 取得穩定 pairwise sub，杜絕索取不必要的電話或私密權限。</li>
            <li>• <strong>PKCE 嚴格驗證：</strong>行動端採 S256 PKCE Code Challenge，Callback URL 由系統瀏覽器安全回調。</li>
          </ul>
        </div>
      </div>
    </div>
  );
};
