import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ============================================================================
/// VTT DESIGN SYSTEM - BORDER RADIUS
/// Inspired by Porsche Design System
/// Clean, refined corner treatments
/// ============================================================================

/// Border radius tokens inspired by Porsche Design System.
///
/// Design principles:
/// - Small radius for clean, refined look (Porsche default: 4px)
/// - Consistent radius across similar components
/// - Slightly larger radius for larger components
abstract final class AppRadius {
  // ═══════════════════════════════════════════════════════════════════════════
  // BASE RADIUS VALUES (double) - Porsche scale
  // ═══════════════════════════════════════════════════════════════════════════

  /// No radius - 0
  static double get noneValue => 0;

  /// Extra small radius - 4dp (Porsche default)
  static double get xsValue => 4.r;

  /// Small radius - 8dp
  static double get smValue => 8.r;

  /// Medium radius - 12dp
  static double get mdValue => 12.r;

  /// Large radius - 16dp
  static double get lgValue => 16.r;

  /// Extra large radius - 24dp
  static double get xlValue => 24.r;

  /// Pill radius - 100dp (fully rounded)
  static double get pillValue => 100.r;

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER RADIUS (BorderRadius objects)
  // ═══════════════════════════════════════════════════════════════════════════

  /// No radius
  static BorderRadius get none => BorderRadius.zero;

  /// Extra small - 4dp (Porsche default for small elements)
  static BorderRadius get xs => BorderRadius.circular(xsValue);

  /// Small - 8dp
  static BorderRadius get sm => BorderRadius.circular(smValue);

  /// Medium - 12dp
  static BorderRadius get md => BorderRadius.circular(mdValue);

  /// Large - 16dp
  static BorderRadius get lg => BorderRadius.circular(lgValue);

  /// Extra large - 24dp
  static BorderRadius get xl => BorderRadius.circular(xlValue);

  /// Pill - fully rounded (100dp)
  static BorderRadius get pill => BorderRadius.circular(pillValue);

  // ═══════════════════════════════════════════════════════════════════════════
  // LEGACY ALIASES (for backward compatibility)
  // ═══════════════════════════════════════════════════════════════════════════

  static double get xxlValue => 16.r;
  static double get xxxlValue => 20.r;
  static double get roundValue => 24.r;

  static BorderRadius get xxl => lg;
  static BorderRadius get xxxl => BorderRadius.circular(20.r);
  static BorderRadius get round => xl;

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPONENT-SPECIFIC PRESETS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Button radius - small (4dp Porsche style)
  static BorderRadius get button => xs;

  /// Button large radius - small
  static BorderRadius get buttonLarge => sm;

  /// Card radius - small (Porsche cards are clean)
  static BorderRadius get card => sm;

  /// Card large radius
  static BorderRadius get cardLarge => md;

  /// Input radius - small
  static BorderRadius get input => xs;

  /// Chip radius - square (4dp like buttons for consistency)
  static BorderRadius get chip => xs;

  /// Badge radius - fully rounded
  static BorderRadius get badge => pill;

  /// Avatar radius - fully rounded
  static BorderRadius get avatar => pill;

  /// Bottom sheet radius - top only, 24dp
  static BorderRadius get bottomSheet => BorderRadius.only(
        topLeft: Radius.circular(xlValue),
        topRight: Radius.circular(xlValue),
      );

  /// Dialog radius - medium
  static BorderRadius get dialog => md;

  /// Modal radius - large
  static BorderRadius get modal => lg;

  /// FAB radius - fully rounded
  static BorderRadius get fab => pill;

  /// Popover radius - small
  static BorderRadius get popover => sm;

  /// Tile radius - small
  static BorderRadius get tile => xs;

  // ═══════════════════════════════════════════════════════════════════════════
  // CUSTOM RADIUS FACTORY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Creates a circular border radius with custom value
  static BorderRadius circular(double radius) =>
      BorderRadius.circular(radius.r);

  /// Creates a border radius with different values for each corner
  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) =>
      BorderRadius.only(
        topLeft: Radius.circular(topLeft.r),
        topRight: Radius.circular(topRight.r),
        bottomLeft: Radius.circular(bottomLeft.r),
        bottomRight: Radius.circular(bottomRight.r),
      );

  /// Creates a border radius with top corners only
  static BorderRadius top(double radius) => BorderRadius.only(
        topLeft: Radius.circular(radius.r),
        topRight: Radius.circular(radius.r),
      );

  /// Creates a border radius with bottom corners only
  static BorderRadius bottom(double radius) => BorderRadius.only(
        bottomLeft: Radius.circular(radius.r),
        bottomRight: Radius.circular(radius.r),
      );
}
