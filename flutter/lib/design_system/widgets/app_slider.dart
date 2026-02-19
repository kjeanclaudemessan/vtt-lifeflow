import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// A styled slider component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppSlider(
///   value: 0.5,
///   onChanged: (v) => setState(() => value = v),
///   label: 'Volume',
///   showValue: true,
/// )
/// ```
class AppSlider extends StatelessWidget {
  /// Current value (0.0 to 1.0 or min to max).
  final double value;

  /// Callback when value changes.
  final ValueChanged<double>? onChanged;

  /// Callback when user starts dragging.
  final ValueChanged<double>? onChangeStart;

  /// Callback when user stops dragging.
  final ValueChanged<double>? onChangeEnd;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of discrete divisions (null for continuous).
  final int? divisions;

  /// Optional label above the slider.
  final String? label;

  /// Whether to show the current value.
  final bool showValue;

  /// Custom value formatter.
  final String Function(double)? valueFormatter;

  /// Active track color.
  final Color? activeColor;

  /// Inactive track color.
  final Color? inactiveColor;

  /// Thumb color.
  final Color? thumbColor;

  /// Whether the slider is disabled.
  final bool isDisabled;

  /// Creates an [AppSlider].
  const AppSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showValue = false,
    this.valueFormatter,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor = inactiveColor ??
        (isDark ? AppColors.contrastLowDark : AppColors.contrastLowLight);
    final effectiveThumbColor = thumbColor ?? AppColors.primary;

    final formattedValue = valueFormatter?.call(value) ??
        (max <= 1.0
            ? '${(value * 100).toInt()}%'
            : value.toStringAsFixed(max >= 100 ? 0 : 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showValue)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: AppTypography.labelMedium.copyWith(
                      color: isDisabled
                          ? (isDark
                              ? AppColors.contrastLowDark
                              : AppColors.contrastLowLight)
                          : null,
                    ),
                  ),
                if (showValue)
                  Text(
                    formattedValue,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDisabled
                          ? (isDark
                              ? AppColors.contrastLowDark
                              : AppColors.contrastLowLight)
                          : effectiveActiveColor,
                    ),
                  ),
              ],
            ),
          ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor:
                isDisabled ? effectiveInactiveColor : effectiveActiveColor,
            inactiveTrackColor: effectiveInactiveColor,
            thumbColor:
                isDisabled ? effectiveInactiveColor : effectiveThumbColor,
            overlayColor: effectiveActiveColor.withValues(alpha: 0.12),
            trackHeight: 4.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.r),
            tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 2.r),
            activeTickMarkColor: AppColors.white,
            inactiveTickMarkColor: effectiveActiveColor.withValues(alpha: 0.5),
          ),
          child: Slider(
            value: value,
            onChanged: isDisabled ? null : onChanged,
            onChangeStart: isDisabled ? null : onChangeStart,
            onChangeEnd: isDisabled ? null : onChangeEnd,
            min: min,
            max: max,
            divisions: divisions,
          ),
        ),
      ],
    );
  }
}

/// A styled range slider component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppRangeSlider(
///   values: RangeValues(20, 80),
///   onChanged: (v) => setState(() => values = v),
///   label: 'Price Range',
///   showValues: true,
///   min: 0,
///   max: 100,
///   valueFormatter: (v) => '\$${v.toInt()}',
/// )
/// ```
class AppRangeSlider extends StatelessWidget {
  /// Current range values.
  final RangeValues values;

  /// Callback when values change.
  final ValueChanged<RangeValues>? onChanged;

  /// Callback when user starts dragging.
  final ValueChanged<RangeValues>? onChangeStart;

  /// Callback when user stops dragging.
  final ValueChanged<RangeValues>? onChangeEnd;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of discrete divisions (null for continuous).
  final int? divisions;

  /// Optional label above the slider.
  final String? label;

  /// Whether to show the current values.
  final bool showValues;

  /// Custom value formatter.
  final String Function(double)? valueFormatter;

  /// Active track color.
  final Color? activeColor;

  /// Inactive track color.
  final Color? inactiveColor;

  /// Whether the slider is disabled.
  final bool isDisabled;

