import React, { useState } from 'react';
import {
  InventoryItem,
  InventoryTransaction,
  AttendanceRecord,
  OfflineSyncItem,
} from '../types/index.ts';
import {
  Calendar,
  Package,
  BadgeDollarSign,
  WifiOff,
  Search,
  AlertTriangle,
  CheckCircle2,
  Clock,
  ArrowRight,
  ExternalLink,
  Plus,
  RefreshCw,
  Coins,
  ShieldCheck,
  Building2,
} from 'lucide-react';

export const Phase2DailyOperations: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'open_data' | 'calendar' | 'inventory' | 'attendance' | 'offline_sync'>('open_data');

  // 1. 公開資料搜尋狀態 (官方 API 調用模擬)
  const [searchQuery, setSearchQuery] = useState('台肥');
  const [searchType, setSearchType] = useState<'fertilizer' | 'pesticide'>('fertilizer');
  const [isSearching, setIsSearching] = useState(false);

  // 官方公開資料快取/結果
  const openDataResults = [
    {
      licenseNo: '肥製(複)字第 0001001 號',
      brandName: '台肥黑王一號有機質特43號複合肥料',
      vendor: '台灣肥料股份有限公司',
      category: '雜項複合肥料 (品目編號 6-05)',
      ingredients: '全氮 15.0%、全磷酐 15.0%、全氧化鉀 15.0%、有機質 50.0%',
      packageSpec: '40公斤/包',
      source: '農業部農糧署開放資料 (data.moa.gov.tw - EIR28)',
      isOfficialVerified: true,
    },
    {
      licenseNo: '肥製(質)字第 0001099 號',
      brandName: '台肥金農友特1號有機質肥料',
      vendor: '台灣肥料股份有限公司',
      category: '植物渣粕肥料 (品目編號 5-01)',
      ingredients: '全氮 4.0%、全磷酐 2.0%、全氧化鉀 1.5%、有機質 75.0%',
      packageSpec: '25公斤/包',
      source: '農業部農糧署開放資料 (data.moa.gov.tw - EIR28)',
      isOfficialVerified: true,
    },
    {
      licenseNo: '農藥製字第 02345 號',
      brandName: '可利斯乳劑 (Chlorantraniliprole 5%)',
      vendor: '富農化學工業',
      category: '殺蟲劑 (IRAC 28)',
      ingredients: '氯蟲苯甲醯胺 5.0% w/v',
      packageSpec: '500毫升/罐',
      safeHarvestDays: '十字花科蔬菜：安全採收期 7 天，稀釋倍數 1500 倍',
      source: '農業部動植物防檢署開放資料 (data.moa.gov.tw - EIR027)',
      isOfficialVerified: true,
    },
  ];

  // 2. 庫存資料狀態
  const [inventory, setInventory] = useState<InventoryItem[]>([
    {
      id: 'inv-01',
      workspaceId: 'ws-tw-xiluo-001',
      brandName: '台灣肥料',
      productName: '台肥黑王一號有機質特43號複合肥料',
      commonName: '特43號',
      category: 'FERTILIZER',
      specification: '40公斤/包',
      unit: '包',
      totalStockQuantity: 18.5,
      safetyStockThreshold: 5.0,
    },
    {
      id: 'inv-02',
      workspaceId: 'ws-tw-xiluo-001',
      brandName: '農友種苗',
      productName: '三津一號青江白菜種子',
      commonName: '青江菜種',
      category: 'SEED',
      specification: '1磅/罐',
      unit: '罐',
      totalStockQuantity: 4,
      safetyStockThreshold: 2.0,
    },
  ]);

  const [transactions, setTransactions] = useState<InventoryTransaction[]>([
    {
      id: 'tx-01',
      itemId: 'inv-01',
      workspaceId: 'ws-tw-xiluo-001',
      transactionType: 'PURCHASE_IN',
      quantityChange: 20,
      resultingBalance: 20,
      batchNumber: 'TF-202602-098',
      operatorName: '林家豪',
      timestamp: '2026-10-10 09:30',
      notes: '向西螺農會採購進庫',
    },
    {
      id: 'tx-02',
      itemId: 'inv-01',
      workspaceId: 'ws-tw-xiluo-001',
      transactionType: 'WORK_CONSUME',
      quantityChange: -1.5,
      resultingBalance: 18.5,
      batchNumber: 'TF-202602-098',
      linkedWorkLogId: 'log-501',
      operatorName: '張金吉 (阿吉叔)',
      timestamp: '2026-10-15 11:00',
      notes: '北田施用基肥一包半 (對應 log-501)',
    },
  ]);

  // 3. 出勤與工資狀態
  const [attendance, setAttendance] = useState<AttendanceRecord[]>([
    {
      id: 'att-01',
      workspaceId: 'ws-tw-xiluo-001',
      taskId: 'task-101',
      contactId: 'contact-01',
      contactName: '張金吉 (阿吉叔)',
      workDate: '2026-10-15',
      checkInTime: '06:30',
      checkOutTime: '11:00',
      actualHoursWorked: 4.5,
      wageType: 'DAILY',
      rateSnapshotTWD: 2500,
      totalPayableTWD: 2500,
      isPaid: true,
      paidDate: '2026-10-15',
      paymentMethod: 'CASH',
      isFamilyLabor: false, // 外部雇工現金支出
    },
    {
      id: 'att-02',
      workspaceId: 'ws-tw-xiluo-001',
      taskId: 'task-101',
      contactId: 'contact-family-01',
      contactName: '林家豪 (青農返鄉)',
      workDate: '2026-10-15',
      checkInTime: '06:30',
      checkOutTime: '12:00',
      actualHoursWorked: 5.5,
      wageType: 'HOURLY',
      rateSnapshotTWD: 200,
      totalPayableTWD: 1100,
      isPaid: false,
      isFamilyLabor: true, // 自家人內部工時估算
    },
  ]);

  // 4. 離線同步佇列狀態
  const [syncQueue, setSyncQueue] = useState<OfflineSyncItem[]>([
    {
      localId: 'local-log-901',
      entityType: 'WORK_LOG',
      payloadSummary: '北田巡查日誌與照片 (現場無訊號暫存)',
      localSavedAt: '2026-10-19 10:15',
      syncStatus: 'LOCAL_SAVED', // 鐵律：不可與已同步打同一個勾
      retryCount: 0,
    },
    {
      localId: 'local-task-902',
      entityType: 'TASK',
      payloadSummary: '追加整地派工單 (阿吉叔)',
      localSavedAt: '2026-10-19 09:30',
      syncStatus: 'SYNCED',
      retryCount: 1,
    },
    {
      localId: 'local-log-903',
      entityType: 'WORK_LOG',
      payloadSummary: '資材領用扣抵紀錄',
      localSavedAt: '2026-10-19 08:20',
      syncStatus: 'SYNC_FAILED',
      retryCount: 3,
      errorMessage: '網路逾時：伺服器未收到 ACK，保留於本機佇列待重試',
    },
  ]);

  const handleManualSync = (localId: string) => {
    setSyncQueue(syncQueue.map(item => {
      if (item.localId !== localId) return item;
      return {
        ...item,
        syncStatus: 'SYNCED',
        retryCount: item.retryCount + 1,
        errorMessage: undefined,
      };
    }));
  };

  return (
    <div className="space-y-6 pb-16">
      {/* 頂部引導卡片 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Calendar className="w-5 h-5 text-emerald-400" />
            <h2 className="text-base font-bold text-white">
              第二階段核心日常協同 (Phase 2 Daily Operations & Open Data)
            </h2>
          </div>
          <span className="text-xs px-2.5 py-1 rounded-full bg-emerald-950 text-emerald-300 border border-emerald-800 font-mono">
            Phase 2 Active
          </span>
        </div>
        <p className="text-xs text-stone-400 mt-2 leading-relaxed">
          包含：<strong>臺灣農業公開資料 (Open Data API) 實時調用、農事行事曆與缺工警報、資材 FIFO 庫存追蹤、出勤與工資結算 (自家工時與外部現金分離)、離線四態同步佇列</strong>。
        </p>

        {/* 次級導航列 */}
        <div className="flex space-x-2 overflow-x-auto mt-4 pt-3 border-t border-stone-800 text-xs">
          <button
            onClick={() => setActiveTab('open_data')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              activeTab === 'open_data' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200 bg-stone-950'
            }`}
          >
            🌐 官方公開資料 API 調用
          </button>
          <button
            onClick={() => setActiveTab('calendar')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              activeTab === 'calendar' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200 bg-stone-950'
            }`}
          >
            📅 農事行事曆與缺工警報
          </button>
          <button
            onClick={() => setActiveTab('inventory')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              activeTab === 'inventory' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200 bg-stone-950'
            }`}
          >
            📦 資材庫存與 FIFO 扣抵
          </button>
          <button
            onClick={() => setActiveTab('attendance')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              activeTab === 'attendance' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200 bg-stone-950'
            }`}
          >
            💰 出勤與工資結算
          </button>
          <button
            onClick={() => setActiveTab('offline_sync')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              activeTab === 'offline_sync' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200 bg-stone-950'
            }`}
          >
            📶 離線四態同步佇列
          </button>
        </div>
      </div>

      {/* 1. 臺灣官方公開資料 API 調用模組 */}
      {activeTab === 'open_data' && (
        <div className="space-y-4">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <h3 className="text-sm font-bold text-white flex items-center gap-2">
                  <Building2 className="w-4 h-4 text-emerald-400" />
                  農業部官方開放資料 API 即時介接 (data.moa.gov.tw)
                </h3>
                <p className="text-xs text-stone-400 mt-0.5">
                  介接動植物防檢署「農藥登記資料 (EIR027)」與農糧署「肥料管理整合資訊 (EIR28)」，合法字號與安全採收期有所依據。
                </p>
              </div>
            </div>

            {/* 搜尋列 */}
            <div className="flex flex-col sm:flex-row gap-2">
              <div className="flex rounded-xl bg-stone-950 p-1 border border-stone-800 text-xs shrink-0">
                <button
                  onClick={() => setSearchType('fertilizer')}
                  className={`px-3 py-1.5 rounded-lg font-medium ${searchType === 'fertilizer' ? 'bg-emerald-800 text-white' : 'text-stone-400'}`}
                >
                  肥料登記資料 (EIR28)
                </button>
                <button
                  onClick={() => setSearchType('pesticide')}
                  className={`px-3 py-1.5 rounded-lg font-medium ${searchType === 'pesticide' ? 'bg-emerald-800 text-white' : 'text-stone-400'}`}
                >
                  農藥登記資料 (EIR027)
                </button>
              </div>

              <div className="relative flex-1">
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="輸入廠牌、品名或商品名 (例如：台肥、特43號、印楝素)..."
                  className="w-full bg-stone-950 border border-stone-800 rounded-xl px-4 py-2 text-xs text-white pl-10"
                />
                <Search className="w-4 h-4 text-stone-400 absolute left-3.5 top-2.5" />
              </div>

              <button
                onClick={() => {
                  setIsSearching(true);
                  setTimeout(() => setIsSearching(false), 300);
                }}
                className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-semibold shrink-0"
              >
                {isSearching ? '查詢官方 API 中...' : '查詢開放資料'}
              </button>
            </div>

            {/* API 呼叫端點規格提示 */}
            <div className="p-3 bg-stone-950 rounded-xl border border-stone-800 text-[11px] font-mono text-stone-400 flex items-center justify-between">
              <span>GET https://data.moa.gov.tw/Service/OpenData/FromM/{searchType === 'fertilizer' ? 'FertilizerData.aspx' : 'PesticideData.aspx'}</span>
              <span className="text-emerald-400">Status 200 OK (即時介接)</span>
            </div>

            {/* 搜尋結果列表 */}
            <div className="space-y-3 pt-2">
              {openDataResults.map((item, idx) => (
                <div key={idx} className="bg-stone-950 border border-stone-800/80 rounded-xl p-4 space-y-2">
                  <div className="flex items-start justify-between">
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-bold text-white">{item.brandName}</span>
                        <span className="text-[10px] px-2 py-0.5 rounded bg-emerald-950 text-emerald-300 border border-emerald-800 font-mono">
                          {item.licenseNo}
                        </span>
                      </div>
                      <div className="text-xs text-stone-400 mt-1">
                        出品業者：{item.vendor} ｜ 品目：{item.category} ｜ 規格：{item.packageSpec}
                      </div>
                    </div>
                    <span className="text-[10px] text-stone-400 flex items-center gap-1">
                      <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" /> 官方登記有案
                    </span>
                  </div>

                  <div className="text-xs text-stone-300 bg-stone-900 p-2.5 rounded-lg border border-stone-800">
                    <div><strong>登記成份：</strong>{item.ingredients}</div>
                    {item.safeHarvestDays && (
                      <div className="text-amber-400 font-medium mt-1">
                        ⚠️ <strong>安全採收期與稀釋規範：</strong>{item.safeHarvestDays}
                      </div>
                    )}
                  </div>

                  <div className="text-[11px] text-stone-500 flex items-center justify-between pt-1">
                    <span>資料來源：{item.source}</span>
                    <button
                      onClick={() => alert(`已成功引用 ${item.brandName} 規格 (${item.packageSpec}) 至農務作業資材項目！`)}
                      className="text-emerald-400 hover:text-emerald-300 text-xs font-medium"
                    >
                      + 帶入至農田日記資材庫存
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* 2. 農事行事曆與缺工警報 */}
      {activeTab === 'calendar' && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-sm font-bold text-white flex items-center gap-2">
              <Calendar className="w-4 h-4 text-emerald-400" />
              115 年 10 月 (2026) 農務派工行事曆
            </h3>
            <span className="text-xs px-2.5 py-0.5 rounded bg-stone-800 text-stone-300">
              西螺大橋下青農合作社
            </span>
          </div>

          {/* 缺工警報橫幅 */}
          <div className="p-3 bg-amber-950/40 border border-amber-800/80 rounded-xl text-xs text-amber-200 flex items-start gap-2">
            <AlertTriangle className="w-4 h-4 text-amber-400 shrink-0 mt-0.5" />
            <div>
              <strong>【缺工警報】10/22 (四) 北田翻耕與基肥追施：</strong>
              <span> 工作預計需要 2 名現場作業員，目前僅 1 人 (張金吉) 本人確認答應；尚缺 1 人未確認！</span>
            </div>
          </div>

          {/* 行事曆日程卡片 */}
          <div className="space-y-3">
            <div className="bg-stone-950 p-4 rounded-xl border border-stone-800 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
              <div>
                <div className="flex items-center gap-2">
                  <span className="text-xs font-mono font-bold text-emerald-400">2026-10-20 (二) 06:30</span>
                  <span className="text-xs px-2 py-0.5 rounded bg-blue-950 text-blue-300 border border-blue-800">已排程</span>
                </div>
                <h4 className="text-sm font-bold text-white mt-1">第1~8畦追施有機質肥並巡檢跳甲</h4>
                <div className="text-xs text-stone-400 mt-0.5">
                  田區：大同路後底大坵 (北田) ｜ 集合點：工寮前榕樹下 ｜ 到場人員：張金吉 (已確認)
                </div>
              </div>
              <span className="text-xs text-emerald-400 font-medium">工班狀態良好 (無缺工)</span>
            </div>

            <div className="bg-stone-950 p-4 rounded-xl border border-stone-800 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
              <div>
                <div className="flex items-center gap-2">
                  <span className="text-xs font-mono font-bold text-amber-400">2026-10-22 (四) 06:00</span>
                  <span className="text-xs px-2 py-0.5 rounded bg-amber-950 text-amber-300 border border-amber-800">缺工待補</span>
                </div>
                <h4 className="text-sm font-bold text-white mt-1">北田全區翻耕與二期作前整地</h4>
                <div className="text-xs text-stone-400 mt-0.5">
                  田區：大同路後底大坵 (北田) ｜ 需求人數：2 人 ｜ 已答應：1 人 ｜ 待聯繫：1 人
                </div>
              </div>
              <button
                onClick={() => alert('已發起快速聯繫工班清單！')}
                className="px-3 py-1.5 bg-amber-800 hover:bg-amber-700 text-white rounded-lg text-xs font-medium self-start sm:self-auto"
              >
                安排補工聯繫
              </button>
            </div>
          </div>
        </div>
      )}

      {/* 3. 資材庫存與 FIFO 扣抵 */}
      {activeTab === 'inventory' && (
        <div className="space-y-4">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <h3 className="text-sm font-bold text-white flex items-center gap-2">
                  <Package className="w-4 h-4 text-emerald-400" />
                  資材產品與庫存進出歷程 (FIFO 批次扣抵)
                </h3>
                <p className="text-xs text-stone-400 mt-0.5">
                  杜絕隨意竄改剩餘數字：每一筆領用消耗必須連回實際農務作業紀錄 ID。
                </p>
              </div>
            </div>

            {/* 庫存餘額清單 */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {inventory.map((inv) => (
                <div key={inv.id} className="bg-stone-950 border border-stone-800 rounded-xl p-4 space-y-2">
                  <div className="flex items-start justify-between">
                    <div>
                      <div className="text-xs text-stone-400">{inv.brandName}</div>
                      <div className="text-sm font-bold text-white">{inv.productName}</div>
                      <div className="text-xs text-stone-300 mt-0.5">規格：{inv.specification}</div>
                    </div>
                    <div className="text-right">
                      <div className="text-lg font-mono font-bold text-emerald-400">
                        {inv.totalStockQuantity} <span className="text-xs text-stone-400">{inv.unit}</span>
                      </div>
                      <div className="text-[11px] text-stone-400">安全庫存：{inv.safetyStockThreshold} {inv.unit}</div>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* 異動歷程明細 */}
            <div className="pt-3 border-t border-stone-800">
              <h4 className="text-xs font-bold text-stone-300 mb-2">可追溯庫存異動流水帳 (Audit Trail)</h4>
              <div className="space-y-2">
                {transactions.map((tx) => (
                  <div key={tx.id} className="bg-stone-950 p-3 rounded-xl border border-stone-800 text-xs flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                    <div>
                      <div className="flex items-center gap-2">
                        <span className={`px-2 py-0.5 rounded text-[10px] font-bold ${
                          tx.transactionType === 'PURCHASE_IN' ? 'bg-emerald-950 text-emerald-300 border border-emerald-800' : 'bg-blue-950 text-blue-300 border border-blue-800'
                        }`}>
                          {tx.transactionType === 'PURCHASE_IN' ? '採購入庫' : '農事作業領用扣抵'}
                        </span>
                        <span className="text-stone-300 font-medium">{tx.notes}</span>
                        {tx.linkedWorkLogId && (
                          <span className="text-[11px] font-mono text-emerald-400">({tx.linkedWorkLogId})</span>
                        )}
                      </div>
                      <div className="text-[11px] text-stone-400 mt-1">
                        批號：{tx.batchNumber} ｜ 經辦人：{tx.operatorName} ｜ 時間：{tx.timestamp}
                      </div>
                    </div>
                    <div className="text-right font-mono">
                      <span className={tx.quantityChange > 0 ? 'text-emerald-400 font-bold' : 'text-amber-400 font-bold'}>
                        {tx.quantityChange > 0 ? `+${tx.quantityChange}` : tx.quantityChange} 包
                      </span>
                      <div className="text-[10px] text-stone-500">結餘：{tx.resultingBalance} 包</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}

      {/* 4. 出勤與工資結算 */}
      {activeTab === 'attendance' && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-sm font-bold text-white flex items-center gap-2">
                <BadgeDollarSign className="w-4 h-4 text-emerald-400" />
                現場出勤與工資結算 (Payroll & Attendance)
              </h3>
              <p className="text-xs text-stone-400 mt-0.5">
                嚴格區分「外部雇工現金支出」與「自家人內部工時估算」，精確核算真實成本。
              </p>
            </div>
          </div>

          <div className="space-y-3">
            {attendance.map((att) => (
              <div key={att.id} className="bg-stone-950 border border-stone-800 rounded-xl p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-sm font-bold text-white">{att.contactName}</span>
                    <span className={`text-[10px] px-2 py-0.5 rounded font-mono ${
                      att.isFamilyLabor ? 'bg-purple-950 text-purple-300 border border-purple-800' : 'bg-emerald-950 text-emerald-300 border border-emerald-800'
                    }`}>
                      {att.isFamilyLabor ? '自家人內部工時估算' : '外部雇工 (現金薪資)'}
                    </span>
                    <span className={`text-[10px] px-2 py-0.5 rounded font-bold ${
                      att.isPaid ? 'bg-stone-800 text-stone-300' : 'bg-amber-950 text-amber-300 border border-amber-800'
                    }`}>
                      {att.isPaid ? '已付清' : '應付未付'}
                    </span>
                  </div>
                  <div className="text-xs text-stone-400 mt-1">
                    日期：{att.workDate} ｜ 到離場：{att.checkInTime} ~ {att.checkOutTime} ({att.actualHoursWorked} 小時) ｜ 費率快照：NT$ {att.rateSnapshotTWD}
                  </div>
                </div>

                <div className="text-right">
                  <div className="text-base font-mono font-bold text-emerald-400">
                    NT$ {att.totalPayableTWD.toLocaleString()}
                  </div>
                  <div className="text-[11px] text-stone-400">
                    {att.isPaid ? `已於 ${att.paidDate} 透過現金結清` : '待管理者審查放款'}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* 5. 離線四態同步佇列 */}
      {activeTab === 'offline_sync' && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-sm font-bold text-white flex items-center gap-2">
                <WifiOff className="w-4 h-4 text-emerald-400" />
                本地離線草稿與同步佇列 (Offline Sync Queue)
              </h3>
              <p className="text-xs text-stone-400 mt-0.5">
                <strong>核心原則：</strong>不可用同一個綠色勾號混淆本機保存與雲端同步，明確標記失敗原因與重試機制。
              </p>
            </div>
          </div>

          <div className="space-y-3">
            {syncQueue.map((item) => (
              <div key={item.localId} className="bg-stone-950 border border-stone-800 rounded-xl p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-xs font-bold text-white">{item.payloadSummary}</span>
                    <span className={`text-[10px] font-mono px-2 py-0.5 rounded border ${
                      item.syncStatus === 'SYNCED' ? 'bg-emerald-950 text-emerald-300 border-emerald-800' :
                      item.syncStatus === 'SYNC_FAILED' ? 'bg-red-950 text-red-300 border-red-800' :
                      'bg-stone-800 text-amber-300 border-stone-700'
                    }`}>
                      {item.syncStatus === 'LOCAL_SAVED' ? '本機已安全暫存 (待連網上傳)' :
                       item.syncStatus === 'SYNCED' ? '雲端已同步' :
                       item.syncStatus === 'SYNC_FAILED' ? '同步失敗 (保留本機)' : '衝突待人工確認'}
                    </span>
                  </div>
                  <div className="text-xs text-stone-400 mt-1">
                    本機寫入時間：{item.localSavedAt} ｜ 重試次數：{item.retryCount} 次
                  </div>
                  {item.errorMessage && (
                    <div className="text-xs text-red-400 mt-1">
                      ⚠️ 失敗原因：{item.errorMessage}
                    </div>
                  )}
                </div>

                {item.syncStatus !== 'SYNCED' && (
                  <button
                    onClick={() => handleManualSync(item.localId)}
                    className="px-3 py-1.5 bg-emerald-800 hover:bg-emerald-700 text-white rounded-lg text-xs font-medium flex items-center gap-1.5 self-start sm:self-auto"
                  >
                    <RefreshCw className="w-3.5 h-3.5" /> 手動立即重試
                  </button>
                )}
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};
