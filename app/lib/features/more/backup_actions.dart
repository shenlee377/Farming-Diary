import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../app/widgets.dart';
import '../../core/backup.dart';

/// 匯出整個農場（資料＋照片）為一個 zip，交給系統分享（存到雲端硬碟、傳 LINE 給自己等）。
Future<void> exportBackup(BuildContext context, WidgetRef ref) async {
  await runAction(context, () async {
    final file = await createBackup(
      ref.read(repositoryProvider),
      await getTemporaryDirectory(),
    );
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/zip')],
        subject: '農田日記備份',
      ),
    );
  });
}

/// 選擇備份 zip 並還原成這支手機上的一個農場。
Future<void> pickAndRestore(
  BuildContext context,
  WidgetRef ref, {
  String? displayName,
}) async {
  final file = await openFile(
    acceptedTypeGroups: const [
      XTypeGroup(
        label: '農田日記備份',
        extensions: ['zip'],
        mimeTypes: ['application/zip'],
        uniformTypeIdentifiers: ['public.zip-archive'],
      ),
    ],
  );
  if (file == null || !context.mounted) return;
  try {
    final result = await ref
        .read(sessionProvider.notifier)
        .restore(file.path, displayName: displayName);
    if (context.mounted) {
      showMessage(
        context,
        '已還原「${result.workspace.name}」：${result.rows} 筆資料、${result.photos} 張照片',
      );
    }
  } on RestoreException catch (e) {
    if (context.mounted) showMessage(context, e.message);
  } catch (e) {
    if (context.mounted) showMessage(context, '還原失敗：$e');
  }
}
