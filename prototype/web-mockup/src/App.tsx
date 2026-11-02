import React, { Suspense, lazy, useState } from 'react';
import { Header } from './components/Header.tsx';
// 各頁籤按需載入，避免首次開啟就下載全部頁面（原本單一 bundle 約 550 KB）
const SpecOverviewView = lazy(() => import('./components/SpecOverviewView.tsx').then((m) => ({ default: m.SpecOverviewView })));
const ArchitectureView = lazy(() => import('./components/ArchitectureView.tsx').then((m) => ({ default: m.ArchitectureView })));
const DomainModelView = lazy(() => import('./components/DomainModelView.tsx').then((m) => ({ default: m.DomainModelView })));
const StateMachinesView = lazy(() => import('./components/StateMachinesView.tsx').then((m) => ({ default: m.StateMachinesView })));
const MilestoneSimulator = lazy(() => import('./components/MilestoneSimulator.tsx').then((m) => ({ default: m.MilestoneSimulator })));
const CostAndSecurityView = lazy(() => import('./components/CostAndSecurityView.tsx').then((m) => ({ default: m.CostAndSecurityView })));
const BrandDesignView = lazy(() => import('./components/BrandDesignView.tsx').then((m) => ({ default: m.BrandDesignView })));
const Phase1LiveWorkspace = lazy(() => import('./components/Phase1LiveWorkspace.tsx').then((m) => ({ default: m.Phase1LiveWorkspace })));
const Phase2DailyOperations = lazy(() => import('./components/Phase2DailyOperations.tsx').then((m) => ({ default: m.Phase2DailyOperations })));
const Phase3BusinessAndAI = lazy(() => import('./components/Phase3BusinessAndAI.tsx').then((m) => ({ default: m.Phase3BusinessAndAI })));
const Phase4InspectionQualityLoop = lazy(() => import('./components/Phase4InspectionQualityLoop.tsx').then((m) => ({ default: m.Phase4InspectionQualityLoop })));
const Phase5ReconstructionAndReports = lazy(() => import('./components/Phase5ReconstructionAndReports.tsx').then((m) => ({ default: m.Phase5ReconstructionAndReports })));
const Phase6FullStackDeployment = lazy(() => import('./components/Phase6FullStackDeployment.tsx').then((m) => ({ default: m.Phase6FullStackDeployment })));
const Phase7AcceptanceAndExporter = lazy(() => import('./components/Phase7AcceptanceAndExporter.tsx').then((m) => ({ default: m.Phase7AcceptanceAndExporter })));
const Phase8AgriDataAndManual = lazy(() => import('./components/Phase8AgriDataAndManual.tsx').then((m) => ({ default: m.Phase8AgriDataAndManual })));

export default function App() {
  const [activeTab, setActiveTab] = useState<string>('spec');

  return (
    <div className="min-h-screen bg-stone-950 text-stone-100 flex flex-col font-sans selection:bg-emerald-800 selection:text-white">
      {/* 導航標頭與聲明橫幅 */}
      <Header activeTab={activeTab} setActiveTab={setActiveTab} />

      {/* 主內容區塊 */}
      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 pt-8">
        <Suspense fallback={<div className="py-16 text-center text-sm text-stone-400">載入中…</div>}>
        {activeTab === 'phase1_live' && <Phase1LiveWorkspace />}
        {activeTab === 'phase2_daily' && <Phase2DailyOperations />}
        {activeTab === 'phase3_business' && <Phase3BusinessAndAI />}
        {activeTab === 'phase4_inspection' && <Phase4InspectionQualityLoop />}
        {activeTab === 'phase5_recon' && <Phase5ReconstructionAndReports />}
        {activeTab === 'phase6_fullstack' && <Phase6FullStackDeployment />}
        {activeTab === 'phase7_acceptance' && <Phase7AcceptanceAndExporter />}
        {activeTab === 'phase8_agri_hub' && <Phase8AgriDataAndManual />}
        {activeTab === 'spec' && <SpecOverviewView />}
        {activeTab === 'arch' && <ArchitectureView />}
        {activeTab === 'domain' && <DomainModelView />}
        {activeTab === 'state' && <StateMachinesView />}
        {activeTab === 'simulator' && <MilestoneSimulator />}
        {activeTab === 'cost' && (
          <div className="space-y-8">
            <CostAndSecurityView />
            <BrandDesignView />
          </div>
        )}
        </Suspense>
      </main>

      {/* 頁尾 */}
      <footer className="border-t border-stone-800/80 bg-stone-900/60 py-6 mt-auto">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col sm:flex-row items-center justify-between text-xs text-stone-400 gap-3">
          <div className="flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
            <span>農田日記 (Farmland Diary) 協作規劃小組</span>
          </div>
          <div>
            架構階段 0 成果交付・待使用者審查確認後啟動里程碑一實作
          </div>
        </div>
      </footer>
    </div>
  );
}
