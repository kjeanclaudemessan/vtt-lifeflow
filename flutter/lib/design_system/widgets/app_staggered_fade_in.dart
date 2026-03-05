import 'package:flutter/material.dart';

import '../tokens/app_animations.dart';

/// A widget that fades in with an upward slide, supporting staggered delays
/// for list item entrance animations.
///
/// Wraps [TweenAnimationBuilder] with [AppAnimations.staggeredDelay] to create
/// a smooth cascading entrance effect when rendering lists.
///
/// ```dart
/// ListView.builder(
///   itemBuilder: (context, index) {
///     return AppStaggeredFadeIn(
///       index: index,
///       child: MyListTile(...),
///     );
///   },
/// )
/// ```
class AppStaggeredFadeIn extends StatelessWidget {
  /// The index of this item in the list (used for stagger delay).
  final int index;

  /// The child widget to animate.
  final Widget child;

  /// Base animation duration before stagger is added.
  /// Defaults to [AppAnimations.medium].
  final Duration? duration;

  /// Animation curve. Defaults to [AppAnimations.easeOut].
  final Curve? curve;

  /// Vertical offset in pixels to slide up from. Defaults to 12.
  final double offsetY;

  /// Maximum index for stagger delay clamping. Defaults to 10.
  final int maxDelay;

  const AppStaggeredFadeIn({
    super.key,
    required this.index,
    required this.child,
    this.duration,
    this.curve,
    this.offsetY = 12,
    this.maxDelay = 10,
  });

  @override
  Widget build(BuildContext context) {
    final baseDuration = duration ?? AppAnimations.medium;
    final animCurve = curve ?? AppAnimations.easeOut;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: baseDuration +
          AppAnimations.staggeredDelay(index, maxDelay: maxDelay),
      curve: animCurve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, offsetY * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
