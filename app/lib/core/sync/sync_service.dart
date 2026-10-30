/// 同步引擎：推送 outbox → 上傳媒體 → 拉取變更 → 下載缺少的媒體檔。
library;

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../domain/state_machines.dart';
import '../db/database.dart';
import 'api_client.dart';
import 'entities.dart';

class SyncKeys {
  static const baseUrl = 'sync_base_url';
  static const cursor = 'sync_cursor';
  static const lastSyncAt = 'sync_last_at';
  static const lastError = 'sync_last_error';
  static const deviceId = 'device_id';
}

class SyncReport {
  int pushed = 0;
  int duplicates = 0;
  int conflicts = 0;
  int rejected = 0;
  int uploaded = 0;
  int pulled = 0;
  int downloaded = 0;
  final List<String> revokedWorkspaces = [];

  @override
  String toString() =>
      'pushed=$pushed dup=$duplicates conflict=$conflicts rejected=$rejected uploaded=$uploaded pulled=$pulled downloaded=$downloaded';
}

class SyncService {
  static const pushBatch = 200;
  static const maxDownloadsPerRun = 50;

  final AppDatabase db;
  final ApiClient api;
  final Directory mediaDir;
  final DateTime Function() now;

  SyncService(this.db, this.api, this.mediaDir, {DateTime Function()? clock})
    : now = clock ?? DateTime.now;

