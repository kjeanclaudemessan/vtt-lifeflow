import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// A design-system widget for playing Rive animations.
///
/// Uses Rive v0.14 API with [RiveWidgetBuilder] + [FileLoader].
///
/// Supports three modes:
/// - **Simple**: Plays the default state machine from the `.riv` file.
/// - **Named state machine**: Drives a specific state machine.
/// - **Fallback**: Shows [placeholder] widget when the `.riv` asset
///   doesn't exist yet (graceful degradation during development).
///
/// ```dart
/// // Simple — plays default state machine
/// AppRiveAnimation(
///   asset: 'assets/rive/onboarding_habits.riv',
///   height: 280,
/// )
///
/// // Named state machine
/// AppRiveAnimation(
///   asset: 'assets/rive/onboarding_habits.riv',
///   stateMachineName: 'idle',
///   height: 280,
/// )
///
/// // Graceful fallback to SVG if .riv doesn't exist yet
/// AppRiveAnimation(
///   asset: 'assets/rive/onboarding_habits.riv',
///   placeholder: SvgPicture.asset('assets/images/onboarding/habits.svg'),
///   height: 280,
/// )
/// ```
class AppRiveAnimation extends StatelessWidget {
  /// Path to the `.riv` asset file.
  final String asset;

  /// Name of the state machine to use (null = default).
  final String? stateMachineName;

  /// Widget height.
  final double? height;

  /// Widget width.
  final double? width;

  /// How the Rive artboard fits inside the widget bounds.
  final BoxFit fit;

  /// Alignment within the available space.
  final Alignment alignment;

  /// Fallback widget shown when the `.riv` asset fails to load.
  /// Useful during development when Rive files are not yet created.
  final Widget? placeholder;

  /// Callback fired when the Rive state is loaded.
  /// Use it to access inputs/triggers on the controller.
  final void Function(RiveLoaded state)? onLoaded;

  const AppRiveAnimation({
    required this.asset,
    this.stateMachineName,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.placeholder,
    this.onLoaded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final stateMachine = stateMachineName != null
        ? StateMachineNamed(stateMachineName!)
        : const StateMachineDefault();

    return SizedBox(
      height: height,
      width: width,
      child: RiveWidgetBuilder(
        fileLoader: FileLoader.fromAsset(
          asset,
          riveFactory: Factory.flutter,
        ),
        stateMachineSelector: stateMachine,
        onLoaded: onLoaded,
        onFailed: (_, __) {
          // Silently handle — fallback is shown via builder
        },
        builder: (context, state) {
          return switch (state) {
            RiveLoaded(:final controller) => RiveWidget(
                controller: controller,
                fit: fit == BoxFit.contain ? Fit.contain : _mapFit(fit),
                alignment: alignment,
              ),
            RiveLoading() => placeholder ?? const SizedBox.shrink(),
            RiveFailed() => placeholder ?? const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  /// Map Flutter [BoxFit] to Rive [Fit].
  static Fit _mapFit(BoxFit boxFit) {
    return switch (boxFit) {
      BoxFit.contain => Fit.contain,
      BoxFit.cover => Fit.cover,
      BoxFit.fill => Fit.fill,
      BoxFit.fitWidth => Fit.fitWidth,
      BoxFit.fitHeight => Fit.fitHeight,
      BoxFit.none => Fit.none,
      _ => Fit.contain,
    };
  }
}

