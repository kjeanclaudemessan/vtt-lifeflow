import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/splash_config.dart';
import '../viewmodels/splash_viewmodel.dart';

/// Splash screen — the app's first greeting.
///
/// This is not a loading screen. It's a **moment of welcome**.
/// The logo breathes in, the greeting adapts to time of day,
/// and the transition out is choreographed, never a hard cut.
class SplashView extends StackedView<SplashViewModel> {
  const SplashView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SplashViewModel viewModel,
    Widget? child,
  ) {
    final config = viewModel.config;
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final skin = context.brandSkin;

    return Scaffold(
      backgroundColor: config.backgroundColor != null
          ? Color(config.backgroundColor!)
          : colorScheme.surface,
      body: Semantics(
        label: l10n.splashInitializing,
        child: SafeArea(
          child: AnimatedOpacity(
            opacity: viewModel.isExiting ? 0.0 : 1.0,
            duration: AppAnimations.medium,
            curve: AppAnimations.easeIn,
            child: AnimatedScale(
              scale: viewModel.isExiting ? 1.05 : 1.0,
              duration: AppAnimations.medium,
              curve: AppAnimations.easeIn,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),

                    // ── Logo with breathing animation ──
                    _BreathingLogo(
                      animation: config.animation,
                      logoAsset: config.logoAsset,
                      isReady: viewModel.progress >= 1.0,
                    ),

                    SizedBox(height: AppSpacing.lg),

                    // ── App name from brand skin ──
                    _FadeInWidget(
                      delay: const Duration(milliseconds: 400),
                      child: Text(
                        skin.appName,
                        style: AppTypography.headlineLarge.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                        semanticsLabel: skin.appName,
                      ),
                    ),

                    SizedBox(height: AppSpacing.xs),

                    // ── Contextual greeting or tagline ──
                    _FadeInWidget(
                      delay: const Duration(milliseconds: 600),
                      child: AnimatedSwitcher(
                        duration: AppAnimations.medium,
                        switchInCurve: AppAnimations.easeOut,
                        switchOutCurve: AppAnimations.easeIn,
                        child: viewModel.hasError
                            ? const SizedBox.shrink(key: ValueKey('empty'))
                            : Text(
                                config.showGreeting
                                    ? viewModel.contextualGreeting(l10n)
                                    : l10n.splashTagline,
                                key: ValueKey(
                                  config.showGreeting ? 'greeting' : 'tagline',
                                ),
                                style: AppTypography.bodyMedium.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // ── Error or progress ──
                    AnimatedSwitcher(
                      duration: AppAnimations.medium,
                      switchInCurve: AppAnimations.easeOut,
                      switchOutCurve: AppAnimations.easeIn,
                      child: viewModel.hasError
                          ? _SplashErrorState(
                              key: const ValueKey('error'),
                              viewModel: viewModel,
                              l10n: l10n,
                            )
                          : _SplashProgress(
                              key: const ValueKey('progress'),
                              progress: viewModel.progress,
                              l10n: l10n,
                            ),
                    ),

                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  SplashViewModel viewModelBuilder(BuildContext context) => SplashViewModel();

  @override
  void onViewModelReady(SplashViewModel viewModel) {
    viewModel.initialize();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// BREATHING LOGO — the signature animation
// ═══════════════════════════════════════════════════════════════════════════════

/// Logo that "breathes" in — a gentle scale from 0.8→1.0 with a soft fade.
///
/// Unlike a mechanical fade-in, the breathing effect feels organic and alive,
/// like the app is waking up alongside the user.
class _BreathingLogo extends StatefulWidget {
  final SplashAnimation animation;
  final String? logoAsset;
  final bool isReady;

  const _BreathingLogo({
    required this.animation,
    this.logoAsset,
    this.isReady = false,
  });

  @override
  State<_BreathingLogo> createState() => _BreathingLogoState();
}

class _BreathingLogoState extends State<_BreathingLogo>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _breatheController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _breatheAnimation;

  @override
  void initState() {
    super.initState();

    // ── Entrance animation (one-shot) ──
    _entranceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animation.durationMs),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: AppAnimations.easeOut,
      ),
    );

    _scaleAnimation = _buildScaleAnimation();

    // ── Breathing loop (subtle pulse after entrance completes) ──
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _breatheAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    if (widget.animation != SplashAnimation.none) {
      _entranceController.forward().then((_) {
        if (mounted) {
          _breatheController.repeat(reverse: true);
        }
      });
    }
  }

  Animation<double> _buildScaleAnimation() {
    return switch (widget.animation) {
      SplashAnimation.breathe => Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: AppAnimations.easeOutCubic,
        ),
      ),
      SplashAnimation.fadeScale => Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: AppAnimations.spring,
        ),
      ),
      SplashAnimation.bounce => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: AppAnimations.spring,
        ),
      ),
      SplashAnimation.slideUp ||
      SplashAnimation.pulse ||
      SplashAnimation.none => Tween<double>(
        begin: 1.0,
        end: 1.0,
      ).animate(_entranceController),
    };
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = _buildLogo(context);

    if (widget.animation == SplashAnimation.none) return logo;

    if (widget.animation == SplashAnimation.slideUp) {
      final slideAnimation =
          Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _entranceController,
              curve: AppAnimations.easeOutCubic,
            ),
          );

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedBuilder(
            animation: _breatheController,
            builder: (context, child) =>
                Transform.scale(scale: _breatheAnimation.value, child: child),
            child: logo,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _breatheController]),
      builder: (context, child) {
        final entranceScale = _scaleAnimation.value;
        final breatheScale = _entranceController.isCompleted
            ? _breatheAnimation.value
            : 1.0;

        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: entranceScale * breatheScale,
            child: child,
          ),
        );
      },
      child: logo,
    );
  }

  Widget _buildLogo(BuildContext context) {
    final logoWidget = widget.logoAsset != null
        ? Image.asset(
            widget.logoAsset!,
            width: 120.w,
            height: 120.w,
            semanticLabel: context.brandSkin.appName,
          )
        : Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: AppRadius.xl,
              boxShadow: AppShadows.md,
            ),
            child: Icon(
              Icons.rocket_launch_rounded,
              size: 64.sp,
              color: context.colorScheme.onPrimary,
            ),
          );

    // Subtle glow behind logo when ready
    if (widget.isReady) {
      return Stack(
        alignment: Alignment.center,
        children: [
          // Soft glow
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          logoWidget,
        ],
      );
    }

    return logoWidget;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FADE-IN HELPER — delayed entrance for staggered content
