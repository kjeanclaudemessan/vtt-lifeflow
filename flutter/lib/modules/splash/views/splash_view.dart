import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/splash_config.dart';
import '../viewmodels/splash_viewmodel.dart';

/// Splash screen view.
///
/// Displays the app logo with animation while initializing the app.
/// Configuration is accessed via the ViewModel for route compatibility.
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

    return Scaffold(
      backgroundColor: config.backgroundColor != null
          ? Color(config.backgroundColor!)
          : context.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Logo with animation
              _AnimatedLogo(
                animation: config.animation,
                logoAsset: config.logoAsset,
              ),

              SizedBox(height: AppSpacing.lg),

              // App name
              Text(
                'LifeFlow',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: AppSpacing.xs),

              // Tagline
              Text(
                l10n.splashTagline,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary(Theme.of(context).brightness),
                ),
              ),

              const Spacer(flex: 2),

              // Error state
              if (viewModel.hasError)
                _buildErrorState(context, viewModel, l10n),

              // Progress indicator
              if (!viewModel.hasError)
                _buildProgressIndicator(context, viewModel, l10n),

              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    SplashViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            viewModel.errorMessage ?? l10n.errorOccurred,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.md),
          AppButton.primary(
            label: l10n.retry,
            leftIcon: Icons.refresh_rounded,
            onPressed: viewModel.retry,
            isFullWidth: false,
            size: AppButtonSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    SplashViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200.w,
            child: AppLinearProgress(
              value: viewModel.progress,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            _getProgressText(viewModel.progress, l10n),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary(Theme.of(context).brightness),
            ),
          ),
        ],
      ),
    );
  }

  String _getProgressText(double progress, AppLocalizations l10n) {
    if (progress < 0.3) return l10n.splashPreparingExperience;
    if (progress < 0.6) return l10n.splashAlmostThere;
    if (progress < 0.9) return l10n.splashFinalTouches;
    return l10n.splashReady;
  }

  @override
  SplashViewModel viewModelBuilder(BuildContext context) => SplashViewModel();

  @override
  void onViewModelReady(SplashViewModel viewModel) {
    viewModel.initialize();
  }
}

/// Animated logo widget with different animation types.
class _AnimatedLogo extends StatefulWidget {
  final SplashAnimation animation;
  final String? logoAsset;

  const _AnimatedLogo({
    required this.animation,
    this.logoAsset,
  });

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animation.durationMs),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (widget.animation != SplashAnimation.none) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = _buildLogo(context);

    return switch (widget.animation) {
      SplashAnimation.fadeScale => AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: logo,
        ),
      SplashAnimation.bounce => ScaleTransition(
          scale: _scaleAnimation,
          child: logo,
        ),
      SplashAnimation.slideUp => SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: logo,
          ),
        ),
      SplashAnimation.pulse => _PulsingWidget(child: logo),
      SplashAnimation.none => logo,
    };
  }

  Widget _buildLogo(BuildContext context) {
    if (widget.logoAsset != null) {
      return Image.asset(
        widget.logoAsset!,
        width: 150.w,
        height: 150.w,
      );
    }

    // Default logo placeholder using design system
    return Container(
      width: 150.w,
      height: 150.w,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.xl,
        boxShadow: AppShadows.md,
      ),
      child: Icon(
        Icons.rocket_launch_rounded,
        size: 80.sp,
        color: AppColors.white,
      ),
    );
  }
}

/// Pulsing animation widget.
class _PulsingWidget extends StatefulWidget {
  final Widget child;

  const _PulsingWidget({required this.child});

  @override
  State<_PulsingWidget> createState() => _PulsingWidgetState();
}

class _PulsingWidgetState extends State<_PulsingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
