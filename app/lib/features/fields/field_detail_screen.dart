import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../core/db/database.dart';
import '../../core/repository.dart';
import '../../domain/geo.dart';
import '../../domain/labels.dart';
import '../../domain/state_machines.dart';
import '../inspection/inspection_camera_screen.dart';
import '../inspection/inspection_session_screen.dart';
import '../reports/report_screen.dart';
import '../tasks/task_editor_screen.dart';
import 'boundary_preview.dart';
import 'boundary_record_screen.dart';
import 'field_editor_screen.dart';
import 'land_dialogs.dart';

final _boundariesProvider = StreamProvider.autoDispose
    .family<List<FieldBoundaryVersion>, String>(
      (ref, id) => ref.watch(repositoryProvider).watchBoundaries(id),
    );
final _parcelsProvider = StreamProvider.autoDispose
    .family<List<ParcelWithRelations>, String>(
      (ref, id) => ref.watch(repositoryProvider).watchParcelsForField(id),
    );
final _pesticideProvider = StreamProvider.autoDispose
    .family<PesticideStatus, String>(
      (ref, id) => ref.watch(repositoryProvider).watchPesticideStatus(id),
    );
final _fieldRecordsProvider = StreamProvider.autoDispose
    .family<List<RecordView>, String>(
      (ref, id) => ref.watch(repositoryProvider).watchRecords(fieldId: id),
    );
final _inspectionsProvider = StreamProvider.autoDispose
    .family<List<InspectionSession>, String>(
      (ref, id) => ref.watch(repositoryProvider).watchInspections(id),
    );

List<GeoPoint> _decodePoints(String json) => (jsonDecode(json) as List)
    .map((e) => GeoPoint.fromJson(e as Map<String, dynamic>))
    .toList();

class FieldDetailScreen extends ConsumerWidget {
  final String fieldId;

  const FieldDetailScreen({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final field = ref.watch(fieldProvider(fieldId));
    return AsyncView(
      field,
      builder: (f) {
        if (f == null || f.archivedAt != null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('這塊田已封存或不存在')),
          );
        }
        return _FieldDetail(field: f);
      },
    );
  }
}

class _FieldDetail extends ConsumerWidget {
  final Field field;

  const _FieldDetail({required this.field});

