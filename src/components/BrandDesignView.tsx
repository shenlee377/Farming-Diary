import React from 'react';
import { Palette, Sun, Eye, Smartphone, Check } from 'lucide-react';

export const BrandDesignView: React.FC = () => {
  return (
    <div className="space-y-6 pb-16">
      {/* 品牌理念與三個方向 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center gap-2 mb-2 text-emerald-400 font-bold">
          <Palette className="w-5 h-5" />
          <h3 className="text-base font-semibold">品牌視覺定位與三大方向提案 (Brand Identity Directions)</h3>
        </div>
        <p className="text-xs text-stone-400 leading-relaxed mb-6">
          核心原則：<strong>臺灣農田、日常紀錄、家庭協作、親切、清楚、可信</strong>。
          絕不把無人機當唯一品牌主體、未確認作物前不限定為稻米、不把四個中文字硬塞進小圖示、不做浮誇科技儀表板。
        </p>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {/* 方向一 (推薦) */}
          <div className="bg-emerald-950/30 border-2 border-emerald-600/70 rounded-2xl p-5 relative space-y-3">
            <span className="absolute top-3 right-3 text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-600 text-white">
              主要推薦 ⭐
            </span>
            <div className="w-12 h-12 rounded-xl bg-emerald-800 border border-emerald-500/40 flex items-center justify-center text-emerald-200">
              <svg className="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                <path d="M12 6v6" />
                <path d="M9 9l3-3 3 3" />
              </svg>
            </div>
            <h4 className="text-sm font-bold text-white">方向一：臺灣沃土與秧苗日記 (Earth & Sprout Note)</h4>
            <p className="text-xs text-stone-300 leading-relaxed">
              以一本親切的厚實農作日記本為外形，書脊翻開處萌生一株堅韌舒展的雙葉幼苗，底色融入臺灣濁水溪沖積平原的深厚黑沃土與秧苗翠綠。象徵記錄每一步耕耘、生命在此扎根。
            </p>
          </div>

          {/* 方向二 */}
          <div className="bg-stone-950 border border-stone-800 rounded-2xl p-5 space-y-3">
            <div className="w-12 h-12 rounded-xl bg-stone-800 border border-stone-700 flex items-center justify-center text-stone-300">
              <svg className="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <polygon points="12 2 2 7 12 12 22 7 12 2"><polyline points="2 17 12 22 22 17" /><polyline points="2 12 12 17 22 12" /></polygon>
              </svg>
            </div>
            <h4 className="text-sm font-bold text-white">方向二：田埂幾何與地塊協作 (Field Contours)</h4>
            <p className="text-xs text-stone-400 leading-relaxed">
              由三道高低起伏的梯田與田埂線條交錯組成，代表土地管理、期作更迭與家庭世代協作，線條流暢質樸，具備強烈的地理輪廓識別。
            </p>
          </div>

          {/* 方向三 */}
          <div className="bg-stone-950 border border-stone-800 rounded-2xl p-5 space-y-3">
            <div className="w-12 h-12 rounded-xl bg-stone-800 border border-stone-700 flex items-center justify-center text-stone-300">
              <svg className="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <circle cx="12" cy="12" r="5" />
                <line x1="12" y1="1" x2="12" y2="3" />
                <line x1="12" y1="21" x2="12" y2="23" />
                <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" />
                <line x1="18.36" y1="18.36" x2="19.78" y2="19.78" />
              </svg>
            </div>
            <h4 className="text-sm font-bold text-white">方向三：晨曦朝露與日程晨會 (Dawn & Calendar)</h4>
            <p className="text-xs text-stone-400 leading-relaxed">
              以晨光初破曉照耀田野的圓形意象，結合日曆網格中一個清晰打勾的節奏，強調農村清晨開工、家庭成員互相交代的安心感。
            </p>
          </div>
        </div>
      </div>

      {/* 戶外日照與長輩友善 UI 設計原則 */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
          <div className="flex items-center gap-2 text-amber-400 font-bold text-sm">
            <Sun className="w-4 h-4" />
            <span>戶外烈日操作防眩光與高對比規範</span>
          </div>
          <ul className="space-y-2 text-xs text-stone-300 leading-relaxed">
            <li>• <strong>高色彩對比度：</strong>WCAG AAA 級別高對比文本（正文對比度大於 7:1），避免使用淺灰細字。</li>
            <li>• <strong>加大觸控熱區：</strong>田間主要操作按鈕高度至少 <strong>52dp / 52px</strong>，間距大於 12dp，支援長輩戴農務手套操作。</li>
            <li>• <strong>不單依賴色彩傳遞：</strong>所有狀態（如「已答應」、「待回覆」）一律「圖示 + 完整中文文字」雙重呈現。</li>
          </ul>
        </div>

        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
          <div className="flex items-center gap-2 text-emerald-400 font-bold text-sm">
            <Eye className="w-4 h-4" />
            <span>字級縮放與首頁架構設計代碼</span>
          </div>
          <ul className="space-y-2 text-xs text-stone-300 leading-relaxed">
            <li>• <strong>動態字級支援：</strong>完全支援 iOS Dynamic Type 與 Android 系統字級縮放（最大 150% 佈局不破圖）。</li>
            <li>• <strong>首頁五大核心看板：</strong>「我的田」、「今天要做」、「等我確認」、「最近異常」、「問農務助理」。</li>
            <li>• <strong>語音回報優先：</strong>戶外回報提供一鍵錄音，免除長輩汗流浹背時在田間長篇打字的痛點。</li>
          </ul>
        </div>
      </div>
    </div>
  );
};
