import 'package:flutter/material.dart';

/// Configuration for the Onboarding module.
///
/// Customizes the onboarding experience including slides,
/// visual style, and navigation options.
class OnboardingConfig {
  /// List of slides to display.
  final List<OnboardingSlide> slides;

  /// Visual style of the onboarding.
  final OnboardingStyle style;

  /// Allow users to skip the onboarding.
  final bool canSkip;

  /// Show progress indicator.
  final bool showIndicator;

  /// Style of the progress indicator.
  final IndicatorStyle indicatorStyle;

  /// Storage key for persistence.
  final String storageKey;

  /// Whether to auto-advance slides.
  final bool autoAdvance;

  /// Duration for auto-advance (if enabled).
  final Duration autoAdvanceDuration;

  const OnboardingConfig({
    required this.slides,
    this.style = OnboardingStyle.cards,
    this.canSkip = true,
    this.showIndicator = true,
    this.indicatorStyle = IndicatorStyle.dots,
    this.storageKey = 'onboarding_completed',
    this.autoAdvance = false,
    this.autoAdvanceDuration = const Duration(seconds: 5),
  });

  /// Default config — LifeFlow onboarding slides with custom SVG illustrations.
  static OnboardingConfig get defaultConfig => const OnboardingConfig(
        slides: [
          OnboardingSlide(
            image: 'assets/images/onboarding/onboarding_habits.svg',
            titleKey: 'onboardingSlide1Title',
            descriptionKey: 'onboardingSlide1Description',
          ),
          OnboardingSlide(
            image: 'assets/images/onboarding/onboarding_time.svg',
            titleKey: 'onboardingSlide2Title',
            descriptionKey: 'onboardingSlide2Description',
          ),
          OnboardingSlide(
            image: 'assets/images/onboarding/onboarding_progress.svg',
            titleKey: 'onboardingSlide3Title',
            descriptionKey: 'onboardingSlide3Description',
          ),
        ],
      );

  /// Whether social login is configured.
  bool get hasMultipleSlides => slides.length > 1;

  /// Total number of slides.
  int get slideCount => slides.length;
}

/// Data for a single onboarding slide.
class OnboardingSlide {
  /// Asset path for the image (SVG or PNG).
  final String image;

  /// Localization key for the title.
  final String titleKey;

  /// Localization key for the description.
  final String descriptionKey;

  /// Optional background color for this slide.
  final Color? backgroundColor;

  /// Optional icon instead of image.
  final IconData? icon;

  /// Optional action button for this slide.
  final OnboardingAction? action;

  const OnboardingSlide({
    required this.image,
    required this.titleKey,
    required this.descriptionKey,
    this.backgroundColor,
    this.icon,
    this.action,
  });

  /// Creates a slide with an icon instead of an image.
  const OnboardingSlide.withIcon({
    required IconData icon,
    required this.titleKey,
    required this.descriptionKey,
    this.backgroundColor,
  })  : image = '',
        icon = icon,
        action = null;
}

/// Optional action button for a slide.
class OnboardingAction {
  /// Label key for the button.
  final String labelKey;

  /// Callback when tapped.
  final VoidCallback onTap;

  const OnboardingAction({
    required this.labelKey,
    required this.onTap,
  });
}

/// Visual styles for the onboarding.
enum OnboardingStyle {
  /// Cards that swipe horizontally.
  cards,

  /// Fullscreen image with text overlay.
  fullscreen,

  /// Minimal design with centered illustration.
  minimal,
}

/// Styles for the progress indicator.
enum IndicatorStyle {
  /// Dot indicators.
  dots,

  /// Line/bar indicator.
  line,

  /// Numeric indicator (1/3).
  numbers,
}
