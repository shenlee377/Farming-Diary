import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../core/repository.dart';
import '../../core/sync/sync_controller.dart';
import '../../domain/state_machines.dart';
import '../fields/field_detail_screen.dart';
import '../inspection/inspection_camera_screen.dart';
import '../records/review_screen.dart';
import '../tasks/task_card.dart';
import '../tasks/task_detail_screen.dart';

final _waitingReportsProvider = StreamProvider.autoDispose<List<ReportView>>(
  (ref) => ref
      .watch(repositoryProvider)
      .watchReports(
        statuses: [ReportStatus.submitted, ReportStatus.underReview],
      ),
);

final _myNeedsInfoProvider = StreamProvider.autoDispose<List<ReportView>>(
  (ref) => ref
      .watch(repositoryProvider)
      .watchReports(statuses: [ReportStatus.needsInfo]),
);

/// 首頁：今天要做／等我確認／我的田（DESIGN_SYSTEM §9）。
class HomeScreen extends ConsumerWidget {
  final void Function(int tab) onOpenTab;

  const HomeScreen({super.key, required this.onOpenTab});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 11) return '早安';
    if (h < 14) return '午安';
    if (h < 18) return '午後好';
    return '晚安';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).value!;
    final tasks = ref.watch(openTasksProvider);
    final waiting = ref.watch(_waitingReportsProvider);
    final needsInfo = ref.watch(_myNeedsInfoProvider);
    final fields = ref.watch(fieldsProvider);
    final pending = ref.watch(pendingOutboxProvider).value ?? 0;
    final sync = ref.watch(syncControllerProvider);
    final text = Theme.of(context).textTheme;
    final canReview = session.role == 'owner' || session.role == 'manager';
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: Text(session.workspace.name)),
      body: PageBody(
        children: [
          Text(
            '${session.profile.displayName}，${_greeting()}',
            style: text.displaySmall,
          ),
          if (pending > 0 && (!sync.configured || sync.lastError != null)) ...[
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(
                  sync.configured ? Icons.sync_problem : Icons.phone_android,
                  color: sync.configured
                      ? context.colors.warning
                      : context.colors.neutral,
                ),
                title: Text('$pending 筆變更存在手機'),
                subtitle: Text(
                  sync.configured
                      ? '暫時無法同步，會自動再試；資料不會遺失。'
                      : '雲端同步尚未開通，資料不會遺失；可到「更多」匯出備份。',
                ),
                onTap: () => onOpenTab(4),
              ),
            ),
          ],
          const SectionTitle('今天要做'),
          AsyncView(
            tasks,
            builder: (list) {
              final todays = list.where((t) {
                final start = t.task.plannedStart;
                if (t.status == TaskStatus.inProgress) return true;
                if (start == null) return false;
                return isSameDay(start, today) || start.isBefore(today);
              }).toList();
              if (todays.isEmpty) {
                return EmptyHint(
                  list.isEmpty ? '還沒有工作。到「工作」新增一項。' : '今天沒有排定的工作。',
                  icon: Icons.event_available,
                );
              }
              return Column(
                children: [
                  for (final t in todays)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TaskCard(t),
                    ),
                ],
              );
            },
          ),
          AsyncView(
            tasks,
            builder: (list) {
              final tomorrow = DateTime(today.year, today.month, today.day + 1);
              final weekEnd = tomorrow.add(const Duration(days: 7));
              final upcoming = list.where((t) {
                final start = t.task.plannedStart?.toLocal();
                return start != null &&
                    !start.isBefore(tomorrow) &&
                    start.isBefore(weekEnd);
              }).toList();
              if (upcoming.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionTitle('接下來 7 天'),
                  for (final t in upcoming)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            '${formatDate(t.task.plannedStart)} ${formatTime(t.task.plannedStart)}・${t.task.title}',
                          ),
                          subtitle: Text(
                            [
                              t.field.name,
                              t.status.label,
                              if (t.task.headcountNeeded > 0)
                                '已答應 ${t.acceptedCount}／${t.task.headcountNeeded} 人',
                            ].join('・'),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  TaskDetailScreen(taskId: t.task.id),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          if (needsInfo.value?.isNotEmpty ?? false) ...[
            const SectionTitle('需要補資料'),
            for (final r in needsInfo.value!)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: context.colors.warning,
                    ),
                    title: Text(r.task?.title ?? '${r.field.name} 回報'),
                    subtitle: Text('要補：${r.report.reviewNote}'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReviewScreen(reportId: r.report.id),
                      ),
                    ),
                  ),
                ),
              ),
          ],
          if (canReview) ...[
            SectionTitle(
              '等我確認',
              trailing: TextButton(
                onPressed: () => onOpenTab(3),
                child: const Text('全部紀錄'),
              ),
            ),
            AsyncView(
              waiting,
              builder: (list) {
                if (list.isEmpty) {
                  return const EmptyHint('沒有等待確認的回報。', icon: Icons.task_alt);
                }
                return Column(
                  children: [
                    for (final r in list)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.schedule,
                              color: context.colors.warning,
                            ),
                            title: Text(r.task?.title ?? '${r.field.name} 回報'),
                            subtitle: Text(
                              '${r.report.reporterName}・${formatDateTime(r.report.submittedAt)}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ReviewScreen(reportId: r.report.id),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          SectionTitle(
            '我的田',
            trailing: TextButton(
              onPressed: () => onOpenTab(1),
              child: const Text('全部田區'),
            ),
          ),
          AsyncView(
            fields,
            builder: (list) {
              if (list.isEmpty) {
                return const EmptyHint('還沒有田區。到「田區」新增第一塊田。', icon: Icons.grass);
              }
              return Column(
                children: [
                  for (final f in list.take(5))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          title: Text(f.name),
                          subtitle: f.aliases.isEmpty
                              ? null
                              : Text('也叫：${f.aliases}'),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FieldDetailScreen(fieldId: f.id),
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: '開始巡田',
                            icon: const Icon(Icons.photo_camera),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => InspectionCameraScreen(
                                  fieldId: f.id,
                                  fieldName: f.name,
                                ),
                              ),
                            ),
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
