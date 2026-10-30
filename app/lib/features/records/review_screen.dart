import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../core/db/database.dart';
import '../../core/repository.dart';
import '../../domain/labels.dart';
import '../../domain/state_machines.dart';

final _reportProvider = StreamProvider.autoDispose.family<ReportView?, String>(
  (ref, id) => ref.watch(repositoryProvider).watchReport(id),
);
final _reportMediaProvider = StreamProvider.autoDispose
    .family<List<MediaAsset>, String>(
      (ref, id) => ref.watch(repositoryProvider).watchMedia('report', id),
    );

/// 管理者確認回報：確認成正式紀錄／要求補資料／退回。回報者在「需要補資料」時可補件。
class ReviewScreen extends ConsumerWidget {
  final String reportId;

  const ReviewScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(_reportProvider(reportId));
    final media = ref.watch(_reportMediaProvider(reportId));
    final session = ref.watch(sessionProvider).value!;
    final canReview = session.role == 'owner' || session.role == 'manager';
    final repo = ref.read(repositoryProvider);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('回報內容')),
      body: AsyncView(
        report,
        builder: (rv) {
          if (rv == null) return const Center(child: Text('找不到這筆回報'));
          final r = rv.report;
          final status = rv.status;
          final reviewable =
              status == ReportStatus.submitted ||
              status == ReportStatus.underReview;
          return PageBody(
            children: [
              Text(
                rv.task?.title ?? '${rv.field.name} 回報',
                style: text.titleLarge,
              ),
              Text(
                '${rv.field.name}・${r.reporterName}・${formatDateTime(r.submittedAt)}',
                style: text.bodyMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusChip.report(status),
                  StatusChip(
                    '回報者說施藥：${PesticideStatus.parse(r.pesticideClaim).label}',
                    tone: Tone.neutral,
                    icon: Icons.record_voice_over,
                  ),
                ],
              ),
              if (r.reviewNote.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.comment, color: context.colors.warning),
                    title: Text(
                      status == ReportStatus.needsInfo ? '需要補的資料' : '管理者說明',
                    ),
                    subtitle: Text(r.reviewNote),
                  ),
                ),
              ],
              const SectionTitle('內容'),
              Text(
                r.rawText.isEmpty ? '（沒有文字）' : r.rawText,
                style: text.bodyLarge,
              ),
              if (r.rawQuantityText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('資材原話：「${r.rawQuantityText}」', style: text.bodyLarge),
              ],
              const SectionTitle('照片'),
              AsyncView(
                media,
                builder: (list) {
                  if (list.isEmpty) {
                    return const EmptyHint('沒有照片', icon: Icons.photo);
                  }
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final m in list)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => showDialog<void>(
                                context: context,
                                builder: (_) => Dialog(
                                  child: InteractiveViewer(
                                    child: Image.file(File(m.localPath)),
                                  ),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(m.localPath),
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  semanticLabel:
                                      '回報照片 ${formatDateTime(m.capturedAt)}',
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            StatusChip.upload(
                              UploadStatus.parse(m.uploadStatus),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              if (reviewable && canReview) ...[
                FilledButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (_) => _ConfirmSheet(view: rv),
                  ),
                  child: const Text('確認成正式紀錄'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    final note = await promptText(
                      context,
                      title: '要求補資料',
                      label: '要補什麼',
                      initial: r.rawQuantityText.isEmpty
                          ? ''
                          : '「${r.rawQuantityText}」是幾公斤？',
                    );
                    if (note != null && context.mounted) {
                      await runAction(context, () async {
                        await repo.openReview(r.id);
                        await repo.requestInfo(r.id, note);
                      }, success: '已要求補資料');
                    }
                  },
                  child: const Text('要求補資料'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.danger,
                    side: BorderSide(color: context.colors.danger),
                  ),
                  onPressed: () async {
                    final reason = await promptText(
                      context,
                      title: '退回回報',
                      label: '退回原因（會保留原文）',
                    );
                    if (reason != null && context.mounted) {
                      await runAction(context, () async {
                        await repo.openReview(r.id);
                        await repo.rejectReport(r.id, reason);
                      }, success: '已退回');
                    }
                  },
                  child: const Text('退回'),
                ),
              ],
              if (status == ReportStatus.needsInfo)
                FilledButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (_) => _ResubmitSheet(reportId: r.id),
                  ),
                  child: const Text('補資料並送出'),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ConfirmSheet extends ConsumerStatefulWidget {
  final ReportView view;

  const _ConfirmSheet({required this.view});

  @override
  ConsumerState<_ConfirmSheet> createState() => _ConfirmSheetState();
}

class _ConfirmSheetState extends ConsumerState<_ConfirmSheet> {
  late final _summary = TextEditingController(
    text: [
      widget.view.task?.title,
      widget.view.report.rawText,
    ].whereType<String>().where((s) => s.isNotEmpty).join('：'),
  );
  late PesticideStatus _pesticide = PesticideStatus.parse(
    widget.view.report.pesticideClaim,
  );
  late String _workType = widget.view.task?.workType ?? 'other';
  late String? _seasonId = widget.view.task?.seasonId;

  @override
  void dispose() {
    _summary.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_summary.text.trim().isEmpty) {
      showMessage(context, '請填紀錄摘要');
      return;
    }
    final ok = await runAction(
      context,
      () => ref
          .read(repositoryProvider)
          .confirmReport(
            widget.view.report.id,
            summary: _summary.text,
            pesticideStatus: _pesticide,
            seasonId: _seasonId,
            workType: _workType,
          ),
      success: '已確認成正式紀錄',
    );
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final seasons = ref.watch(seasonsProvider(widget.view.report.fieldId));
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('確認成正式紀錄', style: text.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _summary,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(labelText: '紀錄摘要（必填）'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: workTypes.containsKey(_workType)
                  ? _workType
                  : 'other',
              decoration: const InputDecoration(labelText: '工作類型'),
              items: [
                for (final e in workTypes.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) => setState(() => _workType = v!),
            ),
            const SizedBox(height: 16),
            AsyncView(
              seasons,
              builder: (ss) => DropdownButtonFormField<String?>(
                initialValue: ss.any((s) => s.id == _seasonId)
                    ? _seasonId
                    : null,
                decoration: const InputDecoration(labelText: '期作'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('不指定'),
                  ),
                  for (final s in ss)
                    DropdownMenuItem<String?>(
                      value: s.id,
                      child: Text('${s.name}・${s.cropName}'),
                    ),
                ],
                onChanged: (v) => setState(() => _seasonId = v),
              ),
            ),
            const SizedBox(height: 16),
            Text('施藥狀態', style: text.titleSmall),
            const SizedBox(height: 8),
            RadioGroup<PesticideStatus>(
              groupValue: _pesticide,
              onChanged: (v) => setState(() => _pesticide = v!),
              child: Column(
                children: [
                  for (final s in PesticideStatus.values)
                    RadioListTile<PesticideStatus>(
                      contentPadding: EdgeInsets.zero,
                      value: s,
                      title: Text(s.label),
                      subtitle: s == PesticideStatus.unknown
                          ? const Text('沒有把握時選這個，不會被當成「沒有施藥」')
                          : null,
                    ),
                ],
              ),
            ),
            if (widget.view.report.rawQuantityText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '資材原話「${widget.view.report.rawQuantityText}」會存為「待補規格」，之後在紀錄頁換算。',
                  style: text.bodyMedium,
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _confirm, child: const Text('確認')),
          ],
        ),
      ),
    );
  }
}

