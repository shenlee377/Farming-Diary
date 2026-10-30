import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../core/sync/sync_controller.dart';

final _outboxCountsProvider = StreamProvider.autoDispose<Map<String, int>>(
  (ref) => ref.watch(repositoryProvider).watchOutboxCounts(),
);

/// 「更多」裡的雲端同步狀態：已存在手機、上傳中、衝突、被拒絕都分開顯示（ARCHITECTURE §7.1）。
class SyncCard extends ConsumerWidget {
  const SyncCard({super.key});

  Future<void> _connect(BuildContext context, WidgetRef ref) async {
    final url = await promptText(
      context,
      title: '連接伺服器（開發測試用）',
      label: '伺服器網址',
      initial: 'https://',
      confirmLabel: '連接',
    );
    if (url == null || !context.mounted) return;
    await runAction(
      context,
      () => ref.read(syncControllerProvider.notifier).connectDev(url),
      success: '已連接，開始同步',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncControllerProvider);
    final counts = ref.watch(_outboxCountsProvider).value ?? const {};
    final uploads = ref.watch(pendingUploadsProvider).value ?? 0;
    final text = Theme.of(context).textTheme;
    final pending = (counts['pending'] ?? 0) + (counts['failed'] ?? 0);
    final conflicts = counts['conflict'] ?? 0;
    final rejected = counts['rejected'] ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  sync.configured ? Icons.cloud_done : Icons.cloud_off,
                  color: sync.configured
                      ? Theme.of(context).colorScheme.primary
                      : context.colors.neutral,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sync.configured
                        ? '雲端同步：已連接 ${Uri.parse(sync.baseUrl!).host}'
                        : '雲端同步尚未開通',
                    style: text.titleSmall,
                  ),
                ),
                if (sync.running)
                  const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text('$pending 筆變更、$uploads 個照片或語音存在手機尚未上傳。'),
            if (sync.lastSyncAt != null)
              Text(
                '上次同步：${formatDateTime(sync.lastSyncAt)}',
                style: text.bodySmall,
              ),
            if (conflicts > 0)
              Text(
                '$conflicts 筆和雲端內容不同，已改用雲端版本；原內容保留在手機。',
                style: text.bodyMedium?.copyWith(color: context.colors.warning),
              ),
            if (rejected > 0)
              Text(
                '$rejected 筆被伺服器拒絕（例如狀態已被別人改變），內容保留在手機。',
                style: text.bodyMedium?.copyWith(color: context.colors.danger),
              ),
            if (sync.lastError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '上次同步沒有完成：${sync.lastError}，會自動再試。',
                  style: text.bodyMedium?.copyWith(
                    color: context.colors.danger,
                  ),
                ),
              ),
            if (!sync.configured)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '資料不會遺失；換手機或刪除 App 前請先匯出備份。',
                  style: text.bodySmall,
                ),
              ),
            const SizedBox(height: 12),
            if (sync.configured) ...[
              FilledButton.icon(
                onPressed: sync.running
                    ? null
                    : () => ref.read(syncControllerProvider.notifier).syncNow(),
                icon: const Icon(Icons.sync),
                label: Text(sync.running ? '同步中…' : '立即同步'),
              ),
              TextButton(
                onPressed: () async {
                  final ok = await confirmDialog(
                    context,
                    title: '中斷連接？',
                    body: '手機上的資料都會保留，之後可以再連接。',
                    confirmLabel: '中斷連接',
                  );
                  if (ok) {
                    await ref
                        .read(syncControllerProvider.notifier)
                        .disconnect();
                  }
                },
                child: const Text('中斷連接'),
              ),
            ] else
              OutlinedButton.icon(
                onPressed: () => _connect(context, ref),
                icon: const Icon(Icons.cloud_upload),
                label: const Text('連接伺服器（開發測試用）'),
              ),
          ],
        ),
      ),
    );
  }
}
