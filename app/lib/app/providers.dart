import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../core/backup.dart';

import '../core/db/database.dart';
import '../core/repository.dart';

/// 由 main() 開啟後覆寫。
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider 未覆寫'),
);

/// App 私有的照片目錄（不需要儲存空間權限）。由 main() 覆寫。
final mediaDirProvider = Provider<Directory>(
  (ref) => throw UnimplementedError('mediaDirProvider 未覆寫'),
);

final sessionStoreProvider = Provider<SessionStore>(
  (ref) => SessionStore(ref.watch(databaseProvider)),
);

class SessionController extends AsyncNotifier<Session?> {
  SessionStore get _store => ref.read(sessionStoreProvider);

  @override
  Future<Session?> build() => _store.load();

  Future<void> setUp({
    required String displayName,
    required String workspaceName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () =>
          _store.setUp(displayName: displayName, workspaceName: workspaceName),
    );
  }

  Future<void> createWorkspace(String name) async {
    await _store.createWorkspace(name);
    state = AsyncData(await _store.load());
  }

  Future<void> switchWorkspace(String workspaceId) async {
    await _store.switchWorkspace(workspaceId);
    state = AsyncData(await _store.load());
  }

  /// 從備份 zip 還原成一個農場並切換過去；第一次使用時一併建立本機身分。
  Future<RestoreResult> restore(String zipPath, {String? displayName}) async {
    if (displayName != null) await _store.ensureProfile(displayName);
    final result = await restoreBackup(
      db: ref.read(databaseProvider),
      store: _store,
      zipPath: zipPath,
      mediaDir: ref.read(mediaDirProvider),
      workDir: await getTemporaryDirectory(),
    );
    state = AsyncData(await _store.load());
    return result;
  }

  Future<void> rename(String displayName) async {
    await _store.renameProfile(displayName);
    state = AsyncData(await _store.load());
  }
}

final sessionProvider = AsyncNotifierProvider<SessionController, Session?>(
  SessionController.new,
);

/// 只有在已建立身分與工作空間後才可讀取。
final repositoryProvider = Provider<FarmRepository>((ref) {
  final session = ref.watch(sessionProvider).value;
  if (session == null) throw StateError('尚未建立工作空間');
  return FarmRepository(
    ref.watch(databaseProvider),
    session,
    ref.watch(mediaDirProvider),
  );
});

// ───────────────────────── 常用資料流 ─────────────────────────

final fieldsProvider = StreamProvider.autoDispose<List<Field>>(
  (ref) => ref.watch(repositoryProvider).watchFields(),
);

final fieldProvider = StreamProvider.autoDispose.family<Field?, String>(
  (ref, id) => ref.watch(repositoryProvider).watchField(id),
);

final openTasksProvider = StreamProvider.autoDispose<List<TaskWithField>>(
  (ref) => ref.watch(repositoryProvider).watchTasks(),
);

final allTasksProvider = StreamProvider.autoDispose<List<TaskWithField>>(
  (ref) => ref.watch(repositoryProvider).watchTasks(openOnly: false),
);

final taskProvider = StreamProvider.autoDispose.family<TaskWithField?, String>(
  (ref, id) => ref.watch(repositoryProvider).watchTask(id),
);

final contactsProvider = StreamProvider.autoDispose<List<Contact>>(
  (ref) => ref.watch(repositoryProvider).watchContacts(),
);

final seasonsProvider = StreamProvider.autoDispose
    .family<List<CropSeason>, String?>(
      (ref, fieldId) =>
          ref.watch(repositoryProvider).watchSeasons(fieldId: fieldId),
    );

final pendingOutboxProvider = StreamProvider.autoDispose<int>(
  (ref) => ref.watch(repositoryProvider).watchPendingOutbox(),
);

final pendingUploadsProvider = StreamProvider.autoDispose<int>(
  (ref) => ref.watch(repositoryProvider).watchPendingUploads(),
);
