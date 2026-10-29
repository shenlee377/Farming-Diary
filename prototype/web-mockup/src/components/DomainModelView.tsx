import React from 'react';
import { Database, Layers, ArrowRight, ShieldCheck, AlertCircle } from 'lucide-react';

export const DomainModelView: React.FC = () => {
  return (
    <div className="space-y-6 pb-16">
      {/* 領域模型概覽卡片 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center gap-2 mb-2 text-emerald-400 font-bold">
          <Database className="w-5 h-5" />
          <h3 className="text-base font-semibold">核心領域實體關係 (Domain Entity Relationship & Schema)</h3>
        </div>
        <p className="text-xs text-stone-400 leading-relaxed">
          拒絕「萬用大 JSON 表」的反模式架構。我們將核心農務實體拆分為清楚、強型別且具備外鍵關聯完整性約束的關聯資料結構。
        </p>

        {/* 實體關聯圖 ASCII / Mermaid 呈現 */}
        <div className="mt-4 bg-stone-950 p-5 rounded-xl border border-stone-800 font-mono text-xs text-emerald-300/90 overflow-x-auto">
          <pre className="leading-relaxed">{`
 [Workspace (工作空間)] ──<1:N>── [WorkspaceMember (成員/角色權限)]
        │
        ├──<1:N>── [WorkContact (現場聯絡人/外部雇工，可無 App 帳號)]
        │
        └──<1:N>── [Field (田區/慣用稱呼/集合點)]
                     │
                     ├──<1:1>── [LandRelationship (土地共有/租賃/未查證標記)]
                     │
                     ├──<M:N>── [CadastralParcel (地籍地號，如雲林西螺公館段0451號)]
                     │
                     ├──<1:N>── [FieldBoundaryVersion (邊界版本/來源標記/經緯多邊形)]
                     │
                     └──<1:N>── [CropSeason (期作/品種/苗來源/休耕標記)]
                                  │
                                  ├──<1:N>── [FarmTask (工作計畫/派工)]
                                  │            │
                                  │            └──<1:N>── [TaskAssignment (人員出席狀態/工資快照)]
                                  │
                                  ├──<1:N>── [FarmWorkLog (實際農務回報)]
                                  │            │
                                  │            ├──<1:N>── [MaterialUsage (資材/原文俗稱換算)]
                                  │            │
                                  │            └──<1:1>── [SprayingRecord (施藥完整查證狀態)]
                                  │
                                  └──<1:N>── [InspectionSession (巡田工作階段)]
                                               │
                                               └──<1:N>── [ReshootTask (補拍任務/遮擋處理)]
          `}</pre>
        </div>
      </div>

      {/* 重點欄位設計細節 */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* 田區與土地關係 */}
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
          <div className="flex items-center justify-between">
            <h4 className="text-sm font-bold text-white flex items-center gap-1.5">
              <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
              田區 (Field) 與土地共有關係
            </h4>
            <span className="text-[0.6875rem] px-2 py-0.5 rounded bg-stone-800 text-stone-300 border border-stone-700">
              多對多地號關聯
            </span>
          </div>
          <p className="text-xs text-stone-400 leading-relaxed">
            管理邊界（農民日常指稱的田邊）不等於正式地政地籍線。一塊管理田區常橫跨多筆地籍地號，或與多位地主共同承租。
          </p>
          <div className="bg-stone-950 p-3.5 rounded-xl border border-stone-800/80 text-xs font-mono space-y-1 text-stone-300">
            <div><span className="text-emerald-400">verification_status</span>: 'SELF_REPORTED_UNVERIFIED' | 'CONFIRMED'</div>
            <div><span className="text-emerald-400">cadastral_parcels</span>: 縣市段號多對多關聯</div>
            <div><span className="text-emerald-400">special_agreements</span>: 包含水權水圳分配、田菁輪作約定</div>
            <div className="text-amber-400/90 text-[0.6875rem] pt-1">
              ⚠️ 法律邊界保護：App 介面自填地主資料一律標示為「自填尚未經地政查證」，避免法律爭議。
            </div>
          </div>
        </div>

        {/* 農事紀錄與資材換算 */}
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
          <div className="flex items-center justify-between">
            <h4 className="text-sm font-bold text-white flex items-center gap-1.5">
              <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
              農事紀錄與資材俗稱換算 (Materials)
            </h4>
            <span className="text-[0.6875rem] px-2 py-0.5 rounded bg-stone-800 text-stone-300 border border-stone-700">
              事實留存原則
            </span>
          </div>
          <p className="text-xs text-stone-400 leading-relaxed">
            長輩回報資材時常說「用了一包半」或「兩桶」。系統必須先完整留存原始口語原文，只有在規格確認時才換算公斤數。
          </p>
          <div className="bg-stone-950 p-3.5 rounded-xl border border-stone-800/80 text-xs font-mono space-y-1 text-stone-300">
            <div><span className="text-emerald-400">raw_input_quantity_text</span>: "一包半" (原始說法不可遺失)</div>
            <div><span className="text-emerald-400">is_specification_confirmed</span>: false → true</div>
            <div><span className="text-emerald-400">standard_amount_kg</span>: 60.0 (40kg * 1.5，確認後才填入)</div>
            <div className="text-emerald-400/90 text-[0.6875rem] pt-1">
              ✓ 杜絕負庫存：庫存扣抵採先入先出 (FIFO) 批次異動追蹤，不允許任意覆蓋數值。
            </div>
          </div>
        </div>

        {/* 外部工作聯絡人 */}
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
          <div className="flex items-center justify-between">
            <h4 className="text-sm font-bold text-white flex items-center gap-1.5">
              <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
              外部工作聯絡人 (WorkContact)
            </h4>
            <span className="text-[0.6875rem] px-2 py-0.5 rounded bg-stone-800 text-stone-300 border border-stone-700">
              免裝 App 支援
            </span>
          </div>
          <p className="text-xs text-stone-400 leading-relaxed">
            臺灣農村長輩與臨時工班通常不願意安裝新 App 或申請電子郵件。系統支援外部聯絡人資料庫，由家庭管理者代為記錄與電話聯絡。
          </p>
          <div className="bg-stone-950 p-3.5 rounded-xl border border-stone-800/80 text-xs font-mono space-y-1 text-stone-300">
            <div><span className="text-emerald-400">has_app_account</span>: false (獨立於系統登入帳號)</div>
            <div><span className="text-emerald-400">work_restrictions</span>: "不能久跪、不提重" (工作安全保護)</div>
            <div><span className="text-emerald-400">rate_snapshot_twd</span>: 派工當下費率快照 (避免日後工資調整產生爭端)</div>
          </div>
        </div>

        {/* 施藥狀態嚴格判定 */}
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
          <div className="flex items-center justify-between">
            <h4 className="text-sm font-bold text-white flex items-center gap-1.5">
              <span className="w-2 h-2 rounded-full bg-red-400"></span>
              施藥狀態嚴謹查驗 (Spraying Safety)
            </h4>
            <span className="text-[0.6875rem] px-2 py-0.5 rounded bg-red-950 text-red-300 border border-red-800">
              安全採收期防線
            </span>
          </div>
          <p className="text-xs text-stone-400 leading-relaxed">
            關乎食品安全與安全採收期。<strong>「沒有施藥紀錄」絕對不可推論為「沒有施用」</strong>，避免造成殘留超標或誤認產銷履歷驗證。
          </p>
          <div className="bg-stone-950 p-3.5 rounded-xl border border-stone-800/80 text-xs font-mono space-y-1 text-stone-300">
            <div><span className="text-red-400">PENDING_CONFIRMATION</span>: 無紀錄時強制顯示待確認</div>
            <div><span className="text-amber-400">INCOMPLETE_RECORD</span>: 有施藥但劑型或品名不清</div>
            <div><span className="text-emerald-400">CONFIRMED_NOT_APPLIED</span>: 經管理者人工切結確認未施用</div>
            <div><span className="text-emerald-400">APPLIED</span>: 完整品項、倍數、稀釋量與安全採收天數查驗</div>
          </div>
        </div>
      </div>
    </div>
  );
};
