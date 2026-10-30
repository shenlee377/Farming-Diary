import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../domain/geo.dart';
import 'field_detail_screen.dart';
import 'field_editor_screen.dart';

class FieldsScreen extends ConsumerWidget {
  const FieldsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fields = ref.watch(fieldsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('田區')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const FieldEditorScreen())),
        icon: const Icon(Icons.add),
        label: const Text('新增田區'),
      ),
      body: AsyncView(
        fields,
        builder: (list) {
          if (list.isEmpty) {
            return const PageBody(
              children: [
                EmptyHint(
                  '還沒有田區。按右下角「新增田區」，填名稱就可以開始；田界、地號之後再補。',
                  icon: Icons.grass,
                ),
              ],
            );
          }
          return PageBody(
            children: [
              for (final f in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListTile(
                      title: Text(f.name),
                      subtitle: Text(
                        [
                          if (f.aliases.isNotEmpty) '也叫：${f.aliases}',
                          f.areaM2 == null ? '面積未填' : formatArea(f.areaM2!),
                        ].join('\n'),
                        style: TextStyle(color: context.colors.textSecondary),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FieldDetailScreen(fieldId: f.id),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 72),
            ],
          );
        },
      ),
    );
  }
}
