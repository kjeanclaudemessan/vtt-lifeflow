import 'package:flutter/material.dart';

/// Application color palette.
///
/// Contains all colors used throughout the app.
/// Use these instead of hardcoded colors.
///
/// Example:
/// ```dart
/// Container(
///   color: AppColors.primary,
/// )
/// ```
class AppColors {
  AppColors._();

  // ===== Brand Colors =====

  /// Primary brand color.
  static const Color primary = Color(0xFF6200EE);

  /// Primary color variants.
  static const Color primaryLight = Color(0xFF9D46FF);
  static const Color primaryDark = Color(0xFF0000BA);

  /// Secondary brand color.
  static const Color secondary = Color(0xFF03DAC6);

  /// Secondary color variants.
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF00A896);

  /// Tertiary accent color.
  static const Color tertiary = Color(0xFFFF6B6B);

  // ===== Neutral Colors =====

  /// Pure white.
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black.
  static const Color black = Color(0xFF000000);

  /// Grey scale.
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Neutral aliases (for semantic usage)
  static const Color neutral100 = grey100;
  static const Color neutral200 = grey200;
  static const Color neutral300 = grey300;
  static const Color neutral400 = grey400;
  static const Color neutral500 = grey500;
  static const Color neutral600 = grey600;
  static const Color neutral700 = grey700;
  static const Color neutral800 = grey800;

  // ===== Semantic Colors =====

  /// Success color (green).
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color successDark = Color(0xFF2E7D32);

  /// Warning color (orange/amber).
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color warningDark = Color(0xFFE65100);

  /// Error color (red).
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFFC62828);

  /// Info color (blue).
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color infoDark = Color(0xFF1565C0);

  // ===== Background Colors =====

  /// Light theme background.
  static const Color backgroundLight = Color(0xFFFAFAFA);

  /// Dark theme background.
  static const Color backgroundDark = Color(0xFF121212);

  /// Light theme surface.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Dark theme surface.
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Light theme card color.
  static const Color cardLight = Color(0xFFFFFFFF);

  /// Dark theme card color.
  static const Color cardDark = Color(0xFF2C2C2C);

  // ===== Text Colors =====

  /// Primary text on light background.
  static const Color textPrimaryLight = Color(0xFF212121);

  /// Secondary text on light background.
  static const Color textSecondaryLight = Color(0xFF757575);

  /// Disabled text on light background.
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  /// Primary text on dark background.
  static const Color textPrimaryDark = Color(0xFFFFFFFF);

  /// Secondary text on dark background.
  static const Color textSecondaryDark = Color(0xFFB3B3B3);

  /// Disabled text on dark background.
  static const Color textDisabledDark = Color(0xFF666666);

  // ===== Border Colors =====

  /// Light theme border color.
  static const Color borderLight = Color(0xFFE0E0E0);

  /// Dark theme border color.
  static const Color borderDark = Color(0xFF424242);

  /// Divider color for light theme.
  static const Color dividerLight = Color(0xFFE0E0E0);

  /// Divider color for dark theme.
  static const Color dividerDark = Color(0xFF424242);

  // ===== Overlay Colors =====

  /// Black overlay (for scrim, shadows).
  static const Color overlayBlack = Color(0x80000000);

  /// White overlay.
  static const Color overlayWhite = Color(0x80FFFFFF);

  /// Modal barrier color.
  static const Color barrier = Color(0x80000000);

  // ===== Gradient Colors =====

  /// Primary gradient.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  /// Secondary gradient.
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  /// Dark gradient for overlay.
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, overlayBlack],
  );

  // ===== Material Color Swatches =====

  /// Primary color as MaterialColor.
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF6200EE,
    <int, Color>{
      50: Color(0xFFEDE7F6),
      100: Color(0xFFD1C4E9),
      200: Color(0xFFB39DDB),
      300: Color(0xFF9575CD),
      400: Color(0xFF7E57C2),
      500: Color(0xFF6200EE),
      600: Color(0xFF5E35B1),
      700: Color(0xFF512DA8),
      800: Color(0xFF4527A0),
      900: Color(0xFF311B92),
    },
  );

  // ===== Helper Methods =====

  /// Returns the appropriate text color for a background.
  static Color textOnColor(Color background) {
    return background.computeLuminance() > 0.5
        ? textPrimaryLight
        : textPrimaryDark;
  }

  /// Returns a color with modified opacity.
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Darkens a color by [percent] (0-100).
  static Color darken(Color color, [int percent = 10]) {
    assert(percent >= 0 && percent <= 100);
    final factor = 1 - percent / 100;
    final alpha = (color.a * 255).round().clamp(0, 255);
    final red = (color.r * 255).round().clamp(0, 255);
    final green = (color.g * 255).round().clamp(0, 255);
    final blue = (color.b * 255).round().clamp(0, 255);
    return Color.fromARGB(
      alpha,
      (red * factor).round(),
      (green * factor).round(),
      (blue * factor).round(),
    );
  }

  /// Lightens a color by [percent] (0-100).
  static Color lighten(Color color, [int percent = 10]) {
    assert(percent >= 0 && percent <= 100);
    final factor = percent / 100;
    final alpha = (color.a * 255).round().clamp(0, 255);
    final red = (color.r * 255).round().clamp(0, 255);
    final green = (color.g * 255).round().clamp(0, 255);
    final blue = (color.b * 255).round().clamp(0, 255);
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * factor).round(),
      green + ((255 - green) * factor).round(),
      blue + ((255 - blue) * factor).round(),
    );
  }
}
