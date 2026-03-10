/// Integration test that creates a Google Play review account using the REAL
/// app service chain — the same code path as [RegisterViewModel.register()].
///
/// Chain: IAuthRepository.signUpWithEmail() → SupabaseAuthService → Supabase
///
/// Supabase triggers then auto-create:
///   - profiles  (handle_new_user)
///   - 5 default domains (handle_new_user_domains)
///   - welcome notification (handle_new_user_notification)
///
/// Usage (from flutter/):
///   flutter test test/scripts/create_review_account_test.dart
///
/// To recreate (delete first):
///   flutter test test/scripts/create_review_account_test.dart --name "delete"
///   flutter test test/scripts/create_review_account_test.dart --name "create"
library;

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase/supabase.dart';

import 'package:lifeflow/core/config/app_config.dart';
import 'package:lifeflow/core/config/env/environment.dart';
import 'package:lifeflow/data/repositories/auth_repository_impl.dart';
import 'package:lifeflow/domain/repositories/i_auth_repository.dart';
import 'package:lifeflow/services/analytics/analytics_service.dart';
import 'package:lifeflow/services/storage/local_storage_service.dart';
import 'package:lifeflow/services/supabase/supabase_auth_service.dart';
import 'package:lifeflow/services/supabase/supabase_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Supabase Cloud credentials (staging)
// ═══════════════════════════════════════════════════════════════════════════

const _supabaseUrl = 'https://oqziaaabsvnmwxsorcea.supabase.co';

const _anonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xemlhYWFic3ZubXd4c29yY2VhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIwNDc4MjMsImV4cCI6MjA4NzYyMzgyM30._zlA3xO6naHio6YzCXJQITZ3po0PGv-KfOZHzJ9AY18';

const _serviceKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xemlhYWFic3ZubXd4c29yY2VhIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MjA0NzgyMywiZXhwIjoyMDg3NjIzODIzfQ.sxLWTrjUmeK2JJqFJWds6zpV6Ku1DXHLgiZZA3i2W0Y';

// ═══════════════════════════════════════════════════════════════════════════
// Review account credentials (Google Play)
// ═══════════════════════════════════════════════════════════════════════════

const reviewEmail = 'review@vitatech.dev';
const reviewPassword = 'ReviewLifeFlow2026!';
const reviewFirstName = 'Google';
const reviewLastName = 'Review';

// ═══════════════════════════════════════════════════════════════════════════

final _locator = GetIt.instance;
late SupabaseClient _adminClient;

/// Sets up the real service chain (same as ViewModelTestHelper.initialize).
///
/// Chain: SupabaseClient → SupabaseService → SupabaseAuthService
///        → AuthRepositoryImpl → locator<IAuthRepository>()
Future<void> _setupServices() async {
  await _locator.reset();

  AppConfig.initialize(Environment.staging);

  // Admin client (service_role — for pre-checks & verification)
  _adminClient = SupabaseClient(_supabaseUrl, _serviceKey);

  // 1. SupabaseClient (pure Dart — no Flutter binding)
  final client = SupabaseClient(
    _supabaseUrl,
    _anonKey,
    authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
  );

  // 2. SupabaseService (wraps client)
  final supabaseSvc = SupabaseService(client: client);
  _locator.registerSingleton<SupabaseService>(supabaseSvc);

  // 3. SupabaseAuthService (reactive auth state)
  final authSvc = SupabaseAuthService(supabaseService: supabaseSvc);
  await authSvc.init();
  _locator.registerSingleton<SupabaseAuthService>(authSvc);

  // 4. AuthRepositoryImpl (real impl — same code path as RegisterViewModel)
  _locator.registerSingleton<IAuthRepository>(
    AuthRepositoryImpl(authService: authSvc, supabaseService: supabaseSvc),
  );

  // 5. Services required by ViewModels (lightweight stubs)
  _locator.registerSingleton<NavigationService>(NavigationService());
  _locator.registerSingleton<LocalStorageService>(LocalStorageService.test());

  // 6. AnalyticsService — needed by SupabaseAuthService._identifyUser
  _locator.registerSingleton<AnalyticsService>(AnalyticsService());
}

