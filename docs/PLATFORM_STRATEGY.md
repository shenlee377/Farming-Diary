# 農田日記 — Android App 與 Chrome 網頁分開最佳化（PLATFORM_STRATEGY）

> 狀態：提議（D-011）。尚未實作；瀏覽器 API 支援度需在開工時依當期 Chrome 版本再確認。
> 最後更新：2026-10-30

兩個平台共用同一個後端 API、同一套權限（後端強制），但**不追求同一個畫面兩邊一模一樣**。依各自強項分工，各自最佳化。

## 1. 分工

| | Android App（Flutter 原生） | Chrome 網頁 |
| --- | --- | --- |
| 定位 | **田間採集**：人在田裡、可能沒網路、要用相機與感測器 | **不用安裝就能用**＋**大螢幕管理** |
| 主要使用者 | owner、管理者、常下田的家人 | 坐在電腦前整理資料的人（記帳、家人）；不想裝 App 的人；只拿到連結的外部對象 |
| 核心功能 | 巡田採集與補拍、拍照回報、離線草稿與上傳佇列、工作提醒 | 田區邊界與地號編輯、報表與匯出、成本與工資整理、確認回報、分享連結檢視 |
| 不做 | 複雜報表編輯 | 巡田 3D／AR 採集（只提供簡易拍照回報） |

理由：巡田品質靠穩定的相機控制、即時畫面分析、背景上傳與大量離線儲存，網頁在這幾點都有天花板；反過來，畫田界、看報表、打字整理，電腦大螢幕加鍵盤滑鼠遠比手機有效率。

## 2. Android App 最佳化

| 項目 | 做法 |
| --- | --- |
| 相機 | Flutter `camera`（底層 CameraX）；巡田時鎖定曝光與白平衡避免連拍閃爍。等級一裝置經原生模組（Kotlin）接 ARCore Depth |
| 即時品質提示 | 用影像串流（`startImageStream`）在手機端算模糊分數，取景畫面即時顯示「畫面晃動」；不必拍完才知道 |
| 方位 | Android 旋轉向量感測器（rotation vector），比單純磁力計穩定；不需權限 |
| 定位 | Fused Location Provider，高精度模式只在巡田畫面開啟期間使用，離開即停，省電 |
| 螢幕常亮 | 巡田畫面開啟期間保持螢幕不熄（wakelock），離開即釋放 |
| 離線 | SQLite（Drift）＋ App 私有目錄存照片，不會被系統當快取清掉 |
| 上傳 | WorkManager：分塊續傳、可設「只在 Wi-Fi 上傳大檔」，App 關掉後仍會完成 |
| 字級 | `MediaQuery.textScaler` 直接讀 Android「字型大小」（含 Android 14 起的非線性放大到 200%）；規則見 DESIGN_SYSTEM §5 |
| 低階手機 | 裝置能力自動分級（Tier 1～3）；AAB 依裝置拆分下載，控制安裝大小 |
| 觸覺回饋 | 拍到一張就震動，戶外看不清螢幕也知道 |
| 權限 | 見 SECURITY_AND_DATA §7：用到才問、只在前景、不申請背景定位與儲存空間 |
| 發布 | Google Play（AAB）＋ GitHub 提供 APK |

## 3. Chrome 網頁最佳化

### 3.1 電腦版 Chrome（主要場景）

| 項目 | 做法 |
| --- | --- |
| 版面 | 寬螢幕多欄：左側田區清單、中間地圖、右側詳情；表格可排序篩選 |
| 田界編輯 | 地圖上用滑鼠拖拉邊界點、對照地號；手機版只看不改，避免手指誤觸 |
| 鍵盤操作 | 表單可全程 Tab／Enter 完成；常用操作提供快捷鍵 |
| 匯出 | 報表直接下載（CSV／PDF）；大批照片匯出由後端打包後提供下載連結 |
| 字級 | 全用 rem，跟隨 Chrome 的字型大小設定與頁面縮放；不在 `html` 寫死 px |

### 3.2 手機版 Chrome（輕量入口）

| 項目 | 做法 |
| --- | --- |
| 安裝 | 提供 PWA（manifest＋Service Worker），可「加到主畫面」；不強迫安裝 Android App |
| 拍照回報 | `<input type="file" accept="image/*" capture="environment">` 直接開系統相機，最穩定、相容性最好；不做巡田連拍 |
| 定位 | Geolocation API，只在填回報時取一次；網頁無法背景定位，也不需要 |
| 離線 | Service Worker 快取畫面；草稿與待傳照片存 IndexedDB，並呼叫 `navigator.storage.persist()` 降低被瀏覽器清除的機會。介面須提醒「網頁版離線草稿可能被清除，重要紀錄請連網送出或用 App」 |
| 上傳 | 頁面開著時上傳；Chrome 支援 Background Sync 時，關頁後於恢復網路時補送一次 |
| 通知 | Web Push（使用者在設定中開啟提醒時才要求） |
| 字級 | rem＋`<meta name="text-scale" content="scale">`，在支援的 Chrome 版本讓網頁跟隨 Android 系統字級 |
| 分享連結 | 限時、限範圍的分享連結直接在 Chrome 開啟檢視，對方不需要帳號或 App（見 SECURITY_AND_DATA §6） |

### 3.3 網頁不做的事與原因

- **巡田連拍與補拍引導**：網頁相機（`getUserMedia`）無法穩定鎖曝光、取得完整相機內參，背景上傳也受限；巡田品質要求只交給 App。
- **AR 田界投影**：Chrome 有 WebXR，但深度與追蹤能力與裝置差異大，不列入網頁版。
- 網頁偵測到使用者要做這些功能時，顯示「請使用 Android App」與下載連結，而不是做一個打折的版本。

## 4. 兩平台共用的部分

- 後端 API、權限、稽核、同步協定（ARCHITECTURE §7）完全共用；網頁是線上為主的客戶端，離線能力只到「草稿」層級。
- 狀態標籤、用詞、色彩 token、字級 token 共用（DESIGN_SYSTEM）；排版依平台各自設計。
- 登入：網頁也走咖啡廳 OAuth，但需要**另一個 OAuth client**（網頁 redirect URI 與 App 不同）；D-005 的「共用 client」只涵蓋 Android／iOS，需另行確認 pairwise sub 跨 client 是否一致（AUTH_INTEGRATION）。

## 5. 待決定

| 問題 | 選項 | 建議 |
| --- | --- | --- |
| 網頁用什麼技術 | (a) Flutter Web，與 App 共用程式碼；(b) 另寫 React／TypeScript 網頁 | 先以 (a) 試做一個管理畫面，檢查電腦版排版、文字選取、瀏覽器字級跟隨與首次載入時間；不符合再改 (b) |
| 網頁版何時開始 | 與 M1 同時／M1 之後 | M1 之後。M1 先把 Android 田間流程做穩；網頁從「確認回報＋報表」開始 |
| 手機版 Chrome 要做到多完整 | 只看＋簡易回報／接近 App | 只看＋簡易回報，田間主力交給 App |
