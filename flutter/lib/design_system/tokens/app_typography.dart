import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// ============================================================================
/// VTT DESIGN SYSTEM - TYPOGRAPHY
/// Inspired by Porsche Design System
/// Premium • Bold • High Contrast • Fluid Scaling
/// ============================================================================

/// Typography tokens inspired by Porsche Design System.
///
/// Design principles:
/// - Fluid typography that scales with viewport
/// - High contrast for readability
/// - Limited weights (Regular, Semi-Bold, Bold)
/// - Generous line-height for premium feel
/// - No thin or italic styles
abstract final class AppTypography {
  // ═══════════════════════════════════════════════════════════════════════════
  // FONT FAMILY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary font family - Using Inter as Porsche Next alternative.
  /// Inter has similar x-height and modern feel.
  static String get fontFamily => GoogleFonts.inter().fontFamily!;

  /// Get TextTheme for Material theme
  static TextTheme get textTheme => GoogleFonts.interTextTheme();

  // ═══════════════════════════════════════════════════════════════════════════
  // FONT WEIGHTS (Limited palette like Porsche)
  // ═══════════════════════════════════════════════════════════════════════════

  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY STYLES - Hero & Emotional Moments
  // ═══════════════════════════════════════════════════════════════════════════

  /// Display Large - 84sp fluid → For hero intros, stats, emotional moments
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 84.sp.clamp(48, 84),
        fontWeight: weightBold,
        color: AppColors.textPrimaryLight,
        letterSpacing: -2,
        height: 1.1,
      );

  /// Display Medium - 60sp fluid
  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: 60.sp.clamp(36, 60),
        fontWeight: weightBold,
        color: AppColors.textPrimaryLight,
        letterSpacing: -1.5,
        height: 1.15,
      );

  /// Display Small - 44sp fluid
  static TextStyle get displaySmall => GoogleFonts.inter(
        fontSize: 44.sp.clamp(28, 44),
        fontWeight: weightBold,
        color: AppColors.textPrimaryLight,
        letterSpacing: -1,
        height: 1.2,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADING STYLES - Section Headers
  // ═══════════════════════════════════════════════════════════════════════════

  /// Heading XX-Large - 36sp → Dedicated section appointments
  static TextStyle get headingXXLarge => GoogleFonts.inter(
        fontSize: 36.sp.clamp(28, 36),
        fontWeight: weightBold,
        color: AppColors.textPrimaryLight,
        letterSpacing: -0.5,
        height: 1.25,
      );

  /// Heading X-Large - 32sp
  static TextStyle get headingXLarge => GoogleFonts.inter(
        fontSize: 32.sp.clamp(24, 32),
        fontWeight: weightBold,
        color: AppColors.textPrimaryLight,
        letterSpacing: -0.5,
        height: 1.25,
      );

  /// Heading Large - 28sp
  static TextStyle get headingLarge => GoogleFonts.inter(
        fontSize: 28.sp.clamp(22, 28),
        fontWeight: weightSemiBold,
        color: AppColors.textPrimaryLight,
        letterSpacing: -0.3,
        height: 1.3,
      );

  /// Heading Medium - 24sp
  static TextStyle get headingMedium => GoogleFonts.inter(
        fontSize: 24.sp.clamp(20, 24),
        fontWeight: weightSemiBold,
        color: AppColors.textPrimaryLight,
        letterSpacing: -0.2,
        height: 1.3,
      );

  /// Heading Small - 20sp
  static TextStyle get headingSmall => GoogleFonts.inter(
        fontSize: 20.sp.clamp(18, 20),
        fontWeight: weightSemiBold,
        color: AppColors.textPrimaryLight,
        height: 1.35,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // LEGACY ALIASES (for Material Theme compatibility)
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get headlineLarge => headingXLarge;
  static TextStyle get headlineMedium => headingLarge;
  static TextStyle get headlineSmall => headingMedium;

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT STYLES - Running Text & Descriptions
  // ═══════════════════════════════════════════════════════════════════════════

  /// Text X-Large - 20sp → Introductions, short descriptions
  static TextStyle get textXLarge => GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: weightRegular,
        color: AppColors.textPrimaryLight,
        height: 1.5,
      );

  /// Text Large - 18sp
  static TextStyle get textLarge => GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: weightRegular,
        color: AppColors.textPrimaryLight,
        height: 1.5,
      );

  /// Text Medium - 16sp → Default running text
  static TextStyle get textMedium => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: weightRegular,
        color: AppColors.textPrimaryLight,
        height: 1.5,
      );

  /// Text Small - 14sp → Secondary text (DEFAULT for body)
  static TextStyle get textSmall => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: weightRegular,
        color: AppColors.textPrimaryLight,
        height: 1.5,
      );

  /// Text X-Small - 12sp → Supporting information
  static TextStyle get textXSmall => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: weightRegular,
        color: AppColors.textSecondaryLight,
        height: 1.5,
      );

  /// Text XX-Small - 11sp → Disclaimers, consumption info only
  static TextStyle get textXXSmall => GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: weightRegular,
        color: AppColors.textTertiaryLight,
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // LEGACY BODY ALIASES (for Material Theme compatibility)
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get bodyLarge => textMedium;
  static TextStyle get bodyMedium => textSmall;
  static TextStyle get bodySmall => textXSmall;

  // ═══════════════════════════════════════════════════════════════════════════
  // TITLE STYLES (UI Element Titles)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Title Large - 18sp, SemiBold
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: weightSemiBold,
        color: AppColors.textPrimaryLight,
        height: 1.4,
      );

  /// Title Medium - 16sp, SemiBold
  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: weightSemiBold,
        color: AppColors.textPrimaryLight,
        height: 1.4,
      );

  /// Title Small - 14sp, SemiBold
  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: weightSemiBold,
        color: AppColors.textPrimaryLight,
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // LABEL STYLES - Buttons, Tags, Chips
  // ═══════════════════════════════════════════════════════════════════════════

  /// Label Large - 16sp, SemiBold → Large buttons
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: weightSemiBold,
        color: AppColors.textPrimaryLight,
        letterSpacing: 0.1,
        height: 1.4,
      );

  /// Label Medium - 14sp, SemiBold → Regular buttons
  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: weightSemiBold,
        color: AppColors.textPrimaryLight,
        letterSpacing: 0.1,
        height: 1.4,
      );

  /// Label Small - 12sp, SemiBold → Small buttons, chips
  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: weightSemiBold,
        color: AppColors.textSecondaryLight,
        letterSpacing: 0.2,
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // CAPTION & OVERLINE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Caption - 12sp → Metadata, timestamps
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: weightRegular,
        color: AppColors.textTertiaryLight,
        height: 1.4,
      );

  /// Overline - 11sp, SemiBold, Uppercase → Section labels
  static TextStyle get overline => GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: weightSemiBold,
        color: AppColors.textSecondaryLight,
        letterSpacing: 1.5,
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Button text style
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: weightSemiBold,
        letterSpacing: 0.1,
        height: 1.2,
      );

  /// Input text style
  static TextStyle get input => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: weightRegular,
        height: 1.5,
      );

  /// Link text style
  static TextStyle get link => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: weightSemiBold,
        color: AppColors.primary,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.primary,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // NUMERIC STYLES - Stats & Amounts
  // ═══════════════════════════════════════════════════════════════════════════

  /// Number Large - 48sp → Hero stats, big amounts
  static TextStyle get numberLarge => GoogleFonts.inter(
        fontSize: 48.sp,
        fontWeight: weightBold,
        letterSpacing: -1.5,
        height: 1.1,
      );

  /// Number Medium - 32sp → Secondary stats
  static TextStyle get numberMedium => GoogleFonts.inter(
        fontSize: 32.sp,
        fontWeight: weightBold,
        letterSpacing: -1,
        height: 1.2,
      );

  /// Number Small - 20sp → Inline numbers
  static TextStyle get numberSmall => GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: weightSemiBold,
        letterSpacing: -0.5,
        height: 1.3,
      );
}
