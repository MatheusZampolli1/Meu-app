import 'package:flutter/material.dart';

class FluxonTheme {
  static const Color accentColor = Color(0xFF4ADE80);
  static const Color secondaryAccent = Color(0xFF22D3EE);
  static const Color backgroundColor = Color(0xFF0D1117);
  static const Color cardColor = Color(0xFF1A1C23);
  static const Color surfaceContainerHighest = Color(0xFF202631);

  static const Duration fastAnimation = Duration(milliseconds: 220);
  static const Duration mediumAnimation = Duration(milliseconds: 420);
  static const Duration longAnimation = Duration(milliseconds: 720);

  static ThemeData build() {
    final baseTheme = ThemeData.dark();
    final textTheme = baseTheme.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );

    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: accentColor,
        secondary: secondaryAccent,
        surface: cardColor,
        surfaceContainerHighest: surfaceContainerHighest,
        onSurface: Colors.white,
        onPrimary: Colors.black,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: textTheme,
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 72,
      ),
      tabBarTheme: baseTheme.tabBarTheme.copyWith(
        indicatorColor: accentColor,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(color: accentColor.withAlpha((0.6 * 255).round())),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      floatingActionButtonTheme: baseTheme.floatingActionButtonTheme.copyWith(
        backgroundColor: secondaryAccent,
        foregroundColor: Colors.black,
        extendedTextStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      cardTheme: baseTheme.cardTheme.copyWith(
        color: cardColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      listTileTheme: baseTheme.listTileTheme.copyWith(
        iconColor: secondaryAccent,
        textColor: Colors.white,
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white12),
        ),
      ),
    );
  }
}

