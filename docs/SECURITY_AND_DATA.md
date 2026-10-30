# 農田日記 — 安全、權限與資料生命週期（SECURITY_AND_DATA）

> 狀態：設計草案。正式發布前需再依 App Store、Google Play 當前政策與個資法規逐項核對。
> 最後更新：2026-10-30

## 1. 權限模型

授權決策只發生在後端 `authz` 模組：`allowed(user, workspace, action, resource, field_groups)`。

### 1.1 動作 × 角色（M1 範圍）

| 動作 | owner | manager | bookkeeper | worker | advisor | viewer |
| --- | --- | --- | --- | --- | --- | --- |
| 管理成員與角色 | ✔ | 邀請 worker／viewer | — | — | — | — |
| 建立／修改田區、邊界 | ✔ | ✔ | — | — | — | — |
| 土地關係（含租金、合約） | ✔ | ✔ | 讀 | — | — | — |
| 期作、種植區 | ✔ | ✔ | 讀 | 讀 | 讀（授權田區） | 讀 |
| 聯絡人（含電話、工資） | ✔ | ✔ | 讀 | 僅姓名與同工作的帶班電話 | — | — |
| 建立工作、安排人員 | ✔ | ✔ | — | — | — | — |
| 回報作業、上傳照片 | ✔ | ✔ | — | 自己被安排的工作 | — | — |
| 確認／修正正式紀錄 | ✔ | ✔ | — | — | — | — |
| 查看正式紀錄與照片 | ✔ | ✔ | ✔ | 自己參與的 | 授權田區 | ✔ |

### 1.2 欄位群組

`land_contract`（租金、合約附件）、`contact_pii`（電話、限制）、`wage`（工資約定、應付已付）、`finance`（成本、收入）、`location_precise`（精確座標）。API 依權限在序列化時移除欄位，並在回應標記 `redacted_fields`，讓 UI 顯示「無權查看」而不是空白。

### 1.3 強制方式

1. 路由層：每個 `/workspaces/{id}/…` 以 dependency 取得 membership，不存在或 `removed` → 404（不洩漏工作空間是否存在）。
2. 服務層：每個命令呼叫 `authz`。
3. 資料層：repo 所有查詢強制 `workspace_id`；子資料以複合外鍵 `(workspace_id, parent_id)` 確保不能掛到別人的父資料。
4. 第二道防線（可選，M2 評估）：PostgreSQL Row-Level Security，以 `SET LOCAL app.workspace_id`。
5. 測試：每個端點都有「其他工作空間的使用者」與「被移除成員」的案例，CI 必跑。

## 2. 雲端安全基線

- 服務帳號：`farm-api`（Cloud SQL client、指定 bucket 的物件讀寫、Cloud Tasks enqueuer、讀取指定 secrets）、`farm-worker`（Cloud SQL client、bucket 讀寫）、`farm-deployer`（CI 部署用，Workload Identity Federation，不用長效 JSON 金鑰）。不使用 Compute 預設服務帳號。
- Cloud Tasks 與 Scheduler 呼叫 worker 時使用 OIDC token，worker 驗證 audience 與服務帳號；worker 不對外開放 unauthenticated。
- 機密放 Secret Manager；上游 refresh token 以 Cloud KMS 金鑰做 envelope encryption 後存 DB。
- Bucket：Uniform bucket-level access、禁止公開存取（Public access prevention）、版本控制視成本開啟、生命週期規則。
- 上傳：Signed URL 限定方法、content-type、`x-goog-content-length-range`；完成後伺服器端再檢查大小、MIME（magic bytes）、雜湊。只接受 JPEG／HEIC／PNG／WebP、AAC／M4A／Opus、PDF。
- 配額：每工作空間每日上傳數與總量、AI 請求數與 token、處理工作數；每使用者 API 速率限制。
- 日誌：結構化日誌；遮蔽 `Authorization`、token、電話、租金、工資；記錄 request_id、user_id、workspace_id、動作、結果。
- AI（階段 3）：工具白名單、參數 schema 驗證、以使用者權限執行查詢（不給模型資料庫帳號）、外部文件與影像內容視為不可信輸入、金錢／派工／外部通知需人工確認、保存模型名稱與版本、輸入摘要、依據、時間、人工決定。

## 3. 資料分類與保存位置

| 類別 | 例子 | 位置 | 保存期限（預設，可調） |
| --- | --- | --- | --- |
| 正式業務資料 | 田區、期作、工作、紀錄、財務 | PostgreSQL | 工作空間存續期間；封存不刪 |
| 空間資料 | 邊界版本、軌跡、地號 | PostgreSQL／PostGIS | 同上；軌跡原始點可在 1 年後降採樣（待決定） |
| 大型檔案 | 照片、語音、單據、合約 | GCS（原檔）+ DB 索引 | 同所屬紀錄；被拒絕的回報附件 180 天後可清除 |
| 高頻感測資料 | 巡田影格 metadata、IMU、姿態 | GCS 分塊檔（例如每 10 秒一個 Parquet／壓縮 JSON Lines）+ DB 索引 | 原始分塊 1 年，之後依品質報告決定保留 |
| AI 與處理結果 | 草案、觀察、重建成果 | DB（摘要、狀態、來源）+ GCS（大型成果） | 草案 90 天未採用即刪；採用者隨紀錄 |
| 稽核與事件 | audit_log、domain_event、通知 | PostgreSQL（或日後匯出到 BigQuery／GCS） | 稽核 3 年；事件 cursor 用途 30 天 |

## 4. 生命週期操作

