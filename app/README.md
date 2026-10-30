# 農田日記 App（Flutter，Android／iOS）

M1 本機版：資料存在手機（SQLite），可獨立使用；雲端同步與正式帳號登入要等私有後端與咖啡廳 OAuth 完成後再接（DECISIONS D-013）。

## 已完成的功能

| 區塊 | 內容 |
| --- | --- |
| 開始使用 | 填稱呼與農場名稱即可；建立本機身分與工作空間（擁有者）。可建立多個農場並切換 |
| 首頁 | 今天要做（工作卡＋「我做完了」）、需要補資料、等我確認、我的田、手機內待上傳筆數 |
| 田區 | 新增／修改／封存；面積可自填（分、平方公尺、公頃）；沿田邊走一圈（或只走四個角）記錄田界 → 草稿 → 確認後更新面積並保留舊版本；螢幕關閉也可續錄（前景服務＋通知） |
| 地號與土地關係 | 地號與田區多對多；土地關係（所有／共有／承租／代耕／使用）、持分、期間、租金；一律標示「本人填寫，未經查證」 |
| 期作 | 新增；計畫中 → 種植中 → 休耕／已結束，自動記錄實際開始與結束日 |
| 工作與人員 | 新增工作（田區、類型、時間、需要人數、集合時間地點）；安排聯絡人；記錄聯絡方式與回覆；只計算「已答應」人數，人手滿了自動變「人手已齊」，有人改口自動回到「找人中」；改期時已答應者變「需再確認」，不自動通知 |
| 聯絡人 | 臨時工、帶班者，不需要 App 帳號；一鍵撥號 |
| 回報 | 長輩最短路徑：拍照或選照片（系統照片選擇器，不需相簿權限）→ 送出；資材保留原話（例：一包半）；施藥自述有／沒有／不確定 |
| 確認與紀錄 | 確認成正式紀錄／要求補資料／退回；資材原話存為「待補規格」，之後填名稱、數量、單位與換算依據；修正與作廢都寫修改歷程；田區施藥狀態彙總（沒有紀錄＝尚未確認，絕不推論為未施用） |
| 巡田相機 | 品質提示、補拍引導、離場前查核都在取景畫面內：預覽影像即時模糊／太暗偵測；邊走邊自動拍（只存清晰照片）；原生羅盤方位；結束時找出「某方向都沒有清晰照片」列為補拍，畫面內顯示往左／往右轉幾度，對準才可拍 |
| 備份 | 匯出全部資料（JSON），可選擇連同照片一起分享 |
| 字級 | 只用主題字級、不寫死字級；跟隨系統字型大小（Android）／動態字級（iOS）；畫面在 200% 下以換行處理（有 widget 測試） |

## 尚未完成（誠實清單）

- **雲端同步與上傳**：所有寫入都記在 outbox、照片標「已存在手機」，但還沒有伺服器可送（私有後端未開始）。
- **正式登入**：咖啡廳 OAuth 未串接，目前是本機身分；角色只有擁有者，成員邀請與權限要等後端。
- **地圖底圖**：田界只畫形狀，沒有衛星／地圖底圖（地圖服務與費用待定，PROJECT_BRIEF A4）。
- **巡田雲端檢查**：人物遮擋判斷、覆蓋率、三維重建在雲端（M4 之後）；手機端只做模糊與亮度快篩。模糊門檻 `defaultBlurThreshold` 需用實機田間照片校正。
- **語音回報**：目前靠鍵盤的語音輸入；錄音檔回報未做。
- **種植區（planting）、資材庫存、工資、成本、通知**：屬 M2 以後。
- **正式簽署**：Android release 目前用 debug 金鑰簽署；iOS 尚未簽署、未上 TestFlight。

## 識別碼

`io.github.shenlee377.farmingdiary`（Android applicationId 與 iOS Bundle ID，暫用，見 DECISIONS D-014）。

## 開發

需要 Flutter（CI 使用 3.47.9 stable）。

```bash
cd app
flutter pub get
flutter run
```

修改 `lib/core/db/database.dart` 後重新產生資料庫程式碼：

```bash
dart run build_runner build --delete-conflicting-outputs
```

檢查（與 CI 相同）：

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

CI（`.github/workflows/app.yml`）另外會建置 Android APK（可在 Actions 頁面下載）並在 macOS 上以 `--no-codesign` 編譯 iOS。

## 結構

```
lib/
├── main.dart                 開啟資料庫、注入相依
├── app/                      主題（DESIGN_SYSTEM token）、providers、共用元件
├── core/
│   ├── db/database.dart      Drift 資料表（對應 DOMAIN_MODEL）＋ outbox
│   ├── repository.dart       所有讀寫；交易＋outbox；狀態轉移經狀態機驗證
│   └── location.dart         定位權限與連續定位（含螢幕關閉續錄）
├── domain/                   狀態機、面積與方位、模糊快篩、中文標籤（純 Dart，有單元測試）
└── features/                 各畫面
android/…/MainActivity.kt     方位感測（旋轉向量）EventChannel
ios/Runner/AppDelegate.swift  方位感測（CLLocationManager）EventChannel
```
