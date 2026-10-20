# 農田日記 — 里程碑與第一個端到端版本（ROADMAP）

> 狀態：計畫。等待確認後才開始 M1。
> 最後更新：2026-10-20

## 1. 里程碑總覽

| 里程碑 | 內容 | 驗收（摘要） | 依賴 |
| --- | --- | --- | --- |
| **M0 決策** | 本輪文件；回答澄清問題；決定 DB、ID、repo 分割 | DECISIONS.md 中 D-001～D-009 狀態為「已確認」 | — |
| **M1-A 後端骨架** | 私有 repo、FastAPI 分層、PostGIS migration、dev 身分、workspace／membership、authz、稽核 | `pytest` 通過；跨工作空間存取回 404；production 設定下 dev 路由不存在 | M0 |
| **M1-B 田區與期作** | 田區、邊界版本（GeoJSON）、地號多對多、土地關係、作物、期作、種植區 | 面積由 PostGIS 計算並標示方法；新增期作不影響舊紀錄 | M1-A |
| **M1-C 人員與工作** | 聯絡人（無帳號）、工作、人員安排與事件、回報、確認成正式紀錄、修改歷程 | 狀態機非法轉移被拒；「已聯繫」不計入已答應人數 | M1-B |
| **M1-D 照片上傳** | 上傳工作階段、Signed URL、complete 驗證、縮圖 worker、限時讀取 | 重送同一 `client_upload_id` 不產生重複；他人無法取得讀取 URL | M1-A |
| **M1-E Flutter App** | 登入（dev／cafe 切換）、工作空間、田區、期作、聯絡人、工作、回報、拍照上傳、本機草稿與 outbox | 在 Android 模擬器與至少一支實機跑完 §4 情境 | M1-B～D |
| **M1-F 正式 OAuth（staging）** | 後端 code 兌換、上游 refresh、撤銷傳遞；咖啡廳註冊 client（需你確認） | 在 staging 以真實咖啡廳帳號登入；撤銷後 15 分鐘內 App 被登出 | 咖啡廳部署（V1、V2） |
| **M1-G 部署** | staging Cloud Run + Cloud SQL + GCS；CI；APK 簽署；TestFlight 內測 | 部署腳本可重複執行；可回滾到前一版 | M1-A～E |
| M2 日常使用 | 行事曆、資材／庫存帳、施用、出勤工資、成本、通知、離線完善 | 另訂 | M1 |
| M3 閉環與 AI | 採收、出貨、結算、AI 草案與確認、異常、行政／災害／保險 | 另訂 | M2 |
| M4 巡田品質 | 能力分級、分塊上傳、雲端檢查、補拍 | 另訂 | M1-D |
| M5 研究 | 三維、地理對齊、DJI | 另訂 | M4 |

M1-F 若咖啡廳 OAuth 尚未部署，M1 仍可用 dev 身分完成驗收，但驗收報告必須寫明「正式 OAuth 未串接」。

## 2. 公開 repo 檔案結構草案（Farming-Diary）

```
Farming-Diary/
├── README.md
├── LICENSE                         # Apache-2.0（D-009）
├── docs/                           # 本輪文件
├── design/brand/                   # 向量來源
├── app/                            # Flutter App（M1-E 建立）
│   ├── pubspec.yaml
│   ├── android/                    # applicationId 待 D-008
│   ├── ios/                        # Bundle ID 待 D-008
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app/                    # 路由、主題（DESIGN_SYSTEM tokens）、環境設定
│   │   ├── core/
│   │   │   ├── api/                # 由 OpenAPI 產生的 client + 錯誤處理
│   │   │   ├── auth/               # 系統瀏覽器授權、安全儲存、session refresh
│   │   │   ├── db/                 # 本機 SQLite schema
│   │   │   ├── sync/               # outbox、拉取 cursor、衝突
│   │   │   └── upload/             # 上傳佇列
│   │   ├── features/
│   │   │   ├── home/               # 我的田／今天要做／等我確認
│   │   │   ├── workspace/
│   │   │   ├── fields/
│   │   │   ├── seasons/
│   │   │   ├── contacts/
│   │   │   ├── tasks/
│   │   │   └── reports/
│   │   └── l10n/                   # zh_Hant_TW 為主
│   ├── test/                       # 單元、widget 測試
│   └── integration_test/           # 端到端（對 local 後端）
├── config/
│   └── app_config.example.json     # API base URL、client_id、redirect（無秘密）
├── prototype/web-mockup/           # 現有 AI Studio React 原型（搬移後，僅供參考）
└── .github/workflows/              # Flutter analyze、test、APK build（不含簽署金鑰）
```

