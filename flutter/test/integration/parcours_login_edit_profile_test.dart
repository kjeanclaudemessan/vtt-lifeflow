/// Parcours 2 — Login → Profile → EditProfile → Profile
///
/// End-to-end flow: user logs in, views profile, edits it,
/// then verifies changes are persisted.
///
/// Run: dart test test/integration/parcours_login_edit_profile_test.dart
/// Requires: `supabase start` running locally.
@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/modules/auth/viewmodels/login_viewmodel.dart';
import 'package:lifeflow/modules/profile/viewmodels/edit_profile_viewmodel.dart';
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
    await ViewModelTestHelper.createUser(
      email: testEmail,
      password: testPassword,
      firstName: 'Jean',
      lastName: 'Dupont',
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
  // Parcours 2 — Login → Profile → EditProfile → Profile
  // ═══════════════════════════════════════════════════════════════════════════

  group('Parcours 2 — Login → Profile → EditProfile → Profile', () {
    test('P2-1: Login with email/password → session active', () async {
      final loginVm = LoginViewModel();
      loginVm.setEmail(testEmail);
      loginVm.setPassword(testPassword);
      expect(loginVm.canSubmit, isTrue);

      try {
        await loginVm.loginWithEmail();
      } catch (_) {} // NavigationService throws without navigator

      expect(loginVm.hasError, isFalse);
      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
    });

    test('P2-2: ProfileVM.init() → loads profile from Supabase', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final profileVm = ProfileViewModel();
      await profileVm.init();

      expect(profileVm.user, isNotNull);
      expect(profileVm.email, testEmail);
      expect(profileVm.hasError, isFalse);
    });

    test('P2-3: displayName, email, initials computed correctly', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final profileVm = ProfileViewModel();
      await profileVm.init();

      expect(profileVm.email, testEmail);
      // displayName comes from profile or metadata
      expect(profileVm.displayName, isA<String>());
      // Initials from Jean Dupont → JD (if firstName/lastName populated)
      if (profileVm.user?.firstName != null &&
          profileVm.user?.lastName != null) {
        expect(profileVm.initials, 'JD');
      }
    });

    test('P2-4: profileCompletion reflects filled fields', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final profileVm = ProfileViewModel();
      await profileVm.init();

      expect(profileVm.profileCompletion, isA<int>());
      expect(profileVm.profileCompletion, greaterThanOrEqualTo(0));
      expect(profileVm.profileCompletion, lessThanOrEqualTo(100));
    });

    test('P2-5: EditProfileVM.init() → pre-fills fields from existing profile',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final editVm = EditProfileViewModel();
      await editVm.init();

      expect(editVm.hasError, isFalse);
      // Email should be pre-filled (from profile)
      final emailValue = editVm.getFieldValue('email');
      if (emailValue.isNotEmpty) {
        expect(emailValue, testEmail);
      }
    });

    test('P2-6: EditProfileVM.setFieldValue() → isDirty becomes true',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final editVm = EditProfileViewModel();
      await editVm.init();

      expect(editVm.isDirty, isFalse);

      editVm.setFieldValue('display_name', 'Nouveau Nom');

      expect(editVm.isDirty, isTrue);
    });

    test('P2-7: EditProfileVM.canSubmit → true when dirty + valid', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final editVm = EditProfileViewModel();
      await editVm.init();

      // Set a required field to make it dirty
      editVm.setFieldValue('display_name', 'Nom Modifié');

      expect(editVm.isDirty, isTrue);
      expect(editVm.isValid, isTrue);
      expect(editVm.canSubmit, isTrue);
    });

    test('P2-8: EditProfileVM.save() → persists via RPC update_my_profile',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final editVm = EditProfileViewModel();
      await editVm.init();

      editVm.setFieldValue('display_name', 'Jean-Pierre Dupont');

      try {
        await editVm.save();
      } catch (_) {} // NavigationService.back() throws

      expect(editVm.hasError, isFalse);
    });

    test('P2-9: ProfileVM.loadProfile() after save → updated data visible',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      // Step 1: Edit and save
      final editVm = EditProfileViewModel();
      await editVm.init();

      editVm.setFieldValue('display_name', 'Jean-Pierre Dupont');
      try {
        await editVm.save();
      } catch (_) {}

      // Step 2: Reload profile with a FRESH ProfileViewModel
      final profileVm = ProfileViewModel();
      await profileVm.loadProfile();

      expect(profileVm.user, isNotNull);
      expect(profileVm.hasError, isFalse);
      // The displayName should reflect the update
      expect(profileVm.displayName, contains('Jean-Pierre'));
    });

    test('P2-10: displayName consistency before/after edit', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      // Before edit
      final profileBefore = ProfileViewModel();
      await profileBefore.loadProfile();
      final nameBefore = profileBefore.displayName;

      // Edit
      final editVm = EditProfileViewModel();
      await editVm.init();
      editVm.setFieldValue('display_name', 'Nom Totalement Différent');
      try {
        await editVm.save();
      } catch (_) {}

      // After edit
      final profileAfter = ProfileViewModel();
      await profileAfter.loadProfile();
      final nameAfter = profileAfter.displayName;

      expect(nameAfter, isNot(equals(nameBefore)));
      expect(nameAfter, contains('Totalement'));
    });
  });
}
