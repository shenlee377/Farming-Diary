import React, { useState } from 'react';
import { Header } from './components/Header.tsx';
import { SpecOverviewView } from './components/SpecOverviewView.tsx';
import { ArchitectureView } from './components/ArchitectureView.tsx';
import { DomainModelView } from './components/DomainModelView.tsx';
import { StateMachinesView } from './components/StateMachinesView.tsx';
import { MilestoneSimulator } from './components/MilestoneSimulator.tsx';
import { CostAndSecurityView } from './components/CostAndSecurityView.tsx';
import { BrandDesignView } from './components/BrandDesignView.tsx';

import { Phase1LiveWorkspace } from './components/Phase1LiveWorkspace.tsx';
import { Phase2DailyOperations } from './components/Phase2DailyOperations.tsx';
import { Phase3BusinessAndAI } from './components/Phase3BusinessAndAI.tsx';
import { Phase4InspectionQualityLoop } from './components/Phase4InspectionQualityLoop.tsx';
import { Phase5ReconstructionAndReports } from './components/Phase5ReconstructionAndReports.tsx';
import { Phase6FullStackDeployment } from './components/Phase6FullStackDeployment.tsx';
import { Phase7AcceptanceAndExporter } from './components/Phase7AcceptanceAndExporter.tsx';
import { Phase8AgriDataAndManual } from './components/Phase8AgriDataAndManual.tsx';

export default function App() {
  const [activeTab, setActiveTab] = useState<string>('spec');

  return (
    <div className="min-h-screen bg-stone-950 text-stone-100 flex flex-col font-sans selection:bg-emerald-800 selection:text-white">
      {/* 導航標頭與聲明橫幅 */}
      <Header activeTab={activeTab} setActiveTab={setActiveTab} />

      {/* 主內容區塊 */}
      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 pt-8">
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
