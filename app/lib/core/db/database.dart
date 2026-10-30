/// 本機 SQLite（Drift）。M1 本機優先（DECISIONS D-013）：資料先存手機，
/// 每筆寫入同時記在 [Outbox]，後端完成後由同步服務送出。
///
/// 欄位命名對應 docs/DOMAIN_MODEL.md；本機版省略伺服器才有的欄位（稽核、權限）。
library;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// 共通欄位：UUIDv7 主鍵、工作空間、樂觀鎖版本、建立／修改時間與人、封存。
mixin BusinessColumns on Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get createdBy => text()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get updatedBy => text()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

/// 這支手機上的使用者身分。M1 為本機 dev 身分；接上咖啡廳 OAuth 後改由後端發 user_id。
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text()();
  TextColumn get identityKind =>
      text().withDefault(const Constant('local_dev'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Workspaces extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get createdBy => text()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Memberships extends Table {
  TextColumn get workspaceId => text()();
  TextColumn get userId => text()();
  TextColumn get role =>
      text()(); // owner/manager/bookkeeper/worker/advisor/viewer
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {workspaceId, userId};
}

class Fields extends Table with BusinessColumns {
  TextColumn get name => text()();
  TextColumn get aliases => text().withDefault(const Constant(''))();
  RealColumn get areaM2 => real().nullable()();
  TextColumn get areaMethod =>
      text().nullable()(); // phone_spherical / user_input
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class FieldBoundaryVersions extends Table with BusinessColumns {
  TextColumn get fieldId => text()();
  TextColumn get pointsJson => text()(); // [{lat,lng,acc}]
  TextColumn get source => text()(); // track_draft / drawn / import
  RealColumn get medianAccuracyM => real().nullable()();
  RealColumn get areaM2 => real()();
  TextColumn get status => text()(); // draft / confirmed / superseded

  @override
  Set<Column> get primaryKey => {id};
}

class LandParcels extends Table with BusinessColumns {
  TextColumn get parcelCode => text()(); // 例：西螺鎮新安段 0124-0000
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class FieldParcels extends Table {
  TextColumn get workspaceId => text()();
  TextColumn get fieldId => text()();
  TextColumn get parcelId => text()();

  @override
  Set<Column> get primaryKey => {fieldId, parcelId};
}

class LandRelations extends Table with BusinessColumns {
  TextColumn get parcelId => text()();
  TextColumn get partyName => text()();
  TextColumn get kind => text()(); // owner/co_owner/lessee/operator/user
  TextColumn get share => text().withDefault(const Constant(''))();
  DateTimeColumn get periodStart => dateTime().nullable()();
  DateTimeColumn get periodEnd => dateTime().nullable()();
  TextColumn get rentAmount => text().nullable()(); // 十進位字串，避免浮點誤差；敏感
  TextColumn get verification =>
      text().withDefault(const Constant('self_reported'))();

  @override
  Set<Column> get primaryKey => {id};
}

class CropSeasons extends Table with BusinessColumns {
  TextColumn get fieldId => text()();
  TextColumn get name => text()();
  TextColumn get cropName => text()();
  TextColumn get variety => text().withDefault(const Constant(''))();
  TextColumn get status => text()(); // planned/active/fallow/closed
  DateTimeColumn get plannedStart => dateTime().nullable()();
  DateTimeColumn get actualStart => dateTime().nullable()();
  DateTimeColumn get plannedEnd => dateTime().nullable()();
  DateTimeColumn get actualEnd => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Contacts extends Table with BusinessColumns {
  TextColumn get name => text()();
  TextColumn get nickname => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get preferredChannel =>
      text().withDefault(const Constant('phone'))();
  TextColumn get workConstraints => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get linkedUserId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Tasks extends Table with BusinessColumns {
  TextColumn get fieldId => text()();
  TextColumn get seasonId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get workType => text()();
  TextColumn get status => text()();
  DateTimeColumn get plannedStart => dateTime().nullable()();
  DateTimeColumn get plannedEnd => dateTime().nullable()();
  DateTimeColumn get meetAt => dateTime().nullable()();
  TextColumn get meetPlace => text().withDefault(const Constant(''))();
  IntColumn get headcountNeeded => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class Assignments extends Table with BusinessColumns {
  TextColumn get taskId => text()();
  TextColumn get contactId => text()();
  TextColumn get role => text().withDefault(const Constant('member'))();
  TextColumn get status => text()();
  TextColumn get wageRateSnapshot => text().nullable()(); // 答應時寫入；敏感

  @override
  Set<Column> get primaryKey => {id};
}

class AssignmentEvents extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get assignmentId => text()();
  TextColumn get action => text()();
  TextColumn get fromStatus => text()();
  TextColumn get toStatus => text()();
  TextColumn get channel =>
      text().withDefault(const Constant(''))(); // phone/line/in_person
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get at => dateTime()();
  TextColumn get by => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkReports extends Table with BusinessColumns {
  TextColumn get taskId => text().nullable()();
  TextColumn get fieldId => text()();
  TextColumn get reportedByKind =>
      text().withDefault(const Constant('user'))(); // user/contact_via_user
  TextColumn get reporterName => text()();
  DateTimeColumn get actualStart => dateTime().nullable()();
  DateTimeColumn get actualEnd => dateTime().nullable()();
  TextColumn get rawText => text().withDefault(const Constant(''))();
  TextColumn get rawQuantityText =>
      text().withDefault(const Constant(''))(); // 原話，例：一包半
  TextColumn get pesticideClaim =>
      text().withDefault(const Constant('unknown'))(); // 回報者自述
  TextColumn get status => text()();
  TextColumn get reviewNote => text().withDefault(const Constant(''))();
  DateTimeColumn get submittedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkRecords extends Table with BusinessColumns {
  TextColumn get reportId => text()();
  TextColumn get fieldId => text()();
  TextColumn get seasonId => text().nullable()();
  TextColumn get workType => text()();
  DateTimeColumn get performedOn => dateTime()();
  TextColumn get summary => text()();
  TextColumn get pesticideStatus => text()();
  TextColumn get status => text()(); // confirmed / amended / voided
  TextColumn get confirmedBy => text()();
  DateTimeColumn get confirmedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkRecordInputs extends Table with BusinessColumns {
  TextColumn get recordId => text()();
  TextColumn get productName => text().withDefault(const Constant(''))();
  TextColumn get rawQuantityText => text()();
  TextColumn get quantity => text().nullable()(); // 十進位字串
  TextColumn get unitCode => text().nullable()();
  TextColumn get conversionBasis => text().withDefault(const Constant(''))();
  TextColumn get status => text()(); // pending_spec / confirmed

  @override
  Set<Column> get primaryKey => {id};
}

class RecordRevisions extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get recordId => text()();
  TextColumn get beforeJson => text()();
  TextColumn get afterJson => text()();
  TextColumn get reason => text()();
  TextColumn get by => text()();
  DateTimeColumn get at => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 照片等媒體。原檔複製到 App 私有目錄，不需要儲存空間權限。
class MediaAssets extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get ownerKind => text()(); // report / inspection
  TextColumn get ownerId => text()();
  TextColumn get localPath => text()();
  TextColumn get kind => text().withDefault(const Constant('photo'))();
  TextColumn get mime => text().withDefault(const Constant('image/jpeg'))();
  IntColumn get sizeBytes => integer()();
  TextColumn get sha256 => text()();
  DateTimeColumn get capturedAt => dateTime()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  RealColumn get accuracyM => real().nullable()();
  RealColumn get headingDeg => real().nullable()();
  TextColumn get clientUploadId => text()(); // 冪等鍵
  TextColumn get uploadStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class InspectionSessions extends Table with BusinessColumns {
  TextColumn get fieldId => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get status => text()(); // capturing / local_saved / reshoot_required / capture_passed_local
  IntColumn get keptFrames => integer().withDefault(const Constant(0))();
  IntColumn get skippedFrames => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class InspectionFrames extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get sessionId => text()();
  TextColumn get mediaId => text().nullable()();
  DateTimeColumn get capturedAt => dateTime()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  RealColumn get accuracyM => real().nullable()();
  RealColumn get headingDeg => real().nullable()();
  RealColumn get blurScore => real()();
  TextColumn get quality => text()(); // sharp / blurry / tooDark
  TextColumn get reshootTaskId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ReshootTasks extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text()();
  TextColumn get sessionId => text()();
  TextColumn get reason => text()(); // excessive_blur / angle_gap
  TextColumn get description => text()();
  RealColumn get headingDeg => real()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get status => text()(); // pending / resolved / dismissed
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 記錄田界時的軌跡點；先寫進資料庫，螢幕關閉或 App 被系統暫停也不會遺失。
class TrackPoints extends Table {
  IntColumn get seq => integer().autoIncrement()();
  TextColumn get trackId => text()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  RealColumn get accuracyM => real().nullable()();
  DateTimeColumn get at => dateTime()();
}

/// 待送往伺服器的變更。後端完成前只累積，不會遺失。
class Outbox extends Table {
  IntColumn get seq => integer().autoIncrement()();
  TextColumn get workspaceId => text()();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();
  TextColumn get op => text()(); // upsert / archive
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get status => text().withDefault(
    const Constant('pending'),
  )(); // pending / sent / failed
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    Profiles,
    Workspaces,
    Memberships,
    Fields,
    FieldBoundaryVersions,
    LandParcels,
    FieldParcels,
    LandRelations,
    CropSeasons,
    Contacts,
    Tasks,
    Assignments,
    AssignmentEvents,
    WorkReports,
    WorkRecords,
    WorkRecordInputs,
    RecordRevisions,
    MediaAssets,
    InspectionSessions,
    InspectionFrames,
    ReshootTasks,
    TrackPoints,
    Outbox,
    Settings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  factory AppDatabase.open() =>
      AppDatabase(driftDatabase(name: 'farming_diary'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
