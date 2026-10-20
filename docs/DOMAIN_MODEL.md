# 農田日記 — 領域模型與狀態機（DOMAIN_MODEL）

> 狀態：設計草案。M1 只實作標示 ★ 的實體；其他實體先定名稱與關係，避免日後大改。
> 最後更新：2026-10-20

## 1. 共通欄位與規則

所有業務表都有：

| 欄位 | 說明 |
| --- | --- |
| `id` | UUIDv7，客戶端可產生 |
| `workspace_id` | 工作空間隔離鍵（`workspace` 本身與 `user` 除外）；複合外鍵確保子資料與父資料同一工作空間 |
| `version` | 整數，樂觀鎖 |
| `created_at` / `created_by` / `updated_at` / `updated_by` | `timestamptz`（UTC 儲存，顯示 Asia/Taipei） |
| `archived_at` | 封存（軟刪除）；正式紀錄不硬刪 |

- 金額：`numeric(14,2)` + `currency`（預設 TWD）；不用浮點數。
- 數量：`numeric(14,4)` + `unit_code`；換算需引用 `unit_conversion` 或產品包裝規格，並保存 `raw_quantity_text`（原話，例如「一包半」）。
- 來源與確認：重要事實帶 `source`（user_input／document／import／ai_draft／device）、`confirmation_status`（unconfirmed／confirmed／disputed）、`confirmed_by`、`confirmed_at`。
- 正式紀錄修改：寫入 `record_revision`（完整前後值、原因、操作人），不覆蓋歷史。
- 稽核：`audit_log` 記錄敏感讀取（合約、電話、工資）與所有寫入。

## 2. 核心 ER 圖

```mermaid
erDiagram
  USER ||--o{ EXTERNAL_IDENTITY : "登入身分"
  USER ||--o{ MEMBERSHIP : "加入"
  WORKSPACE ||--o{ MEMBERSHIP : "成員"
  WORKSPACE ||--o{ FIELD : "擁有"
  WORKSPACE ||--o{ CONTACT : "聯絡人"
  WORKSPACE ||--o{ LAND_PARCEL : "地號"
  WORKSPACE ||--o{ PARTY : "關係人"

  FIELD ||--o{ FIELD_BOUNDARY_VERSION : "邊界版本"
  FIELD }o--o{ LAND_PARCEL : "field_parcel"
  LAND_PARCEL ||--o{ LAND_RELATION : "所有／承租／使用"
  PARTY ||--o{ LAND_RELATION : "關係人"
  LAND_RELATION ||--o{ ATTACHMENT : "合約附件"

  FIELD ||--o{ CROP_SEASON : "期作"
  CROP_SEASON ||--o{ PLANTING : "種植區／作物批次"
  CROP ||--o{ PLANTING : "作物"

  WORKSPACE ||--o{ TASK : "工作"
  TASK }o--o| CROP_SEASON : "屬於"
  TASK }o--|| FIELD : "田區"
  TASK ||--o{ ASSIGNMENT : "人員安排"
  CONTACT ||--o{ ASSIGNMENT : "被安排"
  ASSIGNMENT ||--o{ ASSIGNMENT_EVENT : "聯繫／回覆歷程"

  TASK ||--o{ WORK_REPORT : "執行回報"
  WORK_REPORT ||--o| WORK_RECORD : "確認後成為"
  WORK_RECORD }o--|| FIELD : "田區"
  WORK_RECORD }o--o| CROP_SEASON : "期作"
  WORK_RECORD ||--o{ WORK_RECORD_INPUT : "使用資材"
  WORK_RECORD ||--o{ RECORD_REVISION : "修改歷程"
  WORK_REPORT ||--o{ MEDIA_ASSET : "照片／語音"
  MEDIA_ASSET ||--|| UPLOAD : "來自"

  PRODUCT ||--o{ STOCK_LOT : "批次"
  STOCK_LOT ||--o{ STOCK_MOVEMENT : "入庫／領用／調整"
  WORK_RECORD_INPUT }o--o| STOCK_MOVEMENT : "對應領用"

  WORKSPACE ||--o{ PROCESSING_JOB : "處理工作"
  WORKSPACE ||--o{ AUDIT_LOG : "稽核"

  USER {
    uuid id PK
    text display_name
    timestamptz deleted_at
  }
  EXTERNAL_IDENTITY {
    uuid id PK
    uuid user_id FK
    text provider "cafe_oauth"
    text issuer "授權伺服器 origin"
    text client_id
    text subject "pairwise sub"
  }
  MEMBERSHIP {
    uuid workspace_id PK
    uuid user_id PK
    text role
    text status "invited/active/removed"
  }
  FIELD {
    uuid id PK
    text name
    text aliases
    numeric area_m2
    text area_method
    text area_source
  }
  FIELD_BOUNDARY_VERSION {
    uuid id PK
    geometry geom "SRID 4326"
    text source "drawn/track_draft/import"
    text quality
    timestamptz valid_from
    timestamptz valid_to
    text status "draft/confirmed/superseded"
  }
  LAND_RELATION {
    uuid id PK
    text kind "owner/co_owner/lessee/operator/user"
    text share
    date period_start
    date period_end
    numeric rent_amount "敏感"
    text verification "self_reported/document_seen/officially_verified"
  }
  CROP_SEASON {
    uuid id PK
    text name
    text status "planned/active/fallow/closed"
    date planned_start
    date actual_start
    date planned_end
    date actual_end
  }
  TASK {
    uuid id PK
    text title
    text work_type
    text status
    timestamptz planned_start
    timestamptz planned_end
    timestamptz meet_at
    text meet_place
    int headcount_needed
  }
  ASSIGNMENT {
    uuid id PK
    text role "lead/member"
    text status
    numeric wage_rate_snapshot "敏感"
  }
  CONTACT {
    uuid id PK
    text name
    text nickname
    text phone "敏感"
    text preferred_channel
    text work_constraints "本人確認"
    uuid linked_user_id "可選"
  }
  WORK_REPORT {
    uuid id PK
    text reported_by_kind "user/contact_via_user"
    timestamptz actual_start
    timestamptz actual_end
    text raw_text
    text status
  }
  WORK_RECORD {
    uuid id PK
    text work_type
    text pesticide_status "applied/confirmed_none/unknown/incomplete"
    uuid confirmed_by
    timestamptz confirmed_at
  }
  WORK_RECORD_INPUT {
    uuid id PK
    uuid product_id
    text raw_quantity_text "例：一包半"
    numeric quantity
    text unit_code
    text conversion_basis
    text status "confirmed/pending_spec"
  }
  UPLOAD {
    uuid id PK
    text client_upload_id "冪等"
    text status
    text sha256
    bigint size_bytes
    text mime
  }
  MEDIA_ASSET {
    uuid id PK
    text gcs_path
    text kind "photo/audio/document"
    timestamptz captured_at
    geometry location "可選"
  }
```

