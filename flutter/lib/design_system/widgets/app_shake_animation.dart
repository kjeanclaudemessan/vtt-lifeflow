import 'dart:math';

import 'package:flutter/material.dart';

import '../tokens/app_animations.dart';

/// A widget that applies a horizontal shake animation to its child.
///
/// Use this to draw attention to validation errors or invalid actions.
///
/// Example:
/// ```dart
/// AppShakeAnimation(
///   shake: viewModel.hasError,
///   child: AppTextField(label: 'Name', errorText: viewModel.nameError),
/// )
/// ```
class AppShakeAnimation extends StatefulWidget {
  /// Whether to trigger the shake animation.
  final bool shake;

  /// The child widget to shake.
  final Widget child;

  /// Duration of the shake animation.
  final Duration duration;

  /// Maximum horizontal offset in pixels.
  final double offset;

  /// Creates an [AppShakeAnimation].
  const AppShakeAnimation({
    super.key,
    required this.shake,
    required this.child,
    this.duration = AppAnimations.slow,
    this.offset = 10.0,
  });

  @override
  State<AppShakeAnimation> createState() => _AppShakeAnimationState();
}

class _AppShakeAnimationState extends State<AppShakeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );
  }

  @override
  void didUpdateWidget(covariant AppShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      _controller.forward(from: 0).then((_) {
        if (mounted) _controller.reset();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final sineValue = sin(4 * pi * _animation.value);
        return Transform.translate(
          offset: Offset(sineValue * widget.offset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
