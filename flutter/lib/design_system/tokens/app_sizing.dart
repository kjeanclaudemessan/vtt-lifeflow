import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ============================================================================
/// VTT DESIGN SYSTEM - SIZING
/// Standardized component sizes — no magic numbers
/// ============================================================================

/// Centralized sizing tokens for icons, avatars, touch targets,
/// progress indicators, and miscellaneous UI elements.
///
/// Usage:
/// ```dart
/// Icon(Icons.home, size: AppSizing.iconMd)
/// AppAvatar(size: AppSizing.avatarMd)
/// SizedBox(width: AppSizing.touchTarget, height: AppSizing.touchTarget)
/// ```
abstract final class AppSizing {
  // ═══════════════════════════════════════════════════════════════════════════
  // ICONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Extra small icon — 12dp (inline indicators)
  static double get iconXs => 12.sp;

  /// Small icon — 16dp (trailing, secondary actions)
  static double get iconSm => 16.sp;

  /// Medium icon — 20dp (default body icons)
  static double get iconMd => 20.sp;

  /// Large icon — 24dp (primary action icons, nav bar)
  static double get iconLg => 24.sp;

  /// Extra large icon — 32dp (headers, empty states)
  static double get iconXl => 32.sp;

  /// Extra extra large icon — 48dp (hero icons, onboarding)
  static double get iconXxl => 48.sp;

  // ═══════════════════════════════════════════════════════════════════════════
  // AVATARS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Small avatar — 32dp (list items, compact)
  static double get avatarSm => 32.w;

  /// Medium avatar — 40dp (default list items)
  static double get avatarMd => 40.w;

  /// Large avatar — 56dp (profile header, cards)
  static double get avatarLg => 56.w;

  /// Extra large avatar — 80dp (profile page hero)
  static double get avatarXl => 80.w;

  /// Extra extra large avatar — 100dp (edit profile)
  static double get avatarXxl => 100.w;

  // ═══════════════════════════════════════════════════════════════════════════
  // TOUCH TARGETS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Minimum touch target — 44dp (Apple HIG minimum)
  static double get touchTargetMin => 44.w;

  /// Default touch target — 48dp (Material minimum, WCAG AA)
  static double get touchTarget => 48.w;

  /// Large touch target — 56dp (primary actions)
  static double get touchTargetLg => 56.w;

  // ═══════════════════════════════════════════════════════════════════════════
  // PROGRESS INDICATORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Small circular progress — 20dp (inline)
  static double get circularProgressSm => 20.w;

  /// Medium circular progress — 36dp (default)
  static double get circularProgressMd => 36.w;

  /// Large circular progress — 56dp (centered loading)
  static double get circularProgressLg => 56.w;

  /// Linear progress height — 4dp
  static double get linearProgressHeight => 4.h;

  /// Linear progress height thick — 8dp
  static double get linearProgressHeightLg => 8.h;

  // ═══════════════════════════════════════════════════════════════════════════
  // BADGES & INDICATORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Small badge — 8dp (dot indicator)
  static double get badgeDot => 8.w;

  /// Medium badge — 16dp (counter badge)
  static double get badgeMd => 16.w;

  /// Large badge — 24dp (status badge with text)
  static double get badgeLg => 24.w;

  // ═══════════════════════════════════════════════════════════════════════════
  // MISCELLANEOUS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Bottom sheet handle width — 40dp
  static double get sheetHandle => 40.w;

  /// Bottom sheet handle height — 4dp
  static double get sheetHandleHeight => 4.h;

  /// FAB size — 56dp
  static double get fabSize => 56.w;

  /// Checkbox/Radio size — 24dp
  static double get checkboxSize => 24.w;

  /// Divider thickness — 1dp
  static double get dividerThickness => 1.h;

  /// Skeleton shimmer height for text — 14dp
  static double get skeletonText => 14.h;

  /// Skeleton shimmer height for title — 20dp
  static double get skeletonTitle => 20.h;
}
