import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app.locator.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import '../haptic_service.dart';

/// ============================================================================
/// VTT DESIGN SYSTEM — CELEBRATION SERVICE
///
/// Centralized service that decides WHEN and HOW to celebrate user
/// achievements. Registered as LazySingleton in GetIt.
///
/// ## Celebration Tiers
///
/// | Tier | Trigger Examples | Visual |
/// |------|-----------------|--------|
/// | Micro | Complete habit, save form | Checkmark + haptic |
/// | Medium | 7-day streak, weekly goal | Glow pulse + message |
/// | Major | 30-day streak, monthly goal | Confetti + sound + msg |
///
/// ## Rules
///
/// - Max 1 confetti per session (avoid desensitization)
/// - Never celebrate during errors or loading
/// - Respect "reduce motion" accessibility setting
/// - Celebrations are purely UI — no business logic
/// ============================================================================
class CelebrationService {
  final _haptic = locator<HapticService>();

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Whether a confetti celebration has already fired this session.
  bool _confettiFiredThisSession = false;

  /// Whether confetti has already been used this session.
  bool get confettiFiredThisSession => _confettiFiredThisSession;

  /// Reset session state (call on app resume or new session).
  void resetSession() => _confettiFiredThisSession = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // CELEBRATION TIERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Micro celebration — checkmark animation + haptic.
  /// Use for: habit completion, form save, toggle success.
  CelebrationResult micro({String? message}) {
    _haptic.success();
    return CelebrationResult(
      tier: CelebrationTier.micro,
      message: message,
      shouldShowCheckmark: true,
      shouldShowGlow: false,
      shouldShowConfetti: false,
    );
  }

  /// Medium celebration — glow pulse + encouraging message + haptic.
  /// Use for: 3-day streak, first weekly goal, personal record.
  CelebrationResult medium({required String message}) {
    _haptic.success();
    return CelebrationResult(
      tier: CelebrationTier.medium,
      message: message,
      shouldShowCheckmark: true,
      shouldShowGlow: true,
      shouldShowConfetti: false,
    );
  }

  /// Major celebration — confetti + message + strong haptic.
  /// Use for: 7/30/100-day streak, monthly goals, level up.
  /// Only fires confetti once per session per app rule.
  CelebrationResult major({required String message}) {
    _haptic.success();
    final showConfetti = !_confettiFiredThisSession;
    if (showConfetti) _confettiFiredThisSession = true;
    return CelebrationResult(
      tier: CelebrationTier.major,
      message: message,
      shouldShowCheckmark: true,
      shouldShowGlow: true,
      shouldShowConfetti: showConfetti,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STREAK HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Determines the appropriate celebration for a streak count.
  CelebrationResult? forStreak(int streakDays, {required String message}) {
    return switch (streakDays) {
      >= 100 => major(message: message),
      >= 30 => major(message: message),
      >= 7 => medium(message: message),
      >= 3 => micro(message: message),
      _ => null, // No celebration for < 3 days
    };
  }

  /// Determines celebration for goal completion percentage.
  CelebrationResult? forGoalProgress(
    double progress, {
    required String message,
  }) {
    if (progress >= 1.0) return major(message: message);
    if (progress >= 0.75) return medium(message: message);
    if (progress >= 0.5) return micro(message: message);
    return null;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CELEBRATION RESULT
// ═══════════════════════════════════════════════════════════════════════════════

/// The result of a celebration decision.
///
/// Contains all the information a view needs to display the celebration.
/// The view checks these booleans and respects `disableAnimations`.
@immutable
class CelebrationResult {
  /// Which tier of celebration.
  final CelebrationTier tier;

  /// Optional message to display (e.g. "Bravo ! 7 jours de suite !").
  final String? message;

  /// Whether to show the animated checkmark.
  final bool shouldShowCheckmark;

  /// Whether to show the glow pulse effect.
  final bool shouldShowGlow;

  /// Whether to show confetti particles.
  final bool shouldShowConfetti;

  const CelebrationResult({
    required this.tier,
    this.message,
    required this.shouldShowCheckmark,
    required this.shouldShowGlow,
    required this.shouldShowConfetti,
  });
}

/// Celebration intensity tiers.
enum CelebrationTier {
  /// Subtle — checkmark + haptic only.
  micro,

  /// Moderate — glow + message + haptic.
  medium,

  /// Full — confetti + glow + message + strong haptic.
  major,
}

// ═══════════════════════════════════════════════════════════════════════════════
// CELEBRATION OVERLAY WIDGET (Enhanced)
// ═══════════════════════════════════════════════════════════════════════════════

/// A widget that displays a celebration message with optional animation.
///
/// Place this in a Stack above your main content.
///
/// ```dart
/// Stack(
///   children: [
///     mainContent,
///     if (viewModel.celebrationResult != null)
///       CelebrationMessage(result: viewModel.celebrationResult!),
///   ],
/// )
/// ```
class CelebrationMessage extends StatefulWidget {
  /// The celebration result to display.
  final CelebrationResult result;

  /// Called when the celebration animation completes.
  final VoidCallback? onComplete;

  const CelebrationMessage({super.key, required this.result, this.onComplete});

  @override
  State<CelebrationMessage> createState() => _CelebrationMessageState();
}

class _CelebrationMessageState extends State<CelebrationMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;
  late final Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    final totalDuration = widget.result.tier == CelebrationTier.major
        ? const Duration(milliseconds: 2500)
        : const Duration(milliseconds: 1800);

    _controller = AnimationController(vsync: this, duration: totalDuration);

    // Fade in: 0% → 20%
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.2, curve: Curves.easeOut),
      ),
    );

    // Scale in: 0% → 30%
    _scaleIn = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.easeOutBack),
      ),
    );

    // Fade out: 80% → 100%
    _fadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (widget.result.message == null) return const SizedBox.shrink();

    if (reduceMotion) {
      // Accessibility: show static message, no animation
      return Positioned(
        bottom: AppSpacing.staticXl + MediaQuery.paddingOf(context).bottom,
        left: AppSpacing.staticLg,
        right: AppSpacing.staticLg,
        child: _buildMessageCard(context, opacity: 1, scale: 1),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = _controller.value < 0.8
            ? _fadeIn.value
            : _fadeOut.value;
        return Positioned(
          bottom: AppSpacing.staticXl + MediaQuery.paddingOf(context).bottom,
          left: AppSpacing.staticLg,
          right: AppSpacing.staticLg,
          child: _buildMessageCard(
            context,
            opacity: opacity,
            scale: _scaleIn.value,
          ),
        );
      },
    );
  }

  Widget _buildMessageCard(
    BuildContext context, {
    required double opacity,
    required double scale,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = switch (widget.result.tier) {
      CelebrationTier.micro => Icons.check_circle_outline,
      CelebrationTier.medium => Icons.emoji_events_outlined,
      CelebrationTier.major => Icons.celebration_outlined,
    };

    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: scale,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.staticLg,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: widget.result.shouldShowGlow ? 16.r : 8.r,
                spreadRadius: widget.result.shouldShowGlow ? 2.r : 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 24.sp,
                semanticLabel: widget.result.tier.name,
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: Text(
                  widget.result.message!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
