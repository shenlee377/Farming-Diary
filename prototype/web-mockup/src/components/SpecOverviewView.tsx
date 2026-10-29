import React from 'react';
import { CheckCircle2, HelpCircle, AlertTriangle, Sparkles, BookOpen } from 'lucide-react';

export const SpecOverviewView: React.FC = () => {
  return (
    <div className="space-y-8 pb-16">
      {/* 導言卡片 */}
      <div className="bg-gradient-to-br from-emerald-950/40 via-stone-900 to-stone-900 border border-emerald-800/40 rounded-2xl p-6 sm:p-8 shadow-sm">
        <div className="flex items-center gap-3 mb-4">
          <span className="p-2 bg-emerald-900/60 border border-emerald-700/50 rounded-xl text-emerald-300">
            <BookOpen className="w-6 h-6" />
          </span>
          <div>
            <h2 className="text-xl sm:text-2xl font-bold text-white tracking-tight">
              第一輪交付：專案架構規劃、資料模型與邊界決策
            </h2>
            <p className="text-sm text-stone-400 mt-1">
              依據「農田日記」28 條主提示詞規範，先完成架構、資料模型、狀態機與驗收計畫，待確認後啟動里程碑一實作。
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 pt-4 border-t border-stone-800 text-xs">
          <div className="bg-stone-800/50 p-3.5 rounded-xl border border-stone-700/50">
            <span className="text-stone-400 block font-medium mb-1">面向受眾</span>
            <span className="text-stone-200 font-semibold">臺灣家庭農場、青農返鄉、小型農業協作</span>
          </div>
          <div className="bg-stone-800/50 p-3.5 rounded-xl border border-stone-700/50">
            <span className="text-stone-400 block font-medium mb-1">前端／客戶端</span>
            <span className="text-stone-200 font-semibold">Flutter (Android 開放原始碼 + iOS 正式上架)</span>
          </div>
          <div className="bg-stone-800/50 p-3.5 rounded-xl border border-stone-700/50">
            <span className="text-stone-400 block font-medium mb-1">後端服務</span>
            <span className="text-stone-200 font-semibold">私有 Cloud Run (Python FastAPI) + Cloud Storage</span>
          </div>
        </div>
      </div>

      {/* 1. 產品理解與核心使用者流程 */}
      <section className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center gap-2 mb-4">
          <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
          <h3 className="text-lg font-bold text-white">一、產品理解與核心使用者流程 (Core User Journey)</h3>
        </div>
        <p className="text-stone-300 text-sm leading-relaxed mb-6">
          「農田日記」的核心精神是<strong>「事實可信、責任明確、操作極簡、避免虛報」</strong>。系統不把重心放在浮誇的科技展示，而是聚焦於臺灣家庭農場實務中常見的痛點：土地共有或租用關係曖昧、外聘施藥工班紀錄缺失、語音或電話交代工作後無紀錄、以及出收貨款項未結清。
        </p>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="bg-stone-800/40 border border-stone-800 rounded-xl p-4">
            <div className="text-emerald-400 font-bold text-xs mb-1">流程 01</div>
            <div className="text-white font-medium text-sm mb-2">土地與田區確權</div>
            <p className="text-stone-400 text-xs leading-relaxed">
              建立管理田區，連結臺灣地籍地號（多對多關係）。載明土地所有權人、承租人與經營者，嚴格標註為「自填未官方法律查證」，留存租約與特約說明。
            </p>
          </div>

          <div className="bg-stone-800/40 border border-stone-800 rounded-xl p-4">
            <div className="text-emerald-400 font-bold text-xs mb-1">流程 02</div>
            <div className="text-white font-medium text-sm mb-2">期作規劃與派工</div>
            <p className="text-stone-400 text-xs leading-relaxed">
              同一田區跨期輪作與休耕管理。新增工作聯絡人（長輩或工班無需安裝 App，透過電話聯繫），明確區分「已聯繫待覆」與「本人確認答應」。
            </p>
          </div>

          <div className="bg-stone-800/40 border border-stone-800 rounded-xl p-4">
            <div className="text-emerald-400 font-bold text-xs mb-1">流程 03</div>
            <div className="text-white font-medium text-sm mb-2">現場回報與資材扣抵</div>
            <p className="text-stone-400 text-xs leading-relaxed">
              戶外大按鈕與語音回報。資材俗稱「一包半」先留存原文與包裝規格，不盲目猜換成公斤。施藥紀錄嚴格區分「已確認未施用」與「紀錄不完整」。
            </p>
          </div>

          <div className="bg-stone-800/40 border border-stone-800 rounded-xl p-4">
            <div className="text-emerald-400 font-bold text-xs mb-1">流程 04</div>
            <div className="text-white font-medium text-sm mb-2">巡田採集與閉環驗收</div>
            <p className="text-stone-400 text-xs leading-relaxed">
              單支手機採集照片。手機先完成本機防手震與模糊快篩，雲端非同步進行跨影格覆蓋檢核；若有重大遮擋則發起補拍任務，完成採集後方進行三維或 AI 摘要。
            </p>
          </div>
        </div>
      </section>

      {/* 2. 已確定、假設、待驗證三份清單 */}
      <section className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-stone-900 border border-emerald-900/60 rounded-2xl p-5">
          <div className="flex items-center gap-2 text-emerald-400 font-bold text-sm mb-3">
            <CheckCircle2 className="w-4 h-4" />
            <span>已確定項目 (Confirmed)</span>
          </div>
          <ul className="space-y-2.5 text-xs text-stone-300">
            <li className="flex items-start gap-2">
              <span className="text-emerald-500 font-mono">✓</span>
              <span><strong>客戶端技術：</strong>Flutter 同步規劃 Android (開源 GitHub/提供 APK) 與 iOS (App Store 上架)。</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-emerald-500 font-mono">✓</span>
              <span><strong>後端架構：</strong>私有儲存庫、Python FastAPI 部署於 Google Cloud Run，大檔案放 Cloud Storage。</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-emerald-500 font-mono">✓</span>
              <span><strong>土地與地號：</strong>田區邊界不等於正式地籍，支援多筆地號關聯，標註邊界品質與版本。</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-emerald-500 font-mono">✓</span>
              <span><strong>外部聯絡人獨立性：</strong>工作聯絡人不強制具備 App 帳號，打電話不等於已答應出席。</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-emerald-500 font-mono">✓</span>
              <span><strong>無紀錄不等於未施藥：</strong>安全採收期與農藥管制嚴格依據可靠資料庫，AI 不可憑空幻想。</span>
            </li>
          </ul>
        </div>

        <div className="bg-stone-900 border border-amber-900/60 rounded-2xl p-5">
          <div className="flex items-center gap-2 text-amber-400 font-bold text-sm mb-3">
            <AlertTriangle className="w-4 h-4" />
            <span>核心假設清單 (Assumptions)</span>
          </div>
          <ul className="space-y-2.5 text-xs text-stone-300">
            <li className="flex items-start gap-2">
              <span className="text-amber-500 font-mono">•</span>
              <span><strong>OAuth 串接前置：</strong>假設咖啡廳專案 <code>v5-Google-Cloud-Run</code> 分支之 public client 支援新增 <code>farmland-flutter-android</code> 與 <code>farmland-flutter-ios</code> 獨立用戶端註冊。</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-amber-500 font-mono">•</span>
              <span><strong>網路可用性：</strong>假設現場長輩或巡田人員可能在離線狀態下停留 1~4 小時，必須保證本機可安全儲存作業草稿與照片快取。</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-amber-500 font-mono">•</span>
              <span><strong>地圖圖資：</strong>雙平台初期採用 Google Maps SDK for Flutter 作為標準地圖底圖，圖資資料以 GeoJSON (WGS84) 規格由後端獨立保存。</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-amber-500 font-mono">•</span>
              <span><strong>三維重建設限：</strong>三維重建為後續可選模組，絕不阻塞第一至三階段核心農務、記帳、排程與出貨功能。</span>
            </li>
          </ul>
        </div>

        <div className="bg-stone-900 border border-blue-900/60 rounded-2xl p-5">
          <div className="flex items-center gap-2 text-blue-400 font-bold text-sm mb-3">
            <HelpCircle className="w-4 h-4" />
            <span>待驗證項目 (To Be Verified)</span>
          </div>
          <ul className="space-y-2.5 text-xs text-stone-300">
            <li className="flex items-start gap-2">
              <span className="text-blue-400 font-mono">?</span>
              <span><strong>指定 OAuth 儲存庫實況：</strong><code>shenlee377/chat-coffee-bot-python</code> 之分支目前狀態、是否已上線部署或僅存本地重構。</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-blue-400 font-mono">?</span>
              <span><strong>正式網域與身分識別：</strong>正式產品英文代號（如 <code>farmland-diary</code>）、Android applicationId、iOS Bundle ID。</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-blue-400 font-mono">?</span>
              <span><strong>農藥官方資料庫串接方式：</strong>是否需對接農業部動植物防疫檢疫署 (BAPHIQ) 之農藥登記公開資料 API。</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-blue-400 font-mono">?</span>
              <span><strong>Cloud SQL 初期成本預算：</strong>評估使用 Cloud SQL Developer edition / scale-to-zero 與 Firestore 的成本承受度。</span>
            </li>
          </ul>
        </div>
      </section>

      {/* 3. 最多五個高影響澄清問題 */}
      <section className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center gap-2 mb-4">
          <span className="w-2 h-2 rounded-full bg-amber-500"></span>
          <h3 className="text-lg font-bold text-white">二、五個高影響澄清問題 (High-Impact Clarifications)</h3>
        </div>
        <div className="space-y-4">
          <div className="p-4 bg-stone-800/40 rounded-xl border border-stone-700/60">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-emerald-400">問題 1：外部身分對應與 OAuth 存取權限</span>
              <span className="text-[0.6875rem] px-2 py-0.5 rounded bg-emerald-950 text-emerald-300 border border-emerald-800">登入架構</span>
            </div>
            <p className="text-xs text-stone-300 mt-2 font-medium">
              目前您手邊是否能直接提供 <code>shenlee377/chat-coffee-bot-python</code>（分支 <code>v5-Google-Cloud-Run</code>）中的 <code>docs/IOS_OAUTH.md</code> 與 <code>backend/oauth_clients.py</code> 檔案內容或脫敏截圖？
            </p>
            <p className="text-xs text-stone-400 mt-1">
              <strong>工程建議：</strong>若暫無私有儲存庫唯讀權限，階段 0 與階段 1 建議先在後端建立標準 <code>AuthGateway</code> 介面，使用支援 PKCE 的本機 Mock/Dev 帳號驗證，待提供檔案後一鍵換裝正式 OAuth 客戶端。
            </p>
          </div>

          <div className="p-4 bg-stone-800/40 rounded-xl border border-stone-700/60">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-emerald-400">問題 2：核心資料庫選型決策</span>
              <span className="text-[0.6875rem] px-2 py-0.5 rounded bg-blue-950 text-blue-300 border border-blue-800">資料庫持久層</span>
            </div>
            <p className="text-xs text-stone-300 mt-2 font-medium">
              本報告經詳細比對，主要推薦<strong>「Cloud SQL (PostgreSQL + PostGIS) + GCS」</strong>以確保土地多對多關聯、庫存扣抵與工資財務的 ACID 交易一致性。您是否同意此推薦作為主要方案？
            </p>
            <p className="text-xs text-stone-400 mt-1">
              <strong>工程建議：</strong>若考量初期零閒置成本與免開伺服器特性，Firestore 亦可搭配嚴格後端交易與次級索引實現，但會增加多表聚合、工資結算與空間幾何計算的複雜度。
            </p>
          </div>

          <div className="p-4 bg-stone-800/40 rounded-xl border border-stone-700/60">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-emerald-400">問題 3：雙平台 Client ID 與 Scheme 命名預設</span>
              <span className="text-[0.6875rem] px-2 py-0.5 rounded bg-purple-950 text-purple-300 border border-purple-800">應用識別</span>
            </div>
            <p className="text-xs text-stone-300 mt-2 font-medium">
              是否同意在待定階段暫時採用建議名稱：英文識別 <code>farmland-diary</code>、Android <code>tw.farmland.diary</code>、iOS <code>tw.farmland.diary</code>、自訂 URL Scheme <code>farmlanddiary://oauth/callback</code>？
            </p>
            <p className="text-xs text-stone-400 mt-1">
              <strong>說明：</strong>此僅為開發與範例配置代碼，絕不宣稱已註冊或佔用，未來可隨時由您在正式發布時無痛替換。
            </p>
          </div>

          <div className="p-4 bg-stone-800/40 rounded-xl border border-stone-700/60">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-emerald-400">問題 4：農民長輩與語音回報互動優先級</span>
              <span className="text-[0.6875rem] px-2 py-0.5 rounded bg-amber-950 text-amber-300 border border-amber-800">使用者體驗</span>
            </div>
            <p className="text-xs text-stone-300 mt-2 font-medium">
              長輩在田間回報作業時，首推「大圖示按鈕 + 語音錄音檔上傳 + 原文草稿保留」，由管理者或子女晚間登入後再進行批次確認；此流程是否符合您的家庭協作實務？
            </p>
            <p className="text-xs text-stone-400 mt-1">
              <strong>說明：</strong>這能避免強迫長輩在大太陽下輸入複雜的下拉選單或打字，且確保每一筆回報都可追溯「說了什麼、誰確認的」。
            </p>
          </div>

          <div className="p-4 bg-stone-800/40 rounded-xl border border-stone-700/60">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-emerald-400">問題 5：巡田影像雲端品質檢核的重度運算觸發時機</span>
              <span className="text-[0.6875rem] px-2 py-0.5 rounded bg-red-950 text-red-300 border border-red-800">運算與成本</span>
            </div>
            <p className="text-xs text-stone-300 mt-2 font-medium">
              巡田照片上傳後，雲端檢核是否僅在使用者點擊「完成巡田段落並請求檢查」時才觸發非同步 Cloud Run Job，抑或是每上傳 5 張即自動批次排程？
            </p>
            <p className="text-xs text-stone-400 mt-1">
              <strong>工程建議：</strong>建議採「段落確認手動觸發 / 離場前檢查」以節省不必要的雲端 CPU 與頻寬費用，並給使用者明確的控制感。
            </p>
          </div>
        </div>
      </section>

      {/* 4. MVP 與後續研究功能界線 */}
      <section className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center gap-2 mb-4">
          <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
          <h3 className="text-lg font-bold text-white">三、MVP 與後續功能界線 (Scope Boundaries)</h3>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="p-4 bg-emerald-950/20 border border-emerald-900/60 rounded-xl">
            <h4 className="text-sm font-bold text-emerald-300 mb-3 flex items-center gap-1.5">
              <span>●</span> 里程碑一與核心 MVP 範圍 (必須真正落地)
            </h4>
            <ul className="space-y-2 text-xs text-stone-300 leading-relaxed">
              <li>• <strong>工作空間與成員隔離：</strong>支援個人、家庭共同經營者、唯讀成員之多租戶隔離。</li>
              <li>• <strong>田區與土地關係：</strong>支援多地號關聯、自填所有權人標籤、租賃期限與水井位置。</li>
              <li>• <strong>期作與分區種植：</strong>輪作歷史不覆蓋前作紀錄、休耕標記、品種與苗株批次。</li>
              <li>• <strong>外部工作聯絡人：</strong>建立電話、工作限制、工資快照；不需強制註冊帳號。</li>
              <li>• <strong>農務派工與回報：</strong>區分計畫、回報與正式確認；資材規格換算與「施藥嚴謹狀態」。</li>
              <li>• <strong>私有相片上傳：</strong>透過 GCS Signed URL 上傳與授權查閱，保護田區私密性。</li>
            </ul>
          </div>

          <div className="p-4 bg-stone-800/40 border border-stone-700/60 rounded-xl">
            <h4 className="text-sm font-bold text-stone-300 mb-3 flex items-center gap-1.5">
              <span>○</span> 後續擴充與實驗性研究模組 (不阻塞核心進度)
            </h4>
            <ul className="space-y-2 text-xs text-stone-400 leading-relaxed">
              <li>• <strong>三維點雲與網格重建 (階段 5)：</strong>COLMAP / NerfStudio / Gaussian Splatting，需大型 GPU 運算，採非同步佇列。</li>
              <li>• <strong>實景田界 AR 投影 (階段 5)：</strong>手機相機畫面疊合管理邊界，依賴精確內參姿態估計。</li>
              <li>• <strong>DJI 無人機 Mobile SDK 遙測整合 (階段 5)：</strong>雲台姿態與影像時間校準插值，不列為必備硬體。</li>
              <li>• <strong>政府天然災害救助智慧備件 (階段 3)：</strong>災損照片對比、農情報告匯出，AI 僅供草稿，非官方收件。</li>
            </ul>
          </div>
        </div>
      </section>
    </div>
  );
};