  void _push(BuildContext context, Widget page, {bool fullscreen = false}) =>
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => page, fullscreenDialog: fullscreen),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(repositoryProvider);
    final text = Theme.of(context).textTheme;
    final boundaries = ref.watch(_boundariesProvider(field.id));
    final parcels = ref.watch(_parcelsProvider(field.id));
    final seasons = ref.watch(seasonsProvider(field.id));
    final pesticide = ref.watch(_pesticideProvider(field.id));
    final records = ref.watch(_fieldRecordsProvider(field.id));
    final inspections = ref.watch(_inspectionsProvider(field.id));

    final areaNote = switch (field.areaMethod) {
      'phone_spherical' => '手機沿田邊估算（球面公式）',
      'user_input' => '自己填寫',
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(field.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'edit') {
                _push(context, FieldEditorScreen(existing: field));
              }
              if (v == 'archive') {
                final ok = await confirmDialog(
                  context,
                  title: '封存「${field.name}」？',
                  body: '封存後不會出現在田區清單，但所有紀錄都保留。',
                  confirmLabel: '封存',
                  danger: true,
                );
                if (ok && context.mounted) {
                  await runAction(
                    context,
                    () => repo.archiveField(field),
                    success: '已封存',
                  );
                  if (context.mounted) Navigator.of(context).pop();
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('修改田區資料')),
              PopupMenuItem(value: 'archive', child: Text('封存田區')),
            ],
          ),
        ],
      ),
      body: PageBody(
        children: [
          if (field.aliases.isNotEmpty)
            Text('也叫：${field.aliases}', style: text.bodyLarge),
          Text(
            field.areaM2 == null ? '面積：未填' : '面積：${formatArea(field.areaM2!)}',
            style: text.bodyLarge,
          ),
          if (areaNote != null)
            Text(
              '來源：$areaNote',
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          if (field.notes.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(field.notes, style: text.bodyMedium),
          ],
          const SizedBox(height: 12),
          AsyncView(
            pesticide,
            builder: (s) => Align(
              alignment: Alignment.centerLeft,
              child: StatusChip.pesticide(s),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _push(
              context,
              InspectionCameraScreen(fieldId: field.id, fieldName: field.name),
              fullscreen: true,
            ),
            icon: const Icon(Icons.photo_camera),
            label: const Text('開始巡田'),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () =>
                    _push(context, TaskEditorScreen(initialFieldId: field.id)),
                icon: const Icon(Icons.add_task),
                label: const Text('新增工作'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    _push(context, ReportScreen(fieldId: field.id)),
                icon: const Icon(Icons.edit_note),
                label: const Text('直接回報'),
              ),
            ],
          ),

          // ── 田界 ──
          SectionTitle(
            '田界',
            trailing: TextButton.icon(
              onPressed: () => _push(
                context,
                BoundaryRecordScreen(fieldId: field.id, fieldName: field.name),
              ),
              icon: const Icon(Icons.directions_walk),
              label: const Text('沿田邊走一圈記錄'),
            ),
          ),
          AsyncView(
            boundaries,
            builder: (list) {
              final current = list
                  .where((b) => b.status == 'confirmed')
                  .firstOrNull;
              final drafts = list.where((b) => b.status == 'draft').toList();
              if (current == null && drafts.isEmpty) {
                return const EmptyHint(
                  '還沒有田界。可以拿手機沿田邊走一圈，或只走到四個角。',
                  icon: Icons.crop_free,
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final d in drafts)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const StatusChip(
                              '草稿，尚未確認',
                              tone: Tone.warning,
                              icon: Icons.schedule,
                            ),
                            const SizedBox(height: 8),
                            BoundaryPreview(_decodePoints(d.pointsJson)),
                            const SizedBox(height: 8),
                            Text(
                              '${formatArea(d.areaM2)}${d.medianAccuracyM == null ? '' : '，定位誤差中位數約 ±${d.medianAccuracyM!.round()} 公尺'}',
                            ),
                            Text(
                              '記錄時間：${formatDateTime(d.createdAt)}',
                              style: text.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            FilledButton(
                              onPressed: () => runAction(
                                context,
                                () => repo.confirmBoundary(d),
                                success: '田界已確認，面積已更新',
                              ),
                              child: const Text('確認這個田界'),
                            ),
                            TextButton(
                              onPressed: () => runAction(
                                context,
                                () => repo.discardBoundaryDraft(d),
                                success: '已捨棄草稿',
                              ),
                              child: const Text('捨棄草稿'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (current != null) ...[
                    if (drafts.isNotEmpty) const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const StatusChip(
                              '目前使用的田界',
                              tone: Tone.ok,
                              icon: Icons.check_circle,
                            ),
                            const SizedBox(height: 8),
                            BoundaryPreview(_decodePoints(current.pointsJson)),
                            const SizedBox(height: 8),
                            Text(formatArea(current.areaM2)),
                            Text(
                              '確認時間：${formatDateTime(current.updatedAt)}',
                              style: text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),

          // ── 期作 ──
          SectionTitle(
            '期作',
            trailing: TextButton.icon(
              onPressed: () => showSeasonDialog(context, ref, field.id),
              icon: const Icon(Icons.add),
              label: const Text('新增期作'),
            ),
          ),
          AsyncView(
            seasons,
            builder: (list) {
              if (list.isEmpty) {
                return const EmptyHint(
                  '還沒有期作，例：「2026 秋作・高麗菜」。',
                  icon: Icons.eco,
                );
              }
              return Column(
                children: [
                  for (final s in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            '${s.name}・${s.cropName}${s.variety.isEmpty ? '' : '（${s.variety}）'}',
                          ),
                          subtitle: Text(
                            [
                              seasonStatusLabels[s.status] ?? s.status,
                              if (s.actualStart != null)
                                '開始 ${formatDate(s.actualStart)}'
                              else if (s.plannedStart != null)
                                '預計 ${formatDate(s.plannedStart)}',
                              if (s.actualEnd != null)
                                '結束 ${formatDate(s.actualEnd)}',
                            ].join('・'),
                          ),
                          trailing:
                              (FarmRepository.seasonTransitions[s.status] ??
                                      const [])
                                  .isEmpty
                              ? null
                              : PopupMenuButton<String>(
                                  tooltip: '改變狀態',
                                  onSelected: (next) => runAction(
                                    context,
                                    () => repo.setSeasonStatus(s, next),
                                  ),
                                  itemBuilder: (_) => [
                                    for (final next
                                        in FarmRepository.seasonTransitions[s
                                            .status]!)
                                      PopupMenuItem(
                                        value: next,
                                        child: Text(
                                          '改為「${seasonStatusLabels[next]}」',
                                        ),
                                      ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // ── 地號與土地關係 ──
          SectionTitle(
            '地號與土地關係',
            trailing: TextButton.icon(
              onPressed: () => showLinkParcelDialog(context, ref, field.id),
              icon: const Icon(Icons.add),
              label: const Text('連結地號'),
            ),
          ),
          AsyncView(
            parcels,
            builder: (list) {
              if (list.isEmpty) {
                return const EmptyHint(
                  '還沒有地號。一塊田可以對應多個地號，同一個地號也可以屬於多塊田。',
                  icon: Icons.description,
                );
              }
              return Column(
                children: [
                  for (final pr in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      pr.parcel.parcelCode,
                                      style: text.titleSmall,
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (v) async {
                                      if (v == 'relation') {
                                        await showLandRelationDialog(
                                          context,
                                          ref,
                                          pr.parcel.id,
                                        );
                                      }
                                      if (v == 'unlink' && context.mounted) {
                                        final ok = await confirmDialog(
                                          context,
                                          title: '取消連結？',
                                          body: '只解除這塊田與地號的對應，地號與土地關係資料保留。',
                                          confirmLabel: '取消連結',
                                        );
                                        if (ok && context.mounted) {
                                          await runAction(
                                            context,
                                            () => repo.unlinkParcel(
                                              field.id,
                                              pr.parcel.id,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                        value: 'relation',
                                        child: Text('新增土地關係'),
                                      ),
                                      PopupMenuItem(
                                        value: 'unlink',
                                        child: Text('取消與這塊田的連結'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (pr.parcel.notes.isNotEmpty)
                                Text(pr.parcel.notes, style: text.bodySmall),
                              if (pr.relations.isEmpty)
                                Text(
                                  '尚未填寫土地關係',
                                  style: text.bodyMedium?.copyWith(
                                    color: context.colors.warning,
                                  ),
                                ),
                              for (final r in pr.relations)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${r.partyName}：${landRelationLabel(r.kind)}${r.share.isEmpty ? '' : '（${r.share}）'}',
                                      ),
                                      Text(
                                        [
                                          verificationLabels[r.verification] ??
                                              r.verification,
                                          if (r.periodStart != null ||
                                              r.periodEnd != null)
                                            '期間 ${formatDate(r.periodStart)}～${formatDate(r.periodEnd)}',
                                          if (r.rentAmount != null)
                                            '租金 ${r.rentAmount} 元',
                                        ].join('・'),
                                        style: text.bodySmall?.copyWith(
                                          color: context.colors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // ── 巡田 ──
          const SectionTitle('巡田紀錄'),
          AsyncView(
            inspections,
            builder: (list) {
              if (list.isEmpty) {
                return const EmptyHint('還沒有巡田紀錄。', icon: Icons.photo_camera);
              }
              return Column(
                children: [
                  for (final s in list.take(5))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          leading: Icon(
                            s.status == 'reshoot_required'
                                ? Icons.center_focus_weak
                                : Icons.photo_library,
                            color: s.status == 'reshoot_required'
                                ? context.colors.warning
                                : null,
                          ),
                          title: Text(formatDateTime(s.startedAt)),
                          subtitle: Text(
                            '${inspectionStatusLabels[s.status] ?? s.status}・保留 ${s.keptFrames} 張，略過 ${s.skippedFrames} 次',
                          ),
                          trailing: s.status == 'reshoot_required'
                              ? const Text('需補拍')
                              : const Icon(Icons.chevron_right),
                          onTap: () => _push(
                            context,
                            InspectionSessionScreen(
                              fieldId: field.id,
                              fieldName: field.name,
                              sessionId: s.id,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // ── 紀錄 ──
          const SectionTitle('最近的正式紀錄'),
          AsyncView(
            records,
            builder: (list) {
              if (list.isEmpty) {
                return const EmptyHint('還沒有確認過的紀錄。', icon: Icons.menu_book);
              }
              return Column(
                children: [
                  for (final r in list.take(5))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            '${workTypeLabel(r.record.workType)}・${formatDate(r.record.performedOn)}',
                          ),
                          subtitle: Text(r.record.summary),
                          trailing: StatusChip.pesticide(
                            PesticideStatus.parse(r.record.pesticideStatus),
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
