import React, { useEffect, useState } from 'react';
import {
  ArrowLeft,
  ArrowRight,
  Camera,
  CheckCircle2,
  Compass,
  MapPin,
  Pause,
  Play,
  Target,
  User,
  X,
} from 'lucide-react';
import type { ReshootTask } from '../types/index.ts';
import {
  headingToDirection,
  normalizeHeading,
  turnGuidance,
  RESHOOT_REASON_LABEL,
} from '../domain/inspection_ui.ts';

/**
 * 巡田取景畫面原型：所有品質回饋、補拍引導、離場前查核都疊在相機畫面上，
 * 使用者不需要離開相機去看清單或按「啟動處理」。
 *
 * - 走動時自動連拍清晰影格，模糊或有人入鏡的影格自動略過（不用每張按快門）。
 * - 補拍時畫面直接顯示「往左／往右轉幾度」，對準後才拍。
 * - 按「結束」時若仍有待補拍，在取景畫面內提示，可直接帶去補拍。
 * - 字級全用 rem，跟隨瀏覽器／系統文字大小；HUD 以換行因應大字級，不截斷。
 */

type SceneCondition = 'clear' | 'blur' | 'person';

interface InspectionViewfinderProps {
  fieldName: string;
  reshootTasks: ReshootTask[];
  onReshootResolved: (taskId: string) => void;
  onFinish: () => void;
}

const AUTO_CAPTURE_INTERVAL_MS = 1200;
const GPS_ACCURACY_METERS = 3.2;

