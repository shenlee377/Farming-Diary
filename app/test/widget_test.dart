import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:farming_diary/app/app.dart';
import 'package:farming_diary/app/providers.dart';
import 'package:farming_diary/core/db/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// 以真實畫面＋記憶體資料庫走一次主要流程；同時在系統字級 100% 與 200% 下檢查沒有版面溢出。
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  setUpAll(() => initializeDateFormatting('zh_TW'));

  for (final scale in [1.0, 2.0]) {
    testWidgets('第一次使用 → 建立田區 → 新增工作 → 回報（字級 ${(scale * 100).round()}%）', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.75;
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      final db = AppDatabase(NativeDatabase.memory());
      final mediaDir = Directory.systemTemp.createTempSync('fd_widget');
      addTearDown(() => mediaDir.deleteSync(recursive: true));

      Future<void> settle() async {
        for (var i = 0; i < 8; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 20)),
          );
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            mediaDirProvider.overrideWithValue(mediaDir),
          ],
          child: const FarmingDiaryApp(),
        ),
      );
      await settle();

      // 第一次使用
      expect(find.text('開始使用'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextFormField, '你的稱呼（必填）'),
        '阿明',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '農場名稱（必填）'),
        '林家田',
      );
      await tester.tap(find.text('開始使用'));
      await settle();
      expect(find.text('林家田'), findsWidgets);
      expect(find.textContaining('阿明，'), findsOneWidget);

      // 新增田區
      await tester.tap(find.text('田區').last);
      await settle();
      await tester.tap(find.text('新增田區'));
      await settle();
      await tester.enterText(
        find.widgetWithText(TextFormField, '田區名稱（必填）'),
        '北田',
      );
      await tester.ensureVisible(find.text('建立田區'));
      await tester.tap(find.text('建立田區'));
      await settle();
      expect(find.text('北田'), findsWidgets);

      // 田區詳細頁
      await tester.tap(find.text('北田').hitTestable().first);
      await settle();
      expect(find.text('開始巡田'), findsOneWidget);
      expect(find.text('施藥：尚未確認'), findsOneWidget);
      await tester.tap(find.byType(BackButton).hitTestable());
      await settle();

      // 新增工作
      await tester.tap(find.text('工作').last);
      await settle();
      await tester.tap(find.text('新增工作'));
      await settle();
      await tester.tap(find.byType(DropdownButtonFormField<String>).first);
      await settle();
      await tester.tap(find.text('北田').last);
      await settle();
      await tester.ensureVisible(find.text('建立工作'));
      await tester.tap(find.text('建立工作'));
      await settle();
      expect(find.text('除草'), findsWidgets);
      expect(find.text('草稿'), findsOneWidget);

      // 草稿 → 直接回報
      await tester.tap(find.text('除草').hitTestable().first);
      await settle();
      expect(find.text('排定時間'), findsOneWidget);
      await tester.tap(find.byType(BackButton).hitTestable());
      await settle();

      // 更多：同步狀態與匯出
      await tester.tap(find.text('更多').last);
      await settle();
      expect(find.text('雲端同步尚未開通'), findsOneWidget);
      expect(find.text('匯出備份（資料＋照片）'), findsOneWidget);
      expect(find.text('從備份還原'), findsOneWidget);

      expect(tester.takeException(), isNull);

      // 先卸下畫面（停止資料流），再關資料庫
      await tester.pumpWidget(const SizedBox());
      await settle();
      await tester.runAsync(db.close);
    });
  }
}