### 2.1 M1 範圍（★）

★ USER、EXTERNAL_IDENTITY、WORKSPACE、MEMBERSHIP、FIELD、FIELD_BOUNDARY_VERSION、LAND_PARCEL、FIELD_PARCEL、PARTY、LAND_RELATION、CROP、CROP_SEASON、PLANTING、CONTACT、TASK、ASSIGNMENT、ASSIGNMENT_EVENT、WORK_REPORT、WORK_RECORD、RECORD_REVISION、UPLOAD、MEDIA_ASSET、AUDIT_LOG、AUTH_SESSION。

WORK_RECORD_INPUT 在 M1 只保存原話與待確認狀態，不連庫存（庫存在階段 2）。

### 2.2 階段 2 以後的實體（先定名）

`product`、`supplier`、`purchase`、`purchase_line`、`stock_lot`、`stock_movement`、`attendance`、`wage_agreement`、`payable`、`payment`、`cost_entry`、`cost_allocation`、`harvest_lot`、`processing_step`、`product_lot`、`shipment`、`buyer`、`receivable`、`receipt`、`anomaly`、`anomaly_followup`、`weather_snapshot`、`admin_case`、`disaster_event`、`insurance_policy`、`insurance_claim`、`capture_session`、`capture_frame_chunk`、`reshoot_task`、`processing_job`、`processing_output`、`ai_interaction`、`ai_draft`、`domain_event`、`notification`。

## 3. 狀態機

狀態轉移只能透過服務層的命令進行；伺服器驗證轉移合法性與執行者角色，並寫入 `domain_event`。

### 3.1 工作（TASK）

```mermaid
stateDiagram-v2
  [*] --> draft
  draft --> scheduled: 排定時間與田區
  scheduled --> staffing: 開始找人
  staffing --> ready: 已答應人數 ≥ 需求
  ready --> staffing: 有人取消
  scheduled --> ready: 不需外部人力
  ready --> in_progress: 有人到場／回報開始
  staffing --> in_progress: 管理者決定人力不足仍開工
  in_progress --> reported: 收到完成回報
  reported --> completed: 管理者確認紀錄
  reported --> in_progress: 退回補做／補資料
  draft --> cancelled
  scheduled --> cancelled
  staffing --> cancelled
  ready --> cancelled
  scheduled --> rescheduled: 改期
  staffing --> rescheduled
  ready --> rescheduled
  rescheduled --> scheduled: 新時間確定（已安排人員回到「待重新確認」）
  completed --> [*]
  cancelled --> [*]
```

