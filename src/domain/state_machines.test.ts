import test from 'node:test';
import assert from 'node:assert/strict';
import {
  transitionTask,
  transitionStaffAssignment,
  evaluateSprayingStatus,
  transitionInspectionQuality
} from './state_machines.ts';

test('Task status transitions follow strict flow', () => {
  assert.equal(transitionTask('DRAFT', 'SCHEDULE'), 'SCHEDULED');
  assert.equal(transitionTask('SCHEDULED', 'START'), 'IN_PROGRESS');
  assert.equal(transitionTask('IN_PROGRESS', 'COMPLETE'), 'COMPLETED');
  assert.throws(() => transitionTask('DRAFT', 'COMPLETE'));
});

test('Staff assignment transitions enforce "calling does not mean agreed"', () => {
  // 1. Initial state
  assert.equal(transitionStaffAssignment('UNCONTACTED', 'CONTACT'), 'CONTACTED_PENDING');
  // 2. Pending to Confirmed only when worker explicitly accepts
  assert.equal(transitionStaffAssignment('CONTACTED_PENDING', 'ACCEPT'), 'CONFIRMED');
  // 3. Worker checks in on site
  assert.equal(transitionStaffAssignment('CONFIRMED', 'CHECK_IN'), 'CHECKED_IN');
  // 4. Completed after workday
  assert.equal(transitionStaffAssignment('CHECKED_IN', 'FINISH'), 'COMPLETED');
  // 5. Worker declines
  assert.equal(transitionStaffAssignment('CONTACTED_PENDING', 'DECLINE'), 'DECLINED');
});

test('Spraying status strictly avoids assuming absence of record means no spray', () => {
  // Absence of record -> PENDING_CONFIRMATION, never CONFIRMED_NOT_APPLIED
  assert.equal(
    evaluateSprayingStatus({ hasExplicitRecord: false }),
    'PENDING_CONFIRMATION'
  );

  // Explicit confirmation by manager that no chemicals were used
  assert.equal(
    evaluateSprayingStatus({
      hasExplicitRecord: true,
      sprayApplied: false,
      isConfirmedByManager: true
    }),
    'CONFIRMED_NOT_APPLIED'
  );

  // Chemical used but details incomplete
  assert.equal(
    evaluateSprayingStatus({
      hasExplicitRecord: true,
      sprayApplied: true,
      hasChemicalDetails: false,
      isConfirmedByManager: true
    }),
    'INCOMPLETE_RECORD'
  );

  // Valid full record
  assert.equal(
    evaluateSprayingStatus({
      hasExplicitRecord: true,
      sprayApplied: true,
      hasChemicalDetails: true,
      isConfirmedByManager: true
    }),
    'APPLIED'
  );
});

test('Inspection quality state machine distinguishes server receipt from validation and reconstruction', () => {
  assert.equal(transitionInspectionQuality('LOCAL_SAVED', 'UPLOAD_FINISHED'), 'SERVER_RECEIVED');
  assert.equal(transitionInspectionQuality('SERVER_RECEIVED', 'START_VALIDATION'), 'VALIDATING');
  assert.equal(transitionInspectionQuality('VALIDATING', 'QUALITY_DEFECT_DETECTED'), 'RESHOOT_REQUIRED');
  assert.equal(transitionInspectionQuality('VALIDATING', 'QUALITY_APPROVED'), 'PASSED');
  assert.equal(transitionInspectionQuality('PASSED', 'START_PROCESSING'), 'PROCESSING');
  assert.equal(transitionInspectionQuality('PROCESSING', 'PROCESSING_FINISHED'), 'READY');
});

