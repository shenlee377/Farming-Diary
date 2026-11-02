# 農田日記 — 最佳化與待辦清單（OPTIMIZATION_BACKLOG）

> 狀態：第一輪檢視結果。範圍：`docs/` 全部文件與 `prototype/web-mockup/`。
> 最後更新：2026-11-02
>
> 優先級：**P0** 會造成錯誤資料或違反產品三條可信度規則；**P1** 影響 M1 驗收或使用體驗；**P2** 改善品質，可延後。

## 0. 本次已完成

| 項目 | 修改 | 驗證 |
| --- | --- | --- |
| 原型無法安裝 | `esbuild@^0.25` 與 `vite@8` peer 衝突導致 `npm install` 失敗；移除未使用依賴（`@google/genai`、`express`、`dotenv`、`motion`、`esbuild`、`tsx`、`autoprefixer`、`@types/express`），建置工具移至 devDependencies，新增 `npm test` | `npm install`、`npm run lint`、`npm run build`、`npm test` 全數通過 |
| 首次載入 552 KB 單一 bundle | `App.tsx` 改為各頁籤 `React.lazy` 按需載入 | 主 bundle 降為 235 KB（gzip 75 KB）；14 個頁籤以 Playwright 逐一點開，無 console 錯誤 |
| 施藥狀態誤判 | 資料齊全但**尚未確認**的施用紀錄原本回 `INCOMPLETE_RECORD`，改回 `PENDING_CONFIRMATION`（與 DOMAIN_MODEL §3.3 定義一致） | 新增測試 |
| 離線同步可「降級」已確認施藥紀錄 | 伺服端 `APPLIED`、離線草稿 `CONFIRMED_NOT_APPLIED` 且時間較新時，原本 `CLIENT_WINS`。改為施藥狀態任何分歧一律人工裁決 | 新增測試 |
| 庫存衝突走 LWW | 註解寫「庫存與工資分歧強制人工審核」，程式只處理工資。`INVENTORY_STOCK` 分歧改為人工覆核 | 新增測試 |
| 時間戳以字串比較 | `+08:00` 與 `Z` 混用時先後判斷錯誤；改用 `Date.parse` 比較，無法解析時改為人工確認 | 新增測試 |
| 安全採收期日期邊界 | 採收日早於施藥日時顯示「已過 -8 天」；空字串得到 NaN；含時間的字串可能差一天。改為只比日期（UTC 午夜），異常輸入一律判定「不可採收」並說明原因 | 新增測試 |
| 災害救助、GPU 成本未驗證輸入 | 負面積、損害率 >100%、NaN 會算出金額；改為回傳不符資格與說明 | 新增測試 |
| 無障礙 | `<html lang="en">` → `zh-Hant-TW`（影響螢幕閱讀器發音）；導覽按鈕加 `aria-current` | — |

單元測試：10 → 16 項，全數通過。

---

## 1. 邏輯問題（剩餘）

### 1.1 原型狀態機與 DOMAIN_MODEL 不一致（P0）

`prototype/web-mockup/src/domain/state_machines.ts` 是早期 AI Studio 產物，與 `docs/DOMAIN_MODEL.md` §3 已明顯分歧。正式實作（FastAPI／Flutter）應以文件為準，**不要直接移植原型程式**。

| 狀態機 | 原型缺少／錯誤 | 文件規定 |
| --- | --- | --- |
| 工作 TASK | 只有 5 個狀態；缺 `staffing`、`ready`、`reported`、`rescheduled` | `staffing → ready` 須「已答應人數 ≥ 需求」；`reported → completed` 須管理者確認 |
| 工作 TASK | `COMPLETED → REOPEN → IN_PROGRESS` | `completed` 為終態；更正走 `record_revision`，不可重開讓歷史消失 |
| 人員 ASSIGNMENT | 缺 `needs_reconfirm`（改期後）、`left_early`（提早離開） | 改期時已答應者回到「待重新確認」 |
| 人員 ASSIGNMENT | `DECLINED／CANCELLED → CONTACT` 可復活 | 皆為終態；重新邀請應建立新的 assignment，保留原拒絕紀錄 |
| 人員 ASSIGNMENT | `CHECKED_IN → CANCEL` | 已到場者不應被「取消」（會讓出勤與工資消失）；應為 `left_early` 或 `finished` |
| 回報 WORK_REPORT | 只有型別 `WorkLogStatus`，**沒有轉換函式** | `submitted／under_review／needs_info／confirmed／rejected／amended／voided` |
| 單檔上傳 | 未實作 | `uploading → local_saved`（重試）、`processing_failed`（原檔仍可用） |
| 巡田品質 | 缺 `unverified_offline`；`PARTIAL` 不可補件重算；`RESHOOT_REQUIRED` 回 `SERVER_RECEIVED`（文件為回 `validating`） | 見 §3.4 |

