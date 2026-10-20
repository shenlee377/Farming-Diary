import React, { useState } from 'react';
import {
  evaluatePesticideSafetyInterval,
  calculateDisasterReliefEligibility,
} from '../domain/state_machines.ts';
import {
  Globe2,
  BookOpen,
  FileCode,
  ShieldCheck,
  CloudSun,
  AlertTriangle,
  CheckCircle2,
  Calendar,
  Sparkles,
  Download,
  Copy,
  Check,
  Users,
  Smartphone,
  Layers,
  ArrowRight,
  Calculator,
  Search,
} from 'lucide-react';

export const Phase8AgriDataAndManual: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'agri_hub' | 'field_manual' | 'spec_center'>('agri_hub');

  // ──────────────────────────────────────────────
  // 1. 臺灣農業公用 API 即時對接狀態
  // ──────────────────────────────────────────────
  // 農藥安全採收期試算
  const [selectedPesticide, setSelectedPesticide] = useState<'CYPERMETHRIN' | 'CHLORFENAPYR' | 'BACILLUS_THURINGIENSIS' | 'ORGANIC_NEEM'>('CYPERMETHRIN');
  const [sprayDate, setSprayDate] = useState('2026-10-12');
  const [targetHarvestDate, setTargetHarvestDate] = useState('2026-10-19');

  const pesticideResult = evaluatePesticideSafetyInterval(
    selectedPesticide,
    sprayDate,
    targetHarvestDate
  );

  // 災害救助資格試算
  const [damagedArea, setDamagedArea] = useState<number>(0.42);
  const [damageRatio, setDamageRatio] = useState<number>(35);
  const disasterResult = calculateDisasterReliefEligibility(
    'LEAFY_VEGETABLE',
    damagedArea,
    damageRatio
  );

  // 規格書複製狀態
  const [copiedSpec, setCopiedSpec] = useState(false);

  const fullSystemSummaryMarkdown = `# 「農田日記」臺灣家庭農場協作系統 - 完整系統規格與領域藍圖

## 一、專案身分與雙平台架構
- **正式中文名稱**：「農田日記」
- **客戶端框架**：Flutter 3.22+ (Android 開源 GitHub / iOS 準備上架 App Store)
- **私有後端**：Python 3.11+, FastAPI, SQLAlchemy 2.0 (PostgreSQL + PostGIS)
- **雲端基礎設施**：Google Cloud Run (asia-east1 臺灣彰濱機房) + Cloud Storage
- **離線資料庫**：Drift (SQLite) 本機快取與非同步雙向同步佇列

## 二、七大階段交付模組
1. **Phase 1 (核心領域與確權)**：臺灣地籍地號多對多關聯、土地關係自填標註、工作空間成員隔離。
2. **Phase 2 (日常協同派工)**：外部電話聯絡人獨立性（通話不等於答應）、資材規格原文扣抵、出勤工資快照。
3. **Phase 3 (採收結算與AI)**：市場運費管理費扣款、應收現金核銷、病蟲害追蹤、AI 五分法防護邊界。
4. **Phase 4 (巡田品質閉環)**：3 級相機契約、Laplacian 模糊快篩、人物遮擋與隱私遮罩、精準補拍任務派發。
5. **Phase 5 (三維重建與AR)**：3DGS / COLMAP 雲端 GPU 實時計費、實景 AR 田界投影、無人機 50Hz SLERP 快門插值、TAP 履歷與農損證明匯出。
6. **Phase 6 (全端實作代碼)**：FastAPI 後端、Flutter 相機 HUD、PostGIS DDL、Cloud Run 生產容器 Dockerfile。
7. **Phase 7 (驗收與衝突裁決)**：5 大極端場景實地驗收、離線同步食安紅線強制人工仲裁、雙儲存庫 Git 一鍵啟動指令。
8. **Phase 8 (公用資料與手冊)**：農業部防檢署 PHI 比對、天然災害 20% 門檻試算、三角色家庭田間實務操作手冊。
`;

  return (
    <div className="space-y-8 pb-16">
      {/* 頁面標頭卡片 */}
      <div className="bg-gradient-to-br from-stone-900 via-stone-900 to-emerald-950/30 border border-emerald-800/40 rounded-2xl p-6 sm:p-8">
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mb-4">
          <div className="flex items-center gap-3">
            <span className="p-3 bg-emerald-900/60 border border-emerald-700/50 rounded-xl text-emerald-300">
              <Globe2 className="w-6 h-6" />
            </span>
            <div>
              <div className="flex items-center gap-2">
                <h2 className="text-xl sm:text-2xl font-bold text-white tracking-tight">
                  第八階段：臺灣農業公用資料中樞、家庭手冊與完整規格書
                </h2>
                <span className="px-2.5 py-0.5 rounded-full bg-emerald-950 text-emerald-300 border border-emerald-800 text-xs font-mono font-medium">
                  Phase 8 Comprehensive
                </span>
              </div>
              <p className="text-sm text-stone-400 mt-1">
                落實主提示詞第 4、11、13 條精神：農業部防檢署 (BAPHIQ) 安全採收期 (PHI) 嚴格查核、20% 農損門檻試算與三角色家庭農事實務操作手冊。
              </p>
            </div>
          </div>

          <div className="px-4 py-2 bg-stone-800/80 rounded-xl border border-stone-700 text-xs text-stone-300">
            <span className="text-stone-400 block mb-0.5">公用資料規範</span>
            <span className="text-emerald-300 font-semibold">食安安全採收期嚴格強制・法規救助標準試算</span>
          </div>
        </div>

        {/* 標籤導航 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-2 pt-4 border-t border-stone-800 text-xs">
          <button
            onClick={() => setActiveTab('agri_hub')}
            className={`p-3 rounded-xl border flex items-center gap-2.5 transition-colors text-left ${
              activeTab === 'agri_hub'
                ? 'bg-emerald-900/40 border-emerald-600 text-emerald-200'
                : 'bg-stone-800/40 border-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <Globe2 className="w-4 h-4 text-emerald-400 shrink-0" />
            <div>
              <div className="font-semibold text-white">1. 臺灣農業公用 API 中樞</div>
              <div className="text-[11px] text-stone-400">防檢署 PHI / 20% 災損試算</div>
            </div>
          </button>

          <button
            onClick={() => setActiveTab('field_manual')}
            className={`p-3 rounded-xl border flex items-center gap-2.5 transition-colors text-left ${
              activeTab === 'field_manual'
                ? 'bg-emerald-900/40 border-emerald-600 text-emerald-200'
                : 'bg-stone-800/40 border-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <BookOpen className="w-4 h-4 text-amber-400 shrink-0" />
            <div>
              <div className="font-semibold text-white">2. 田間實務家庭操作手冊</div>
              <div className="text-[11px] text-stone-400">長輩語音 / 子女審核 / 會計出貨</div>
            </div>
          </button>

          <button
            onClick={() => setActiveTab('spec_center')}
            className={`p-3 rounded-xl border flex items-center gap-2.5 transition-colors text-left ${
              activeTab === 'spec_center'
                ? 'bg-emerald-900/40 border-emerald-600 text-emerald-200'
                : 'bg-stone-800/40 border-stone-800 text-stone-400 hover:text-stone-200'
            }`}
          >
            <FileCode className="w-4 h-4 text-purple-400 shrink-0" />
            <div>
              <div className="font-semibold text-white">3. 全系統產物匯出中心</div>
              <div className="text-[11px] text-stone-400">完整規格書與 OpenAPI 藍圖</div>
            </div>
          </button>
        </div>
      </div>

      {/* ──────────────────────────────────────────────────────── */}
      {/* 1. 臺灣農業公用 API 工作台 */}
      {/* ──────────────────────────────────────────────────────── */}
      {activeTab === 'agri_hub' && (
        <div className="space-y-6">
          {/* 農藥安全採收期 (PHI) 試算器 */}
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <ShieldCheck className="w-5 h-5 text-emerald-400" />
                <h3 className="text-base font-bold text-white">農業部防檢署 (BAPHIQ) 農藥安全採收期 (PHI) 智能查驗</h3>
              </div>
              <span className="text-xs text-stone-400">
                調用純函數：evaluatePesticideSafetyInterval()
              </span>
            </div>

            <p className="text-xs text-stone-300 leading-relaxed mb-6">
              依據主提示詞原則：<strong>「缺少資訊明確標示、農藥管制嚴格依據可靠資料庫」</strong>。本模組直接比對十字花科蔬菜用藥之法定安全採收期，嚴禁提前採收出貨。
            </p>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6 text-xs">
              <div>
                <label className="block text-stone-300 font-medium mb-1.5">施用資材／農藥品項</label>
                <select
                  value={selectedPesticide}
                  onChange={(e) => setSelectedPesticide(e.target.value as any)}
                  className="w-full bg-stone-800 border border-stone-700 rounded-xl px-3 py-2 text-stone-200 focus:outline-none focus:border-emerald-500"
                >
                  <option value="CYPERMETHRIN">賽滅寧 (Cypermethrin 10% EC) - 法定採收期 7 天</option>
                  <option value="CHLORFENAPYR">蟲蟎腈 (Chlorfenapyr 10% SC) - 法定採收期 14 天</option>
                  <option value="BACILLUS_THURINGIENSIS">蘇力菌 (生物防治劑) - 無受限採收期 (0天)</option>
                  <option value="ORGANIC_NEEM">印楝素 (有機資材) - 無受限採收期 (0天)</option>
                </select>
              </div>

              <div>
                <label className="block text-stone-300 font-medium mb-1.5">最後施藥日期</label>
                <input
                  type="date"
                  value={sprayDate}
                  onChange={(e) => setSprayDate(e.target.value)}
                  className="w-full bg-stone-800 border border-stone-700 rounded-xl px-3 py-2 text-stone-200 focus:outline-none focus:border-emerald-500"
                />
              </div>

              <div>
                <label className="block text-stone-300 font-medium mb-1.5">預計採收日期</label>
                <input
                  type="date"
                  value={targetHarvestDate}
                  onChange={(e) => setTargetHarvestDate(e.target.value)}
                  className="w-full bg-stone-800 border border-stone-700 rounded-xl px-3 py-2 text-stone-200 focus:outline-none focus:border-emerald-500"
                />
              </div>
            </div>

            {/* 試算結論卡片 */}
            <div
              className={`p-4 rounded-xl border flex flex-col md:flex-row md:items-center justify-between gap-4 ${
                pesticideResult.isSafeToHarvest
                  ? 'bg-emerald-950/50 border-emerald-700/60'
                  : 'bg-red-950/50 border-red-700/60'
              }`}
            >
              <div className="flex items-center gap-3">
                <div
                  className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 ${
                    pesticideResult.isSafeToHarvest
                      ? 'bg-emerald-800 text-white'
                      : 'bg-red-800 text-white'
                  }`}
                >
                  {pesticideResult.isSafeToHarvest ? (
                    <CheckCircle2 className="w-6 h-6" />
                  ) : (
                    <AlertTriangle className="w-6 h-6" />
                  )}
                </div>
                <div>
                  <div className="flex items-center gap-2">
                    <span className="font-bold text-sm text-white">
                      {pesticideResult.isSafeToHarvest ? '符合安全採收標準 (可採收)' : '未達安全採收期 (禁止採收)'}
                    </span>
                    <span className="text-[11px] font-mono px-2 py-0.5 rounded bg-black/40 text-stone-300">
                      法定間隔: {pesticideResult.requiredIntervalDays} 天 | 已經過: {pesticideResult.daysPassed} 天
                    </span>
                  </div>
                  <p className="text-xs text-stone-300 mt-1">
                    {pesticideResult.officialNotice}
                  </p>
                </div>
              </div>

              {!pesticideResult.isSafeToHarvest && (
                <div className="px-3 py-2 bg-red-900/60 rounded-lg border border-red-700 text-right text-xs shrink-0">
                  <span className="text-red-300 block">距解禁尚缺</span>
                  <span className="text-white font-bold text-base font-mono">{pesticideResult.daysRemaining} 天</span>
                </div>
              )}
            </div>
          </div>

          {/* 農業天然災害救助 20% 法定門檻試算 */}
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Calculator className="w-5 h-5 text-amber-400" />
                <h3 className="text-base font-bold text-white">農業天然災害現金救助法定標準試算 (20% 門檻)</h3>
              </div>
              <span className="text-xs text-stone-400">
                依據農業部《農業天然災害救助辦法》第 5 條
              </span>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6 text-xs">
              <div>
                <label className="block text-stone-300 font-medium mb-1.5">受損耕作面積 (公頃)</label>
                <input
                  type="number"
                  step="0.01"
                  value={damagedArea}
                  onChange={(e) => setDamagedArea(Number(e.target.value))}
                  className="w-full bg-stone-800 border border-stone-700 rounded-xl px-3 py-2 text-stone-200 focus:outline-none focus:border-emerald-500 font-mono"
                />
              </div>

              <div>
                <label className="block text-stone-300 font-medium mb-1.5">農損比率 (%): {damageRatio}%</label>
                <input
                  type="range"
                  min="0"
                  max="100"
                  value={damageRatio}
                  onChange={(e) => setDamageRatio(Number(e.target.value))}
                  className="w-full accent-amber-500 bg-stone-800 rounded mt-2"
                />
              </div>
            </div>

            <div
              className={`p-4 rounded-xl border flex flex-col md:flex-row md:items-center justify-between gap-4 ${
                disasterResult.isEligibleForRelief
                  ? 'bg-amber-950/40 border-amber-700/60'
                  : 'bg-stone-800/40 border-stone-700'
              }`}
            >
              <div>
                <div className="flex items-center gap-2">
                  <span className="font-bold text-sm text-white">
                    {disasterResult.isEligibleForRelief
                      ? '符合申報現金救助標準 (達 20% 門檻)'
                      : '未達 20% 救助門檻 (不符合現金救助)'}
                  </span>
                  <span className="text-[11px] font-mono px-2 py-0.5 rounded bg-black/40 text-stone-300">
                    蔬菜一類基準: NT$ 44,000 / 公頃
                  </span>
                </div>
                <p className="text-xs text-stone-300 mt-1">
                  {disasterResult.reason}
                </p>
              </div>

              {disasterResult.isEligibleForRelief && (
                <div className="px-4 py-2 bg-amber-900/60 rounded-xl border border-amber-600 text-right shrink-0">
                  <span className="text-xs text-amber-200 block">試算救助金額</span>
                  <span className="text-lg font-bold text-white font-mono">
                    NT$ {disasterResult.calculatedReliefTWD.toLocaleString()}
                  </span>
                </div>
              )}
            </div>
          </div>
        </div>
      )}

      {/* ──────────────────────────────────────────────────────── */}
      {/* 2. 田間實務家庭操作手冊 (Field Manual) */}
      {/* ──────────────────────────────────────────────────────── */}
      {activeTab === 'field_manual' && (
        <div className="space-y-6">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <h3 className="text-base font-bold text-white mb-2 flex items-center gap-2">
              <Users className="w-5 h-5 text-emerald-400" />
              <span>臺灣家庭農場三角色實戰操作指南 (Role-based Workflow)</span>
            </h3>
            <p className="text-xs text-stone-400 mb-6">
              依據第 3 條情境設計：長輩手持操作、大太陽防眩光、子女下班後非同步確認、電話工班不強制安裝 App。
            </p>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {/* 角色 A：長輩現場操作 */}
              <div className="bg-stone-800/40 border border-stone-700/60 rounded-2xl p-5 space-y-4">
                <div className="flex items-center gap-2.5 pb-3 border-b border-stone-700">
                  <span className="p-2 bg-emerald-950 text-emerald-300 rounded-xl">
                    <Smartphone className="w-5 h-5" />
                  </span>
                  <div>
                    <h4 className="font-bold text-sm text-white">長輩與現場工作者</h4>
                    <span className="text-[11px] text-stone-400">大太陽下按三下完成</span>
                  </div>
                </div>

                <div className="space-y-3 text-xs">
                  <div className="p-3 bg-stone-900 rounded-xl border border-stone-800">
                    <span className="font-bold text-emerald-400 block mb-1">步驟 1：抵達田區大按鈕</span>
                    <p className="text-stone-300">
                      打開 App，首頁僅顯示巨大「開始巡田」與「回報農事」，無需輸入複雜帳號密碼。
                    </p>
                  </div>

                  <div className="p-3 bg-stone-900 rounded-xl border border-stone-800">
                    <span className="font-bold text-emerald-400 block mb-1">步驟 2：按住說話錄音</span>
                    <p className="text-stone-300">
                      按住麥克風直接講台語或國語（如：「北田第四畦有蟲、灑了一包半黑王」），不強迫長輩打字。
                    </p>
                  </div>

                  <div className="p-3 bg-stone-900 rounded-xl border border-stone-800">
                    <span className="font-bold text-emerald-400 block mb-1">步驟 3：拍兩張照震動確認</span>
                    <p className="text-stone-300">
                      快門拍攝後發出微幅觸覺震動，離線即時存入手機 SQLite，待回家連上 Wi-Fi 自動上傳。
                    </p>
                  </div>
                </div>
              </div>

              {/* 角色 B：返鄉青農晚間審核 */}
              <div className="bg-stone-800/40 border border-stone-700/60 rounded-2xl p-5 space-y-4">
                <div className="flex items-center gap-2.5 pb-3 border-b border-stone-700">
                  <span className="p-2 bg-blue-950 text-blue-300 rounded-xl">
                    <Users className="w-5 h-5" />
                  </span>
                  <div>
                    <h4 className="font-bold text-sm text-white">返鄉青農與共同經營者</h4>
                    <span className="text-[11px] text-stone-400">晚間 3 分鐘審定與派工</span>
                  </div>
                </div>

                <div className="space-y-3 text-xs">
                  <div className="p-3 bg-stone-900 rounded-xl border border-stone-800">
                    <span className="font-bold text-blue-400 block mb-1">步驟 1：收聽長輩語音原文</span>
                    <p className="text-stone-300">
                      系統完整保留長輩錄音檔案，子女核對「一包半」對應台肥特43號 60 公斤扣庫存。
                    </p>
                  </div>

                  <div className="p-3 bg-stone-900 rounded-xl border border-stone-800">
                    <span className="font-bold text-blue-400 block mb-1">步驟 2：簽認未施農藥</span>
                    <p className="text-stone-300">
                      點擊「主管確認未施用管制農藥」，解除採收鎖定，讓後續 TAP 產銷履歷自動合規。
                    </p>
                  </div>

                  <div className="p-3 bg-stone-900 rounded-xl border border-stone-800">
                    <span className="font-bold text-blue-400 block mb-1">步驟 3：電話確認次日工班</span>
                    <p className="text-stone-300">
                      致電蓮姊確認明日 2 名採收工人，在 App 標記為 CONFIRMED，確保不缺工。
                    </p>
                  </div>
                </div>
              </div>

              {/* 角色 C：出貨結算與會計 */}
              <div className="bg-stone-800/40 border border-stone-700/60 rounded-2xl p-5 space-y-4">
                <div className="flex items-center gap-2.5 pb-3 border-b border-stone-700">
                  <span className="p-2 bg-purple-950 text-purple-300 rounded-xl">
                    <Calendar className="w-5 h-5" />
                  </span>
                  <div>
                    <h4 className="font-bold text-sm text-white">會計與出貨管理者</h4>
                    <span className="text-[11px] text-stone-400">市場拍賣單與現金核銷</span>
                  </div>
                </div>

                <div className="space-y-3 text-xs">
                  <div className="p-3 bg-stone-900 rounded-xl border border-stone-800">
                    <span className="font-bold text-purple-400 block mb-1">步驟 1：輸入拍賣單據</span>
                    <p className="text-stone-300">
                      拍下西螺果菜市場拍賣聯，輸入毛收入、扣除運費與管理費，算出應收淨額。
                    </p>
                  </div>

                  <div className="p-3 bg-stone-900 rounded-xl border border-stone-800">
                    <span className="font-bold text-purple-400 block mb-1">步驟 2：收到現金勾稽銷帳</span>
                    <p className="text-stone-300">
                      收到行口匯款後將「應收帳款」轉為「已收現金」，杜絕家庭農場長期帳目不清。
                    </p>
                  </div>

                  <div className="p-3 bg-stone-900 rounded-xl border border-stone-800">
                    <span className="font-bold text-purple-400 block mb-1">步驟 3：天然災害一鍵備件</span>
                    <p className="text-stone-300">
                      若遇颱風損害，直接匯出帶有地號浮水印的申請表，隔日送至公所領取現金補助。
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ──────────────────────────────────────────────────────── */}
      {/* 3. 系統完整規格書與產物匯出中心 */}
      {/* ──────────────────────────────────────────────────────── */}
      {activeTab === 'spec_center' && (
        <div className="space-y-6">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-4">
              <div className="flex items-center gap-3">
                <span className="p-2.5 bg-emerald-950 border border-emerald-700/60 rounded-xl text-emerald-300">
                  <FileCode className="w-5 h-5" />
                </span>
                <div>
                  <h3 className="text-base font-bold text-white">「農田日記」全專案綜合技術規格白皮書 (Markdown)</h3>
                  <p className="text-xs text-stone-400">涵蓋階段 1 至 8 之架構規格、資料庫結構、API 路由與發布邊界</p>
                </div>
              </div>

              <button
                onClick={() => {
                  navigator.clipboard.writeText(fullSystemSummaryMarkdown);
                  setCopiedSpec(true);
                  setTimeout(() => setCopiedSpec(false), 2000);
                }}
                className="px-4 py-2 bg-emerald-700 hover:bg-emerald-600 text-white rounded-xl text-xs font-semibold flex items-center gap-2 transition-colors"
              >
                {copiedSpec ? (
                  <>
                    <Check className="w-4 h-4 text-emerald-300" />
                    <span>已複製規格書全文</span>
                  </>
                ) : (
                  <>
                    <Copy className="w-4 h-4" />
                    <span>複製規格書 Markdown</span>
                  </>
                )}
              </button>
            </div>

            <div className="bg-stone-950 rounded-xl border border-stone-800 p-4 max-h-[460px] overflow-y-auto text-xs font-mono text-stone-300 leading-relaxed scrollbar-thin">
              <pre className="whitespace-pre-wrap">{fullSystemSummaryMarkdown}</pre>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
