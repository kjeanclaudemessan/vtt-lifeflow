import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';

import 'supabase_test_config.dart';

/// Helper class for Supabase integration tests.
class SupabaseTestHelper {
  static SupabaseClient? _client;
  static SupabaseClient? _adminClient;

  /// Initialize Supabase for testing (using direct client, not flutter).
  static Future<SupabaseClient> initialize() async {
    if (_client != null) return _client!;

    _client = SupabaseClient(
      testSupabaseUrl,
      testSupabaseAnonKey,
    );

    return _client!;
  }

  /// Get the Supabase client.
  static SupabaseClient get client {
    if (_client == null) {
      throw StateError('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  /// Get admin client for cleanup operations.
  static SupabaseClient get adminClient {
    _adminClient ??= SupabaseClient(
      testSupabaseUrl,
      testSupabaseServiceKey,
    );
    return _adminClient!;
  }

  /// Sign out current user.
  static Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (_) {
      // Ignore signout errors
    }
  }

  /// Clean up test user by email.
  static Future<void> deleteTestUser(String email) async {
    try {
      // Use admin client to find and delete user
      final users = await adminClient.auth.admin.listUsers();
      final user = users.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('User not found'),
      );
      await adminClient.auth.admin.deleteUser(user.id);
    } catch (_) {
      // User might not exist, ignore
    }
  }

  /// Clean up all test users (emails starting with test_).
  static Future<void> cleanupTestUsers() async {
    try {
      final users = await adminClient.auth.admin.listUsers();
      for (final user in users) {
        if (user.email?.startsWith('test_') == true ||
            user.email?.startsWith('test1@') == true ||
            user.email?.startsWith('test2@') == true) {
          await adminClient.auth.admin.deleteUser(user.id);
        }
      }
    } catch (_) {
      // Ignore cleanup errors
    }
  }

  /// Create a test user and return their credentials.
  static Future<User> createTestUser({
    String? email,
    String password = 'Test123456!',
    Map<String, dynamic>? metadata,
  }) async {
    final userEmail = email ?? generateTestEmail();

    final response = await adminClient.auth.admin.createUser(
      AdminUserAttributes(
        email: userEmail,
        password: password,
        emailConfirm: true,
        userMetadata: metadata,
      ),
    );

    if (response.user == null) {
      throw Exception('Failed to create test user');
    }

    return response.user!;
  }

  /// Wait for a condition to be true (useful for async operations).
  static Future<void> waitFor(
    Future<bool> Function() condition, {
    Duration timeout = const Duration(seconds: 5),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout) {
      if (await condition()) return;
      await Future.delayed(interval);
    }
    throw TimeoutException('Condition not met within timeout', timeout);
  }
}

/// Set up Supabase for all tests in a file.
void setUpSupabaseTests() {
  setUpAll(() async {
    await SupabaseTestHelper.initialize();
  });

  setUp(() async {
    // Sign out before each test to ensure clean state
    await SupabaseTestHelper.signOut();
  });

  tearDownAll(() async {
    await SupabaseTestHelper.signOut();
    await SupabaseTestHelper.cleanupTestUsers();
  });
}
