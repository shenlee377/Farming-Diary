import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart'
    show openAppSettings;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/providers.dart';
import '../../core/db/database.dart';
import '../../core/location.dart';
import '../../core/repository.dart';
import '../../domain/blur.dart';
import '../../domain/geo.dart';
import 'heading_source.dart';

/// 巡田取景畫面（DESIGN_SYSTEM §8）：品質提示、補拍轉向引導、離場前查核全部疊在相機畫面上。
///
/// - 一般巡田：按大按鈕開始，邊走邊自動拍；模糊或太暗的畫面只記方位、不存照片。
/// - 結束時在手機上彙整一次：某個方向都沒有清晰照片 → 列為補拍，畫面內可直接帶去補拍。
/// - 補拍：依羅盤顯示往左／往右轉幾度，對準且清晰才允許按快門。
/// - 字級跟隨系統；快門等觸控元件尺寸固定。
class InspectionCameraScreen extends ConsumerStatefulWidget {
  final String fieldId;
  final String fieldName;

  /// 繼續上一次巡田的補拍。
  final String? resumeSessionId;

  const InspectionCameraScreen({
    super.key,
    required this.fieldId,
    required this.fieldName,
    this.resumeSessionId,
  });

  @override
  ConsumerState<InspectionCameraScreen> createState() =>
      _InspectionCameraScreenState();
}

enum _Sheet { none, leaveCheck, done }

