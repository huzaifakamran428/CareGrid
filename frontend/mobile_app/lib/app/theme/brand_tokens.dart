import 'package:flutter/material.dart';

/// CareGrid visual identity — inspired by the emerald + gold CG heart mark.
///
/// Use these tokens instead of hard-coded colors in feature screens. Semantic
/// colors (danger / information) are intentionally distinct for accessibility.
abstract final class CareGridPalette {
  static const primary = Color(0xFF087C69);
  static const primaryDeep = Color(0xFF075A50);
  static const primaryBright = Color(0xFF31AD96);
  static const primaryBorder = Color(0xFF70BFAF);
  static const gold = Color(0xFFE3A33B);
  static const goldDeep = Color(0xFFAD751D);
  static const goldTint = Color(0xFFFFF4E2);
  static const ink = Color(0xFF173D37);
  static const secondaryText = Color(0xFF58746D);
  static const canvas = Color(0xFFF7FAF8);
  static const surface = Colors.white;
  static const paleMint = Color(0xFFE5F5EE);
  static const mintBorder = Color(0xFFB2DFCE);
  static const line = Color(0xFFDAE8E1);
  static const paleNeutral = Color(0xFFF0F6F2);
  static const danger = Color(0xFFBC4751);
  static const dangerTint = Color(0xFFFFECEE);
  static const dangerBorder = Color(0xFFE5A1A7);
  static const info = Color(0xFF407C9F);
  static const infoTint = Color(0xFFEAF3FC);

  static const headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDeep, primary, Color(0xFF168D78)],
  );
}

/// Brand-level metrics shared by all the beneficiary feature modules.
abstract final class CareGridLayout {
  static const double cardRadius = 18;
  static const double sheetRadius = 28;
  static const double buttonRadius = 14;
  static const double horizontalPadding = 18;

  static const cardShadow = BoxShadow(
    color: Color(0x0D075A50),
    blurRadius: 18,
    offset: Offset(0, 7),
  );
}
