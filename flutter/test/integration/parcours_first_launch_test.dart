/// Parcours 1 — First Launch (Splash → Onboarding → Register → Profile)
///
/// End-to-end flow: first app launch, no session, onboarding not completed,
/// user goes through onboarding, registers, then views profile.
///
/// Run: dart test test/integration/parcours_first_launch_test.dart
/// Requires: `supabase start` running locally.
@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/modules/auth/viewmodels/register_viewmodel.dart';
import 'package:lifeflow/modules/onboarding/viewmodels/onboarding_viewmodel.dart';
import 'package:lifeflow/modules/profile/viewmodels/profile_viewmodel.dart';
import 'package:lifeflow/modules/splash/config/splash_config.dart';
import 'package:lifeflow/modules/splash/viewmodels/splash_viewmodel.dart';

import 'viewmodel_test_helper.dart';

void main() {
  late String testEmail;
  const testPassword = 'Test123456!';

  setUpAll(() async {
    await ViewModelTestHelper.initialize();
  });

  setUp(() async {
    await ViewModelTestHelper.signOut();
    await ViewModelTestHelper.localStorage.clear();
    testEmail = generateVmTestEmail();
  });

  tearDown(() async {
    await ViewModelTestHelper.signOut();
    await ViewModelTestHelper.deleteUser(testEmail);
  });

  tearDownAll(() async {
    await ViewModelTestHelper.cleanup();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Parcours 1 — First Launch
  // ═══════════════════════════════════════════════════════════════════════════

  group('Parcours 1 — First Launch', () {
    test('P1-1: SplashVM.initialize() without session → !isAuthenticated',
        () async {
      final splashVm = SplashViewModel();
      try {
        await splashVm.initialize();
      } catch (_) {}

      // No session → should NOT go to home
      expect(splashVm.result, isNot(SplashResult.goToHome));
    });

    test('P1-2: SplashVM → onboarding not completed → goToOnboarding',
        () async {
      // localStorage is cleared in setUp → onboarding_completed = null
      final splashVm = SplashViewModel();
      try {
        await splashVm.initialize();
      } catch (_) {}

      expect(splashVm.result, SplashResult.goToOnboarding);
    });

    test('P1-3: OnboardingVM.init → page 0, isLastSlide = false', () {
      final onboardingVm = OnboardingViewModel();

      expect(onboardingVm.currentIndex, 0);
      expect(onboardingVm.isFirstSlide, isTrue);
      expect(onboardingVm.isLastSlide, isFalse);
    });

    test('P1-4: OnboardingVM.next() × N → traverses all pages', () {
      final onboardingVm = OnboardingViewModel();
      final slideCount = onboardingVm.config.slideCount;

      // Navigate through all slides except the last
      for (int i = 0; i < slideCount - 1; i++) {
        expect(onboardingVm.currentIndex, i);
        onboardingVm.next();
      }

      // Should be on last slide
      expect(onboardingVm.currentIndex, slideCount - 1);
    });

    test('P1-5: OnboardingVM on last page → isLastSlide = true', () {
      final onboardingVm = OnboardingViewModel();
      final slideCount = onboardingVm.config.slideCount;

      // Go to last slide
      for (int i = 0; i < slideCount - 1; i++) {
        onboardingVm.next();
      }

      expect(onboardingVm.isLastSlide, isTrue);
      expect(onboardingVm.isFirstSlide, isFalse);
    });

    test('P1-6: OnboardingVM.skip() → persists onboardingCompleted = true',
        () async {
      final onboardingVm = OnboardingViewModel();

      try {
        onboardingVm.skip();
      } catch (_) {} // NavigationService throws

      // Give async setBool time to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Verify the storage key was set
      final completed = ViewModelTestHelper.localStorage
          .getBool(onboardingVm.config.storageKey);
      expect(completed, isTrue);
    });

    test('P1-7: Re-splash → onboarding completed, no session → goToLogin',
        () async {
      // Simulate onboarding completed
      await ViewModelTestHelper.localStorage
          .setBool('onboarding_completed', true);

      final splashVm = SplashViewModel();
      try {
        await splashVm.initialize();
      } catch (_) {}

      expect(splashVm.result, SplashResult.goToLogin);
    });

    test('P1-8: RegisterVM.register() → account created + session', () async {
      final registerVm = RegisterViewModel();
      registerVm.setFirstName('Premier');
      registerVm.setLastName('Lancement');
      registerVm.setEmail(testEmail);
      registerVm.setPassword(testPassword);
      if (registerVm.config.showTermsCheckbox) {
        registerVm.setAcceptedTerms(true);
      }

      try {
        await registerVm.register();
      } catch (_) {}

      expect(registerVm.hasError, isFalse);
      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
    });

    test('P1-9: ProfileVM.init() → new user profile loaded', () async {
      // Register
      final registerVm = RegisterViewModel();
      registerVm.setFirstName('Premier');
      registerVm.setLastName('Lancement');
      registerVm.setEmail(testEmail);
      registerVm.setPassword(testPassword);
      if (registerVm.config.showTermsCheckbox) {
        registerVm.setAcceptedTerms(true);
      }
      try {
        await registerVm.register();
      } catch (_) {}

      // Wait for Supabase trigger to create profile row
      await Future.delayed(const Duration(milliseconds: 500));

      // Load profile
      final profileVm = ProfileViewModel();
      await profileVm.init();

      expect(profileVm.email, testEmail);
      expect(profileVm.hasError, isFalse);
    });
  });
}
