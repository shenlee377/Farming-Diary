import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/widgets.dart';
import '../../domain/labels.dart';
import '../contacts/contacts_screen.dart';
import 'backup_actions.dart';
import 'sync_card.dart';

final _workspacesProvider = FutureProvider.autoDispose((ref) {
  ref.watch(sessionProvider);
  return ref.read(sessionStoreProvider).workspaces();
});

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).value!;
    final workspaces = ref.watch(_workspacesProvider);

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
          const SyncCard(),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('備份', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  const Text('把整個農場（資料＋照片＋語音）存成一個檔案，可存到雲端硬碟或傳給自己。'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => exportBackup(context, ref),
                    icon: const Icon(Icons.ios_share),
                    label: const Text('匯出備份（資料＋照片）'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => pickAndRestore(context, ref),
                    icon: const Icon(Icons.settings_backup_restore),
                    label: const Text('從備份還原'),
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
