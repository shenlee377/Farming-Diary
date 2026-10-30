# 農田日記 — 決策紀錄（DECISIONS）

狀態：`提議` → `已確認` → `已取代`。變更決策時新增一筆並把舊的標為已取代，不直接改寫。

| ID | 日期 | 決策 | 狀態 | 理由／備註 |
| --- | --- | --- | --- | --- |
| D-001 | 2026-10-20 | 正式產品平台為 Flutter（Android + iOS 同步）；AI Studio React 頁面只是輔助設計原型 | 已確認（需求明訂） | 不為預覽工具改平台 |
| D-002 | 2026-10-20 | 唯一正式資料來源：Cloud SQL for PostgreSQL + PostGIS | 已確認（2026-10-20） | ARCHITECTURE §2 |
| D-003 | 2026-10-20 | 後端為 FastAPI 模組化單體，放獨立私有 repo（暫名 `farming-diary-backend`）；公開 repo 不含後端 | 已確認（2026-10-20） | 公開 repo 的 `backend/` 已刪除；私有 repo 尚未建立，於 M1-A 建立並重寫，不沿用舊範例 |
| D-004 | 2026-10-20 | 身分：咖啡廳 OAuth（account.read），由農田日記後端兌換 code，自簽不透明 session；不用 Firebase Auth | 提議 | AUTH_INTEGRATION §6 |
| D-005 | 2026-10-20 | Android／iOS 共用一個 OAuth client（暫名 `farming-diary`） | 提議 | pairwise sub 跨平台一致 |
| D-006 | 2026-10-20 | 工作派送用 Cloud Tasks；長工作用 Cloud Run Jobs 或其他 GPU 環境；狀態回饋 = 查詢 + SSE | 提議 | ARCHITECTURE §5 |
| D-007 | 2026-10-20 | 品牌方向 A「田埂手帳」+ 戶外高對比介面規則 | 提議 | DESIGN_SYSTEM |
| D-008 | 2026-10-20 | 識別碼 | 提議（待你決定） | 見下方候選 |
| D-009 | 2026-10-20 | 公開 repo 授權條款：Apache-2.0 | 已確認（2026-10-20） | 根目錄 `LICENSE` 為 apache.org 官方原文。只涵蓋本公開 repo，不涵蓋私有後端 |
| D-010 | 2026-10-20 | 現有 AI Studio 原型搬到 `prototype/web-mockup/` 並移除未驗證的完成宣稱；公開 repo 的 `backend/` 刪除 | 已確認並執行（2026-10-20） | 舊 `backend/` 仍存在於 Git 歷史（commit `9dde1fe` 以前），經檢查沒有真實秘密 |
| D-011 | 2026-10-30 | 平台：先做 Flutter Android／iOS App；Chrome 網頁暫緩（分工規劃保留於 PLATFORM_STRATEGY） | 已確認（2026-10-30） | 主力在田間，長輩不會開網頁下田 |
| D-012 | 2026-10-30 | 權限不以 Google Play 審查為限制（Android 另有 APK）；記錄田界可於螢幕關閉時續錄 | 已確認（2026-10-30） | SECURITY_AND_DATA §7 |
| D-013 | 2026-10-30 | M1 App 先以「本機優先」可獨立使用：資料存手機 SQLite，所有寫入進 outbox；後端完成後再接同步。登入先用本機 dev 身分 | 提議 | 後端（D-003）與咖啡廳 OAuth（V1）尚未就緒 |
| D-014 | 2026-10-30 | 暫用 applicationId／Bundle ID `io.github.shenlee377.farmingdiary`（GitHub 帳號擁有的命名空間），正式發布前可依 D-008 更換 | 提議 | 不可使用不屬於你的網域 |

## D-008 識別碼候選（未查證可用性與商標）

| 項目 | 候選 | 備註 |
| --- | --- | --- |
| 英文名稱 | Farming Diary／Field Diary／TianRi（田日） | 與 repo 名稱一致者為 Farming Diary |
| GitHub repo | `Farming-Diary`（現有，公開）、`farming-diary-backend`（私有，待建） | |
| Android applicationId | `<你擁有的網域反寫>.farmingdiary` | 一經發布不可更改；不可使用不屬於你的網域 |
| iOS Bundle ID | 同上 | 需在 Apple Developer 帳號註冊 |
| OAuth client_id | `farming-diary` | 咖啡廳註冊表內唯一即可 |
| Callback | `<applicationId>://oauth/callback`；有網域後改 https App Links／Universal Links | |

以上皆為候選，**未註冊、未確認可用，也不代表屬於你**。

## 現有儲存庫內容稽核（2026-10-20，commit 4765c59；處理結果見 D-010）

| 項目 | 現況 | 問題 | 處理建議 |
| --- | --- | --- | --- |
| `src/`、`index.html`、`package.json` | Google AI Studio 產生的 React／Vite 原型，10 個以上頁籤 | 介面寫有「PROJECT COMPLETED 100%」「Unit Tested (100% Pass)」「14/14 項合格」等**未經驗證的完成宣稱**；預設開啟頁籤為「階段 9 完成」 | 搬到 `prototype/web-mockup/`，加上「輔助設計原型，非正式產品」聲明；移除完成宣稱 |
| `backend/` | FastAPI 範例程式 | 1) 放在公開 repo，違反「後端不公開」；2) 認證為寫死的假 token（如 `token_user_lin_01`），且未限制只在開發環境；3) 授權成員表寫死在程式；4) 設定檔中的 `https://api.coffeeshop.tw/oauth/verify` 不存在於咖啡廳程式碼；5) `ai_assistant.py`、`disasters.py`、`harvest.py` 為空檔，但 `main.py` 仍匯入其 `router`，啟動時會失敗（依程式碼推斷，未執行） | 不沿用；M1-A 在私有 repo 重建。經檢查未發現真實秘密 |
| `docs/ARCHITECTURE_PHASE_0.md` | 第一版摘要 | 成本數字未附來源；「Cloud SQL 開發環境 scale-to-zero」不正確 | 標示為已被新文件取代 |
| `.aistudio/artifacts/` | 29 張 AI Studio 截圖 | 非必要，增加 repo 大小 | 可移除（不影響功能） |
| `.env.example` | `GEMINI_API_KEY` 佔位 | 屬原型用途 | 隨原型搬移 |
