import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../design_system/tokens/app_animations.dart';
import '../../../services/haptic_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../config/onboarding_config.dart';

/// ViewModel for the Onboarding screen.
///
/// Handles slide navigation, haptic feedback, choreographed exit,
/// persistence, and completion celebration.
///
/// This is the **first conversation** with the user.
/// Every slide transition is intentional and animated.
class OnboardingViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final LocalStorageService _storageService = locator<LocalStorageService>();
  final HapticService _hapticService = locator<HapticService>();

  /// Onboarding configuration.
  final OnboardingConfig config;

  /// Creates the ViewModel with optional config.
  OnboardingViewModel({OnboardingConfig? config})
      : config = config ?? OnboardingConfig.defaultConfig;

  // ═══════════════════════════════════════════════════════════════════════════
  // PAGE CONTROLLER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Controller for the PageView — keeps button and swipe in sync.
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  int _currentIndex = 0;

  /// Current slide index.
  int get currentIndex => _currentIndex;

  /// Whether we're on the last slide.
  bool get isLastSlide => _currentIndex >= config.slideCount - 1;

  /// Whether we're on the first slide.
  bool get isFirstSlide => _currentIndex == 0;

  /// Current slide data.
  OnboardingSlide get currentSlide => config.slides[_currentIndex];

  /// Progress percentage (0.0 to 1.0).
  double get progress =>
      config.slideCount > 0 ? (_currentIndex + 1) / config.slideCount : 0.0;

  bool _isExiting = false;

  /// Whether the exit animation is playing.
  bool get isExiting => _isExiting;

  // ═══════════════════════════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Go to the next slide or complete onboarding.
  void next() {
    if (isLastSlide) {
      _completeOnboarding();
    } else {
      if (config.enableHaptics) _hapticService.selection();

      pageController.animateToPage(
        _currentIndex + 1,
        duration: AppAnimations.medium,
        curve: AppAnimations.easeOutCubic,
      );
    }
  }

  /// Go to the previous slide.
  void previous() {
    if (_currentIndex > 0) {
      if (config.enableHaptics) _hapticService.selection();

      pageController.animateToPage(
        _currentIndex - 1,
        duration: AppAnimations.medium,
        curve: AppAnimations.easeOutCubic,
      );
    }
  }

  /// Go to a specific slide (called by PageView.onPageChanged).
  void goToSlide(int index) {
    if (index >= 0 && index < config.slideCount) {
      _currentIndex = index;
      rebuildUi();
    }
  }

  /// Skip the onboarding entirely.
  void skip() {
    _completeOnboarding();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE & EXIT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Mark onboarding as completed, celebrate, and navigate away.
  Future<void> _completeOnboarding() async {
    // Haptic success pulse
    if (config.enableHaptics) _hapticService.success();

    await _storageService.setBool(config.storageKey, true);

    // Choreographed exit: fade out content before navigating
    if (config.animateExit) {
      _isExiting = true;
      rebuildUi();
      await Future.delayed(AppAnimations.medium);
    }

    _navigateToNextScreen();
  }

  /// Navigate to the next screen (login — user must authenticate).
  void _navigateToNextScreen() {
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATIC HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if onboarding has been completed.
  static Future<bool> isCompleted(
      {String storageKey = 'onboarding_completed'}) async {
    final storage = locator<LocalStorageService>();
    return storage.getBool(storageKey) ?? false;
  }

  /// Reset onboarding status (show again).
  static Future<void> reset(
      {String storageKey = 'onboarding_completed'}) async {
    final storage = locator<LocalStorageService>();
    await storage.remove(storageKey);
  }
}
