import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_shadows.dart';

/// Card variants.
enum AppCardVariant {
  /// Elevated card with shadow.
  elevated,

  /// Outlined card with border.
  outlined,

  /// Filled card with background color.
  filled,
}

/// A customizable card component.
///
/// Example:
/// ```dart
/// AppCard(
///   child: Text('Card content'),
///   variant: AppCardVariant.elevated,
/// )
/// ```
class AppCard extends StatelessWidget {
  /// Card content.
  final Widget child;

  /// Card style variant.
  final AppCardVariant variant;

  /// Custom padding.
  final EdgeInsetsGeometry? padding;

  /// Custom background color.
  final Color? backgroundColor;

  /// Custom border color (for outlined variant).
  final Color? borderColor;

  /// Callback when card is tapped.
  final VoidCallback? onTap;

  /// Custom border radius.
  final BorderRadius? borderRadius;

  /// Custom width.
  final double? width;

  /// Custom height.
  final double? height;

  /// Creates an [AppCard].
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.borderRadius,
    this.width,
    this.height,
  });

  /// Creates an elevated card.
  const AppCard.elevated({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.borderRadius,
    this.width,
    this.height,
  })  : variant = AppCardVariant.elevated,
        borderColor = null;

  /// Creates an outlined card.
  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.borderRadius,
    this.width,
    this.height,
  }) : variant = AppCardVariant.outlined;

  /// Creates a filled card.
  const AppCard.filled({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.onTap,
    this.borderRadius,
    this.width,
    this.height,
  })  : variant = AppCardVariant.filled,
        borderColor = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding ?? EdgeInsets.all(16.w),
        decoration: _buildDecoration(isDark),
        child: child,
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark) {
    switch (variant) {
      case AppCardVariant.elevated:
        return BoxDecoration(
          color: backgroundColor ??
              (isDark ? AppColors.surfaceDark : AppColors.white),
          borderRadius: borderRadius ?? AppRadius.card,
          boxShadow: isDark ? AppShadows.darkSm : AppShadows.sm,
        );
      case AppCardVariant.outlined:
        return BoxDecoration(
          color: backgroundColor ??
              (isDark ? AppColors.surfaceDark : AppColors.white),
          borderRadius: borderRadius ?? AppRadius.card,
          border: Border.all(
            color: borderColor ??
                (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: 1,
          ),
        );
      case AppCardVariant.filled:
        return BoxDecoration(
          color: backgroundColor ??
              (isDark
                  ? AppColors.surfaceSecondaryDark
                  : AppColors.surfaceSecondaryLight),
          borderRadius: borderRadius ?? AppRadius.card,
        );
    }
  }
}

/// A dark themed card for highlights.
class AppDarkCard extends StatelessWidget {
  /// Card content.
  final Widget child;

  /// Custom padding.
  final EdgeInsetsGeometry? padding;

  /// Callback when card is tapped.
  final VoidCallback? onTap;

  /// Custom border radius.
  final BorderRadius? borderRadius;

  /// Creates an [AppDarkCard].
  const AppDarkCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: padding ?? EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.contrastHighLight,
          borderRadius: borderRadius ?? AppRadius.xl,
          boxShadow: [
            BoxShadow(
              color: AppColors.contrastHighLight.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
