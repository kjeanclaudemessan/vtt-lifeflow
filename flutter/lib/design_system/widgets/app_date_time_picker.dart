import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// A styled date picker field following Porsche Design System.
///
/// This component opens a themed date picker dialog that respects
/// the Porsche Design System color palette and styling.
///
/// Example:
/// ```dart
/// AppDatePicker(
///   value: _selectedDate,
///   onChanged: (date) => setState(() => _selectedDate = date),
///   label: 'Birth Date',
///   hint: 'Select your birth date',
/// );
/// ```
class AppDatePicker extends StatelessWidget {
  /// Currently selected date.
  final DateTime? value;

  /// Callback when date is selected.
  final ValueChanged<DateTime?>? onChanged;

  /// Label above the field.
  final String? label;

  /// Hint text when no date is selected.
  final String? hint;

  /// Helper text below the field.
  final String? helperText;

  /// Error text (shows error state).
  final String? errorText;

  /// Whether the field is disabled.
  final bool isDisabled;

  /// Whether the field is required.
  final bool isRequired;

  /// Minimum selectable date.
  final DateTime? firstDate;

  /// Maximum selectable date.
  final DateTime? lastDate;

  /// Initial date to show in picker.
  final DateTime? initialDate;

  /// Date format pattern (e.g., 'dd/MM/yyyy').
  final String dateFormat;

  /// Custom date formatter function.
  final String Function(DateTime)? formatter;

  /// Whether to show a clear button.
  final bool showClearButton;

  /// Custom icon.
  final IconData? icon;

  /// Creates an [AppDatePicker].
  const AppDatePicker({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.isDisabled = false,
    this.isRequired = false,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.dateFormat = 'dd/MM/yyyy',
    this.formatter,
    this.showClearButton = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              if (isRequired) ...[
                SizedBox(width: 4.w),
                Text(
                  '*',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
        ],

        // Field
        GestureDetector(
          onTap: isDisabled ? null : () => _showPicker(context),
          child: Container(
            padding: AppSpacing.inputPadding,
            decoration: BoxDecoration(
              borderRadius: AppRadius.input,
              border: Border.all(
                color: hasError
                    ? AppColors.error
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: hasError ? 2 : 1,
              ),
              color: isDisabled
                  ? (isDark
                      ? AppColors.surfaceSecondaryDark
                      : AppColors.surfaceSecondaryLight)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null
                        ? _formatDate(value!)
                        : (hint ?? 'Select date'),
                    style: AppTypography.bodyMedium.copyWith(
                      color: value != null
                          ? (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight)
                          : (isDark
                              ? AppColors.textDisabledDark
                              : AppColors.textDisabledLight),
                    ),
                  ),
                ),
                if (showClearButton && value != null && !isDisabled) ...[
                  GestureDetector(
                    onTap: () => onChanged?.call(null),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18.sp,
                        color: isDark
                            ? AppColors.contrastMediumDark
                            : AppColors.contrastMediumLight,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                ],
                Icon(
                  icon ?? Icons.calendar_today_rounded,
                  size: 20.sp,
                  color: isDisabled
                      ? (isDark
                          ? AppColors.textDisabledDark
                          : AppColors.textDisabledLight)
                      : (isDark
                          ? AppColors.contrastHighDark
                          : AppColors.contrastHighLight),
                ),
              ],
            ),
          ),
        ),

        // Helper/Error text
        if (helperText != null || errorText != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorText ?? helperText!,
            style: AppTypography.bodySmall.copyWith(
              color: hasError
                  ? AppColors.error
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    if (formatter != null) {
      return formatter!(date);
    }
    return DateFormat(dateFormat).format(date);
  }

  Future<void> _showPicker(BuildContext context) async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: value ?? initialDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) => _buildThemedPicker(context, child),
    );

    if (result != null) {
      onChanged?.call(result);
    }
  }

  Widget _buildThemedPicker(BuildContext context, Widget? child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.textOnPrimary,
          secondary: AppColors.primary,
          onSecondary: AppColors.textOnPrimary,
          error: AppColors.error,
          onError: AppColors.textOnPrimary,
          surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          onSurface:
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.labelLarge,
          ),
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor:
              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          headerBackgroundColor: AppColors.primary,
          headerForegroundColor: AppColors.textOnPrimary,
          dayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.textOnPrimary;
            }
            if (states.contains(WidgetState.disabled)) {
              return isDark
                  ? AppColors.textDisabledDark
                  : AppColors.textDisabledLight;
            }
            return isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight;
          }),
          dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          }),
          todayForegroundColor: WidgetStateProperty.all(AppColors.primary),
          todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
          todayBorder: const BorderSide(color: AppColors.primary, width: 1),
          yearForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.textOnPrimary;
            }
            return isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight;
          }),
          yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          }),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
          dayShape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: AppRadius.xs),
          ),
        ),
        dialogTheme: DialogThemeData(
            backgroundColor:
                isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
      ),
      child: child!,
    );
  }
}

