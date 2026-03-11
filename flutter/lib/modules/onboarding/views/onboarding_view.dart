import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/onboarding_config.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_navigation.dart';
import '../widgets/onboarding_slide_widget.dart';

/// Onboarding view.
///
/// Displays introduction slides for first-time users.
/// Wraps content in an exit animation that fades out
/// before navigating to the next screen.
class OnboardingView extends StackedView<OnboardingViewModel> {
  /// Optional custom configuration.
  final OnboardingConfig? config;

  const OnboardingView({this.config, super.key});

  @override
  Widget builder(
    BuildContext context,
    OnboardingViewModel viewModel,
    Widget? child,
  ) {
    final content = switch (viewModel.config.style) {
      OnboardingStyle.cards => _buildCardsStyle(context, viewModel),
      OnboardingStyle.fullscreen => _buildFullscreenStyle(context, viewModel),
      OnboardingStyle.minimal => _buildMinimalStyle(context, viewModel),
    };

    // Choreographed exit: fade + scale down gently
    return AnimatedOpacity(
      opacity: viewModel.isExiting ? 0.0 : 1.0,
      duration: AppAnimations.medium,
      curve: AppAnimations.easeOut,
      child: AnimatedScale(
        scale: viewModel.isExiting ? 0.96 : 1.0,
        duration: AppAnimations.medium,
        curve: AppAnimations.easeOut,
        child: content,
      ),
    );
  }

  Widget _buildCardsStyle(BuildContext context, OnboardingViewModel viewModel) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: Semantics(
          label: 'Onboarding',
          child: Column(
            children: [
              // Skip button in header
              if (viewModel.config.canSkip && !viewModel.isLastSlide)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: TextButton(
                      onPressed: viewModel.skip,
                      child: Text(
                        context.l10n.skip,
                        style: AppTypography.labelMedium.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SizedBox(height: 48.h),

              // Slides
              Expanded(
                child: PageView.builder(
                  controller: viewModel.pageController,
                  itemCount: viewModel.config.slideCount,
                  onPageChanged: viewModel.goToSlide,
                  itemBuilder: (context, index) {
                    return OnboardingSlideWidget(
                      slide: viewModel.config.slides[index],
                      style: OnboardingStyle.cards,
                    );
                  },
                ),
              ),

              // Indicator
              if (viewModel.config.showIndicator) ...[
                OnboardingIndicator(
                  currentIndex: viewModel.currentIndex,
                  totalCount: viewModel.config.slideCount,
                  style: viewModel.config.indicatorStyle,
                ),
                SizedBox(height: AppSpacing.xl),
              ],

              // Navigation
              OnboardingNavigationFull(
                isLastSlide: viewModel.isLastSlide,
                onNext: viewModel.next,
                onSkip: viewModel.skip,
                canSkip: false, // Already have skip in header
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullscreenStyle(
    BuildContext context,
    OnboardingViewModel viewModel,
  ) {
    return Scaffold(
      body: Stack(
        children: [
          // Slides (fullscreen)
          PageView.builder(
            controller: viewModel.pageController,
            itemCount: viewModel.config.slideCount,
            onPageChanged: viewModel.goToSlide,
            itemBuilder: (context, index) {
              return OnboardingSlideWidget(
                slide: viewModel.config.slides[index],
                style: OnboardingStyle.fullscreen,
              );
            },
          ),

          // Skip button
          if (viewModel.config.canSkip && !viewModel.isLastSlide)
            Positioned(
              top: MediaQuery.of(context).padding.top + AppSpacing.md,
              right: AppSpacing.md,
              child: TextButton(
                onPressed: viewModel.skip,
                child: Text(
                  context.l10n.skip,
                  style: AppTypography.labelMedium.copyWith(
                    color: context.colorScheme.onInverseSurface,
                  ),
                ),
              ),
            ),

          // Bottom navigation and indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
            child: Column(
              children: [
                if (viewModel.config.showIndicator)
                  OnboardingIndicator(
                    currentIndex: viewModel.currentIndex,
                    totalCount: viewModel.config.slideCount,
                    style: viewModel.config.indicatorStyle,
                    activeColor: context.colorScheme.onInverseSurface,
                    inactiveColor: context.colorScheme.onInverseSurface
                        .withValues(alpha: 0.3),
                  ),
                SizedBox(height: AppSpacing.lg),
                OnboardingNavigation(
                  isLastSlide: viewModel.isLastSlide,
                  onNext: viewModel.next,
                  onSkip: viewModel.skip,
                  canSkip: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalStyle(
    BuildContext context,
    OnboardingViewModel viewModel,
  ) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: AppSpacing.xl),

            // Indicator at top
            if (viewModel.config.showIndicator)
              OnboardingIndicator(
                currentIndex: viewModel.currentIndex,
                totalCount: viewModel.config.slideCount,
                style: IndicatorStyle.line,
              ),

            // Slides
            Expanded(
              child: PageView.builder(
                controller: viewModel.pageController,
                itemCount: viewModel.config.slideCount,
                onPageChanged: viewModel.goToSlide,
                itemBuilder: (context, index) {
                  return OnboardingSlideWidget(
                    slide: viewModel.config.slides[index],
                    style: OnboardingStyle.minimal,
                  );
                },
              ),
            ),

            // Navigation
            OnboardingNavigationFull(
              isLastSlide: viewModel.isLastSlide,
              onNext: viewModel.next,
              onSkip: viewModel.skip,
              canSkip: viewModel.config.canSkip,
            ),
          ],
        ),
      ),
    );
  }

  @override
  OnboardingViewModel viewModelBuilder(BuildContext context) =>
      OnboardingViewModel(config: config);
}
