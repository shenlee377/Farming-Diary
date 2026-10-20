import React, { useState } from 'react';
import {
  TaskStatus,
  StaffAssignmentStatus,
  InspectionQualityStatus,
  transitionTask,
  transitionStaffAssignment,
  transitionInspectionQuality,
  evaluateSprayingStatus,
} from '../domain/state_machines.ts';
import { Compass, UserCheck, ShieldAlert, Camera, ArrowRight, RefreshCw, CheckCircle, AlertCircle } from 'lucide-react';

export const StateMachinesView: React.FC = () => {
  // 1. 工作狀態機
  const [taskState, setTaskState] = useState<TaskStatus>('DRAFT');
  const [taskErr, setTaskErr] = useState<string | null>(null);

  // 2. 人員安排狀態機
  const [staffState, setStaffState] = useState<StaffAssignmentStatus>('UNCONTACTED');
  const [staffErr, setStaffErr] = useState<string | null>(null);

  // 3. 巡田採集閉環狀態機
  const [inspectionState, setInspectionState] = useState<InspectionQualityStatus>('LOCAL_SAVED');
  const [inspectionErr, setInspectionErr] = useState<string | null>(null);

  // 4. 施藥推論模擬
  const [hasExplicitRecord, setHasExplicitRecord] = useState<boolean>(false);
  const [sprayApplied, setSprayApplied] = useState<boolean>(false);
  const [isConfirmedByManager, setIsConfirmedByManager] = useState<boolean>(false);
  const [hasChemicalDetails, setHasChemicalDetails] = useState<boolean>(false);

  const handleTaskAction = (action: 'SCHEDULE' | 'START' | 'COMPLETE' | 'CANCEL' | 'REOPEN') => {
    try {
      setTaskErr(null);
      const next = transitionTask(taskState, action);
      setTaskState(next);
    } catch (e: any) {
      setTaskErr(e.message);
    }
  };

  const handleStaffAction = (action: 'CONTACT' | 'ACCEPT' | 'DECLINE' | 'CANCEL' | 'CHECK_IN' | 'FINISH') => {
    try {
      setStaffErr(null);
      const next = transitionStaffAssignment(staffState, action);
      setStaffState(next);
    } catch (e: any) {
      setStaffErr(e.message);
    }
  };

  const handleInspectionEvent = (
    event:
      | 'UPLOAD_FINISHED'
      | 'START_VALIDATION'
      | 'QUALITY_DEFECT_DETECTED'
      | 'QUALITY_APPROVED'
      | 'START_PROCESSING'
      | 'PROCESSING_FINISHED'
      | 'PROCESSING_PARTIAL'
      | 'ERROR_OCCURRED'
      | 'RETRY'
  ) => {
    try {
      setInspectionErr(null);
      const next = transitionInspectionQuality(inspectionState, event);
      setInspectionState(next);
    } catch (e: any) {
      setInspectionErr(e.message);
    }
  };

  const calculatedSprayStatus = evaluateSprayingStatus({
    hasExplicitRecord,
    sprayApplied,
    isConfirmedByManager,
    hasChemicalDetails,
  });

  return (
    <div className="space-y-8 pb-16">
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center gap-2 mb-2 text-emerald-400 font-bold">
          <Compass className="w-5 h-5" />
          <h3 className="text-base font-semibold">四核心狀態機互動驗證 (Interactive State Transition Engine)</h3>
        </div>
        <p className="text-xs text-stone-400">
          直接呼叫後端領域單元測試通過之純邏輯 (<code>src/domain/state_machines.ts</code>)，體驗嚴格受保護的業務狀態流轉。
        </p>
      </div>

      {/* 1. 工作狀態機 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h4 className="text-sm font-bold text-white flex items-center gap-2">
              <span className="w-2.5 h-2.5 rounded-full bg-blue-400"></span>
              狀態機 1：工作任務生命週期 (FarmTask Status)
            </h4>
            <p className="text-xs text-stone-400 mt-0.5">
              區分「工作計畫草案」與「正式排程派工」，未排程不可直接跳至完成。
            </p>
          </div>
          <span className="px-3 py-1 rounded-full text-xs font-mono font-bold bg-blue-950 text-blue-300 border border-blue-800">
            目前狀態：{taskState}
          </span>
        </div>

        {taskErr && (
          <div className="p-3 bg-red-950/60 border border-red-800 rounded-xl text-xs text-red-300 flex items-center gap-2">
            <AlertCircle className="w-4 h-4 shrink-0" />
            <span>{taskErr}</span>
          </div>
        )}

        <div className="flex flex-wrap gap-2 pt-2">
          <button
            onClick={() => handleTaskAction('SCHEDULE')}
            className="px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700 text-xs font-medium text-stone-200 border border-stone-700"
          >
            排入日程 (SCHEDULE)
          </button>
          <button
            onClick={() => handleTaskAction('START')}
            className="px-3 py-1.5 rounded-lg bg-blue-900/60 hover:bg-blue-800 text-xs font-medium text-blue-200 border border-blue-700"
          >
            現場開始 (START)
          </button>
          <button
            onClick={() => handleTaskAction('COMPLETE')}
            className="px-3 py-1.5 rounded-lg bg-emerald-900/60 hover:bg-emerald-800 text-xs font-medium text-emerald-200 border border-emerald-700"
          >
            作業完成 (COMPLETE)
          </button>
          <button
            onClick={() => handleTaskAction('CANCEL')}
            className="px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700 text-xs font-medium text-red-300 border border-stone-700"
          >
            取消作業 (CANCEL)
          </button>
          <button
            onClick={() => setTaskState('DRAFT')}
            className="px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700 text-xs font-medium text-stone-400"
          >
            重置回草稿
          </button>
        </div>
      </div>

      {/* 2. 人員安排狀態機 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h4 className="text-sm font-bold text-white flex items-center gap-2">
              <UserCheck className="w-4 h-4 text-emerald-400" />
              狀態機 2：人員安排與雇工出勤 (Staff Assignment)
            </h4>
            <p className="text-xs text-stone-400 mt-0.5">
              <strong>核心鐵律：</strong>「打過電話」不等於「已答應出席」，必須等待本人確認，到場後再簽到。
            </p>
          </div>
          <span className="px-3 py-1 rounded-full text-xs font-mono font-bold bg-emerald-950 text-emerald-300 border border-emerald-800">
            目前狀態：{staffState}
          </span>
        </div>

        {staffErr && (
          <div className="p-3 bg-red-950/60 border border-red-800 rounded-xl text-xs text-red-300 flex items-center gap-2">
            <AlertCircle className="w-4 h-4 shrink-0" />
            <span>{staffErr}</span>
          </div>
        )}

        <div className="flex flex-wrap gap-2 pt-2">
          <button
            onClick={() => handleStaffAction('CONTACT')}
            className="px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700 text-xs font-medium text-amber-300 border border-stone-700"
          >
            打電話聯繫 (CONTACT) → 已聯繫待回覆
          </button>
          <button
            onClick={() => handleStaffAction('ACCEPT')}
            className="px-3 py-1.5 rounded-lg bg-emerald-900/60 hover:bg-emerald-800 text-xs font-medium text-emerald-200 border border-emerald-700"
          >
            對方親口答應 (ACCEPT) → 已答應
          </button>
          <button
            onClick={() => handleStaffAction('CHECK_IN')}
            className="px-3 py-1.5 rounded-lg bg-blue-900/60 hover:bg-blue-800 text-xs font-medium text-blue-200 border border-blue-700"
          >
            當日現場到場 (CHECK_IN) → 已到場
          </button>
          <button
            onClick={() => handleStaffAction('FINISH')}
            className="px-3 py-1.5 rounded-lg bg-emerald-800 hover:bg-emerald-700 text-xs font-medium text-white"
          >
            工時完成結算 (FINISH) → 已完成
          </button>
          <button
            onClick={() => handleStaffAction('DECLINE')}
            className="px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700 text-xs font-medium text-stone-300 border border-stone-700"
          >
            無法出席 (DECLINE)
          </button>
          <button
            onClick={() => setStaffState('UNCONTACTED')}
            className="px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700 text-xs font-medium text-stone-400"
          >
            重置
          </button>
        </div>
      </div>

      {/* 3. 施藥查驗狀態推論 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h4 className="text-sm font-bold text-white flex items-center gap-2">
              <ShieldAlert className="w-4 h-4 text-amber-400" />
              狀態推論 3：農藥施用安全狀態判定 (Spraying Verification)
            </h4>
            <p className="text-xs text-stone-400 mt-0.5">
              嚴防空泛臆測：沒有施藥紀錄絕不可推論為沒有施用！
            </p>
          </div>
          <span
            className={`px-3 py-1 rounded-full text-xs font-mono font-bold border ${
              calculatedSprayStatus === 'CONFIRMED_NOT_APPLIED'
                ? 'bg-emerald-950 text-emerald-300 border-emerald-800'
                : calculatedSprayStatus === 'APPLIED'
                ? 'bg-blue-950 text-blue-300 border-blue-800'
                : 'bg-amber-950 text-amber-300 border-amber-800'
            }`}
          >
            判定結果：{calculatedSprayStatus}
          </span>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 bg-stone-950 p-4 rounded-xl border border-stone-800 text-xs">
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              checked={hasExplicitRecord}
              onChange={(e) => setHasExplicitRecord(e.target.checked)}
              className="rounded bg-stone-800 border-stone-700 text-emerald-600 focus:ring-0"
            />
            <span className="text-stone-300">有填寫明確作業紀錄</span>
          </label>
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              checked={sprayApplied}
              onChange={(e) => setSprayApplied(e.target.checked)}
              className="rounded bg-stone-800 border-stone-700 text-emerald-600 focus:ring-0"
            />
            <span className="text-stone-300">有施用藥劑 (未勾選代表未施用)</span>
          </label>
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              checked={hasChemicalDetails}
              onChange={(e) => setHasChemicalDetails(e.target.checked)}
              className="rounded bg-stone-800 border-stone-700 text-emerald-600 focus:ring-0"
            />
            <span className="text-stone-300">藥品規格與稀釋倍數完整</span>
          </label>
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              checked={isConfirmedByManager}
              onChange={(e) => setIsConfirmedByManager(e.target.checked)}
              className="rounded bg-stone-800 border-stone-700 text-emerald-600 focus:ring-0"
            />
            <span className="text-stone-300">管理者親自核對切結</span>
          </label>
        </div>
      </div>

      {/* 4. 巡田採集閉環狀態機 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h4 className="text-sm font-bold text-white flex items-center gap-2">
              <Camera className="w-4 h-4 text-purple-400" />
              狀態機 4：單手機巡田採集與雲端品質九階段閉環 (Inspection Loop)
            </h4>
            <p className="text-xs text-stone-400 mt-0.5">
              「上傳完成」不等於「採集通過」；「採集通過」不等於「成果可用」。
            </p>
          </div>
          <span className="px-3 py-1 rounded-full text-xs font-mono font-bold bg-purple-950 text-purple-300 border border-purple-800">
            階段：{inspectionState}
          </span>
        </div>

        {inspectionErr && (
          <div className="p-3 bg-red-950/60 border border-red-800 rounded-xl text-xs text-red-300 flex items-center gap-2">
            <AlertCircle className="w-4 h-4 shrink-0" />
            <span>{inspectionErr}</span>
          </div>
        )}

        <div className="flex flex-wrap gap-2 pt-2">
          <button
            onClick={() => handleInspectionEvent('UPLOAD_FINISHED')}
            className="px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700 text-xs font-medium text-stone-200 border border-stone-700"
          >
            上傳至 GCS 完成 (SERVER_RECEIVED)
          </button>
          <button
            onClick={() => handleInspectionEvent('START_VALIDATION')}
            className="px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700 text-xs font-medium text-blue-300 border border-stone-700"
          >
            觸發雲端覆蓋檢核 (VALIDATING)
          </button>
          <button
            onClick={() => handleInspectionEvent('QUALITY_DEFECT_DETECTED')}
            className="px-3 py-1.5 rounded-lg bg-amber-950/80 hover:bg-amber-900 text-xs font-medium text-amber-200 border border-amber-800"
          >
            偵測到重要遮擋 (發布補拍任務 RESHOOT_REQUIRED)
          </button>
          <button
            onClick={() => handleInspectionEvent('QUALITY_APPROVED')}
            className="px-3 py-1.5 rounded-lg bg-emerald-900/60 hover:bg-emerald-800 text-xs font-medium text-emerald-200 border border-emerald-700"
          >
            採集檢核通過 (PASSED)
          </button>
          <button
            onClick={() => handleInspectionEvent('START_PROCESSING')}
            className="px-3 py-1.5 rounded-lg bg-purple-900/60 hover:bg-purple-800 text-xs font-medium text-purple-200 border border-purple-700"
          >
            啟動後續成果分析 (PROCESSING)
          </button>
          <button
            onClick={() => handleInspectionEvent('PROCESSING_FINISHED')}
            className="px-3 py-1.5 rounded-lg bg-emerald-800 hover:bg-emerald-700 text-xs font-medium text-white"
          >
            成果產出就緒 (READY)
          </button>
          <button
            onClick={() => setInspectionState('LOCAL_SAVED')}
            className="px-3 py-1.5 rounded-lg bg-stone-800 hover:bg-stone-700 text-xs font-medium text-stone-400"
          >
            重置
          </button>
        </div>
      </div>
    </div>
  );
};
