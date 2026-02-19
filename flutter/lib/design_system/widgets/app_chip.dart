import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// Chip variants.
enum AppChipVariant {
  /// Filled chip.
  filled,

  /// Outlined chip.
  outlined,

  /// Tonal chip (softer background).
  tonal,
}

/// A customizable chip component.
///
/// Example:
/// ```dart
/// AppChip(
///   label: 'Category',
///   onTap: () => print('Tapped'),
/// )
/// ```
class AppChip extends StatelessWidget {
  /// Chip label text.
  final String label;

  /// Callback when chip is tapped.
  final VoidCallback? onTap;

  /// Chip style variant.
  final AppChipVariant variant;

  /// Whether the chip is selected.
  final bool isSelected;

  /// Optional leading icon.
  final IconData? leadingIcon;

  /// Optional trailing icon (usually close).
  final IconData? trailingIcon;

  /// Callback when trailing icon is tapped.
  final VoidCallback? onTrailingTap;

  /// Custom background color.
  final Color? backgroundColor;

  /// Custom text color.
  final Color? textColor;

  /// Creates an [AppChip].
  const AppChip({
    super.key,
    required this.label,
    this.onTap,
    this.variant = AppChipVariant.filled,
    this.isSelected = false,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingTap,
    this.backgroundColor,
    this.textColor,
  });

  /// Creates a filter chip.
  const AppChip.filter({
    super.key,
    required this.label,
    this.onTap,
    this.isSelected = false,
    this.leadingIcon,
  })  : variant = AppChipVariant.tonal,
        trailingIcon = null,
        onTrailingTap = null,
        backgroundColor = null,
        textColor = null;

  /// Creates a removable chip.
  const AppChip.removable({
    super.key,
    required this.label,
    this.onTap,
    required this.onTrailingTap,
    this.leadingIcon,
  })  : variant = AppChipVariant.tonal,
        isSelected = false,
        trailingIcon = Icons.close,
        backgroundColor = null,
        textColor = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.chipPadding,
        decoration: _buildDecoration(isDark),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 16.sp,
                color: _getTextColor(isDark),
              ),
              SizedBox(width: 6.w),
            ],
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: _getTextColor(isDark),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (trailingIcon != null) ...[
              SizedBox(width: 6.w),
              GestureDetector(
                onTap: onTrailingTap,
                child: Icon(
                  trailingIcon,
                  size: 16.sp,
                  color: _getTextColor(isDark),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark) {
    switch (variant) {
      case AppChipVariant.filled:
        return BoxDecoration(
          color: backgroundColor ??
              (isSelected ? AppColors.primary : AppColors.contrastHighLight),
          borderRadius: AppRadius.chip,
        );
      case AppChipVariant.outlined:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: AppRadius.chip,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 1.5 : 1,
          ),
        );
      case AppChipVariant.tonal:
        return BoxDecoration(
          color: backgroundColor ??
              (isSelected
                  ? AppColors.primaryLight
                  : (isDark
                      ? AppColors.surfaceSecondaryDark
                      : AppColors.surfaceSecondaryLight)),
          borderRadius: AppRadius.chip,
        );
    }
  }

  Color _getTextColor(bool isDark) {
    if (textColor != null) return textColor!;

    switch (variant) {
      case AppChipVariant.filled:
        return AppColors.white;
      case AppChipVariant.outlined:
        return isSelected
            ? AppColors.primary
            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);
      case AppChipVariant.tonal:
        return isSelected
            ? AppColors.primaryDark
            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);
    }
  }
}

/// A status badge.
class AppStatusChip extends StatelessWidget {
  /// Status label.
  final String label;

  /// Status type.
  final AppStatusType status;

  /// Creates an [AppStatusChip].
  const AppStatusChip({
    super.key,
    required this.label,
    required this.status,
  });

  /// Creates a success status chip.
  const AppStatusChip.success({
    super.key,
    required this.label,
  }) : status = AppStatusType.success;

  /// Creates an error status chip.
  const AppStatusChip.error({
    super.key,
    required this.label,
  }) : status = AppStatusType.error;

  /// Creates a warning status chip.
  const AppStatusChip.warning({
    super.key,
    required this.label,
  }) : status = AppStatusType.warning;

  /// Creates an info status chip.
  const AppStatusChip.info({
    super.key,
    required this.label,
  }) : status = AppStatusType.info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: AppRadius.chip,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: _getColor(),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: _getColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case AppStatusType.success:
        return AppColors.success;
      case AppStatusType.error:
        return AppColors.error;
      case AppStatusType.warning:
        return AppColors.warning;
      case AppStatusType.info:
        return AppColors.info;
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case AppStatusType.success:
        return AppColors.successLight;
      case AppStatusType.error:
        return AppColors.errorLight;
      case AppStatusType.warning:
        return AppColors.warningLight;
      case AppStatusType.info:
        return AppColors.infoLight;
    }
  }
}

/// Status types.
enum AppStatusType {
  /// Success status.
  success,

  /// Error status.
  error,

  /// Warning status.
  warning,

  /// Info status.
  info,
}
