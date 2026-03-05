import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';

/// Themed [RefreshIndicator] using DS colors and parameters.
///
/// Ensures consistent pull-to-refresh styling across:
/// habits list, today view, notifications, payment history, tasks, inbox, etc.
///
/// Usage:
/// ```dart
/// AppRefreshIndicator(
///   onRefresh: viewModel.refresh,
///   child: ListView(...),
/// )
/// ```
class AppRefreshIndicator extends StatelessWidget {
  /// Called when the user pulls to refresh.
  final Future<void> Function() onRefresh;

  /// Scrollable child widget.
  final Widget child;

  /// Indicator color. Defaults to [AppColors.primary].
  final Color? color;

  /// Background color of the indicator.
  final Color? backgroundColor;

  /// Distance from the top before the indicator triggers.
  final double displacement;

  /// Stroke width of the indicator.
  final double strokeWidth;

  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
    this.backgroundColor,
    this.displacement = 40.0,
    this.strokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? AppColors.primary,
      backgroundColor: backgroundColor ??
          (brightness == Brightness.dark
              ? AppColors.surfaceDark
              : AppColors.white),
      displacement: displacement,
      strokeWidth: strokeWidth.w,
      child: child,
    );
  }
}