class _InspectionCameraScreenState extends ConsumerState<InspectionCameraScreen>
    with WidgetsBindingObserver {
  static const _autoCaptureInterval = Duration(milliseconds: 1500);
  static const _analysisInterval = Duration(milliseconds: 250);

  late final FarmRepository _repo = ref.read(repositoryProvider);

  CameraController? _camera;
  String? _cameraError;
  bool _cameraPermissionDenied = false;

  StreamSubscription<double>? _headingSub;
  StreamSubscription<GeoPoint>? _locationSub;
  StreamSubscription<List<ReshootTask>>? _reshootSub;
  Timer? _autoTimer;

  double? _heading;
  bool _hasCompass = true;
  GeoPoint? _location;

  DateTime _lastAnalysis = DateTime.fromMillisecondsSinceEpoch(0);
  bool _analysing = false;
  double _blurScore = 0;
  FrameQuality _quality = FrameQuality.sharp;

  String? _sessionId;
  bool _recording = false;
  bool _capturing = false;
  int _kept = 0;
  int _skipped = 0;
  List<ReshootTask> _pendingReshoots = const [];
  String? _activeReshootId;
  _Sheet _sheet = _Sheet.none;
  String? _toast;
  Timer? _toastTimer;

  ReshootTask? get _activeReshoot =>
      _pendingReshoots.where((t) => t.id == _activeReshootId).firstOrNull;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WakelockPlus.enable();
    _sessionId = widget.resumeSessionId;
    if (_sessionId != null) _watchReshoots(_sessionId!);
    _startSensors();
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    WakelockPlus.disable();
    _autoTimer?.cancel();
    _toastTimer?.cancel();
    _headingSub?.cancel();
    _locationSub?.cancel();
    _reshootSub?.cancel();
    _camera?.dispose();
    super.dispose();
  }

  // 依 camera 套件建議：進背景時釋放相機，回前景再初始化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final camera = _camera;
    if (state == AppLifecycleState.inactive) {
      _autoTimer?.cancel();
      if (camera != null) {
        setState(() => _camera = null);
        camera.dispose();
      }
    } else if (state == AppLifecycleState.resumed &&
        _camera == null &&
        !_cameraPermissionDenied) {
      _initCamera();
      if (_recording) _startAutoCapture();
    }
  }

  void _watchReshoots(String sessionId) {
    _reshootSub?.cancel();
    _reshootSub = _repo.watchReshootTasks(sessionId).listen((tasks) {
      if (!mounted) return;
      setState(() {
        _pendingReshoots = tasks.where((t) => t.status == 'pending').toList();
        if (widget.resumeSessionId != null &&
            _activeReshootId == null &&
            _pendingReshoots.isNotEmpty &&
            _sheet == _Sheet.none) {
          _activeReshootId = _pendingReshoots.first.id;
        }
      });
    });
  }

  Future<void> _startSensors() async {
    _headingSub = HeadingSource().stream().listen(
      (h) {
        if (mounted) setState(() => _heading = h);
      },
      onError: (_) {
        if (mounted) setState(() => _hasCompass = false);
      },
    );
    // 定位權限被拒時仍可巡田，只是照片沒有座標
    if (!mounted) return;
    if (await ensureLocation(context, purpose: '記錄照片位置')) {
      _locationSub = positionStream(keepRunningWhenScreenOff: false)
          .listen((p) {
            if (mounted) setState(() => _location = p);
          }, onError: (_) {});
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final back = cameras
          .where((c) => c.lensDirection == CameraLensDirection.back)
          .toList();
      if (back.isEmpty) {
        setState(() => _cameraError = '找不到後鏡頭');
        return;
      }
      final controller = CameraController(
        back.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      await controller.startImageStream(_analyse);
      setState(() {
        _camera = controller;
        _cameraError = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      final denied =
          e.code.contains('AccessDenied') || e.code.contains('permission');
      setState(() {
        _cameraPermissionDenied = denied;
        _cameraError = denied
            ? '需要相機權限才能巡田。請到設定允許「相機」。'
            : '相機無法啟動（${e.code}），請關掉再開一次。';
      });
    }
  }

  /// 手機端模糊快篩：每 250 毫秒取一張預覽影像的亮度平面計算。
  void _analyse(CameraImage image) {
    final now = DateTime.now();
    if (_analysing || now.difference(_lastAnalysis) < _analysisInterval) return;
    _lastAnalysis = now;
    _analysing = true;
    try {
      final y = image.planes.first;
      final score = laplacianVariance(
        y.bytes,
        width: image.width,
        height: image.height,
        rowStride: y.bytesPerRow,
        step: 4,
      );
      final brightness = meanLuma(
        y.bytes,
        width: image.width,
        height: image.height,
        rowStride: y.bytesPerRow,
      );
      if (mounted) {
        setState(() {
          _blurScore = score;
          _quality = classifyFrame(blurScore: score, brightness: brightness);
        });
      }
    } catch (e) {
      debugPrint('frame analysis failed: $e');
    } finally {
      _analysing = false;
    }
  }

  void _showToast(String text) {
    _toastTimer?.cancel();
    setState(() => _toast = text);
    _toastTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  Future<String> _ensureSession() async {
    if (_sessionId != null) return _sessionId!;
    final s = await _repo.startInspection(widget.fieldId);
    _sessionId = s.id;
    _watchReshoots(s.id);
    return s.id;
  }

  void _startAutoCapture() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(_autoCaptureInterval, (_) => _autoTick());
  }

  Future<void> _toggleRecording() async {
    if (_recording) {
      _autoTimer?.cancel();
      setState(() => _recording = false);
      return;
    }
    await _ensureSession();
    setState(() => _recording = true);
    _startAutoCapture();
  }

  Future<void> _autoTick() async {
    final camera = _camera;
    if (!_recording ||
        _activeReshoot != null ||
        _capturing ||
        camera == null ||
        !camera.value.isInitialized) {
      return;
    }
    final sessionId = _sessionId!;
    final quality = _quality;
    final score = _blurScore;
    if (quality != FrameQuality.sharp) {
      await _repo.addInspectionFrame(
        sessionId,
        quality: quality,
        blurScore: score,
        location: _location,
        headingDeg: _heading,
      );
      if (mounted) setState(() => _skipped++);
      return;
    }
    _capturing = true;
    try {
      final photo = await camera.takePicture();
      await _repo.addInspectionFrame(
        sessionId,
        quality: quality,
        blurScore: score,
        photoPath: photo.path,
        location: _location,
        headingDeg: _heading,
      );
      HapticFeedback.lightImpact();
      if (mounted) setState(() => _kept++);
    } on CameraException catch (e) {
      debugPrint('auto capture failed: ${e.code}');
    } finally {
      _capturing = false;
    }
  }

  Future<void> _reshootCapture(ReshootTask task) async {
    final camera = _camera;
    if (camera == null || _capturing) return;
    final heading = _heading;
    if (_hasCompass && heading != null) {
      final g = turnGuidance(heading, task.headingDeg);
      if (!g.aligned) {
        HapticFeedback.heavyImpact();
        _showToast(g.text);
        return;
      }
    }
    if (_quality != FrameQuality.sharp) {
      HapticFeedback.heavyImpact();
      _showToast(_quality.hint);
      return;
    }
    _capturing = true;
    try {
      final photo = await camera.takePicture();
      await _repo.addInspectionFrame(
        task.sessionId,
        quality: FrameQuality.sharp,
        blurScore: _blurScore,
        photoPath: photo.path,
        location: _location,
        headingDeg: heading ?? task.headingDeg,
        reshootTaskId: task.id,
      );
      HapticFeedback.mediumImpact();
      if (mounted) {
        setState(() {
          _kept++;
          _activeReshootId = null;
        });
        _showToast('補拍完成');
      }
    } on CameraException catch (e) {
      _showToast('這張沒拍成功（${e.code}），請再按一次');
    } finally {
      _capturing = false;
    }
  }

  Future<void> _end() async {
    _autoTimer?.cancel();
    setState(() {
      _recording = false;
      _activeReshootId = null;
    });
    final sessionId = _sessionId;
    if (sessionId == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    final pending = await _repo.endInspection(sessionId);
    if (!mounted) return;
    setState(() {
      _pendingReshoots = pending;
      _sheet = pending.isEmpty ? _Sheet.done : _Sheet.leaveCheck;
    });
  }

  // ───────────────────────── 畫面 ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final camera = _camera;
    return PopScope(
      canPop: !_recording,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _end();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (camera != null && camera.value.isInitialized)
              _CoverPreview(camera)
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _cameraError == null
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _cameraError!,
                              textAlign: TextAlign.center,
                              style: text.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_cameraPermissionDenied)
                              FilledButton(
                                onPressed: openAppSettings,
                                child: const Text('到設定開啟相機'),
                              ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                '離開',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _topHud(text),
                    const SizedBox(height: 8),
                    if (_pendingReshoots.isNotEmpty &&
                        _activeReshoot == null &&
                        _sheet == _Sheet.none)
                      _HudButton(
                        color: const Color(0xE67A3E0C),
                        icon: Icons.center_focus_strong,
                        label: '還有 ${_pendingReshoots.length} 處要補拍，點這裡帶你去',
                        onTap: () => setState(() {
                          _recording = false;
                          _autoTimer?.cancel();
                          _activeReshootId = _pendingReshoots.first.id;
                        }),
                      ),
                    const Spacer(),
                    _centerStatus(text),
                    const Spacer(),
                    _bottomBar(text),
                  ],
                ),
              ),
            ),
            if (_sheet != _Sheet.none) _sheetView(text),
          ],
        ),
      ),
    );
  }

  Widget _topHud(TextTheme text) {
    final style = text.bodyLarge?.copyWith(color: Colors.white);
    final acc = _location?.accuracyMeters;
    return _HudPanel(
      child: Wrap(
        spacing: 14,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            widget.fieldName,
            style: text.titleMedium?.copyWith(color: Colors.white),
          ),
          _hudItem(Icons.photo_camera, '已拍 $_kept 張', style),
          _hudItem(
            Icons.my_location,
            acc == null ? '定位中' : '定位 ±${acc.round()} 公尺',
            style,
          ),
          if (_hasCompass && _heading != null)
            _hudItem(
              Icons.explore,
              '${headingToDirection(_heading!)} ${_heading!.round()}°',
              style,
            ),
        ],
      ),
    );
  }

  Widget _hudItem(IconData icon, String label, TextStyle? style) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: const Color(0xFF8FCB98), size: 20),
      const SizedBox(width: 4),
      Text(label, style: style),
    ],
  );

  Widget _centerStatus(TextTheme text) {
    final task = _activeReshoot;
    final children = <Widget>[];
    if (task != null) {
      final heading = _heading;
      final g = (_hasCompass && heading != null)
          ? turnGuidance(heading, task.headingDeg)
          : null;
      final aligned = g?.aligned ?? true;
      children.add(
        _HudPanel(
          color: aligned ? const Color(0xE61E4D2B) : const Color(0xE67A3E0C),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (g != null && !aligned && g.delta < 0)
                    const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                  if (aligned)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 32,
                    ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      g?.text ?? '朝${headingToDirection(task.headingDeg)}方向拍一張',
                      textAlign: TextAlign.center,
                      style: text.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (g != null && !aligned && g.delta > 0)
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 32,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '補拍：${task.description}',
                textAlign: TextAlign.center,
                style: text.bodyLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } else {
      final (msg, color) = !_recording
          ? (
              _sessionId == null ? '按下中間大按鈕開始巡田，邊走邊自動拍' : '已暫停，按大按鈕繼續',
              const Color(0x99000000),
            )
          : _quality == FrameQuality.sharp
          ? ('畫面清晰，持續拍攝中', const Color(0xE61E4D2B))
          : (_quality.hint, const Color(0xE67A3E0C));
      children.add(
        _HudPanel(
          color: color,
          child: Text(
            msg,
            textAlign: TextAlign.center,
            style: text.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
      );
    }
    if (_toast != null) {
      children.add(const SizedBox(height: 8));
      children.add(
        _HudPanel(
          child: Text(
            _toast!,
            textAlign: TextAlign.center,
            style: text.bodyLarge?.copyWith(color: Colors.white),
          ),
        ),
      );
    }
    return Semantics(
      liveRegion: true,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  Widget _bottomBar(TextTheme text) {
    final task = _activeReshoot;
    final label = text.labelLarge?.copyWith(color: Colors.white);
    final heading = _heading;
    final aligned =
        task == null ||
        !_hasCompass ||
        heading == null ||
        turnGuidance(heading, task.headingDeg).aligned;
    final Color shutterColor;
    final IconData shutterIcon;
    final String shutterLabel;
    if (task != null) {
      shutterColor = aligned && _quality == FrameQuality.sharp
          ? const Color(0xFF2F6B3A)
          : Colors.grey;
      shutterIcon = Icons.photo_camera;
      shutterLabel = '補拍這一張';
    } else if (_recording) {
      shutterColor = const Color(0xFFA3261E);
      shutterIcon = Icons.pause;
      shutterLabel = '暫停巡田拍攝';
    } else {
      shutterColor = const Color(0xFF2F6B3A);
      shutterIcon = Icons.play_arrow;
      shutterLabel = _sessionId == null ? '開始巡田拍攝' : '繼續巡田拍攝';
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0x8C000000),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: _sheet == _Sheet.none ? _end : null,
              icon: const Icon(Icons.close, color: Colors.white),
              label: Text('結束', style: label),
            ),
          ),
          Semantics(
            button: true,
            label: shutterLabel,
            child: GestureDetector(
              onTap: _camera == null || _sheet != _Sheet.none
                  ? null
                  : (task != null
                        ? () => _reshootCapture(task)
                        : _toggleRecording),
              // 觸控尺寸固定 84，不隨文字放大
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: shutterColor,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Icon(shutterIcon, color: Colors.white, size: 40),
              ),
            ),
          ),
          Expanded(
            child: task != null
                ? TextButton.icon(
                    onPressed: () => setState(() => _activeReshootId = null),
                    icon: const Icon(Icons.undo, color: Colors.white),
                    label: Text('先不補', style: label),
                  )
                : Text(
                    _recording ? '拍攝中' : '已暫停',
                    textAlign: TextAlign.center,
                    style: label,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _sheetView(TextTheme text) {
    final white = text.bodyLarge?.copyWith(color: Colors.white);
    final List<Widget> content;
    if (_sheet == _Sheet.leaveCheck) {
      content = [
        Text(
          '離開前，還有 ${_pendingReshoots.length} 處需要補拍',
          style: text.titleLarge?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        for (final t in _pendingReshoots)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2F28),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(t.description, style: white),
          ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () => setState(() {
            _sheet = _Sheet.none;
            _activeReshootId = _pendingReshoots.first.id;
          }),
          child: const Text('帶我去補拍'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white54),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('先離開，下次再補'),
        ),
      ];
    } else {
      content = [
        Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF8FCB98), size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '巡田結束，共保留 $_kept 張',
                style: text.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '照片已存在手機，雲端同步開通後會自動上傳並檢查，不用再按其他按鈕。'
          '${_skipped > 0 ? '另有 $_skipped 次模糊或太暗的畫面已自動略過。' : ''}',
          style: white,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('好'),
        ),
      ];
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: Color(0xF2141A13),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// 以「填滿」方式顯示相機預覽（直式）。
class _CoverPreview extends StatelessWidget {
  final CameraController controller;

  const _CoverPreview(this.controller);

  @override
  Widget build(BuildContext context) {
    final size = controller.value.previewSize;
    if (size == null) return CameraPreview(controller);
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: size.height,
          height: size.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

class _HudPanel extends StatelessWidget {
  final Widget child;
  final Color color;

  const _HudPanel({required this.child, this.color = const Color(0x99000000)});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white24),
    ),
    child: child,
  );
}

class _HudButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HudButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: color,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
