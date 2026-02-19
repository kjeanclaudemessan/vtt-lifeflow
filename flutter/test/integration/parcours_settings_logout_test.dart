/// Parcours 3 — Login → Settings → Logout → Re-Login
///
/// End-to-end flow: user logs in, changes settings (theme, locale),
/// logs out, re-logs in, and verifies settings are restored.
///
/// Run: dart test test/integration/parcours_settings_logout_test.dart
/// Requires: `supabase start` running locally.
@TestOn('vm')
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/modules/auth/viewmodels/login_viewmodel.dart';
import 'package:lifeflow/modules/settings/viewmodels/settings_viewmodel.dart';

import 'viewmodel_test_helper.dart';

void main() {
  late String testEmail;
  const testPassword = 'Test123456!';

  setUpAll(() async {
    await ViewModelTestHelper.initialize();
  });

  setUp(() async {
    await ViewModelTestHelper.signOut();
    // Clear localStorage between tests to avoid leaking state
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
  // Parcours 3 — Login → Settings → Logout → Re-Login
  // ═══════════════════════════════════════════════════════════════════════════

  group('Parcours 3 — Login → Settings → Logout → Re-Login', () {
    test('P3-1: Login → session active', () async {
      final loginVm = LoginViewModel();
      loginVm.setEmail(testEmail);
      loginVm.setPassword(testPassword);

      try {
        await loginVm.loginWithEmail();
      } catch (_) {}

      expect(loginVm.hasError, isFalse);
      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
    });

    test('P3-2: SettingsVM.init() → loads preferences', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final settingsVm = SettingsViewModel();
      await settingsVm.init();

      // Default values
      expect(settingsVm.themeMode, ThemeMode.system);
      expect(settingsVm.locale, const Locale('fr'));
      expect(settingsVm.pushNotificationsEnabled, isTrue);
      expect(settingsVm.emailNotificationsEnabled, isTrue);
      expect(settingsVm.hasError, isFalse);
    });

    test('P3-3: SettingsVM.setThemeMode(dark) → persists in LocalStorage',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final settingsVm = SettingsViewModel();
      await settingsVm.init();

      await settingsVm.setThemeMode(ThemeMode.dark);
      expect(settingsVm.themeMode, ThemeMode.dark);

      // Verify persistence
      final stored = ViewModelTestHelper.localStorage.getInt('theme_mode');
      expect(stored, ThemeMode.dark.index);
    });

    test('P3-4: SettingsVM.setLocale(en) → persists in LocalStorage', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final settingsVm = SettingsViewModel();
      await settingsVm.init();

      await settingsVm.setLocale(const Locale('en'));
      expect(settingsVm.locale, const Locale('en'));

      // Verify persistence
      final stored = ViewModelTestHelper.localStorage.getString('locale');
      expect(stored, 'en');
    });

    test('P3-5: SettingsVM.logout() → calls authRepository.signOut()',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final settingsVm = SettingsViewModel();
      await settingsVm.init();

      // TestDialogService auto-confirms
      try {
        await settingsVm.logout();
      } catch (_) {} // NavigationService throws

      expect(settingsVm.hasError, isFalse);
    });

    test('P3-6: Session is null after logout', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final settingsVm = SettingsViewModel();
      await settingsVm.init();

      try {
        await settingsVm.logout();
      } catch (_) {}

      await Future.delayed(const Duration(milliseconds: 200));
      expect(ViewModelTestHelper.supabaseService.currentUser, isNull);
    });

    test('P3-7: Re-login with same credentials → session restored', () async {
      // Login
      await ViewModelTestHelper.signIn(email: testEmail);

      // Logout via SettingsVM
      final settingsVm = SettingsViewModel();
      await settingsVm.init();
      try {
        await settingsVm.logout();
      } catch (_) {}

      await Future.delayed(const Duration(milliseconds: 200));

      // Re-login
      final loginVm = LoginViewModel();
      loginVm.setEmail(testEmail);
      loginVm.setPassword(testPassword);
      try {
        await loginVm.loginWithEmail();
      } catch (_) {}

      expect(loginVm.hasError, isFalse);
      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
    });

    test('P3-8: SettingsVM.init() → preferences restored from LocalStorage',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      // Set preferences
      final settingsVm1 = SettingsViewModel();
      await settingsVm1.init();
      await settingsVm1.setThemeMode(ThemeMode.dark);
      await settingsVm1.setLocale(const Locale('en'));
      await settingsVm1.togglePushNotifications(false);

      // Logout
      try {
        await settingsVm1.logout();
      } catch (_) {}

      await Future.delayed(const Duration(milliseconds: 200));

      // Re-login
      await ViewModelTestHelper.signIn(email: testEmail);

      // Load settings again with a FRESH ViewModel
      final settingsVm2 = SettingsViewModel();
      await settingsVm2.init();

      // Preferences should be restored from LocalStorage
      expect(settingsVm2.themeMode, ThemeMode.dark);
      expect(settingsVm2.locale, const Locale('en'));
      expect(settingsVm2.pushNotificationsEnabled, isFalse);
    });
  });
}