test('Phase 5 3D reconstruction pipeline status transitions', async () => {
  const { transitionReconstructionJob, calculateGpuCostTwd, evaluateTapCompliance } = await import('./state_machines.ts');
  
  assert.equal(transitionReconstructionJob('QUEUED', 'START_SFM'), 'STRUCTURE_FROM_MOTION');
  assert.equal(transitionReconstructionJob('STRUCTURE_FROM_MOTION', 'START_TRAINING'), 'DENSE_TRAINING');
  assert.equal(transitionReconstructionJob('DENSE_TRAINING', 'START_MESH'), 'MESH_EXPORTING');
  assert.equal(transitionReconstructionJob('MESH_EXPORTING', 'FINISH'), 'COMPLETED');
  // 3DGS shortcut direct to completed without mesh export
  assert.equal(transitionReconstructionJob('DENSE_TRAINING', 'FINISH'), 'COMPLETED');
  assert.throws(() => transitionReconstructionJob('QUEUED', 'FINISH'));
});

test('Phase 5 GPU cost calculator accurately reflects TWD pricing without hidden fees', async () => {
  const { calculateGpuCostTwd } = await import('./state_machines.ts');
  // GCP T4 16GB: 0.35 USD/hr * 32.5 = 11.375 TWD/hr -> 12 mins is ~2.3 TWD
  const costT4 = calculateGpuCostTwd('GCP_T4_16GB', 12);
  assert.ok(costT4 > 2.0 && costT4 < 2.5);

  // GCP A10G 24GB: 1.05 USD/hr * 32.5 = 34.125 TWD/hr -> 60 mins is 34.1 TWD
  const costA10G = calculateGpuCostTwd('GCP_A10G_24GB', 60);
  assert.equal(costA10G, 34.1);
});

test('Phase 5 TAP Compliance verification detects missing spray audits and prohibited chemicals', async () => {
  const { evaluateTapCompliance } = await import('./state_machines.ts');
  // 1. Prohibited chemicals -> IRREGULAR_RECORD
  assert.equal(
    evaluateTapCompliance({
      hasUnconfirmedSpray: false,
      hasBannedPesticide: true,
      isHarvestDateRecorded: true,
      totalTaskLogsCount: 10,
    }),
    'IRREGULAR_RECORD'
  );

  // 2. Unconfirmed spray -> NEEDS_AUDIT
  assert.equal(
    evaluateTapCompliance({
      hasUnconfirmedSpray: true,
      hasBannedPesticide: false,
      isHarvestDateRecorded: true,
      totalTaskLogsCount: 10,
    }),
    'NEEDS_AUDIT'
  );

  // 3. Fully recorded -> COMPLIANT
  assert.equal(
    evaluateTapCompliance({
      hasUnconfirmedSpray: false,
      hasBannedPesticide: false,
      isHarvestDateRecorded: true,
      totalTaskLogsCount: 8,
    }),
    'COMPLIANT'
  );
});

test('Phase 7 Offline conflict resolution engine protects food safety and merges notes', async () => {
  const { resolveOfflineConflict } = await import('./state_machines.ts');

  // 1. Food safety protection: offline spray report cannot silently override manager signed non-spray
  const sprayConflict = resolveOfflineConflict({
    entityType: 'SPRAYING_RECORD',
    clientValue: 'APPLIED',
    serverValue: 'CONFIRMED_NOT_APPLIED',
    clientTimestamp: '2026-10-19T08:00:00Z',
    serverTimestamp: '2026-10-19T07:30:00Z',
  });
  assert.equal(sprayConflict.action, 'MANUAL_REVIEW_REQUIRED');

  // 2. Field notes merge: preserves both local voice notes and server notes
  const notesConflict = resolveOfflineConflict({
    entityType: 'WORK_LOG',
    clientValue: '巡查第二畦缺水補灌溉',
    serverValue: '晚間已由林伯協助開水閘門',
    clientTimestamp: '2026-10-19T10:00:00Z',
    serverTimestamp: '2026-10-19T11:00:00Z',
  });
  assert.equal(notesConflict.action, 'MERGED');
  assert.ok(notesConflict.finalValue.includes('巡查第二畦缺水補灌溉'));
  assert.ok(notesConflict.finalValue.includes('晚間已由林伯協助開水閘門'));

  // 3. Wage and attendance mismatch: requires manual review
  const attendanceConflict = resolveOfflineConflict({
    entityType: 'ATTENDANCE',
    clientValue: 1800,
    serverValue: 1500,
    clientTimestamp: '2026-10-19T17:00:00Z',
    serverTimestamp: '2026-10-19T16:30:00Z',
  });
  assert.equal(attendanceConflict.action, 'MANUAL_REVIEW_REQUIRED');
});

