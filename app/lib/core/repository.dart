/// 資料存取層。所有寫入都在交易中完成，並同時寫一筆 [Outbox]，
/// 狀態轉移一律經過 domain/state_machines.dart 驗證。
library;

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../domain/blur.dart';
import '../domain/geo.dart';
import '../domain/state_machines.dart';
import 'db/database.dart';

typedef Clock = DateTime Function();

const _uuid = Uuid();
String newId() => _uuid.v7();

/// 目前登入的身分與工作空間。
class Session {
  final Profile profile;
  final Workspace workspace;
  final String role;

  const Session(this.profile, this.workspace, this.role);

  String get userId => profile.id;
  String get workspaceId => workspace.id;
}

/// 啟動與身分相關的操作（尚未有工作空間時也能用）。
class SessionStore {
  final AppDatabase db;
  final Clock now;

  SessionStore(this.db, {Clock? clock}) : now = clock ?? DateTime.now;

  static const _currentWorkspaceKey = 'current_workspace_id';

  Future<Session?> load() async {
    final profile = await db.select(db.profiles).getSingleOrNull();
    if (profile == null) return null;
    final currentId =
        (await (db.select(db.settings)
                  ..where((s) => s.key.equals(_currentWorkspaceKey)))
                .getSingleOrNull())
            ?.value;
    final memberships =
        await (db.select(db.memberships)..where(
              (m) => m.userId.equals(profile.id) & m.status.equals('active'),
            ))
            .get();
    if (memberships.isEmpty) return null;
    final membership = memberships.firstWhere(
      (m) => m.workspaceId == currentId,
      orElse: () => memberships.first,
    );
    final workspace = await (db.select(
      db.workspaces,
    )..where((w) => w.id.equals(membership.workspaceId))).getSingle();
    return Session(profile, workspace, membership.role);
  }

  Future<List<Workspace>> workspaces() async {
    final profile = await db.select(db.profiles).getSingleOrNull();
    if (profile == null) return [];
    final query =
        db.select(db.workspaces).join([
            innerJoin(
              db.memberships,
              db.memberships.workspaceId.equalsExp(db.workspaces.id),
            ),
          ])
          ..where(
            db.memberships.userId.equals(profile.id) &
                db.memberships.status.equals('active'),
          )
          ..orderBy([OrderingTerm.asc(db.workspaces.createdAt)]);
    return (await query.get()).map((r) => r.readTable(db.workspaces)).toList();
  }

  /// 第一次使用：建立本機身分與第一個工作空間（擁有者）。
  Future<Session> setUp({
    required String displayName,
    required String workspaceName,
  }) async {
    return db.transaction(() async {
      var profile = await db.select(db.profiles).getSingleOrNull();
      if (profile == null) {
        profile = Profile(
          id: newId(),
          displayName: displayName.trim(),
          identityKind: 'local_dev',
          createdAt: now(),
        );
        await db.into(db.profiles).insert(profile);
      }
      await createWorkspace(workspaceName, profile: profile);
      return (await load())!;
    });
  }

  /// 只建立本機身分（例：重裝後先建立身分再從備份還原）。
  Future<Profile> ensureProfile(String displayName) async {
    final existing = await db.select(db.profiles).getSingleOrNull();
    if (existing != null) return existing;
    final profile = Profile(
      id: newId(),
      displayName: displayName.trim(),
      identityKind: 'local_dev',
      createdAt: now(),
    );
    await db.into(db.profiles).insert(profile);
    return profile;
  }

  Future<Workspace> createWorkspace(String name, {Profile? profile}) async {
    profile ??= await db.select(db.profiles).getSingle();
    final ws = Workspace(
      id: newId(),
      name: name.trim(),
      createdAt: now(),
      createdBy: profile.id,
    );
    await db.transaction(() async {
      await db.into(db.workspaces).insert(ws);
      await db
          .into(db.memberships)
          .insert(
            Membership(
              workspaceId: ws.id,
              userId: profile!.id,
              role: 'owner',
              status: 'active',
            ),
          );
      await db
          .into(db.outbox)
          .insert(
            OutboxCompanion.insert(
              workspaceId: ws.id,
              entity: 'workspace',
              entityId: ws.id,
              op: 'upsert',
              payloadJson: jsonEncode(ws.toJson()),
              createdAt: now(),
            ),
          );
      await switchWorkspace(ws.id);
    });
    return ws;
  }

  Future<void> switchWorkspace(String workspaceId) => db
      .into(db.settings)
      .insertOnConflictUpdate(
        Setting(key: _currentWorkspaceKey, value: workspaceId),
      );

  Future<void> renameProfile(String displayName) async {
    await db
        .update(db.profiles)
        .write(ProfilesCompanion(displayName: Value(displayName.trim())));
  }
}

class TaskWithField {
  final Task task;
  final Field field;
  final int acceptedCount;
  final int contactedCount;

  const TaskWithField(
    this.task,
    this.field,
    this.acceptedCount,
    this.contactedCount,
  );

  TaskStatus get status => TaskStatus.parse(task.status);
}

class AssignmentWithContact {
  final Assignment assignment;
  final Contact contact;

  const AssignmentWithContact(this.assignment, this.contact);

  AssignmentStatus get status => AssignmentStatus.parse(assignment.status);
}

class ParcelWithRelations {
  final LandParcel parcel;
  final List<LandRelation> relations;

  const ParcelWithRelations(this.parcel, this.relations);
}

class ReportView {
  final WorkReport report;
  final Field field;
  final Task? task;

  const ReportView(this.report, this.field, this.task);

  ReportStatus get status => ReportStatus.parse(report.status);
}

class RecordView {
  final WorkRecord record;
  final Field field;
  final List<WorkRecordInput> inputs;

  const RecordView(this.record, this.field, this.inputs);
}

const _imageMime = {
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.png': 'image/png',
  '.heic': 'image/heic',
};
const _audioMime = {
  '.m4a': 'audio/mp4',
  '.aac': 'audio/aac',
  '.wav': 'audio/wav',
};

/// 要加入的媒體檔（照片或語音，依副檔名判斷）。
class NewPhoto {
  final String sourcePath;
  final DateTime capturedAt;
  final GeoPoint? location;
  final double? headingDeg;

  const NewPhoto(
    this.sourcePath,
    this.capturedAt, {
    this.location,
    this.headingDeg,
  });
}

/// 某個工作空間內的所有資料操作。
class FarmRepository {
  final AppDatabase db;
  final Session session;
  final Directory mediaDir;
  final Clock now;

  FarmRepository(this.db, this.session, this.mediaDir, {Clock? clock})
    : now = clock ?? DateTime.now;

  String get _ws => session.workspaceId;
  String get _me => session.userId;

  Future<void> _log(
    String entity,
    String id,
    Map<String, dynamic> payload, {
    String op = 'upsert',
  }) => db
      .into(db.outbox)
      .insert(
        OutboxCompanion.insert(
          workspaceId: _ws,
          entity: entity,
          entityId: id,
          op: op,
          payloadJson: jsonEncode(payload),
          createdAt: now(),
        ),
      );

  // ───────────────────────── 田區 ─────────────────────────

  Stream<List<Field>> watchFields() =>
      (db.select(db.fields)
            ..where((f) => f.workspaceId.equals(_ws) & f.archivedAt.isNull())
            ..orderBy([(f) => OrderingTerm.asc(f.name)]))
          .watch();

