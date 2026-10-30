import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../app/widgets.dart';
import '../../domain/labels.dart';
import 'contact_editor_screen.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('聯絡人')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ContactEditorScreen())),
        icon: const Icon(Icons.person_add),
        label: const Text('新增聯絡人'),
      ),
      body: AsyncView(
        contacts,
        builder: (list) => PageBody(
          children: [
            if (list.isEmpty)
              const EmptyHint(
                '還沒有聯絡人。臨時工、帶班者不需要裝 App，記在這裡就能安排工作。',
                icon: Icons.people,
              ),
            for (final c in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    title: Text(
                      c.nickname.isEmpty ? c.name : '${c.name}（${c.nickname}）',
                    ),
                    subtitle: Text(
                      [
                        if (c.phone.isNotEmpty) c.phone,
                        '習慣用${contactChannels[c.preferredChannel] ?? c.preferredChannel}',
                        if (c.workConstraints.isNotEmpty) c.workConstraints,
                      ].join('・'),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ContactEditorScreen(existing: c),
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v == 'call') {
                          await launchUrl(Uri(scheme: 'tel', path: c.phone));
                        }
                        if (v == 'archive' && context.mounted) {
                          final ok = await confirmDialog(
                            context,
                            title: '封存${c.name}？',
                            body: '過去的安排與紀錄都會保留。',
                            confirmLabel: '封存',
                            danger: true,
                          );
                          if (ok && context.mounted) {
                            await runAction(
                              context,
                              () => ref
                                  .read(repositoryProvider)
                                  .archiveContact(c),
                            );
                          }
                        }
                      },
                      itemBuilder: (_) => [
                        if (c.phone.isNotEmpty)
                          const PopupMenuItem(
                            value: 'call',
                            child: Text('打電話'),
                          ),
                        const PopupMenuItem(
                          value: 'archive',
                          child: Text('封存'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 72),
          ],
        ),
      ),
    );
  }
}
