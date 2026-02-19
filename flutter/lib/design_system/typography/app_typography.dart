import 'package:flutter/material.dart';

/// Application typography styles.
///
/// Based on Material Design 3 type scale with customizations.
/// Use these instead of hardcoded text styles.
///
/// Example:
/// ```dart
/// Text(
///   'Hello',
///   style: AppTypography.headlineLarge,
/// )
/// ```
class AppTypography {
  AppTypography._();

  // ===== Font Family =====

  /// Primary font family.
  static const String fontFamily = 'Roboto';

  /// Secondary font family (for headings, branding).
  static const String fontFamilySecondary = 'Roboto';

  /// Monospace font family (for code).
  static const String fontFamilyMono = 'RobotoMono';

  // ===== Font Weights =====

  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // ===== Display Styles =====

  /// Display Large - 57px.
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: regular,
    letterSpacing: -0.25,
    height: 1.12,
    fontFamily: fontFamily,
  );

  /// Display Medium - 45px.
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.16,
    fontFamily: fontFamily,
  );

  /// Display Small - 36px.
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.22,
    fontFamily: fontFamily,
  );

  // ===== Headline Styles =====

  /// Headline Large - 32px.
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.25,
    fontFamily: fontFamily,
  );

  /// Headline Medium - 28px.
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.29,
    fontFamily: fontFamily,
  );

  /// Headline Small - 24px.
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.33,
    fontFamily: fontFamily,
  );

  // ===== Title Styles =====

  /// Title Large - 22px.
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.27,
    fontFamily: fontFamily,
  );

  /// Title Medium - 16px.
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    letterSpacing: 0.15,
    height: 1.5,
    fontFamily: fontFamily,
  );

  /// Title Small - 14px.
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
    fontFamily: fontFamily,
  );

  // ===== Body Styles =====

  /// Body Large - 16px.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: 0.5,
    height: 1.5,
    fontFamily: fontFamily,
  );

  /// Body Medium - 14px.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0.25,
    height: 1.43,
    fontFamily: fontFamily,
  );

  /// Body Small - 12px.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
    fontFamily: fontFamily,
  );

  // ===== Label Styles =====

  /// Label Large - 14px.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
    fontFamily: fontFamily,
  );

  /// Label Medium - 12px.
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.33,
    fontFamily: fontFamily,
  );

  /// Label Small - 11px.
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.45,
    fontFamily: fontFamily,
  );

  // ===== Custom Styles =====

  /// Button text style.
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 1.25,
    height: 1.43,
    fontFamily: fontFamily,
  );

  /// Caption text style.
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
    fontFamily: fontFamily,
  );

  /// Overline text style.
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: medium,
    letterSpacing: 1.5,
    height: 1.6,
    fontFamily: fontFamily,
  );

  /// Code/monospace text style.
  static const TextStyle code = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.43,
    fontFamily: fontFamilyMono,
  );

  // ===== TextTheme =====

  /// Creates a [TextTheme] with the app typography.
  static TextTheme get textTheme => const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );

  // ===== Helper Methods =====

  /// Applies a color to a text style.
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Applies a weight to a text style.
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Makes a text style bold.
  static TextStyle toBold(TextStyle style) {
    return style.copyWith(fontWeight: bold);
  }

  /// Makes a text style italic.
  static TextStyle toItalic(TextStyle style) {
    return style.copyWith(fontStyle: FontStyle.italic);
  }
}
