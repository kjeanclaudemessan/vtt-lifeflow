import 'package:flutter/material.dart';

/// ============================================================================
/// VTT DESIGN SYSTEM - COLORS
/// Inspired by Porsche Design System
/// Premium • Bold • Distinctive • High Contrast
/// ============================================================================

/// Porsche-inspired color palette with monochromatic base and bold accent.
///
/// Design principles:
/// - Monochromatic base (deep black / pure white)
/// - Bold accent color (Porsche Red)
/// - High contrast for accessibility
/// - Limited color set for consistency
/// - Frosted glass effects for premium feel
abstract final class AppColors {
  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary brand color - Porsche Red
  /// Used for CTAs, highlights, and brand moments
  static const Color primary = Color(0xFFD5001C);

  /// Primary color variants
  static const Color primaryLight = Color(0xFFFF2D46);
  static const Color primaryDark = Color(0xFFA30015);
  static const Color primaryContainer = Color(0xFFFDE6E9);
  static const Color primaryContainerDark = Color(0xFF3D0008);

  /// On primary (text/icons on primary backgrounds)
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Alias for onPrimary - text on primary colored backgrounds
  static const Color textOnPrimary = onPrimary;

  // ═══════════════════════════════════════════════════════════════════════════
  // PURE NEUTRALS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black
  static const Color black = Color(0xFF000000);

  // ═══════════════════════════════════════════════════════════════════════════
  // NEUTRAL PALETTE - For UI elements requiring specific shades
  // ═══════════════════════════════════════════════════════════════════════════

  /// Neutral 100 - Very light gray (backgrounds, disabled states)
  static const Color neutral100 = Color(0xFFF5F5F5);

  /// Neutral 200 - Light gray (borders, dividers)
  static const Color neutral200 = Color(0xFFEEEEEE);

  /// Neutral 300 - Medium-light gray (inactive elements)
  static const Color neutral300 = Color(0xFFE0E0E0);

  /// Neutral 400 - Medium gray (placeholder text)
  static const Color neutral400 = Color(0xFFBDBDBD);

  /// Neutral 500 - Standard gray (secondary icons)
  static const Color neutral500 = Color(0xFF9E9E9E);

  /// Neutral 600 - Medium-dark gray (secondary text)
  static const Color neutral600 = Color(0xFF757575);

  /// Neutral 700 - Dark gray (primary text alternative)
  static const Color neutral700 = Color(0xFF616161);

  /// Neutral 800 - Very dark gray (headings)
  static const Color neutral800 = Color(0xFF424242);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME - BACKGROUND COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Background base - Pure white canvas
  static const Color backgroundLight = Color(0xFFFFFFFF);

  /// Background surface - Slightly elevated (cards, sheets)
  static const Color surfaceLight = Color(0xFFF7F7F7);

  /// Background surface secondary
  static const Color surfaceSecondaryLight = Color(0xFFEEEEEE);

  /// Background shading - Overlay effect
  static const Color shadingLight = Color(0x1A000000);

