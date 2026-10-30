import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/widgets.dart';
import 'task_card.dart';
import 'task_editor_screen.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('工作'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '還沒完成'),
              Tab(text: '全部'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: null,
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const TaskEditorScreen())),
          icon: const Icon(Icons.add),
          label: const Text('新增工作'),
        ),
        body: TabBarView(
          children: [
            AsyncView(
              ref.watch(openTasksProvider),
              builder: (list) => _list(list, '沒有未完成的工作。'),
            ),
            AsyncView(
              ref.watch(allTasksProvider),
              builder: (list) => _list(list, '還沒有工作。'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(List list, String empty) => PageBody(
    children: [
      if (list.isEmpty) EmptyHint(empty, icon: Icons.assignment),
      for (final t in list)
        Padding(padding: const EdgeInsets.only(bottom: 12), child: TaskCard(t)),
      const SizedBox(height: 72),
    ],
  );
}
