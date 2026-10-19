import React, { useState } from 'react';
import {
  HarvestBatch,
  ShipmentRecord,
  AnomalyIncident,
  DisasterCase,
  AiConsultationMessage,
} from '../types/index.ts';
import {
  ShoppingBag,
  Coins,
  AlertOctagon,
  CloudLightning,
  Sparkles,
  ShieldCheck,
  CheckCircle2,
  Clock,
  ArrowRight,
  Send,
} from 'lucide-react';

export const Phase3BusinessAndAI: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'harvest' | 'shipments' | 'anomalies' | 'disasters' | 'ai_assistant'>('harvest');

  // 1. 採收批次資料
  const [harvests, setHarvests] = useState<HarvestBatch[]>([
    {
      id: 'harvest-01',
      workspaceId: 'ws-tw-xiluo-001',
      cropSeasonId: 'crop-season-2026-01',
      cropName: '青江白菜 (三津一號)',
      fieldId: 'field-north-01',
      fieldName: '大同路後底大坵 (北田)',
      harvestDate: '2026-10-18',
      harvestAreaDescription: '全區南側第1~4畦',
      grossWeightKg: 620.0,
      netWeightKg: 580.0,
      gradeQuality: 'GRADE_A',
      preHarvestCheck: {
        isSprayingRecordsComplete: true,
        isSafeHarvestPeriodPassed: true,
        hasPendingSprayConfirmation: false,
        inspectorName: '林家豪 (經營者)',
        checkedAt: '2026-10-18 05:30',
        checkPassed: true,
        notes: '全期查無受限農藥施用，安全採收期無受限，品質優良。',
      },
      operatorNames: ['林家豪', '陳美蓮 (蓮姊採收工班)'],
      notes: '晨採蔬菜，脆度良好，已移入工寮低溫暫存。',
    },
  ]);

  // 2. 出貨與結算資料
  const [shipments, setShipments] = useState<ShipmentRecord[]>([
    {
      id: 'ship-01',
      workspaceId: 'ws-tw-xiluo-001',
      harvestBatchId: 'harvest-01',
      cropName: '青江白菜 (優級)',
      buyerName: '西螺果菜批發市場行口 (38號順發蔬菜行)',
      buyerType: 'WHOLESALE_MARKET',
      shipmentDate: '2026-10-18',
      packagesCount: 19,
      packageType: '30公斤塑膠簍裝',
      unitAgreedPriceTWD: 32.0,
      grossRevenueTWD: 18560.0,
      freightDeductionTWD: 950.0,
      marketFeeDeductionTWD: 556.0,
      netReceivableTWD: 17054.0,
      actualReceivedCashTWD: 17054.0,
      receivedDate: '2026-10-19',
      isFullySettled: true,
      notes: '行口代銷每日清算，款項已匯入西螺農會帳戶。',
    },
    {
      id: 'ship-02',
      workspaceId: 'ws-tw-xiluo-001',
      harvestBatchId: 'harvest-01',
      cropName: '青江白菜 (良級規格)',
      buyerName: '溪州在地生鮮超市直供',
      buyerType: 'SUPERMARKET',
      shipmentDate: '2026-10-19',
      packagesCount: 10,
      packageType: '20公斤紙箱裝',
      unitAgreedPriceTWD: 26.0,
      grossRevenueTWD: 5200.0,
      freightDeductionTWD: 200.0,
      marketFeeDeductionTWD: 0.0,
      netReceivableTWD: 5000.0,
      actualReceivedCashTWD: 0.0,
      isFullySettled: false,
      notes: '超市開立採購單，約定次月 5 日電匯，尚未收到現金。',
    },
  ]);

  // 3. 田間異常事件追蹤
  const [anomalies, setAnomalies] = useState<AnomalyIncident[]>([
    {
      id: 'anom-01',
      workspaceId: 'ws-tw-xiluo-001',
      fieldId: 'field-north-01',
      fieldName: '大同路後底大坵 (北田)',
      cropSeasonId: 'crop-season-2026-01',
      title: '第5畦葉面局部有細微圓形咬痕',
      category: 'PEST',
      severity: 'MEDIUM',
      discoveredAt: '2026-10-17 07:10',
      discoveredBy: '林家豪',
      photoUrls: [
        'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?auto=format&fit=crop&w=800&q=80',
      ],
      observedPhenomenon: '巡田發現約 10 株菜葉葉緣出現針眼狀斑點，但翻檢葉背尚未見成蟲群聚。',
      actionTaken: '於第 5 畦兩端插設黃色黏蟲板進行監測，未施用化學農藥。',
      resolvedStatus: 'INVESTIGATING',
    },
  ]);

  // 4. 災害與保險案件
  const [disasters, setDisasters] = useState<DisasterCase[]>([
    {
      id: 'disaster-2026-01',
      workspaceId: 'ws-tw-xiluo-001',
      disasterEventName: '115年7月颱風農業天然災害救助申請',
      affectedFieldIds: ['field-north-01'],
      affectedCropName: '一期水稻 / 轉作蔬菜',
      damagedAreaHectares: 0.35,
      damageRatioPercent: 30.0,
      lossEstimatedTWD: 28000.0,
      photoEvidenceUrls: [
        'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?auto=format&fit=crop&w=800&q=80',
      ],
      governmentReliefStatus: 'APPLICATION_SUBMITTED',
      reliefOfficialAmountTWD: undefined,
      insurancePolicyNumber: 'AGRI-INS-2026-8891',
      insuranceClaimStatus: 'SURVEY_IN_PROGRESS',
      insurancePaidAmountTWD: undefined,
      officialNotes: '【系統法律警語】本系統內部災損估算僅供農場備查與整理備件，不得直接冒充農業部或鄉鎮公所官方勘查認定結果。',
    },
  ]);

  // 5. AI 農務助理
  const [aiPrompt, setAiPrompt] = useState('北田目前生長狀況如何？採收前還有哪些必須留意的農事細節？');
  const [isAiLoading, setIsAiLoading] = useState(false);
  const [aiMessages, setAiMessages] = useState<AiConsultationMessage[]>([
    {
      id: 'msg-01',
      role: 'USER',
      timestamp: '2026-10-19 11:20',
      prompt: '北田目前生長狀況如何？採收前還有哪些必須留意的農事細節？',
      content: {
        knownFacts: [
          '大同路後底大坵 (北田) 目前種植青江白菜 (三津一號)，前作水稻。',
          '2026-10-15 由張金吉施用台肥特43號基肥 60 公斤，管理者親自切結未施用化學農藥。',
          '2026-10-18 已完成第一階段採收 580 公斤，採前安全檢查合格並出貨西螺果菜市場。',
        ],
        observablePhenomena: [
          '2026-10-17 異常追蹤紀錄顯示第 5 畦有零星針眼狀咬痕，已插設黃色黏蟲板進行監控。',
        ],
        possibleCauses: [
          '可能為跳甲幼蟲或小菜蛾成蟲初期活動，需持續追蹤黏蟲板蟲數。',
        ],
        missingInformation: [
          '尚未確認剩餘第 5~8 畦的預計採收日期與現場作業工班安排。',
        ],
        suggestedNextSteps: [
          '1. 第二批採收前，請再度執行「採前安全期檢查表」，確認無鄰田農藥飄散污染。',
          '2. 檢查第 5 畦黃色黏蟲板之蟲數，若未達防治門檻可維持採收計畫。',
          '3. 提前通知陳美蓮帶班工班集合時間 (預計 06:00 工寮前)。',
        ],
      },
    },
  ]);

  const handleSendAiPrompt = () => {
    if (!aiPrompt.trim()) return;
    setIsAiLoading(true);
    setTimeout(() => {
      const newMsg: AiConsultationMessage = {
        id: `msg-${Date.now()}`,
        role: 'USER',
        timestamp: '剛剛',
        prompt: aiPrompt,
        content: {
          knownFacts: [
            '正式紀錄顯示：西螺合作社目前有一筆 5,000 元之超市應收帳款 (次月 5 日撥款)。',
            '倉庫中台肥特43號尚餘 18.5 包，高於 5 包之安全庫存閥值。',
          ],
          observablePhenomena: [
            '目前無未處理之重大設備損壞或水權衝突。',
          ],
          possibleCauses: [
            '天候預報近期穩定，適宜進行田區二期翻耕與清圳。',
          ],
          missingInformation: [
            '尚未取得 10/22 (四) 缺工 1 人之補工名單確認回覆。',
          ],
          suggestedNextSteps: [
            '優先致電工班候補名冊，於今日 18:00 前完成出工名冊確認。',
          ],
        },
      };
      setAiMessages([newMsg, ...aiMessages]);
      setIsAiLoading(false);
      setAiPrompt('');
    }, 600);
  };

  return (
    <div className="space-y-6 pb-16">
      {/* 頂部引導卡片 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <ShoppingBag className="w-5 h-5 text-emerald-400" />
            <h2 className="text-base font-bold text-white">
              第三階段核心農務閉環與 AI (Phase 3 Business Loop & AI)
            </h2>
          </div>
          <span className="text-xs px-2.5 py-1 rounded-full bg-emerald-950 text-emerald-300 border border-emerald-800 font-mono">
            Phase 3 Active
          </span>
        </div>
        <p className="text-xs text-stone-400 mt-2 leading-relaxed">
          包含：<strong>採收批次與採前安全期檢查、出貨履歷與應收/已收現金分離、田間異常事件追蹤、災害救助與保險理賠獨立管理、接地授權資料的 AI 農務助理 (五段式回答)</strong>。
        </p>

        {/* 次級導航列 */}
        <div className="flex space-x-2 overflow-x-auto mt-4 pt-3 border-t border-stone-800 text-xs">
          <button
            onClick={() => setActiveTab('harvest')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              activeTab === 'harvest' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200 bg-stone-950'
            }`}
          >
            🥬 採收批次與安全查核
          </button>
          <button
            onClick={() => setActiveTab('shipments')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              activeTab === 'shipments' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200 bg-stone-950'
            }`}
          >
            🚚 出貨履歷與款項結算
          </button>
          <button
            onClick={() => setActiveTab('anomalies')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              activeTab === 'anomalies' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200 bg-stone-950'
            }`}
          >
            🐛 田間異常事件追蹤
          </button>
          <button
            onClick={() => setActiveTab('disasters')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              activeTab === 'disasters' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200 bg-stone-950'
            }`}
          >
            ⛈️ 災害申報與保險獨立管理
          </button>
          <button
            onClick={() => setActiveTab('ai_assistant')}
            className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
              activeTab === 'ai_assistant' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200 bg-stone-950'
            }`}
          >
            🤖 AI 農務助理 (五段式結構)
          </button>
        </div>
      </div>

      {/* 1. 採收批次與採前安全期檢查 */}
      {activeTab === 'harvest' && (
        <div className="space-y-4">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
            <h3 className="text-sm font-bold text-white flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-emerald-400" />
              採收批次履歷與採前安全採收期防線 (Pre-Harvest Quality Gate)
            </h3>
            <p className="text-xs text-stone-400">
              採收前嚴格檢查：農事紀錄是否完整、施藥紀錄與安全採收天數是否符合官方規定。
            </p>

            <div className="space-y-4">
              {harvests.map((h) => (
                <div key={h.id} className="bg-stone-950 border border-stone-800 rounded-xl p-5 space-y-3">
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="text-sm font-bold text-white">{h.cropName}</span>
                        <span className="text-xs px-2 py-0.5 rounded bg-emerald-950 text-emerald-300 border border-emerald-800 font-bold">
                          等級：優級 (GRADE_A)
                        </span>
                      </div>
                      <div className="text-xs text-stone-400 mt-1">
                        採收日期：{h.harvestDate} ｜ 田區：{h.fieldName} ｜ 範圍：{h.harvestAreaDescription}
                      </div>
                    </div>
                    <div className="text-right">
                      <div className="text-lg font-mono font-bold text-emerald-400">
                        {h.netWeightKg} <span className="text-xs text-stone-400">公斤 (淨重)</span>
                      </div>
                      <div className="text-[11px] text-stone-500">毛重：{h.grossWeightKg} 公斤</div>
                    </div>
                  </div>

                  <div className="bg-stone-900 p-3.5 rounded-xl border border-stone-800 text-xs space-y-1.5">
                    <div className="flex items-center justify-between">
                      <span className="font-bold text-emerald-300 flex items-center gap-1.5">
                        <CheckCircle2 className="w-4 h-4 text-emerald-400" /> 採前安全採收期查驗：合格通過
                      </span>
                      <span className="text-stone-400 text-[11px]">
                        檢查人：{h.preHarvestCheck.inspectorName} ({h.preHarvestCheck.checkedAt})
                      </span>
                    </div>
                    <div className="text-stone-300">
                      查驗依據：{h.preHarvestCheck.notes}
                    </div>
                    <div className="text-stone-400 text-[11px] pt-1 border-t border-stone-800/80">
                      作業人員：{h.operatorNames.join('、')} ｜ 備註：{h.notes}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* 2. 出貨履歷與款項結算 */}
      {activeTab === 'shipments' && (
        <div className="space-y-4">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
            <h3 className="text-sm font-bold text-white flex items-center gap-2">
              <Coins className="w-4 h-4 text-emerald-400" />
              出貨履歷、運費扣款與現金結算 (Shipment & Cash Settlement)
            </h3>
            <p className="text-xs text-stone-400">
              <strong>實務鐵律：</strong>「應收貨款 (Receivable)」絕不等於「已收到現金 (Cash Received)」，未收現前不宣稱獲利！
            </p>

            <div className="space-y-3">
              {shipments.map((s) => (
                <div key={s.id} className="bg-stone-950 border border-stone-800 rounded-xl p-5 space-y-3">
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="text-sm font-bold text-white">{s.buyerName}</span>
                        <span className={`text-[10px] px-2 py-0.5 rounded font-mono font-bold ${
                          s.isFullySettled ? 'bg-emerald-950 text-emerald-300 border border-emerald-800' : 'bg-amber-950 text-amber-300 border border-amber-800'
                        }`}>
                          {s.isFullySettled ? '已收到現金結清' : '尚未收到現金 (待對帳)'}
                        </span>
                      </div>
                      <div className="text-xs text-stone-400 mt-1">
                        出貨日期：{s.shipmentDate} ｜ 品項：{s.cropName} ｜ 件數：{s.packagesCount} 件 ({s.packageType})
                      </div>
                    </div>
                    <div className="text-right">
                      <div className="text-xs text-stone-400">成交單價：NT$ {s.unitAgreedPriceTWD} / 公斤</div>
                      <div className="text-base font-mono font-bold text-white">
                        毛額：NT$ {s.grossRevenueTWD.toLocaleString()}
                      </div>
                    </div>
                  </div>

                  <div className="bg-stone-900 p-3 rounded-xl border border-stone-800 text-xs flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                    <div className="space-y-0.5">
                      <div className="text-stone-300">
                        運費代扣：-NT$ {s.freightDeductionTWD} ｜ 行口管理費：-NT$ {s.marketFeeDeductionTWD}
                      </div>
                      <div className="text-emerald-400 font-bold">
                        淨應收款 (Net Receivable)：NT$ {s.netReceivableTWD.toLocaleString()}
                      </div>
                    </div>

                    <div className="text-right font-mono">
                      <span className="text-xs text-stone-400">銀行實際入帳：</span>
                      <span className={`font-bold ml-1 ${s.actualReceivedCashTWD > 0 ? 'text-emerald-400' : 'text-amber-400'}`}>
                        NT$ {s.actualReceivedCashTWD.toLocaleString()}
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* 3. 田間異常事件追蹤 */}
      {activeTab === 'anomalies' && (
        <div className="space-y-4">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
            <h3 className="text-sm font-bold text-white flex items-center gap-2">
              <AlertOctagon className="w-4 h-4 text-amber-400" />
              田間異常事件與處置追蹤 (Anomaly Incidents)
            </h3>
            <p className="text-xs text-stone-400">
              客觀記錄可觀察現象（食痕、黃化），未獲確認前不擅自斷定法定病蟲害名稱。
            </p>

            <div className="space-y-3">
              {anomalies.map((anom) => (
                <div key={anom.id} className="bg-stone-950 border border-stone-800 rounded-xl p-5 space-y-3">
                  <div className="flex items-start justify-between">
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="text-sm font-bold text-white">{anom.title}</span>
                        <span className="text-[10px] px-2 py-0.5 rounded bg-amber-950 text-amber-300 border border-amber-800">
                          {anom.category}
                        </span>
                      </div>
                      <div className="text-xs text-stone-400 mt-1">
                        發現時間：{anom.discoveredAt} ｜ 田區：{anom.fieldName} ｜ 通報人：{anom.discoveredBy}
                      </div>
                    </div>
                    <span className="text-xs px-2.5 py-0.5 rounded bg-stone-800 text-stone-300 border border-stone-700">
                      處理狀態：{anom.resolvedStatus}
                    </span>
                  </div>

                  <div className="bg-stone-900 p-3 rounded-xl border border-stone-800 text-xs space-y-1.5 text-stone-300">
                    <div><strong>現場客觀觀察：</strong>{anom.observedPhenomenon}</div>
                    {anom.actionTaken && (
                      <div className="text-emerald-300"><strong>採取處置：</strong>{anom.actionTaken}</div>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* 4. 災害申報與保險獨立管理 */}
      {activeTab === 'disasters' && (
        <div className="space-y-4">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
            <h3 className="text-sm font-bold text-white flex items-center gap-2">
              <CloudLightning className="w-4 h-4 text-blue-400" />
              天然災害申報與農業保險獨立管理 (Disasters & Crop Insurance)
            </h3>
            <p className="text-xs text-stone-400">
              <strong>實務鐵律：</strong>「政府救助」與「商業保險」嚴禁合成同一種狀態；AI 估損不得冒充官方核定！
            </p>

            <div className="space-y-4">
              {disasters.map((dis) => (
                <div key={dis.id} className="bg-stone-950 border border-stone-800 rounded-xl p-5 space-y-4">
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                    <div>
                      <h4 className="text-sm font-bold text-white">{dis.disasterEventName}</h4>
                      <div className="text-xs text-stone-400 mt-0.5">
                        受災作物：{dis.affectedCropName} ｜ 受損面積：{dis.damagedAreaHectares} 公頃 (受損率 {dis.damageRatioPercent}%)
                      </div>
                    </div>
                    <div className="text-right">
                      <span className="text-xs text-stone-400">農場內部估損：</span>
                      <span className="text-base font-mono font-bold text-amber-400 ml-1">
                        NT$ {dis.lossEstimatedTWD.toLocaleString()}
                      </span>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3 pt-2">
                    <div className="p-3.5 bg-stone-900 rounded-xl border border-stone-800 space-y-1.5 text-xs">
                      <div className="flex items-center justify-between">
                        <strong className="text-emerald-400">1. 政府農業天然災害救助</strong>
                        <span className="text-[10px] px-2 py-0.5 rounded bg-blue-950 text-blue-300 border border-blue-800 font-mono">
                          {dis.governmentReliefStatus}
                        </span>
                      </div>
                      <div className="text-stone-300">進度：已送出公所受理，待農業部公告救助地區與現場複勘。</div>
                    </div>

                    <div className="p-3.5 bg-stone-900 rounded-xl border border-stone-800 space-y-1.5 text-xs">
                      <div className="flex items-center justify-between">
                        <strong className="text-blue-400">2. 商業農業保險理賠 (獨立保單)</strong>
                        <span className="text-[10px] px-2 py-0.5 rounded bg-purple-950 text-purple-300 border border-purple-800 font-mono">
                          {dis.insuranceClaimStatus}
                        </span>
                      </div>
                      <div className="text-stone-300">保單編號：{dis.insurancePolicyNumber}</div>
                    </div>
                  </div>

                  <div className="p-2.5 bg-amber-950/30 rounded-xl border border-amber-900/60 text-[11px] text-amber-300">
                    {dis.officialNotes}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* 5. AI 農務助理 (五段式結構) */}
      {activeTab === 'ai_assistant' && (
        <div className="space-y-4">
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
            <h3 className="text-sm font-bold text-white flex items-center gap-2">
              <Sparkles className="w-4 h-4 text-emerald-400" />
              AI 農務助理 (Grounded Farm Assistant)
            </h3>
            <p className="text-xs text-stone-400">
              存取授權田區正式紀錄，非通用聊天框。嚴格遵循<strong>五段式回答：已知事實、可觀察現象、可能原因、尚缺資訊、建議下一步</strong>。
            </p>

            <div className="flex gap-2">
              <input
                type="text"
                value={aiPrompt}
                onChange={(e) => setAiPrompt(e.target.value)}
                placeholder="輸入農務問題 (例如：北田目前生長與採收安全期檢核狀況？)..."
                className="flex-1 bg-stone-950 border border-stone-800 rounded-xl px-4 py-2.5 text-xs text-white"
                onKeyDown={(e) => {
                  if (e.key === 'Enter') handleSendAiPrompt();
                }}
              />
              <button
                onClick={handleSendAiPrompt}
                disabled={isAiLoading}
                className="px-4 py-2.5 bg-emerald-600 hover:bg-emerald-500 disabled:bg-stone-800 text-white rounded-xl text-xs font-semibold flex items-center gap-1.5"
              >
                <Send className="w-3.5 h-3.5" />
                <span>{isAiLoading ? '分析中...' : '諮詢助理'}</span>
              </button>
            </div>

            <div className="space-y-4 pt-2">
              {aiMessages.map((msg) => (
                <div key={msg.id} className="bg-stone-950 border border-stone-800 rounded-xl p-5 space-y-4">
                  <div className="flex items-center justify-between border-b border-stone-800 pb-2">
                    <span className="text-xs font-bold text-emerald-400">問題：{msg.prompt}</span>
                    <span className="text-[11px] text-stone-500">{msg.timestamp}</span>
                  </div>

                  <div className="space-y-3 text-xs">
                    <div className="p-3 bg-stone-900/90 rounded-xl border border-stone-800/80">
                      <div className="font-bold text-white mb-1 flex items-center gap-1.5">
                        <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
                        1. 已知事實 (依授權之正式農事紀錄)：
                      </div>
                      <ul className="space-y-1 text-stone-300 pl-4 list-disc">
                        {msg.content.knownFacts.map((item, idx) => (
                          <li key={idx}>{item}</li>
                        ))}
                      </ul>
                    </div>

                    <div className="p-3 bg-stone-900/90 rounded-xl border border-stone-800/80">
                      <div className="font-bold text-white mb-1 flex items-center gap-1.5">
                        <span className="w-2 h-2 rounded-full bg-blue-400"></span>
                        2. 可觀察現象 (現場回報與感測資料)：
                      </div>
                      <ul className="space-y-1 text-stone-300 pl-4 list-disc">
                        {msg.content.observablePhenomena.map((item, idx) => (
                          <li key={idx}>{item}</li>
                        ))}
                      </ul>
                    </div>

                    <div className="p-3 bg-stone-900/90 rounded-xl border border-stone-800/80">
                      <div className="font-bold text-white mb-1 flex items-center gap-1.5">
                        <span className="w-2 h-2 rounded-full bg-amber-400"></span>
                        3. 可能原因 (非確診結論)：
                      </div>
                      <ul className="space-y-1 text-stone-300 pl-4 list-disc">
                        {msg.content.possibleCauses.map((item, idx) => (
                          <li key={idx}>{item}</li>
                        ))}
                      </ul>
                    </div>

                    <div className="p-3 bg-stone-900/90 rounded-xl border border-stone-800/80">
                      <div className="font-bold text-white mb-1 flex items-center gap-1.5">
                        <span className="w-2 h-2 rounded-full bg-red-400"></span>
                        4. 尚缺資訊 (需人工現場確認項目)：
                      </div>
                      <ul className="space-y-1 text-stone-300 pl-4 list-disc">
                        {msg.content.missingInformation.map((item, idx) => (
                          <li key={idx}>{item}</li>
                        ))}
                      </ul>
                    </div>

                    <div className="p-3 bg-emerald-950/30 rounded-xl border border-emerald-800/60">
                      <div className="font-bold text-emerald-300 mb-1 flex items-center gap-1.5">
                        <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
                        5. 建議下一步 (安全規範與排程操作)：
                      </div>
                      <ul className="space-y-1 text-emerald-200 pl-4 list-disc">
                        {msg.content.suggestedNextSteps.map((item, idx) => (
                          <li key={idx}>{item}</li>
                        ))}
                      </ul>
                    </div>
                  </div>

                  <div className="text-[10px] text-stone-500 pt-1 border-t border-stone-800/60">
                    【農事安全守則】AI 助理之推論僅供現場觀察輔助，不得作為正式植物病理確診或法定用藥處方。任何藥劑使用請依農藥登記資料庫為準。
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
