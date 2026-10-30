import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../domain/state_machines.dart';
import 'theme.dart';

final _date = DateFormat('M/d（E）', 'zh_TW');
final _dateTime = DateFormat('M/d（E）HH:mm', 'zh_TW');
final _time = DateFormat('HH:mm', 'zh_TW');

String formatDate(DateTime? d) => d == null ? '未定' : _date.format(d.toLocal());
String formatDateTime(DateTime? d) =>
    d == null ? '未定' : _dateTime.format(d.toLocal());
String formatTime(DateTime? d) => d == null ? '' : _time.format(d.toLocal());

bool isSameDay(DateTime a, DateTime b) {
  final x = a.toLocal(), y = b.toLocal();
  return x.year == y.year && x.month == y.month && x.day == y.day;
}

enum Tone { ok, warning, danger, info, neutral }

/// 狀態標籤：圖示＋文字＋顏色三者並用，不只靠顏色（DESIGN_SYSTEM §7）。
class StatusChip extends StatelessWidget {
  final String label;
  final Tone tone;
  final IconData icon;

  const StatusChip(
    this.label, {
    super.key,
    required this.tone,
    required this.icon,
  });

  factory StatusChip.task(TaskStatus s) => switch (s) {
    TaskStatus.completed => StatusChip(
      s.label,
      tone: Tone.ok,
      icon: Icons.check_circle,
    ),
    TaskStatus.ready => StatusChip(s.label, tone: Tone.ok, icon: Icons.groups),
    TaskStatus.inProgress => StatusChip(
      s.label,
      tone: Tone.info,
      icon: Icons.autorenew,
    ),
    TaskStatus.reported => StatusChip(
      s.label,
      tone: Tone.warning,
      icon: Icons.schedule,
    ),
    TaskStatus.staffing => StatusChip(
      s.label,
      tone: Tone.warning,
      icon: Icons.person_search,
    ),
    TaskStatus.rescheduled => StatusChip(
      s.label,
      tone: Tone.warning,
      icon: Icons.event_repeat,
    ),
    TaskStatus.cancelled => StatusChip(
      s.label,
      tone: Tone.neutral,
      icon: Icons.block,
    ),
    TaskStatus.draft || TaskStatus.scheduled => StatusChip(
      s.label,
      tone: Tone.neutral,
      icon: Icons.event,
    ),
  };

  factory StatusChip.assignment(AssignmentStatus s) => switch (s) {
    AssignmentStatus.accepted ||
    AssignmentStatus.arrived ||
    AssignmentStatus.finished => StatusChip(
      s.label,
      tone: Tone.ok,
      icon: Icons.check_circle,
    ),
    AssignmentStatus.awaitingReply || AssignmentStatus.needsReconfirm =>
      StatusChip(s.label, tone: Tone.warning, icon: Icons.schedule),
    AssignmentStatus.declined || AssignmentStatus.leftEarly => StatusChip(
      s.label,
      tone: Tone.danger,
      icon: Icons.error_outline,
    ),
    AssignmentStatus.notContacted || AssignmentStatus.cancelled => StatusChip(
      s.label,
      tone: Tone.neutral,
      icon: Icons.help_outline,
    ),
  };

  factory StatusChip.report(ReportStatus s) => switch (s) {
    ReportStatus.confirmed => StatusChip(
      s.label,
      tone: Tone.ok,
      icon: Icons.check_circle,
    ),
    ReportStatus.submitted ||
    ReportStatus.underReview ||
    ReportStatus.amended => StatusChip(
      s.label,
      tone: Tone.warning,
      icon: Icons.schedule,
    ),
    ReportStatus.needsInfo => StatusChip(
      s.label,
      tone: Tone.warning,
      icon: Icons.help_outline,
    ),
    ReportStatus.rejected || ReportStatus.voided => StatusChip(
      s.label,
      tone: Tone.danger,
      icon: Icons.error_outline,
    ),
    ReportStatus.draft => StatusChip(
      s.label,
      tone: Tone.neutral,
      icon: Icons.phone_android,
    ),
  };

  factory StatusChip.pesticide(PesticideStatus s) => switch (s) {
    PesticideStatus.applied => StatusChip(
      '施藥：${s.label}',
      tone: Tone.info,
      icon: Icons.science,
    ),
    PesticideStatus.confirmedNone => StatusChip(
      '施藥：${s.label}',
      tone: Tone.ok,
      icon: Icons.check_circle,
    ),
    PesticideStatus.unknown => StatusChip(
      '施藥：${s.label}',
      tone: Tone.warning,
      icon: Icons.help_outline,
    ),
    PesticideStatus.incomplete => StatusChip(
      '施藥：${s.label}',
      tone: Tone.danger,
      icon: Icons.error_outline,
    ),
  };

  factory StatusChip.upload(UploadStatus s) => switch (s) {
    UploadStatus.localSaved => StatusChip(
      s.label,
      tone: Tone.neutral,
      icon: Icons.phone_android,
    ),
    UploadStatus.uploading => StatusChip(
      s.label,
      tone: Tone.info,
      icon: Icons.cloud_upload,
    ),
    UploadStatus.serverReceived || UploadStatus.processed => StatusChip(
      s.label,
      tone: Tone.ok,
      icon: Icons.cloud_done,
    ),
    UploadStatus.failed || UploadStatus.processingFailed => StatusChip(
      s.label,
      tone: Tone.danger,
      icon: Icons.error_outline,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = switch (tone) {
      Tone.ok => Theme.of(context).colorScheme.primary,
      Tone.warning => c.warning,
      Tone.danger => c.danger,
      Tone.info => c.info,
      Tone.neutral => c.neutral,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: ShapeDecoration(
        shape: StadiumBorder(side: BorderSide(color: color)),
        color: color.withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const SectionTitle(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text(text, style: Theme.of(context).textTheme.titleMedium),
        ?trailing,
      ],
    ),
  );
}

class EmptyHint extends StatelessWidget {
  final String text;
  final IconData icon;

  const EmptyHint(this.text, {super.key, this.icon = Icons.info_outline});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: context.colors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ),
        ],
      ),
    ),
  );
}

/// AsyncValue 的共用呈現：載入中、錯誤（說明原因）、資料。
class AsyncView<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  const AsyncView(this.value, {super.key, required this.builder});

  @override
  Widget build(BuildContext context) => value.when(
    data: builder,
    loading: () => const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    ),
    error: (e, _) => Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        '讀取資料時發生問題：$e',
        style: TextStyle(color: context.colors.danger),
      ),
    ),
  );
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  bool danger = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('先不要'),
        ),
        FilledButton(
          style: danger
              ? FilledButton.styleFrom(backgroundColor: context.colors.danger)
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<String?> promptText(
  BuildContext context, {
  required String title,
  required String label,
  String initial = '',
  String confirmLabel = '確定',
  bool required = true,
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        minLines: 1,
        maxLines: 4,
        decoration: InputDecoration(labelText: label),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            final text = controller.text.trim();
            if (required && text.isEmpty) return;
            Navigator.pop(context, text);
          },
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

void showMessage(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

/// 執行寫入動作；失敗時顯示原因，而不是默默失敗。
Future<bool> runAction(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
}) async {
  try {
    await action();
    if (success != null && context.mounted) showMessage(context, success);
    return true;
  } catch (e) {
    if (context.mounted) showMessage(context, '沒有完成：$e');
    return false;
  }
}

/// 頁面內容的共用外框：可捲動、左右留白、底部留空給主要按鈕。
class PageBody extends StatelessWidget {
  final List<Widget> children;

  const PageBody({super.key, required this.children});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
    children: children,
  );
}
