import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../core/db/database.dart';
import '../../core/repository.dart';
import '../../domain/labels.dart';
import '../../domain/state_machines.dart';
import '../contacts/contact_editor_screen.dart';
import '../records/review_screen.dart';
import '../reports/report_screen.dart';
import 'task_editor_screen.dart';

final _assignmentsProvider = StreamProvider.autoDispose
    .family<List<AssignmentWithContact>, String>(
      (ref, id) => ref.watch(repositoryProvider).watchAssignments(id),
    );

final _taskReportsProvider = StreamProvider.autoDispose
    .family<List<ReportView>, String>(
      (ref, taskId) => ref
          .watch(repositoryProvider)
          .watchReports()
          .map((list) => list.where((r) => r.report.taskId == taskId).toList()),
    );

final _eventsProvider = StreamProvider.autoDispose
    .family<List<AssignmentEvent>, String>(
      (ref, id) => ref.watch(repositoryProvider).watchAssignmentEvents(id),
    );

/// 由系統自動處理、不給使用者直接按的轉移。
const _automaticActions = {
  TaskAction.staffingFilled,
  TaskAction.someoneCancelled,
  TaskAction.report,
  TaskAction.confirm,
  TaskAction.sendBack,
  TaskAction.reschedule,
  TaskAction.rescheduleConfirmed,
  TaskAction.schedule,
};

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(taskProvider(taskId));
    return AsyncView(
      item,
      builder: (t) {
        if (t == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('找不到這項工作')),
          );
        }
        return _TaskDetail(item: t);
      },
    );
  }
}

class _TaskDetail extends ConsumerWidget {
  final TaskWithField item;

  const _TaskDetail({required this.item});

  Future<void> _reschedule(BuildContext context, FarmRepository repo) async {
    final when = await pickDateTime(context, initial: item.task.plannedStart);
    if (when == null || !context.mounted) return;
    await runAction(context, () async {
      await repo.applyTaskAction(item.task.id, TaskAction.reschedule);
      await repo.applyTaskAction(
        item.task.id,
        TaskAction.rescheduleConfirmed,
        newPlannedStart: when,
      );
    }, success: '已改期。已答應的人改為「需再確認」，是否通知由你決定。');
  }

  Future<void> _schedule(BuildContext context, FarmRepository repo) async {
    final when = await pickDateTime(context);
    if (when == null || !context.mounted) return;
    await runAction(
      context,
      () => repo.applyTaskAction(
        item.task.id,
        TaskAction.schedule,
        newPlannedStart: when,
      ),
    );
  }

