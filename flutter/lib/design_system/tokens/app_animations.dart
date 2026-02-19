import 'package:flutter/material.dart';

/// ============================================
/// DESIGN SYSTEM - ANIMATIONS
/// Animation durations and curves
/// ============================================

class AppAnimations {
  AppAnimations._();

  // ─────────────────────────────────────────────
  // DURATIONS
  // ─────────────────────────────────────────────

  /// Instant - 0ms (no animation).
  static const Duration instant = Duration.zero;

  /// Extra fast - 100ms.
  static const Duration extraFast = Duration(milliseconds: 100);

  /// Fast - 150ms.
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal - 200ms.
  static const Duration normal = Duration(milliseconds: 200);

  /// Medium - 300ms (default for most animations).
  static const Duration medium = Duration(milliseconds: 300);

  /// Slow - 400ms.
  static const Duration slow = Duration(milliseconds: 400);

  /// Extra slow - 500ms.
  static const Duration extraSlow = Duration(milliseconds: 500);

  /// Very slow - 600ms.
  static const Duration verySlow = Duration(milliseconds: 600);

  // ─────────────────────────────────────────────
  // CURVES
  // ─────────────────────────────────────────────

  /// Default ease curve - smooth start and end.
  static const Curve defaultCurve = Curves.easeInOut;

  /// Ease out - fast start, slow end (for entrances).
  static const Curve easeOut = Curves.easeOut;

  /// Ease in - slow start, fast end (for exits).
  static const Curve easeIn = Curves.easeIn;

  /// Ease out cubic - more pronounced ease out.
  static const Curve easeOutCubic = Curves.easeOutCubic;

  /// Ease in out cubic - smooth acceleration/deceleration.
  static const Curve easeInOutCubic = Curves.easeInOutCubic;

  /// Spring curve - bouncy effect.
  static const Curve spring = Curves.elasticOut;

  /// Bounce - bouncing effect.
  static const Curve bounce = Curves.bounceOut;

  /// Decelerate - smooth deceleration.
  static const Curve decelerate = Curves.decelerate;

  /// Linear - constant speed.
  static const Curve linear = Curves.linear;

  // ─────────────────────────────────────────────
  // COMPONENT-SPECIFIC PRESETS
  // ─────────────────────────────────────────────

  /// Page transition duration.
  static const Duration pageTransition = medium;

  /// Page transition curve.
  static const Curve pageTransitionCurve = easeOutCubic;

  /// Modal entry duration.
  static const Duration modalEntry = medium;

  /// Modal exit duration.
  static const Duration modalExit = normal;

  /// Button press duration.
  static const Duration buttonPress = fast;

  /// Button press curve.
  static const Curve buttonPressCurve = easeOut;

  /// Fade duration.
  static const Duration fade = normal;

  /// Expand/collapse duration.
  static const Duration expand = medium;

  /// Expand/collapse curve.
  static const Curve expandCurve = easeInOutCubic;

  /// List item stagger delay.
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Shimmer animation duration.
  static const Duration shimmer = Duration(milliseconds: 1500);

  /// Pulse animation duration.
  static const Duration pulse = Duration(milliseconds: 1500);

  /// Rotation duration (full 360°).
  static const Duration rotation = Duration(milliseconds: 1000);

  // ─────────────────────────────────────────────
  // HELPER METHODS
  // ─────────────────────────────────────────────

  /// Creates a staggered delay for list animations.
  static Duration staggeredDelay(int index, {int maxDelay = 10}) {
    final clampedIndex = index.clamp(0, maxDelay);
    return Duration(milliseconds: clampedIndex * 50);
  }

  /// Creates a page route with custom transition.
  static PageRouteBuilder<T> fadeRoute<T>({
    required Widget page,
    Duration duration = medium,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Creates a slide up page route.
  static PageRouteBuilder<T> slideUpRoute<T>({
    required Widget page,
    Duration duration = medium,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: easeOutCubic),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Creates a scale page route.
  static PageRouteBuilder<T> scaleRoute<T>({
    required Widget page,
    Duration duration = medium,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: 0.9, end: 1.0).chain(
          CurveTween(curve: easeOutCubic),
        );
        return ScaleTransition(
          scale: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}
