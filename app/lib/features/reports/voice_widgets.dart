import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../app/theme.dart';
import '../../app/widgets.dart';

/// 按住說話：按下開始錄音，放開結束；錄好的檔案交給 [onRecorded]。
/// 太短（不到 1 秒）視為誤觸，不保存。最長 3 分鐘。
class HoldToTalkButton extends StatefulWidget {
  final void Function(String path, Duration length) onRecorded;

  const HoldToTalkButton({super.key, required this.onRecorded});

  @override
  State<HoldToTalkButton> createState() => _HoldToTalkButtonState();
}

class _HoldToTalkButtonState extends State<HoldToTalkButton> {
  static const _maxLength = Duration(minutes: 3);

  final _recorder = AudioRecorder();
  DateTime? _startedAt;
  Timer? _ticker;
  String? _path;

  bool get _recording => _startedAt != null;

  @override
  void dispose() {
    _ticker?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (!await _recorder.hasPermission()) {
      if (mounted) showMessage(context, '需要麥克風權限才能錄音，請到設定允許「麥克風」。');
      return;
    }
    final dir = await getTemporaryDirectory();
    _path = p.join(
      dir.path,
      'voice-${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
    await _recorder.start(
      const RecordConfig(numChannels: 1, bitRate: 64000),
      path: _path!,
    );
    HapticFeedback.mediumImpact();
    setState(() => _startedAt = DateTime.now());
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      if (DateTime.now().difference(_startedAt!) >= _maxLength) {
        _stop();
      } else {
        setState(() {});
      }
    });
  }

  Future<void> _stop() async {
    final started = _startedAt;
    if (started == null) return;
    _ticker?.cancel();
    setState(() => _startedAt = null);
    final path = await _recorder.stop();
    final length = DateTime.now().difference(started);
    HapticFeedback.lightImpact();
    if (path == null) return;
    if (length < const Duration(seconds: 1)) {
      File(path).deleteSync();
      if (mounted) showMessage(context, '要按住不放才會錄音，說完再放開');
      return;
    }
    widget.onRecorded(path, length);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final elapsed = _recording
        ? DateTime.now().difference(_startedAt!)
        : Duration.zero;
    return Semantics(
      button: true,
      label: _recording ? '錄音中，放開結束' : '按住說話',
      child: GestureDetector(
        onLongPressStart: (_) => _start(),
        onLongPressEnd: (_) => _stop(),
        onLongPressCancel: _stop,
        onTap: () => showMessage(context, '請按住不放再說話，說完放開'),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _recording ? context.colors.danger : scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _recording ? context.colors.danger : scheme.primary,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _recording ? Icons.mic : Icons.mic_none,
                color: _recording ? Colors.white : scheme.primary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _recording ? '錄音中 ${elapsed.inSeconds} 秒，放開結束' : '按住說話',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _recording ? Colors.white : scheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 語音片段：播放／停止，可選擇刪除。
class VoiceClipTile extends StatefulWidget {
  final String path;
  final String label;
  final VoidCallback? onDelete;

  const VoiceClipTile({
    super.key,
    required this.path,
    required this.label,
    this.onDelete,
  });

  @override
  State<VoiceClipTile> createState() => _VoiceClipTileState();
}

class _VoiceClipTileState extends State<VoiceClipTile> {
  final _player = AudioPlayer();
  bool _playing = false;
  StreamSubscription<void>? _done;

  @override
  void initState() {
    super.initState();
    _done = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playing = false);
    });
  }

  @override
  void dispose() {
    _done?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _player.stop();
      setState(() => _playing = false);
    } else {
      await _player.play(DeviceFileSource(widget.path));
      setState(() => _playing = true);
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: IconButton(
        tooltip: _playing ? '停止' : '播放',
        icon: Icon(_playing ? Icons.stop_circle : Icons.play_circle),
        iconSize: 36,
        onPressed: _toggle,
      ),
      title: Text(widget.label),
      trailing: widget.onDelete == null
          ? null
          : IconButton(
              tooltip: '刪除這段',
              icon: const Icon(Icons.delete_outline),
              onPressed: widget.onDelete,
            ),
    ),
  );
}
