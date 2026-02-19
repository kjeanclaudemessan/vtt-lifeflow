import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// A styled segmented button component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppSegmentedButton<String>(
///   segments: [
///     AppSegment(value: 'day', label: 'Day'),
///     AppSegment(value: 'week', label: 'Week'),
///     AppSegment(value: 'month', label: 'Month'),
///   ],
///   selected: _selectedView,
///   onChanged: (value) => setState(() => _selectedView = value),
/// );
/// ```
class AppSegmentedButton<T> extends StatelessWidget {
  /// List of segments.
  final List<AppSegment<T>> segments;

  /// Currently selected value.
  final T selected;

  /// Callback when selection changes.
  final ValueChanged<T> onChanged;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// Whether segments can have icons only.
  final bool showLabels;

  /// Size of the segmented button.
  final AppSegmentedButtonSize size;

  /// Creates an [AppSegmentedButton].
  const AppSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.isDisabled = false,
    this.showLabels = true,
    this.size = AppSegmentedButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceSecondaryDark
            : AppColors.surfaceSecondaryLight,
        borderRadius: AppRadius.sm,
      ),
      padding: EdgeInsets.all(4.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: segments.map((segment) {
          final isSelected = segment.value == selected;
          return _SegmentButton(
            segment: segment,
            isSelected: isSelected,
            isDisabled: isDisabled || segment.isDisabled,
            showLabel: showLabels,
            size: size,
            isDark: isDark,
            onTap: () {
              if (!isDisabled && !segment.isDisabled) {
                onChanged(segment.value);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

/// Individual segment button.
class _SegmentButton<T> extends StatelessWidget {
  final AppSegment<T> segment;
  final bool isSelected;
  final bool isDisabled;
  final bool showLabel;
  final AppSegmentedButtonSize size;
  final bool isDark;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.segment,
    required this.isSelected,
    required this.isDisabled,
    required this.showLabel,
    required this.size,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final padding = _getPadding();
    final textColor = _getTextColor();
    final backgroundColor = _getBackgroundColor();

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (segment.icon != null) ...[
              Icon(
                segment.icon,
                size: _getIconSize(),
                color: textColor,
              ),
              if (showLabel && segment.label != null) SizedBox(width: 8.w),
            ],
            if (showLabel && segment.label != null)
              Text(
                segment.label!,
                style: _getTextStyle().copyWith(color: textColor),
              ),
          ],
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppSegmentedButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h);
      case AppSegmentedButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
      case AppSegmentedButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppSegmentedButtonSize.small:
        return 16.sp;
      case AppSegmentedButtonSize.medium:
        return 20.sp;
      case AppSegmentedButtonSize.large:
        return 24.sp;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppSegmentedButtonSize.small:
        return AppTypography.labelSmall;
      case AppSegmentedButtonSize.medium:
        return AppTypography.labelMedium;
      case AppSegmentedButtonSize.large:
        return AppTypography.labelLarge;
    }
  }

  Color _getTextColor() {
    if (isDisabled) {
      return isDark
          ? AppColors.textDisabledDark
          : AppColors.textDisabledLight;
    }
    if (isSelected) {
      return isDark
          ? AppColors.textPrimaryDark
          : AppColors.textPrimaryLight;
    }
    return isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      return isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    }
    return Colors.transparent;
  }
}

/// Segment size.
enum AppSegmentedButtonSize {
  small,
  medium,
  large,
}

/// Segment definition.
class AppSegment<T> {
  /// Segment value.
  final T value;

  /// Segment label.
  final String? label;

  /// Segment icon.
  final IconData? icon;

  /// Whether this segment is disabled.
  final bool isDisabled;

  /// Creates an [AppSegment].
  const AppSegment({
    required this.value,
    this.label,
    this.icon,
    this.isDisabled = false,
  }) : assert(label != null || icon != null);
}

/// A styled stepper component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppStepper(
///   currentStep: _currentStep,
///   steps: [
///     AppStep(title: 'Account', subtitle: 'Create your account'),
///     AppStep(title: 'Profile', subtitle: 'Set up your profile'),
///     AppStep(title: 'Complete', subtitle: 'Finish setup'),
///   ],
///   onStepTapped: (step) => setState(() => _currentStep = step),
/// );
/// ```
class AppStepper extends StatelessWidget {
  /// Current active step index.
  final int currentStep;

  /// List of steps.
  final List<AppStep> steps;

  /// Callback when step is tapped.
  final ValueChanged<int>? onStepTapped;

  /// Stepper orientation.
  final Axis orientation;

  /// Creates an [AppStepper].
  const AppStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepTapped,
    this.orientation = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    if (orientation == Axis.horizontal) {
      return _buildHorizontal(context);
    }
    return _buildVertical(context);
  }

  Widget _buildHorizontal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep;
          return Expanded(
            child: Container(
              height: 2.h,
              color: isCompleted
                  ? AppColors.primary
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
          );
        }

        // Step
        final stepIndex = index ~/ 2;
        final step = steps[stepIndex];
        final state = _getStepState(stepIndex);

        return _StepIndicator(
          index: stepIndex,
          step: step,
          state: state,
          isDark: isDark,
          onTap: onStepTapped != null ? () => onStepTapped!(stepIndex) : null,
          orientation: Axis.horizontal,
        );
      }),
    );
  }

  Widget _buildVertical(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep;
          return Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Container(
              width: 2.w,
              height: 40.h,
              color: isCompleted
                  ? AppColors.primary
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
          );
        }

        // Step
        final stepIndex = index ~/ 2;
        final step = steps[stepIndex];
        final state = _getStepState(stepIndex);

        return _StepIndicator(
          index: stepIndex,
          step: step,
          state: state,
          isDark: isDark,
          onTap: onStepTapped != null ? () => onStepTapped!(stepIndex) : null,
          orientation: Axis.vertical,
        );
      }),
    );
  }

  _StepState _getStepState(int index) {
    if (index < currentStep) return _StepState.completed;
    if (index == currentStep) return _StepState.active;
    return _StepState.upcoming;
  }
}

