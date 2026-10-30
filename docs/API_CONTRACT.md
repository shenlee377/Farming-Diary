# 農田日記 — App 與後端 API 契約 v1（API_CONTRACT）

> 狀態：草案 v1（2026-10-30）。App 端同步客戶端已依本文件實作並以假伺服器測試；後端（私有 repo）尚未實作。
> 修改本文件時，App 的 `lib/core/sync/` 與後端須一起更新；不相容的修改升版為 `/v2`。

## 1. 共通

- Base URL：`https://<api-host>/v1`（App 在「更多 › 雲端同步」設定；正式版寫死於建置設定）。
- 編碼：JSON（UTF-8）。外層欄位用 `snake_case`；`payload` 內容就是 App 資料表的 JSON（`camelCase`，時間為 UTC epoch 毫秒），金額、數量用十進位字串。
- 認證：`Authorization: Bearer <access_token>`（§2 取得）。
- 錯誤：HTTP 狀態碼＋`{"error_code": "...", "message": "..."}`。

| 狀態 | `error_code` 例 | App 行為 |
| --- | --- | --- |
| 400 | `invalid_payload` | 該筆標為失敗，保留在手機，顯示原因 |
| 401 | `token_expired` | 用 refresh token 換新一次後重試；仍失敗 → 請使用者重新登入 |
| 403 | `membership_revoked` | 鎖定該工作空間（ARCHITECTURE §7.2），未上傳的資料保留供匯出 |
| 409 | `version_conflict` | 見 §3 |
| 413／415 | `too_large`／`unsupported_type` | 上傳標為失敗 |
| 429／5xx | — | 退避後重試（1、2、4…最長 5 分鐘） |

## 2. 認證

### 2.1 開發身分（只在 local／staging 註冊路由；production 不存在）

`POST /auth/dev/login`

```json
{ "display_name": "阿明", "device_label": "Pixel 8", "local_user_id": "0192…" }
```

回應：

```json
{ "user_id": "0192…", "access_token": "…", "refresh_token": "…", "expires_in": 900 }
```

- `local_user_id`：App 本機身分 ID。開發身分下，若此 ID 尚未被其他人使用，後端直接採用為 `user_id`，讓本機已建立資料的 `created_by` 不需改寫。

### 2.2 咖啡廳帳號（AUTH_INTEGRATION §6）

`POST /auth/cafe/exchange` `{code, code_verifier, redirect_uri, device_label, local_user_id}` → 同上回應格式。
若 `user_id` 與 `local_user_id` 不同，後端記錄別名（`local_user_id → user_id`），處理 push 時把 `created_by`／`updated_by`／`confirmed_by` 等改寫為正式 `user_id`。

### 2.3 換發

`POST /auth/refresh` `{refresh_token}` → 新的 `access_token`、`refresh_token`（輪替；舊 refresh 重播 → 該裝置 session 失效）。

## 3. 推送變更

`POST /sync/push`（每批最多 200 筆，依 outbox 順序）

```json
{
  "commands": [
    {
      "command_id": "outbox-<裝置>-<seq>",
      "workspace_id": "0192…",
      "entity": "task",
      "entity_id": "0192…",
      "op": "upsert",
      "payload": { "id": "0192…", "status": "staffing", "version": 3, "...": "..." }
    }
  ]
}
```

回應（與 `commands` 一一對應）：

```json
{
  "results": [
    { "command_id": "…", "status": "applied", "server_version": 3 },
    { "command_id": "…", "status": "duplicate" },
    { "command_id": "…", "status": "conflict", "current": { "...": "伺服器目前內容" } },
    { "command_id": "…", "status": "rejected", "error_code": "illegal_transition", "message": "…" }
  ]
}
```

- `command_id` 是冪等鍵：重送已處理過的命令回 `duplicate`，不重複寫入。
- `op`：`upsert`、`archive`、`delete`（只用於草稿與連結，例如田界草稿、田區與地號連結）、`delete_draft`。
- 衝突（ARCHITECTURE §7.2）：回報、照片、語音、巡田影格、聯絡紀錄**只新增**，不會衝突；狀態轉移由後端以狀態機重新驗證，不合法回 `rejected`＋目前狀態；描述性欄位版本不符回 `conflict`＋伺服器內容，由使用者選擇。
- `entity` 名稱：`workspace`、`field`、`field_boundary_version`、`land_parcel`、`field_parcel`、`land_relation`、`crop_season`、`contact`、`task`、`assignment`、`assignment_event`、`work_report`、`work_record`、`work_record_input`、`record_revision`、`media_asset`、`inspection_session`、`inspection_frame`、`reshoot_task`。payload 欄位與 App 資料表相同（見 `app/lib/core/db/database.dart`）。

## 4. 拉取變更

`GET /sync/changes?cursor=<不透明字串>&limit=500`

```json
{
  "changes": [
    { "entity": "task", "entity_id": "…", "workspace_id": "…", "op": "upsert", "version": 4, "payload": { "...": "..." } }
  ],
  "next_cursor": "…",
  "has_more": false,
  "revoked_workspaces": []
}
```

- 只回傳使用者有權看到的資料；敏感欄位依角色由後端過濾（PROJECT_BRIEF §2）。
- App 套用規則：本機同 ID 資料的 `version` 較新（還沒推送的修改）時略過；否則覆寫。拉取的資料不再進 outbox。
- `revoked_workspaces`：App 清除該工作空間的本機快取，保留自己未上傳的草稿供匯出。

## 5. 照片與語音上傳（ARCHITECTURE §6）

1. `POST /uploads`

```json
{ "client_upload_id": "…", "workspace_id": "…", "media_asset_id": "…", "sha256": "…", "size_bytes": 123456, "mime": "image/jpeg" }
```

回應：`{"upload_id": "…", "status": "pending", "upload_url": "https://…", "upload_headers": {"Content-Type": "image/jpeg"}}`；
同一 `client_upload_id` 已收過時回 `{"upload_id": "…", "status": "server_received"}`，App 直接標為已上傳。

2. `PUT <upload_url>`（限時 Signed URL，帶 `upload_headers`，本文為檔案原始位元組）。
3. `POST /uploads/{upload_id}/complete` → `{"status": "server_received"}`；後端驗證大小、類型、雜湊後建立媒體紀錄並派送縮圖工作。

讀取照片：`GET /media/{media_asset_id}/url` → `{"url": "…", "expires_in": 600}`（限時，依權限簽發）。

## 6. App 端行為摘要

- 同步時機：開啟 App、回到前景、每 5 分鐘（App 開著時）、使用者按「立即同步」。
- 順序：推送 outbox → 上傳媒體 → 拉取變更。
- outbox 狀態：`pending` → `sent`；`conflict`、`rejected`、`failed` 保留在手機並顯示筆數與原因。
- 權杖存在系統安全儲存（Android Keystore／iOS Keychain），不存在 SQLite、不進備份檔。
