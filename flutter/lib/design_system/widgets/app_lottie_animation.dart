import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A design-system widget for playing Lottie animations.
///
/// Loads and plays a Lottie JSON animation from an asset path.
/// Provides graceful fallback via [placeholder] when the asset
/// doesn't exist or fails to load.
///
/// ```dart
/// // Simple — auto-plays once
/// AppLottieAnimation(
///   asset: 'assets/lottie/onboarding_habits.json',
///   height: 280,
/// )
///
/// // Looping
/// AppLottieAnimation(
///   asset: 'assets/lottie/onboarding_habits.json',
///   repeat: true,
///   height: 280,
/// )
///
/// // With SVG fallback during development
/// AppLottieAnimation(
///   asset: 'assets/lottie/onboarding_habits.json',
///   placeholder: SvgPicture.asset('assets/images/onboarding/habits.svg'),
///   height: 280,
/// )
/// ```
class AppLottieAnimation extends StatelessWidget {
  /// Path to the Lottie `.json` asset file.
  final String asset;

  /// Widget height.
  final double? height;

  /// Widget width.
  final double? width;

  /// How the animation fits inside the widget bounds.
  final BoxFit fit;

  /// Alignment within the available space.
  final Alignment alignment;

  /// Whether the animation should loop. Defaults to `true`.
  final bool repeat;

  /// Whether to auto-play on mount. Defaults to `true`.
  final bool animate;

  /// Whether to play in reverse.
  final bool reverse;

  /// Fallback widget shown when the `.json` asset fails to load.
  final Widget? placeholder;

  /// Callback when the Lottie composition is loaded.
  /// Use for advanced control (e.g., custom AnimationController).
  final void Function(LottieComposition)? onLoaded;

  const AppLottieAnimation({
    required this.asset,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.repeat = true,
    this.animate = true,
    this.reverse = false,
    this.placeholder,
    this.onLoaded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Lottie.asset(
        asset,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        animate: animate,
        reverse: reverse,
        onLoaded: onLoaded,
        errorBuilder: (context, error, stackTrace) {
          // Graceful fallback — no crash, no broken icon
          return placeholder ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
