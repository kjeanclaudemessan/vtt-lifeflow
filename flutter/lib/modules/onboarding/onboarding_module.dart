/// Onboarding module.
///
/// Provides an introduction flow for first-time users.
///
/// ## Features
/// - Customizable slides with images and text
/// - Multiple visual styles (cards, fullscreen, minimal)
/// - Skip functionality
/// - Progress indicators
/// - Persistence (remembers if completed)
///
/// ## Usage
/// ```dart
/// import 'package:lifeflow/modules/onboarding/onboarding_module.dart';
///
/// // Use with default config
/// OnboardingView()
///
/// // Use with custom config
/// OnboardingView(
///   config: OnboardingConfig(
///     slides: [
///       OnboardingSlide(
///         image: 'assets/images/onboarding_1.svg',
///         titleKey: 'onboarding.slide1.title',
///         descriptionKey: 'onboarding.slide1.description',
///       ),
///     ],
///     style: OnboardingStyle.fullscreen,
///   ),
/// )
/// ```
library;

// Config
export 'config/onboarding_config.dart';
// ViewModels
export 'viewmodels/onboarding_viewmodel.dart';
// Views
export 'views/onboarding_view.dart';
// Widgets
export 'widgets/onboarding_indicator.dart';
export 'widgets/onboarding_navigation.dart';
export 'widgets/onboarding_slide_widget.dart';