  Stream<Field?> watchField(String id) =>
      (db.select(db.fields)
            ..where((f) => f.id.equals(id) & f.workspaceId.equals(_ws)))
          .watchSingleOrNull();

  Future<Field> createField({
    required String name,
    String aliases = '',
    String notes = '',
    double? areaM2,
  }) async {
    final t = now();
    final field = Field(
      id: newId(),
      workspaceId: _ws,
      version: 1,
      createdAt: t,
      createdBy: _me,
      updatedAt: t,
      updatedBy: _me,
      name: name.trim(),
      aliases: aliases.trim(),
      notes: notes.trim(),
      areaM2: areaM2,
      areaMethod: areaM2 == null ? null : 'user_input',
    );
    await db.transaction(() async {
      await db.into(db.fields).insert(field);
      await _log('field', field.id, field.toJson());
    });
    return field;
  }

  Future<void> updateField(
    Field field, {
    String? name,
    String? aliases,
    String? notes,
    double? manualAreaM2,
  }) async {
    await db.transaction(() async {
      final updated = field.copyWith(
        name: name?.trim() ?? field.name,
        aliases: aliases?.trim() ?? field.aliases,
        notes: notes?.trim() ?? field.notes,
        areaM2: manualAreaM2 == null
            ? Value(field.areaM2)
            : Value(manualAreaM2),
        areaMethod: manualAreaM2 == null
            ? Value(field.areaMethod)
            : const Value('user_input'),
        version: field.version + 1,
        updatedAt: now(),
        updatedBy: _me,
      );
      await db.update(db.fields).replace(updated);
      await _log('field', field.id, updated.toJson());
    });
  }

  Future<void> archiveField(Field field) async {
    await db.transaction(() async {
      final archived = field.copyWith(
        archivedAt: Value(now()),
        version: field.version + 1,
        updatedAt: now(),
      );
      await db.update(db.fields).replace(archived);
      await _log('field', field.id, archived.toJson(), op: 'archive');
    });
  }

  // ───────────────────────── 田界 ─────────────────────────

