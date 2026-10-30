import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../core/repository.dart';
import '../../domain/labels.dart';
import '../../domain/state_machines.dart';
import '../reports/report_screen.dart';
import 'task_detail_screen.dart';

/// 首頁與工作列表共用的工作卡：標題、田區、時間、狀態、單一主要動作。
class TaskCard extends StatelessWidget {
  final TaskWithField item;
  final bool showReportButton;

  const TaskCard(this.item, {super.key, this.showReportButton = true});

  @override
  Widget build(BuildContext context) {
    final task = item.task;
    final status = item.status;
    final text = Theme.of(context).textTheme;
    final canReport =
        showReportButton &&
        status.isOpen &&
        status != TaskStatus.reported &&
        status != TaskStatus.rescheduled &&
        status != TaskStatus.draft;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TaskDetailScreen(taskId: task.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(task.title, style: text.titleMedium),
              const SizedBox(height: 4),
              Text(
                '${item.field.name}・${workTypeLabel(task.workType)}・${formatDateTime(task.plannedStart)}',
                style: text.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusChip.task(status),
                  if (task.headcountNeeded > 0)
                    StatusChip(
                      '已答應 ${item.acceptedCount}／${task.headcountNeeded} 人'
                      '${item.contactedCount > 0 ? '（${item.contactedCount} 人等回覆）' : ''}',
                      tone: item.acceptedCount >= task.headcountNeeded
                          ? Tone.ok
                          : Tone.warning,
                      icon: Icons.groups,
                    ),
                ],
              ),
              if (canReport) ...[
                const SizedBox(height: 12),
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
            ],
          ),
        ),
      ),
    );
  }
}