test('Phase 8 Pesticide safety interval correctly enforces withdrawal period', async () => {
  const { evaluatePesticideSafetyInterval } = await import('./state_machines.ts');

  // Cypermethrin (7 days): sprayed on 2026-10-10, harvested on 2026-10-18 (8 days later) -> SAFE
  const safeResult = evaluatePesticideSafetyInterval(
    'CYPERMETHRIN',
    '2026-10-10',
    '2026-10-18'
  );
  assert.equal(safeResult.isSafeToHarvest, true);
  assert.equal(safeResult.daysRemaining, 0);

  // Cypermethrin: sprayed on 2026-10-16, targeted harvest on 2026-10-18 (only 2 days later) -> UNSAFE
  const unsafeResult = evaluatePesticideSafetyInterval(
    'CYPERMETHRIN',
    '2026-10-16',
    '2026-10-18'
  );
  assert.equal(unsafeResult.isSafeToHarvest, false);
  assert.equal(unsafeResult.daysRemaining, 5);

  // Organic Neem: 0 days interval -> Always safe
  const organicResult = evaluatePesticideSafetyInterval(
    'ORGANIC_NEEM',
    '2026-10-18',
    '2026-10-18'
  );
  assert.equal(organicResult.isSafeToHarvest, true);
});

test('Phase 8 Taiwan disaster relief eligibility evaluates 20% legal threshold', async () => {
  const { calculateDisasterReliefEligibility } = await import('./state_machines.ts');

  // Below 20% threshold: 15% damage -> Not eligible
  const belowThreshold = calculateDisasterReliefEligibility('LEAFY_VEGETABLE', 0.5, 15);
  assert.equal(belowThreshold.isEligibleForRelief, false);
  assert.equal(belowThreshold.calculatedReliefTWD, 0);

  // Meets 20% threshold: 35% damage on 0.5 hectares of leafy vegetables (Rate 44,000/ha) -> Eligible NT$ 22,000
  const eligible = calculateDisasterReliefEligibility('LEAFY_VEGETABLE', 0.5, 35);
  assert.equal(eligible.isEligibleForRelief, true);
  assert.equal(eligible.calculatedReliefTWD, 22000);
});

test('Phase 9 Project completion checklist validates production launch readiness', async () => {
  const { validateProjectCompletion } = await import('./state_machines.ts');

  // Complete checklist
  const readyResult = validateProjectCompletion({
    hasDualRepoArchitecture: true,
    hasOfflineFirstDriftDb: true,
    hasStrictSprayingSafetyRules: true,
    hasMultiCadastreSupport: true,
    hasPhoneContactSeparation: true,
    hasCloudRunCostControl: true,
    hasTaiwanAgriDataIntegration: true,
  });
  assert.equal(readyResult.isReadyForLaunch, true);
  assert.equal(readyResult.readinessStatus, 'READY_FOR_PRODUCTION_LAUNCH');
  assert.equal(readyResult.totalChecksPassed, 7);

  // Missing food safety check -> Incomplete
  const missingResult = validateProjectCompletion({
    hasDualRepoArchitecture: true,
    hasOfflineFirstDriftDb: true,
    hasStrictSprayingSafetyRules: false, // Incomplete!
    hasMultiCadastreSupport: true,
    hasPhoneContactSeparation: true,
    hasCloudRunCostControl: true,
    hasTaiwanAgriDataIntegration: true,
  });
  assert.equal(missingResult.isReadyForLaunch, false);
  assert.equal(missingResult.readinessStatus, 'INCOMPLETE');
  assert.equal(missingResult.totalChecksPassed, 6);
});




