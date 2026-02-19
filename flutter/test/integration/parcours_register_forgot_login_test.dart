/// Parcours 4 — Register → ForgotPassword → Login
///
/// End-to-end flow: new user registers, tests password reset,
/// then logs in with original credentials.
///
/// Run: dart test test/integration/parcours_register_forgot_login_test.dart
/// Requires: `supabase start` running locally.
@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/modules/auth/viewmodels/forgot_password_viewmodel.dart';
import 'package:lifeflow/modules/auth/viewmodels/login_viewmodel.dart';
import 'package:lifeflow/modules/auth/viewmodels/register_viewmodel.dart';
import 'package:lifeflow/modules/profile/viewmodels/profile_viewmodel.dart';

import 'viewmodel_test_helper.dart';

void main() {
  late String testEmail;
  const testPassword = 'Test123456!';

  setUpAll(() async {
    await ViewModelTestHelper.initialize();
  });

  setUp(() async {
    await ViewModelTestHelper.signOut();
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
  // Parcours 4 — Register → ForgotPassword → Login
  // ═══════════════════════════════════════════════════════════════════════════

  group('Parcours 4 — Register → ForgotPassword → Login', () {
    test('P4-1: RegisterVM.register() → creates account + session', () async {
      final registerVm = RegisterViewModel();

      registerVm.setFirstName('Parcours');
      registerVm.setLastName('Quatre');
      registerVm.setEmail(testEmail);
      registerVm.setPassword(testPassword);
      if (registerVm.config.showTermsCheckbox) {
        registerVm.setAcceptedTerms(true);
      }

      expect(registerVm.canSubmit, isTrue);

      try {
        await registerVm.register();
      } catch (_) {} // NavigationService throws

      expect(registerVm.hasError, isFalse);
      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
    });

    test('P4-2: Logout after register', () async {
      // Register
      final registerVm = RegisterViewModel();
      registerVm.setFirstName('Parcours');
      registerVm.setLastName('Quatre');
      registerVm.setEmail(testEmail);
      registerVm.setPassword(testPassword);
      if (registerVm.config.showTermsCheckbox) {
        registerVm.setAcceptedTerms(true);
      }
      try {
        await registerVm.register();
      } catch (_) {}

      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);

      // Logout
      await ViewModelTestHelper.signOut();
      await Future.delayed(const Duration(milliseconds: 200));

      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isFalse);
    });

    test('P4-3: ForgotPasswordVM.sendResetEmail() → emailSent = true',
        () async {
      // First register the user
      await ViewModelTestHelper.createUser(
        email: testEmail,
        password: testPassword,
      );

      final forgotVm = ForgotPasswordViewModel();
      forgotVm.setEmail(testEmail);

      expect(forgotVm.canSubmit, isTrue);

      await forgotVm.sendResetEmail();

      expect(forgotVm.hasError, isFalse);
      expect(forgotVm.emailSent, isTrue);
    });

    test('P4-4: ForgotPasswordVM.resendEmail() → re-sends without error',
        () async {
      await ViewModelTestHelper.createUser(
        email: testEmail,
        password: testPassword,
      );

      final forgotVm = ForgotPasswordViewModel();
      forgotVm.setEmail(testEmail);

      // First send
      await forgotVm.sendResetEmail();
      expect(forgotVm.emailSent, isTrue);

      // Small delay to avoid rate limiting
      await Future.delayed(const Duration(seconds: 1));

      // Resend — create a fresh VM to avoid runBusyFuture state issues
      final forgotVm2 = ForgotPasswordViewModel();
      forgotVm2.setEmail(testEmail);
      await forgotVm2.sendResetEmail();
      expect(forgotVm2.hasError, isFalse);
      expect(forgotVm2.emailSent, isTrue);
    });

    test(
        'P4-5: LoginVM.loginWithEmail() with same credentials → session active',
        () async {
      // Register the user first
      final registerVm = RegisterViewModel();
      registerVm.setFirstName('Parcours');
      registerVm.setLastName('Quatre');
      registerVm.setEmail(testEmail);
      registerVm.setPassword(testPassword);
      if (registerVm.config.showTermsCheckbox) {
        registerVm.setAcceptedTerms(true);
      }
      try {
        await registerVm.register();
      } catch (_) {}

      // Logout
      await ViewModelTestHelper.signOut();

      // Login with same credentials
      final loginVm = LoginViewModel();
      loginVm.setEmail(testEmail);
      loginVm.setPassword(testPassword);

      try {
        await loginVm.loginWithEmail();
      } catch (_) {}

      expect(loginVm.hasError, isFalse);
      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
      expect(ViewModelTestHelper.supabaseService.currentUser?.email, testEmail);
    });

    test('P4-6: ProfileVM.init() → loaded profile = same user', () async {
      // Full flow: register → logout → login → profile
      final registerVm = RegisterViewModel();
      registerVm.setFirstName('Parcours');
      registerVm.setLastName('Quatre');
      registerVm.setEmail(testEmail);
      registerVm.setPassword(testPassword);
      if (registerVm.config.showTermsCheckbox) {
        registerVm.setAcceptedTerms(true);
      }
      try {
        await registerVm.register();
      } catch (_) {}

      await ViewModelTestHelper.signOut();

      // Login
      await ViewModelTestHelper.signIn(
          email: testEmail, password: testPassword);

      // Load profile
      final profileVm = ProfileViewModel();
      await profileVm.init();

      expect(profileVm.user, isNotNull);
      expect(profileVm.email, testEmail);
      expect(profileVm.hasError, isFalse);
    });
  });
}
