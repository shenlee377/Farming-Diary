import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:farming_diary/core/backup.dart';
import 'package:farming_diary/core/db/database.dart';
import 'package:farming_diary/core/repository.dart';
import 'package:farming_diary/domain/blur.dart';
import 'package:farming_diary/domain/geo.dart';
import 'package:farming_diary/domain/state_machines.dart';
import 'package:flutter_test/flutter_test.dart';

/// 對應 docs/ROADMAP.md §4 端到端情境中可在本機驗證的步驟（2–10），
/// 外加巡田補拍與匯出。
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late Directory tmp;
  late FarmRepository repo;
  late Session session;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tmp = await Directory.systemTemp.createTemp('farming_diary_test');
    session = await SessionStore(db)
        .setUp(displayName: '阿明', workspaceName: '林家田');
    var t = DateTime.utc(2026, 11, 1);
    // 每次取時間前進 1 秒，讓排序與實際使用一樣有先後
    repo = FarmRepository(
      db,
      session,
      Directory('${tmp.path}/media'),
      clock: () => t = t.add(const Duration(seconds: 1)),
    );
  });

  tearDown(() async {
    await db.close();
    await tmp.delete(recursive: true);
  });

  Future<int> outboxCount() async => (await db.select(db.outbox).get()).length;

  test('建立工作空間：本人為擁有者', () async {
    expect(session.role, 'owner');
    expect(session.workspace.name, '林家田');
    final again = await SessionStore(db).load();
    expect(again?.workspaceId, session.workspaceId);
  });

  test('田區、地號多對多、土地關係標示未查證', () async {
    final north = await repo.createField(name: '北田');
    final south = await repo.createField(name: '南田');
    final p1 = await repo.linkParcel(north.id, '新安段 0124-0000');
    await repo.linkParcel(north.id, '新安段 0125-0000');
    final shared = await repo.linkParcel(south.id, '新安段 0124-0000');
    expect(shared.id, p1.id, reason: '同一地號只建一筆，可對應多塊田');

    final rel = await repo.addLandRelation(
      parcelId: p1.id,
      partyName: '王先生',
      kind: 'lessee',
      rentAmount: '12000',
    );
    expect(rel.verification, 'self_reported');

    final parcels = await repo.watchParcelsForField(north.id).first;
    expect(parcels.map((p) => p.parcel.parcelCode), [
      '新安段 0124-0000',
      '新安段 0125-0000',
    ]);
    expect(parcels.first.relations.single.partyName, '王先生');
  });

  test('田界草稿確認後才更新面積，舊田界標為取代', () async {
    final field = await repo.createField(name: '北田');
    const lat = 23.78, lng = 120.46;
    final ring = [
      const GeoPoint(lat, lng, accuracyMeters: 3),
      const GeoPoint(lat, lng + 0.001, accuracyMeters: 4),
      const GeoPoint(lat + 0.001, lng + 0.001, accuracyMeters: 5),
      const GeoPoint(lat + 0.001, lng, accuracyMeters: 3),
    ];
    final draft = await repo.saveBoundaryDraft(field.id, ring);
    expect((await repo.watchField(field.id).first)!.areaM2, isNull);

    await repo.confirmBoundary(draft);
    final updated = (await repo.watchField(field.id).first)!;
    expect(updated.areaM2, closeTo(draft.areaM2, 0.001));
    expect(updated.areaMethod, 'phone_spherical');

    final second = await repo.saveBoundaryDraft(field.id, ring.sublist(0, 3));
    await repo.confirmBoundary(second);
    final versions = await repo.watchBoundaries(field.id).first;
    expect(versions.where((v) => v.status == 'confirmed').single.id, second.id);
    expect(versions.where((v) => v.status == 'superseded').single.id, draft.id);
  });

  test('情境：安排人手 → 回報（原話）→ 確認成正式紀錄', () async {
    final field = await repo.createField(name: '北田');
    final season = await repo.createSeason(
      fieldId: field.id,
      name: '2026 秋作',
      cropName: '高麗菜',
    );
    final aji = await repo.saveContact(name: '阿吉叔', phone: '0912345678');
    final amei = await repo.saveContact(name: '阿美姨');
    expect(aji.linkedUserId, isNull);

    final task = await repo.createTask(
      fieldId: field.id,
      seasonId: season.id,
      title: '北田除草',
      workType: 'weeding',
      plannedStart: DateTime(2026, 11, 2, 7),
      headcountNeeded: 2,
    );
    expect(task.status, TaskStatus.scheduled.name);
    await repo.applyTaskAction(task.id, TaskAction.startStaffing);
    await repo.addAssignment(task.id, aji.id);
    await repo.addAssignment(task.id, amei.id);

    final assignments = await repo.watchAssignments(task.id).first;
    final a1 = assignments.firstWhere((a) => a.contact.id == aji.id).assignment;
    final a2 = assignments
        .firstWhere((a) => a.contact.id == amei.id)
        .assignment;

    await repo.applyAssignmentAction(
      a1.id,
      AssignmentAction.contact,
      channel: 'phone',
    );
    var t = (await repo.watchTask(task.id).first)!;
    expect(t.acceptedCount, 0, reason: '已聯繫不計入已答應');
    expect(t.status, TaskStatus.staffing);

    await repo.applyAssignmentAction(a1.id, AssignmentAction.accept);
    await repo.applyAssignmentAction(a2.id, AssignmentAction.accept);
    t = (await repo.watchTask(task.id).first)!;
    expect(t.acceptedCount, 2);
    expect(t.status, TaskStatus.ready);

    await repo.applyAssignmentAction(
      a2.id,
      AssignmentAction.decline,
      note: '腰痛',
    );
    t = (await repo.watchTask(task.id).first)!;
    expect(t.status, TaskStatus.staffing, reason: '有人改口 → 回到找人中');
    final events = await repo.watchAssignmentEvents(a1.id).first;
    expect(events.map((e) => e.toStatus), [
      AssignmentStatus.accepted.name,
      AssignmentStatus.awaitingReply.name,
    ]);

    // 照片
    final photo = File('${tmp.path}/p.jpg')
      ..writeAsBytesSync(List.filled(64, 7));
    final report = await repo.submitReport(
      taskId: task.id,
      fieldId: field.id,
      rawText: '除草完成',
      rawQuantityText: '用了一包半',
      photos: [
        NewPhoto(
          photo.path,
          DateTime(2026, 11, 2, 11),
          location: const GeoPoint(23.78, 120.46),
        ),
      ],
    );
    expect(report.status, ReportStatus.submitted.name);
    t = (await repo.watchTask(task.id).first)!;
    expect(t.status, TaskStatus.reported, reason: '人力不足仍開工，回報後成為已回報');

    final media = await repo.watchMedia('report', report.id).first;
    expect(media.single.uploadStatus, UploadStatus.localSaved.name);
    expect(media.single.sha256, hasLength(64));
    expect(File(media.single.localPath).existsSync(), isTrue);

    final record = await repo.confirmReport(
      report.id,
      summary: '北田除草',
      pesticideStatus: PesticideStatus.unknown,
    );
    expect(record.pesticideStatus, PesticideStatus.unknown.name);
    expect(record.seasonId, season.id);
    t = (await repo.watchTask(task.id).first)!;
    expect(t.status, TaskStatus.completed);

    final records = await repo.watchRecords(fieldId: field.id).first;
    final input = records.single.inputs.single;
    expect(input.rawQuantityText, '用了一包半');
    expect(input.status, 'pending_spec');

    expect(
      await repo.watchPesticideStatus(field.id).first,
      PesticideStatus.unknown,
    );
    expect(await outboxCount(), greaterThan(10));
  });

  test('長輩最短路徑：未排定的工作直接回報也能完成', () async {
    final field = await repo.createField(name: '北田');
    final task = await repo.createTask(
      fieldId: field.id,
      title: '巡水',
      workType: 'irrigation',
    );
    expect(task.status, TaskStatus.draft.name);
    await repo.submitReport(taskId: task.id, fieldId: field.id);
    final t = (await repo.watchTask(task.id).first)!;
    expect(t.status, TaskStatus.reported);
    expect(t.task.plannedStart, isNotNull);
  });

  test('要求補資料 → 補件 → 退回，退回時工作回到進行中', () async {
    final field = await repo.createField(name: '北田');
    final task = await repo.createTask(
      fieldId: field.id,
      title: '施肥',
      workType: 'fertilizing',
      plannedStart: DateTime(2026, 11, 3),
    );
    final report = await repo.submitReport(
      taskId: task.id,
      fieldId: field.id,
      rawQuantityText: '一包半',
    );
    await repo.openReview(report.id);
    await repo.requestInfo(report.id, '一包半是幾公斤？');
    var rv = (await repo.watchReport(report.id).first)!;
    expect(rv.status, ReportStatus.needsInfo);
    await repo.resubmit(report.id, '一包 40 公斤');
    rv = (await repo.watchReport(report.id).first)!;
    expect(rv.status, ReportStatus.submitted);
    expect(rv.report.rawText, contains('一包 40 公斤'));
    await repo.openReview(report.id);
    await repo.rejectReport(report.id, '請補拍照片');
    expect(
      (await repo.watchTask(task.id).first)!.status,
      TaskStatus.inProgress,
    );
  });

  test('改期：已答應的人改為需再確認，不計入人手', () async {
    final field = await repo.createField(name: '北田');
    final c = await repo.saveContact(name: '阿吉叔');
    final task = await repo.createTask(
      fieldId: field.id,
      title: '採收',
      workType: 'harvest',
      plannedStart: DateTime(2026, 11, 5),
      headcountNeeded: 1,
    );
    await repo.applyTaskAction(task.id, TaskAction.startStaffing);
    await repo.addAssignment(task.id, c.id);
    final a = (await repo.watchAssignments(task.id).first).single.assignment;
    await repo.applyAssignmentAction(a.id, AssignmentAction.accept);
    expect((await repo.watchTask(task.id).first)!.status, TaskStatus.ready);

    await repo.applyTaskAction(task.id, TaskAction.reschedule);
    await repo.applyTaskAction(
      task.id,
      TaskAction.rescheduleConfirmed,
      newPlannedStart: DateTime(2026, 11, 8),
    );
    final t = (await repo.watchTask(task.id).first)!;
    expect(t.status, TaskStatus.scheduled);
    expect(t.task.plannedStart, DateTime(2026, 11, 8));
    expect(t.acceptedCount, 0);
    expect(
      (await repo.watchAssignments(task.id).first).single.status,
      AssignmentStatus.needsReconfirm,
    );
  });

  test('修正與作廢正式紀錄都留下修改歷程', () async {
    final field = await repo.createField(name: '北田');
    final report = await repo.submitReport(fieldId: field.id, rawText: '噴藥');
    final record = await repo.confirmReport(
      report.id,
      summary: '噴藥',
      pesticideStatus: PesticideStatus.incomplete,
    );
    await repo.amendRecord(
      record,
      reason: '補上藥名',
      summary: '噴藥（某藥劑）',
      pesticideStatus: PesticideStatus.applied,
    );
    var revisions = await repo.watchRevisions(record.id).first;
    expect(revisions, hasLength(1));
    expect(jsonDecode(revisions.single.beforeJson)['summary'], '噴藥');
    expect(
      await repo.watchPesticideStatus(field.id).first,
      PesticideStatus.applied,
    );

    final current =
        (await repo.watchRecords(fieldId: field.id).first).single.record;
    await repo.voidRecord(current, '記錯田');
    revisions = await repo.watchRevisions(record.id).first;
    expect(revisions, hasLength(2));
    expect(await repo.watchRecords(fieldId: field.id).first, isEmpty);
    expect(
      await repo.watchPesticideStatus(field.id).first,
      PesticideStatus.unknown,
    );
    expect(
      (await repo.watchReport(report.id).first)!.status,
      ReportStatus.voided,
    );
  });

  test('巡田：某方向只有模糊畫面 → 結束時列為補拍；補拍後解除', () async {
    final field = await repo.createField(name: '北田');
    final s = await repo.startInspection(field.id);
    final photo = File('${tmp.path}/f.jpg')
      ..writeAsBytesSync(List.filled(32, 1));
    // 朝東：清晰照片
    await repo.addInspectionFrame(
      s.id,
      quality: FrameQuality.sharp,
      blurScore: 200,
      photoPath: photo.path,
      headingDeg: 92,
    );
    // 朝西：兩次都模糊
    await repo.addInspectionFrame(
      s.id,
      quality: FrameQuality.blurry,
      blurScore: 10,
      headingDeg: 268,
    );
    await repo.addInspectionFrame(
      s.id,
      quality: FrameQuality.blurry,
      blurScore: 12,
      headingDeg: 275,
    );
    // 朝北：只閃過一次，不算缺漏
    await repo.addInspectionFrame(
      s.id,
      quality: FrameQuality.blurry,
      blurScore: 12,
      headingDeg: 2,
    );

    final pending = await repo.endInspection(s.id);
    expect(pending, hasLength(1));
    expect(pending.single.headingDeg, 270);
    expect(pending.single.description, contains('西'));
    var session = (await repo.watchInspections(field.id).first).single;
    expect(session.status, 'reshoot_required');
    expect(session.keptFrames, 1);
    expect(session.skippedFrames, 3);

    await repo.addInspectionFrame(
      s.id,
      quality: FrameQuality.sharp,
      blurScore: 210,
      photoPath: photo.path,
      headingDeg: 271,
      reshootTaskId: pending.single.id,
    );
    expect(await repo.endInspection(s.id), isEmpty);
    session = (await repo.watchInspections(field.id).first).single;
    expect(session.status, 'local_saved');
  });

  test('匯出包含全部資料且只含本工作空間', () async {
    await repo.createField(name: '北田');
    final other = await SessionStore(db).createWorkspace('別人的田');
    final otherSession = (await SessionStore(db).load())!;
    expect(otherSession.workspaceId, other.id);
    await FarmRepository(
      db,
      otherSession,
      Directory('${tmp.path}/m2'),
    ).createField(name: '不該出現');

    final data = await repo.exportWorkspace();
    expect((data['fields'] as List).map((f) => f['name']), ['北田']);
    expect(jsonEncode(data), isNot(contains('不該出現')));
  });

  test('非法狀態轉移不會寫入資料', () async {
    final field = await repo.createField(name: '北田');
    final task = await repo.createTask(
      fieldId: field.id,
      title: 'x',
      workType: 'other',
      plannedStart: DateTime(2026, 11, 1),
    );
    final before = await outboxCount();
    await expectLater(
      repo.applyTaskAction(task.id, TaskAction.confirm),
      throwsA(isA<IllegalTransition>()),
    );
    expect(await outboxCount(), before);
    expect((await repo.watchTask(task.id).first)!.status, TaskStatus.scheduled);
  });

  test('修改工作需要人數後重新判斷人手', () async {
    final field = await repo.createField(name: '北田');
    final c = await repo.saveContact(name: '阿吉叔');
    final task = await repo.createTask(
      fieldId: field.id,
      title: '採收',
      workType: 'harvest',
      plannedStart: DateTime(2026, 11, 5),
      headcountNeeded: 2,
    );
    await repo.applyTaskAction(task.id, TaskAction.startStaffing);
    await repo.addAssignment(task.id, c.id);
    final a = (await repo.watchAssignments(task.id).first).single.assignment;
    await repo.applyAssignmentAction(a.id, AssignmentAction.accept);
    expect((await repo.watchTask(task.id).first)!.status, TaskStatus.staffing);

    await repo.updateTask(
      task.id,
      title: '採收高麗菜',
      workType: 'harvest',
      headcountNeeded: 1,
    );
    var t = (await repo.watchTask(task.id).first)!;
    expect(t.task.title, '採收高麗菜');
    expect(t.status, TaskStatus.ready);

    await repo.updateTask(
      task.id,
      title: '採收高麗菜',
      workType: 'harvest',
      headcountNeeded: 3,
    );
    t = (await repo.watchTask(task.id).first)!;
    expect(t.status, TaskStatus.staffing);
  });

  test('備份 → 在另一支手機還原：資料與照片完整', () async {
    final field = await repo.createField(name: '北田');
    final parcel = await repo.linkParcel(field.id, '新安段 0124-0000');
    await repo.addLandRelation(
      parcelId: parcel.id,
      partyName: '王先生',
      kind: 'lessee',
    );
    final photo = File('${tmp.path}/p.jpg')
      ..writeAsBytesSync(List.generate(500, (i) => i % 256));
    final report = await repo.submitReport(
      fieldId: field.id,
      rawText: '除草',
      photos: [NewPhoto(photo.path, DateTime(2026, 11, 2))],
    );
    await repo.confirmReport(
      report.id,
      summary: '除草',
      pesticideStatus: PesticideStatus.confirmedNone,
    );

    final zip = await createBackup(repo, tmp);
    expect(zip.existsSync(), isTrue);

    // 另一支手機：全新資料庫
    final db2 = AppDatabase(NativeDatabase.memory());
    addTearDown(db2.close);
    final store2 = SessionStore(db2);
    await store2.ensureProfile('阿明');
    final media2 = Directory('${tmp.path}/media2');
    final result = await restoreBackup(
      db: db2,
      store: store2,
      zipPath: zip.path,
      mediaDir: media2,
      workDir: tmp,
    );
    expect(result.workspace.name, '林家田');
    expect(result.photos, 1);

    final s2 = (await store2.load())!;
    expect(s2.workspaceId, session.workspaceId);
    expect(s2.role, 'owner');
    final repo2 = FarmRepository(db2, s2, media2);
    final fields = await repo2.watchFields().first;
    expect(fields.single.name, '北田');
    final parcels = await repo2.watchParcelsForField(field.id).first;
    expect(parcels.single.relations.single.partyName, '王先生');
    final records = await repo2.watchRecords().first;
    expect(
      records.single.record.pesticideStatus,
      PesticideStatus.confirmedNone.name,
    );
    final media = await repo2.watchMedia('report', report.id).first;
    expect(
      File(media.single.localPath).readAsBytesSync(),
      photo.readAsBytesSync(),
    );
    expect(
      await repo2.watchPendingOutbox().first,
      greaterThan(0),
      reason: '還原的資料也要排入同步',
    );

    // 同一個農場不能再還原一次
    await expectLater(
      restoreBackup(
        db: db2,
        store: store2,
        zipPath: zip.path,
        mediaDir: media2,
        workDir: tmp,
      ),
      throwsA(isA<RestoreException>()),
    );
  });

  test('不是備份檔時清楚拒絕', () async {
    final bogus = File('${tmp.path}/bogus.zip')..writeAsStringSync('not a zip');
    await expectLater(
      restoreBackup(
        db: db,
        store: SessionStore(db),
        zipPath: bogus.path,
        mediaDir: tmp,
        workDir: tmp,
      ),
      throwsA(isA<RestoreException>()),
    );
  });
}
