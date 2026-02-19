import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// Tooltip position relative to the child.
enum AppTooltipPosition {
  /// Above the child.
  top,

  /// Below the child.
  bottom,

  /// To the left of the child.
  left,

  /// To the right of the child.
  right,
}

/// A styled tooltip component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppTooltip(
///   message: 'Click to save',
///   child: IconButton(
///     icon: Icon(Icons.save),
///     onPressed: () {},
///   ),
/// )
/// ```
class AppTooltip extends StatelessWidget {
  /// The widget that triggers the tooltip.
  final Widget child;

  /// The tooltip message.
  final String message;

  /// Custom rich message (overrides message).
  final InlineSpan? richMessage;

  /// Preferred position of the tooltip.
  final AppTooltipPosition? preferredPosition;

  /// Duration before tooltip appears.
  final Duration? waitDuration;

  /// Duration tooltip stays visible.
  final Duration? showDuration;

  /// Custom padding inside tooltip.
  final EdgeInsetsGeometry? padding;

  /// Custom margin around tooltip.
  final EdgeInsetsGeometry? margin;

  /// Custom height (for vertical offset).
  final double? verticalOffset;

  /// Whether the tooltip should be shown on tap (mobile-friendly).
  final bool triggerMode;

  /// Custom decoration.
  final Decoration? decoration;

  /// Custom text style.
  final TextStyle? textStyle;

  /// Whether to exclude the tooltip from semantics.
  final bool excludeFromSemantics;

  /// Creates an [AppTooltip].
  const AppTooltip({
    super.key,
    required this.child,
    required this.message,
    this.richMessage,
    this.preferredPosition,
    this.waitDuration,
    this.showDuration,
    this.padding,
    this.margin,
    this.verticalOffset,
    this.triggerMode = false,
    this.decoration,
    this.textStyle,
    this.excludeFromSemantics = false,
  });

  /// Creates an info tooltip.
  const AppTooltip.info({
    super.key,
    required this.child,
    required this.message,
    this.preferredPosition,
  })  : richMessage = null,
        waitDuration = null,
        showDuration = null,
        padding = null,
        margin = null,
        verticalOffset = null,
        triggerMode = false,
        decoration = null,
        textStyle = null,
        excludeFromSemantics = false;

  /// Creates a long-press tooltip (mobile-friendly).
  const AppTooltip.longPress({
    super.key,
    required this.child,
    required this.message,
    this.preferredPosition,
  })  : richMessage = null,
        waitDuration = const Duration(milliseconds: 0),
        showDuration = const Duration(seconds: 2),
        padding = null,
        margin = null,
        verticalOffset = null,
        triggerMode = true,
        decoration = null,
        textStyle = null,
        excludeFromSemantics = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: message,
      richMessage: richMessage,
      waitDuration: waitDuration ?? const Duration(milliseconds: 500),
      showDuration: showDuration ?? const Duration(seconds: 1),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w),
      verticalOffset: verticalOffset ?? _getVerticalOffset(),
      preferBelow: _preferBelow(),
      decoration: decoration ?? _buildDecoration(isDark),
      textStyle: textStyle ?? _buildTextStyle(isDark),
      triggerMode:
          triggerMode ? TooltipTriggerMode.tap : TooltipTriggerMode.longPress,
      excludeFromSemantics: excludeFromSemantics,
      child: child,
    );
  }

  double _getVerticalOffset() {
    switch (preferredPosition) {
      case AppTooltipPosition.top:
      case AppTooltipPosition.bottom:
        return 24.h;
      case AppTooltipPosition.left:
      case AppTooltipPosition.right:
        return 0;
      default:
        return 24.h;
    }
  }

  bool _preferBelow() {
    switch (preferredPosition) {
      case AppTooltipPosition.top:
        return false;
      case AppTooltipPosition.bottom:
        return true;
      default:
        return true;
    }
  }

  BoxDecoration _buildDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.surfaceLight : AppColors.contrastHighLight,
      borderRadius: AppRadius.sm,
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.15),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  TextStyle _buildTextStyle(bool isDark) {
    return AppTypography.bodySmall.copyWith(
      color: isDark ? AppColors.textPrimaryLight : AppColors.white,
    );
  }
}

/// A styled tooltip trigger that shows an info icon.
///
/// Example:
/// ```dart
/// AppTooltipIcon(
///   message: 'This is helpful information',
/// )
/// ```
class AppTooltipIcon extends StatelessWidget {
  /// The tooltip message.
  final String message;

  /// Icon to display.
  final IconData icon;

  /// Icon size.
  final double? iconSize;

  /// Icon color.
  final Color? iconColor;

  /// Creates an [AppTooltipIcon].
  const AppTooltipIcon({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppTooltip(
      message: message,
      child: Icon(
        icon,
        size: iconSize ?? 18.sp,
        color: iconColor ??
            (isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight),
      ),
    );
  }
}
