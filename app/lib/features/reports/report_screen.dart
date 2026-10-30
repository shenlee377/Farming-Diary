import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../core/db/database.dart';
import '../../core/location.dart';
import '../../core/repository.dart';
import '../../domain/state_machines.dart';

/// 現場回報（長輩最短路徑）：拍照（可略過）→ 送出。其他欄位都可以不填。
///
/// 選既有照片走系統照片選擇器，不需要相簿權限；拍照用系統相機。
class ReportScreen extends ConsumerStatefulWidget {
  final String fieldId;
  final Task? task;

  const ReportScreen({super.key, required this.fieldId, this.task});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final _picker = ImagePicker();
  final _text = TextEditingController();
  final _quantity = TextEditingController();
  final List<NewPhoto> _photos = [];
  PesticideStatus _pesticide = PesticideStatus.unknown;
  bool _sending = false;

  @override
  void dispose() {
    _text.dispose();
    _quantity.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 2560,
      );
      if (file == null) return;
      final location = await currentLocationOrNull();
      setState(
        () => _photos.add(
          NewPhoto(file.path, DateTime.now(), location: location),
        ),
      );
    } catch (e) {
      if (mounted) showMessage(context, '相機無法開啟：$e。請到設定允許相機權限。');
    }
  }

  Future<void> _pickPhotos() async {
    final files = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 2560,
    );
    if (files.isEmpty) return;
    setState(() {
      for (final f in files) {
        _photos.add(NewPhoto(f.path, DateTime.now()));
      }
    });
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    final ok = await runAction(
      context,
      () => ref
          .read(repositoryProvider)
          .submitReport(
            taskId: widget.task?.id,
            fieldId: widget.fieldId,
            rawText: _text.text,
            rawQuantityText: _quantity.text,
            pesticideClaim: _pesticide,
            photos: _photos,
          ),
      success: '已送出，存在手機，等管理者確認',
    );
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? '回報' : '回報：${widget.task!.title}'),
      ),
      body: PageBody(
        children: [
          Text('拍張照片就可以送出，文字都可以不填。', style: text.bodyLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('拍照'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickPhotos,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('選照片'),
                ),
              ),
            ],
          ),
          if (_photos.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_photos[i].sourcePath),
                        width: 112,
                        height: 112,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton.filledTonal(
                        tooltip: '移除這張',
                        onPressed: () => setState(() => _photos.removeAt(i)),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _text,
            minLines: 2,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: '做了什麼、發生什麼事（可不填）',
              helperText: '可以按鍵盤上的麥克風用說的',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quantity,
            decoration: const InputDecoration(
              labelText: '用了什麼資材、多少（照原話寫，可不填）',
              hintText: '例：肥料一包半',
              helperText: '會保留原話，由管理者換算',
            ),
          ),
          const SizedBox(height: 16),
          Text('這次有沒有噴藥？', style: text.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<PesticideStatus>(
            segments: const [
              ButtonSegment(value: PesticideStatus.applied, label: Text('有')),
              ButtonSegment(
                value: PesticideStatus.confirmedNone,
                label: Text('沒有'),
              ),
              ButtonSegment(value: PesticideStatus.unknown, label: Text('不確定')),
            ],
            selected: {_pesticide},
            onSelectionChanged: (s) => setState(() => _pesticide = s.first),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _sending ? null : _send,
            icon: const Icon(Icons.send),
            label: Text(_sending ? '送出中…' : '送出回報'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.phone_android, color: context.colors.neutral),
              const SizedBox(width: 8),
              Expanded(
                child: Text('沒有網路也能送出，資料會先存在手機。', style: text.bodySmall),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
