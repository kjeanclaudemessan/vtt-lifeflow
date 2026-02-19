import 'dart:async';

import '../supabase_test_helper.dart';

/// Helper class for optional modules integration tests.
class OptionalTestHelper {
  /// Creates a test organization and returns its ID.
  ///
  /// The [ownerId] must be the ID of an existing user.
  static Future<String> createTestOrganization({
    required String ownerId,
    String? name,
    String? slug,
  }) async {
    final orgName = name ?? 'Test Org ${DateTime.now().millisecondsSinceEpoch}';
    final orgSlug = slug ?? 'test-org-${DateTime.now().millisecondsSinceEpoch}';

    final response = await SupabaseTestHelper.adminClient
        .from('organizations')
        .insert({
          'name': orgName,
          'slug': orgSlug,
          'description': 'Test organization',
          'owner_id': ownerId,
        })
        .select()
        .single();

    return response['id'] as String;
  }

  /// Deletes a test organization.
  static Future<void> deleteTestOrganization(String orgId) async {
    try {
      await SupabaseTestHelper.adminClient
          .from('organizations')
          .delete()
          .eq('id', orgId);
    } catch (_) {
      // Ignore cleanup errors
    }
  }

  /// Creates a test plan and returns its ID.
  ///
  /// The [priceMonthly] is in cents (smallest currency unit).
  static Future<String> createTestPlan({
    String? name,
    String? code,
    int priceMonthly = 999,
    int? priceYearly,
  }) async {
    final planName =
        name ?? 'Test Plan ${DateTime.now().millisecondsSinceEpoch}';
    final planCode =
        code ?? 'test-plan-${DateTime.now().millisecondsSinceEpoch}';

    final response = await SupabaseTestHelper.adminClient
        .from('plans')
        .insert({
          'name': planName,
          'code': planCode,
          'price_monthly': priceMonthly,
          'price_yearly': priceYearly ?? priceMonthly * 10,
          'currency': 'XOF',
          'features': ['feature1', 'feature2'],
          'limits': {'max_members': 5, 'storage_gb': 10},
          'is_active': true,
        })
        .select()
        .single();

    return response['id'] as String;
  }

  /// Deletes a test plan.
  static Future<void> deleteTestPlan(String planId) async {
    try {
      await SupabaseTestHelper.adminClient
          .from('plans')
          .delete()
          .eq('id', planId);
    } catch (_) {
      // Ignore cleanup errors
    }
  }

  /// Creates a test tag and returns its ID.
  static Future<String> createTestTag({
    required String userId,
    String? name,
    String? color,
  }) async {
    final tagName = name ?? 'Test Tag ${DateTime.now().millisecondsSinceEpoch}';

    final response = await SupabaseTestHelper.adminClient
        .from('tags')
        .insert({
          'name': tagName,
          'slug': tagName.toLowerCase().replaceAll(' ', '-'),
          'user_id': userId,
          'color': color ?? '#FF5733',
        })
        .select()
        .single();

    return response['id'] as String;
  }

  /// Deletes a test tag.
  static Future<void> deleteTestTag(String tagId) async {
    try {
      await SupabaseTestHelper.adminClient
          .from('tags')
          .delete()
          .eq('id', tagId);
    } catch (_) {
      // Ignore cleanup errors
    }
  }

  /// Cleans up all test data for optional modules.
  static Future<void> cleanupAllTestData() async {
    try {
      // Delete test activities
      await SupabaseTestHelper.adminClient
          .from('activities')
          .delete()
          .ilike('target_type', 'test%');

      // Delete test comments
      await SupabaseTestHelper.adminClient
          .from('comments')
          .delete()
          .ilike('commentable_type', 'test%');

      // Delete test favorites
      await SupabaseTestHelper.adminClient
          .from('favorites')
          .delete()
          .ilike('favoritable_type', 'test%');

      // Delete test attachments
      await SupabaseTestHelper.adminClient
          .from('attachments')
          .delete()
          .ilike('attachable_type', 'test%');

      // Delete test taggables
      await SupabaseTestHelper.adminClient
          .from('taggables')
          .delete()
          .ilike('taggable_type', 'test%');

      // Delete test tags (user-scoped)
      await SupabaseTestHelper.adminClient
          .from('tags')
          .delete()
          .ilike('name', 'Test%');

      // Delete test payments
      await SupabaseTestHelper.adminClient
          .from('payments')
          .delete()
          .ilike('description', 'Test%');

      // Delete test subscriptions
      await SupabaseTestHelper.adminClient
          .from('subscriptions')
          .delete()
          .neq('id', '00000000-0000-0000-0000-000000000000');

      // Delete test invitations
      await SupabaseTestHelper.adminClient
          .from('invitations')
          .delete()
          .ilike('email', 'test%');

      // Delete test organizations
      await SupabaseTestHelper.adminClient
          .from('organizations')
          .delete()
          .ilike('name', 'Test%');

      // Delete test plans
      await SupabaseTestHelper.adminClient
          .from('plans')
          .delete()
          .ilike('name', 'Test%');
    } catch (_) {
      // Ignore cleanup errors
    }
  }
}
