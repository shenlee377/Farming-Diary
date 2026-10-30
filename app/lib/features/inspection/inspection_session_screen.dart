import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../core/db/database.dart';
import '../../domain/geo.dart';
import '../../domain/labels.dart';
import 'inspection_camera_screen.dart';

final _sessionProvider = StreamProvider.autoDispose
    .family<InspectionSession?, (String, String)>(
      (ref, key) => ref
          .watch(repositoryProvider)
          .watchInspections(key.$1)
          .map((list) => list.where((s) => s.id == key.$2).firstOrNull),
    );
final _photosProvider = StreamProvider.autoDispose
    .family<List<MediaAsset>, String>(
      (ref, id) => ref.watch(repositoryProvider).watchMedia('inspection', id),
    );
final _reshootProvider = StreamProvider.autoDispose
    .family<List<ReshootTask>, String>(
      (ref, id) => ref.watch(repositoryProvider).watchReshootTasks(id),
    );

/// 一次巡田的成果：照片、補拍清單，可繼續補拍。
class InspectionSessionScreen extends ConsumerWidget {
  final String fieldId;
  final String fieldName;
  final String sessionId;

  const InspectionSessionScreen({
    super.key,
    required this.fieldId,
    required this.fieldName,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(_sessionProvider((fieldId, sessionId)));
    final photos = ref.watch(_photosProvider(sessionId));
    final reshoots = ref.watch(_reshootProvider(sessionId));
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('巡田：$fieldName')),
      body: AsyncView(
        session,
        builder: (s) {
          if (s == null) return const Center(child: Text('找不到這次巡田'));
          final pending =
              reshoots.value?.where((r) => r.status == 'pending').toList() ??
              const [];
          return PageBody(
            children: [
              Text(formatDateTime(s.startedAt), style: text.titleMedium),
              Text(
                inspectionStatusLabels[s.status] ?? s.status,
                style: text.bodyLarge,
              ),
              Text(
                '保留 ${s.keptFrames} 張，略過 ${s.skippedFrames} 次模糊或太暗的畫面',
                style: text.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              if (pending.isNotEmpty) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => InspectionCameraScreen(
                        fieldId: fieldId,
                        fieldName: fieldName,
                        resumeSessionId: sessionId,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.center_focus_strong),
                  label: Text('去補拍（${pending.length} 處）'),
                ),
              ],
              AsyncView(
                reshoots,
                builder: (list) {
                  if (list.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SectionTitle('補拍清單'),
                      for (final r in list)
                        Card(
                          child: ListTile(
                            leading: Icon(
                              r.status == 'pending'
                                  ? Icons.center_focus_weak
                                  : Icons.check_circle,
                              color: r.status == 'pending'
                                  ? context.colors.warning
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(r.description),
                            subtitle: Text(switch (r.status) {
                              'pending' =>
                                '待補拍・朝${headingToDirection(r.headingDeg)}',
                              'resolved' => '已補拍',
                              _ => '已略過',
                            }),
                            trailing: r.status == 'pending'
                                ? TextButton(
                                    onPressed: () => runAction(
                                      context,
                                      () => ref
                                          .read(repositoryProvider)
                                          .dismissReshoot(r),
                                    ),
                                    child: const Text('不用補'),
                                  )
                                : null,
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SectionTitle('照片'),
              AsyncView(
                photos,
                builder: (list) {
                  if (list.isEmpty) {
                    return const EmptyHint('這次沒有保留照片。', icon: Icons.photo);
                  }
                  return GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final m in list)
                        GestureDetector(
                          onTap: () => showDialog<void>(
                            context: context,
                            builder: (_) => Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InteractiveViewer(
                                    child: Image.file(File(m.localPath)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      [
                                        formatDateTime(m.capturedAt),
                                        if (m.headingDeg != null)
                                          '朝${headingToDirection(m.headingDeg!)} ${m.headingDeg!.round()}°',
                                        if (m.accuracyM != null)
                                          '定位 ±${m.accuracyM!.round()} 公尺',
                                      ].join('・'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: Image.file(
                            File(m.localPath),
                            fit: BoxFit.cover,
                            cacheWidth: 360,
                            semanticLabel:
                                '巡田照片 ${formatDateTime(m.capturedAt)}',
                            errorBuilder: (_, _, _) => const ColoredBox(
                              color: Colors.black12,
                              child: Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