// ═══════════════════════════════════════════════════════════════════════════════

/// A widget that fades in after a configurable delay.
///
/// Used for staggering the entrance of text elements below the logo,
/// creating a natural top-to-bottom reveal.
class _FadeInWidget extends StatefulWidget {
  final Duration delay;
  final Widget child;

  const _FadeInWidget({required this.delay, required this.child});

  @override
  State<_FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<_FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.slow,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeOut),
    );

    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: AppAnimations.easeOutCubic,
          ),
        );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(opacity: _opacity, child: widget.child),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROGRESS INDICATOR — warm, branded
// ═══════════════════════════════════════════════════════════════════════════════

class _SplashProgress extends StatelessWidget {
  final double progress;
  final AppLocalizations l10n;

  const _SplashProgress({
    super.key,
    required this.progress,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200.w,
            child: AppLinearProgress(value: progress),
          ),
          SizedBox(height: AppSpacing.sm),
          Semantics(
            liveRegion: true,
            child: Text(
              _getProgressMessage(progress, l10n),
              style: AppTypography.bodySmall.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns warm, progressive messages as loading advances.
  String _getProgressMessage(double progress, AppLocalizations l10n) {
    if (progress < 0.3) return l10n.splashPreparingExperience;
    if (progress < 0.6) return l10n.splashAlmostThere;
    if (progress < 0.9) return l10n.splashFinalTouches;
    return l10n.splashReady;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ERROR STATE — empathetic, never blaming
// ═══════════════════════════════════════════════════════════════════════════════

class _SplashErrorState extends StatelessWidget {
  final SplashViewModel viewModel;
  final AppLocalizations l10n;

  const _SplashErrorState({
    super.key,
    required this.viewModel,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Empathetic icon
          Icon(
            Icons.cloud_off_rounded,
            size: 32.sp,
            color: context.colorScheme.error,
          ),
          SizedBox(height: AppSpacing.sm),

          // Honest, concrete message — never "Oups"
          Text(
            viewModel.errorMessage ?? l10n.errorOccurred,
            style: AppTypography.bodyMedium.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.md),

          // Warm retry button
          Semantics(
            button: true,
            label: l10n.retry,
            child: AppButton.primary(
              label: l10n.retry,
              leftIcon: Icons.refresh_rounded,
              onPressed: viewModel.retry,
              isFullWidth: false,
              size: AppButtonSize.small,
            ),
          ),
        ],
      ),
    );
  }
}
