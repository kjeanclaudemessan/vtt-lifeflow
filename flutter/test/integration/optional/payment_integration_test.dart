import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase_test_config.dart';
import '../supabase_test_helper.dart';
import 'optional_test_helper.dart';

/// Integration tests for the Payments module.
///
/// Tests payment records, history, and refunds.
void main() {
  late User testUser;
  String? testOrgId;
  String? testPlanId;
  String? testSubscriptionId;
  String? testPaymentId;

  setUpAll(() async {
    await SupabaseTestHelper.initialize();

    // Create test user
    testUser = await SupabaseTestHelper.createTestUser(
      email: generateTestEmail(),
      metadata: {'first_name': 'Payment', 'last_name': 'Tester'},
    );

    // Create test organization
    testOrgId = await OptionalTestHelper.createTestOrganization(
      ownerId: testUser.id,
      name: 'Payment Test Org',
    );

    // Create test plan
    testPlanId = await OptionalTestHelper.createTestPlan(
      name: 'Payment Plan',
      code: 'payment-plan',
      priceMonthly: 2999,
    );

    // Create test subscription
    final now = DateTime.now();
    final subResponse = await SupabaseTestHelper.adminClient
        .from('subscriptions')
        .insert({
          'organization_id': testOrgId,
          'plan_id': testPlanId,
          'status': 'active',
          'billing_cycle': 'monthly',
          'current_period_start': now.toIso8601String(),
          'current_period_end':
              now.add(const Duration(days: 30)).toIso8601String(),
        })
        .select()
        .single();

    testSubscriptionId = subResponse['id'] as String;
  });

  tearDownAll(() async {
    if (testPaymentId != null) {
      await SupabaseTestHelper.adminClient
          .from('payments')
          .delete()
          .eq('id', testPaymentId!);
    }
    if (testSubscriptionId != null) {
      await SupabaseTestHelper.adminClient
          .from('subscriptions')
          .delete()
          .eq('id', testSubscriptionId!);
    }
    if (testPlanId != null) {
      await OptionalTestHelper.deleteTestPlan(testPlanId!);
    }
    if (testOrgId != null) {
      await OptionalTestHelper.deleteTestOrganization(testOrgId!);
    }
    await SupabaseTestHelper.deleteTestUser(testUser.email!);
  });

  group('Payments Integration Tests', () {
    group('create payment', () {
      test('should record successful payment', () async {
        // Arrange
        await SupabaseTestHelper.client.auth.signInWithPassword(
          email: testUser.email!,
          password: 'Test123456!',
        );

        // Act
        final response = await SupabaseTestHelper.adminClient
            .from('payments')
            .insert({
              'subscription_id': testSubscriptionId,
              'user_id': testUser.id,
              'amount': 2999,
              'currency': 'XOF',
              'status': 'success',
              'payment_method': 'card',
              'provider': 'moneroo',
              'provider_tx_id':
                  'pi_test_${DateTime.now().millisecondsSinceEpoch}',
            })
            .select()
            .single();

        testPaymentId = response['id'] as String;

        // Assert
        expect(testPaymentId, isNotNull);
        expect(response['amount'], equals(2999));
        expect(response['status'], equals('success'));
      });

      test('should link payment to subscription', () async {
        // Arrange
        await SupabaseTestHelper.client.auth.signInWithPassword(
          email: testUser.email!,
          password: 'Test123456!',
        );

        // Act
        final payment = await SupabaseTestHelper.adminClient
            .from('payments')
            .select('*, subscriptions(*)')
            .eq('id', testPaymentId!)
            .single();

        // Assert
        expect(payment['subscription_id'], equals(testSubscriptionId));
        expect(payment['subscriptions'], isNotNull);
      });
    });

    group('payment history', () {
      test('should list user payments', () async {
        // Arrange
        await SupabaseTestHelper.client.auth.signInWithPassword(
          email: testUser.email!,
          password: 'Test123456!',
        );

        // Act
        final payments = await SupabaseTestHelper.client
            .from('payments')
            .select()
            .eq('user_id', testUser.id)
            .order('created_at', ascending: false);

        // Assert
        expect(payments, isNotEmpty);
        expect(payments.first['id'], equals(testPaymentId));
      });

      test('should record failed payment', () async {
        // Act
        final response = await SupabaseTestHelper.adminClient
            .from('payments')
            .insert({
              'subscription_id': testSubscriptionId,
              'user_id': testUser.id,
              'amount': 2999,
              'currency': 'XOF',
              'status': 'failed',
              'payment_method': 'card',
              'provider': 'moneroo',
              'provider_tx_id':
                  'pi_failed_${DateTime.now().millisecondsSinceEpoch}',
              'error_message': 'Card declined',
            })
            .select()
            .single();

        final failedPaymentId = response['id'] as String;

        try {
          // Assert
          expect(response['status'], equals('failed'));
          expect(response['error_message'], equals('Card declined'));
        } finally {
          // Cleanup
          await SupabaseTestHelper.adminClient
              .from('payments')
              .delete()
              .eq('id', failedPaymentId);
        }
      });
    });

    group('refunds', () {
      test('should record refund', () async {
        // Act - Use metadata to store refund reason since no dedicated column
        await SupabaseTestHelper.adminClient.from('payments').update({
          'status': 'refunded',
          'completed_at': DateTime.now().toIso8601String(),
          'metadata': {'refund_reason': 'Customer request'},
        }).eq('id', testPaymentId!);

        // Assert
        final payment = await SupabaseTestHelper.adminClient
            .from('payments')
            .select()
            .eq('id', testPaymentId!)
            .single();

        expect(payment['status'], equals('refunded'));
        expect(payment['completed_at'], isNotNull);
        expect(
            payment['metadata']['refund_reason'], equals('Customer request'));
      });

      test('should record partial refund', () async {
        // Arrange - Create a new payment for partial refund test
        final response = await SupabaseTestHelper.adminClient
            .from('payments')
            .insert({
              'subscription_id': testSubscriptionId,
              'user_id': testUser.id,
              'amount': 10000,
              'currency': 'XOF',
              'status': 'success',
              'payment_method': 'card',
              'provider': 'moneroo',
              'provider_tx_id':
                  'pi_partial_${DateTime.now().millisecondsSinceEpoch}',
            })
            .select()
            .single();

        final partialPaymentId = response['id'] as String;

        try {
          // Act - Store refund info in metadata
          await SupabaseTestHelper.adminClient.from('payments').update({
            'status': 'refunded',
            'metadata': {
              'original_amount': 10000,
              'refunded_amount': 5000,
              'refund_reason': 'Partial service cancellation',
            },
          }).eq('id', partialPaymentId);

          // Assert
          final payment = await SupabaseTestHelper.adminClient
              .from('payments')
              .select()
              .eq('id', partialPaymentId)
              .single();

          expect(payment['status'], equals('refunded'));
          expect(payment['metadata']['refunded_amount'], equals(5000));
        } finally {
          // Cleanup
          await SupabaseTestHelper.adminClient
              .from('payments')
              .delete()
              .eq('id', partialPaymentId);
        }
      });
    });

    group('organization payments', () {
      test('should record organization payment', () async {
        // Act
        final response = await SupabaseTestHelper.adminClient
            .from('payments')
            .insert({
              'subscription_id': testSubscriptionId,
              'organization_id': testOrgId,
              'amount': 29999,
              'currency': 'XOF',
              'status': 'success',
              'payment_method': 'invoice',
              'provider': 'moneroo',
              'provider_tx_id':
                  'pi_org_${DateTime.now().millisecondsSinceEpoch}',
            })
            .select()
            .single();

        final orgPaymentId = response['id'] as String;

        try {
          // Assert
          expect(response['organization_id'], equals(testOrgId));
          expect(response['amount'], equals(29999));
        } finally {
          // Cleanup
          await SupabaseTestHelper.adminClient
              .from('payments')
              .delete()
              .eq('id', orgPaymentId);
        }
      });
    });
  });
}
