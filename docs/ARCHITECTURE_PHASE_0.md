# 農田日記 (Farmland Diary) - 第一輪架構規格與決策藍圖

## 聲明與平台邊界
- 正式前端客戶端：Flutter (Android 原始碼開源 GitHub + APK 下載；iOS 準備上架 App Store)。
- 正式後端：上傳至 GitHub 私有儲存庫 (Private GitHub Repository)，僅供私人維護；Python FastAPI 部署於 Google Cloud Run，物件保存於 Google Cloud Storage。
- 本 AI Studio 預覽環境為「架構規格審查、狀態機驗證與輔助設計導航原型」，不代表正式 Flutter App 已經完成。

---

## 1. 產品理解與核心使用者流程
產品精神：「**事實可信、責任明確、操作極簡、避免虛報**」。
面向臺灣家庭農場與小型農業經營者，解決以下核心痛點：
1. **確權與空間：** 這塊田是誰的、誰在用（地主自填標註「未官方查證」、多地號關聯、邊界版本）。
2. **期作與輪作：** 前後作交替、休耕期綠肥翻埋，歷史紀錄不互相覆蓋。
3. **人員與通訊：** 長輩與工班不強制裝 App，電話聯繫優先；打電話不等於已答應，排行程不等於已通知。
4. **資材與履歷：** 口語「一包半」留存原文，規格確認後換算；沒有施藥紀錄絕不可推論為沒有施用。
5. **巡田與品質閉環：** 單機採集，伺服器接收、覆蓋檢核、補拍引導、成果處理四階段分明。

---

## 2. 三份清單 (已確定、假設、待驗證)

### 已確定 (Confirmed)
- 客戶端雙平台同步使用 Flutter。
- Android 開放原始碼並產出 APK；iOS 準備上架。
- 後端私有化，核心 API 部署 Google Cloud Run，大檔放 GCS。
- 田區管理邊界與地政地籍線脫鉤，支援多對多地號。
- 聯絡人無須 App 帳號；無紀錄不可推論為未施藥。

### 核心假設 (Assumptions)
- 咖啡廳專案 `shenlee377/chat-coffee-bot-python` 之 `v5-Google-Cloud-Run` 分支支援新增專用 client。
- 田間使用者有 1~4 小時離線場景，本機需有 SQLite / Hive 快取。
- 第一版地圖優先採用 Google Maps SDK for Flutter，資料以 WGS84 GeoJSON 保存。
- 三維重建與 LiDAR 屬於階段 5 可選功能，不阻塞日常農務。

### 待驗證 (To Be Verified)
- 咖啡廳 OAuth 伺服器之實裝與部署狀態（提供 `docs/IOS_OAUTH.md` 與 `backend/oauth_clients.py`）。
- 正式英文代號、Android applicationId、iOS Bundle ID。
- 農業部動植物防檢署 (BAPHIQ) 農藥登記資料庫 API 串接細節。
- Cloud SQL for PostgreSQL 成本預算承受度。

---

## 3. 五個高影響澄清問題
1. **OAuth 儲存庫實況：** 是否可提供 `v5-Google-Cloud-Run` 分支中 `IOS_OAUTH.md` 與 `oauth_clients.py` 之內容？（階段 0 先提供 Dev Mock 支援，後續替換）
2. **資料庫選型定案：** 是否同意主要推薦採用方案 B (Cloud SQL for PostgreSQL + PostGIS + GCS)？
3. **識別碼暫定名稱：** 是否同意暫定採用 `farmland-diary` 與 `tw.farmland.diary`？
4. **長輩田間回報互動：** 首推「大圖示按鈕 + 語音錄音 + 原文保留 + 管理者確認」流程是否符合期待？
5. **巡田重運算觸發：** 是否採「段落確認手動觸發 / 離場前檢查」以節省非必要雲端費用？

---

## 4. MVP 與研究功能邊界
- **MVP (階段 1~3)：** 租戶隔離、田區與共有土地關係、輪作期作、免裝 App 外部雇工、農務回報與資材扣抵、私有照片上傳、基本權限與審計。
- **後續研究 (階段 4~5)：** 單手機覆蓋率檢核與補拍任務（階段 4）；COLMAP / NerfStudio 三維重建、實景田界 AR 投影、DJI 無人機 Mobile SDK 遙測整合（階段 5）。

---

## 5. 資料庫選型比較與推薦
- **結論：主要推薦方案 B (Cloud SQL for PostgreSQL + PostGIS + GCS)**。
- **理由：**
  - **土地與地號關聯：** 多對多關聯表與外鍵約束天然契合，杜絕孤立紀錄。
  - **空間幾何 (GIS)：** 原生 `ST_Area` 與 `ST_Intersects` 提供精確臺灣地表面積投影，遠勝 Firestore 之單點 Geohash。
  - **財務與庫存一致性：** 具備完整 ACID 事務與行級鎖，資材扣抵與工資結算無競態條件。

---

## 6. 四大狀態機規則
1. **工作任務狀態機：** `DRAFT` → `SCHEDULED` → `IN_PROGRESS` → `COMPLETED`（或 `CANCELLED`）。
2. **人員安排狀態機：** `UNCONTACTED` → `CONTACTED_PENDING` → `CONFIRMED` → `CHECKED_IN` → `COMPLETED`。
   - 打電話不等於答應；排日程不等於已通知。
3. **施藥狀態判定：**
   - 無紀錄時強制顯示 `PENDING_CONFIRMATION`（待確認），嚴禁假定未施用。
   - 僅在管理者親自核對切結時，方可判定為 `CONFIRMED_NOT_APPLIED`。
4. **巡田品質閉環 (九階段)：**
   - `LOCAL_SAVED` → `SERVER_RECEIVED` → `VALIDATING` → (`RESHOOT_REQUIRED` 或 `PASSED`) → `PROCESSING` → `READY`（或 `PARTIAL` / `FAILED`）。
   - 上傳完成不等於採集通過，採集通過不等於成果就緒。

---

## 7. 雲端成本模型與上限策略
- **固定閒置成本：** Cloud Run 採 scale-to-zero ($0/月)；Cloud SQL 開發環境使用 scale-to-zero，正式環境微型實例約 $9~$15 美元/月。
- **隨用量遞增：** Cloud Storage 標準儲存每 GB 約 $0.026 美元；GCP 免費層涵蓋前 200 萬次請求與 10GB 頻寬。
- **AI / GPU 重運算：** Gemini 2.5 Flash 每次調用約 $0.0001~$0.0003 美元；三維重建採按需排程並設 15 分鐘強制逾時。
- **安全防護上限：** 建立每工作空間每日照片上傳上限 (200張) 與 $20/$50 美元雙層警報閥值。

---

## 8. 里程碑一端到端驗收標準
驗收情境：
1. 登入系統並取得穩定使用者識別 (`user-lin-01`)。
2. 建立工作空間 (`ws-tw-xiluo-001`)。
3. 建立田區（北田 0.85公頃，關聯公館段 0451、0452 地號，承租土地關係）與一期作。
4. 新增免裝 App 外部雇工（阿吉叔，保留日薪與工作限制）。
5. 建立農務任務並安排人員（電話聯繫轉為已答應）。
6. 回報現場作業與資材（留存「一包半」原文，上傳私有照片，施藥嚴格查驗）。
7. 重新登入後資料完整留存。
8. 切換為未授權使用者 (`unauthorized-user-09`) 存取，系統回傳 HTTP 403 被拒。