  Future<void> _addPerson(BuildContext context, WidgetRef ref) async {
    final contacts = await ref.read(repositoryProvider).watchContacts().first;
    if (!context.mounted) return;
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('新增聯絡人'),
              onTap: () async {
                final created = await Navigator.of(context).push<Contact>(
                  MaterialPageRoute(
                    builder: (_) => const ContactEditorScreen(),
                  ),
                );
                if (context.mounted) Navigator.pop(context, created?.id);
              },
            ),
            for (final c in contacts)
              ListTile(
                title: Text(
                  c.nickname.isEmpty ? c.name : '${c.name}（${c.nickname}）',
                ),
                subtitle: c.workConstraints.isEmpty
                    ? null
                    : Text(c.workConstraints),
                onTap: () => Navigator.pop(context, c.id),
              ),
          ],
        ),
      ),
    );
    if (picked != null && context.mounted) {
      await runAction(
        context,
        () => ref.read(repositoryProvider).addAssignment(item.task.id, picked),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(repositoryProvider);
    final task = item.task;
    final status = item.status;
    final text = Theme.of(context).textTheme;
    final assignments = ref.watch(_assignmentsProvider(task.id));
    final reports = ref.watch(_taskReportsProvider(task.id));
    final manualActions = status.allowedActions.difference(_automaticActions);
    final canReport =
        status.isOpen &&
        status != TaskStatus.reported &&
        status != TaskStatus.draft &&
        status != TaskStatus.rescheduled;

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          if (status.isOpen)
            IconButton(
              tooltip: '修改工作',
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TaskEditorScreen(existing: task),
                ),
              ),
            ),
        ],
      ),
      body: PageBody(
        children: [
          Text(
            '${item.field.name}・${workTypeLabel(task.workType)}',
            style: text.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '時間：${formatDateTime(task.plannedStart)}',
            style: text.bodyLarge,
          ),
          if (task.meetAt != null || task.meetPlace.isNotEmpty)
            Text(
              '集合：${task.meetAt == null ? '' : formatDateTime(task.meetAt)} ${task.meetPlace}',
              style: text.bodyLarge,
            ),
          if (task.notes.isNotEmpty) Text(task.notes, style: text.bodyMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusChip.task(status),
              if (task.headcountNeeded > 0)
                StatusChip(
                  '已答應 ${item.acceptedCount}／${task.headcountNeeded} 人',
                  tone: item.acceptedCount >= task.headcountNeeded
                      ? Tone.ok
                      : Tone.warning,
                  icon: Icons.groups,
                ),
            ],
          ),
          if (canReport) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ReportScreen(fieldId: task.fieldId, task: task),
                ),
              ),
              icon: const Icon(Icons.check),
              label: const Text('我做完了'),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (status == TaskStatus.draft)
                OutlinedButton(
                  onPressed: () => _schedule(context, repo),
                  child: const Text('排定時間'),
                ),
              for (final action in manualActions)
                OutlinedButton(
                  onPressed: () async {
                    if (action == TaskAction.cancel) {
                      final ok = await confirmDialog(
                        context,
                        title: '取消這項工作？',
                        body: '已安排的人不會自動收到通知，請自行聯絡。',
                        confirmLabel: '取消工作',
                        danger: true,
                      );
                      if (!ok || !context.mounted) return;
                    }
                    if (context.mounted) {
                      await runAction(
                        context,
                        () => repo.applyTaskAction(task.id, action),
                      );
                    }
                  },
                  child: Text(action.label),
                ),
              if (status.can(TaskAction.reschedule))
                OutlinedButton(
                  onPressed: () => _reschedule(context, repo),
                  child: const Text('改期'),
                ),
            ],
          ),

          SectionTitle(
            '人員安排',
            trailing: status.isOpen
                ? TextButton.icon(
                    onPressed: () => _addPerson(context, ref),
                    icon: const Icon(Icons.person_add),
                    label: const Text('安排人員'),
                  )
                : null,
          ),
          Text(
            '「打過電話」不等於答應；只有本人答應才算人手。',
            style: text.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          AsyncView(
            assignments,
            builder: (list) {
              if (list.isEmpty) {
                return const EmptyHint('還沒有安排人員。', icon: Icons.groups);
              }
              return Column(
                children: [
                  for (final a in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _AssignmentCard(a),
                    ),
                ],
              );
            },
          ),

          const SectionTitle('回報'),
          AsyncView(
            reports,
            builder: (list) {
              if (list.isEmpty) {
                return const EmptyHint('還沒有回報。', icon: Icons.edit_note);
              }
              return Column(
                children: [
                  for (final r in list)
                    Card(
                      child: ListTile(
                        title: Text(
                          '${r.report.reporterName}・${formatDateTime(r.report.submittedAt)}',
                        ),
                        subtitle: Text(
                          r.report.rawText.isEmpty
                              ? '（沒有文字）'
                              : r.report.rawText,
                          maxLines: 2,
                        ),
                        trailing: StatusChip.report(r.status),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ReviewScreen(reportId: r.report.id),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AssignmentCard extends ConsumerWidget {
  final AssignmentWithContact item;

  const _AssignmentCard(this.item);

  Future<void> _apply(
    BuildContext context,
    WidgetRef ref,
    AssignmentAction action,
  ) async {
    var channel = '';
    var note = '';
    if (action == AssignmentAction.contact) {
      final picked = await showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(title: Text('用什麼方式聯絡？')),
              for (final e in contactChannels.entries)
                ListTile(
                  title: Text(e.value),
                  onTap: () => Navigator.pop(context, e.key),
                ),
            ],
          ),
        ),
      );
      if (picked == null) return;
      channel = picked;
    }
    if (action == AssignmentAction.decline && context.mounted) {
      note =
          await promptText(
            context,
            title: '不能來的原因',
            label: '原因（可不填）',
            required: false,
          ) ??
          '';
    }
    if (context.mounted) {
      await runAction(
        context,
        () => ref
            .read(repositoryProvider)
            .applyAssignmentAction(
              item.assignment.id,
              action,
              channel: channel,
              note: note,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = item.contact;
    final status = item.status;
    final events = ref.watch(_eventsProvider(item.assignment.id));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    c.nickname.isEmpty ? c.name : '${c.name}（${c.nickname}）',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (c.phone.isNotEmpty)
                  IconButton(
                    tooltip: '打電話給${c.name}',
                    icon: const Icon(Icons.call),
                    onPressed: () =>
                        launchUrl(Uri(scheme: 'tel', path: c.phone)),
                  ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: StatusChip.assignment(status),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final action in status.allowedActions.where(
                  (a) => a != AssignmentAction.taskRescheduled,
                ))
                  OutlinedButton(
                    onPressed: () => _apply(context, ref, action),
                    child: Text(action.label),
                  ),
                if (status == AssignmentStatus.notContacted)
                  TextButton(
                    onPressed: () => runAction(
                      context,
                      () => ref
                          .read(repositoryProvider)
                          .removeAssignment(item.assignment),
                    ),
                    child: const Text('移除'),
                  ),
              ],
            ),
            AsyncView(
              events,
              builder: (list) {
                if (list.isEmpty) return const SizedBox.shrink();
                return ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text('聯絡紀錄（${list.length}）'),
                  children: [
                    for (final e in list)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '${formatDateTime(e.at)}：${AssignmentStatus.parse(e.fromStatus).label} → ${AssignmentStatus.parse(e.toStatus).label}',
                        ),
                        subtitle: Text(
                          [
                            if (e.channel.isNotEmpty)
                              '方式：${contactChannels[e.channel] ?? e.channel}',
                            if (e.note.isNotEmpty) e.note,
                          ].join('・'),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
