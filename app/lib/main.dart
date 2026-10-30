import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/db/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('zh_TW');
  final docs = await getApplicationDocumentsDirectory();
  final db = AppDatabase.open();
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        mediaDirProvider.overrideWithValue(
          Directory(p.join(docs.path, 'media')),
        ),
      ],
      child: const FarmingDiaryApp(),
    ),
  );
}