## 3. 私有後端 repo 檔案結構草案（暫名 farming-diary-backend）

```
farming-diary-backend/
├── pyproject.toml                  # 鎖定依賴版本
├── Dockerfile
├── docker-compose.yml              # local：postgis + api + worker
├── alembic.ini
├── migrations/versions/
├── src/farm/
│   ├── main.py                     # FastAPI app 工廠；依環境註冊路由
│   ├── settings.py                 # 啟動時驗證環境與危險組合
│   ├── api/v1/                     # auth, workspaces, fields, seasons, contacts, tasks, reports, uploads, sync
│   ├── auth/                       # session、cafe adapter、dev 身分
│   ├── authz/                      # 政策
│   ├── domain/                     # 實體、狀態機
│   ├── services/
│   ├── repo/
│   ├── adapters/                   # gcs, tasks, cafe_oauth
│   └── jobs/                       # thumbnail 等
├── openapi/                        # 匯出的契約（供 App 產生 client）
├── tests/
│   ├── unit/
│   ├── api/                        # 含跨工作空間、被移除成員
│   └── e2e/                        # §4 情境
├── deploy/                         # Cloud Run、IAM、bucket 設定（腳本或 Terraform）
└── docs/OPERATIONS.md
```

## 4. 第一個端到端驗收情境

前置：local 環境（Docker PostGIS + API + worker + 模擬 GCS 或 staging bucket），Flutter App 連 local／staging。

| 步驟 | 操作 | 預期結果 | 驗證方式 |
| --- | --- | --- | --- |
| 1 | 使用者 A 登入（dev 身分；M1-F 後改為咖啡廳 staging） | 建立內部 `user_id` 與 `external_identity`；App 顯示身分類型 | API 測試 + App 畫面 |
| 2 | 建立工作空間「林家田」 | A 為 owner | `GET /workspaces` |
| 3 | 建立田區「北田」：畫多邊形、連地號 2 筆、土地關係「承租」（自填，未查證） | 面積由伺服器計算並顯示方法；土地關係顯示「本人填寫，未經查證」 | API + 畫面 |
| 4 | 建立期作「2026 秋作」與一個種植區 | 期作狀態 planned | API |
| 5 | 新增聯絡人「阿吉叔」（只有姓名、電話，沒有帳號） | 聯絡人建立，`linked_user_id` 為空 | API |
| 6 | 建立工作「北田除草」，需 2 人，安排阿吉叔 | 工作 `staffing`；阿吉叔 `not_contacted`；已答應 0／2 | API |
| 7 | 記錄「已打電話」→ 再記錄「答應」 | 依序 `awaiting_reply` → `accepted`；中間狀態不計入已答應 | API 狀態機測試 |
| 8 | A 回報實際作業：時間、原話「用了一包半」、照片 1 張 | 回報 `submitted`；資材數量 `pending_spec`，保留原話 | API + 畫面 |
| 9 | 照片上傳 | 依序顯示「已存在手機」→「已上傳」；重送不重複；縮圖產生 | API + worker 日誌 |
| 10 | A 確認回報 | 建立 `work_record`；施藥狀態為 `unknown`（未填）而非「未施用」 | API |
| 11 | 登出、重新登入 | 所有資料仍在；照片以新的限時 URL 讀取 | App |
| 12 | 使用者 B 登入（另一身分）嘗試讀 A 的工作空間、田區、照片、聯絡人 | 全部 404；直接猜照片物件路徑也無法讀取（bucket 非公開） | API 自動化測試 |

完成條件：步驟 1–12 有自動化測試（後端）與一次手動 App 走查紀錄（含裝置型號與 OS 版本）。未在實機執行的平台在報告中標示「未驗證」。

## 5. 每次交付的報告格式

本次目標／修改檔案／資料變更（migration）／設定與秘密需求／啟動方式／測試方式／驗收步驟／已驗證與未驗證／風險／下一個里程碑。
