import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../db/database.dart';
import 'api_client.dart';
import 'sync_service.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => SecureTokenStore());

class SyncState {
  final String? baseUrl;
  final bool signedIn;
  final bool running;
  final DateTime? lastSyncAt;
  final String? lastError;
  final SyncReport? lastReport;

  const SyncState({
    this.baseUrl,
    this.signedIn = false,
    this.running = false,
    this.lastSyncAt,
    this.lastError,
    this.lastReport,
  });

  bool get configured => baseUrl != null && signedIn;

  SyncState copyWith({
    String? baseUrl,
    bool? signedIn,
    bool? running,
    DateTime? lastSyncAt,
    String? lastError,
    bool clearError = false,
    SyncReport? lastReport,
  }) => SyncState(
    baseUrl: baseUrl ?? this.baseUrl,
    signedIn: signedIn ?? this.signedIn,
    running: running ?? this.running,
    lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    lastError: clearError ? null : (lastError ?? this.lastError),
    lastReport: lastReport ?? this.lastReport,
  );
}

class SyncController extends Notifier<SyncState> {
  ApiClient? _api;

  @override
  SyncState build() {
    ref.onDispose(() => _api?.close());
    _load();
    return const SyncState();
  }

  SyncService _service(ApiClient api) =>
      SyncService(ref.read(databaseProvider), api, ref.read(mediaDirProvider));

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    Future<String?> setting(String key) async => (await (db.select(
      db.settings,
    )..where((s) => s.key.equals(key))).getSingleOrNull())?.value;
    final url = await setting(SyncKeys.baseUrl);
    AuthTokens? tokens;
    try {
      tokens = await ref.read(tokenStoreProvider).read();
    } catch (_) {
      tokens = null; // 安全儲存讀不到（例如系統重設金鑰）→ 視為未登入，請使用者重新連接
    }
    final last = await setting(SyncKeys.lastSyncAt);
    if (url != null) {
      _api = ApiClient(Uri.parse(url), ref.read(tokenStoreProvider));
    }
    state = state.copyWith(
      baseUrl: url,
      signedIn: tokens != null,
      lastSyncAt: last == null ? null : DateTime.tryParse(last),
      lastError: await setting(SyncKeys.lastError),
    );
  }

  /// 設定伺服器並以開發身分登入（M1；正式版改為咖啡廳帳號，見 API_CONTRACT §2）。
  Future<void> connectDev(String baseUrl) async {
    final url = Uri.parse(baseUrl.trim());
    if (!url.hasScheme || url.host.isEmpty) {
      throw const FormatException('網址格式不對，例：https://api.example.com/v1');
    }
    final session = ref.read(sessionProvider).value!;
    final api = ApiClient(url, ref.read(tokenStoreProvider));
    await api.devLogin(
      displayName: session.profile.displayName,
      localUserId: session.userId,
      deviceLabel: Platform.operatingSystem,
    );
    final db = ref.read(databaseProvider);
    await db
        .into(db.settings)
        .insertOnConflictUpdate(
          Setting(key: SyncKeys.baseUrl, value: url.toString()),
        );
    _api?.close();
    _api = api;
    state = state.copyWith(
      baseUrl: url.toString(),
      signedIn: true,
      clearError: true,
    );
    await syncNow();
  }

  Future<void> disconnect() async {
    await ref.read(tokenStoreProvider).clear();
    final db = ref.read(databaseProvider);
    await (db.delete(
      db.settings,
    )..where((s) => s.key.equals(SyncKeys.baseUrl))).go();
    _api?.close();
    _api = null;
    state = const SyncState();
  }

  /// 立即同步；未設定或正在同步時不做事。錯誤只記錄在狀態上，不丟出。
  Future<void> syncNow() async {
    final api = _api;
    if (api == null || !state.signedIn || state.running) return;
    state = state.copyWith(running: true);
    try {
      final report = await _service(api).syncOnce();
      state = state.copyWith(
        running: false,
        lastSyncAt: DateTime.now(),
        clearError: true,
        lastReport: report,
      );
      if (report.revokedWorkspaces.isNotEmpty) ref.invalidate(sessionProvider);
    } on ApiException catch (e) {
      final signedIn = e.isAuth
          ? (await ref.read(tokenStoreProvider).read()) != null
          : state.signedIn;
      state = state.copyWith(
        running: false,
        lastError: e.toString(),
        signedIn: signedIn,
      );
    } catch (e) {
      state = state.copyWith(running: false, lastError: e.toString());
    }
  }
}

final syncControllerProvider = NotifierProvider<SyncController, SyncState>(
  SyncController.new,
);

/// 掛在主畫面上：開啟、回到前景、每 5 分鐘、資料變動後 15 秒自動同步。
class AutoSync extends ConsumerStatefulWidget {
  final Widget child;

  const AutoSync({super.key, required this.child});

  @override
  ConsumerState<AutoSync> createState() => _AutoSyncState();
}

class _AutoSyncState extends ConsumerState<AutoSync> {
  Timer? _periodic;
  Timer? _debounce;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _sync);
    _periodic = Timer.periodic(const Duration(minutes: 5), (_) => _sync());
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  void _sync() => ref.read(syncControllerProvider.notifier).syncNow();

  @override
  void dispose() {
    _lifecycle.dispose();
    _periodic?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(pendingOutboxProvider, (prev, next) {
      final before = prev?.value ?? 0, after = next.value ?? 0;
      if (after > before) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(seconds: 15), _sync);
      }
    });
    return widget.child;
  }
}