class _ResubmitSheet extends ConsumerStatefulWidget {
  final String reportId;

  const _ResubmitSheet({required this.reportId});

  @override
  ConsumerState<_ResubmitSheet> createState() => _ResubmitSheetState();
}

class _ResubmitSheetState extends ConsumerState<_ResubmitSheet> {
  final _text = TextEditingController();
  final List<NewPhoto> _photos = [];

  @override
  void dispose() {
    _text.dispose();
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
            Text('補資料', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _text,
              autofocus: true,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(labelText: '補充說明'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final f = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  imageQuality: 85,
                  maxWidth: 2560,
                );
                if (f != null) {
                  setState(() => _photos.add(NewPhoto(f.path, DateTime.now())));
                }
              },
              icon: const Icon(Icons.photo_camera),
              label: Text(
                _photos.isEmpty ? '補拍照片（可不拍）' : '已補 ${_photos.length} 張，再拍一張',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                final ok = await runAction(
                  context,
                  () => ref
                      .read(repositoryProvider)
                      .resubmit(widget.reportId, _text.text, photos: _photos),
                  success: '已補件送出',
                );
                if (ok && context.mounted) Navigator.of(context).pop();
              },
              child: const Text('送出'),
            ),
          ],
        ),
      ),
    );
  }
}
