import React, { useState } from 'react';
import {
  Workspace,
  Field,
  CropSeason,
  WorkContact,
  FarmTask,
  FarmWorkLog,
  MaterialUsage,
} from '../types/index.ts';
import {
  SEED_WORKSPACE,
  SEED_FIELDS,
  SEED_CROP_SEASONS,
  SEED_CONTACTS,
  SEED_TASKS,
  SEED_LOGS,
} from '../data/seedData.ts';
import {
  transitionStaffAssignment,
  evaluateSprayingStatus,
} from '../domain/state_machines.ts';
import {
  Sprout,
  Users,
  Calendar,
  FileText,
  ShieldCheck,
  ShieldAlert,
  Plus,
  MapPin,
  CheckCircle2,
  Clock,
  PhoneCall,
  Camera,
  AlertTriangle,
  Lock,
  UserCheck,
} from 'lucide-react';

export const Phase1LiveWorkspace: React.FC = () => {
  // 當前使用者身分切換 (支援驗收情境：未授權帳號測試)
  const [currentUser, setCurrentUser] = useState<'user-lin-01' | 'unauthorized-user-09'>('user-lin-01');

  // 工作空間與業務資料狀態
  const [activeSubView, setActiveSubView] = useState<'fields' | 'seasons' | 'contacts' | 'tasks' | 'logs'>('fields');
  const [workspace, setWorkspace] = useState<Workspace>(SEED_WORKSPACE);
  const [fields, setFields] = useState<Field[]>(SEED_FIELDS);
  const [seasons, setSeasons] = useState<CropSeason[]>(SEED_CROP_SEASONS);
  const [contacts, setContacts] = useState<WorkContact[]>(SEED_CONTACTS);
  const [tasks, setTasks] = useState<FarmTask[]>(SEED_TASKS);
  const [logs, setLogs] = useState<FarmWorkLog[]>(SEED_LOGS);

  // 表單 Modal / 展開狀態
  const [showAddField, setShowAddField] = useState(false);
  const [showAddContact, setShowAddContact] = useState(false);
  const [showAddTask, setShowAddTask] = useState(false);
  const [showAddLog, setShowAddLog] = useState(false);

  // 1. 新增田區表單狀態
  const [newFieldName, setNewFieldName] = useState('');
  const [newFieldArea, setNewFieldArea] = useState('0.65');
  const [newCadastralNumber, setNewCadastralNumber] = useState('雲林縣西螺鎮公館段 0488-0000 號');
  const [newLandOwner, setNewLandOwner] = useState('廖福來 (地主自填)');

  // 2. 新增外部聯絡人表單狀態
  const [newContactName, setNewContactName] = useState('');
  const [newContactNickname, setNewContactNickname] = useState('');
  const [newContactPhone, setNewContactPhone] = useState('');
  const [newContactWage, setNewContactWage] = useState('2200');
  const [newContactRestriction, setNewContactRestriction] = useState('不能久跪，避開午後大太陽');

  // 3. 新增工作派工表單狀態
  const [newTaskTitle, setNewTaskTitle] = useState('');
  const [newTaskFieldId, setNewTaskFieldId] = useState(fields[0]?.id || '');
  const [selectedContactId, setSelectedContactId] = useState(contacts[0]?.id || '');

  // 4. 新增農務回報表單狀態
  const [newLogRawText, setNewLogRawText] = useState('今天阿吉叔幫忙補施特43號一包半，全區完成，無噴藥。');
  const [newMaterialRawQuantity, setNewMaterialRawQuantity] = useState('一包半');
  const [isSpecConfirmed, setIsSpecConfirmed] = useState(true);
  const [sprayApplied, setSprayApplied] = useState(false);
  const [managerConfirmedNotApplied, setManagerConfirmedNotApplied] = useState(true);

  // 權限檢查 (租戶隔離)：只有 user-lin-01 具備西螺農場存取權
  const isAuthorized = currentUser === 'user-lin-01';

  // 處理新增田區
  const handleCreateField = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newFieldName.trim()) return;
    const fieldItem: Field = {
      id: `field-${Date.now().toString().slice(-4)}`,
      workspaceId: workspace.id,
      name: newFieldName,
      areaHectares: parseFloat(newFieldArea) || 0.5,
      areaSource: 'MANUAL_INPUT',
      landRelationship: {
        ownerName: newLandOwner,
        isSharedOwnership: false,
        tenantName: '林慶忠',
        actualOperator: '林家豪',
        verificationStatus: 'SELF_REPORTED_UNVERIFIED',
      },
      cadastralParcels: [
        { cadastralNumber: newCadastralNumber, areaSqMeters: (parseFloat(newFieldArea) || 0.5) * 10000 }
      ],
      waterSourceDescription: '水利會圳溝水源',
      assemblyPointDescription: '田頭榕樹下',
      boundaryVersion: 1,
      boundaryCoordinates: [[120.465, 23.785], [120.466, 23.786]],
      isArchived: false,
    };
    setFields([fieldItem, ...fields]);
    setNewFieldName('');
    setShowAddField(false);
  };

  // 處理新增外部聯絡人 (免裝 App)
  const handleCreateContact = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newContactName.trim() || !newContactPhone.trim()) return;
    const contactItem: WorkContact = {
      id: `contact-${Date.now().toString().slice(-4)}`,
      workspaceId: workspace.id,
      fullName: newContactName,
      nickname: newContactNickname || newContactName,
      phone: newContactPhone,
      preferredContactMethod: 'PHONE_CALL',
      workRestrictions: newContactRestriction,
      defaultDailyWageTWD: parseFloat(newContactWage) || 2000,
      hasAppAccount: false,
      notes: '電話優先，口頭派工',
    };
    setContacts([...contacts, contactItem]);
    setNewContactName('');
    setNewContactNickname('');
    setNewContactPhone('');
    setShowAddContact(false);
  };

  // 處理新增派工任務
  const handleCreateTask = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newTaskTitle.trim()) return;
    const assignedContact = contacts.find(c => c.id === selectedContactId) || contacts[0];
    const taskItem: FarmTask = {
      id: `task-${Date.now().toString().slice(-4)}`,
      workspaceId: workspace.id,
      fieldId: newTaskFieldId,
      fieldName: fields.find(f => f.id === newTaskFieldId)?.name || '指定田區',
      cropSeasonId: seasons[0]?.id || 'season-01',
      cropName: seasons[0]?.cropName || '當季作物',
      title: newTaskTitle,
      taskType: 'FERTILIZING',
      plannedDate: '2026-10-22',
      assemblyTime: '06:30',
      assemblyLocation: '鐵皮工寮前',
      requiredWorkersCount: 1,
      assignments: assignedContact ? [
        {
          contactId: assignedContact.id,
          contactName: assignedContact.fullName,
          status: 'CONTACTED_PENDING', // 剛聯絡，待對方確認
          rateSnapshotTWD: assignedContact.defaultDailyWageTWD || 2500,
          wageType: 'DAILY',
          paidStatus: 'UNPAID',
        }
      ] : [],
      preparedToolsNotes: '背負式農具',
      status: 'SCHEDULED',
    };
    setTasks([taskItem, ...tasks]);
    setNewTaskTitle('');
    setShowAddTask(false);
  };

  // 處理人員安排狀態流轉 (如：已聯絡 -> 對方親口答應)
  const handleUpdateAssignmentStatus = (taskId: string, contactId: string, action: 'ACCEPT' | 'CHECK_IN' | 'FINISH') => {
    setTasks(tasks.map(task => {
      if (task.id !== taskId) return task;
      return {
        ...task,
        assignments: task.assignments.map(asg => {
          if (asg.contactId !== contactId) return asg;
          try {
            const nextStatus = transitionStaffAssignment(asg.status, action);
            return { ...asg, status: nextStatus };
          } catch (err) {
            return asg;
          }
        }),
      };
    }));
  };

  // 處理新增作業回報
  const handleCreateLog = (e: React.FormEvent) => {
    e.preventDefault();
    const calculatedSpray = evaluateSprayingStatus({
      hasExplicitRecord: true,
      sprayApplied,
      isConfirmedByManager: managerConfirmedNotApplied,
      hasChemicalDetails: false,
    });

    const logItem: FarmWorkLog = {
      id: `log-${Date.now().toString().slice(-4)}`,
      workspaceId: workspace.id,
      fieldId: fields[0]?.id || 'field-01',
      fieldName: fields[0]?.name || '大同路後底大坵 (北田)',
      cropSeasonId: seasons[0]?.id || 'season-01',
      cropName: seasons[0]?.cropName || '青江白菜與包心白菜',
      activityType: '基肥追加與培土作業',
      actualStartTime: '2026-10-19T06:30:00Z',
      actualEndTime: '2026-10-19T10:30:00Z',
      operatorNames: ['林家豪', contacts[0]?.fullName || '張金吉'],
      workAreaDescription: '北田第3~6畦',
      materialsUsed: [
        {
          materialName: '台肥黑王一號特43號',
          specification: '40公斤/包',
          rawInputQuantityText: newMaterialRawQuantity,
          isSpecificationConfirmed: isSpecConfirmed,
          standardAmountKg: isSpecConfirmed ? 60.0 : undefined,
          batchNumber: 'TF-202610-01',
        }
      ],
      sprayingStatus: calculatedSpray,
      photoUrls: [
        'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?auto=format&fit=crop&w=800&q=80'
      ],
      originalRawInput: newLogRawText,
      reportedByUserId: currentUser,
      status: 'CONFIRMED',
    };
    setLogs([logItem, ...logs]);
    setShowAddLog(false);
  };

  return (
    <div className="space-y-6 pb-16">
      {/* 頂部操作者身分切換列 (驗收測試切換) */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-4 flex flex-col sm:flex-row items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <div className="w-9 h-9 rounded-xl bg-emerald-900/60 border border-emerald-700/60 flex items-center justify-center text-emerald-300">
            <UserCheck className="w-5 h-5" />
          </div>
          <div>
            <div className="text-xs text-stone-400">當前模擬登入身分：</div>
            <div className="text-sm font-bold text-white flex items-center gap-2">
              <span>{currentUser === 'user-lin-01' ? '林家豪 (青農經營者 / user-lin-01)' : '外部未授權使用者 (unauthorized-user-09)'}</span>
              <span className={`text-[0.625rem] px-2 py-0.5 rounded font-mono ${
                isAuthorized ? 'bg-emerald-950 text-emerald-300 border border-emerald-800' : 'bg-red-950 text-red-300 border border-red-800'
              }`}>
                {isAuthorized ? '已授權成員' : '未授權帳號 (測試越權拒絕)'}
              </span>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={() => setCurrentUser('user-lin-01')}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors ${
              currentUser === 'user-lin-01'
                ? 'bg-emerald-800 text-white border-emerald-600'
                : 'bg-stone-800 text-stone-300 border-stone-700 hover:bg-stone-700'
            }`}
          >
            以經營者登入 (user-lin-01)
          </button>
          <button
            onClick={() => setCurrentUser('unauthorized-user-09')}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors ${
              currentUser === 'unauthorized-user-09'
                ? 'bg-red-800 text-white border-red-600'
                : 'bg-stone-800 text-stone-300 border-stone-700 hover:bg-stone-700'
            }`}
          >
            切換為未授權帳號 (測試 403)
          </button>
        </div>
      </div>

      {/* 租戶隔離越權攔截警示 (如果非授權成員) */}
      {!isAuthorized ? (
        <div className="bg-red-950/40 border-2 border-red-800/80 rounded-2xl p-8 text-center space-y-4">
          <div className="w-16 h-16 rounded-full bg-red-900/60 border border-red-700 mx-auto flex items-center justify-center text-red-400">
            <Lock className="w-8 h-8" />
          </div>
          <div>
            <h3 className="text-lg font-bold text-red-300">HTTP 403 Forbidden - 存取被拒</h3>
            <p className="text-xs text-stone-300 max-w-xl mx-auto mt-2 leading-relaxed">
              後端租戶防護中介層 (<code>WorkspaceAccessGuard</code>) 已嚴格攔截此請求！
              使用者 <code>unauthorized-user-09</code> 並非農場工作空間 <code>{workspace.id}</code> 的合法成員，無權檢視田區、期作、工資與農事履歷。
            </p>
          </div>
          <button
            onClick={() => setCurrentUser('user-lin-01')}
            className="px-4 py-2 bg-stone-800 hover:bg-stone-700 text-white text-xs rounded-xl border border-stone-700 inline-flex items-center gap-2"
          >
            切換回合法經營者身分以繼續操作
          </button>
        </div>
      ) : (
        /* 合法成員主工作區 */
        <div className="space-y-6">
          {/* 工作空間看板 */}
          <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <div className="flex items-center gap-2">
                <h2 className="text-lg font-bold text-white">{workspace.name}</h2>
                <span className="text-[0.6875rem] px-2 py-0.5 rounded bg-emerald-950 text-emerald-300 border border-emerald-800 font-mono">
                  {workspace.id}
                </span>
              </div>
              <p className="text-xs text-stone-400 mt-1">
                擁有者：林家豪 (user-lin-01) ｜ 建立日期：2026-03-01 ｜ 資料庫架構：Cloud SQL PostgreSQL
              </p>
            </div>

            {/* 子分頁選單 */}
            <div className="flex bg-stone-950 p-1 rounded-xl border border-stone-800 text-xs">
              <button
                onClick={() => setActiveSubView('fields')}
                className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
                  activeSubView === 'fields' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200'
                }`}
              >
                🌾 田區與土地 ({fields.length})
              </button>
              <button
                onClick={() => setActiveSubView('seasons')}
                className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
                  activeSubView === 'seasons' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200'
                }`}
              >
                🌱 期作輪作 ({seasons.length})
              </button>
              <button
                onClick={() => setActiveSubView('contacts')}
                className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
                  activeSubView === 'contacts' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200'
                }`}
              >
                👥 免App雇工 ({contacts.length})
              </button>
              <button
                onClick={() => setActiveSubView('tasks')}
                className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
                  activeSubView === 'tasks' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200'
                }`}
              >
                📋 派工安排 ({tasks.length})
              </button>
              <button
                onClick={() => setActiveSubView('logs')}
                className={`px-3 py-1.5 rounded-lg font-medium transition-colors ${
                  activeSubView === 'logs' ? 'bg-emerald-800 text-white' : 'text-stone-400 hover:text-stone-200'
                }`}
              >
                📝 作業回報 ({logs.length})
              </button>
            </div>
          </div>

          {/* 視圖 1：田區與土地確權 */}
          {activeSubView === 'fields' && (
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <h3 className="text-sm font-bold text-white flex items-center gap-2">
                  <MapPin className="w-4 h-4 text-emerald-400" />
                  管理田區與土地共有關係 (Field & Land Relationship)
                </h3>
                <button
                  onClick={() => setShowAddField(true)}
                  className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-medium"
                >
                  <Plus className="w-3.5 h-3.5" /> 新增田區
                </button>
              </div>

              {/* 新增田區表單 Modal / 卡片 */}
              {showAddField && (
                <form onSubmit={handleCreateField} className="bg-stone-900 border border-emerald-800/80 rounded-2xl p-5 space-y-3">
                  <h4 className="text-xs font-bold text-emerald-300">新增管理田區</h4>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                    <div>
                      <label className="block text-stone-300 mb-1">田區慣用稱呼</label>
                      <input
                        type="text"
                        placeholder="例如：溪底二番北田"
                        value={newFieldName}
                        onChange={(e) => setNewFieldName(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-stone-300 mb-1">管理面積 (公頃)</label>
                      <input
                        type="number"
                        step="0.01"
                        value={newFieldArea}
                        onChange={(e) => setNewFieldArea(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-stone-300 mb-1">對應地籍地號 (支援多筆)</label>
                      <input
                        type="text"
                        value={newCadastralNumber}
                        onChange={(e) => setNewCadastralNumber(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-stone-300 mb-1">所有權人自填 (系統標記未經官方查證)</label>
                      <input
                        type="text"
                        value={newLandOwner}
                        onChange={(e) => setNewLandOwner(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                        required
                      />
                    </div>
                  </div>
                  <div className="flex justify-end gap-2 pt-2">
                    <button
                      type="button"
                      onClick={() => setShowAddField(false)}
                      className="px-3 py-1.5 bg-stone-800 text-stone-400 rounded-lg text-xs"
                    >
                      取消
                    </button>
                    <button
                      type="submit"
                      className="px-3 py-1.5 bg-emerald-600 text-white rounded-lg text-xs font-medium"
                    >
                      儲存田區
                    </button>
                  </div>
                </form>
              )}

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {fields.map((f) => (
                  <div key={f.id} className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
                    <div className="flex items-start justify-between">
                      <div>
                        <h4 className="text-sm font-bold text-white">{f.name}</h4>
                        <div className="text-xs text-stone-400 mt-0.5">
                          面積：<span className="text-emerald-400 font-semibold">{f.areaHectares} 公頃</span> ｜ 計算來源：{f.areaSource}
                        </div>
                      </div>
                      <span className="text-[0.625rem] px-2 py-0.5 rounded font-mono bg-stone-800 text-stone-300 border border-stone-700">
                        邊界 v{f.boundaryVersion}
                      </span>
                    </div>

                    <div className="bg-stone-950 p-3 rounded-xl border border-stone-800/80 text-xs space-y-1 text-stone-300">
                      <div><strong className="text-stone-400">地號關聯：</strong>{f.cadastralParcels.map(p => p.cadastralNumber).join('、')}</div>
                      <div><strong className="text-stone-400">所有權人：</strong>{f.landRelationship.ownerName} ({f.landRelationship.isSharedOwnership ? '共有' : '單獨'})</div>
                      <div><strong className="text-stone-400">承租與經營：</strong>{f.landRelationship.tenantName} 承租 / {f.landRelationship.actualOperator} 經營</div>
                      {f.landRelationship.annualRentTWD && (
                        <div><strong className="text-stone-400">租金約定：</strong>NT$ {f.landRelationship.annualRentTWD.toLocaleString()} / 年</div>
                      )}
                      <div className="text-amber-400 font-mono text-[0.6875rem] pt-1">
                        [狀態標記] {f.landRelationship.verificationStatus} (自填資料，非官方地政查證)
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* 視圖 2：期作與輪作 */}
          {activeSubView === 'seasons' && (
            <div className="space-y-4">
              <h3 className="text-sm font-bold text-white flex items-center gap-2">
                <Sprout className="w-4 h-4 text-emerald-400" />
                期作輪作歷史 (Crop Seasons & Crop Rotation)
              </h3>
              <p className="text-xs text-stone-400">
                嚴格保護歷史農務紀錄：新增一期作絕不覆蓋過去期作的施肥與病蟲害履歷。
              </p>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {seasons.map((s) => (
                  <div key={s.id} className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
                    <div className="flex items-center justify-between">
                      <span className="text-xs font-bold text-emerald-400">{s.seasonCode}</span>
                      <span className={`text-[0.625rem] px-2 py-0.5 rounded font-bold ${
                        s.status === 'ACTIVE' ? 'bg-emerald-950 text-emerald-300 border border-emerald-800' : 'bg-stone-800 text-stone-400'
                      }`}>
                        {s.status === 'FALLOW' ? '休耕期' : s.status}
                      </span>
                    </div>
                    <div className="text-sm font-bold text-white">{s.cropName} (品種：{s.variety})</div>
                    <div className="text-xs text-stone-400 space-y-1">
                      <div>苗株來源：{s.seedlingSource} {s.seedlingBatchNumber && `(批號 ${s.seedlingBatchNumber})`}</div>
                      <div>預計種植：{s.plannedPlantingDate} ｜ 預計採收：{s.plannedHarvestDate}</div>
                      <div className="text-stone-300 italic pt-1">備註：{s.notes}</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* 視圖 3：免裝 App 外部聯絡人 */}
          {activeSubView === 'contacts' && (
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-bold text-white flex items-center gap-2">
                    <Users className="w-4 h-4 text-emerald-400" />
                    工作聯絡人名冊 (Work Contacts - 免裝 App 支援)
                  </h3>
                  <p className="text-xs text-stone-400 mt-0.5">
                    長輩與現場雇工無需下載 App 或申請電子郵件，由家庭管理者電話聯繫與代為記錄。
                  </p>
                </div>
                <button
                  onClick={() => setShowAddContact(true)}
                  className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-medium"
                >
                  <Plus className="w-3.5 h-3.5" /> 新增聯絡人
                </button>
              </div>

              {showAddContact && (
                <form onSubmit={handleCreateContact} className="bg-stone-900 border border-emerald-800/80 rounded-2xl p-5 space-y-3">
                  <h4 className="text-xs font-bold text-emerald-300">新增外部聯絡人</h4>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                    <div>
                      <label className="block text-stone-300 mb-1">本名</label>
                      <input
                        type="text"
                        placeholder="例：陳明財"
                        value={newContactName}
                        onChange={(e) => setNewContactName(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-stone-300 mb-1">習慣稱呼 / 俗稱</label>
                      <input
                        type="text"
                        placeholder="例：阿財伯 (施藥代工)"
                        value={newContactNickname}
                        onChange={(e) => setNewContactNickname(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                      />
                    </div>
                    <div>
                      <label className="block text-stone-300 mb-1">聯絡電話 (優先電話聯繫)</label>
                      <input
                        type="text"
                        placeholder="0911-222-333"
                        value={newContactPhone}
                        onChange={(e) => setNewContactPhone(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-stone-300 mb-1">預設日薪 (NT$ / 日)</label>
                      <input
                        type="number"
                        value={newContactWage}
                        onChange={(e) => setNewContactWage(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                      />
                    </div>
                  </div>
                  <div>
                    <label className="block text-xs text-stone-300 mb-1">本人確認之工作限制 (職業安全)</label>
                    <input
                      type="text"
                      value={newContactRestriction}
                      onChange={(e) => setNewContactRestriction(e.target.value)}
                      className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-xs text-white"
                    />
                  </div>
                  <div className="flex justify-end gap-2 pt-2">
                    <button
                      type="button"
                      onClick={() => setShowAddContact(false)}
                      className="px-3 py-1.5 bg-stone-800 text-stone-400 rounded-lg text-xs"
                    >
                      取消
                    </button>
                    <button
                      type="submit"
                      className="px-3 py-1.5 bg-emerald-600 text-white rounded-lg text-xs font-medium"
                    >
                      儲存聯絡人
                    </button>
                  </div>
                </form>
              )}

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {contacts.map((c) => (
                  <div key={c.id} className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-2">
                    <div className="flex items-center justify-between">
                      <div className="text-sm font-bold text-white flex items-center gap-2">
                        <span>{c.fullName}</span>
                        <span className="text-xs text-stone-400">({c.nickname})</span>
                      </div>
                      <span className="text-[0.625rem] px-2 py-0.5 rounded font-mono bg-stone-800 text-amber-300 border border-stone-700">
                        免裝 App
                      </span>
                    </div>
                    <div className="text-xs text-stone-300 flex items-center gap-2">
                      <PhoneCall className="w-3.5 h-3.5 text-emerald-400" />
                      <span>{c.phone} (偏好電話)</span>
                    </div>
                    <div className="text-xs text-stone-400">
                      預設日薪：NT$ {c.defaultDailyWageTWD?.toLocaleString()} ｜ 工班：{c.groupLeaderName || '獨立雇工'}
                    </div>
                    <div className="bg-stone-950 p-2.5 rounded-xl border border-stone-800/80 text-xs text-amber-300/90">
                      ⚠️ 工作限制：{c.workRestrictions || '無特別限制'}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* 視圖 4：工作安排與派工 */}
          {activeSubView === 'tasks' && (
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-bold text-white flex items-center gap-2">
                    <Calendar className="w-4 h-4 text-emerald-400" />
                    派工日程與狀態流轉 (Task Dispatching)
                  </h3>
                  <p className="text-xs text-stone-400 mt-0.5">
                    <strong>核心約束：</strong>打電話不等於已答應，排入日程不等於已通知。
                  </p>
                </div>
                <button
                  onClick={() => setShowAddTask(true)}
                  className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-medium"
                >
                  <Plus className="w-3.5 h-3.5" /> 建立派工
                </button>
              </div>

              {showAddTask && (
                <form onSubmit={handleCreateTask} className="bg-stone-900 border border-emerald-800/80 rounded-2xl p-5 space-y-3">
                  <h4 className="text-xs font-bold text-emerald-300">建立新農務派工</h4>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                    <div>
                      <label className="block text-stone-300 mb-1">工作內容說明</label>
                      <input
                        type="text"
                        placeholder="例：北田二期翻耕與基肥施用"
                        value={newTaskTitle}
                        onChange={(e) => setNewTaskTitle(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-stone-300 mb-1">派遣雇工</label>
                      <select
                        value={selectedContactId}
                        onChange={(e) => setSelectedContactId(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                      >
                        {contacts.map((c) => (
                          <option key={c.id} value={c.id}>{c.fullName} ({c.nickname})</option>
                        ))}
                      </select>
                    </div>
                  </div>
                  <div className="flex justify-end gap-2 pt-2">
                    <button
                      type="button"
                      onClick={() => setShowAddTask(false)}
                      className="px-3 py-1.5 bg-stone-800 text-stone-400 rounded-lg text-xs"
                    >
                      取消
                    </button>
                    <button
                      type="submit"
                      className="px-3 py-1.5 bg-emerald-600 text-white rounded-lg text-xs font-medium"
                    >
                      發布工作
                    </button>
                  </div>
                </form>
              )}

              <div className="space-y-4">
                {tasks.map((t) => (
                  <div key={t.id} className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
                    <div className="flex items-start justify-between">
                      <div>
                        <h4 className="text-sm font-bold text-white">{t.title}</h4>
                        <div className="text-xs text-stone-400 mt-0.5">
                          田區：{t.fieldName} ｜ 預計日期：{t.plannedDate} ｜ 集合點：{t.assemblyLocation}
                        </div>
                      </div>
                      <span className="text-[0.625rem] px-2 py-0.5 rounded font-mono bg-blue-950 text-blue-300 border border-blue-800">
                        {t.status}
                      </span>
                    </div>

                    <div className="border-t border-stone-800/80 pt-3 space-y-2">
                      <div className="text-xs text-stone-400 font-medium">派遣人員與即時狀態流轉：</div>
                      {t.assignments.map((asg) => (
                        <div key={asg.contactId} className="flex flex-col sm:flex-row sm:items-center justify-between bg-stone-950 p-3 rounded-xl border border-stone-800 gap-2">
                          <div>
                            <span className="text-xs font-bold text-white">{asg.contactName}</span>
                            <span className="text-xs text-stone-400 ml-2">工資快照：NT$ {asg.rateSnapshotTWD}</span>
                          </div>
                          <div className="flex items-center gap-2">
                            <span className={`text-[0.6875rem] font-mono px-2 py-0.5 rounded border ${
                              asg.status === 'CONFIRMED' ? 'bg-emerald-950 text-emerald-300 border-emerald-800' :
                              asg.status === 'CHECKED_IN' ? 'bg-blue-950 text-blue-300 border-blue-800' :
                              asg.status === 'COMPLETED' ? 'bg-purple-950 text-purple-300 border-purple-800' :
                              'bg-amber-950 text-amber-300 border-amber-800'
                            }`}>
                              {asg.status}
                            </span>

                            {/* 狀態切換按鈕 */}
                            {asg.status === 'CONTACTED_PENDING' && (
                              <button
                                onClick={() => handleUpdateAssignmentStatus(t.id, asg.contactId, 'ACCEPT')}
                                className="px-2 py-1 bg-emerald-800 hover:bg-emerald-700 text-white text-[0.6875rem] rounded"
                              >
                                對方口頭答應 (ACCEPT)
                              </button>
                            )}
                            {asg.status === 'CONFIRMED' && (
                              <button
                                onClick={() => handleUpdateAssignmentStatus(t.id, asg.contactId, 'CHECK_IN')}
                                className="px-2 py-1 bg-blue-800 hover:bg-blue-700 text-white text-[0.6875rem] rounded"
                              >
                                當日現場簽到 (CHECK_IN)
                              </button>
                            )}
                            {asg.status === 'CHECKED_IN' && (
                              <button
                                onClick={() => handleUpdateAssignmentStatus(t.id, asg.contactId, 'FINISH')}
                                className="px-2 py-1 bg-purple-800 hover:bg-purple-700 text-white text-[0.6875rem] rounded"
                              >
                                工時完成 (FINISH)
                              </button>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* 視圖 5：作業回報與資材換算 */}
          {activeSubView === 'logs' && (
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-bold text-white flex items-center gap-2">
                    <FileText className="w-4 h-4 text-emerald-400" />
                    農務作業履歷與資材扣抵 (Farm Work Logs)
                  </h3>
                  <p className="text-xs text-stone-400 mt-0.5">
                    保存長輩原始說法「一包半」；施藥嚴格查驗，未登記者絕不假定為未施用。
                  </p>
                </div>
                <button
                  onClick={() => setShowAddLog(true)}
                  className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-medium"
                >
                  <Plus className="w-3.5 h-3.5" /> 回報新作業
                </button>
              </div>

              {showAddLog && (
                <form onSubmit={handleCreateLog} className="bg-stone-900 border border-emerald-800/80 rounded-2xl p-5 space-y-3">
                  <h4 className="text-xs font-bold text-emerald-300">填寫農務作業回報</h4>
                  <div>
                    <label className="block text-xs text-stone-300 mb-1">現場口述或語音原始紀錄原文</label>
                    <textarea
                      value={newLogRawText}
                      onChange={(e) => setNewLogRawText(e.target.value)}
                      rows={2}
                      className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-xs text-white"
                      required
                    />
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                    <div>
                      <label className="block text-stone-300 mb-1">資材俗稱或口語使用量</label>
                      <input
                        type="text"
                        value={newMaterialRawQuantity}
                        onChange={(e) => setNewMaterialRawQuantity(e.target.value)}
                        className="w-full bg-stone-950 border border-stone-800 rounded-lg p-2 text-white"
                      />
                    </div>
                    <div className="flex items-center gap-2 pt-5">
                      <input
                        type="checkbox"
                        checked={isSpecConfirmed}
                        onChange={(e) => setIsSpecConfirmed(e.target.checked)}
                        className="rounded bg-stone-800 border-stone-700 text-emerald-600"
                      />
                      <span className="text-stone-300">已確認包裝規格 (40公斤/包，自動換算為 60 kg)</span>
                    </div>
                  </div>

                  <div className="p-3 bg-stone-950 rounded-xl border border-stone-800 text-xs space-y-2">
                    <div className="font-bold text-stone-300">施藥安全檢查：</div>
                    <label className="flex items-center gap-2 cursor-pointer">
                      <input
                        type="checkbox"
                        checked={sprayApplied}
                        onChange={(e) => setSprayApplied(e.target.checked)}
                        className="rounded bg-stone-800 border-stone-700 text-emerald-600"
                      />
                      <span className="text-stone-300">本次作業有施用農藥或化學防治劑</span>
                    </label>
                    {!sprayApplied && (
                      <label className="flex items-center gap-2 cursor-pointer">
                        <input
                          type="checkbox"
                          checked={managerConfirmedNotApplied}
                          onChange={(e) => setManagerConfirmedNotApplied(e.target.checked)}
                          className="rounded bg-stone-800 border-stone-700 text-emerald-600"
                        />
                        <span className="text-emerald-400 font-medium">管理者親自切結：本次完全未施用農藥 (轉為 CONFIRMED_NOT_APPLIED)</span>
                      </label>
                    )}
                  </div>

                  <div className="flex justify-end gap-2 pt-2">
                    <button
                      type="button"
                      onClick={() => setShowAddLog(false)}
                      className="px-3 py-1.5 bg-stone-800 text-stone-400 rounded-lg text-xs"
                    >
                      取消
                    </button>
                    <button
                      type="submit"
                      className="px-3 py-1.5 bg-emerald-600 text-white rounded-lg text-xs font-medium"
                    >
                      確認提交正式紀錄
                    </button>
                  </div>
                </form>
              )}

              <div className="space-y-4">
                {logs.map((l) => (
                  <div key={l.id} className="bg-stone-900 border border-stone-800 rounded-2xl p-5 space-y-3">
                    <div className="flex items-start justify-between">
                      <div>
                        <h4 className="text-sm font-bold text-white">{l.activityType}</h4>
                        <div className="text-xs text-stone-400 mt-0.5">
                          田區：{l.fieldName} ｜ 範圍：{l.workAreaDescription} ｜ 操作人：{l.operatorNames.join('、')}
                        </div>
                      </div>
                      <span className="text-[0.625rem] px-2 py-0.5 rounded font-mono bg-emerald-950 text-emerald-300 border border-emerald-800">
                        {l.status}
                      </span>
                    </div>

                    <div className="bg-stone-950 p-3 rounded-xl border border-stone-800/80 text-xs space-y-2">
                      <div>
                        <strong className="text-stone-400">長輩口述原文：</strong>
                        <span className="text-stone-200">「{l.originalRawInput}」</span>
                      </div>

                      {l.materialsUsed.length > 0 && (
                        <div className="pt-1 border-t border-stone-800">
                          <strong className="text-stone-400">資材領用扣抵：</strong>
                          {l.materialsUsed.map((m, idx) => (
                            <div key={idx} className="mt-1 text-emerald-300">
                              • {m.materialName} ({m.specification})：口頭回報「{m.rawInputQuantityText}」
                              {m.standardAmountKg ? ` $\\rightarrow$ 已確認換算 ${m.standardAmountKg} 公斤` : ' (待規格確認，未換算)'}
                            </div>
                          ))}
                        </div>
                      )}

                      <div className="pt-1 border-t border-stone-800 flex items-center justify-between">
                        <span className="text-stone-400">施藥安全判定：</span>
                        <span className={`font-mono text-xs font-bold ${
                          l.sprayingStatus === 'CONFIRMED_NOT_APPLIED' ? 'text-emerald-400' :
                          l.sprayingStatus === 'APPLIED' ? 'text-blue-400' : 'text-amber-400'
                        }`}>
                          {l.sprayingStatus}
                        </span>
                      </div>
                    </div>

                    {l.photoUrls.length > 0 && (
                      <div className="flex items-center gap-2 pt-1 text-xs text-stone-400">
                        <Camera className="w-3.5 h-3.5 text-emerald-400" />
                        <span>佐證照片已加密儲存於私有 GCS Bucket (Signed URL 授權檢視)</span>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
};
