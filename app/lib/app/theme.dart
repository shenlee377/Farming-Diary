/// 依 docs/DESIGN_SYSTEM.md §4–§6 的 token 建立主題。
///
/// 字級只在這裡定義；元件一律用 Theme.of(context).textTheme，不寫死 fontSize，
/// 由 MediaQuery.textScaler 跟隨系統文字大小（Android 字型大小、iOS Dynamic Type）。
library;

import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color warning;
  final Color danger;
  final Color info;
  final Color neutral;
  final Color textSecondary;

  const AppColors({
    required this.warning,
    required this.danger,
    required this.info,
    required this.neutral,
    required this.textSecondary,
  });

  static const light = AppColors(
    warning: Color(0xFF8A4B12),
    danger: Color(0xFFA3261E),
    info: Color(0xFF1F5C8A),
    neutral: Color(0xFF6B5E4A),
    textSecondary: Color(0xFF4A5544),
  );

  static const dark = AppColors(
    warning: Color(0xFFF0B072),
    danger: Color(0xFFF2A49C),
    info: Color(0xFF9CC8EE),
    neutral: Color(0xFFC9BBA4),
    textSecondary: Color(0xFFB9C2B0),
  );

  @override
  AppColors copyWith({
    Color? warning,
    Color? danger,
    Color? info,
    Color? neutral,
    Color? textSecondary,
  }) => AppColors(
    warning: warning ?? this.warning,
    danger: danger ?? this.danger,
    info: info ?? this.info,
    neutral: neutral ?? this.neutral,
    textSecondary: textSecondary ?? this.textSecondary,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

TextTheme _textTheme(Color text) {
  // DESIGN_SYSTEM §5：display 28 / title 22 / heading 19 / body 17 / label 16 / caption 14
  TextStyle s(double size, double height, FontWeight weight) => TextStyle(
    fontSize: size,
    height: height,
    fontWeight: weight,
    color: text,
  );
  return TextTheme(
    displaySmall: s(28, 1.3, FontWeight.w700),
    headlineSmall: s(22, 1.35, FontWeight.w700),
    titleLarge: s(22, 1.35, FontWeight.w700),
    titleMedium: s(19, 1.4, FontWeight.w600),
    titleSmall: s(17, 1.4, FontWeight.w600),
    bodyLarge: s(17, 1.5, FontWeight.w400),
    bodyMedium: s(17, 1.5, FontWeight.w400),
    bodySmall: s(14, 1.4, FontWeight.w400),
    labelLarge: s(16, 1.4, FontWeight.w600),
    labelMedium: s(14, 1.4, FontWeight.w600),
    labelSmall: s(14, 1.4, FontWeight.w500),
  );
}

ThemeData _build({
  required Brightness brightness,
  required Color surface,
  required Color card,
  required Color text,
  required Color primary,
  required Color onPrimary,
  required Color outline,
  required AppColors colors,
}) {
  final scheme =
      ColorScheme.fromSeed(seedColor: primary, brightness: brightness).copyWith(
        primary: primary,
        onPrimary: onPrimary,
        surface: surface,
        onSurface: text,
        surfaceContainerLowest: card,
        surfaceContainerLow: card,
        outline: outline,
        error: colors.danger,
      );
  final textTheme = _textTheme(text);
  const buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: surface,
    textTheme: textTheme,
    extensions: [colors],
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: text,
      titleTextStyle: textTheme.titleLarge,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: outline),
      ),
    ),
    // 主要按鈕高 56、最小觸控 48（DESIGN_SYSTEM §6）；高度用 minimumSize，字級放大時可長高
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 56),
        shape: buttonShape,
        textStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: buttonShape,
        textStyle: textTheme.labelLarge,
        side: BorderSide(color: primary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        textStyle: textTheme.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: textTheme.labelLarge,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    ),
    chipTheme: ChipThemeData(
      labelStyle: textTheme.labelMedium,
      shape: const StadiumBorder(),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: textTheme.titleSmall,
      subtitleTextStyle: textTheme.bodySmall?.copyWith(
        color: colors.textSecondary,
      ),
      minVerticalPadding: 12,
    ),
  );
}

final lightTheme = _build(
  brightness: Brightness.light,
  surface: const Color(0xFFFAF7F0),
  card: const Color(0xFFFFFFFF),
  text: const Color(0xFF1F2A1C),
  primary: const Color(0xFF2F6B3A),
  onPrimary: const Color(0xFFFFFFFF),
  outline: const Color(0xFFC9C1AE),
  colors: AppColors.light,
);

final darkTheme = _build(
  brightness: Brightness.dark,
  surface: const Color(0xFF121611),
  card: const Color(0xFF1B2119),
  text: const Color(0xFFECE6D8),
  primary: const Color(0xFF8FCB98),
  onPrimary: const Color(0xFF10210F),
  outline: const Color(0xFF3A4436),
  colors: AppColors.dark,
);
