import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:farming_diary/core/db/database.dart';
import 'package:farming_diary/core/repository.dart';
import 'package:farming_diary/core/sync/api_client.dart';
import 'package:farming_diary/core/sync/sync_service.dart';
import 'package:farming_diary/domain/state_machines.dart';
import 'package:flutter_test/flutter_test.dart';

/// 依 docs/API_CONTRACT.md v1 實作的記憶體假伺服器，只用於測試 App 的同步客戶端。
class FakeServer {
  late HttpServer _server;
  String accessToken = 'a1';
  String refreshToken = 'r1';
  int _tokenSeq = 1;

  final Map<String, Map<String, dynamic>> commands = {}; // command_id → command
  final Map<String, int> versions = {}; // entity_id → server version
  final Map<String, List<int>> uploadedBytes = {}; // upload_id → bytes
  final Map<String, String> uploadsByClientId = {};
  final Map<String, List<int>> files = {}; // media id → bytes（伺服器上已有的檔案）
  List<Map<String, dynamic>> pendingChanges = [];
  List<String> revokedWorkspaces = [];

  int failNextPushWith = 0;
  bool expireTokenOnce = false;
  String? rejectEntity;
  int refreshCalls = 0;
  int pushCalls = 0;

  Uri get base =>
      Uri.parse('http://${_server.address.host}:${_server.port}/v1');

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server.listen(_handle);
  }

  Future<void> stop() => _server.close(force: true);

  Future<void> _json(HttpRequest req, int status, Object body) async {
    req.response
      ..statusCode = status
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(body));
    await req.response.close();
  }

  Future<void> _handle(HttpRequest req) async {
    final path = req.uri.path;
    final bodyText = await utf8.decodeStream(req);
    final body = bodyText.isEmpty || req.method == 'PUT'
        ? <String, dynamic>{}
        : jsonDecode(bodyText) as Map<String, dynamic>;

    if (req.method == 'POST' && path == '/v1/auth/dev/login') {
      return _json(req, 200, {
        'user_id': body['local_user_id'],
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_in': 900,
      });
    }
    if (req.method == 'POST' && path == '/v1/auth/refresh') {
      refreshCalls++;
      if (body['refresh_token'] != refreshToken) {
        return _json(req, 401, {'error_code': 'invalid_refresh'});
      }
      _tokenSeq++;
      accessToken = 'a$_tokenSeq';
      refreshToken = 'r$_tokenSeq';
      return _json(req, 200, {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_in': 900,
      });
    }
    // 上傳到 Signed URL 與下載檔案不需要 Bearer
    if (req.method == 'PUT' && path.startsWith('/signed/')) {
      uploadedBytes[path.split('/').last] = utf8.encode(bodyText);
      req.response.statusCode = 200;
      return req.response.close();
    }
    if (req.method == 'GET' && path.startsWith('/files/')) {
      req.response.add(files[path.split('/').last]!);
      return req.response.close();
    }

    final auth = req.headers.value('authorization');
    if (expireTokenOnce || auth != 'Bearer $accessToken') {
      expireTokenOnce = false;
      return _json(req, 401, {'error_code': 'token_expired', 'message': '過期'});
    }

    if (req.method == 'POST' && path == '/v1/sync/push') {
      pushCalls++;
      if (failNextPushWith != 0) {
        final code = failNextPushWith;
        failNextPushWith = 0;
        return _json(req, code, {
          'error_code': 'server_error',
          'message': '暫時故障',
        });
      }
      final results = <Map<String, dynamic>>[];
      for (final c in (body['commands'] as List).cast<Map<String, dynamic>>()) {
        final id = c['command_id'] as String;
        if (commands.containsKey(id)) {
          results.add({'command_id': id, 'status': 'duplicate'});
        } else if (c['entity'] == rejectEntity) {
          commands[id] = c;
          results.add({
            'command_id': id,
            'status': 'rejected',
            'error_code': 'illegal_transition',
            'message': '狀態已改變',
          });
        } else {
          commands[id] = c;
          final v = (versions[c['entity_id'] as String] ?? 0) + 1;
          versions[c['entity_id'] as String] = v;
          results.add({
            'command_id': id,
            'status': 'applied',
            'server_version': v,
          });
        }
      }
      return _json(req, 200, {'results': results});
    }
    if (req.method == 'GET' && path == '/v1/sync/changes') {
      final changes = pendingChanges;
      pendingChanges = [];
      final revoked = revokedWorkspaces;
      revokedWorkspaces = [];
      return _json(req, 200, {
        'changes': changes,
        'next_cursor': 'c${DateTime.now().microsecondsSinceEpoch}',
        'has_more': false,
        'revoked_workspaces': revoked,
      });
    }
    if (req.method == 'POST' && path == '/v1/uploads') {
      final clientId = body['client_upload_id'] as String;
      final existing = uploadsByClientId[clientId];
      if (existing != null && uploadedBytes.containsKey(existing)) {
        return _json(req, 200, {
          'upload_id': existing,
          'status': 'server_received',
        });
      }
      final uploadId = 'up-$clientId';
      uploadsByClientId[clientId] = uploadId;
      return _json(req, 200, {
        'upload_id': uploadId,
        'status': 'pending',
        'upload_url': '${base.replace(path: '/signed/$uploadId')}',
        'upload_headers': {'Content-Type': body['mime']},
      });
    }
    if (req.method == 'POST' &&
        path.startsWith('/v1/uploads/') &&
        path.endsWith('/complete')) {
      final id = path.split('/')[3];
      if (!uploadedBytes.containsKey(id)) {
        return _json(req, 400, {'error_code': 'not_uploaded'});
      }
      return _json(req, 200, {'status': 'server_received'});
    }
    if (req.method == 'GET' &&
        path.startsWith('/v1/media/') &&
        path.endsWith('/url')) {
      final id = path.split('/')[3];
      return _json(req, 200, {
        'url': '${base.replace(path: '/files/$id')}',
        'expires_in': 600,
      });
    }
    return _json(req, 404, {'error_code': 'not_found'});
  }
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late FakeServer server;
  late AppDatabase db;
  late Directory tmp;
  late FarmRepository repo;
  late ApiClient api;
  late SyncService sync;
  late MemoryTokenStore tokens;

  setUp(() async {
    server = FakeServer();
    await server.start();
    db = AppDatabase(NativeDatabase.memory());
    tmp = await Directory.systemTemp.createTemp('fd_sync');
    final session = await SessionStore(db)
        .setUp(displayName: '阿明', workspaceName: '林家田');
    repo = FarmRepository(db, session, Directory('${tmp.path}/media'));
    tokens = MemoryTokenStore();
    api = ApiClient(server.base, tokens);
    await api.devLogin(displayName: '阿明', localUserId: session.userId);
    sync = SyncService(db, api, Directory('${tmp.path}/media'));
  });

  tearDown(() async {
    api.close();
    await server.stop();
    await db.close();
    await tmp.delete(recursive: true);
  });

  Future<Map<String, int>> outboxCounts() async {
    final rows = await db.select(db.outbox).get();
    final counts = <String, int>{};
    for (final r in rows) {
      counts[r.status] = (counts[r.status] ?? 0) + 1;
    }
    return counts;
  }

  test('推送 outbox：全部送出；再同步不重送', () async {
    final field = await repo.createField(name: '北田');
    await repo.createTask(
      fieldId: field.id,
      title: '除草',
      workType: 'weeding',
      plannedStart: DateTime(2026, 11, 2),
    );
    final before = (await db.select(db.outbox).get()).length;

    final report = await sync.syncOnce();
    expect(report.pushed, before);
    expect((await outboxCounts())['sent'], before);
    expect(
      server.commands.values.map((c) => c['entity']),
      containsAll(['workspace', 'field', 'task']),
    );

    final again = await sync.syncOnce();
    expect(again.pushed, 0);
    expect(server.commands.length, before);
  });

  test('伺服器暫時故障：保留在手機，下次重試成功；回應遺失時以 command_id 去重', () async {
    await repo.createField(name: '北田');
    server.failNextPushWith = 503;
    await expectLater(sync.syncOnce(), throwsA(isA<ApiException>()));
    final failed = await db.select(db.outbox).get();
    expect(
      failed.every(
        (o) => o.status == 'pending' && o.attempts == 1 && o.lastError != null,
      ),
      isTrue,
    );

    await sync.syncOnce();
    expect((await outboxCounts())['sent'], failed.length);

    // 模擬「伺服器已套用，但回應沒送到手機」：把紀錄改回 pending 再同步
    await db
        .update(db.outbox)
        .write(const OutboxCompanion(status: Value('pending')));
    final report = await sync.syncOnce();
    expect(report.duplicates, failed.length);
    expect(report.pushed, 0);
  });

  test('access token 過期：自動換發後繼續', () async {
    await repo.createField(name: '北田');
    server.expireTokenOnce = true;
    await sync.syncOnce();
    expect(server.refreshCalls, 1);
    expect(tokens.tokens!.accessToken, server.accessToken);
    expect((await outboxCounts()).keys, ['sent']);
  });

  test('被拒絕的命令留在手機並計數', () async {
    final field = await repo.createField(name: '北田');
    await repo.createTask(fieldId: field.id, title: '除草', workType: 'weeding');
    server.rejectEntity = 'task';
    final report = await sync.syncOnce();
    expect(report.rejected, 1);
    final rejected = await (db.select(
      db.outbox,
    )..where((o) => o.status.equals('rejected'))).get();
    expect(rejected.single.entity, 'task');
    expect(rejected.single.lastError, '狀態已改變');
  });

  test('照片上傳：位元組一致、狀態變已上傳、不重複上傳', () async {
    final field = await repo.createField(name: '北田');
    final photo = File('${tmp.path}/p.jpg')
      ..writeAsStringSync('fake-jpeg-bytes');
    final report = await repo.submitReport(
      fieldId: field.id,
      photos: [NewPhoto(photo.path, DateTime(2026, 11, 2))],
    );

    final r1 = await sync.syncOnce();
    expect(r1.uploaded, 1);
    final media = (await repo.watchMedia('report', report.id).first).single;
    expect(media.uploadStatus, UploadStatus.serverReceived.name);
    expect(utf8.decode(server.uploadedBytes.values.single), 'fake-jpeg-bytes');

    final r2 = await sync.syncOnce();
    expect(r2.uploaded, 0);
  });

  test('拉取：較新版本覆寫、本機較新略過、雲端照片下載', () async {
    final field = await repo.createField(name: '北田');
    await sync.syncOnce();
    final local = (await repo.watchField(field.id).first)!;

    // 別人改了名字（版本較新）
    server.pendingChanges = [
      {
        'entity': 'field',
        'entity_id': field.id,
        'workspace_id': field.workspaceId,
        'op': 'upsert',
        'version': local.version + 1,
        'payload': local
            .copyWith(name: '北田（大坵）', version: local.version + 1)
            .toJson(),
      },
    ];
    var report = await sync.syncOnce();
    expect(report.pulled, 1);
    expect((await repo.watchField(field.id).first)!.name, '北田（大坵）');

    // 舊版本不得覆蓋本機較新的修改
    final current = (await repo.watchField(field.id).first)!;
    await repo.updateField(current, name: '北田（本機剛改）');
    server.pendingChanges = [
      {
        'entity': 'field',
        'entity_id': field.id,
        'workspace_id': field.workspaceId,
        'op': 'upsert',
        'version': current.version,
        'payload': current.copyWith(name: '舊名字').toJson(),
      },
    ];
    report = await sync.syncOnce();
    expect(report.pulled, 0);
    expect((await repo.watchField(field.id).first)!.name, '北田（本機剛改）');

    // 別的成員上傳的照片：中繼資料先進來，檔案再下載
    const mediaId = '01930000-0000-7000-8000-000000000001';
    server.files[mediaId] = utf8.encode('remote-photo');
    server.pendingChanges = [
      {
        'entity': 'media_asset',
        'entity_id': mediaId,
        'workspace_id': field.workspaceId,
        'op': 'upsert',
        'version': 1,
        'payload': {
          'id': mediaId,
          'workspaceId': field.workspaceId,
          'ownerKind': 'report',
          'ownerId': 'r1',
          'kind': 'photo',
          'mime': 'image/jpeg',
          'sizeBytes': 12,
          'sha256': 'x',
          'capturedAt': DateTime(2026, 11, 3).millisecondsSinceEpoch,
          'clientUploadId': mediaId,
          'uploadStatus': 'server_received',
          'createdAt': DateTime(2026, 11, 3).millisecondsSinceEpoch,
        },
      },
    ];
    report = await sync.syncOnce();
    expect(report.downloaded, 1);
    final downloaded = (await repo.watchMedia('report', 'r1').first).single;
    expect(File(downloaded.localPath).readAsStringSync(), 'remote-photo');
    expect(await repo.watchPendingUploads().first, 0, reason: '別人的照片不需要再上傳');
  });

  test('權限被撤銷：本機成員資格移除', () async {
    await repo.createField(name: '北田');
    server.revokedWorkspaces = [repo.session.workspaceId];
    final report = await sync.syncOnce();
    expect(report.revokedWorkspaces, [repo.session.workspaceId]);
    expect(await SessionStore(db).load(), isNull);
    // 尚未上傳的資料仍保留可匯出
    expect(await db.select(db.fields).get(), isNotEmpty);
  });

  test('連不上伺服器時記錄錯誤、不遺失資料', () async {
    await repo.createField(name: '北田');
    await server.stop();
    await expectLater(sync.syncOnce(), throwsA(isA<ApiException>()));
    expect(await sync.lastError(), contains('連不上伺服器'));
    expect((await outboxCounts())['pending'], greaterThan(0));
  });

  test('任務狀態推送的 payload 含版本號，供伺服器做狀態機驗證', () async {
    final field = await repo.createField(name: '北田');
    final task = await repo.createTask(
      fieldId: field.id,
      title: '除草',
      workType: 'weeding',
      plannedStart: DateTime(2026, 11, 2),
    );
    await repo.applyTaskAction(task.id, TaskAction.startStaffing);
    await sync.syncOnce();
    final taskCommands = server.commands.values
        .where((c) => c['entity'] == 'task')
        .toList();
    expect(taskCommands.map((c) => (c['payload'] as Map)['status']), [
      'scheduled',
      'staffing',
    ]);
    expect(taskCommands.map((c) => (c['payload'] as Map)['version']), [1, 2]);
  });
}
