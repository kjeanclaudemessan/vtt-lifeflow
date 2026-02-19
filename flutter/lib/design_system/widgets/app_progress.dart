import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// Progress indicator sizes.
enum AppProgressSize {
  /// Small - 16dp
  small,

  /// Medium - 24dp (default)
  medium,

  /// Large - 48dp
  large,
}

/// Progress indicator variants.
enum AppProgressVariant {
  /// Primary color
  primary,

  /// Success color
  success,

  /// Warning color
  warning,

  /// Error color
  error,

  /// Info color
  info,
}

/// A styled linear progress indicator following Porsche Design System.
///
/// Example:
/// ```dart
/// AppLinearProgress(
///   value: 0.7,
///   label: 'Upload progress',
///   showPercentage: true,
/// )
/// ```
class AppLinearProgress extends StatelessWidget {
  /// Progress value (0.0 to 1.0). Null for indeterminate.
  final double? value;

  /// Color variant.
  final AppProgressVariant variant;

  /// Optional label.
  final String? label;

  /// Whether to show percentage.
  final bool showPercentage;

  /// Height of the progress bar.
  final double? height;

  /// Border radius of the progress bar.
  final BorderRadius? borderRadius;

  /// Background color override.
  final Color? backgroundColor;

  /// Creates an [AppLinearProgress].
  const AppLinearProgress({
    super.key,
    this.value,
    this.variant = AppProgressVariant.primary,
    this.label,
    this.showPercentage = false,
    this.height,
    this.borderRadius,
    this.backgroundColor,
  });

  /// Creates an indeterminate linear progress indicator.
  const AppLinearProgress.indeterminate({
    super.key,
    this.variant = AppProgressVariant.primary,
    this.label,
    this.height,
    this.borderRadius,
    this.backgroundColor,
  })  : value = null,
        showPercentage = false;

  Color _getColor() {
    switch (variant) {
      case AppProgressVariant.primary:
        return AppColors.primary;
      case AppProgressVariant.success:
        return AppColors.success;
      case AppProgressVariant.warning:
        return AppColors.warning;
      case AppProgressVariant.error:
        return AppColors.error;
      case AppProgressVariant.info:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBackgroundColor = backgroundColor ??
        (isDark ? AppColors.contrastLowDark : AppColors.contrastLowLight);
    final effectiveHeight = height ?? 4.h;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(2.r);
    final color = _getColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercentage)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(label!, style: AppTypography.labelMedium),
                if (showPercentage && value != null)
                  Text(
                    '${(value! * 100).toInt()}%',
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: SizedBox(
            height: effectiveHeight,
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: effectiveBackgroundColor,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
      ],
    );
  }
}

/// A styled circular progress indicator following Porsche Design System.
///
/// Example:
/// ```dart
/// AppCircularProgress(
///   value: 0.75,
///   showPercentage: true,
/// )
/// ```
class AppCircularProgress extends StatelessWidget {
  /// Progress value (0.0 to 1.0). Null for indeterminate.
  final double? value;

  /// Color variant.
  final AppProgressVariant variant;

  /// Size of the indicator.
  final AppProgressSize size;

  /// Whether to show percentage in center.
  final bool showPercentage;

  /// Custom size override.
  final double? customSize;

  /// Stroke width override.
  final double? strokeWidth;

  /// Background color override.
  final Color? backgroundColor;

  /// Optional label below.
  final String? label;

  /// Creates an [AppCircularProgress].
  const AppCircularProgress({
    super.key,
    this.value,
    this.variant = AppProgressVariant.primary,
    this.size = AppProgressSize.medium,
    this.showPercentage = false,
    this.customSize,
    this.strokeWidth,
    this.backgroundColor,
    this.label,
  });

  /// Creates an indeterminate circular progress indicator.
  const AppCircularProgress.indeterminate({
    super.key,
    this.variant = AppProgressVariant.primary,
    this.size = AppProgressSize.medium,
    this.customSize,
    this.strokeWidth,
    this.backgroundColor,
    this.label,
  })  : value = null,
        showPercentage = false;

  double _getSize() {
    if (customSize != null) return customSize!;
    switch (size) {
      case AppProgressSize.small:
        return 16.sp;
      case AppProgressSize.medium:
        return 24.sp;
      case AppProgressSize.large:
        return 48.sp;
    }
  }

  double _getStrokeWidth() {
    if (strokeWidth != null) return strokeWidth!;
    switch (size) {
      case AppProgressSize.small:
        return 2.w;
      case AppProgressSize.medium:
        return 3.w;
      case AppProgressSize.large:
        return 4.w;
    }
  }

