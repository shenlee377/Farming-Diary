/// 同步與備份共用的實體對照：API 的 entity 名稱 ↔ 本機資料表。
library;

import 'package:drift/drift.dart';

import '../db/database.dart';

class EntitySpec<T extends Table, D extends Insertable<D>> {
  /// API 與 outbox 使用的名稱，例如 `field_boundary_version`。
  final String entity;

  /// 備份檔 data.json 的鍵，例如 `fieldBoundaryVersions`。
  final String backupKey;
  final TableInfo<T, D> Function(AppDatabase db) table;
  final D Function(Map<String, dynamic> json) fromJson;
  final String Function(D row) idOf;

  /// 有版本號的實體才做「本機較新就略過」的判斷；只新增的實體為 null。
  final int Function(D row)? versionOf;

  const EntitySpec({
    required this.entity,
    required this.backupKey,
    required this.table,
    required this.fromJson,
    required this.idOf,
    this.versionOf,
  });

  /// 從 JSON 取得 ID（在類別內呼叫，避免透過 `EntitySpec<dynamic>` 呼叫型別化 callback 失敗）。
  String idOfJson(Map<String, dynamic> json) => idOf(fromJson(json));

  /// 依 ID 查本機資料。
  Future<D?> findLocal(AppDatabase db, String id) {
    final t = table(db);
    final idColumn = t.columnsByName['id'] as GeneratedColumn<String>;
    return (db.select(t)..where((_) => idColumn.equals(id))).getSingleOrNull();
  }

  /// 套用伺服器傳來的資料；本機版本較新（尚未推送的修改）時略過。回傳是否寫入。
  Future<bool> applyRemote(AppDatabase db, Map<String, dynamic> payload) async {
    final incoming = fromJson(payload);
    final version = versionOf;
    if (version != null) {
      final local = await findLocal(db, idOf(incoming));
      if (local != null && version(local) > version(incoming)) return false;
    }
    await db.into(table(db)).insertOnConflictUpdate(incoming);
    return true;
  }
}

/// 依外鍵相依順序排列（還原與套用時由上而下）。
final List<EntitySpec> syncEntities = [
  EntitySpec<$FieldsTable, Field>(
    entity: 'field',
    backupKey: 'fields',
    table: (db) => db.fields,
    fromJson: Field.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$FieldBoundaryVersionsTable, FieldBoundaryVersion>(
    entity: 'field_boundary_version',
    backupKey: 'fieldBoundaryVersions',
    table: (db) => db.fieldBoundaryVersions,
    fromJson: FieldBoundaryVersion.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$LandParcelsTable, LandParcel>(
    entity: 'land_parcel',
    backupKey: 'landParcels',
    table: (db) => db.landParcels,
    fromJson: LandParcel.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$FieldParcelsTable, FieldParcel>(
    entity: 'field_parcel',
    backupKey: 'fieldParcels',
    table: (db) => db.fieldParcels,
    fromJson: FieldParcel.fromJson,
    idOf: (r) => '${r.fieldId}:${r.parcelId}',
  ),
  EntitySpec<$LandRelationsTable, LandRelation>(
    entity: 'land_relation',
    backupKey: 'landRelations',
    table: (db) => db.landRelations,
    fromJson: LandRelation.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$CropSeasonsTable, CropSeason>(
    entity: 'crop_season',
    backupKey: 'cropSeasons',
    table: (db) => db.cropSeasons,
    fromJson: CropSeason.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$ContactsTable, Contact>(
    entity: 'contact',
    backupKey: 'contacts',
    table: (db) => db.contacts,
    fromJson: Contact.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$TasksTable, Task>(
    entity: 'task',
    backupKey: 'tasks',
    table: (db) => db.tasks,
    fromJson: Task.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$AssignmentsTable, Assignment>(
    entity: 'assignment',
    backupKey: 'assignments',
    table: (db) => db.assignments,
    fromJson: Assignment.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$AssignmentEventsTable, AssignmentEvent>(
    entity: 'assignment_event',
    backupKey: 'assignmentEvents',
    table: (db) => db.assignmentEvents,
    fromJson: AssignmentEvent.fromJson,
    idOf: (r) => r.id,
  ),
  EntitySpec<$WorkReportsTable, WorkReport>(
    entity: 'work_report',
    backupKey: 'workReports',
    table: (db) => db.workReports,
    fromJson: WorkReport.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$WorkRecordsTable, WorkRecord>(
    entity: 'work_record',
    backupKey: 'workRecords',
    table: (db) => db.workRecords,
    fromJson: WorkRecord.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$WorkRecordInputsTable, WorkRecordInput>(
    entity: 'work_record_input',
    backupKey: 'workRecordInputs',
    table: (db) => db.workRecordInputs,
    fromJson: WorkRecordInput.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$RecordRevisionsTable, RecordRevision>(
    entity: 'record_revision',
    backupKey: 'recordRevisions',
    table: (db) => db.recordRevisions,
    fromJson: RecordRevision.fromJson,
    idOf: (r) => r.id,
  ),
  EntitySpec<$InspectionSessionsTable, InspectionSession>(
    entity: 'inspection_session',
    backupKey: 'inspectionSessions',
    table: (db) => db.inspectionSessions,
    fromJson: InspectionSession.fromJson,
    idOf: (r) => r.id,
    versionOf: (r) => r.version,
  ),
  EntitySpec<$InspectionFramesTable, InspectionFrame>(
    entity: 'inspection_frame',
    backupKey: 'inspectionFrames',
    table: (db) => db.inspectionFrames,
    fromJson: InspectionFrame.fromJson,
    idOf: (r) => r.id,
  ),
  EntitySpec<$ReshootTasksTable, ReshootTask>(
    entity: 'reshoot_task',
    backupKey: 'reshootTasks',
    table: (db) => db.reshootTasks,
    fromJson: ReshootTask.fromJson,
    idOf: (r) => r.id,
  ),
];

EntitySpec? entitySpecFor(String entity) {
  for (final s in syncEntities) {
    if (s.entity == entity) return s;
  }
  return null;
}
