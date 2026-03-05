import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// A reusable week/period navigator with prev/next arrows.
///
/// Used by CounterView, BilanView, and any future weekly/monthly views.
///
/// Example:
/// ```dart
/// AppWeekNavigator(
///   label: '12 jan – 18 jan 2025',
///   isLast: viewModel.isCurrentWeek,
///   onPrevious: viewModel.previousWeek,
///   onNext: viewModel.nextWeek,
///   onLabelTap: viewModel.goToCurrentWeek,
/// )
/// ```
class AppWeekNavigator extends StatelessWidget {
  /// The text label to display (e.g. "12 jan – 18 jan").
  final String label;

  /// Whether this is the last page (disables next button).
  final bool isLast;

  /// Whether this is the first page (disables previous button).
  final bool isFirst;

  /// Called when previous is tapped.
  final VoidCallback? onPrevious;

  /// Called when next is tapped.
  final VoidCallback? onNext;

  /// Called when the label text is tapped (e.g. jump to current period).
  final VoidCallback? onLabelTap;

  /// Tooltip for the previous button.
  final String? previousTooltip;

  /// Tooltip for the next button.
  final String? nextTooltip;

  /// Text style override for the label.
  final TextStyle? labelStyle;

  /// Creates an [AppWeekNavigator].
  const AppWeekNavigator({
    super.key,
    required this.label,
    this.isLast = false,
    this.isFirst = false,
    this.onPrevious,
    this.onNext,
    this.onLabelTap,
    this.previousTooltip,
    this.nextTooltip,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          tooltip: previousTooltip,
          iconSize: 24.sp,
          onPressed: isFirst ? null : onPrevious,
        ),
        Expanded(
          child: GestureDetector(
            onTap: onLabelTap,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: labelStyle ??
                  AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary(brightness),
                  ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right,
            color: isLast
                ? AppColors.textSecondary(brightness).withValues(alpha: 0.3)
                : null,
          ),
          tooltip: nextTooltip,
          iconSize: 24.sp,
          onPressed: isLast ? null : onNext,
        ),
      ],
    );
  }
}
