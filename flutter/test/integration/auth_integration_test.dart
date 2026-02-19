import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';

import 'supabase_test_config.dart';
import 'supabase_test_helper.dart';

/// Integration tests for Supabase Authentication.
///
/// These tests run against a local Supabase instance.
/// Make sure `supabase start` is running before executing.
///
/// Note: Tests use admin API to create users since signUp requires PKCE
/// which needs asyncStorage not available in pure Dart tests.
void main() {
  setUpSupabaseTests();

  group('Supabase Auth Integration Tests', () {
    // ═══════════════════════════════════════════════════════════════════════════
    // ADMIN USER CREATION TESTS (for setup)
    // ═══════════════════════════════════════════════════════════════════════════

    group('admin user creation', () {
      test('should create a user via admin API', () async {
        // Arrange
        final email = generateTestEmail();
        const password = 'Test123456!';

        // Act
        final user = await SupabaseTestHelper.createTestUser(
          email: email,
          password: password,
        );

        // Assert
        expect(user, isNotNull);
        expect(user.email, equals(email));
        expect(user.id, isNotEmpty);

        // Cleanup
        await SupabaseTestHelper.deleteTestUser(email);
      });

      test('should create user with metadata via admin API', () async {
        // Arrange
        final email = generateTestEmail();
        const password = 'Test123456!';
        const firstName = 'John';
        const lastName = 'Doe';

        // Act
        final user = await SupabaseTestHelper.createTestUser(
          email: email,
          password: password,
          metadata: {
            'first_name': firstName,
            'last_name': lastName,
          },
        );

        // Assert
        expect(user, isNotNull);
        expect(user.userMetadata?['first_name'], equals(firstName));
        expect(user.userMetadata?['last_name'], equals(lastName));

        // Cleanup
        await SupabaseTestHelper.deleteTestUser(email);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // SIGN IN TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('signInWithPassword', () {
      late String testEmail;
      const testPassword = 'Test123456!';

      setUp(() async {
        // Create a test user before each sign in test
        testEmail = generateTestEmail();
        await SupabaseTestHelper.createTestUser(
          email: testEmail,
          password: testPassword,
        );
      });

      tearDown(() async {
        await SupabaseTestHelper.deleteTestUser(testEmail);
      });

      test('should sign in with valid credentials', () async {
        // Act
        final response =
            await SupabaseTestHelper.client.auth.signInWithPassword(
          email: testEmail,
          password: testPassword,
        );

        // Assert
        expect(response.user, isNotNull);
        expect(response.user!.email, equals(testEmail));
        expect(response.session, isNotNull);
        expect(response.session!.accessToken, isNotEmpty);
      });

      test('should fail with wrong password', () async {
        // Act & Assert
        expect(
          () => SupabaseTestHelper.client.auth.signInWithPassword(
            email: testEmail,
            password: 'WrongPassword123!',
          ),
          throwsA(isA<AuthException>()),
        );
      });

      test('should fail with non-existent email', () async {
        // Act & Assert
        expect(
          () => SupabaseTestHelper.client.auth.signInWithPassword(
            email: 'nonexistent@example.com',
            password: testPassword,
          ),
          throwsA(isA<AuthException>()),
        );
      });

      test('should provide valid session after sign in', () async {
        // Act
        final response =
            await SupabaseTestHelper.client.auth.signInWithPassword(
          email: testEmail,
          password: testPassword,
        );

        // Assert
        expect(response.session, isNotNull);
        expect(response.session!.accessToken, isNotEmpty);
        expect(response.session!.refreshToken, isNotEmpty);
        expect(response.session!.expiresIn, greaterThan(0));
      });

      test('should set current user after sign in', () async {
        // Act
        await SupabaseTestHelper.client.auth.signInWithPassword(
          email: testEmail,
          password: testPassword,
        );

        // Assert
        expect(SupabaseTestHelper.client.auth.currentUser, isNotNull);
        expect(SupabaseTestHelper.client.auth.currentUser!.email, equals(testEmail));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // SIGN OUT TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('signOut', () {
      test('should sign out successfully', () async {
        // Arrange - create and sign in
        final email = generateTestEmail();
        const password = 'Test123456!';
        await SupabaseTestHelper.createTestUser(email: email, password: password);
        await SupabaseTestHelper.client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        expect(SupabaseTestHelper.client.auth.currentUser, isNotNull);

        // Act
        await SupabaseTestHelper.client.auth.signOut();

        // Assert
        expect(SupabaseTestHelper.client.auth.currentUser, isNull);
        expect(SupabaseTestHelper.client.auth.currentSession, isNull);

        // Cleanup
        await SupabaseTestHelper.deleteTestUser(email);
      });

      test('should not throw when not logged in', () async {
        // Ensure signed out
        await SupabaseTestHelper.signOut();

        // Act & Assert - should not throw
        await expectLater(
          SupabaseTestHelper.client.auth.signOut(),
          completes,
        );
      });
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // CURRENT USER TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('currentUser', () {
      test('should return null when not authenticated', () async {
        // Ensure signed out
        await SupabaseTestHelper.signOut();

        // Assert
        expect(SupabaseTestHelper.client.auth.currentUser, isNull);
      });

      test('should return user when authenticated', () async {
        // Arrange
        final email = generateTestEmail();
        const password = 'Test123456!';
        await SupabaseTestHelper.createTestUser(email: email, password: password);
        await SupabaseTestHelper.client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        // Assert
        expect(SupabaseTestHelper.client.auth.currentUser, isNotNull);
        expect(SupabaseTestHelper.client.auth.currentUser!.email, equals(email));

        // Cleanup
        await SupabaseTestHelper.signOut();
        await SupabaseTestHelper.deleteTestUser(email);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // UPDATE USER TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('updateUser', () {
      late String testEmail;
      const testPassword = 'Test123456!';

      setUp(() async {
        testEmail = generateTestEmail();
        await SupabaseTestHelper.createTestUser(
          email: testEmail,
          password: testPassword,
        );
        await SupabaseTestHelper.client.auth.signInWithPassword(
          email: testEmail,
          password: testPassword,
        );
      });

      tearDown(() async {
        await SupabaseTestHelper.signOut();
        await SupabaseTestHelper.deleteTestUser(testEmail);
      });

      test('should update user metadata', () async {
        // Act
        final response = await SupabaseTestHelper.client.auth.updateUser(
          UserAttributes(
            data: {
              'first_name': 'Updated',
              'last_name': 'Name',
            },
          ),
        );

        // Assert
        expect(response.user, isNotNull);
        expect(response.user!.userMetadata?['first_name'], equals('Updated'));
        expect(response.user!.userMetadata?['last_name'], equals('Name'));
      });

      test('should update password', () async {
        // Act
        const newPassword = 'NewPassword123!';
        await SupabaseTestHelper.client.auth.updateUser(
          UserAttributes(password: newPassword),
        );

        // Sign out and sign back in with new password
        await SupabaseTestHelper.signOut();

        final response =
            await SupabaseTestHelper.client.auth.signInWithPassword(
          email: testEmail,
          password: newPassword,
        );

        // Assert
        expect(response.user, isNotNull);
      });

      test('should preserve existing metadata when updating', () async {
        // Arrange - set initial metadata
        await SupabaseTestHelper.client.auth.updateUser(
          UserAttributes(
            data: {
              'first_name': 'Initial',
              'custom_field': 'custom_value',
            },
          ),
        );

        // Act - update only first_name
        final response = await SupabaseTestHelper.client.auth.updateUser(
          UserAttributes(
            data: {
              'first_name': 'Updated',
            },
          ),
        );

        // Assert - custom_field should still exist
        expect(response.user!.userMetadata?['first_name'], equals('Updated'));
        expect(response.user!.userMetadata?['custom_field'], equals('custom_value'));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // SESSION TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('session', () {
      test('should have valid access token after sign in', () async {
        // Arrange
        final email = generateTestEmail();
        const password = 'Test123456!';
        await SupabaseTestHelper.createTestUser(email: email, password: password);

        // Act
        final response = await SupabaseTestHelper.client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        // Assert
        expect(response.session!.accessToken, isNotEmpty);
        expect(response.session!.accessToken.split('.').length, equals(3)); // JWT format

        // Cleanup
        await SupabaseTestHelper.signOut();
        await SupabaseTestHelper.deleteTestUser(email);
      });

      test('should have refresh token after sign in', () async {
        // Arrange
        final email = generateTestEmail();
        const password = 'Test123456!';
        await SupabaseTestHelper.createTestUser(email: email, password: password);

        // Act
        final response = await SupabaseTestHelper.client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        // Assert
        expect(response.session!.refreshToken, isNotEmpty);

        // Cleanup
        await SupabaseTestHelper.signOut();
        await SupabaseTestHelper.deleteTestUser(email);
      });

      test('should have expiration time', () async {
        // Arrange
        final email = generateTestEmail();
        const password = 'Test123456!';
        await SupabaseTestHelper.createTestUser(email: email, password: password);

        // Act
        final response = await SupabaseTestHelper.client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        // Assert
        expect(response.session!.expiresIn, greaterThan(0));
        expect(response.session!.expiresAt, isNotNull);

        // Cleanup
        await SupabaseTestHelper.signOut();
        await SupabaseTestHelper.deleteTestUser(email);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // ADMIN OPERATIONS TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('admin operations', () {
      test('should list users via admin API', () async {
        // Arrange
        final email = generateTestEmail();
        await SupabaseTestHelper.createTestUser(email: email, password: 'Test123456!');

        // Act
        final users = await SupabaseTestHelper.adminClient.auth.admin.listUsers();

        // Assert
        expect(users, isNotEmpty);
        expect(users.any((u) => u.email == email), isTrue);

        // Cleanup
        await SupabaseTestHelper.deleteTestUser(email);
      });

      test('should delete user via admin API', () async {
        // Arrange
        final email = generateTestEmail();
        final user = await SupabaseTestHelper.createTestUser(email: email, password: 'Test123456!');

        // Act
        await SupabaseTestHelper.adminClient.auth.admin.deleteUser(user.id);

        // Assert
        final users = await SupabaseTestHelper.adminClient.auth.admin.listUsers();
        expect(users.any((u) => u.email == email), isFalse);
      });

      test('should get user by ID via admin API', () async {
        // Arrange
        final email = generateTestEmail();
        final createdUser = await SupabaseTestHelper.createTestUser(
          email: email,
          password: 'Test123456!',
          metadata: {'test_field': 'test_value'},
        );

        // Act
        final user = await SupabaseTestHelper.adminClient.auth.admin.getUserById(createdUser.id);

        // Assert
        expect(user.user, isNotNull);
        expect(user.user!.email, equals(email));
        expect(user.user!.userMetadata?['test_field'], equals('test_value'));

        // Cleanup
        await SupabaseTestHelper.deleteTestUser(email);
      });
    });
  });
}
