/// 備份與還原：單一 zip（data.json＋media/ 照片），換手機或重裝後可完整還原。
library;

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import 'db/database.dart';
import 'repository.dart';
import 'sync/entities.dart';

const backupFormat = 'farming-diary-export';

/// 建立備份檔，回傳 zip 檔案。照片以原檔不壓縮存放。
Future<File> createBackup(FarmRepository repo, Directory outDir) async {
  final data = await repo.exportWorkspace();
  final media = (data['mediaAssets'] as List).cast<Map<String, dynamic>>();
  final files = <(File, String)>[];
  for (final m in media) {
    final file = File(m['localPath'] as String);
    final name = 'media/${p.basename(file.path)}';
    m['file'] = name;
    m.remove('localPath');
    if (file.existsSync()) files.add((file, name));
  }
  final stamp = DateTime.now()
      .toIso8601String()
      .substring(0, 19)
      .replaceAll(RegExp(r'[:T]'), '-');
  final zipPath = p.join(
    outDir.path,
    '農田日記備份-${repo.session.workspace.name}-$stamp.zip',
  );
  final encoder = ZipFileEncoder()..create(zipPath);
  encoder.addArchiveFile(
    ArchiveFile.string(
      'data.json',
      const JsonEncoder.withIndent(' ').convert(data),
    ),
  );
  for (final (file, name) in files) {
    await encoder.addFile(file, name, 0);
  }
  await encoder.close();
  return File(zipPath);
}

class RestoreResult {
  final Workspace workspace;
  final int rows;
  final int photos;

  const RestoreResult(this.workspace, this.rows, this.photos);
}

class RestoreException implements Exception {
  final String message;

  const RestoreException(this.message);

  @override
  String toString() => message;
}

/// 從備份還原成這支手機上的一個農場；目前使用者成為擁有者。
/// 同一個農場已存在時拒絕（避免覆蓋現有資料）。
Future<RestoreResult> restoreBackup({
  required AppDatabase db,
  required SessionStore store,
  required String zipPath,
  required Directory mediaDir,
  required Directory workDir,
}) async {
  final extractDir = Directory(
    p.join(workDir.path, 'restore-${DateTime.now().microsecondsSinceEpoch}'),
  );
  try {
    await extractFileToDisk(zipPath, extractDir.path);
    final jsonFile = File(p.join(extractDir.path, 'data.json'));
    if (!jsonFile.existsSync()) {
      throw const RestoreException('這不是農田日記的備份檔（找不到 data.json）');
    }
    final data =
        jsonDecode(await jsonFile.readAsString()) as Map<String, dynamic>;
    if (data['format'] != backupFormat) {
      throw const RestoreException('這不是農田日記的備份檔');
    }
    if ((data['formatVersion'] as int? ?? 0) > 1) {
      throw const RestoreException('備份檔版本較新，請先更新 App');
    }

    final workspace = Workspace.fromJson(
      data['workspace'] as Map<String, dynamic>,
    );
    final exists = await (db.select(
      db.workspaces,
    )..where((w) => w.id.equals(workspace.id))).getSingleOrNull();
    if (exists != null) {
      throw RestoreException('「${workspace.name}」已經在這支手機上，不需要還原');
    }

    final profile = await db.select(db.profiles).getSingleOrNull();
    if (profile == null) throw const RestoreException('請先完成「開始使用」再還原');

    await mediaDir.create(recursive: true);
    var rows = 0;
    var photos = 0;
    final now = DateTime.now();

    await db.transaction(() async {
      Future<void> log(
        String entity,
        String id,
        Map<String, dynamic> payload,
      ) => db
          .into(db.outbox)
          .insert(
            OutboxCompanion.insert(
              workspaceId: workspace.id,
              entity: entity,
              entityId: id,
              op: 'upsert',
              payloadJson: jsonEncode(payload),
              createdAt: now,
            ),
          );

      await db.into(db.workspaces).insert(workspace);
      await db
          .into(db.memberships)
          .insert(
            Membership(
              workspaceId: workspace.id,
              userId: profile.id,
              role: 'owner',
              status: 'active',
            ),
            mode: InsertMode.insertOrReplace,
          );
      for (final spec in syncEntities) {
        for (final raw
            in (data[spec.backupKey] as List? ?? const [])
                .cast<Map<String, dynamic>>()) {
          await spec.applyRemote(db, raw);
          await log(spec.entity, spec.idOfJson(raw), raw);
          rows++;
        }
      }

      for (final raw
          in (data['mediaAssets'] as List? ?? const [])
              .cast<Map<String, dynamic>>()) {
        final name = raw['file'] as String?;
        final source = name == null
            ? null
            : File(p.join(extractDir.path, name));
        final dest = p.join(
          mediaDir.path,
          p.basename(name ?? '${raw['id']}.jpg'),
        );
        if (source != null && source.existsSync()) {
          await source.copy(dest);
          photos++;
        }
        final asset = MediaAsset.fromJson({...raw, 'localPath': dest});
        await db.into(db.mediaAssets).insert(asset);
        await log('media_asset', asset.id, Map.of(raw)..remove('file'));
        rows++;
      }
    });
    await store.switchWorkspace(workspace.id);
    return RestoreResult(workspace, rows, photos);
  } on RestoreException {
    rethrow;
  } on ArchiveException {
    throw const RestoreException('備份檔不是有效的 zip 檔');
  } on FormatException {
    throw const RestoreException('備份檔內容損壞，無法讀取');
  } finally {
    if (extractDir.existsSync()) await extractDir.delete(recursive: true);
  }
}
