/**
 * 巡田相機畫面用的顯示輔助函式：方位文字、轉向引導、狀態白話文字。
 * 介面上不直接顯示列舉值（例如 RESHOOT_REQUIRED），一律轉成農民看得懂的中文。
 */
import type { InspectionSession, ReshootTask } from '../types/index.ts';

const DIRECTIONS_16 = [
  '北', '北北東', '東北', '東北東', '東', '東南東', '東南', '南南東',
  '南', '南南西', '西南', '西南西', '西', '西北西', '西北', '北北西',
];

/** 將任意角度正規化到 0~359。 */
export function normalizeHeading(degrees: number): number {
  return ((Math.round(degrees) % 360) + 360) % 360;
}

/** 依角度回傳 16 方位中文，例如 285 → 西北西。 */
export function headingToDirection(degrees: number): string {
  return DIRECTIONS_16[Math.round(normalizeHeading(degrees) / 22.5) % 16];
}

/** 目前朝向到目標朝向的最短轉角：正值往右（順時針），負值往左。範圍 -180~180。 */
export function turnDelta(currentDegrees: number, targetDegrees: number): number {
  const diff = normalizeHeading(targetDegrees - currentDegrees);
  return diff > 180 ? diff - 360 : diff;
}

/** 對準容許誤差（度）。 */
export const ALIGN_TOLERANCE_DEGREES = 15;

export interface TurnGuidance {
  aligned: boolean;
  delta: number;
  text: string;
}

/** 補拍時在取景畫面中顯示的轉向提示。 */
export function turnGuidance(currentDegrees: number, targetDegrees: number): TurnGuidance {
  const delta = turnDelta(currentDegrees, targetDegrees);
  if (Math.abs(delta) <= ALIGN_TOLERANCE_DEGREES) {
    return { aligned: true, delta, text: '對準了，按下快門' };
  }
  const side = delta > 0 ? '往右轉' : '往左轉';
  return { aligned: false, delta, text: `${side}約 ${Math.round(Math.abs(delta) / 5) * 5}°` };
}

export const QUALITY_STATUS_LABEL: Record<InspectionSession['qualityStatus'], string> = {
  LOCAL_SAVED: '已存在手機',
  SERVER_RECEIVED: '已上傳',
  VALIDATING: '檢查照片中',
  RESHOOT_REQUIRED: '需要補拍',
  PASSED: '照片檢查通過',
  PROCESSING: '整理成果中',
  READY: '巡田成果完成',
  PARTIAL: '部分完成',
  FAILED: '處理失敗',
};

export const RESHOOT_REASON_LABEL: Record<ReshootTask['reason'], string> = {
  EXCESSIVE_BLUR: '照片太模糊',
  PERSON_OCCLUSION_UNREPLACEABLE: '有人擋住，且沒有其他照片可替代',
  ANGLE_GAP: '缺少這個角度',
  INSUFFICIENT_OVERLAP: '前後照片重疊不足',
};
