import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ============================================================================
/// VTT DESIGN SYSTEM - SHADOWS & EFFECTS
/// Inspired by Porsche Design System
/// Premium drop shadows and glassmorphism effects
/// ============================================================================

/// Shadow tokens inspired by Porsche Design System.
///
/// Design principles:
/// - Subtle, refined drop shadows
/// - High contrast focus states
/// - Glassmorphism / frosted glass support
/// - Distinct light vs dark theme shadows
abstract final class AppShadows {
  // ═══════════════════════════════════════════════════════════════════════════
  // DROP SHADOWS - LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// No shadow
  static List<BoxShadow> get none => [];

  /// Extra small drop shadow - subtle lift
  static List<BoxShadow> get xs => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  /// Small drop shadow - cards at rest
  static List<BoxShadow> get sm => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Medium drop shadow - elevated elements (Porsche default)
  static List<BoxShadow> get md => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  /// Large drop shadow - modals, popovers
  static List<BoxShadow> get lg => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Extra large drop shadow - flyouts, important elements
  static List<BoxShadow> get xl => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.16),
          blurRadius: 32,
          offset: const Offset(0, 12),
          spreadRadius: -6,
        ),
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // DROP SHADOWS - DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Dark theme small shadow
  static List<BoxShadow> get darkSm => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.30),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];

  /// Dark theme medium shadow
  static List<BoxShadow> get darkMd => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.40),
          blurRadius: 20,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
      ];

  /// Dark theme large shadow
  static List<BoxShadow> get darkLg => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.50),
          blurRadius: 32,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // FOCUS SHADOWS (Porsche-style focus ring)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Focus ring - light theme (blue glow)
  static List<BoxShadow> get focusLight => [
        BoxShadow(
          color: AppColors.stateFocusLight.withValues(alpha: 0.4),
          blurRadius: 0,
          spreadRadius: 3,
        ),
      ];

  /// Focus ring - dark theme (lighter blue glow)
  static List<BoxShadow> get focusDark => [
        BoxShadow(
          color: AppColors.stateFocusDark.withValues(alpha: 0.5),
          blurRadius: 0,
          spreadRadius: 3,
        ),
      ];

  /// Focus ring with offset (for accessibility)
  static List<BoxShadow> get focusOffset => [
        const BoxShadow(
          color: AppColors.stateFocusLight,
          blurRadius: 0,
          spreadRadius: 2,
        ),
        const BoxShadow(
          color: AppColors.white,
          blurRadius: 0,
          spreadRadius: 4,
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORED SHADOWS - Primary (Porsche Red)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary shadow - for primary buttons
  static List<BoxShadow> get primary => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.30),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
      ];

  /// Primary strong shadow - for pressed/hover state
  static List<BoxShadow> get primaryStrong => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.40),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -2,
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORED SHADOWS - Semantic
  // ═══════════════════════════════════════════════════════════════════════════

  /// Error shadow
  static List<BoxShadow> get error => [
        BoxShadow(
          color: AppColors.error.withValues(alpha: 0.30),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// Success shadow
  static List<BoxShadow> get success => [
        BoxShadow(
          color: AppColors.success.withValues(alpha: 0.30),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// Warning shadow
  static List<BoxShadow> get warning => [
        BoxShadow(
          color: AppColors.warning.withValues(alpha: 0.30),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// Info shadow
  static List<BoxShadow> get info => [
        BoxShadow(
          color: AppColors.info.withValues(alpha: 0.30),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // INPUT SHADOWS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Input focus shadow - light theme
  static List<BoxShadow> get inputFocus => [
        BoxShadow(
          color: AppColors.stateFocusLight.withValues(alpha: 0.2),
          blurRadius: 0,
          spreadRadius: 2,
        ),
      ];

  /// Input error shadow
  static List<BoxShadow> get inputError => [
        BoxShadow(
          color: AppColors.error.withValues(alpha: 0.2),
          blurRadius: 0,
          spreadRadius: 2,
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPONENT-SPECIFIC PRESETS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Card shadow
  static List<BoxShadow> get card => sm;

  /// Card elevated shadow
  static List<BoxShadow> get cardElevated => md;

  /// Button shadow
  static List<BoxShadow> get button => none;

  /// Button pressed shadow
  static List<BoxShadow> get buttonPressed => none;

  /// Button hover shadow
  static List<BoxShadow> get buttonHover => xs;

  /// Dropdown / Popover shadow
  static List<BoxShadow> get dropdown => lg;

  /// Modal shadow
  static List<BoxShadow> get modal => xl;

  /// Bottom navigation shadow
  static List<BoxShadow> get bottomNav => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, -4),
        ),
      ];

  /// App bar shadow
  static List<BoxShadow> get appBar => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// FAB shadow
  static List<BoxShadow> get fab => lg;

  /// Dialog shadow
  static List<BoxShadow> get dialog => xl;

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get shadow based on theme brightness
  static List<BoxShadow> getShadow(Brightness brightness,
      {bool elevated = false}) {
    if (brightness == Brightness.light) {
      return elevated ? md : sm;
    } else {
      return elevated ? darkMd : darkSm;
    }
  }

  /// Get focus shadow based on theme brightness
  static List<BoxShadow> getFocus(Brightness brightness) {
    return brightness == Brightness.light ? focusLight : focusDark;
  }
}
