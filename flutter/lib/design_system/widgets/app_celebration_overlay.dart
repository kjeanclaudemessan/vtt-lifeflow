import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';

/// Confetti celebration overlay — reusable for habit completion,
/// streak milestones, task completion, OKR achievement, etc.
///
/// Usage:
/// ```dart
/// AppCelebrationOverlay(
///   shouldCelebrate: viewModel.justCompletedAll,
///   onComplete: viewModel.clearCelebration,
/// )
/// ```
class AppCelebrationOverlay extends StatefulWidget {
  /// Whether the celebration animation should fire.
  final bool shouldCelebrate;

  /// Called after the celebration animation + delay finishes.
  final VoidCallback onComplete;

  /// Confetti particle colors. Defaults to teal/gold/coral palette.
  final List<Color>? colors;

  /// Number of particles per emission. Defaults to 20.
  final int numberOfParticles;

  /// Duration of the confetti emission. Defaults to 3 seconds.
  final Duration duration;

  /// Delay after emission stops before calling [onComplete].
  /// Defaults to 1 second (so total = duration + delay).
  final Duration completeDelay;

  /// Maximum blast force. Defaults to 30.
  final double maxBlastForce;

  /// Minimum blast force. Defaults to 10.
  final double minBlastForce;

  /// Gravity applied to particles. Defaults to 0.15.
  final double gravity;

  /// Emission frequency (0.0–1.0). Lower = more frequent. Defaults to 0.05.
  final double emissionFrequency;

  /// Alignment of the confetti source. Defaults to [Alignment.topCenter].
  final Alignment alignment;

  const AppCelebrationOverlay({
    super.key,
    required this.shouldCelebrate,
    required this.onComplete,
    this.colors,
    this.numberOfParticles = 20,
    this.duration = const Duration(seconds: 3),
    this.completeDelay = const Duration(seconds: 1),
    this.maxBlastForce = 30,
    this.minBlastForce = 10,
    this.gravity = 0.15,
    this.emissionFrequency = 0.05,
    this.alignment = Alignment.topCenter,
  });

  @override
  State<AppCelebrationOverlay> createState() => _AppCelebrationOverlayState();
}

class _AppCelebrationOverlayState extends State<AppCelebrationOverlay> {
  late final ConfettiController _controller;

  static const _defaultColors = [
    AppColors.primary,
    AppColors.success,
    Color(0xFFFFD700), // Gold
    Color(0xFFFF6B6B), // Coral
    Color(0xFF4ECDC4), // Teal accent
  ];

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: widget.duration);
  }

  @override
  void didUpdateWidget(covariant AppCelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldCelebrate && !oldWidget.shouldCelebrate) {
      _controller.play();
      Future.delayed(widget.duration + widget.completeDelay, () {
        if (mounted) widget.onComplete();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Custom star path for confetti particles.
  Path _drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);
    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        emissionFrequency: widget.emissionFrequency,
        numberOfParticles: widget.numberOfParticles,
        maxBlastForce: widget.maxBlastForce,
        minBlastForce: widget.minBlastForce,
        gravity: widget.gravity,
        particleDrag: 0.05,
        minimumSize: Size(5.w, 5.w),
        maximumSize: Size(12.w, 12.w),
        colors: widget.colors ?? _defaultColors,
        createParticlePath: _drawStar,
      ),
    );
  }
}