規則：

- 改期或取消時，系統列出受影響的人員、資材、機具、運輸，**由管理者決定**是否通知；不自動通知、不自動取消。
- `staffing → ready` 的條件是「已答應」人數，不是「已聯繫」人數。

### 3.2 人員安排（ASSIGNMENT）

```mermaid
stateDiagram-v2
  [*] --> not_contacted: 排入工作
  not_contacted --> awaiting_reply: 已聯繫（記錄方式與時間）
  awaiting_reply --> accepted: 本人答應
  awaiting_reply --> declined: 無法出席
  not_contacted --> accepted: 本人直接答應（記錄來源）
  accepted --> declined: 本人改口
  accepted --> cancelled: 管理者取消安排
  awaiting_reply --> cancelled
  not_contacted --> cancelled
  accepted --> needs_reconfirm: 工作改期
  needs_reconfirm --> awaiting_reply: 已再次聯繫
  accepted --> arrived: 到場
  arrived --> finished: 完成（產生出勤紀錄）
  arrived --> left_early: 提早離開
  declined --> [*]
  cancelled --> [*]
  finished --> [*]
  left_early --> [*]
```

規則：

- 「打過電話」只能到 `awaiting_reply`。
- 排入行事曆不改變此狀態；通知是否送出另記於 `assignment_event`。
- `wage_rate_snapshot` 在 `accepted` 時寫入，之後的預設工資變更不影響本次。

### 3.3 農務紀錄確認（WORK_REPORT → WORK_RECORD）

```mermaid
stateDiagram-v2
  [*] --> draft: 本機草稿
  draft --> submitted: 送出回報
  submitted --> under_review: 管理者開啟
  under_review --> needs_info: 要求補資料（例：一包半是幾公斤）
  needs_info --> submitted: 補件
  under_review --> confirmed: 確認 → 建立 WORK_RECORD
  under_review --> rejected: 退回（保留原文與原因）
  confirmed --> amended: 修正（寫 RECORD_REVISION）
  amended --> confirmed: 修正後確認
  confirmed --> voided: 作廢（保留紀錄與原因）
  rejected --> [*]
  voided --> [*]
```

施藥狀態（`work_record.pesticide_status` 及田區期作層級彙總）：

| 值 | 意義 | 產生方式 |
| --- | --- | --- |
| `applied` | 已施用 | 有已確認的施用紀錄 |
| `confirmed_none` | 已確認未施用 | 管理者對指定期間明確聲明，記錄聲明人與時間 |
| `unknown` | 尚未確認 | 預設值；沒有紀錄時一律是此狀態 |
| `incomplete` | 紀錄不完整 | 有施用但缺產品、數量、日期等必要欄位 |

彙總規則：期間內任何一筆 `applied` → applied；沒有紀錄 → `unknown`（**絕不推論為未施用**）。

### 3.4 上傳與巡田品質

單一檔案上傳（M1）：

```mermaid
stateDiagram-v2
  [*] --> local_saved: 本機已保存
  local_saved --> uploading
  uploading --> local_saved: 中斷（自動重試，有上限與退避）
  uploading --> server_received: complete 驗證通過
  uploading --> failed: 驗證失敗（大小／類型／雜湊）
  server_received --> processed: 縮圖與 metadata 完成
  server_received --> processing_failed: 處理失敗（原檔仍可用）
  processed --> [*]
```

巡田採集工作階段（階段 4；狀態名稱先定）：

```mermaid
stateDiagram-v2
  [*] --> local_saved: 1 本機已保存
  local_saved --> server_received: 2 伺服器已接收（分塊）
  server_received --> validating: 3 驗證中
  validating --> reshoot_required: 4 需要補拍
  reshoot_required --> validating: 補拍上傳
  validating --> capture_passed: 5 採集通過
  validating --> unverified_offline: 網路不足，尚未驗證
  unverified_offline --> validating: 恢復連線
  capture_passed --> processing: 6 成果處理中
  processing --> ready: 7 成果可用
  processing --> partial: 8 部分完成
  processing --> failed: 9 失敗／中斷
  validating --> failed
  partial --> processing: 補件後重算
```

- `server_received` ≠ `capture_passed` ≠ `ready`，UI 用不同文字與圖示呈現。
- `unverified_offline` 明確顯示「尚未驗證」，不顯示通過。
- 補拍任務欄位：原因、位置／區段、缺少內容、建議朝向、優先級、可接受條件、關閉條件；離場前彙整一次，避免每偵測一次就要求折返。
- 遮擋處理決策：保留／替代影格／裁切／補拍／待確認；以「被遮住的內容是否必要」判斷，不只看人物面積。隱私模糊與幾何排除分開；禁止生成式補圖。
