import 'package:flutter/material.dart';

/// Application spacing constants.
///
/// Based on an 8px grid system for consistent spacing.
/// Use these instead of hardcoded spacing values.
///
/// Example:
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(AppSpacing.md),
///   child: ...
/// )
/// ```
class AppSpacing {
  AppSpacing._();

  // ===== Base Unit =====

  /// Base spacing unit (8px).
  static const double unit = 8.0;

  // ===== Spacing Scale =====

  /// Extra extra small spacing (2px).
  static const double xxs = 2.0;

  /// Extra small spacing (4px).
  static const double xs = 4.0;

  /// Small spacing (8px).
  static const double sm = 8.0;

  /// Medium spacing (16px).
  static const double md = 16.0;

  /// Large spacing (24px).
  static const double lg = 24.0;

  /// Extra large spacing (32px).
  static const double xl = 32.0;

  /// Extra extra large spacing (48px).
  static const double xxl = 48.0;

  /// Extra extra extra large spacing (64px).
  static const double xxxl = 64.0;

  // ===== Semantic Spacing =====

  /// Spacing between inline elements.
  static const double inline = xs;

  /// Spacing between stacked elements.
  static const double stack = md;

  /// Spacing for section separation.
  static const double section = xl;

  /// Spacing for page margins.
  static const double page = md;

  /// Spacing for card padding.
  static const double card = md;

  /// Spacing for list items.
  static const double listItem = sm;

  /// Spacing for form fields.
  static const double formField = md;

  /// Spacing for button padding horizontal.
  static const double buttonHorizontal = md;

  /// Spacing for button padding vertical.
  static const double buttonVertical = sm;

  // ===== EdgeInsets Presets =====

  /// Zero padding.
  static const EdgeInsets zero = EdgeInsets.zero;

  /// All sides extra small (4px).
  static const EdgeInsets allXs = EdgeInsets.all(xs);

  /// All sides small (8px).
  static const EdgeInsets allSm = EdgeInsets.all(sm);

  /// All sides medium (16px).
  static const EdgeInsets allMd = EdgeInsets.all(md);

  /// All sides large (24px).
  static const EdgeInsets allLg = EdgeInsets.all(lg);

  /// All sides extra large (32px).
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  /// Horizontal small (8px).
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);

  /// Horizontal medium (16px).
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);

  /// Horizontal large (24px).
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);

  /// Vertical small (8px).
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);

  /// Vertical medium (16px).
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);

  /// Vertical large (24px).
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);

  /// Page padding (horizontal: 16px, vertical: 16px).
  static const EdgeInsets pagePadding = EdgeInsets.all(page);

  /// Card padding (16px).
  static const EdgeInsets cardPadding = EdgeInsets.all(card);

  /// Button padding (horizontal: 16px, vertical: 8px).
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: buttonHorizontal,
    vertical: buttonVertical,
  );

  /// List item padding (horizontal: 16px, vertical: 8px).
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // ===== SizedBox Helpers (Gaps) =====

  /// Horizontal gap - extra small (4px).
  static const SizedBox gapXs = SizedBox(width: xs);

  /// Horizontal gap - small (8px).
  static const SizedBox gapSm = SizedBox(width: sm);

  /// Horizontal gap - medium (16px).
  static const SizedBox gapMd = SizedBox(width: md);

  /// Horizontal gap - large (24px).
  static const SizedBox gapLg = SizedBox(width: lg);

  /// Horizontal gap - extra large (32px).
  static const SizedBox gapXl = SizedBox(width: xl);

  /// Vertical gap - extra small (4px).
  static const SizedBox vGapXs = SizedBox(height: xs);

  /// Vertical gap - small (8px).
  static const SizedBox vGapSm = SizedBox(height: sm);

  /// Vertical gap - medium (16px).
  static const SizedBox vGapMd = SizedBox(height: md);

  /// Vertical gap - large (24px).
  static const SizedBox vGapLg = SizedBox(height: lg);

  /// Vertical gap - extra large (32px).
  static const SizedBox vGapXl = SizedBox(height: xl);

  /// Vertical gap - extra extra large (48px).
  static const SizedBox vGapXxl = SizedBox(height: xxl);

  // ===== Helper Methods =====

  /// Creates a horizontal gap of [width].
  static SizedBox hGap(double width) => SizedBox(width: width);

  /// Creates a vertical gap of [height].
  static SizedBox vGap(double height) => SizedBox(height: height);

  /// Creates an EdgeInsets with all sides equal to [value].
  static EdgeInsets all(double value) => EdgeInsets.all(value);

  /// Creates an EdgeInsets with horizontal and vertical values.
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  /// Creates an EdgeInsets with only specified sides.
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
}
