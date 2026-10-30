import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/home/home_shell.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'providers.dart';
import 'theme.dart';

class FarmingDiaryApp extends ConsumerWidget {
  const FarmingDiaryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    return MaterialApp(
      title: '農田日記',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: const Locale('zh', 'TW'),
      supportedLocales: const [Locale('zh', 'TW')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: session.when(
        data: (s) => s == null
            ? const OnboardingScreen()
            : HomeShell(key: ValueKey(s.workspaceId)),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('無法開啟資料：$e'),
            ),
          ),
        ),
      ),
    );
  }
}