  Future<String?> _setting(String key) async => (await (db.select(
    db.settings,
  )..where((s) => s.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _setSetting(String key, String? value) async {
    if (value == null) {
      await (db.delete(db.settings)..where((s) => s.key.equals(key))).go();
    } else {
      await db
          .into(db.settings)
          .insertOnConflictUpdate(Setting(key: key, value: value));
    }
  }

  Future<String> deviceId() async {
    final existing = await _setting(SyncKeys.deviceId);
    if (existing != null) return existing;
    final id = const Uuid().v4();
    await _setSetting(SyncKeys.deviceId, id);
    return id;
  }

  /// 跑一輪完整同步。任何一步失敗都會記錄錯誤並丟出；已完成的部分不會重做（冪等）。
  Future<SyncReport> syncOnce() async {
    final report = SyncReport();
    try {
      await _push(report);
      await _uploadMedia(report);
      await _pull(report);
      await _downloadMissingMedia(report);
      await _setSetting(SyncKeys.lastSyncAt, now().toUtc().toIso8601String());
      await _setSetting(SyncKeys.lastError, null);
      return report;
    } catch (e) {
      await _setSetting(SyncKeys.lastError, e.toString());
      rethrow;
    }
  }

  // ───────────────────────── 推送 ─────────────────────────

  Future<void> _push(SyncReport report) async {
    final device = await deviceId();
    while (true) {
      final batch =
          await (db.select(db.outbox)
                ..where((o) => o.status.isIn(['pending', 'failed']))
                ..orderBy([(o) => OrderingTerm.asc(o.seq)])
                ..limit(pushBatch))
              .get();
      if (batch.isEmpty) return;
      final commands = [
        for (final o in batch)
          {
            'command_id': 'outbox-$device-${o.seq}',
            'workspace_id': o.workspaceId,
            'entity': o.entity,
            'entity_id': o.entityId,
            'op': o.op,
            'payload': jsonDecode(o.payloadJson),
          },
      ];
      final List<Map<String, dynamic>> results;
      try {
        results = await api.push(commands);
      } on ApiException catch (e) {
        if (e.isRevoked) rethrow;
        await _markAttempt(batch, e.toString());
        rethrow;
      }
      if (results.length != batch.length) {
        throw const ApiException(500, 'bad_response', '伺服器回應筆數不符');
      }
      await db.transaction(() async {
        for (var i = 0; i < batch.length; i++) {
          final o = batch[i];
          final r = results[i];
          final status = r['status'] as String;
          final newStatus = switch (status) {
            'applied' => 'sent',
            'duplicate' => 'sent',
            'conflict' => 'conflict',
            'rejected' => 'rejected',
            _ => 'failed',
          };
          switch (status) {
            case 'applied':
              report.pushed++;
            case 'duplicate':
              report.duplicates++;
            case 'conflict':
              report.conflicts++;
            case 'rejected':
              report.rejected++;
          }
          await (db.update(db.outbox)..where((x) => x.seq.equals(o.seq))).write(
            OutboxCompanion(
              status: Value(newStatus),
              attempts: Value(o.attempts + 1),
              lastError: Value(
                r['message'] as String? ?? r['error_code'] as String?,
              ),
            ),
          );
          // 衝突時以伺服器內容為準更新本機（使用者可在紀錄的修改歷程看到差異）
          final current = r['current'];
          if (status == 'conflict' && current is Map<String, dynamic>) {
            await entitySpecFor(o.entity)?.applyRemote(db, current);
          }
        }
      });
      // 有一筆失敗就停，避免後面相依的命令先送
      if (results.any(
        (r) =>
            r['status'] != 'applied' &&
            r['status'] != 'duplicate' &&
            r['status'] != 'conflict' &&
            r['status'] != 'rejected',
      )) {
        return;
      }
    }
  }

  Future<void> _markAttempt(List<OutboxData> batch, String error) async {
    await db.transaction(() async {
      for (final o in batch) {
        await (db.update(db.outbox)..where((x) => x.seq.equals(o.seq))).write(
          OutboxCompanion(
            attempts: Value(o.attempts + 1),
            lastError: Value(error),
          ),
        );
      }
    });
  }

  // ───────────────────────── 上傳 ─────────────────────────

  Future<void> _uploadMedia(SyncReport report) async {
    final pending =
        await (db.select(db.mediaAssets)
              ..where(
                (m) => m.uploadStatus.isIn([
                  UploadStatus.localSaved.name,
                  UploadStatus.failed.name,
                  UploadStatus.uploading.name,
                ]),
              )
              ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
            .get();
    for (final m in pending) {
      final file = File(m.localPath);
      if (!file.existsSync()) {
        await _setUpload(m.id, UploadStatus.failed);
        continue;
      }
      await _setUpload(m.id, UploadStatus.uploading);
      try {
        final created = await api.createUpload({
          'client_upload_id': m.clientUploadId,
          'workspace_id': m.workspaceId,
          'media_asset_id': m.id,
          'sha256': m.sha256,
          'size_bytes': m.sizeBytes,
          'mime': m.mime,
        });
        if (created['status'] != UploadStatus.serverReceived.name &&
            created['status'] != 'server_received') {
          final headers = (created['upload_headers'] as Map? ?? const {}).map(
            (k, v) => MapEntry('$k', '$v'),
          );
          await api.putUpload(
            Uri.parse(created['upload_url'] as String),
            headers,
            file,
          );
          await api.completeUpload(created['upload_id'] as String);
        }
        await _setUpload(m.id, UploadStatus.serverReceived);
        report.uploaded++;
      } on ApiException catch (e) {
        await _setUpload(
          m.id,
          e.isRetryable ? UploadStatus.localSaved : UploadStatus.failed,
        );
        if (e.isRetryable || e.isAuth || e.isRevoked) rethrow;
      }
    }
  }

  Future<void> _setUpload(String id, UploadStatus status) =>
      (db.update(db.mediaAssets)..where((m) => m.id.equals(id))).write(
        MediaAssetsCompanion(uploadStatus: Value(status.name)),
      );

  // ───────────────────────── 拉取 ─────────────────────────

  Future<void> _pull(SyncReport report) async {
    var cursor = await _setting(SyncKeys.cursor);
    while (true) {
      final res = await api.changes(cursor: cursor);
      final changes = (res['changes'] as List).cast<Map<String, dynamic>>();
      await db.transaction(() async {
        for (final c in changes) {
          if (await _applyChange(c)) report.pulled++;
        }
        cursor = res['next_cursor'] as String?;
        await _setSetting(SyncKeys.cursor, cursor);
      });
      for (final ws
          in (res['revoked_workspaces'] as List? ?? const []).cast<String>()) {
        report.revokedWorkspaces.add(ws);
        await _revokeWorkspace(ws);
      }
      if (res['has_more'] != true) return;
    }
  }

  Future<bool> _applyChange(Map<String, dynamic> c) async {
    final entity = c['entity'] as String;
    final payload = (c['payload'] as Map).cast<String, dynamic>();
    if (entity == 'workspace') {
      await db
          .into(db.workspaces)
          .insertOnConflictUpdate(Workspace.fromJson(payload));
      return true;
    }
    if (entity == 'media_asset') {
      final existing = await (db.select(
        db.mediaAssets,
      )..where((m) => m.id.equals(payload['id'] as String))).getSingleOrNull();
      if (existing != null) return false; // 媒體只新增；本機已有（多半是自己拍的）
      await db
          .into(db.mediaAssets)
          .insert(
            MediaAsset.fromJson({
              ...payload,
              'localPath': '',
              'uploadStatus': UploadStatus.serverReceived.name,
            }),
          );
      return true;
    }
    final spec = entitySpecFor(entity);
    if (spec == null) return false; // 舊版 App 不認得的實體：略過，不中斷同步
    return spec.applyRemote(db, payload);
  }

  /// 權限被撤銷：移除該工作空間的成員資格（畫面隨即鎖定），本機尚未上傳的資料保留在 outbox 供匯出。
  Future<void> _revokeWorkspace(String workspaceId) async {
    await (db.update(db.memberships)
          ..where((m) => m.workspaceId.equals(workspaceId)))
        .write(const MembershipsCompanion(status: Value('removed')));
  }

  // ───────────────────────── 下載 ─────────────────────────

  Future<void> _downloadMissingMedia(SyncReport report) async {
    final missing =
        await (db.select(db.mediaAssets)
              ..where((m) => m.localPath.equals(''))
              ..limit(maxDownloadsPerRun))
            .get();
    if (missing.isEmpty) return;
    await mediaDir.create(recursive: true);
    for (final m in missing) {
      try {
        final bytes = await api.download(await api.mediaUrl(m.id));
        final ext = switch (m.mime) {
          'audio/mp4' => '.m4a',
          'image/png' => '.png',
          'image/heic' => '.heic',
          _ => '.jpg',
        };
        final path = p.join(mediaDir.path, '${m.id}$ext');
        await File(path).writeAsBytes(bytes, flush: true);
        await (db.update(db.mediaAssets)..where((x) => x.id.equals(m.id)))
            .write(MediaAssetsCompanion(localPath: Value(path)));
        report.downloaded++;
      } on ApiException catch (e) {
        if (e.isAuth || e.isRevoked) rethrow;
        // 個別檔案下載失敗不影響其他資料，下次再試
      }
    }
  }

  // ───────────────────────── 狀態 ─────────────────────────

  Future<String?> baseUrl() => _setting(SyncKeys.baseUrl);
  Future<String?> lastSyncAt() => _setting(SyncKeys.lastSyncAt);
  Future<String?> lastError() => _setting(SyncKeys.lastError);
}