建議做法：把每張狀態圖寫成**與語言無關的測試向量**（JSON：`from`、`event`、`expected` 或 `error`），放在公開 repo（例如 `spec/state_machines/*.json`）。後端 pytest 與 Flutter test 讀同一份向量，避免三份實作各自漂移。

### 1.2 尚未實作的規則（P0）

- **施藥彙總規則**：期間內任一筆 `applied` → `applied`；沒有紀錄 → `unknown`。目前只有單筆判斷，沒有田區／期作層級彙總函式。
- **已答應人數計算**：`staffing → ready` 依賴「只計 accepted」，需一個純函式並測試 `awaiting_reply` 不計入（ROADMAP §4 步驟 7）。
- **`wage_rate_snapshot` 寫入時機**：在 `accepted` 時寫入，之後調整預設工資不得影響。

### 1.3 離線同步設計（P1）

- 目前以「整個實體」做 Last-Write-Wins，且依賴**客戶端時鐘**（手機時間可能錯）。正式設計應以 `version` 樂觀鎖 + 欄位層級合併，伺服器時間為準。
- `WORK_LOG` 文字合併不具冪等性：同一衝突重送兩次會產生 `【本機離線回報】【本機離線回報】…` 巢狀前綴。正式版應把每次回報存成獨立 `work_report`，不合併字串。
- 庫存應以異動帳（`stock_movement`）重算，同步時只傳異動，不傳庫存快照，衝突自然消失。

### 1.4 示範數據與判斷（P1）

- 安全採收期以「藥劑」單一鍵查表，實際依**作物 × 藥劑 × 劑型**而異；須改為查官方登記資料（PROJECT_BRIEF V7）。
- `evaluateTapCompliance` 的「紀錄少於 3 筆即需稽核」為任意門檻，沒有依據。
- 災害救助每公頃金額與 20% 門檻未查證；UI 只試算葉菜類。
- 金額以浮點數計算（GPU 成本）。文件規定 `numeric(14,2)`；前端顯示也應以整數「分」或 decimal 函式庫計算。

### 1.5 原型 UI 程式小問題（P2）

- `Phase1LiveWorkspace.tsx` 人員狀態按鈕遇到不合法轉換時 `catch` 後直接吞掉錯誤，使用者按了沒反應；應顯示原因。
- 同檔 `setTasks(tasks.map(...))` 使用閉包中的舊 state，連續點擊可能遺失更新；改用 `setTasks(prev => prev.map(...))`。
- 多處 `catch (e: any)`，可改為 `unknown` 並安全取 `message`。

---

## 2. UI 深入建議

### 2.1 對齊設計系統（P1）

原型目前是深色 `stone-950` 背景、大量 `text-xs`（12px），與 `DESIGN_SYSTEM.md` 相反：

| 項目 | 原型 | 設計系統 |
| --- | --- | --- |
| 主題 | 深色為主 | 淺色 `surface #FAF7F0` 為主，深色為選項 |
| 內文 | 12–14px | `body` 17，最小 `caption` 14 且不放重要資訊 |
| 主色 | Tailwind emerald | `primary #2F6B3A` |

建議把 §4 色票與 §5 字級寫成 Tailwind `@theme` token，原型與未來 Flutter `ThemeData` 共用同一份來源（例如 `design/tokens.json`）。

### 2.2 長輩與田間情境（P1）

