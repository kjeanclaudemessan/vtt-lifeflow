import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// Badge variants.
enum AppBadgeVariant {
  /// Primary badge.
  primary,

  /// Secondary badge.
  secondary,

  /// Success badge.
  success,

  /// Error badge.
  error,

  /// Warning badge.
  warning,

  /// Info badge.
  info,

  /// Neutral badge.
  neutral,
}

/// A badge component for notifications or status.
///
/// Example:
/// ```dart
/// AppBadge(
///   label: '3',
///   variant: AppBadgeVariant.error,
/// )
/// ```
class AppBadge extends StatelessWidget {
  /// Badge text.
  final String? label;

  /// Badge count (alternative to label).
  final int? count;

  /// Badge variant.
  final AppBadgeVariant variant;

  /// Whether to show as a small dot.
  final bool isDot;

  /// Creates an [AppBadge].
  const AppBadge({
    super.key,
    this.label,
    this.count,
    this.variant = AppBadgeVariant.primary,
    this.isDot = false,
  });

  /// Creates a dot badge.
  const AppBadge.dot({
    super.key,
    this.variant = AppBadgeVariant.error,
  })  : label = null,
        count = null,
        isDot = true;

  /// Creates a count badge.
  const AppBadge.count({
    super.key,
    required this.count,
    this.variant = AppBadgeVariant.error,
  })  : label = null,
        isDot = false;

  @override
  Widget build(BuildContext context) {
    if (isDot) {
      return Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          shape: BoxShape.circle,
        ),
      );
    }

    final displayText = label ?? (count != null ? _formatCount() : '');

    return Container(
      constraints: BoxConstraints(minWidth: 20.w, minHeight: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: AppRadius.badge,
      ),
      child: Center(
        child: Text(
          displayText,
          style: AppTypography.caption.copyWith(
            color: _getTextColor(),
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  String _formatCount() {
    if (count == null) return '';
    if (count! > 99) return '99+';
    return '$count';
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case AppBadgeVariant.primary:
        return AppColors.primary;
      case AppBadgeVariant.secondary:
        return AppColors.contrastHighLight;
      case AppBadgeVariant.success:
        return AppColors.success;
      case AppBadgeVariant.error:
        return AppColors.error;
      case AppBadgeVariant.warning:
        return AppColors.warning;
      case AppBadgeVariant.info:
        return AppColors.info;
      case AppBadgeVariant.neutral:
        return AppColors.contrastMediumLight;
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case AppBadgeVariant.warning:
        return AppColors.contrastHighLight;
      default:
        return AppColors.white;
    }
  }
}

/// A widget that shows a badge on top of another widget.
class AppBadgeWrapper extends StatelessWidget {
  /// Child widget.
  final Widget child;

  /// Badge text.
  final String? label;

  /// Badge count.
  final int? count;

  /// Badge variant.
  final AppBadgeVariant variant;

  /// Whether to show as a dot.
  final bool isDot;

  /// Whether to show the badge.
  final bool showBadge;

  /// Badge position.
  final BadgePosition position;

  /// Creates an [AppBadgeWrapper].
  const AppBadgeWrapper({
    super.key,
    required this.child,
    this.label,
    this.count,
    this.variant = AppBadgeVariant.error,
    this.isDot = false,
    this.showBadge = true,
    this.position = BadgePosition.topRight,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBadge && count == null || count == 0) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: position == BadgePosition.topRight ||
                  position == BadgePosition.topLeft
              ? -4.h
              : null,
          bottom: position == BadgePosition.bottomRight ||
                  position == BadgePosition.bottomLeft
              ? -4.h
              : null,
          right: position == BadgePosition.topRight ||
                  position == BadgePosition.bottomRight
              ? -4.w
              : null,
          left: position == BadgePosition.topLeft ||
                  position == BadgePosition.bottomLeft
              ? -4.w
              : null,
          child: AppBadge(
            label: label,
            count: count,
            variant: variant,
            isDot: isDot,
          ),
        ),
      ],
    );
  }
}

/// Badge position options.
enum BadgePosition {
  /// Top right corner.
  topRight,

  /// Top left corner.
  topLeft,

  /// Bottom right corner.
  bottomRight,

  /// Bottom left corner.
  bottomLeft,
}