  Color _getColor() {
    switch (variant) {
      case AppProgressVariant.primary:
        return AppColors.primary;
      case AppProgressVariant.success:
        return AppColors.success;
      case AppProgressVariant.warning:
        return AppColors.warning;
      case AppProgressVariant.error:
        return AppColors.error;
      case AppProgressVariant.info:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBackgroundColor = backgroundColor ??
        (isDark ? AppColors.contrastLowDark : AppColors.contrastLowLight);
    final effectiveSize = _getSize();
    final effectiveStrokeWidth = _getStrokeWidth();
    final color = _getColor();

    Widget indicator = SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: CircularProgressIndicator(
        value: value,
        backgroundColor: effectiveBackgroundColor,
        valueColor: AlwaysStoppedAnimation(color),
        strokeWidth: effectiveStrokeWidth,
      ),
    );

    if (showPercentage && value != null) {
      indicator = Stack(
        alignment: Alignment.center,
        children: [
          indicator,
          Text(
            '${(value! * 100).toInt()}%',
            style: AppTypography.caption.copyWith(
              fontSize: effectiveSize * 0.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    if (label != null) {
      indicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          AppSpacing.verticalXs,
          Text(label!, style: AppTypography.caption),
        ],
      );
    }

    return indicator;
  }
}

/// A progress bar with step indicators.
///
/// Example:
/// ```dart
/// AppStepProgress(
///   currentStep: 2,
///   totalSteps: 4,
///   labels: ['Cart', 'Shipping', 'Payment', 'Done'],
/// )
/// ```
class AppStepProgress extends StatelessWidget {
  /// Current step (1-indexed).
  final int currentStep;

  /// Total number of steps.
  final int totalSteps;

  /// Optional labels for each step.
  final List<String>? labels;

  /// Active color.
  final Color? activeColor;

  /// Inactive color.
  final Color? inactiveColor;

  /// Whether to show step numbers.
  final bool showNumbers;

  /// Creates an [AppStepProgress].
  const AppStepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.labels,
    this.activeColor,
    this.inactiveColor,
    this.showNumbers = false,
  }) : assert(
          labels == null || labels.length == totalSteps,
          'Labels length must match totalSteps',
        );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor = inactiveColor ??
        (isDark ? AppColors.contrastLowDark : AppColors.contrastLowLight);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isOdd) {
              // Connector line
              final stepIndex = (index + 1) ~/ 2;
              final isActive = stepIndex < currentStep;
              return Expanded(
                child: Container(
                  height: 2.h,
                  color: isActive
                      ? effectiveActiveColor
                      : effectiveInactiveColor,
                ),
              );
            } else {
              // Step circle
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep - 1;
              final isCurrent = stepIndex == currentStep - 1;
              final isActive = isCompleted || isCurrent;

              return Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? effectiveActiveColor
                      : effectiveInactiveColor,
                  border: isCurrent
                      ? Border.all(
                          color: effectiveActiveColor,
                          width: 2.w,
                        )
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          size: 14.sp,
                          color: AppColors.white,
                        )
                      : showNumbers
                          ? Text(
                              '${stepIndex + 1}',
                              style: AppTypography.labelSmall.copyWith(
                                color: isActive
                                    ? AppColors.white
                                    : (isDark
                                        ? AppColors.contrastMediumDark
                                        : AppColors.contrastMediumLight),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : null,
                ),
              );
            }
          }),
        ),
        if (labels != null) ...[
          AppSpacing.verticalXs,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels!.asMap().entries.map((entry) {
              final isActive = entry.key < currentStep;
              return SizedBox(
                width: 60.w,
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(
                    color: isActive
                        ? effectiveActiveColor
                        : (isDark
                            ? AppColors.contrastMediumDark
                            : AppColors.contrastMediumLight),
                    fontWeight: isActive ? FontWeight.w600 : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

/// A upload/download progress indicator with file info.
///
/// Example:
/// ```dart
/// AppFileProgress(
///   fileName: 'document.pdf',
///   progress: 0.65,
///   fileSize: '2.4 MB',
/// )
/// ```
class AppFileProgress extends StatelessWidget {
  /// File name.
  final String fileName;

  /// Progress value (0.0 to 1.0).
  final double progress;

  /// File size text.
  final String? fileSize;

  /// Whether the operation is paused.
  final bool isPaused;

  /// Whether there's an error.
  final bool hasError;

  /// Error message.
  final String? errorMessage;

  /// Callback when cancel is pressed.
  final VoidCallback? onCancel;

  /// Callback when retry is pressed.
  final VoidCallback? onRetry;

  /// Creates an [AppFileProgress].
  const AppFileProgress({
    super.key,
    required this.fileName,
    required this.progress,
    this.fileSize,
    this.isPaused = false,
    this.hasError = false,
    this.errorMessage,
    this.onCancel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = hasError
        ? AppColors.error
        : isPaused
            ? AppColors.warning
            : AppColors.primary;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: hasError
              ? AppColors.error.withValues(alpha: 0.3)
              : (isDark
                  ? AppColors.contrastLowDark
                  : AppColors.contrastLowLight),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                hasError
                    ? Icons.error_outline
                    : Icons.insert_drive_file_outlined,
                size: 20.sp,
                color: color,
              ),
              AppSpacing.horizontalXs,
              Expanded(
                child: Text(
                  fileName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasError && onRetry != null)
                IconButton(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh, size: 20.sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColors.primary,
                )
              else if (onCancel != null)
                IconButton(
                  onPressed: onCancel,
                  icon: Icon(Icons.close, size: 20.sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: isDark
                      ? AppColors.contrastMediumDark
                      : AppColors.contrastMediumLight,
                ),
            ],
          ),
          AppSpacing.verticalXs,
          AppLinearProgress(
            value: progress,
            variant: hasError
                ? AppProgressVariant.error
                : isPaused
                    ? AppProgressVariant.warning
                    : AppProgressVariant.primary,
          ),
          AppSpacing.verticalXxs,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hasError
                    ? (errorMessage ?? 'Upload failed')
                    : isPaused
                        ? 'Paused'
                        : '${(progress * 100).toInt()}%',
                style: AppTypography.caption.copyWith(
                  color: hasError
                      ? AppColors.error
                      : (isDark
                          ? AppColors.contrastMediumDark
                          : AppColors.contrastMediumLight),
                ),
              ),
              if (fileSize != null)
                Text(
                  fileSize!,
                  style: AppTypography.caption.copyWith(
                    color: isDark
                        ? AppColors.contrastMediumDark
                        : AppColors.contrastMediumLight,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
