# 農田日記（Farming Diary，英文名稱暫定）

給臺灣家庭農場與小型農業經營者的協作 App：田區、土地關係、期作、農事、人員、資材、成本、採收與行政紀錄整合在一起，重要事實可追溯，缺少的資訊明確標示。

## 目前狀態（2026-10-20）

| 項目 | 狀態 |
| --- | --- |
| 架構與計畫（階段 0） | 文件草案完成；資料庫、repo 分割、授權條款已確認（見 [DECISIONS.md](docs/DECISIONS.md)） |
| 正式 Flutter App（Android／iOS） | **尚未開始** |
| 私有後端 | **尚未開始**（獨立私有 repo，不在本 repo） |
| 咖啡廳 OAuth 串接 | **未串接**；已完成程式碼分析 |
| 建置、測試、部署、上架 | **皆未進行** |

[`prototype/web-mockup/`](prototype/web-mockup/README.md) 是 Google AI Studio 產生的**輔助設計原型**，不是正式產品，頁面內容皆為未經驗證的示範資料。

## 文件

| 文件 | 內容 |
| --- | --- |
| [PROJECT_BRIEF](docs/PROJECT_BRIEF.md) | 產品理解、使用者流程、已確定／假設／待驗證、澄清問題、MVP 界線 |
| [ARCHITECTURE](docs/ARCHITECTURE.md) | 資料庫比較與推薦、系統架構圖、前後端邊界、工作排程、上傳、離線同步、地圖 |
| [DOMAIN_MODEL](docs/DOMAIN_MODEL.md) | ER 圖、四組狀態機 |
| [AUTH_INTEGRATION](docs/AUTH_INTEGRATION.md) | 咖啡廳 OAuth 分支核對結果與整合設計 |
| [SECURITY_AND_DATA](docs/SECURITY_AND_DATA.md) | 權限、雲端安全、資料生命週期、備份、刪除 |
| [COST_MODEL](docs/COST_MODEL.md) | 成本來源、用量假設、上限策略 |
| [PLATFORM_STRATEGY](docs/PLATFORM_STRATEGY.md) | Android App 與 Chrome 網頁的分工與各自最佳化 |
| [DESIGN_SYSTEM](docs/DESIGN_SYSTEM.md) | 品牌方向、暫定圖示、色彩與字級、元件規則 |
| [ROADMAP](docs/ROADMAP.md) | 里程碑、檔案結構草案、第一個端到端驗收情境 |
| [DECISIONS](docs/DECISIONS.md) | 決策紀錄、識別碼候選、現有 repo 稽核 |

## 授權

本 repo 以 [Apache License 2.0](LICENSE) 授權。私有後端不在此授權範圍內。
