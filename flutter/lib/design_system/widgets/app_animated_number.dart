import 'package:flutter/material.dart';

import '../tokens/app_animations.dart';

/// Animated number that tweens from a previous value to the current one.
///
/// Useful for counters, scores, timers, budgets — anywhere a number
/// transitions smoothly instead of snapping. Reusable across:
/// - Counter weekly total
/// - Task completion counts
/// - OKR progress numbers
/// - Budget time remaining
///
/// Usage:
/// ```dart
/// AppAnimatedNumber(
///   value: viewModel.totalMinutes,
///   duration: Duration(milliseconds: 1000),
///   builder: (animatedValue) => Text('$animatedValue min'),
/// )
/// ```
class AppAnimatedNumber extends StatelessWidget {
  /// The target integer value to animate to.
  final int value;

  /// Animation duration. Defaults to 1000ms.
  final Duration duration;

  /// Animation curve. Defaults to [AppAnimations.easeOutCubic].
  final Curve curve;

  /// Builder receiving the interpolated integer value.
  final Widget Function(int animatedValue) builder;

  const AppAnimatedNumber({
    super.key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: curve,
      builder: (context, animatedValue, _) => builder(animatedValue),
    );
  }
}

/// Animated double value — for progress bars, percentages, etc.
///
/// Usage:
/// ```dart
/// AppAnimatedDouble(
///   value: viewModel.completionRate,
///   builder: (v) => AppProgressRing.large(value: v),
/// )
/// ```
class AppAnimatedDouble extends StatelessWidget {
  /// The target double value to animate to.
  final double value;

  /// Animation duration. Defaults to 1200ms.
  final Duration duration;

  /// Animation curve. Defaults to [AppAnimations.easeOutCubic].
  final Curve curve;

  /// Builder receiving the interpolated double value.
  final Widget Function(double animatedValue) builder;

  const AppAnimatedDouble({
    super.key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 1200),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: curve,
      builder: (context, animatedValue, _) => builder(animatedValue),
    );
  }
}