- **首頁三區塊**：「今天要做／等我確認／最近異常」，每張工作卡顯示田區、集合時間地點、已答應 n／需求人數。
- **3 次點擊回報**：工作卡 →「我做完了」→ 拍照或按住說話（可略過）→ 送出。按鈕最小 48dp，主要動作放拇指可及的下半部。
- **上傳狀態要分清楚**：「已存在手機」「上傳中」「已上傳，等○○確認」「已確認」各用不同圖示＋文字，不只靠顏色。
- **缺資料顯示元件**：統一的「尚未確認」「紀錄不完整」標籤，絕不顯示空白或「無」。
- **原話保留**：資材顯示「一包半」原文＋「待換算」標籤，管理者點開才填公斤數。
- **日照可讀性**：戶外模式（加粗、高對比），避免淺灰次要文字。

### 2.3 管理者介面（P1）

- **確認審核畫面**：左邊回報原文／照片／語音，右邊即將寫入的正式紀錄欄位；可「確認」「要求補資料」「退回」並填原因。
- **改期影響清單**：改期或取消時列出受影響人員、資材、機具；每人勾選是否通知，系統不自動發送。
- **修改歷程**：正式紀錄顯示 `record_revision` 時間軸（誰、何時、改了什麼、原因）。
- **角色切換預覽**：原型加一個「以 worker／bookkeeper 身分檢視」切換，展示敏感欄位（租金、電話、工資）如何隱藏。

### 2.4 原型導覽（P2）

- 14 個頁籤混合「規格文件」與「互動畫面」，建議分成兩組；互動畫面改為手機外框＋底部導覽，較接近正式 App。
- 以 URL hash 記錄目前頁籤，方便在討論中直接貼連結。

---

## 3. 設計需要的功能（依里程碑）

### M1 必要（已在文件中，提醒驗收重點）

- 工作空間／角色／欄位群組權限（後端過濾）；跨工作空間一律 404。
- 田區邊界版本（GeoJSON，伺服器計算面積並標示方法）、地號多對多、土地關係與查證等級。
- 聯絡人不需帳號；人員安排歷程（`assignment_event`）。
- 回報 → 確認 → 正式紀錄；照片以 `client_upload_id` 冪等上傳、限時讀取 URL。
- 稽核紀錄（敏感讀取＋所有寫入）。

### 文件中尚未涵蓋、建議補上的功能

| 功能 | 理由 | 建議階段 |
| --- | --- | --- |
| **聯絡人通知管道（LINE／簡訊）** | 臨時工多半沒有 App，臺灣以 LINE 與電話為主；需決定是「產生訊息讓管理者複製轉貼」還是串接 LINE 官方帳號 | M1 決定、M2 實作 |
| **單位換算表** | 「一包半」「一桶」「一分地」需依產品包裝規格與臺灣慣用單位（分、甲、坪）換算 | M1（只存原話）、M2（換算） |
| **語音輸入（含臺語）** | 長輩口述是主要回報方式；先存原始錄音，轉文字為 AI 草案須確認 | M1 存檔、M3 轉文字 |
| **天氣資料** | 中央氣象署開放資料；改期建議與災害佐證 | M2 |
| **產銷履歷（TAP）匯出** | 直接對應農民實際行政需求；依正式紀錄產出，缺資料清楚標示 | M3 |
| **資料匯出與備份** | 使用者能自行匯出全部資料（CSV／JSON＋照片），降低被鎖定疑慮 | M2 |
| **農曆／節氣顯示** | 長輩常以節氣與農曆安排農事 | M2（行事曆） |
| **離職／移除成員交接** | 被移除成員的未完成工作、聯絡人歸屬 | M1-C |

---

## 4. 工程與 repo（P2）

- **`.aistudio/artifacts/`**：29 張截圖約 6 MB，DECISIONS.md 已註記「可移除」；建議刪除或移出 repo（需你確認）。
- **CI**：本次新增 `.github/workflows/prototype.yml`（原型的型別檢查、測試、建置）。M1-E 建立 Flutter App 後再加 `flutter analyze`／`flutter test`。
- **lockfile**：本次提交 `package-lock.json`，確保 CI 安裝版本一致。
- **共用測試向量**：見 §1.1，放公開 repo，私有後端以 git submodule 或 CI 下載方式取用。
