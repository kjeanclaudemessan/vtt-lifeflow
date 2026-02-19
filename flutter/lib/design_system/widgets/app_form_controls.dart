import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// A styled switch component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppSwitch(
///   value: _isEnabled,
///   onChanged: (value) => setState(() => _isEnabled = value),
///   label: 'Enable notifications',
/// );
/// ```
class AppSwitch extends StatelessWidget {
  /// Whether the switch is on.
  final bool value;

  /// Callback when the switch is toggled.
  final ValueChanged<bool>? onChanged;

  /// Optional label for the switch.
  final String? label;

  /// Optional subtitle/description.
  final String? subtitle;

  /// Whether the switch is disabled.
  final bool isDisabled;

  /// Position of the label relative to the switch.
  final AppSwitchLabelPosition labelPosition;

  /// Creates an [AppSwitch].
  const AppSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.subtitle,
    this.isDisabled = false,
    this.labelPosition = AppSwitchLabelPosition.left,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (label == null) {
      return _buildSwitch(isDark);
    }

    final labelWidget = _buildLabel(isDark);
    final switchWidget = _buildSwitch(isDark);

    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged?.call(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: labelPosition == AppSwitchLabelPosition.left
            ? [labelWidget, SizedBox(width: 12.w), switchWidget]
            : [switchWidget, SizedBox(width: 12.w), labelWidget],
      ),
    );
  }

  Widget _buildLabel(bool isDark) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: AppTypography.bodyMedium.copyWith(
              color: isDisabled
                  ? (isDark
                      ? AppColors.textDisabledDark
                      : AppColors.textDisabledLight)
                  : (isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight),
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSwitch(bool isDark) {
    return Switch(
      value: value,
      onChanged: isDisabled ? null : onChanged,
      activeThumbColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
      inactiveThumbColor:
          isDark ? AppColors.contrastMediumDark : AppColors.contrastMediumLight,
      inactiveTrackColor: isDark
          ? AppColors.surfaceSecondaryDark
          : AppColors.surfaceSecondaryLight,
    );
  }
}

/// Label position for switch.
enum AppSwitchLabelPosition {
  /// Label on the left side.
  left,

  /// Label on the right side.
  right,
}

/// A styled checkbox component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppCheckbox(
///   value: _isChecked,
///   onChanged: (value) => setState(() => _isChecked = value),
///   label: 'I agree to the terms',
/// );
/// ```
class AppCheckbox extends StatelessWidget {
  /// Whether the checkbox is checked.
  final bool? value;

  /// Callback when the checkbox is toggled.
  final ValueChanged<bool?>? onChanged;

  /// Optional label for the checkbox.
  final String? label;

  /// Optional subtitle/description.
  final String? subtitle;

  /// Whether the checkbox is disabled.
  final bool isDisabled;

  /// Whether this is a tristate checkbox.
  final bool tristate;

  /// Creates an [AppCheckbox].
  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.subtitle,
    this.isDisabled = false,
    this.tristate = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final checkbox = Checkbox(
      value: value,
      onChanged: isDisabled ? null : onChanged,
      tristate: tristate,
      activeColor: AppColors.primary,
      checkColor: AppColors.textOnPrimary,
      side: BorderSide(
        color: isDark
            ? AppColors.contrastMediumDark
            : AppColors.contrastMediumLight,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r),
      ),
    );

    if (label == null) {
      return checkbox;
    }

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (tristate) {
                onChanged?.call(value == null ? true : (value! ? false : null));
              } else {
                onChanged?.call(!(value ?? false));
              }
            },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          checkbox,
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Text(
                    label!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDisabled
                          ? (isDark
                              ? AppColors.textDisabledDark
                              : AppColors.textDisabledLight)
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight),
                    ),
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A styled radio button component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppRadio<String>(
///   value: 'option1',
///   groupValue: _selectedOption,
///   onChanged: (value) => setState(() => _selectedOption = value),
///   label: 'Option 1',
/// );
/// ```
class AppRadio<T> extends StatelessWidget {
  /// The value of this radio button.
  final T value;

  /// The currently selected value in the group.
  final T? groupValue;

  /// Callback when this radio button is selected.
  final ValueChanged<T?>? onChanged;

  /// Optional label for the radio button.
  final String? label;

  /// Optional subtitle/description.
  final String? subtitle;

  /// Whether the radio button is disabled.
  final bool isDisabled;

  /// Creates an [AppRadio].
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.subtitle,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final radio = Radio<T>.adaptive(
      value: value,
      groupValue: groupValue,
      onChanged: isDisabled ? null : onChanged,
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return isDark
              ? AppColors.textDisabledDark
              : AppColors.textDisabledLight;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return isDark
            ? AppColors.contrastMediumDark
            : AppColors.contrastMediumLight;
      }),
    );

    if (label == null) {
      return radio;
    }

    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged?.call(value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          radio,
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Text(
                    label!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDisabled
                          ? (isDark
                              ? AppColors.textDisabledDark
                              : AppColors.textDisabledLight)
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight),
                    ),
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A group of radio buttons.
///
/// Example:
/// ```dart
/// AppRadioGroup<String>(
///   options: [
///     AppRadioOption(value: 'opt1', label: 'Option 1'),
///     AppRadioOption(value: 'opt2', label: 'Option 2'),
///     AppRadioOption(value: 'opt3', label: 'Option 3'),
///   ],
///   groupValue: _selectedOption,
///   onChanged: (value) => setState(() => _selectedOption = value),
/// );
/// ```
class AppRadioGroup<T> extends StatelessWidget {
  /// List of radio options.
  final List<AppRadioOption<T>> options;

  /// Currently selected value.
  final T? groupValue;

  /// Callback when selection changes.
  final ValueChanged<T?>? onChanged;

  /// Spacing between radio buttons.
  final double spacing;

  /// Layout direction.
  final Axis direction;

  /// Creates an [AppRadioGroup].
  const AppRadioGroup({
    super.key,
    required this.options,
    required this.groupValue,
    this.onChanged,
    this.spacing = 8,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final children = options
        .map(
          (option) => AppRadio<T>(
            value: option.value,
            groupValue: groupValue,
            onChanged: option.isDisabled ? null : onChanged,
            label: option.label,
            subtitle: option.subtitle,
            isDisabled: option.isDisabled,
          ),
        )
        .toList();

    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children
            .expand((w) => [w, SizedBox(height: spacing.h)])
            .take(children.length * 2 - 1)
            .toList(),
      );
    }

    return Wrap(
      spacing: spacing.w,
      runSpacing: spacing.h,
      children: children,
    );
  }
}

/// Option for radio group.
class AppRadioOption<T> {
  /// Option value.
  final T value;

  /// Option label.
  final String label;

  /// Optional subtitle.
  final String? subtitle;

  /// Whether this option is disabled.
  final bool isDisabled;

  /// Creates an [AppRadioOption].
  const AppRadioOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.isDisabled = false,
  });
}
