/// REAL ViewModel integration tests — LoginViewModel & RegisterViewModel
/// against a real local Supabase instance.
///
/// These tests import and instantiate the ACTUAL ViewModels, call their
/// real methods, and verify their real state.
///
/// Run: dart test test/integration/viewmodel_auth_integration_test.dart
/// Requires: `supabase start` running locally.
@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/modules/auth/viewmodels/login_viewmodel.dart';
import 'package:lifeflow/modules/auth/viewmodels/register_viewmodel.dart';

import 'viewmodel_test_helper.dart';

void main() {
  setUpAll(() async {
    await ViewModelTestHelper.initialize();
  });

  setUp(() async {
    await ViewModelTestHelper.signOut();
  });

  tearDownAll(() async {
    await ViewModelTestHelper.cleanup();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // LoginViewModel — Form Validation
  // ═══════════════════════════════════════════════════════════════════════════

  group('LoginViewModel — Form Validation', () {
    late LoginViewModel vm;

    setUp(() {
      vm = LoginViewModel();
    });

    test('initial state: canSubmit is false, no errors', () {
      expect(vm.email, isEmpty);
      expect(vm.password, isEmpty);
      expect(vm.canSubmit, isFalse);
      expect(vm.emailError, isNull);
      expect(vm.passwordError, isNull);
      expect(vm.obscurePassword, isTrue);
      expect(vm.rememberMe, isFalse);
    });

    test('setEmail validates email format', () {
      vm.setEmail('invalid');
      expect(vm.emailError, isNotNull);

      vm.setEmail('valid@example.com');
      expect(vm.emailError, isNull);
      expect(vm.email, 'valid@example.com');
    });

    test('setPassword validates minimum length', () {
      vm.setPassword('ab');
      expect(vm.passwordError, isNotNull);

      vm.setPassword('Test123456!');
      expect(vm.passwordError, isNull);
      expect(vm.password, 'Test123456!');
    });

    test('canSubmit is true when email and password are valid', () {
      vm.setEmail('test@example.com');
      vm.setPassword('Test123456!');
      expect(vm.canSubmit, isTrue);
    });

    test('canSubmit is false with invalid email', () {
      vm.setEmail('not-an-email');
      vm.setPassword('Test123456!');
      expect(vm.canSubmit, isFalse);
    });

    test('togglePasswordVisibility flips state', () {
      expect(vm.obscurePassword, isTrue);
      vm.togglePasswordVisibility();
      expect(vm.obscurePassword, isFalse);
      vm.togglePasswordVisibility();
      expect(vm.obscurePassword, isTrue);
    });

    test('setRememberMe updates state', () {
      vm.setRememberMe(true);
      expect(vm.rememberMe, isTrue);
      vm.setRememberMe(false);
      expect(vm.rememberMe, isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // LoginViewModel — Real Auth (Supabase)
  // ═══════════════════════════════════════════════════════════════════════════

  group('LoginViewModel — Real Auth', () {
    late String testEmail;
    const testPassword = 'Test123456!';

    setUp(() async {
      testEmail = generateVmTestEmail();
      await ViewModelTestHelper.createUser(
        email: testEmail,
        password: testPassword,
        firstName: 'Login',
        lastName: 'Test',
      );
    });

    tearDown(() async {
      await ViewModelTestHelper.signOut();
      await ViewModelTestHelper.deleteUser(testEmail);
    });

    test('loginWithEmail succeeds with correct credentials', () async {
      final vm = LoginViewModel();
      vm.setEmail(testEmail);
      vm.setPassword(testPassword);

      expect(vm.canSubmit, isTrue);

      // loginWithEmail calls _navigationService.clearStackAndShow on success,
      // which throws in tests (no navigator). We catch it — the important
      // thing is that auth succeeded (no error on the VM).
      try {
        await vm.loginWithEmail();
      } catch (_) {
        // NavigationService throws without a navigator — expected in tests.
      }

      // After successful login, ViewModel should NOT have an error
      expect(vm.hasError, isFalse);

      // Session should be active on the shared client
      final user = ViewModelTestHelper.supabaseService.currentUser;
      expect(user, isNotNull);
      expect(user!.email, testEmail);
    });

    test('loginWithEmail fails with wrong password', () async {
      final vm = LoginViewModel();
      vm.setEmail(testEmail);
      vm.setPassword('WrongPassword!');

      try {
        await vm.loginWithEmail();
      } catch (_) {}

      // After wrong password, the ViewModel should either:
      // - have an error set via setError()
      // - or still have the user as null (not authenticated)
      final authenticated = ViewModelTestHelper.supabaseService.isAuthenticated;
      expect(authenticated, isFalse,
          reason: 'Should NOT be authenticated with wrong password');
    });

    test('loginWithEmail does nothing when canSubmit is false', () async {
      final vm = LoginViewModel();
      // Don't set email/password

      expect(vm.canSubmit, isFalse);

      await vm.loginWithEmail(); // Should return immediately

      expect(vm.hasError, isFalse);
      expect(ViewModelTestHelper.supabaseService.currentUser, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // RegisterViewModel — Form Validation
  // ═══════════════════════════════════════════════════════════════════════════

  group('RegisterViewModel — Form Validation', () {
    late RegisterViewModel vm;

    setUp(() {
      vm = RegisterViewModel();
    });

    test('initial state: all empty, canSubmit false', () {
      expect(vm.firstName, isEmpty);
      expect(vm.lastName, isEmpty);
      expect(vm.email, isEmpty);
      expect(vm.password, isEmpty);
      expect(vm.confirmPassword, isEmpty);
      expect(vm.canSubmit, isFalse);
      expect(vm.acceptedTerms, isFalse);
      expect(vm.passwordStrength, PasswordStrength.none);
    });

    test('setFirstName / setLastName update state', () {
      vm.setFirstName('  Jean  ');
      vm.setLastName('  Dupont  ');
      expect(vm.firstName, 'Jean');
      expect(vm.lastName, 'Dupont');
    });

    test('setEmail validates format', () {
      vm.setEmail('bad');
      expect(vm.emailError, isNotNull);

      vm.setEmail('ok@test.com');
      expect(vm.emailError, isNull);
    });

    test('setPassword validates length + updates strength', () {
      vm.setPassword('ab');
      expect(vm.passwordError, isNotNull);
      expect(vm.passwordStrength, PasswordStrength.weak);

      vm.setPassword('Test123456!');
      expect(vm.passwordError, isNull);
      expect(vm.passwordStrength, PasswordStrength.strong);
    });

    test('setConfirmPassword validates match', () {
      vm.setPassword('Test123456!');
      vm.setConfirmPassword('different');
      expect(vm.confirmPasswordError, isNotNull);

      vm.setConfirmPassword('Test123456!');
      expect(vm.confirmPasswordError, isNull);
    });

    test('password strength levels', () {
      vm.setPassword('');
      expect(vm.passwordStrength, PasswordStrength.none);

      vm.setPassword('abc');
      expect(vm.passwordStrength, PasswordStrength.weak);

      vm.setPassword('Abcdef12');
      expect(vm.passwordStrength, PasswordStrength.medium);

      vm.setPassword('Abcdef12!XYZ');
      expect(vm.passwordStrength, PasswordStrength.strong);
    });

    test('togglePasswordVisibility works', () {
      expect(vm.obscurePassword, isTrue);
      vm.togglePasswordVisibility();
      expect(vm.obscurePassword, isFalse);
    });

    test('toggleConfirmPasswordVisibility works', () {
      expect(vm.obscureConfirmPassword, isTrue);
      vm.toggleConfirmPasswordVisibility();
      expect(vm.obscureConfirmPassword, isFalse);
    });

    test('canSubmit requires email + password + terms (if configured)', () {
      vm.setEmail('user@test.com');
      vm.setPassword('Test123456!');

      // If showTermsCheckbox is true, need to accept
      if (vm.config.showTermsCheckbox) {
        expect(vm.canSubmit, isFalse);
        vm.setAcceptedTerms(true);
      }
      expect(vm.canSubmit, isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // RegisterViewModel — Real Registration (Supabase)
  // ═══════════════════════════════════════════════════════════════════════════

  group('RegisterViewModel — Real Registration', () {
    late String testEmail;
    const testPassword = 'Test123456!';

    setUp(() {
      testEmail = generateVmTestEmail();
    });

    tearDown(() async {
      await ViewModelTestHelper.signOut();
      await ViewModelTestHelper.deleteUser(testEmail);
    });

    test('register() creates a real user in Supabase', () async {
      final vm = RegisterViewModel();

      vm.setFirstName('Register');
      vm.setLastName('TestUser');
      vm.setEmail(testEmail);
      vm.setPassword(testPassword);

      if (vm.config.showTermsCheckbox) {
        vm.setAcceptedTerms(true);
      }

      expect(vm.canSubmit, isTrue);

      // register() calls _navigationService.clearStackAndShow on success,
      // which throws in tests (no navigator). We catch it.
      try {
        await vm.register();
      } catch (_) {}

      // Give auth listener time to update
      await Future.delayed(const Duration(milliseconds: 300));

      // After successful registration, the session should be active
      final sessionUser =
          ViewModelTestHelper.supabaseService.client.auth.currentUser;
      expect(sessionUser, isNotNull,
          reason: 'signUp should auto-sign-in the new user');
      expect(sessionUser!.email, testEmail);
    });

    test('register() does nothing when canSubmit is false', () async {
      final vm = RegisterViewModel();
      // Don't fill any fields

      expect(vm.canSubmit, isFalse);
      await vm.register();
      expect(vm.hasError, isFalse);
    });
  });
}
