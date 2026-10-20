import React from 'react';
import { Sprout, ShieldAlert, Layers, BookOpen, Compass, CheckCircle2, Calendar, ShoppingBag, Camera, Box, Terminal, FolderArchive, Globe2 } from 'lucide-react';

interface HeaderProps {
  activeTab: string;
  setActiveTab: (tab: string) => void;
}

export const Header: React.FC<HeaderProps> = ({ activeTab, setActiveTab }) => {
  const navItems = [
    { id: 'phase1_live', label: '🌱 第一階段 (Phase 1 核心)', icon: Sprout },
    { id: 'phase2_daily', label: '📅 第二階段 (Phase 2 日常協同)', icon: Calendar },
    { id: 'phase3_business', label: '🥬 第三階段 (Phase 3 採收結算與AI)', icon: ShoppingBag },
    { id: 'phase4_inspection', label: '📸 第四階段 (Phase 4 巡田品質閉環)', icon: Camera },
    { id: 'phase5_recon', label: '🧊 第五階段 (Phase 5 重建/AR/報表)', icon: Box },
    { id: 'phase6_fullstack', label: '🚀 第六階段 (Phase 6 實作與部署代碼)', icon: Terminal },
    { id: 'phase7_acceptance', label: '📦 第七階段 (Phase 7 驗收與匯出工廠)', icon: FolderArchive },
    { id: 'phase8_agri_hub', label: '🌐 第八階段 (Phase 8 公用資料與手冊)', icon: Globe2 },
    { id: 'spec', label: '1. 規劃與決策總表', icon: BookOpen },
    { id: 'arch', label: '2. 系統與雲端架構', icon: Layers },
    { id: 'domain', label: '3. 核心領域與資料模型', icon: Sprout },
    { id: 'state', label: '4. 四大狀態機驗證', icon: Compass },
    { id: 'simulator', label: '5. 里程碑一端到端模擬', icon: CheckCircle2 },
    { id: 'cost', label: '6. 成本用量與安全邊界', icon: ShieldAlert },
  ];

  return (
    <header className="bg-stone-900 border-b border-stone-800 text-stone-100 sticky top-0 z-50 shadow-md">
      {/* 頂部強制警示橫幅 */}
      <div className="bg-amber-950/80 border-b border-amber-800/60 px-4 py-2 text-xs text-amber-200 flex items-center justify-between">
        <div className="flex items-center gap-2 max-w-5xl">
          <ShieldAlert className="w-4 h-4 text-amber-400 shrink-0" />
          <span>
            <strong>【輔助設計原型，非正式產品】</strong>
            本頁全部為示範資料與模擬畫面，未連接任何後端，未經建置、測試或部署驗證；頁面中的農藥間隔、救助金額等數字未經查證。正式產品為 <strong>Flutter (Android/iOS)</strong> App 與私有後端，均尚未開始實作。
          </span>
        </div>
        <span className="hidden md:inline-block px-2 py-0.5 rounded bg-amber-900 text-amber-300 font-mono text-[11px]">
          v0.1.0-spec
        </span>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-emerald-700 border border-emerald-500/30 flex items-center justify-center shadow-inner">
              <Sprout className="w-6 h-6 text-emerald-200" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-xl font-bold tracking-tight text-white">農田日記</h1>
                <span className="text-xs px-2 py-0.5 rounded-full bg-emerald-950 text-emerald-400 border border-emerald-800 font-medium">
                  臺灣家庭農場協作系統
                </span>
              </div>
              <p className="text-xs text-stone-400">
                田區・土地關係・期作・資材・雇工派遣・作業履歷・巡田品質閉環
              </p>
            </div>
          </div>

          <div className="hidden lg:flex items-center gap-1 text-xs text-stone-400">
            <span className="inline-block w-2 h-2 rounded-full bg-emerald-500 mr-1 animate-pulse"></span>
            階段 0：架構草案，正式實作尚未開始
          </div>
        </div>

        {/* 標籤導航列 */}
        <nav className="flex space-x-1 overflow-x-auto py-2 scrollbar-none border-t border-stone-800/60">
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = activeTab === item.id;
            return (
              <button
                key={item.id}
                onClick={() => setActiveTab(item.id)}
                className={`flex items-center gap-2 px-3.5 py-1.5 rounded-lg text-xs font-medium whitespace-nowrap transition-colors ${
                  isActive
                    ? 'bg-emerald-800/80 text-emerald-100 border border-emerald-600/50 shadow-sm'
                    : 'text-stone-400 hover:text-stone-200 hover:bg-stone-800/50'
                }`}
              >
                <Icon className={`w-3.5 h-3.5 ${isActive ? 'text-emerald-300' : 'text-stone-500'}`} />
                {item.label}
              </button>
            );
          })}
        </nav>
      </div>
    </header>
  );
};
