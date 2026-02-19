import 'package:flutter/material.dart';

/// Application border radius constants.
///
/// Use these instead of hardcoded border radius values.
///
/// Example:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: AppRadius.md,
///   ),
/// )
/// ```
class AppRadius {
  AppRadius._();

  // ===== Radius Values =====

  /// No radius (0px).
  static const double none = 0.0;

  /// Extra small radius (4px).
  static const double xs = 4.0;

  /// Small radius (8px).
  static const double sm = 8.0;

  /// Medium radius (12px).
  static const double md = 12.0;

  /// Large radius (16px).
  static const double lg = 16.0;

  /// Extra large radius (24px).
  static const double xl = 24.0;

  /// Extra extra large radius (32px).
  static const double xxl = 32.0;

  /// Full/circular radius.
  static const double full = 9999.0;

  // ===== BorderRadius Presets =====

  /// No border radius.
  static const BorderRadius zero = BorderRadius.zero;

  /// Extra small border radius (4px).
  static const BorderRadius roundedXs = BorderRadius.all(Radius.circular(xs));

  /// Small border radius (8px).
  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(sm));

  /// Medium border radius (12px).
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(md));

  /// Large border radius (16px).
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(lg));

  /// Extra large border radius (24px).
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(xl));

  /// Extra extra large border radius (32px).
  static const BorderRadius roundedXxl = BorderRadius.all(Radius.circular(xxl));

  /// Full/circular border radius.
  static const BorderRadius roundedFull =
      BorderRadius.all(Radius.circular(full));

  // ===== Semantic BorderRadius =====

  /// Border radius for buttons.
  static const BorderRadius button = roundedSm;

  /// Border radius for cards.
  static const BorderRadius card = roundedMd;

  /// Border radius for dialogs.
  static const BorderRadius dialog = roundedLg;

  /// Border radius for bottom sheets.
  static const BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  /// Border radius for text fields.
  static const BorderRadius textField = roundedSm;

  /// Border radius for chips.
  static const BorderRadius chip = roundedFull;

  /// Border radius for avatars.
  static const BorderRadius avatar = roundedFull;

  /// Border radius for images.
  static const BorderRadius image = roundedMd;

  // ===== Directional BorderRadius =====

  /// Top corners only (medium).
  static const BorderRadius topMd = BorderRadius.only(
    topLeft: Radius.circular(md),
    topRight: Radius.circular(md),
  );

  /// Bottom corners only (medium).
  static const BorderRadius bottomMd = BorderRadius.only(
    bottomLeft: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );

  /// Left corners only (medium).
  static const BorderRadius leftMd = BorderRadius.only(
    topLeft: Radius.circular(md),
    bottomLeft: Radius.circular(md),
  );

  /// Right corners only (medium).
  static const BorderRadius rightMd = BorderRadius.only(
    topRight: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );

  // ===== Helper Methods =====

  /// Creates a circular border radius with [radius].
  static BorderRadius circular(double radius) {
    return BorderRadius.circular(radius);
  }

  /// Creates a border radius with different values for each corner.
  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  /// Creates a border radius for top corners only.
  static BorderRadius top(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );
  }

  /// Creates a border radius for bottom corners only.
  static BorderRadius bottom(double radius) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }
}
