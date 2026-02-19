/// Parcours 8 — Returning User (Splash → Home)
///
/// End-to-end flow: user already authenticated, splash detects session
/// and navigates directly to home.
///
/// Run: dart test test/integration/parcours_returning_user_test.dart
/// Requires: `supabase start` running locally.
@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
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
    await ViewModelTestHelper.createUser(
      email: testEmail,
      password: testPassword,
    );
  });

  tearDown(() async {
    await ViewModelTestHelper.signOut();
    await ViewModelTestHelper.deleteUser(testEmail);
  });

  tearDownAll(() async {
    await ViewModelTestHelper.cleanup();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Parcours 8 — Returning User
  // ═══════════════════════════════════════════════════════════════════════════

  group('Parcours 8 — Returning User (Splash → Home)', () {
    test('P8-1: Login → session active', () async {
      await ViewModelTestHelper.signIn(email: testEmail);
      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
    });

    test('P8-2: SplashVM.initialize() with session → detects isAuthenticated',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final splashVm = SplashViewModel();
      await splashVm.initialize();

      // Result should indicate going to home
      expect(splashVm.result, isNotNull);
      expect(splashVm.result, SplashResult.goToHome);
    });

    test('P8-3: SplashVM checks onboardingCompleted in LocalStorage', () async {
      // No session → splash should check onboarding
      final splashVm = SplashViewModel();

      try {
        await splashVm.initialize();
      } catch (_) {}

      // Without session AND without onboarding completed:
      // result should be goToOnboarding
      expect(splashVm.result, SplashResult.goToOnboarding);

      // Now mark onboarding as completed
      await ViewModelTestHelper.localStorage
          .setBool('onboarding_completed', true);

      final splashVm2 = SplashViewModel();
      try {
        await splashVm2.initialize();
      } catch (_) {}

      // With onboarding completed but no session → goToLogin
      expect(splashVm2.result, SplashResult.goToLogin);
    });

    test('P8-4: SplashVM with session → goToHome (not Login/Onboarding)',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);
      // Mark onboarding as completed (returning user)
      await ViewModelTestHelper.localStorage
          .setBool('onboarding_completed', true);

      final splashVm = SplashViewModel();
      await splashVm.initialize();

      expect(splashVm.result, SplashResult.goToHome);
      expect(splashVm.result, isNot(SplashResult.goToLogin));
      expect(splashVm.result, isNot(SplashResult.goToOnboarding));
    });

    test('P8-5: SplashVM preloads profile when authenticated', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final splashVm = SplashViewModel();
      await splashVm.initialize();

      // Progress should have reached 1.0
      expect(splashVm.progress, 1.0);
      expect(splashVm.hasError, isFalse);
    });
  });
}