  /// Background frosted - Glassmorphism
  static const Color frostedLight = Color(0xE6FFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME - BACKGROUND COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Background base - Deep black
  static const Color backgroundDark = Color(0xFF0E0E0E);

  /// Background surface - Elevated dark surface
  static const Color surfaceDark = Color(0xFF1A1A1A);

  /// Background surface secondary
  static const Color surfaceSecondaryDark = Color(0xFF262626);

  /// Background shading - Overlay effect
  static const Color shadingDark = Color(0x66000000);

  /// Background frosted - Glassmorphism
  static const Color frostedDark = Color(0xE60E0E0E);

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTRAST COLORS - LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Contrast low - Subtle borders, disabled states
  static const Color contrastLowLight = Color(0xFFE0E0E0);

  /// Contrast medium - Secondary text, icons
  static const Color contrastMediumLight = Color(0xFF6B6B6B);

  /// Contrast high - Primary text, strong borders
  static const Color contrastHighLight = Color(0xFF000000);

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTRAST COLORS - DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Contrast low - Subtle borders, disabled states
  static const Color contrastLowDark = Color(0xFF3D3D3D);

  /// Contrast medium - Secondary text, icons
  static const Color contrastMediumDark = Color(0xFF969696);

  /// Contrast high - Primary text, strong borders
  static const Color contrastHighDark = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTIFICATION / SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Success - Green
  static const Color success = Color(0xFF018A16);
  static const Color successLight = Color(0xFFE5F5E7);
  static const Color successDark = Color(0xFF0D2A11);

  /// Warning - Amber
  static const Color warning = Color(0xFFFF9B00);
  static const Color warningLight = Color(0xFFFFF4E0);
  static const Color warningDark = Color(0xFF332000);

  /// Error - Red (distinct from primary)
  static const Color error = Color(0xFFE00000);
  static const Color errorLight = Color(0xFFFDE6E6);
  static const Color errorDark = Color(0xFF330000);

  /// Info - Blue
  static const Color info = Color(0xFF0061BD);
  static const Color infoLight = Color(0xFFE5F0F9);
  static const Color infoDark = Color(0xFF001A33);

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT COLORS - LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary text on light background
  static const Color textPrimaryLight = contrastHighLight;

  /// Secondary text on light background
  static const Color textSecondaryLight = contrastMediumLight;

  /// Tertiary/hint text on light background
  static const Color textTertiaryLight = Color(0xFF8F8F8F);

  /// Disabled text on light background
  static const Color textDisabledLight = contrastLowLight;

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT COLORS - DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary text on dark background
  static const Color textPrimaryDark = contrastHighDark;

  /// Secondary text on dark background
  static const Color textSecondaryDark = contrastMediumDark;

  /// Tertiary/hint text on dark background
  static const Color textTertiaryDark = Color(0xFF6B6B6B);

  /// Disabled text on dark background
  static const Color textDisabledDark = contrastLowDark;

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER & DIVIDER COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Border color - Light theme
  static const Color borderLight = contrastLowLight;

  /// Border color - Dark theme
  static const Color borderDark = contrastLowDark;

  /// Divider color - Light theme
  static const Color dividerLight = contrastLowLight;

  /// Divider color - Dark theme
  static const Color dividerDark = contrastLowDark;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE COLORS - LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Hover state - 5% black overlay
  static const Color stateHoverLight = Color(0x0D000000);

  /// Active/Pressed state - 10% black overlay
  static const Color stateActiveLight = Color(0x1A000000);

  /// Focus ring color
  static const Color stateFocusLight = Color(0xFF0061BD);

  /// Disabled state - 30% opacity
  static const Color stateDisabledLight = Color(0x4D000000);

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE COLORS - DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Hover state - 5% white overlay
  static const Color stateHoverDark = Color(0x0DFFFFFF);

  /// Active/Pressed state - 10% white overlay
  static const Color stateActiveDark = Color(0x1AFFFFFF);

  /// Focus ring color
  static const Color stateFocusDark = Color(0xFF6AC2FF);

  /// Disabled state - 30% opacity
  static const Color stateDisabledDark = Color(0x4DFFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT ON COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Text on primary color
  static const Color onPrimaryColor = white;

  /// Text on error color
  static const Color onError = white;

  /// Text on success color
  static const Color onSuccess = white;

  /// Text on warning color
  static const Color onWarning = black;

  /// Text on info color
  static const Color onInfo = white;

  /// Text on dark surfaces
  static const Color onDark = white;

  // ═══════════════════════════════════════════════════════════════════════════
  // OVERLAY COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Black overlay (50%) - for modals, drawers
  static const Color overlayBlack = Color(0x80000000);

  /// Black overlay (30%) - lighter overlay
  static const Color overlayBlackLight = Color(0x4D000000);

  /// White overlay (50%)
  static const Color overlayWhite = Color(0x80FFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENT DEFINITIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary gradient - subtle brand gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  /// Dark overlay gradient - for hero images
  static const LinearGradient darkOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xBF000000)],
  );

  /// Premium sheen gradient - subtle light effect
  static const LinearGradient sheenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x1AFFFFFF), Color(0x00FFFFFF)],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns primary color with opacity
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);

  /// Returns error color with opacity
  static Color errorWithOpacity(double opacity) =>
      error.withValues(alpha: opacity);

  /// Returns black with opacity
  static Color blackWithOpacity(double opacity) =>
      black.withValues(alpha: opacity);

  /// Returns white with opacity
  static Color whiteWithOpacity(double opacity) =>
      white.withValues(alpha: opacity);

  /// Get text color based on background brightness
  static Color getTextColorOn(Color background) {
    return background.computeLuminance() > 0.5 ? textPrimaryLight : onDark;
  }

  /// Get appropriate surface color for theme
  static Color surface(Brightness brightness) =>
      brightness == Brightness.light ? surfaceLight : surfaceDark;

  /// Get appropriate background color for theme
  static Color background(Brightness brightness) =>
      brightness == Brightness.light ? backgroundLight : backgroundDark;

  /// Get appropriate text primary for theme
  static Color textPrimary(Brightness brightness) =>
      brightness == Brightness.light ? textPrimaryLight : textPrimaryDark;

  /// Get appropriate text secondary for theme
  static Color textSecondary(Brightness brightness) =>
      brightness == Brightness.light ? textSecondaryLight : textSecondaryDark;

  /// Get appropriate border color for theme
  static Color border(Brightness brightness) =>
      brightness == Brightness.light ? borderLight : borderDark;

  /// Get appropriate contrast high for theme
  static Color contrastHigh(Brightness brightness) =>
      brightness == Brightness.light ? contrastHighLight : contrastHighDark;

  /// Get appropriate contrast medium for theme
  static Color contrastMedium(Brightness brightness) =>
      brightness == Brightness.light ? contrastMediumLight : contrastMediumDark;

  /// Get appropriate hover state for theme
  static Color stateHover(Brightness brightness) =>
      brightness == Brightness.light ? stateHoverLight : stateHoverDark;

  /// Get appropriate focus state for theme
  static Color stateFocus(Brightness brightness) =>
      brightness == Brightness.light ? stateFocusLight : stateFocusDark;

  /// Get appropriate text tertiary for theme
  static Color textTertiary(Brightness brightness) =>
      brightness == Brightness.light ? textTertiaryLight : textTertiaryDark;

  /// Get appropriate surface secondary for theme
  static Color surfaceSecondary(Brightness brightness) =>
      brightness == Brightness.light
          ? surfaceSecondaryLight
          : surfaceSecondaryDark;
}