  Stream<List<FieldBoundaryVersion>> watchBoundaries(String fieldId) =>
      (db.select(db.fieldBoundaryVersions)
            ..where(
              (b) => b.fieldId.equals(fieldId) & b.workspaceId.equals(_ws),
            )
            ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
          .watch();

  /// 保存軌跡為田界草稿；需要使用者確認後才更新田區面積。
  Future<FieldBoundaryVersion> saveBoundaryDraft(
    String fieldId,
    List<GeoPoint> points, {
    String source = 'track_draft',
  }) async {
    if (points.length < 3) throw ArgumentError('田界至少需要 3 個點');
    final accuracies =
        points.map((p) => p.accuracyMeters).whereType<double>().toList()
          ..sort();
    final t = now();
    final version = FieldBoundaryVersion(
      id: newId(),
      workspaceId: _ws,
      version: 1,
      createdAt: t,
      createdBy: _me,
      updatedAt: t,
      updatedBy: _me,
      fieldId: fieldId,
      pointsJson: jsonEncode(points.map((p) => p.toJson()).toList()),
      source: source,
      medianAccuracyM: accuracies.isEmpty
          ? null
          : accuracies[accuracies.length ~/ 2],
      areaM2: polygonAreaSquareMeters(points),
      status: 'draft',
    );
    await db.transaction(() async {
      await db.into(db.fieldBoundaryVersions).insert(version);
      await _log('field_boundary_version', version.id, version.toJson());
    });
    return version;
  }

  Future<void> confirmBoundary(FieldBoundaryVersion draft) async {
    await db.transaction(() async {
      final t = now();
      final previous =
          await (db.select(db.fieldBoundaryVersions)..where(
                (b) =>
                    b.fieldId.equals(draft.fieldId) &
                    b.status.equals('confirmed'),
              ))
              .get();
      for (final old in previous) {
        final superseded = old.copyWith(
          status: 'superseded',
          version: old.version + 1,
          updatedAt: t,
          updatedBy: _me,
        );
        await db.update(db.fieldBoundaryVersions).replace(superseded);
        await _log('field_boundary_version', old.id, superseded.toJson());
      }
      final confirmed = draft.copyWith(
        status: 'confirmed',
        version: draft.version + 1,
        updatedAt: t,
        updatedBy: _me,
      );
      await db.update(db.fieldBoundaryVersions).replace(confirmed);
      await _log('field_boundary_version', draft.id, confirmed.toJson());
      final field = await (db.select(
        db.fields,
      )..where((f) => f.id.equals(draft.fieldId))).getSingle();
      final updated = field.copyWith(
        areaM2: Value(draft.areaM2),
        areaMethod: const Value('phone_spherical'),
        version: field.version + 1,
        updatedAt: t,
        updatedBy: _me,
      );
      await db.update(db.fields).replace(updated);
      await _log('field', field.id, updated.toJson());
    });
  }

  Future<void> discardBoundaryDraft(FieldBoundaryVersion draft) async {
    if (draft.status != 'draft') throw StateError('只能捨棄草稿');
    await db.transaction(() async {
      await (db.delete(
        db.fieldBoundaryVersions,
      )..where((b) => b.id.equals(draft.id))).go();
      await _log('field_boundary_version', draft.id, {
        'id': draft.id,
      }, op: 'delete_draft');
    });
  }

  // ─────────────── 記錄田界的軌跡（寫入資料庫，避免背景時遺失） ───────────────

  Future<void> addTrackPoint(String trackId, GeoPoint point) => db
      .into(db.trackPoints)
      .insert(
        TrackPointsCompanion.insert(
          trackId: trackId,
          lat: point.lat,
          lng: point.lng,
          accuracyM: Value(point.accuracyMeters),
          at: now(),
        ),
      );

  Stream<List<GeoPoint>> watchTrack(String trackId) =>
      (db.select(db.trackPoints)
            ..where((t) => t.trackId.equals(trackId))
            ..orderBy([(t) => OrderingTerm.asc(t.seq)]))
          .watch()
          .map(
            (rows) => rows
                .map((r) => GeoPoint(r.lat, r.lng, accuracyMeters: r.accuracyM))
                .toList(),
          );

  Future<void> clearTrack(String trackId) =>
      (db.delete(db.trackPoints)..where((t) => t.trackId.equals(trackId))).go();

  // ───────────────────────── 地號與土地關係 ─────────────────────────

  Stream<List<ParcelWithRelations>> watchParcelsForField(String fieldId) {
    final query =
        db.select(db.landParcels).join([
            innerJoin(
              db.fieldParcels,
              db.fieldParcels.parcelId.equalsExp(db.landParcels.id),
            ),
          ])
          ..where(
            db.fieldParcels.fieldId.equals(fieldId) &
                db.landParcels.archivedAt.isNull(),
          )
          ..orderBy([OrderingTerm.asc(db.landParcels.parcelCode)]);
    return query.watch().asyncMap((rows) async {
      final parcels = rows.map((r) => r.readTable(db.landParcels)).toList();
      final relations = parcels.isEmpty
          ? <LandRelation>[]
          : await (db.select(db.landRelations)..where(
                  (r) =>
                      r.parcelId.isIn(parcels.map((p) => p.id)) &
                      r.archivedAt.isNull(),
                ))
                .get();
      return [
        for (final parcel in parcels)
          ParcelWithRelations(
            parcel,
            relations.where((r) => r.parcelId == parcel.id).toList(),
          ),
      ];
    });
  }

  /// 連結地號到田區；同一個地號（同工作空間）只建一筆，可對應多塊田。
  Future<LandParcel> linkParcel(
    String fieldId,
    String parcelCode, {
    String notes = '',
  }) async {
    final code = parcelCode.trim();
    return db.transaction(() async {
      var parcel =
          await (db.select(db.landParcels)..where(
                (p) =>
                    p.workspaceId.equals(_ws) &
                    p.parcelCode.equals(code) &
                    p.archivedAt.isNull(),
              ))
              .getSingleOrNull();
      if (parcel == null) {
        final t = now();
        parcel = LandParcel(
          id: newId(),
          workspaceId: _ws,
          version: 1,
          createdAt: t,
          createdBy: _me,
          updatedAt: t,
          updatedBy: _me,
          parcelCode: code,
          notes: notes.trim(),
        );
        await db.into(db.landParcels).insert(parcel);
        await _log('land_parcel', parcel.id, parcel.toJson());
      }
      final link = FieldParcel(
        workspaceId: _ws,
        fieldId: fieldId,
        parcelId: parcel.id,
      );
      await db
          .into(db.fieldParcels)
          .insert(link, mode: InsertMode.insertOrIgnore);
      await _log('field_parcel', '$fieldId:${parcel.id}', link.toJson());
      return parcel;
    });
  }

  Future<void> unlinkParcel(String fieldId, String parcelId) async {
    await db.transaction(() async {
      await (db.delete(db.fieldParcels)..where(
            (l) => l.fieldId.equals(fieldId) & l.parcelId.equals(parcelId),
          ))
          .go();
      await _log('field_parcel', '$fieldId:$parcelId', {
        'fieldId': fieldId,
        'parcelId': parcelId,
      }, op: 'delete');
    });
  }

  Future<LandRelation> addLandRelation({
    required String parcelId,
    required String partyName,
    required String kind,
    String share = '',
    DateTime? periodStart,
    DateTime? periodEnd,
    String? rentAmount,
  }) async {
    final t = now();
    final relation = LandRelation(
      id: newId(),
      workspaceId: _ws,
      version: 1,
      createdAt: t,
      createdBy: _me,
      updatedAt: t,
      updatedBy: _me,
      parcelId: parcelId,
      partyName: partyName.trim(),
      kind: kind,
      share: share.trim(),
      periodStart: periodStart,
      periodEnd: periodEnd,
      rentAmount: (rentAmount == null || rentAmount.trim().isEmpty)
          ? null
          : rentAmount.trim(),
      verification: 'self_reported',
    );
    await db.transaction(() async {
      await db.into(db.landRelations).insert(relation);
      await _log('land_relation', relation.id, relation.toJson());
    });
    return relation;
  }

  Future<void> archiveLandRelation(LandRelation relation) async {
    await db.transaction(() async {
      final archived = relation.copyWith(
        archivedAt: Value(now()),
        version: relation.version + 1,
        updatedAt: now(),
      );
      await db.update(db.landRelations).replace(archived);
      await _log(
        'land_relation',
        relation.id,
        archived.toJson(),
        op: 'archive',
      );
    });
  }

  // ───────────────────────── 期作 ─────────────────────────

  Stream<List<CropSeason>> watchSeasons({String? fieldId}) =>
      (db.select(db.cropSeasons)
            ..where(
              (s) =>
                  s.workspaceId.equals(_ws) &
                  s.archivedAt.isNull() &
                  (fieldId == null
                      ? const Constant(true)
                      : s.fieldId.equals(fieldId)),
            )
            ..orderBy([(s) => OrderingTerm.desc(s.createdAt)]))
          .watch();

  Future<CropSeason> createSeason({
    required String fieldId,
    required String name,
    required String cropName,
    String variety = '',
    DateTime? plannedStart,
    DateTime? plannedEnd,
  }) async {
    final t = now();
    final season = CropSeason(
      id: newId(),
      workspaceId: _ws,
      version: 1,
      createdAt: t,
      createdBy: _me,
      updatedAt: t,
      updatedBy: _me,
      fieldId: fieldId,
      name: name.trim(),
      cropName: cropName.trim(),
      variety: variety.trim(),
      status: 'planned',
      plannedStart: plannedStart,
      plannedEnd: plannedEnd,
    );
    await db.transaction(() async {
      await db.into(db.cropSeasons).insert(season);
      await _log('crop_season', season.id, season.toJson());
    });
    return season;
  }

  static const seasonTransitions = {
    'planned': ['active', 'fallow'],
    'active': ['fallow', 'closed'],
    'fallow': ['active', 'closed'],
    'closed': <String>[],
  };

  Future<void> setSeasonStatus(CropSeason season, String status) async {
    if (!(seasonTransitions[season.status] ?? const []).contains(status)) {
      throw IllegalTransition('crop_season', season.status, status);
    }
    await db.transaction(() async {
      final t = now();
      final updated = season.copyWith(
        status: status,
        actualStart: status == 'active' && season.actualStart == null
            ? Value(t)
            : Value(season.actualStart),
        actualEnd: status == 'closed' ? Value(t) : Value(season.actualEnd),
        version: season.version + 1,
        updatedAt: t,
        updatedBy: _me,
      );
      await db.update(db.cropSeasons).replace(updated);
      await _log('crop_season', season.id, updated.toJson());
    });
  }

  // ───────────────────────── 聯絡人 ─────────────────────────

  Stream<List<Contact>> watchContacts() =>
      (db.select(db.contacts)
            ..where((c) => c.workspaceId.equals(_ws) & c.archivedAt.isNull())
            ..orderBy([(c) => OrderingTerm.asc(c.name)]))
          .watch();

  Future<Contact> saveContact({
    Contact? existing,
    required String name,
    String nickname = '',
    String phone = '',
    String preferredChannel = 'phone',
    String workConstraints = '',
    String notes = '',
  }) async {
    final t = now();
    final contact = existing == null
        ? Contact(
            id: newId(),
            workspaceId: _ws,
            version: 1,
            createdAt: t,
            createdBy: _me,
            updatedAt: t,
            updatedBy: _me,
            name: name.trim(),
            nickname: nickname.trim(),
            phone: phone.trim(),
            preferredChannel: preferredChannel,
            workConstraints: workConstraints.trim(),
            notes: notes.trim(),
          )
        : existing.copyWith(
            name: name.trim(),
            nickname: nickname.trim(),
            phone: phone.trim(),
            preferredChannel: preferredChannel,
            workConstraints: workConstraints.trim(),
            notes: notes.trim(),
            version: existing.version + 1,
            updatedAt: t,
            updatedBy: _me,
          );
    await db.transaction(() async {
      await db.into(db.contacts).insertOnConflictUpdate(contact);
      await _log('contact', contact.id, contact.toJson());
    });
    return contact;
  }

  Future<void> archiveContact(Contact contact) async {
    await db.transaction(() async {
      final archived = contact.copyWith(
        archivedAt: Value(now()),
        version: contact.version + 1,
        updatedAt: now(),
      );
      await db.update(db.contacts).replace(archived);
      await _log('contact', contact.id, archived.toJson(), op: 'archive');
    });
  }

  // ───────────────────────── 工作 ─────────────────────────

  Stream<List<TaskWithField>> watchTasks({
    bool openOnly = true,
    String? fieldId,
  }) {
    final query = db.select(db.tasks).join([
      innerJoin(db.fields, db.fields.id.equalsExp(db.tasks.fieldId)),
    ]);
    var where = db.tasks.workspaceId.equals(_ws) & db.tasks.archivedAt.isNull();
    if (openOnly) {
      where =
          where &
          db.tasks.status.isNotIn([
            TaskStatus.completed.name,
            TaskStatus.cancelled.name,
          ]);
    }
    if (fieldId != null) where = where & db.tasks.fieldId.equals(fieldId);
    query
      ..where(where)
      ..orderBy([
        OrderingTerm(expression: db.tasks.plannedStart, nulls: NullsOrder.last),
        OrderingTerm.asc(db.tasks.createdAt),
      ]);
    // 指派變動也要重新計算人數，所以同時監看 assignments
    return query.watch().asyncMap((rows) async {
      final tasks = rows
          .map((r) => (r.readTable(db.tasks), r.readTable(db.fields)))
          .toList();
      final assignments = tasks.isEmpty
          ? <Assignment>[]
          : await (db.select(
              db.assignments,
            )..where((a) => a.taskId.isIn(tasks.map((t) => t.$1.id)))).get();
      return [
        for (final (task, field) in tasks)
          TaskWithField(
            task,
            field,
            assignments
                .where(
                  (a) =>
                      a.taskId == task.id &&
                      AssignmentStatus.parse(a.status).countsAsAccepted,
                )
                .length,
            assignments
                .where(
                  (a) =>
                      a.taskId == task.id &&
                      AssignmentStatus.parse(a.status) ==
                          AssignmentStatus.awaitingReply,
                )
                .length,
          ),
      ];
    });
  }

  Stream<TaskWithField?> watchTask(String id) =>
      watchTasks(openOnly: false)
          .map((list) => list.where((t) => t.task.id == id).firstOrNull);

  Future<Task> createTask({
    required String fieldId,
    String? seasonId,
    required String title,
    required String workType,
    DateTime? plannedStart,
    DateTime? meetAt,
    String meetPlace = '',
    int headcountNeeded = 0,
    String notes = '',
  }) async {
    final t = now();
    final status = plannedStart == null
        ? TaskStatus.draft
        : TaskStatus.draft.apply(TaskAction.schedule);
    final task = Task(
      id: newId(),
      workspaceId: _ws,
      version: 1,
      createdAt: t,
      createdBy: _me,
      updatedAt: t,
      updatedBy: _me,
      fieldId: fieldId,
      seasonId: seasonId,
      title: title.trim(),
      workType: workType,
      status: status.name,
      plannedStart: plannedStart,
      meetAt: meetAt,
      meetPlace: meetPlace.trim(),
      headcountNeeded: headcountNeeded,
      notes: notes.trim(),
    );
    await db.transaction(() async {
      await db.into(db.tasks).insert(task);
      await _log('task', task.id, task.toJson());
    });
    return task;
  }

  /// 修改工作內容。時間要用「改期」（會通知受影響的人重新確認），這裡不改時間。
  /// 需要人數變動時，依已答應人數重新判斷「找人中／人手已齊」。
  Future<void> updateTask(
    String taskId, {
    required String title,
    required String workType,
    String? seasonId,
    DateTime? meetAt,
    String meetPlace = '',
    required int headcountNeeded,
    String notes = '',
  }) async {
    await db.transaction(() async {
      final task = await _getTask(taskId);
      final updated = task.copyWith(
        title: title.trim(),
        workType: workType,
        seasonId: Value(seasonId),
        meetAt: Value(meetAt),
        meetPlace: meetPlace.trim(),
        headcountNeeded: headcountNeeded,
        notes: notes.trim(),
        version: task.version + 1,
        updatedAt: now(),
        updatedBy: _me,
      );
      await db.update(db.tasks).replace(updated);
      await _log('task', task.id, updated.toJson());
      final status = TaskStatus.parse(updated.status);
      final filled = isStaffingFilled(
        acceptedCount: await _acceptedCount(task.id),
        headcountNeeded: headcountNeeded,
      );
      if (status == TaskStatus.staffing && filled) {
        await _writeTask(updated, status.apply(TaskAction.staffingFilled));
      } else if (status == TaskStatus.ready && !filled && headcountNeeded > 0) {
        await _writeTask(updated, status.apply(TaskAction.someoneCancelled));
      }
    });
  }

  Future<Task> _writeTask(
    Task task,
    TaskStatus status, {
    DateTime? plannedStart,
    bool keepPlannedStart = true,
  }) async {
    final updated = task.copyWith(
      status: status.name,
      plannedStart: keepPlannedStart
          ? Value(task.plannedStart)
          : Value(plannedStart),
      version: task.version + 1,
      updatedAt: now(),
      updatedBy: _me,
    );
    await db.update(db.tasks).replace(updated);
    await _log('task', task.id, updated.toJson());
    return updated;
  }

  Future<Task> _getTask(String id) => (db.select(
    db.tasks,
  )..where((t) => t.id.equals(id) & t.workspaceId.equals(_ws))).getSingle();

  /// 套用工作狀態轉移；改期時把已答應的人改為「需再確認」（不自動通知，由管理者決定）。
  Future<void> applyTaskAction(
    String taskId,
    TaskAction action, {
    DateTime? newPlannedStart,
  }) async {
    await db.transaction(() async {
      final task = await _getTask(taskId);
      final current = TaskStatus.parse(task.status);
      var next = current.apply(action);
      if (action == TaskAction.rescheduleConfirmed) {
        if (newPlannedStart == null) throw ArgumentError('改期需要新的時間');
        await _writeTask(
          task,
          next,
          plannedStart: newPlannedStart,
          keepPlannedStart: false,
        );
        return;
      }
      if (action == TaskAction.schedule &&
          task.plannedStart == null &&
          newPlannedStart == null) {
        throw ArgumentError('排定工作需要時間');
      }
      if (action == TaskAction.startStaffing) {
        // 若已答應人數已足夠，直接進入人手已齊
        final accepted = await _acceptedCount(taskId);
        if (isStaffingFilled(
          acceptedCount: accepted,
          headcountNeeded: task.headcountNeeded,
        )) {
          next = next.apply(TaskAction.staffingFilled);
        }
      }
      await _writeTask(
        task,
        next,
        plannedStart: newPlannedStart ?? task.plannedStart,
        keepPlannedStart: newPlannedStart == null,
      );
      if (action == TaskAction.reschedule) {
        final assignments = await (db.select(
          db.assignments,
        )..where((a) => a.taskId.equals(taskId))).get();
        for (final a in assignments) {
          final status = AssignmentStatus.parse(a.status);
          if (status.can(AssignmentAction.taskRescheduled)) {
            await _writeAssignment(
              a,
              AssignmentAction.taskRescheduled,
              note: '工作改期',
            );
          }
        }
      }
    });
  }

  Future<int> _acceptedCount(String taskId) async {
    final assignments = await (db.select(
      db.assignments,
    )..where((a) => a.taskId.equals(taskId))).get();
    return assignments
        .where((a) => AssignmentStatus.parse(a.status).countsAsAccepted)
        .length;
  }

  // ───────────────────────── 人員安排 ─────────────────────────

  Stream<List<AssignmentWithContact>> watchAssignments(String taskId) {
    final query =
        db.select(db.assignments).join([
            innerJoin(
              db.contacts,
              db.contacts.id.equalsExp(db.assignments.contactId),
            ),
          ])
          ..where(
            db.assignments.taskId.equals(taskId) &
                db.assignments.archivedAt.isNull(),
          )
          ..orderBy([OrderingTerm.asc(db.contacts.name)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (r) => AssignmentWithContact(
              r.readTable(db.assignments),
              r.readTable(db.contacts),
            ),
          )
          .toList(),
    );
  }

  Stream<List<AssignmentEvent>> watchAssignmentEvents(String assignmentId) =>
      (db.select(db.assignmentEvents)
            ..where((e) => e.assignmentId.equals(assignmentId))
            ..orderBy([(e) => OrderingTerm.desc(e.at)]))
          .watch();

  Future<void> addAssignment(String taskId, String contactId) async {
    await db.transaction(() async {
      final exists =
          await (db.select(db.assignments)..where(
                (a) =>
                    a.taskId.equals(taskId) &
                    a.contactId.equals(contactId) &
                    a.archivedAt.isNull(),
              ))
              .getSingleOrNull();
      if (exists != null) return;
      final t = now();
      final assignment = Assignment(
        id: newId(),
        workspaceId: _ws,
        version: 1,
        createdAt: t,
        createdBy: _me,
        updatedAt: t,
        updatedBy: _me,
        taskId: taskId,
        contactId: contactId,
        role: 'member',
        status: AssignmentStatus.notContacted.name,
      );
      await db.into(db.assignments).insert(assignment);
      await _log('assignment', assignment.id, assignment.toJson());
    });
  }

  Future<Assignment> _writeAssignment(
    Assignment a,
    AssignmentAction action, {
    String channel = '',
    String note = '',
  }) async {
    final from = AssignmentStatus.parse(a.status);
    final to = from.apply(action);
    final t = now();
    final updated = a.copyWith(
      status: to.name,
      version: a.version + 1,
      updatedAt: t,
      updatedBy: _me,
    );
    await db.update(db.assignments).replace(updated);
    await _log('assignment', a.id, updated.toJson());
    final event = AssignmentEvent(
      id: newId(),
      workspaceId: _ws,
      assignmentId: a.id,
      action: action.name,
      fromStatus: from.name,
      toStatus: to.name,
      channel: channel,
      note: note.trim(),
      at: t,
      by: _me,
    );
    await db.into(db.assignmentEvents).insert(event);
    await _log('assignment_event', event.id, event.toJson());
    return updated;
  }

  /// 記錄聯絡與回覆；同時依「已答應」人數更新工作的找人狀態。
  Future<void> applyAssignmentAction(
    String assignmentId,
    AssignmentAction action, {
    String channel = '',
    String note = '',
  }) async {
    await db.transaction(() async {
      final a =
          await (db.select(db.assignments)..where(
                (x) => x.id.equals(assignmentId) & x.workspaceId.equals(_ws),
              ))
              .getSingle();
      await _writeAssignment(a, action, channel: channel, note: note);
      final task = await _getTask(a.taskId);
      final status = TaskStatus.parse(task.status);
      final filled = isStaffingFilled(
        acceptedCount: await _acceptedCount(task.id),
        headcountNeeded: task.headcountNeeded,
      );
      if (status == TaskStatus.staffing && filled) {
        await _writeTask(task, status.apply(TaskAction.staffingFilled));
      } else if (status == TaskStatus.ready &&
          !filled &&
          task.headcountNeeded > 0) {
        await _writeTask(task, status.apply(TaskAction.someoneCancelled));
      }
    });
  }

  Future<void> removeAssignment(Assignment a) async {
    await db.transaction(() async {
      final archived = a.copyWith(
        archivedAt: Value(now()),
        version: a.version + 1,
        updatedAt: now(),
      );
      await db.update(db.assignments).replace(archived);
      await _log('assignment', a.id, archived.toJson(), op: 'archive');
    });
  }

  // ───────────────────────── 照片 ─────────────────────────

  Future<MediaAsset> addPhoto(
    String ownerKind,
    String ownerId,
    NewPhoto photo,
  ) async {
    final id = newId();
    await mediaDir.create(recursive: true);
    final ext = p.extension(photo.sourcePath).isEmpty
        ? '.jpg'
        : p.extension(photo.sourcePath).toLowerCase();
    final dest = p.join(mediaDir.path, '$id$ext');
    final bytes = await File(photo.sourcePath).readAsBytes();
    await File(dest).writeAsBytes(bytes, flush: true);
    final asset = MediaAsset(
      id: id,
      workspaceId: _ws,
      ownerKind: ownerKind,
      ownerId: ownerId,
      localPath: dest,
      kind: _audioMime.containsKey(ext) ? 'audio' : 'photo',
      mime: _audioMime[ext] ?? _imageMime[ext] ?? 'image/jpeg',
      sizeBytes: bytes.length,
      sha256: sha256.convert(bytes).toString(),
      capturedAt: photo.capturedAt,
      lat: photo.location?.lat,
      lng: photo.location?.lng,
      accuracyM: photo.location?.accuracyMeters,
      headingDeg: photo.headingDeg,
      clientUploadId: id,
      uploadStatus: UploadStatus.localSaved.name,
      createdAt: now(),
    );
    await db.transaction(() async {
      await db.into(db.mediaAssets).insert(asset);
      // 檔案本身由上傳佇列處理；outbox 只記中繼資料
      await _log('media_asset', asset.id, asset.toJson()..remove('localPath'));
    });
    return asset;
  }

  Stream<List<MediaAsset>> watchMedia(String ownerKind, String ownerId) =>
      (db.select(db.mediaAssets)
            ..where(
              (m) => m.ownerKind.equals(ownerKind) & m.ownerId.equals(ownerId),
            )
            ..orderBy([(m) => OrderingTerm.asc(m.capturedAt)]))
          .watch();

  // ───────────────────────── 回報與確認 ─────────────────────────

  /// 送出回報（長輩最短路徑）：必要時自動把工作推進到「已回報」。
  Future<WorkReport> submitReport({
    String? taskId,
    required String fieldId,
    String rawText = '',
    String rawQuantityText = '',
    PesticideStatus pesticideClaim = PesticideStatus.unknown,
    DateTime? actualStart,
    DateTime? actualEnd,
    List<NewPhoto> photos = const [],
    String reportedByKind = 'user',
    String? reporterName,
  }) async {
    final t = now();
    final report = WorkReport(
      id: newId(),
      workspaceId: _ws,
      version: 1,
      createdAt: t,
      createdBy: _me,
      updatedAt: t,
      updatedBy: _me,
      taskId: taskId,
      fieldId: fieldId,
      reportedByKind: reportedByKind,
      reporterName: reporterName ?? session.profile.displayName,
      actualStart: actualStart,
      actualEnd: actualEnd ?? t,
      rawText: rawText.trim(),
      rawQuantityText: rawQuantityText.trim(),
      pesticideClaim: pesticideClaim.name,
      status: ReportStatus.draft.apply(ReportAction.submit).name,
      reviewNote: '',
      submittedAt: t,
    );
    await db.transaction(() async {
      await db.into(db.workReports).insert(report);
      await _log('work_report', report.id, report.toJson());
      if (taskId != null) await _advanceTaskToReported(taskId);
    });
    for (final photo in photos) {
      await addPhoto('report', report.id, photo);
    }
    return report;
  }

  Future<void> _advanceTaskToReported(String taskId) async {
    var task = await _getTask(taskId);
    var status = TaskStatus.parse(task.status);
    const path = [
      TaskAction.schedule,
      TaskAction.noExternalStaff,
      TaskAction.startShortHanded,
      TaskAction.start,
      TaskAction.report,
    ];
    for (final action in path) {
      if (status == TaskStatus.reported) break;
      if (action == TaskAction.schedule && task.plannedStart == null) {
        if (status.can(action)) {
          task = await _writeTask(
            task,
            status.apply(action),
            plannedStart: now(),
            keepPlannedStart: false,
          );
          status = TaskStatus.parse(task.status);
        }
        continue;
      }
      if (status.can(action)) {
        task = await _writeTask(task, status.apply(action));
        status = TaskStatus.parse(task.status);
      }
    }
  }

  Stream<List<ReportView>> watchReports({
    List<ReportStatus>? statuses,
    String? fieldId,
  }) {
    final query = db.select(db.workReports).join([
      innerJoin(db.fields, db.fields.id.equalsExp(db.workReports.fieldId)),
      leftOuterJoin(db.tasks, db.tasks.id.equalsExp(db.workReports.taskId)),
    ]);
    var where = db.workReports.workspaceId.equals(_ws);
    if (statuses != null) {
      where = where & db.workReports.status.isIn(statuses.map((s) => s.name));
    }
    if (fieldId != null) where = where & db.workReports.fieldId.equals(fieldId);
    query
      ..where(where)
      ..orderBy([OrderingTerm.desc(db.workReports.createdAt)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (r) => ReportView(
              r.readTable(db.workReports),
              r.readTable(db.fields),
              r.readTableOrNull(db.tasks),
            ),
          )
          .toList(),
    );
  }

  Stream<ReportView?> watchReport(String id) => watchReports().map(
    (list) => list.where((r) => r.report.id == id).firstOrNull,
  );

  Future<WorkReport> _getReport(String id) => (db.select(
    db.workReports,
  )..where((r) => r.id.equals(id) & r.workspaceId.equals(_ws))).getSingle();

  Future<WorkReport> _writeReport(
    WorkReport report,
    ReportAction action, {
    String? reviewNote,
    String? appendText,
  }) async {
    final next = ReportStatus.parse(report.status).apply(action);
    final updated = report.copyWith(
      status: next.name,
      reviewNote: reviewNote ?? report.reviewNote,
      rawText: appendText == null || appendText.trim().isEmpty
          ? report.rawText
          : [
              report.rawText,
              '補充：${appendText.trim()}',
            ].where((s) => s.isNotEmpty).join('\n'),
      submittedAt: action == ReportAction.resubmit
          ? Value(now())
          : Value(report.submittedAt),
      version: report.version + 1,
      updatedAt: now(),
      updatedBy: _me,
    );
    await db.update(db.workReports).replace(updated);
    await _log('work_report', report.id, updated.toJson());
    return updated;
  }

  /// 管理者開啟確認（submitted → under_review）。重複開啟不報錯。
  Future<void> openReview(String reportId) async {
    await db.transaction(() async {
      final report = await _getReport(reportId);
      if (ReportStatus.parse(report.status) == ReportStatus.submitted) {
        await _writeReport(report, ReportAction.openReview);
      }
    });
  }

  Future<void> requestInfo(String reportId, String note) async {
    await db.transaction(() async {
      await _writeReport(
        await _getReport(reportId),
        ReportAction.requestInfo,
        reviewNote: note.trim(),
      );
    });
  }

  Future<void> resubmit(
    String reportId,
    String extraText, {
    List<NewPhoto> photos = const [],
  }) async {
    await db.transaction(() async {
      await _writeReport(
        await _getReport(reportId),
        ReportAction.resubmit,
        appendText: extraText,
      );
    });
    for (final photo in photos) {
      await addPhoto('report', reportId, photo);
    }
  }

  Future<void> rejectReport(String reportId, String reason) async {
    await db.transaction(() async {
      final report = await _writeReport(
        await _getReport(reportId),
        ReportAction.reject,
        reviewNote: reason.trim(),
      );
      if (report.taskId != null) {
        final task = await _getTask(report.taskId!);
        if (TaskStatus.parse(task.status).can(TaskAction.sendBack)) {
          await _writeTask(
            task,
            TaskStatus.parse(task.status).apply(TaskAction.sendBack),
          );
        }
      }
    });
  }

  /// 確認回報 → 建立正式農務紀錄。資材原話先存為「待補規格」，不自動換算。
  Future<WorkRecord> confirmReport(
    String reportId, {
    required String summary,
    required PesticideStatus pesticideStatus,
    String? seasonId,
    String? workType,
  }) async {
    return db.transaction(() async {
      var report = await _getReport(reportId);
      if (ReportStatus.parse(report.status) == ReportStatus.submitted) {
        report = await _writeReport(report, ReportAction.openReview);
      }
      report = await _writeReport(report, ReportAction.confirm);
      final task = report.taskId == null
          ? null
          : await _getTask(report.taskId!);
      final t = now();
      final record = WorkRecord(
        id: newId(),
        workspaceId: _ws,
        version: 1,
        createdAt: t,
        createdBy: _me,
        updatedAt: t,
        updatedBy: _me,
        reportId: report.id,
        fieldId: report.fieldId,
        seasonId: seasonId ?? task?.seasonId,
        workType: workType ?? task?.workType ?? 'other',
        performedOn: report.actualEnd ?? report.createdAt,
        summary: summary.trim(),
        pesticideStatus: pesticideStatus.name,
        status: 'confirmed',
        confirmedBy: _me,
        confirmedAt: t,
      );
      await db.into(db.workRecords).insert(record);
      await _log('work_record', record.id, record.toJson());
      if (report.rawQuantityText.isNotEmpty) {
        final input = WorkRecordInput(
          id: newId(),
          workspaceId: _ws,
          version: 1,
          createdAt: t,
          createdBy: _me,
          updatedAt: t,
          updatedBy: _me,
          recordId: record.id,
          productName: '',
          rawQuantityText: report.rawQuantityText,
          conversionBasis: '',
          status: 'pending_spec',
        );
        await db.into(db.workRecordInputs).insert(input);
        await _log('work_record_input', input.id, input.toJson());
      }
      if (task != null &&
          TaskStatus.parse(task.status).can(TaskAction.confirm)) {
        await _writeTask(
          task,
          TaskStatus.parse(task.status).apply(TaskAction.confirm),
        );
      }
      return record;
    });
  }

  Stream<List<RecordView>> watchRecords({
    String? fieldId,
    bool includeVoided = false,
  }) {
    final query = db.select(db.workRecords).join([
      innerJoin(db.fields, db.fields.id.equalsExp(db.workRecords.fieldId)),
    ]);
    var where = db.workRecords.workspaceId.equals(_ws);
    if (fieldId != null) where = where & db.workRecords.fieldId.equals(fieldId);
    if (!includeVoided) {
      where = where & db.workRecords.status.equals('voided').not();
    }
    query
      ..where(where)
      ..orderBy([OrderingTerm.desc(db.workRecords.performedOn)]);
    return query.watch().asyncMap((rows) async {
      final ids = rows.map((r) => r.readTable(db.workRecords).id).toList();
      final inputs = ids.isEmpty
          ? <WorkRecordInput>[]
          : await (db.select(db.workRecordInputs)
                  ..where((i) => i.recordId.isIn(ids) & i.archivedAt.isNull()))
                .get();
      return [
        for (final r in rows)
          RecordView(
            r.readTable(db.workRecords),
            r.readTable(db.fields),
            inputs
                .where((i) => i.recordId == r.readTable(db.workRecords).id)
                .toList(),
          ),
      ];
    });
  }

  /// 修正正式紀錄：寫入修改歷程，不覆蓋歷史。
  Future<void> amendRecord(
    WorkRecord record, {
    required String reason,
    String? summary,
    PesticideStatus? pesticideStatus,
  }) async {
    await db.transaction(() async {
      final report = await _getReport(record.reportId);
      final amending = await _writeReport(report, ReportAction.amend);
      final updated = record.copyWith(
        summary: summary?.trim() ?? record.summary,
        pesticideStatus: pesticideStatus?.name ?? record.pesticideStatus,
        version: record.version + 1,
        updatedAt: now(),
        updatedBy: _me,
      );
      await _writeRevision(record, updated, reason);
      await db.update(db.workRecords).replace(updated);
      await _log('work_record', record.id, updated.toJson());
      await _writeReport(amending, ReportAction.confirmAmendment);
    });
  }

  Future<void> voidRecord(WorkRecord record, String reason) async {
    await db.transaction(() async {
      final updated = record.copyWith(
        status: 'voided',
        version: record.version + 1,
        updatedAt: now(),
        updatedBy: _me,
      );
      await _writeRevision(record, updated, reason);
      await db.update(db.workRecords).replace(updated);
      await _log('work_record', record.id, updated.toJson());
      await _writeReport(
        await _getReport(record.reportId),
        ReportAction.voidRecord,
        reviewNote: reason.trim(),
      );
    });
  }

  Future<void> _writeRevision(
    WorkRecord before,
    WorkRecord after,
    String reason,
  ) async {
    final revision = RecordRevision(
      id: newId(),
      workspaceId: _ws,
      recordId: before.id,
      beforeJson: jsonEncode(before.toJson()),
      afterJson: jsonEncode(after.toJson()),
      reason: reason.trim(),
      by: _me,
      at: now(),
    );
    await db.into(db.recordRevisions).insert(revision);
    await _log('record_revision', revision.id, revision.toJson());
  }

  Stream<List<RecordRevision>> watchRevisions(String recordId) =>
      (db.select(db.recordRevisions)
            ..where((r) => r.recordId.equals(recordId))
            ..orderBy([(r) => OrderingTerm.desc(r.at)]))
          .watch();

  Future<void> specifyInput(
    WorkRecordInput input, {
    required String productName,
    required String quantity,
    required String unitCode,
    required String basis,
  }) async {
    await db.transaction(() async {
      final updated = input.copyWith(
        productName: productName.trim(),
        quantity: Value(quantity.trim()),
        unitCode: Value(unitCode.trim()),
        conversionBasis: basis.trim(),
        status: 'confirmed',
        version: input.version + 1,
        updatedAt: now(),
        updatedBy: _me,
      );
      await db.update(db.workRecordInputs).replace(updated);
      await _log('work_record_input', input.id, updated.toJson());
    });
  }

  /// 田區（可限定期作）施藥狀態彙總。沒有紀錄 → 尚未確認。
  Stream<PesticideStatus> watchPesticideStatus(
    String fieldId, {
    String? seasonId,
  }) {
    final query = db.select(db.workRecords)
      ..where(
        (r) =>
            r.fieldId.equals(fieldId) &
            r.status.equals('voided').not() &
            (seasonId == null
                ? const Constant(true)
                : r.seasonId.equals(seasonId)),
      );
    return query.watch().map(
      (rows) => aggregatePesticideStatus(
        rows.map((r) => PesticideStatus.parse(r.pesticideStatus)),
      ),
    );
  }

  // ───────────────────────── 巡田 ─────────────────────────

  Future<InspectionSession> startInspection(String fieldId) async {
    final t = now();
    final s = InspectionSession(
      id: newId(),
      workspaceId: _ws,
      version: 1,
      createdAt: t,
      createdBy: _me,
      updatedAt: t,
      updatedBy: _me,
      fieldId: fieldId,
      startedAt: t,
      status: 'capturing',
      keptFrames: 0,
      skippedFrames: 0,
    );
    await db.transaction(() async {
      await db.into(db.inspectionSessions).insert(s);
      await _log('inspection_session', s.id, s.toJson());
    });
    return s;
  }

  /// 記錄一次取樣：清晰的保存照片，不清晰的只記中繼資料（供離場前判斷補拍）。
  Future<InspectionFrame> addInspectionFrame(
    String sessionId, {
    required FrameQuality quality,
    required double blurScore,
    String? photoPath,
    GeoPoint? location,
    double? headingDeg,
    String? reshootTaskId,
  }) async {
    final t = now();
    MediaAsset? media;
    if (photoPath != null) {
      media = await addPhoto(
        'inspection',
        sessionId,
        NewPhoto(photoPath, t, location: location, headingDeg: headingDeg),
      );
    }
    final frame = InspectionFrame(
      id: newId(),
      workspaceId: _ws,
      sessionId: sessionId,
      mediaId: media?.id,
      capturedAt: t,
      lat: location?.lat,
      lng: location?.lng,
      accuracyM: location?.accuracyMeters,
      headingDeg: headingDeg,
      blurScore: blurScore,
      quality: quality.name,
      reshootTaskId: reshootTaskId,
    );
    await db.transaction(() async {
      await db.into(db.inspectionFrames).insert(frame);
      final s = await (db.select(
        db.inspectionSessions,
      )..where((x) => x.id.equals(sessionId))).getSingle();
      await db
          .update(db.inspectionSessions)
          .replace(
            s.copyWith(
              keptFrames: s.keptFrames + (media == null ? 0 : 1),
              skippedFrames: s.skippedFrames + (media == null ? 1 : 0),
              updatedAt: t,
            ),
          );
      if (reshootTaskId != null && media != null) {
        final task = await (db.select(
          db.reshootTasks,
        )..where((r) => r.id.equals(reshootTaskId))).getSingle();
        await db
            .update(db.reshootTasks)
            .replace(task.copyWith(status: 'resolved'));
        await _log(
          'reshoot_task',
          task.id,
          task.copyWith(status: 'resolved').toJson(),
        );
      }
    });
    return frame;
  }

  /// 結束巡田：在手機上彙整一次補拍清單（離場前一次查核，不中途要求折返）。
  Future<List<ReshootTask>> endInspection(String sessionId) async {
    return db.transaction(() async {
      final frames = await (db.select(
        db.inspectionFrames,
      )..where((f) => f.sessionId.equals(sessionId))).get();
      final existing = await (db.select(
        db.reshootTasks,
      )..where((r) => r.sessionId.equals(sessionId))).get();
      final created = <ReshootTask>[];
      for (final gap in findReshootGaps(frames)) {
        final alreadyHas = existing.any(
          (r) =>
              r.status == 'pending' &&
              turnDelta(r.headingDeg, gap.headingDeg).abs() < 22.5,
        );
        if (alreadyHas) continue;
        final task = ReshootTask(
          id: newId(),
          workspaceId: _ws,
          sessionId: sessionId,
          reason: 'excessive_blur',
          description: '朝${headingToDirection(gap.headingDeg)}方向的照片都不清楚',
          headingDeg: gap.headingDeg,
          lat: gap.location?.lat,
          lng: gap.location?.lng,
          status: 'pending',
          createdAt: now(),
        );
        await db.into(db.reshootTasks).insert(task);
        await _log('reshoot_task', task.id, task.toJson());
        created.add(task);
      }
      final pending = [
        ...existing.where((r) => r.status == 'pending'),
        ...created,
      ];
      final s = await (db.select(
        db.inspectionSessions,
      )..where((x) => x.id.equals(sessionId))).getSingle();
      final updated = s.copyWith(
        status: pending.isEmpty ? 'local_saved' : 'reshoot_required',
        endedAt: Value(now()),
        version: s.version + 1,
        updatedAt: now(),
      );
      await db.update(db.inspectionSessions).replace(updated);
      await _log('inspection_session', s.id, updated.toJson());
      return pending;
    });
  }

  Future<void> dismissReshoot(ReshootTask task) async {
    await db.transaction(() async {
      final updated = task.copyWith(status: 'dismissed');
      await db.update(db.reshootTasks).replace(updated);
      await _log('reshoot_task', task.id, updated.toJson());
    });
  }

  Stream<List<ReshootTask>> watchReshootTasks(String sessionId) =>
      (db.select(db.reshootTasks)
            ..where((r) => r.sessionId.equals(sessionId))
            ..orderBy([(r) => OrderingTerm.asc(r.createdAt)]))
          .watch();

  Stream<List<InspectionSession>> watchInspections(String fieldId) =>
      (db.select(db.inspectionSessions)
            ..where(
              (s) => s.fieldId.equals(fieldId) & s.workspaceId.equals(_ws),
            )
            ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
          .watch();

  // ───────────────────────── 同步與匯出 ─────────────────────────

  Stream<int> watchPendingOutbox() {
    final count = db.outbox.seq.count();
    final query = db.selectOnly(db.outbox)
      ..addColumns([count])
      ..where(
        db.outbox.workspaceId.equals(_ws) & db.outbox.status.equals('pending'),
      );
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  /// outbox 各狀態筆數（pending／sent／conflict／rejected／failed），所有工作空間合計。
  Stream<Map<String, int>> watchOutboxCounts() {
    final count = db.outbox.seq.count();
    final query = db.selectOnly(db.outbox)
      ..addColumns([db.outbox.status, count])
      ..groupBy([db.outbox.status]);
    return query.watch().map(
      (rows) => {
        for (final r in rows) r.read(db.outbox.status)!: r.read(count) ?? 0,
      },
    );
  }

  Stream<int> watchPendingUploads() {
    final count = db.mediaAssets.id.count();
    final query = db.selectOnly(db.mediaAssets)
      ..addColumns([count])
      ..where(
        db.mediaAssets.workspaceId.equals(_ws) &
            db.mediaAssets.uploadStatus.equals(UploadStatus.localSaved.name),
      );
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  /// 匯出這個工作空間的全部資料（JSON），讓使用者自行備份；照片另以原檔分享。
  Future<Map<String, dynamic>> exportWorkspace() async {
    Future<List<Map<String, dynamic>>> dump<T extends Table, R>(
      TableInfo<T, R> table,
      Expression<bool> Function(T) where,
    ) async {
      final rows = await (db.select(table)..where(where)).get();
      return rows
          .map((r) => (r as dynamic).toJson() as Map<String, dynamic>)
          .toList();
    }

    return {
      'format': 'farming-diary-export',
      'formatVersion': 1,
      'exportedAt': now().toUtc().toIso8601String(),
      'workspace': session.workspace.toJson(),
      'fields': await dump(db.fields, (t) => t.workspaceId.equals(_ws)),
      'fieldBoundaryVersions': await dump(
        db.fieldBoundaryVersions,
        (t) => t.workspaceId.equals(_ws),
      ),
      'landParcels': await dump(
        db.landParcels,
        (t) => t.workspaceId.equals(_ws),
      ),
      'fieldParcels': await dump(
        db.fieldParcels,
        (t) => t.workspaceId.equals(_ws),
      ),
      'landRelations': await dump(
        db.landRelations,
        (t) => t.workspaceId.equals(_ws),
      ),
      'cropSeasons': await dump(
        db.cropSeasons,
        (t) => t.workspaceId.equals(_ws),
      ),
      'contacts': await dump(db.contacts, (t) => t.workspaceId.equals(_ws)),
      'tasks': await dump(db.tasks, (t) => t.workspaceId.equals(_ws)),
      'assignments': await dump(
        db.assignments,
        (t) => t.workspaceId.equals(_ws),
      ),
      'assignmentEvents': await dump(
        db.assignmentEvents,
        (t) => t.workspaceId.equals(_ws),
      ),
      'workReports': await dump(
        db.workReports,
        (t) => t.workspaceId.equals(_ws),
      ),
      'workRecords': await dump(
        db.workRecords,
        (t) => t.workspaceId.equals(_ws),
      ),
      'workRecordInputs': await dump(
        db.workRecordInputs,
        (t) => t.workspaceId.equals(_ws),
      ),
      'recordRevisions': await dump(
        db.recordRevisions,
        (t) => t.workspaceId.equals(_ws),
      ),
      'mediaAssets': await dump(
        db.mediaAssets,
        (t) => t.workspaceId.equals(_ws),
      ),
      'inspectionSessions': await dump(
        db.inspectionSessions,
        (t) => t.workspaceId.equals(_ws),
      ),
      'inspectionFrames': await dump(
        db.inspectionFrames,
        (t) => t.workspaceId.equals(_ws),
      ),
      'reshootTasks': await dump(
        db.reshootTasks,
        (t) => t.workspaceId.equals(_ws),
      ),
    };
  }
}

class ReshootGap {
  final double headingDeg;
  final GeoPoint? location;

  const ReshootGap(this.headingDeg, this.location);
}

/// 依朝向分成 8 個扇區；某扇區有取樣但沒有任何清晰照片 → 需要補拍。
List<ReshootGap> findReshootGaps(List<InspectionFrame> frames) {
  final sectors = <int, List<InspectionFrame>>{};
  for (final f in frames) {
    final h = f.headingDeg;
    if (h == null) continue;
    sectors
        .putIfAbsent((normalizeHeading(h) / 45).round() % 8, () => [])
        .add(f);
  }
  final gaps = <ReshootGap>[];
  for (final entry
      in sectors.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    final list = entry.value;
    // 只轉過去一下（少於 2 次取樣）不算缺漏
    if (list.length < 2 || list.any((f) => f.mediaId != null)) continue;
    final located = list.where((f) => f.lat != null && f.lng != null).toList();
    final location = located.isEmpty
        ? null
        : GeoPoint(
            located.map((f) => f.lat!).reduce((a, b) => a + b) / located.length,
            located.map((f) => f.lng!).reduce((a, b) => a + b) / located.length,
          );
    gaps.add(ReshootGap(entry.key * 45.0, location));
  }
  return gaps;
}
