import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../core/db/database.dart';
import '../../core/repository.dart';
import '../../domain/labels.dart';
import '../../domain/state_machines.dart';
import 'review_screen.dart';

final _pendingReportsProvider = StreamProvider.autoDispose<List<ReportView>>(
  (ref) => ref
      .watch(repositoryProvider)
      .watchReports(
        statuses: [
          ReportStatus.submitted,
          ReportStatus.underReview,
          ReportStatus.needsInfo,
        ],
      ),
);
final _recordsProvider = StreamProvider.autoDispose<List<RecordView>>(
  (ref) => ref.watch(repositoryProvider).watchRecords(),
);
final _revisionsProvider = StreamProvider.autoDispose
    .family<List<RecordRevision>, String>(
      (ref, id) => ref.watch(repositoryProvider).watchRevisions(id),
    );

/// 紀錄：計畫 ≠ 回報 ≠ 正式紀錄，分兩頁呈現。
class RecordsScreen extends ConsumerWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('紀錄'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '回報（待確認）'),
              Tab(text: '正式紀錄'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AsyncView(
              ref.watch(_pendingReportsProvider),
              builder: (list) => PageBody(
                children: [
                  if (list.isEmpty)
                    const EmptyHint('沒有待確認的回報。', icon: Icons.task_alt),
                  for (final r in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          title: Text(r.task?.title ?? '${r.field.name} 回報'),
                          subtitle: Text(
                            '${r.field.name}・${r.report.reporterName}・${formatDateTime(r.report.submittedAt)}',
                          ),
                          trailing: StatusChip.report(r.status),
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
              ),
            ),
            AsyncView(
              ref.watch(_recordsProvider),
              builder: (list) => PageBody(
                children: [
                  if (list.isEmpty)
                    const EmptyHint(
                      '還沒有正式紀錄。回報經確認後會出現在這裡。',
                      icon: Icons.menu_book,
                    ),
                  for (final r in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _RecordCard(r),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordCard extends ConsumerWidget {
  final RecordView view;

  const _RecordCard(this.view);

  Future<void> _amend(BuildContext context, WidgetRef ref) async {
    final record = view.record;
    final summary = await promptText(
      context,
      title: '修正紀錄',
      label: '新的摘要',
      initial: record.summary,
    );
    if (summary == null || !context.mounted) return;
    final reason = await promptText(
      context,
      title: '修正原因',
      label: '為什麼修正（會留下修改歷程）',
    );
    if (reason == null || !context.mounted) return;
    await runAction(
      context,
      () => ref
          .read(repositoryProvider)
          .amendRecord(record, reason: reason, summary: summary),
      success: '已修正，舊內容保留在修改歷程',
    );
  }

  Future<void> _void(BuildContext context, WidgetRef ref) async {
    final reason = await promptText(
      context,
      title: '作廢紀錄',
      label: '作廢原因（紀錄會保留）',
      confirmLabel: '作廢',
    );
    if (reason == null || !context.mounted) return;
    await runAction(
      context,
      () => ref.read(repositoryProvider).voidRecord(view.record, reason),
      success: '已作廢',
    );
  }

  Future<void> _setPesticide(BuildContext context, WidgetRef ref) async {
    final picked = await showModalBottomSheet<PesticideStatus>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in PesticideStatus.values)
              ListTile(
                title: Text(s.label),
                onTap: () => Navigator.pop(context, s),
              ),
          ],
        ),
      ),
    );
    if (picked == null || !context.mounted) return;
    final reason = await promptText(context, title: '修改原因', label: '為什麼修改施藥狀態');
    if (reason == null || !context.mounted) return;
    await runAction(
      context,
      () => ref
          .read(repositoryProvider)
          .amendRecord(view.record, reason: reason, pesticideStatus: picked),
    );
  }

  Future<void> _specify(
    BuildContext context,
    WidgetRef ref,
    WorkRecordInput input,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _SpecifyInputSheet(input: input),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = view.record;
    final text = Theme.of(context).textTheme;
    final revisions = ref.watch(_revisionsProvider(r.id));
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
                    '${view.field.name}・${workTypeLabel(r.workType)}・${formatDate(r.performedOn)}',
                    style: text.titleSmall,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'amend') _amend(context, ref);
                    if (v == 'pesticide') _setPesticide(context, ref);
                    if (v == 'void') _void(context, ref);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'amend', child: Text('修正摘要')),
                    PopupMenuItem(value: 'pesticide', child: Text('修改施藥狀態')),
                    PopupMenuItem(value: 'void', child: Text('作廢')),
                  ],
                ),
              ],
            ),
            Text(r.summary, style: text.bodyLarge),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: StatusChip.pesticide(
                PesticideStatus.parse(r.pesticideStatus),
              ),
            ),
            for (final input in view.inputs)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: input.status == 'pending_spec'
                    ? OutlinedButton.icon(
                        onPressed: () => _specify(context, ref, input),
                        icon: Icon(
                          Icons.help_outline,
                          color: context.colors.warning,
                        ),
                        label: Text('資材「${input.rawQuantityText}」待補規格，點此換算'),
                      )
                    : Text(
                        '資材：${input.productName} ${input.quantity} ${input.unitCode}（原話「${input.rawQuantityText}」，${input.conversionBasis}）',
                      ),
              ),
            AsyncView(
              revisions,
              builder: (list) {
                if (list.isEmpty) return const SizedBox.shrink();
                return ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text('修改歷程（${list.length}）'),
                  children: [
                    for (final rev in list)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(formatDateTime(rev.at)),
                        subtitle: Text('原因：${rev.reason}'),
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

class _SpecifyInputSheet extends ConsumerStatefulWidget {
  final WorkRecordInput input;

  const _SpecifyInputSheet({required this.input});

  @override
  ConsumerState<_SpecifyInputSheet> createState() => _SpecifyInputSheetState();
}

class _SpecifyInputSheetState extends ConsumerState<_SpecifyInputSheet> {
  final _product = TextEditingController();
  final _quantity = TextEditingController();
  final _basis = TextEditingController();
  String _unit = 'kg';

  @override
  void dispose() {
    _product.dispose();
    _quantity.dispose();
    _basis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '換算「${widget.input.rawQuantityText}」',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _product,
              decoration: const InputDecoration(
                labelText: '資材名稱（必填）',
                hintText: '例：台肥 43 號',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantity,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: '數量（必填）'),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _unit,
                  onChanged: (v) => setState(() => _unit = v!),
                  items: const [
                    DropdownMenuItem(value: 'kg', child: Text('公斤')),
                    DropdownMenuItem(value: 'L', child: Text('公升')),
                    DropdownMenuItem(value: 'mL', child: Text('毫升')),
                    DropdownMenuItem(value: 'g', child: Text('公克')),
                    DropdownMenuItem(value: 'bag', child: Text('包')),
                    DropdownMenuItem(value: 'bottle', child: Text('瓶')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _basis,
              decoration: const InputDecoration(
                labelText: '換算依據（必填）',
                hintText: '例：一包 40 公斤，一包半 = 60 公斤',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                if (_product.text.trim().isEmpty ||
                    num.tryParse(_quantity.text.trim()) == null ||
                    _basis.text.trim().isEmpty) {
                  showMessage(context, '請填名稱、數量（數字）與換算依據');
                  return;
                }
                final ok = await runAction(
                  context,
                  () => ref
                      .read(repositoryProvider)
                      .specifyInput(
                        widget.input,
                        productName: _product.text,
                        quantity: _quantity.text,
                        unitCode: _unit,
                        basis: _basis.text,
                      ),
                );
                if (ok && context.mounted) Navigator.of(context).pop();
              },
              child: const Text('儲存'),
            ),
          ],
        ),
      ),
    );
  }
}