| 操作 | 行為 |
| --- | --- |
| 封存田區 | 不能再新增工作；歷史紀錄、照片仍可查 |
| 刪除草稿 | 硬刪（從未成為正式紀錄） |
| 作廢正式紀錄 | 狀態 `voided` + 原因；不硬刪 |
| 成員離開／被移除 | membership → `removed`；其建立的正式紀錄保留（顯示建立人姓名快照）；其裝置下次同步收到 `membership_revoked`，清除該工作空間快取 |
| 帳號刪除 | 1) 若是某工作空間唯一 owner，必須先移交或刪除該工作空間；2) 刪除個人資料（顯示名稱改為「已刪除的使用者」）、session、external_identity；3) 共同資料（他參與的正式紀錄）保留，因為屬於工作空間；4) 撤銷咖啡廳授權（不刪咖啡廳帳號）；5) 30 天後完成清除，期間可取消 |
| 工作空間刪除 | owner 確認 + 7 天冷卻 → 刪 DB 資料與 GCS 前綴；備份依備份保存期自然到期 |
| 聯絡人刪除請求 | 聯絡人本人可透過管理者要求刪除電話等個資；出勤與工資紀錄保留必要欄位（姓名快照、金額）以符合帳務需求 |
| 資料匯出 | owner 可匯出工作空間：CSV／GeoJSON／原始檔 ZIP；匯出本身寫稽核，下載連結限時 |

## 5. 備份與還原

- Cloud SQL 自動備份 + 時間點還原（PITR）；保留天數依官方選項設定（待查證）。
- 每週 `pg_dump` 邏輯備份到另一個專案的 bucket（不同服務帳號），防誤刪整個執行個體。
- GCS：正式 bucket 開啟物件版本控制或保留政策（成本待估）；跨區複本列為階段 2 評估。
- **還原演練**：每季一次在 staging 還原最新備份並跑完整性檢查；未演練過的備份不算有效。
- 還原時，DB 與 GCS 可能不一致 → 以孤立檔案清理程序比對 `media_asset` 與物件清單，列報告而不自動刪除。

## 6. 隱私與分享

- 農場位置、聯絡人電話、工資、租金預設僅工作空間內有權角色可見。
- 分享給外部（例如顧問、買方）一律用「限時、限範圍、可撤銷」的分享連結；預設不含精確座標與個資。
- 照片 EXIF 含 GPS：原檔保留在私有 bucket；對外分享產生去除 EXIF 的版本。
- 不蒐集與農務無關的個資（身分證號、生日、家庭狀況等）。
- 行事曆同步到外部（Google Calendar，後續功能）只寫標題、時間、田區名稱；不寫電話、工資、合約。

## 7. 手機 App 權限（Android／iOS 獨立 App）

正式產品是 Flutter 編譯的**獨立 App**（Android APK／AAB、iOS App Store），相機、定位、羅盤、系統字級都走原生 API，不受瀏覽器權限限制；`prototype/web-mockup` 的網頁做法僅供原型展示。

原則：**用到時才要求**（不在安裝或啟動時一次要全部）、只在前景使用、拒絕後功能降級而不是整個 App 不能用。

| 能力 | Android | iOS | 何時要求 | 拒絕時 |
| --- | --- | --- | --- | --- |
| 相機（巡田、拍照回報） | `CAMERA`（執行期要求） | `NSCameraUsageDescription` | 第一次進入巡田或拍照 | 畫面說明用途＋「到設定開啟」按鈕；回報仍可只寫文字 |
| 定位（照片座標、巡田軌跡） | `ACCESS_FINE_LOCATION`＋`ACCESS_COARSE_LOCATION`，僅「使用 App 時」 | `NSLocationWhenInUseUsageDescription` | 第一次巡田 | 只給大略位置時照片標「定位精度低」；完全拒絕時改由使用者手選田區 |
| 羅盤（補拍轉向引導） | 不需權限（感測器） | 不需權限 | — | 裝置無磁力計時隱藏轉向箭頭，只顯示文字說明 |
| 麥克風（語音回報） | `RECORD_AUDIO` | `NSMicrophoneUsageDescription` | 第一次按語音輸入 | 改用文字輸入 |
| 選既有照片 | 系統 Photo Picker，**不申請** `READ_MEDIA_IMAGES` | PHPicker，**不申請**相簿權限 | — | — |
| 通知（工作提醒） | Android 13+ `POST_NOTIFICATIONS` | 通知授權 | 使用者開啟提醒時 | App 內「等我確認」列表仍可看到 |
| 背景上傳 | WorkManager（不需額外權限）；不常駐前景服務 | `BGTaskScheduler`／背景 URLSession | — | 下次開 App 時續傳 |

- **不申請背景定位**：巡田在 App 前景、相機畫面開著時進行，前景定位即足夠（提議，取代原先「背景定位僅在巡田功能」的保留；Google Play 對背景定位審查嚴格，省掉可簡化上架）。
- **不申請儲存空間權限**：照片與離線資料存在 App 私有目錄。
- 系統字級：Flutter 透過 `MediaQuery.textScalerOf` 直接讀取 Android「字型大小」與 iOS Dynamic Type，不需要權限；規則見 [DESIGN_SYSTEM](DESIGN_SYSTEM.md) §5。
- 權限說明文字由 App 先用白話解釋（例如「巡田需要相機，用來拍田區照片」），再跳系統對話框。

## 8. 發布前檢查（各平台，需依當期官方要求）

- iOS：隱私營養標籤、`PrivacyInfo.xcprivacy`、權限用途字串（相機、麥克風、定位、相簿）、帳號刪除入口、第三方登入相關審查指南。
- Android：Data safety 表單、權限最小化（依 §7，定位只在使用中、不申請背景定位）、目標 API level。
- 隱私權政策與服務條款頁面（需正式網域）。
