import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../domain/labels.dart';
import '../contacts/contacts_screen.dart';

final _workspacesProvider = FutureProvider.autoDispose((ref) {
  ref.watch(sessionProvider);
  return ref.read(sessionStoreProvider).workspaces();
});

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  Future<void> _export(
    BuildContext context,
    WidgetRef ref, {
    required bool withPhotos,
  }) async {
    await runAction(context, () async {
      final repo = ref.read(repositoryProvider);
      final data = await repo.exportWorkspace();
      final dir = await getTemporaryDirectory();
      final stamp = DateTime.now().toIso8601String().replaceAll(
        RegExp(r'[:.]'),
        '-',
      );
      final file = File(p.join(dir.path, 'farming-diary-$stamp.json'));
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(data),
      );
      final files = [XFile(file.path, mimeType: 'application/json')];
      if (withPhotos) {
        for (final m
            in (data['mediaAssets'] as List).cast<Map<String, dynamic>>()) {
          final path = m['localPath'] as String;
          if (File(path).existsSync()) {
            files.add(XFile(path, mimeType: m['mime'] as String?));
          }
        }
      }
      await SharePlus.instance.share(
        ShareParams(files: files, subject: '農田日記備份 $stamp'),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).value!;
    final pending = ref.watch(pendingOutboxProvider).value ?? 0;
    final uploads = ref.watch(pendingUploadsProvider).value ?? 0;
    final workspaces = ref.watch(_workspacesProvider);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('更多')),
      body: PageBody(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(session.profile.displayName),
              subtitle: Text(
                '本機身分（正式帳號登入尚未串接）・${roleLabels[session.role] ?? session.role}',
              ),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final name = await promptText(
                  context,
                  title: '修改稱呼',
                  label: '你的稱呼',
                  initial: session.profile.displayName,
                );
                if (name != null) {
                  await ref.read(sessionProvider.notifier).rename(name);
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('聯絡人'),
              subtitle: const Text('臨時工、帶班者，不需要裝 App'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ContactsScreen())),
            ),
          ),

          const SectionTitle('同步與備份'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.cloud_off, color: context.colors.neutral),
                      const SizedBox(width: 8),
                      Expanded(child: Text('雲端同步尚未開通', style: text.titleSmall)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$pending 筆變更、$uploads 張照片存在這支手機，等伺服器完成後會自動上傳。'
                    '換手機或刪除 App 前，請先匯出備份。',
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _export(context, ref, withPhotos: false),
                    icon: const Icon(Icons.ios_share),
                    label: const Text('匯出備份（資料）'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _export(context, ref, withPhotos: true),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('匯出備份（資料＋照片）'),
                  ),
                ],
              ),
            ),
          ),

          const SectionTitle('農場'),
          AsyncView(
            workspaces,
            builder: (list) => Column(
              children: [
                for (final w in list)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        w.id == session.workspaceId
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                      ),
                      title: Text(w.name),
                      onTap: w.id == session.workspaceId
                          ? null
                          : () => ref
                                .read(sessionProvider.notifier)
                                .switchWorkspace(w.id),
                    ),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final name = await promptText(
                      context,
                      title: '新增農場',
                      label: '農場名稱',
                    );
                    if (name != null) {
                      await ref
                          .read(sessionProvider.notifier)
                          .createWorkspace(name);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('新增另一個農場'),
                ),
              ],
            ),
          ),

          const SectionTitle('顯示'),
          const Card(
            child: ListTile(
              leading: Icon(Icons.format_size),
              title: Text('文字大小'),
              subtitle: Text(
                '跟隨手機的「字型大小」設定（Android 設定 › 顯示；iPhone 設定 › 顯示與亮度 › 文字大小）。',
              ),
            ),
          ),

          const SectionTitle('關於'),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('農田日記 M1 本機版'),
              subtitle: Text('資料存在這支手機；正式帳號登入與雲端同步尚在開發。原始碼以 Apache-2.0 授權公開。'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () =>
                showLicensePage(context: context, applicationName: '農田日記'),
            child: const Text('開放原始碼授權'),
          ),
        ],
      ),
    );
  }
}