enum _StepState { completed, active, upcoming }

/// Individual step indicator.
class _StepIndicator extends StatelessWidget {
  final int index;
  final AppStep step;
  final _StepState state;
  final bool isDark;
  final VoidCallback? onTap;
  final Axis orientation;

  const _StepIndicator({
    required this.index,
    required this.step,
    required this.state,
    required this.isDark,
    this.onTap,
    required this.orientation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: orientation == Axis.horizontal
          ? _buildHorizontalStep()
          : _buildVerticalStep(),
    );
  }

  Widget _buildHorizontalStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCircle(),
        SizedBox(height: 8.h),
        Text(
          step.title,
          style: AppTypography.labelSmall.copyWith(
            color: _getTitleColor(),
            fontWeight: state == _StepState.active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalStep() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCircle(),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppTypography.labelMedium.copyWith(
                  color: _getTitleColor(),
                  fontWeight: state == _StepState.active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (step.subtitle != null) ...[
                SizedBox(height: 4.h),
                Text(
                  step.subtitle!,
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
    );
  }

  Widget _buildCircle() {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: _getCircleColor(),
        shape: BoxShape.circle,
        border: state == _StepState.upcoming
            ? Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 2,
              )
            : null,
      ),
      child: Center(
        child: state == _StepState.completed
            ? Icon(
                Icons.check_rounded,
                size: 16.sp,
                color: AppColors.textOnPrimary,
              )
            : Text(
                '${index + 1}',
                style: AppTypography.labelMedium.copyWith(
                  color: state == _StepState.active
                      ? AppColors.textOnPrimary
                      : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Color _getCircleColor() {
    switch (state) {
      case _StepState.completed:
        return AppColors.primary;
      case _StepState.active:
        return AppColors.primary;
      case _StepState.upcoming:
        return Colors.transparent;
    }
  }

  Color _getTitleColor() {
    switch (state) {
      case _StepState.completed:
        return AppColors.primary;
      case _StepState.active:
        return isDark
            ? AppColors.textPrimaryDark
            : AppColors.textPrimaryLight;
      case _StepState.upcoming:
        return isDark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight;
    }
  }
}

/// Step definition.
class AppStep {
  /// Step title.
  final String title;

  /// Step subtitle.
  final String? subtitle;

  /// Step icon (for completed state).
  final IconData? icon;

  /// Creates an [AppStep].
  const AppStep({
    required this.title,
    this.subtitle,
    this.icon,
  });
}

/// A styled expansion panel/accordion.
///
/// Example:
/// ```dart
/// AppExpansionPanel(
///   title: 'Frequently Asked Questions',
///   children: [
///     AppExpansionTile(
///       title: 'How do I reset my password?',
///       content: Text('You can reset your password...'),
///     ),
///     AppExpansionTile(
///       title: 'How do I contact support?',
///       content: Text('Contact us at...'),
///     ),
///   ],
/// );
/// ```
class AppExpansionPanel extends StatelessWidget {
  /// Panel title.
  final String? title;

  /// Expansion tiles.
  final List<AppExpansionTile> children;

  /// Whether only one tile can be expanded at a time.
  final bool singleExpansion;

  /// Creates an [AppExpansionPanel].
  const AppExpansionPanel({
    super.key,
    this.title,
    required this.children,
    this.singleExpansion = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppTypography.titleMedium.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 16.h),
        ],
        ...children,
      ],
    );
  }
}

/// Individual expansion tile.
class AppExpansionTile extends StatefulWidget {
  /// Tile title.
  final String title;

  /// Tile subtitle.
  final String? subtitle;

  /// Tile content when expanded.
  final Widget content;

  /// Whether the tile is initially expanded.
  final bool initiallyExpanded;

  /// Leading icon.
  final IconData? leadingIcon;

  /// Callback when expansion changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// Creates an [AppExpansionTile].
  const AppExpansionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.content,
    this.initiallyExpanded = false,
    this.leadingIcon,
    this.onExpansionChanged,
  });

  @override
  State<AppExpansionTile> createState() => _AppExpansionTileState();
}

class _AppExpansionTileState extends State<AppExpansionTile>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeIn));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpansionChanged?.call(_isExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          InkWell(
            onTap: _toggle,
            borderRadius: AppRadius.sm,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  if (widget.leadingIcon != null) ...[
                    Icon(
                      widget.leadingIcon,
                      size: 20.sp,
                      color: isDark
                          ? AppColors.contrastHighDark
                          : AppColors.contrastHighLight,
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            widget.subtitle!,
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
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark
                          ? AppColors.contrastMediumDark
                          : AppColors.contrastMediumLight,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          ClipRect(
            child: AnimatedBuilder(
              animation: _heightFactor,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightFactor.value,
                  child: child,
                );
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: widget.content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