  /// Creates an [AppRangeSlider].
  const AppRangeSlider({
    super.key,
    required this.values,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showValues = false,
    this.valueFormatter,
    this.activeColor,
    this.inactiveColor,
    this.isDisabled = false,
  });

  String _formatValue(double value) {
    return valueFormatter?.call(value) ??
        (max <= 1.0
            ? '${(value * 100).toInt()}%'
            : value.toStringAsFixed(max >= 100 ? 0 : 1));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor = inactiveColor ??
        (isDark ? AppColors.contrastLowDark : AppColors.contrastLowLight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showValues)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: AppTypography.labelMedium.copyWith(
                      color: isDisabled
                          ? (isDark
                              ? AppColors.contrastLowDark
                              : AppColors.contrastLowLight)
                          : null,
                    ),
                  ),
                if (showValues)
                  Text(
                    '${_formatValue(values.start)} - ${_formatValue(values.end)}',
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDisabled
                          ? (isDark
                              ? AppColors.contrastLowDark
                              : AppColors.contrastLowLight)
                          : effectiveActiveColor,
                    ),
                  ),
              ],
            ),
          ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor:
                isDisabled ? effectiveInactiveColor : effectiveActiveColor,
            inactiveTrackColor: effectiveInactiveColor,
            thumbColor:
                isDisabled ? effectiveInactiveColor : effectiveActiveColor,
            overlayColor: effectiveActiveColor.withValues(alpha: 0.12),
            trackHeight: 4.h,
            rangeThumbShape:
                RoundRangeSliderThumbShape(enabledThumbRadius: 10.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.r),
            rangeTickMarkShape: RoundRangeSliderTickMarkShape(
              tickMarkRadius: 2.r,
            ),
            activeTickMarkColor: AppColors.white,
            inactiveTickMarkColor: effectiveActiveColor.withValues(alpha: 0.5),
          ),
          child: RangeSlider(
            values: values,
            onChanged: isDisabled ? null : onChanged,
            onChangeStart: isDisabled ? null : onChangeStart,
            onChangeEnd: isDisabled ? null : onChangeEnd,
            min: min,
            max: max,
            divisions: divisions,
          ),
        ),
      ],
    );
  }
}

/// A slider with labeled marks at specific positions.
///
/// Example:
/// ```dart
/// AppMarkedSlider(
///   value: 2,
///   marks: ['Low', 'Medium', 'High', 'Very High'],
///   onChanged: (v) => setState(() => value = v),
/// )
/// ```
class AppMarkedSlider extends StatelessWidget {
  /// Current value (index of the mark).
  final int value;

  /// List of mark labels.
  final List<String> marks;

  /// Callback when value changes.
  final ValueChanged<int>? onChanged;

  /// Optional label above the slider.
  final String? label;

  /// Active track color.
  final Color? activeColor;

  /// Whether the slider is disabled.
  final bool isDisabled;

  /// Creates an [AppMarkedSlider].
  const AppMarkedSlider({
    super.key,
    required this.value,
    required this.marks,
    this.onChanged,
    this.label,
    this.activeColor,
    this.isDisabled = false,
  }) : assert(marks.length >= 2, 'At least 2 marks are required');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final disabledColor =
        isDark ? AppColors.contrastLowDark : AppColors.contrastLowLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label!,
                  style: AppTypography.labelMedium.copyWith(
                    color: isDisabled ? disabledColor : null,
                  ),
                ),
                Text(
                  marks[value],
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDisabled ? disabledColor : effectiveActiveColor,
                  ),
                ),
              ],
            ),
          ),
        AppSlider(
          value: value.toDouble(),
          min: 0,
          max: (marks.length - 1).toDouble(),
          divisions: marks.length - 1,
          onChanged: isDisabled ? null : (v) => onChanged?.call(v.round()),
          activeColor: activeColor,
          isDisabled: isDisabled,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: marks
                .asMap()
                .entries
                .map(
                  (entry) => Text(
                    entry.value,
                    style: AppTypography.caption.copyWith(
                      color: isDisabled
                          ? disabledColor
                          : (entry.key == value
                              ? effectiveActiveColor
                              : (isDark
                                  ? AppColors.contrastMediumDark
                                  : AppColors.contrastMediumLight)),
                      fontWeight: entry.key == value ? FontWeight.w600 : null,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