/// A styled time picker field following Porsche Design System.
///
/// Example:
/// ```dart
/// AppTimePicker(
///   value: _selectedTime,
///   onChanged: (time) => setState(() => _selectedTime = time),
///   label: 'Meeting Time',
/// );
/// ```
class AppTimePicker extends StatelessWidget {
  /// Currently selected time.
  final TimeOfDay? value;

  /// Callback when time is selected.
  final ValueChanged<TimeOfDay?>? onChanged;

  /// Label above the field.
  final String? label;

  /// Hint text when no time is selected.
  final String? hint;

  /// Helper text below the field.
  final String? helperText;

  /// Error text (shows error state).
  final String? errorText;

  /// Whether the field is disabled.
  final bool isDisabled;

  /// Whether the field is required.
  final bool isRequired;

  /// Whether to use 24-hour format.
  final bool use24HourFormat;

  /// Custom time formatter function.
  final String Function(TimeOfDay)? formatter;

  /// Whether to show a clear button.
  final bool showClearButton;

  /// Custom icon.
  final IconData? icon;

  /// Creates an [AppTimePicker].
  const AppTimePicker({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.isDisabled = false,
    this.isRequired = false,
    this.use24HourFormat = false,
    this.formatter,
    this.showClearButton = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              if (isRequired) ...[
                SizedBox(width: 4.w),
                Text(
                  '*',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
        ],

        // Field
        GestureDetector(
          onTap: isDisabled ? null : () => _showPicker(context),
          child: Container(
            padding: AppSpacing.inputPadding,
            decoration: BoxDecoration(
              borderRadius: AppRadius.input,
              border: Border.all(
                color: hasError
                    ? AppColors.error
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: hasError ? 2 : 1,
              ),
              color: isDisabled
                  ? (isDark
                      ? AppColors.surfaceSecondaryDark
                      : AppColors.surfaceSecondaryLight)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null
                        ? _formatTime(context, value!)
                        : (hint ?? 'Select time'),
                    style: AppTypography.bodyMedium.copyWith(
                      color: value != null
                          ? (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight)
                          : (isDark
                              ? AppColors.textDisabledDark
                              : AppColors.textDisabledLight),
                    ),
                  ),
                ),
                if (showClearButton && value != null && !isDisabled) ...[
                  GestureDetector(
                    onTap: () => onChanged?.call(null),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18.sp,
                        color: isDark
                            ? AppColors.contrastMediumDark
                            : AppColors.contrastMediumLight,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                ],
                Icon(
                  icon ?? Icons.access_time_rounded,
                  size: 20.sp,
                  color: isDisabled
                      ? (isDark
                          ? AppColors.textDisabledDark
                          : AppColors.textDisabledLight)
                      : (isDark
                          ? AppColors.contrastHighDark
                          : AppColors.contrastHighLight),
                ),
              ],
            ),
          ),
        ),

        // Helper/Error text
        if (helperText != null || errorText != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorText ?? helperText!,
            style: AppTypography.bodySmall.copyWith(
              color: hasError
                  ? AppColors.error
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
            ),
          ),
        ],
      ],
    );
  }

  String _formatTime(BuildContext context, TimeOfDay time) {
    if (formatter != null) {
      return formatter!(time);
    }

    if (use24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> _showPicker(BuildContext context) async {
    final result = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
      builder: (context, child) => _buildThemedPicker(context, child),
    );

    if (result != null) {
      onChanged?.call(result);
    }
  }

  Widget _buildThemedPicker(BuildContext context, Widget? child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.textOnPrimary,
          secondary: AppColors.primary,
          onSecondary: AppColors.textOnPrimary,
          error: AppColors.error,
          onError: AppColors.textOnPrimary,
          surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          onSurface:
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.labelLarge,
          ),
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor:
              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          hourMinuteColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary.withValues(alpha: 0.2);
            }
            return isDark
                ? AppColors.surfaceSecondaryDark
                : AppColors.surfaceSecondaryLight;
          }),
          hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight;
          }),
          dayPeriodColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          }),
          dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.textOnPrimary;
            }
            return isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight;
          }),
          dialHandColor: AppColors.primary,
          dialBackgroundColor: isDark
              ? AppColors.surfaceSecondaryDark
              : AppColors.surfaceSecondaryLight,
          dialTextColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.textOnPrimary;
            }
            return isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight;
          }),
          entryModeIconColor: AppColors.primary,
          helpTextStyle: AppTypography.labelSmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
          hourMinuteShape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          dayPeriodShape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          dayPeriodBorderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        dialogTheme: DialogThemeData(
            backgroundColor:
                isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
      ),
      child: child!,
    );
  }
}

