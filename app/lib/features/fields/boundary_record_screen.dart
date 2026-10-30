import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../core/location.dart';
import '../../core/repository.dart';
import '../../domain/geo.dart';
import 'boundary_preview.dart';

/// 沿田邊走一圈記錄田界。軌跡點即時寫入資料庫，螢幕關閉或 App 被暫停也不會遺失；
/// 完成後存成「草稿」，使用者確認才更新田區面積。
class BoundaryRecordScreen extends ConsumerStatefulWidget {
  final String fieldId;
  final String fieldName;

  const BoundaryRecordScreen({
    super.key,
    required this.fieldId,
    required this.fieldName,
  });

  @override
  ConsumerState<BoundaryRecordScreen> createState() =>
      _BoundaryRecordScreenState();
}

class _BoundaryRecordScreenState extends ConsumerState<BoundaryRecordScreen> {
  final String _trackId = newId();
  StreamSubscription<GeoPoint>? _sub;
  GeoPoint? _lastKept;
  GeoPoint? _latest;
  bool _keepWhenScreenOff = true;
  bool _recording = false;
  bool _saving = false;

  late final FarmRepository _repo = ref.read(repositoryProvider);
  late final Stream<List<GeoPoint>> _track = _repo.watchTrack(_trackId);

  @override
  void dispose() {
    _sub?.cancel();
    WakelockPlus.disable();
    _repo.clearTrack(_trackId);
    super.dispose();
  }

  Future<void> _start() async {
    if (!await ensureLocation(context, purpose: '記錄田界')) return;
    if (_keepWhenScreenOff) await requestNotificationPermissionIfNeeded();
    if (!_keepWhenScreenOff) await WakelockPlus.enable();
    _sub = positionStream(keepRunningWhenScreenOff: _keepWhenScreenOff).listen(
      (point) async {
        setState(() => _latest = point);
        if (shouldKeepTrackPoint(_lastKept, point)) {
          _lastKept = point;
          await _repo.addTrackPoint(_trackId, point);
        }
      },
      onError: (Object e) {
        if (mounted) showMessage(context, '定位中斷：$e');
        _stop();
      },
    );
    setState(() => _recording = true);
  }

  Future<void> _stop() async {
    await _sub?.cancel();
    _sub = null;
    await WakelockPlus.disable();
    if (mounted) setState(() => _recording = false);
  }

  /// 在目前位置標一個角點（不受最小距離限制），適合只走到四個角。
  Future<void> _markCorner() async {
    final p = _latest ?? await currentLocationOrNull();
    if (p == null) {
      if (mounted) showMessage(context, '還沒有取得位置，請稍等');
      return;
    }
    _lastKept = p;
    await _repo.addTrackPoint(_trackId, p);
    if (mounted) showMessage(context, '已標記角點');
  }

  Future<void> _save(List<GeoPoint> points) async {
    setState(() => _saving = true);
    await _stop();
    if (!mounted) return;
    final ok = await runAction(
      context,
      () => _repo.saveBoundaryDraft(widget.fieldId, points),
      success: '已存成田界草稿，請在田區頁確認',
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) Navigator.of(context).pop();
  }

  Future<bool> _confirmLeave(int pointCount) async {
    if (pointCount == 0) return true;
    return confirmDialog(
      context,
      title: '放棄這次記錄？',
      body: '已記錄 $pointCount 個點，離開後不會保存。',
      confirmLabel: '放棄',
      danger: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return StreamBuilder<List<GeoPoint>>(
      stream: _track,
      builder: (context, snapshot) {
        final points = snapshot.data ?? const <GeoPoint>[];
        final area = polygonAreaSquareMeters(points);
        final acc = _latest?.accuracyMeters;
        return PopScope(
          canPop: points.isEmpty,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            if (await _confirmLeave(points.length) && context.mounted) {
              await _stop();
              if (context.mounted) Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(title: Text('記錄田界：${widget.fieldName}')),
            body: PageBody(
              children: [
                Text(
                  '拿著手機沿著田邊走一圈，回到起點後按「完成」。只走到四個角也可以：每到一個角按「在這裡標一個角」。',
                  style: text.bodyLarge,
                ),
                const SizedBox(height: 12),
                BoundaryPreview(points, closed: !_recording, height: 220),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusChip(
                      '已記錄 ${points.length} 個點',
                      tone: Tone.info,
                      icon: Icons.timeline,
                    ),
                    if (acc != null)
                      StatusChip(
                        '定位誤差約 ±${acc.round()} 公尺',
                        tone: acc <= 5
                            ? Tone.ok
                            : (acc <= 15 ? Tone.warning : Tone.danger),
                        icon: Icons.my_location,
                      ),
                    if (points.length >= 3)
                      StatusChip(
                        '估計 ${formatArea(area)}',
                        tone: Tone.neutral,
                        icon: Icons.square_foot,
                      ),
                  ],
                ),
                if (acc != null && acc > 15) ...[
                  const SizedBox(height: 8),
                  Text(
                    '現在定位不準（誤差大於 15 公尺的點會略過）。請到空曠處稍等一下。',
                    style: text.bodyMedium?.copyWith(
                      color: context.colors.danger,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _keepWhenScreenOff,
                  onChanged: _recording
                      ? null
                      : (v) => setState(() => _keepWhenScreenOff = v),
                  title: const Text('螢幕關閉也繼續記錄'),
                  subtitle: const Text('記錄期間通知列會顯示「正在記錄田界」；關閉時改為保持螢幕常亮。'),
                ),
                const SizedBox(height: 12),
                if (!_recording)
                  FilledButton.icon(
                    onPressed: _saving ? null : _start,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(points.isEmpty ? '開始記錄' : '繼續記錄'),
                  )
                else ...[
                  OutlinedButton.icon(
                    onPressed: _markCorner,
                    icon: const Icon(Icons.place),
                    label: const Text('在這裡標一個角'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _stop,
                    icon: const Icon(Icons.pause),
                    label: const Text('暫停'),
                  ),
                ],
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: points.length >= 3 && !_saving
                      ? () => _save(points)
                      : null,
                  icon: const Icon(Icons.check),
                  label: Text(
                    points.length >= 3 ? '完成，存成田界草稿' : '至少需要 3 個點才能完成',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '面積是手機用球面公式估算，誤差取決於定位精度；正式面積之後由伺服器計算並標示方法。',
                  style: text.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
