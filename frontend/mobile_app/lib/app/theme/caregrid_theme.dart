import 'package:flutter/material.dart';
import 'brand_tokens.dart';

/// One Material 3 theme for the entire CareGrid mobile application.
abstract final class CareGridTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: CareGridPalette.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: CareGridPalette.primary,
      onPrimary: Colors.white,
      primaryContainer: CareGridPalette.paleMint,
      onPrimaryContainer: CareGridPalette.primaryDeep,
      secondary: CareGridPalette.gold,
      onSecondary: CareGridPalette.ink,
      secondaryContainer: CareGridPalette.goldTint,
      onSecondaryContainer: CareGridPalette.ink,
      surface: CareGridPalette.surface,
      onSurface: CareGridPalette.ink,
      error: CareGridPalette.danger,
      outline: CareGridPalette.line,
    );

    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: CareGridPalette.line),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: CareGridPalette.canvas,
      splashColor: CareGridPalette.paleMint,
      highlightColor: CareGridPalette.paleMint,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: CareGridPalette.ink, fontSize: 27, fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(color: CareGridPalette.ink, fontSize: 23, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(color: CareGridPalette.ink, fontSize: 20, fontWeight: FontWeight.w800),
        titleMedium: TextStyle(color: CareGridPalette.ink, fontSize: 16, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: CareGridPalette.ink, fontSize: 15),
        bodyMedium: TextStyle(color: CareGridPalette.secondaryText, fontSize: 13, height: 1.45),
        labelLarge: TextStyle(fontWeight: FontWeight.w800),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: CareGridPalette.glassSurface,
        foregroundColor: CareGridPalette.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: CareGridPalette.ink,
          fontWeight: FontWeight.w800,
          letterSpacing: -.35,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 8,
        backgroundColor: CareGridPalette.glassSurface,
        indicatorColor: CareGridPalette.paleMint,
        shadowColor: CareGridPalette.primaryDeep.withValues(alpha: .08),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? CareGridPalette.primary : CareGridPalette.secondaryText,
          size: states.contains(WidgetState.selected) ? 25 : 23,
        )),
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? CareGridPalette.primaryDeep : CareGridPalette.secondaryText,
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w800 : FontWeight.w600,
        )),
      ),
      cardTheme: CardThemeData(
        color: CareGridPalette.glassSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x18075A50),
        elevation: 2,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CareGridLayout.cardRadius),
          side: const BorderSide(color: CareGridPalette.glassBorder),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: CareGridPalette.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CareGridLayout.buttonRadius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: CareGridPalette.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CareGridLayout.buttonRadius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CareGridPalette.primary,
          side: const BorderSide(color: CareGridPalette.mintBorder),
          minimumSize: const Size(0, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CareGridLayout.buttonRadius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CareGridPalette.glassSurface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        hintStyle: const TextStyle(color: CareGridPalette.secondaryText),
        labelStyle: const TextStyle(color: CareGridPalette.secondaryText),
        border: outline,
        enabledBorder: outline,
        focusedBorder: outline.copyWith(
          borderSide: const BorderSide(color: CareGridPalette.primary, width: 1.7),
        ),
        errorBorder: outline.copyWith(
          borderSide: const BorderSide(color: CareGridPalette.danger),
        ),
      ),
      dividerTheme: const DividerThemeData(color: CareGridPalette.line),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: CareGridPalette.primaryDeep,
        contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: CareGridPalette.primary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: CareGridPalette.paleMint,
        side: const BorderSide(color: CareGridPalette.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(color: CareGridPalette.ink, fontWeight: FontWeight.w600),
      ),
    );
  }
}