export const InspectionViewfinder: React.FC<InspectionViewfinderProps> = ({
  fieldName,
  reshootTasks,
  onReshootResolved,
  onFinish,
}) => {
  const [heading, setHeading] = useState(90);
  const [condition, setCondition] = useState<SceneCondition>('clear');
  const [recording, setRecording] = useState(false);
  const [capturedCount, setCapturedCount] = useState(0);
  const [skippedCount, setSkippedCount] = useState(0);
  const [activeReshootId, setActiveReshootId] = useState<string | null>(null);
  const [sheet, setSheet] = useState<'end' | 'done' | null>(null);
  const [toast, setToast] = useState<string | null>(null);

  const pendingTasks = reshootTasks.filter((t) => t.status === 'PENDING');
  const activeTask = pendingTasks.find((t) => t.id === activeReshootId) ?? null;
  const guidance = activeTask ? turnGuidance(heading, activeTask.suggestedHeadingDegrees) : null;

  // 走動模式：自動連拍，只保留清晰且無人入鏡的影格
  useEffect(() => {
    if (!recording || activeTask) return;
    const timer = setInterval(() => {
      if (condition === 'clear') {
        setCapturedCount((n) => n + 1);
      } else {
        setSkippedCount((n) => n + 1);
      }
    }, AUTO_CAPTURE_INTERVAL_MS);
    return () => clearInterval(timer);
  }, [recording, activeTask, condition]);

  useEffect(() => {
    if (!toast) return;
    const timer = setTimeout(() => setToast(null), 2500);
    return () => clearTimeout(timer);
  }, [toast]);

  const startReshoot = (taskId: string) => {
    setRecording(false);
    setSheet(null);
    setActiveReshootId(taskId);
  };

  const handleShutter = () => {
    if (!activeTask) {
      setRecording((r) => !r);
      return;
    }
    if (!guidance?.aligned) {
      setToast(guidance?.text ?? '');
      return;
    }
    if (condition !== 'clear') {
      setToast('畫面不清楚，請拿穩後再拍一次');
      return;
    }
    setCapturedCount((n) => n + 1);
    onReshootResolved(activeTask.id);
    setActiveReshootId(null);
    setToast('補拍完成');
  };

  const handleEnd = () => {
    setRecording(false);
    setActiveReshootId(null);
    if (pendingTasks.length > 0) {
      setSheet('end');
    } else {
      finish();
    }
  };

  const finish = () => {
    setSheet('done');
    onFinish();
  };

  const liveStatus = (() => {
    if (activeTask) return null;
    if (!recording) return { tone: 'neutral', text: '按下中間大按鈕開始巡田，邊走邊自動拍' } as const;
    if (condition === 'blur') return { tone: 'warn', text: '畫面晃動，請放慢腳步' } as const;
    if (condition === 'person') return { tone: 'warn', text: '有人入鏡，稍等一下或換個角度' } as const;
    return { tone: 'ok', text: '畫面清晰，持續拍攝中' } as const;
  })();

  const toneClass = {
    ok: 'bg-emerald-900/85 text-emerald-100 border-emerald-400/70',
    warn: 'bg-amber-900/90 text-amber-100 border-amber-400/80',
    neutral: 'bg-black/60 text-white border-white/30',
  };

  return (
    <div className="grid grid-cols-1 lg:grid-cols-[384px_1fr] gap-6 items-start">
      {/* 手機取景畫面 */}
      <div className="relative mx-auto w-full max-w-[384px] min-h-[680px] rounded-[2rem] overflow-hidden border-4 border-stone-700 bg-stone-950 shadow-2xl">
        {/* 模擬相機畫面：天空與田畦，依朝向左右平移 */}
        <div
          aria-hidden="true"
          className={`absolute inset-0 transition-[filter] duration-300 ${condition === 'blur' ? 'blur-[3px]' : ''}`}
          style={{
            backgroundImage:
              'linear-gradient(to bottom, #9cc8ee 0%, #cfe3ef 34%, #6f9a4a 35%, #3f6b2c 100%),' +
              'repeating-linear-gradient(100deg, rgba(0,0,0,0.18) 0 6px, transparent 6px 38px)',
            backgroundBlendMode: 'multiply',
            backgroundPosition: `${-heading * 2}px 0`,
          }}
        />
        {condition === 'person' && (
          <User aria-hidden="true" className="absolute left-1/2 top-[38%] -translate-x-1/2 w-40 h-40 text-stone-900/80" />
        )}

        <div className="relative z-10 flex min-h-[680px] flex-col justify-between gap-3 p-3 text-sm">
          {/* 頂部 HUD：田區、已拍張數、定位精度、朝向（大字級時自動換行） */}
          <div className="space-y-2">
            <div className="flex flex-wrap items-center gap-x-3 gap-y-1 rounded-2xl border border-white/20 bg-black/60 px-3 py-2 text-white backdrop-blur-sm">
              <span className="font-bold">{fieldName}</span>
              <span className="flex items-center gap-1">
                <Camera className="w-4 h-4 text-emerald-300" aria-hidden="true" /> 已拍 {capturedCount} 張
              </span>
              <span className="flex items-center gap-1">
                <MapPin className="w-4 h-4 text-emerald-300" aria-hidden="true" /> 定位 ±{GPS_ACCURACY_METERS} 公尺
              </span>
              <span className="flex items-center gap-1">
                <Compass className="w-4 h-4 text-emerald-300" aria-hidden="true" /> {headingToDirection(heading)} {heading}°
              </span>
            </div>

            {pendingTasks.length > 0 && !activeTask && (
              <button
                type="button"
                onClick={() => startReshoot(pendingTasks[0].id)}
                className="flex min-h-12 w-full items-center gap-2 rounded-2xl border border-amber-400/80 bg-amber-900/90 px-3 py-2 text-left font-semibold text-amber-50"
              >
                <Target className="w-5 h-5 shrink-0" aria-hidden="true" />
                <span>還有 {pendingTasks.length} 處要補拍，點這裡帶你去</span>
              </button>
            )}
          </div>

          {/* 中央：即時品質提示或補拍轉向引導 */}
          <div role="status" aria-live="polite" className="flex flex-col items-center gap-3 text-center">
            {liveStatus && (
              <span className={`rounded-full border px-4 py-2 font-semibold ${toneClass[liveStatus.tone]}`}>
                {liveStatus.text}
              </span>
            )}
            {activeTask && guidance && (
              <div className={`w-full rounded-2xl border px-4 py-3 ${guidance.aligned ? toneClass.ok : toneClass.warn}`}>
                <div className="flex items-center justify-center gap-2 text-lg font-bold">
                  {guidance.aligned ? (
                    <CheckCircle2 className="w-7 h-7" aria-hidden="true" />
                  ) : guidance.delta < 0 ? (
                    <ArrowLeft className="w-7 h-7" aria-hidden="true" />
                  ) : null}
                  <span>{guidance.text}</span>
                  {!guidance.aligned && guidance.delta > 0 && <ArrowRight className="w-7 h-7" aria-hidden="true" />}
                </div>
                <div className="mt-1">
                  補拍：{activeTask.fieldSegment}（朝{headingToDirection(activeTask.suggestedHeadingDegrees)}）
                </div>
              </div>
            )}
            {toast && (
              <span className="rounded-full border border-white/30 bg-black/75 px-4 py-2 text-white">{toast}</span>
            )}
          </div>

          {/* 底部操作列：結束／大快門／取消補拍 */}
          <div className="grid grid-cols-[1fr_auto_1fr] items-center rounded-3xl bg-black/55 px-2 py-3 text-white backdrop-blur-sm">
            <button
              type="button"
              onClick={handleEnd}
              className="mx-auto flex min-h-12 min-w-12 flex-col items-center justify-center gap-0.5 font-semibold"
            >
              <X className="w-6 h-6" aria-hidden="true" />
              結束
            </button>

            <button
              type="button"
              onClick={handleShutter}
              aria-label={activeTask ? '補拍這一張' : recording ? '暫停巡田拍攝' : '開始巡田拍攝'}
              className={`mx-2 flex h-[80px] w-[80px] shrink-0 items-center justify-center rounded-full border-4 border-white shadow-lg transition-colors ${
                activeTask
                  ? guidance?.aligned
                    ? 'bg-emerald-600'
                    : 'bg-stone-500'
                  : recording
                    ? 'bg-red-600'
                    : 'bg-emerald-600'
              }`}
            >
              {activeTask ? (
                <Camera className="w-9 h-9" aria-hidden="true" />
              ) : recording ? (
                <Pause className="w-9 h-9" aria-hidden="true" />
              ) : (
                <Play className="w-9 h-9" aria-hidden="true" />
              )}
            </button>

            {activeTask ? (
              <button
                type="button"
                onClick={() => setActiveReshootId(null)}
                className="mx-auto flex min-h-12 min-w-12 flex-col items-center justify-center gap-0.5 font-semibold"
              >
                <ArrowLeft className="w-6 h-6" aria-hidden="true" />
                先不補
              </button>
            ) : (
              <span className="text-center text-stone-300">{recording ? '拍攝中' : '已暫停'}</span>
            )}
          </div>
        </div>

        {/* 取景畫面內的底部面板：離場前查核與完成 */}
        {sheet && (
          <div className="absolute inset-x-0 bottom-0 z-20 max-h-full overflow-y-auto space-y-3 rounded-t-3xl border-t border-stone-700 bg-stone-900/95 p-4 text-stone-100">
            {sheet === 'end' ? (
              <>
                <h4 className="text-lg font-bold">離開前，還有 {pendingTasks.length} 處需要補拍</h4>
                <ul className="space-y-2">
                  {pendingTasks.map((t) => (
                    <li key={t.id} className="rounded-xl bg-stone-800 p-3">
                      <div className="font-semibold">{t.fieldSegment}</div>
                      <div className="text-stone-300">{RESHOOT_REASON_LABEL[t.reason]}</div>
                    </li>
                  ))}
                </ul>
                <button
                  type="button"
                  onClick={() => startReshoot(pendingTasks[0].id)}
                  className="min-h-14 w-full rounded-xl bg-emerald-600 font-bold text-white"
                >
                  帶我去補拍
                </button>
                <button
                  type="button"
                  onClick={finish}
                  className="min-h-12 w-full rounded-xl border border-stone-600 font-semibold"
                >
                  先離開，下次再補
                </button>
              </>
            ) : (
              <>
                <h4 className="flex items-center gap-2 text-lg font-bold">
                  <CheckCircle2 className="w-6 h-6 text-emerald-400" aria-hidden="true" /> 巡田結束，共 {capturedCount} 張
                </h4>
                <p className="text-stone-300">
                  照片已存在手機，連上網路會自動上傳並檢查，不用再按其他按鈕。
                  {skippedCount > 0 && `另有 ${skippedCount} 張模糊或有人入鏡的畫面已自動略過。`}
                </p>
                <button
                  type="button"
                  onClick={() => setSheet(null)}
                  className="min-h-14 w-full rounded-xl bg-emerald-600 font-bold text-white"
                >
                  好
                </button>
              </>
            )}
          </div>
        )}
      </div>

      {/* 原型模擬控制（正式 App 由感測器與影像快篩提供） */}
      <div className="space-y-4 rounded-2xl border border-stone-800 bg-stone-950 p-4 text-sm text-stone-300">
        <div className="font-bold text-white">原型模擬控制</div>
        <p className="text-stone-400">正式 App 由羅盤與手機端模糊快篩自動提供，這裡用來試操作流程。</p>

        <label className="block space-y-1">
          <span>
            模擬轉動手機：<strong className="text-emerald-300">{headingToDirection(heading)} {heading}°</strong>
          </span>
          <input
            type="range"
            min={0}
            max={359}
            value={heading}
            onChange={(e) => setHeading(normalizeHeading(Number(e.target.value)))}
            className="w-full accent-emerald-500"
          />
        </label>

        <fieldset className="space-y-2">
          <legend>模擬現場畫面</legend>
          <div className="flex flex-wrap gap-2">
            {(
              [
                ['clear', '清晰'],
                ['blur', '手晃模糊'],
                ['person', '有人入鏡'],
              ] as const
            ).map(([value, label]) => (
              <button
                key={value}
                type="button"
                onClick={() => setCondition(value)}
                aria-pressed={condition === value}
                className={`min-h-12 rounded-xl border px-4 font-semibold ${
                  condition === value
                    ? 'border-emerald-500 bg-emerald-950 text-emerald-200'
                    : 'border-stone-700 text-stone-300 hover:border-stone-500'
                }`}
              >
                {label}
              </button>
            ))}
          </div>
        </fieldset>

        <ul className="list-disc space-y-1 pl-5 text-stone-400">
          <li>走動時自動連拍，模糊或有人入鏡的畫面自動略過（已略過 {skippedCount} 張）。</li>
          <li>補拍引導直接疊在畫面上：依羅盤顯示往左／往右轉幾度，對準才允許拍。</li>
          <li>按「結束」時若還有待補拍，在相機畫面內提醒，可一鍵帶去補拍。</li>
          <li>結束後自動上傳與檢查，不需要手動「啟動處理」。</li>
        </ul>
      </div>
    </div>
  );
};