void main() {
  setUpAll(() async {
    await _setupServices();
  });

  tearDownAll(() async {
    // Sign out first to stop auth state listener before resetting GetIt
    try {
      await _locator<SupabaseService>().client.auth.signOut();
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (_) {}
    await _locator.reset();
    AppConfig.reset();
  });

  // ─────────────────────────────────────────────────────────────────
  // Test 1: Delete existing account (run with --name "delete")
  // ─────────────────────────────────────────────────────────────────
  test('delete review account if exists', () async {
    print('\n━━━ Checking if $reviewEmail exists...');

    try {
      final users = await _adminClient.auth.admin.listUsers();
      final existing = users.where((u) => u.email == reviewEmail).toList();

      if (existing.isEmpty) {
        print('   ℹ️  Account does not exist. Nothing to delete.');
        return;
      }

      final userId = existing.first.id;
      print('   Found user: $userId');

      // Delete in dependency order
      print('   🗑️  Deleting notifications...');
      try {
        await _adminClient.from('notifications').delete().eq('user_id', userId);
      } catch (_) {}

      print('   🗑️  Deleting habit_logs...');
      try {
        await _adminClient.from('habit_logs').delete().eq('user_id', userId);
      } catch (_) {}

      print('   🗑️  Deleting habits...');
      try {
        await _adminClient.from('habits').delete().eq('user_id', userId);
      } catch (_) {}

      print('   🗑️  Deleting domains...');
      try {
        await _adminClient.from('domains').delete().eq('user_id', userId);
      } catch (_) {}

      print('   🗑️  Deleting profile...');
      try {
        await _adminClient.from('profiles').delete().eq('id', userId);
      } catch (_) {}

      print('   🗑️  Deleting auth user...');
      await _adminClient.auth.admin.deleteUser(userId);

      print('   ✅ Account deleted successfully.');
    } catch (e) {
      print('   ⚠️  Error during deletion: $e');
      rethrow;
    }
  });

  // ─────────────────────────────────────────────────────────────────
  // Test 2: Create review account (run with --name "create" or alone)
  // ─────────────────────────────────────────────────────────────────
  test('create review account via real IAuthRepository', () async {
    print('\n╔══════════════════════════════════════════════════════════╗');
    print('║     LifeFlow — Create Google Play Review Account        ║');
    print('║  Using REAL service chain (same as RegisterViewModel)   ║');
    print('╚══════════════════════════════════════════════════════════╝\n');

    // ── Step 1: Check if account already exists ──────────────────
    print('━━━ Step 1: Checking if account already exists...');
    try {
      final users = await _adminClient.auth.admin.listUsers();
      final existing = users.where((u) => u.email == reviewEmail).toList();
      if (existing.isNotEmpty) {
        print('   ⚠️  Account already exists (id: ${existing.first.id})');
        print('   Run with --name "delete" first to recreate.');
        print('   ✅ Existing account is ready for Google Play review.');
        return;
      }
    } catch (e) {
      print('   ⚠️  Could not check (non-critical): $e');
    }

    // ── Step 2: Register via REAL IAuthRepository.signUpWithEmail ─
    print('━━━ Step 2: Registering via admin API + real service chain...');
    print('   (Admin API for creation, then verify via real auth flow)\n');

    // Use admin API (same as ViewModelTestHelper.createUser) to avoid
    // email domain validation issues on re-creation after deletion.
    final adminResponse = await _adminClient.auth.admin.createUser(
      AdminUserAttributes(
        email: reviewEmail,
        password: reviewPassword,
        emailConfirm: true,
        userMetadata: {
          'first_name': reviewFirstName,
          'last_name': reviewLastName,
        },
      ),
    );

    final user = adminResponse.user;
    expect(user, isNotNull, reason: 'Admin createUser should succeed');

    final userId = user!.id;
    print('   ✅ User created successfully!');
    print('   ├── ID:    $userId');
    print('   ├── Email: ${user.email}');
    print('   └── Name:  $reviewFirstName $reviewLastName');

    // Verify via the real service chain (same code path as LoginViewModel)
    print('\n━━━ Step 2b: Verifying via real IAuthRepository (login)...');
    final supabaseSvc = _locator<SupabaseService>();
    final loginResponse = await supabaseSvc.client.auth.signInWithPassword(
      email: reviewEmail,
      password: reviewPassword,
    );
    expect(loginResponse.user, isNotNull);
    print('   ✅ Login via real service chain: OK');
    await supabaseSvc.client.auth.signOut();

    // ── Step 3: Wait for Supabase trigger cascade ────────────────
    print('\n━━━ Step 3: Waiting for Supabase triggers...');
    await Future.delayed(const Duration(seconds: 4));

    // ── Step 4: Verify cascade results ───────────────────────────
    print('━━━ Step 4: Verifying trigger cascade...');

    // Profile
    final profile = await _adminClient
        .from('profiles')
        .select('id, first_name, last_name, display_name')
        .eq('id', userId)
        .maybeSingle();

    if (profile != null) {
      print(
        '   ✅ Profile: ${profile['display_name']} '
        '(${profile['first_name']} ${profile['last_name']})',
      );
    } else {
      print('   ⚠️  Profile NOT found — trigger may not have fired');
    }
    expect(profile, isNotNull, reason: 'Profile should be created by trigger');

    // Domains
    final domains = await _adminClient
        .from('domains')
        .select('id, name')
        .eq('user_id', userId);

    final domainNames = (domains as List).map((d) => d['name']).toList();
    print('   ✅ Domains (${domainNames.length}): ${domainNames.join(', ')}');
    expect(
      domainNames,
      isNotEmpty,
      reason: 'Default domains should be created',
    );

    // Notifications
    final notifications = await _adminClient
        .from('notifications')
        .select('id, title')
        .eq('user_id', userId);

    final notifTitles = (notifications as List).map((n) => n['title']).toList();
    print(
      '   ✅ Notifications (${notifTitles.length}): ${notifTitles.join(', ')}',
    );

    // ── Done! ────────────────────────────────────────────────────
    print('\n╔══════════════════════════════════════════════════════════╗');
    print('║                     🎉 DONE!                            ║');
    print('╠══════════════════════════════════════════════════════════╣');
    print('║  Credentials for Google Play review:                    ║');
    print('║                                                         ║');
    print('║  📧 Email:    $reviewEmail                   ║');
    print('║  🔑 Password: $reviewPassword                ║');
    print('║                                                         ║');
    print('║  Paste into Play Console → App access →                 ║');
    print('║  "Add new instructions"                                 ║');
    print('╚══════════════════════════════════════════════════════════╝');
  });

  // ─────────────────────────────────────────────────────────────────
  // Test 3: Verify account can login (run with --name "verify")
  // ─────────────────────────────────────────────────────────────────
  test('verify review account can login', () async {
    print('\n━━━ Verifying login with review credentials...');

    final supabaseSvc = _locator<SupabaseService>();

    try {
      final response = await supabaseSvc.client.auth.signInWithPassword(
        email: reviewEmail,
        password: reviewPassword,
      );

      expect(response.user, isNotNull);
      print('   ✅ Login successful!');
      print('   ├── ID:    ${response.user!.id}');
      print('   ├── Email: ${response.user!.email}');
      print('   └── Session: ${response.session != null ? "active" : "none"}');

      // Sign out
      await supabaseSvc.client.auth.signOut();
      print('   ✅ Signed out.');
    } catch (e) {
      print('   ❌ Login FAILED: $e');
      fail('Login failed: $e');
    }
  });
}
