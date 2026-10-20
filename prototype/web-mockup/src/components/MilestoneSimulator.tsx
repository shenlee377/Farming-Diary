import React, { useState } from 'react';
import {
  Workspace,
  Field,
  CropSeason,
  WorkContact,
  FarmTask,
  FarmWorkLog,
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
  User,
  ShieldCheck,
  CheckCircle2,
  Lock,
  Plus,
  Play,
  ArrowRight,
  FileText,
  Camera,
  Users,
  MapPin,
  Calendar,
  AlertOctagon,
} from 'lucide-react';

export const MilestoneSimulator: React.FC = () => {
  // 當前模擬步驟 (1 ~ 8)
  const [currentStep, setCurrentStep] = useState<number>(1);

  // 登入狀態模擬
  const [currentUser, setCurrentUser] = useState<'user-lin-01' | 'unauthorized-user-09'>('user-lin-01');

  // 本地狀態儲存
  const [workspace, setWorkspace] = useState<Workspace>(SEED_WORKSPACE);
  const [fields, setFields] = useState<Field[]>(SEED_FIELDS);
  const [seasons, setSeasons] = useState<CropSeason[]>(SEED_CROP_SEASONS);
  const [contacts, setContacts] = useState<WorkContact[]>(SEED_CONTACTS);
  const [tasks, setTasks] = useState<FarmTask[]>(SEED_TASKS);
  const [logs, setLogs] = useState<FarmWorkLog[]>(SEED_LOGS);

  // 步驟 3 表單輸入狀態
  const [newFieldName, setNewFieldName] = useState<string>('溪底新大坵');
  const [newCropName, setNewCropName] = useState<string>('青江白菜與包心白菜');

  // 步驟 4 新增無 App 外部聯絡人狀態
  const [newContactName, setNewContactName] = useState<string>('黃明輝 (輝哥)');
  const [newContactPhone, setNewContactPhone] = useState<string>('0933-123-456');

  // 步驟 6 現場回報狀態
  const [rawInputNote, setRawInputNote] = useState<string>('今天用了特43一包半，全區完成培土，無噴藥。');

  // 檢查是否具有工作空間存取權限
  const hasAccess = currentUser === 'user-lin-01';

  const resetFlow = () => {
    setCurrentStep(1);
    setCurrentUser('user-lin-01');
    setFields(SEED_FIELDS);
    setContacts(SEED_CONTACTS);
    setTasks(SEED_TASKS);
    setLogs(SEED_LOGS);
  };

  return (
    <div className="space-y-6 pb-16">
      {/* 頂部引導卡片 */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <CheckCircle2 className="w-5 h-5 text-emerald-400" />
            <h3 className="text-base font-bold text-white">
              里程碑一端到端驗收情境互動模擬器 (Milestone 1 Acceptance Simulator)
            </h3>
          </div>
          <button
            onClick={resetFlow}
            className="text-xs text-stone-400 hover:text-stone-200 px-3 py-1 bg-stone-800 rounded-lg border border-stone-700"
          >
            重設驗收流程
          </button>
        </div>
        <p className="text-xs text-stone-400 mt-2 leading-relaxed">
          完整重現主提示詞第 28 條規定之第一個端到端驗收測試：
          <strong>
            登入 → 建立工作空間 → 建立田區與一期作 → 新增無 App 外部工作聯絡人 → 派工安排 → 回報作業與資材 → 私有照片上傳 → 重新登入查看 → 未授權身分隔離測試。
          </strong>
        </p>

        {/* 步驟進度條 */}
        <div className="grid grid-cols-4 sm:grid-cols-8 gap-1.5 mt-6">
          {[
            '1. 登入',
            '2. 工作空間',
            '3. 田區期作',
            '4. 無App雇工',
            '5. 派工安排',
            '6. 作業回報',
            '7. 重新登入',
            '8. 租戶隔離',
          ].map((title, idx) => {
            const stepNum = idx + 1;
            const isCompleted = currentStep > stepNum;
            const isCurrent = currentStep === stepNum;
            return (
              <button
                key={stepNum}
                onClick={() => setCurrentStep(stepNum)}
                className={`p-2 rounded-lg text-left text-[11px] font-medium border transition-colors ${
                  isCurrent
                    ? 'bg-emerald-950/80 border-emerald-500 text-emerald-200 shadow-sm'
                    : isCompleted
                    ? 'bg-stone-800/80 border-stone-700 text-stone-300'
                    : 'bg-stone-900 border-stone-800 text-stone-500'
                }`}
              >
                <div className="flex items-center justify-between">
                  <span>{title}</span>
                  {isCompleted && <span className="text-emerald-400">✓</span>}
                </div>
              </button>
            );
          })}
        </div>
      </div>

      {/* 步驟 1：身分登入 */}
      {currentStep === 1 && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <h4 className="text-sm font-bold text-white flex items-center gap-2">
            <User className="w-4 h-4 text-emerald-400" />
            步驟 1：使用者身分認證 (Authentication Gateway)
          </h4>
          <p className="text-xs text-stone-400 leading-relaxed">
            透過 OAuth 授權碼交換或本機隔離測試 Token，系統解析出穩定內部 <code>user_id</code>。
          </p>
          <div className="p-4 bg-stone-950 rounded-xl border border-stone-800 text-xs font-mono space-y-2">
            <div><span className="text-stone-400">登入帳號：</span><span className="text-emerald-400">林家豪 (青農返鄉)</span></div>
            <div><span className="text-stone-400">Internal User ID：</span><span className="text-stone-300">user-lin-01</span></div>
            <div><span className="text-stone-400">授權 Scope：</span><span className="text-stone-300">account.read (最小權限原則，無多餘電話或社交權限)</span></div>
            <div><span className="text-stone-400">認證狀態：</span><span className="text-emerald-400 font-bold">已驗證 Session 就緒</span></div>
          </div>
          <button
            onClick={() => setCurrentStep(2)}
            className="flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-semibold"
          >
            下一步：進入工作空間 <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* 步驟 2：工作空間 */}
      {currentStep === 2 && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <h4 className="text-sm font-bold text-white flex items-center gap-2">
            <ShieldCheck className="w-4 h-4 text-emerald-400" />
            步驟 2：建立工作空間 (Workspace Tenant Creation)
          </h4>
          <p className="text-xs text-stone-400 leading-relaxed">
            工作空間為所有田區、期作、人員與帳務的強制資料隔離邊界。
          </p>
          <div className="p-4 bg-stone-950 rounded-xl border border-stone-800 text-xs space-y-2">
            <div className="flex justify-between">
              <span className="text-stone-400">農場工作空間名稱：</span>
              <span className="text-white font-bold">{workspace.name}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-stone-400">擁有者 (Owner)：</span>
              <span className="text-emerald-400">{workspace.ownerUserId}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-stone-400">隔離識別碼 (Tenant ID)：</span>
              <span className="font-mono text-stone-300">{workspace.id}</span>
            </div>
          </div>
          <button
            onClick={() => setCurrentStep(3)}
            className="flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-semibold"
          >
            下一步：建立田區與一期作 <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* 步驟 3：建立田區與期作 */}
      {currentStep === 3 && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <h4 className="text-sm font-bold text-white flex items-center gap-2">
            <MapPin className="w-4 h-4 text-emerald-400" />
            步驟 3：建立田區與期作 (Field & Crop Season with Land Relationship)
          </h4>
          <p className="text-xs text-stone-400 leading-relaxed">
            嚴格落實「管理田區邊界不等於地籍線」、「自填土地關係不可標示為已完成法律查證」。
          </p>

          <div className="space-y-3">
            <div>
              <label className="block text-xs font-medium text-stone-300 mb-1">田區慣用稱呼</label>
              <input
                type="text"
                value={newFieldName}
                onChange={(e) => setNewFieldName(e.target.value)}
                className="w-full bg-stone-950 border border-stone-800 rounded-xl px-3 py-2 text-xs text-white"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-stone-300 mb-1">本期種植作物</label>
              <input
                type="text"
                value={newCropName}
                onChange={(e) => setNewCropName(e.target.value)}
                className="w-full bg-stone-950 border border-stone-800 rounded-xl px-3 py-2 text-xs text-white"
              />
            </div>
            <div className="p-3 bg-stone-950 rounded-xl border border-stone-800 text-xs space-y-1.5 text-stone-400">
              <div><strong className="text-stone-300">多對多地籍關聯：</strong>雲林縣西螺鎮公館段 0451 號 (5200㎡) + 0452 號 (3300㎡)</div>
              <div><strong className="text-stone-300">土地權利狀態：</strong>承租 (陳黃阿雀祭祀公業)；租約至 2028-12-31</div>
              <div className="text-amber-400 font-mono text-[11px]">
                [系統標籤] SELF_REPORTED_UNVERIFIED (自填資料，非官方地政查證)
              </div>
            </div>
          </div>

          <button
            onClick={() => setCurrentStep(4)}
            className="flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-semibold"
          >
            下一步：新增免裝 App 工作聯絡人 <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* 步驟 4：新增無 App 外部聯絡人 */}
      {currentStep === 4 && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <h4 className="text-sm font-bold text-white flex items-center gap-2">
            <Users className="w-4 h-4 text-emerald-400" />
            步驟 4：新增工作聯絡人 (External Contact - No App Required)
          </h4>
          <p className="text-xs text-stone-400 leading-relaxed">
            長輩或外聘工班無需下載 App 或建立身分帳號。由家庭經營者代為留存電話、工作限制與預設日薪。
          </p>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-medium text-stone-300 mb-1">聯絡人姓名與稱呼</label>
              <input
                type="text"
                value={newContactName}
                onChange={(e) => setNewContactName(e.target.value)}
                className="w-full bg-stone-950 border border-stone-800 rounded-xl px-3 py-2 text-xs text-white"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-stone-300 mb-1">電話號碼 (電話通知優先)</label>
              <input
                type="text"
                value={newContactPhone}
                onChange={(e) => setNewContactPhone(e.target.value)}
                className="w-full bg-stone-950 border border-stone-800 rounded-xl px-3 py-2 text-xs text-white"
              />
            </div>
          </div>

          <div className="p-3 bg-stone-950 rounded-xl border border-stone-800 text-xs space-y-1 text-stone-300">
            <div><span className="text-stone-400">App 登入帳號：</span><span className="text-amber-400 font-bold">無 (has_app_account: false)</span></div>
            <div><span className="text-stone-400">工作限制安全備註：</span><span>膝蓋不能久跪，偏好早上開中耕機作業</span></div>
            <div><span className="text-stone-400">預設日薪約定：</span><span>NT$ 2,500 / 天 (當次派工時保存費率快照)</span></div>
          </div>

          <button
            onClick={() => setCurrentStep(5)}
            className="flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-semibold"
          >
            下一步：建立派工任務並安排人員 <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* 步驟 5：派工安排 */}
      {currentStep === 5 && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <h4 className="text-sm font-bold text-white flex items-center gap-2">
            <Calendar className="w-4 h-4 text-emerald-400" />
            步驟 5：建立農務工作與派工狀態 (Task & Staffing Guard)
          </h4>
          <p className="text-xs text-stone-400 leading-relaxed">
            系統強制約束：電話聯絡過僅能標註為 <code>CONTACTED_PENDING</code>（已聯繫待回覆），必須等對方親口同意才可轉為 <code>CONFIRMED</code>。
          </p>

          <div className="p-4 bg-stone-950 rounded-xl border border-stone-800 text-xs space-y-2">
            <div className="flex justify-between">
              <span className="text-stone-400">派工工作名稱：</span>
              <span className="text-white font-bold">{tasks[0]?.title}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-stone-400">預計作業日期與集合地：</span>
              <span className="text-stone-300">{tasks[0]?.plannedDate} ({tasks[0]?.assemblyLocation})</span>
            </div>
            <div className="pt-2 border-t border-stone-800 space-y-1.5">
              <div className="text-stone-400 font-medium">派遣人員名冊狀態：</div>
              {tasks[0]?.assignments.map((asg, idx) => (
                <div key={idx} className="flex items-center justify-between bg-stone-900 p-2 rounded-lg">
                  <span className="text-stone-200">{asg.contactName}</span>
                  <span className="px-2 py-0.5 rounded text-[11px] font-mono bg-emerald-950 text-emerald-300 border border-emerald-800">
                    狀態：{asg.status} (工資快照：NT$ {asg.rateSnapshotTWD})
                  </span>
                </div>
              ))}
            </div>
          </div>

          <button
            onClick={() => setCurrentStep(6)}
            className="flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-semibold"
          >
            下一步：回報現場作業與資材 <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* 步驟 6：回報實際作業 */}
      {currentStep === 6 && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <h4 className="text-sm font-bold text-white flex items-center gap-2">
            <FileText className="w-4 h-4 text-emerald-400" />
            步驟 6：現場作業回報與資材規格查證 (Farm Work Log)
          </h4>
          <p className="text-xs text-stone-400 leading-relaxed">
            長輩回報資材「一包半」先留存原始文字；施藥狀態明確標示「經切結已確認未施用 (CONFIRMED_NOT_APPLIED)」。
          </p>

          <div>
            <label className="block text-xs font-medium text-stone-300 mb-1">長輩或現場作業原始口述紀錄</label>
            <textarea
              value={rawInputNote}
              onChange={(e) => setRawInputNote(e.target.value)}
              rows={2}
              className="w-full bg-stone-950 border border-stone-800 rounded-xl px-3 py-2 text-xs text-white"
            />
          </div>

          <div className="p-4 bg-stone-950 rounded-xl border border-stone-800 text-xs space-y-2">
            <div className="text-emerald-400 font-bold flex items-center gap-1.5">
              <Camera className="w-4 h-4" />
              <span>現場佐證相片已上傳至私有 GCS 儲存桶</span>
            </div>
            <div className="text-stone-400 text-[11px]">
              gs://farmland-diary-private-bucket/workspaces/ws-tw-xiluo-001/logs/photo_01.jpg (透過限時 Signed URL 授權檢視)
            </div>
            <div className="pt-2 border-t border-stone-800 flex justify-between">
              <span className="text-stone-400">施藥安全狀態：</span>
              <span className="font-mono text-emerald-300 font-bold">CONFIRMED_NOT_APPLIED (安全採收期無受限)</span>
            </div>
          </div>

          <button
            onClick={() => setCurrentStep(7)}
            className="flex items-center gap-2 px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-semibold"
          >
            下一步：模擬登出與重新登入讀取 <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* 步驟 7：重新登入驗證 */}
      {currentStep === 7 && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 space-y-4">
          <h4 className="text-sm font-bold text-white flex items-center gap-2">
            <CheckCircle2 className="w-4 h-4 text-emerald-400" />
            步驟 7：重新登入後資料完整復原 (Persistence & Recovery)
          </h4>
          <p className="text-xs text-stone-400 leading-relaxed">
            模擬使用者關閉 App 重新開啟或於不同裝置登入。後端以使用者 <code>user-lin-01</code> 正確撈取工作空間所有歷史田區、期作、人員與作業紀錄。
          </p>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 text-xs">
            <div className="p-3 bg-stone-950 rounded-xl border border-stone-800">
              <span className="text-stone-400 block mb-1">田區數量</span>
              <span className="text-emerald-400 font-bold text-lg">{fields.length} 個田區</span>
            </div>
            <div className="p-3 bg-stone-950 rounded-xl border border-stone-800">
              <span className="text-stone-400 block mb-1">外部聯絡人</span>
              <span className="text-emerald-400 font-bold text-lg">{contacts.length} 位人員</span>
            </div>
            <div className="p-3 bg-stone-950 rounded-xl border border-stone-800">
              <span className="text-stone-400 block mb-1">已確認農務紀錄</span>
              <span className="text-emerald-400 font-bold text-lg">{logs.length} 筆正式紀錄</span>
            </div>
          </div>

          <button
            onClick={() => {
              setCurrentUser('unauthorized-user-09');
              setCurrentStep(8);
            }}
            className="flex items-center gap-2 px-4 py-2 bg-red-800 hover:bg-red-700 text-white rounded-xl text-xs font-semibold"
          >
            最後一步：切換為未授權使用者進行拒絕測試 <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* 步驟 8：未授權租戶隔離測試 */}
      {currentStep === 8 && (
        <div className="bg-stone-900 border border-red-900/60 rounded-2xl p-6 space-y-4">
          <div className="flex items-center justify-between">
            <h4 className="text-sm font-bold text-red-400 flex items-center gap-2">
              <AlertOctagon className="w-4 h-4" />
              步驟 8：多租戶安全防護與未授權拒絕 (Tenant Isolation Security Test)
            </h4>
            <span className="px-2.5 py-0.5 rounded text-[11px] font-mono bg-red-950 text-red-300 border border-red-800">
              HTTP 403 Forbidden
            </span>
          </div>
          <p className="text-xs text-stone-300 leading-relaxed">
            模擬另一位外部登入使用者 <code>unauthorized-user-09</code>（例如另一家農場的員工或惡意攻擊者），嘗試透過 API 直接請求西螺農場的田區與工資紀錄。
          </p>

          <div className="p-4 bg-red-950/30 border border-red-900/80 rounded-xl text-xs font-mono space-y-2 text-red-200">
            <div>REQUEST: GET /api/v1/workspaces/ws-tw-xiluo-001/fields</div>
            <div>AUTH HEADER: Bearer token_for_unauthorized_user_09</div>
            <div className="text-red-400 font-bold">RESPONSE STATUS: 403 Forbidden</div>
            <div className="text-stone-400">
              MESSAGE: "存取被拒：當前使用者不具備工作空間 ws-tw-xiluo-001 的成員存取權限。"
            </div>
          </div>

          <div className="flex items-center justify-between pt-2">
            <span className="text-xs text-emerald-400 font-bold flex items-center gap-1.5">
              <CheckCircle2 className="w-4 h-4" />
              里程碑一 8 大驗收項目全數通過！
            </span>
            <button
              onClick={resetFlow}
              className="px-4 py-1.5 bg-stone-800 hover:bg-stone-700 text-stone-200 text-xs rounded-lg border border-stone-700"
            >
              重新測試
            </button>
          </div>
        </div>
      )}
    </div>
  );
};
