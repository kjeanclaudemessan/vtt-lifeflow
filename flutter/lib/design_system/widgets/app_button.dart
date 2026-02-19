import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_shadows.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// Button variants.
enum AppButtonVariant {
  /// Primary filled button.
  primary,

  /// Secondary filled button.
  secondary,

  /// Outlined button.
  outline,

  /// Danger/error button.
  danger,

  /// Ghost/text button.
  ghost,
}

/// Button sizes.
enum AppButtonSize {
  /// Small button - 36dp height.
  small,

  /// Medium button - 48dp height (default).
  medium,

  /// Large button - 56dp height.
  large,
}

/// A customizable button component.
///
/// Example:
/// ```dart
/// AppButton(
///   label: 'Continue',
///   onPressed: () => print('Pressed'),
///   variant: AppButtonVariant.primary,
/// )
/// ```
class AppButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Callback when button is pressed.
  final VoidCallback? onPressed;

  /// Button style variant.
  final AppButtonVariant variant;

  /// Button size.
  final AppButtonSize size;

  /// Optional icon on the left.
  final IconData? leftIcon;

  /// Optional icon on the right.
  final IconData? rightIcon;

  /// Whether the button is in loading state.
  final bool isLoading;

  /// Whether the button takes full width.
  final bool isFullWidth;

  /// Creates an [AppButton].
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.leftIcon,
    this.rightIcon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  /// Creates a primary button.
  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.leftIcon,
    this.rightIcon,
    this.isLoading = false,
    this.isFullWidth = true,
  }) : variant = AppButtonVariant.primary;

  /// Creates a secondary button.
  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.leftIcon,
    this.rightIcon,
    this.isLoading = false,
    this.isFullWidth = true,
  }) : variant = AppButtonVariant.secondary;

  /// Creates an outlined button.
  const AppButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.leftIcon,
    this.rightIcon,
    this.isLoading = false,
    this.isFullWidth = true,
  }) : variant = AppButtonVariant.outline;

  /// Creates a danger button.
  const AppButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.leftIcon,
    this.rightIcon,
    this.isLoading = false,
    this.isFullWidth = true,
  }) : variant = AppButtonVariant.danger;

  /// Creates a ghost/text button.
  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.leftIcon,
    this.rightIcon,
    this.isLoading = false,
    this.isFullWidth = true,
  }) : variant = AppButtonVariant.ghost;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(),
    );
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return AppSpacing.buttonHeightSm;
      case AppButtonSize.medium:
        return AppSpacing.buttonHeightMd;
      case AppButtonSize.large:
        return AppSpacing.buttonHeightLg;
    }
  }

  Widget _buildButton() {
    switch (variant) {
      case AppButtonVariant.primary:
        return _buildElevatedButton(AppColors.primary, AppColors.white);
      case AppButtonVariant.secondary:
        return _buildElevatedButton(
            AppColors.contrastHighLight, AppColors.white);
      case AppButtonVariant.danger:
        return _buildElevatedButton(AppColors.error, AppColors.white);
      case AppButtonVariant.outline:
        return _buildOutlinedButton();
      case AppButtonVariant.ghost:
        return _buildGhostButton();
    }
  }

  Widget _buildElevatedButton(Color bgColor, Color fgColor) {
    final isDisabled = onPressed == null || isLoading;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.button,
        boxShadow: isDisabled
            ? AppShadows.none
            : [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: bgColor.withValues(alpha: 0.5),
          disabledForegroundColor: fgColor.withValues(alpha: 0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
        ),
        child: _buildContent(fgColor),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
      ),
      child: _buildContent(AppColors.primary),
    );
  }

  Widget _buildGhostButton() {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
      ),
      child: _buildContent(AppColors.primary),
    );
  }

  Widget _buildContent(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 20.w,
        height: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leftIcon != null) ...[
          Icon(leftIcon, size: 18.sp),
          SizedBox(width: 8.w),
        ],
        Text(label, style: AppTypography.button),
        if (rightIcon != null) ...[
          SizedBox(width: 8.w),
          Icon(rightIcon, size: 18.sp),
        ],
      ],
    );
  }
}

/// An icon button with optional badge.
class AppIconButton extends StatelessWidget {
  /// Icon to display.
  final IconData icon;

  /// Callback when button is pressed.
  final VoidCallback? onTap;

  /// Whether to show a notification badge.
  final bool hasBadge;

  /// Badge count (if > 0, shows number instead of dot).
  final int badgeCount;

  /// Background color.
  final Color? backgroundColor;

  /// Icon color.
  final Color? iconColor;

  /// Button size.
  final double? size;

  /// Creates an [AppIconButton].
  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.hasBadge = false,
    this.badgeCount = 0,
    this.backgroundColor,
    this.iconColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 44.w;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.white,
              borderRadius: AppRadius.md,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.contrastHighLight,
              size: 22.sp,
            ),
          ),
          if (hasBadge || badgeCount > 0)
            Positioned(
              top: 8.w,
              right: 8.w,
              child: Container(
                width: badgeCount > 0 ? null : 8.w,
                height: badgeCount > 0 ? null : 8.w,
                padding: badgeCount > 0
                    ? EdgeInsets.symmetric(horizontal: 4.w)
                    : null,
                constraints: badgeCount > 0
                    ? BoxConstraints(minWidth: 16.w, minHeight: 16.w)
                    : null,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: badgeCount > 0 ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: badgeCount > 0 ? AppRadius.pill : null,
                  border: Border.all(color: AppColors.white, width: 1.5),
                ),
                child: badgeCount > 0
                    ? Center(
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