/// A styled date range picker field following Porsche Design System.
///
/// Example:
/// ```dart
/// AppDateRangePicker(
///   value: _dateRange,
///   onChanged: (range) => setState(() => _dateRange = range),
///   label: 'Trip Dates',
/// );
/// ```
class AppDateRangePicker extends StatelessWidget {
  /// Currently selected date range.
  final DateTimeRange? value;

  /// Callback when date range is selected.
  final ValueChanged<DateTimeRange?>? onChanged;

  /// Label above the field.
  final String? label;

  /// Hint text when no range is selected.
  final String? hint;

  /// Helper text below the field.
  final String? helperText;

  /// Error text (shows error state).
  final String? errorText;

  /// Whether the field is disabled.
  final bool isDisabled;

  /// Whether the field is required.
  final bool isRequired;

  /// Minimum selectable date.
  final DateTime? firstDate;

  /// Maximum selectable date.
  final DateTime? lastDate;

  /// Date format pattern.
  final String dateFormat;

  /// Whether to show a clear button.
  final bool showClearButton;

  /// Creates an [AppDateRangePicker].
  const AppDateRangePicker({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.isDisabled = false,
    this.isRequired = false,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'dd/MM/yyyy',
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = errorText != null;
    final formatter = DateFormat(dateFormat);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              if (isRequired) ...[
                SizedBox(width: 4.w),
                Text(
                  '*',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
        ],

        // Field
        GestureDetector(
          onTap: isDisabled ? null : () => _showPicker(context),
          child: Container(
            padding: AppSpacing.inputPadding,
            decoration: BoxDecoration(
              borderRadius: AppRadius.input,
              border: Border.all(
                color: hasError
                    ? AppColors.error
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: hasError ? 2 : 1,
              ),
              color: isDisabled
                  ? (isDark
                      ? AppColors.surfaceSecondaryDark
                      : AppColors.surfaceSecondaryLight)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null
                        ? '${formatter.format(value!.start)} - ${formatter.format(value!.end)}'
                        : (hint ?? 'Select date range'),
                    style: AppTypography.bodyMedium.copyWith(
                      color: value != null
                          ? (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight)
                          : (isDark
                              ? AppColors.textDisabledDark
                              : AppColors.textDisabledLight),
                    ),
                  ),
                ),
                if (showClearButton && value != null && !isDisabled) ...[
                  GestureDetector(
                    onTap: () => onChanged?.call(null),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18.sp,
                        color: isDark
                            ? AppColors.contrastMediumDark
                            : AppColors.contrastMediumLight,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                ],
                Icon(
                  Icons.date_range_rounded,
                  size: 20.sp,
                  color: isDisabled
                      ? (isDark
                          ? AppColors.textDisabledDark
                          : AppColors.textDisabledLight)
                      : (isDark
                          ? AppColors.contrastHighDark
                          : AppColors.contrastHighLight),
                ),
              ],
            ),
          ),
        ),

        // Helper/Error text
        if (helperText != null || errorText != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorText ?? helperText!,
            style: AppTypography.bodySmall.copyWith(
              color: hasError
                  ? AppColors.error
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = await showDateRangePicker(
      context: context,
      initialDateRange: value,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: isDark ? Brightness.dark : Brightness.light,
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              secondary: AppColors.primary,
              onSecondary: AppColors.textOnPrimary,
              error: AppColors.error,
              onError: AppColors.textOnPrimary,
              surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              onSurface: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            dialogTheme: DialogThemeData(
                backgroundColor:
                    isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      onChanged?.call(result);
    }
  }
}
