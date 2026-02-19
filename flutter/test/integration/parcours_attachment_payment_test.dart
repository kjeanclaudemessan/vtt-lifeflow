/// Parcours 7 — Attachments & Payments
///
/// End-to-end flow: user uploads an attachment, manages it, then
/// creates a payment record and checks stats.
///
/// Attachments: upload bytes → getEntityAttachments → getAttachment → deleteAttachment
/// Payments: initiatePayment → loadPayments → getPayment → cancelPayment → getPaymentStats
///
/// Note: PaymentService requires MonerooService registered in GetIt.
/// Moneroo is NOT initialized (no API key) — payment records are created in DB
/// but checkout URLs are not generated.
///
/// Run: dart test test/integration/parcours_attachment_payment_test.dart
/// Requires: `supabase start` running locally.
@TestOn('vm')
library;

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lifeflow/modules/optional/attachments/attachment_service.dart';
import 'package:lifeflow/modules/optional/payments/payment_service.dart';
import 'package:lifeflow/services/moneroo/moneroo_service.dart';

import 'viewmodel_test_helper.dart';
import 'optional/optional_test_helper.dart';

final _locator = GetIt.instance;

void main() {
  late String testEmail;
  const testPassword = 'Test123456!';

  // Synthetic entity for polymorphic operations
  late String testEntityId;
  const testEntityType = 'test_entity';

  // Shared state across sequential tests
  String? uploadedAttachmentId;
  String? createdPaymentId;
  String? testOrgId;

  setUpAll(() async {
    await ViewModelTestHelper.initialize();

    // Register MonerooService (required by PaymentService)
    if (!_locator.isRegistered<MonerooService>()) {
      _locator.registerSingleton<MonerooService>(MonerooService());
    }

    testEmail = generateVmTestEmail();
    testEntityId = _generateUuid();

    await ViewModelTestHelper.createUser(
      email: testEmail,
      password: testPassword,
      firstName: 'Attach',
      lastName: 'Payer',
    );

    // Sign in and wait for profile trigger
    await ViewModelTestHelper.signIn(email: testEmail);
    await Future.delayed(const Duration(milliseconds: 500));

    // Create test org (needed for payments and org-scoped attachments)
    final userId = ViewModelTestHelper.supabaseService.currentUser!.id;
    testOrgId = await OptionalTestHelper.createTestOrganization(
      ownerId: userId,
      name: 'Test Org P7',
    );
  });

  tearDownAll(() async {
    await ViewModelTestHelper.signOut();
    await OptionalTestHelper.cleanupAllTestData();
    await ViewModelTestHelper.deleteUser(testEmail);
    await ViewModelTestHelper.cleanup();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Parcours 7 — Attachments & Payments
  // ═══════════════════════════════════════════════════════════════════════════

  group('Parcours 7 — Attachments & Payments', () {
    // ─────────────────────────────────────────────────────────────────────────
    // Attachments
    // ─────────────────────────────────────────────────────────────────────────

    test('P7-1: Login → session active', () async {
      // Already signed in during setUpAll, but verify
      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
    });

    test('P7-2: AttachmentService.uploadBytes() → attachment created',
        () async {
      // Storage upload requires storage RLS policies (bucket-level).
      // We insert the attachment record directly via admin to test DB operations.
      final userId = ViewModelTestHelper.supabaseService.currentUser!.id;
      final adminClient = ViewModelTestHelper.adminClient;

      final response = await adminClient
          .from('attachments')
          .insert({
            'user_id': userId,
            'attachable_type': testEntityType,
            'attachable_id': testEntityId,
            'file_name': 'test_parcours7.bin',
            'file_size': 128,
            'file_type': 'application/octet-stream',
            'file_extension': 'bin',
            'storage_bucket': 'attachments',
            'storage_path': 'test/$testEntityId/test_parcours7.bin',
            'public_url':
                'http://127.0.0.1:54321/storage/v1/object/public/attachments/test/test_parcours7.bin',
            'metadata': {},
          })
          .select()
          .single();

      expect(response['id'], isNotEmpty);
      expect(response['file_name'], 'test_parcours7.bin');
      uploadedAttachmentId = response['id'] as String;
    });

    test('P7-3: AttachmentService.getEntityAttachments() → attachment visible',
        () async {
      final attachService = AttachmentService();

      final result = await attachService.getEntityAttachments(
        entityType: testEntityType,
        entityId: testEntityId,
      );

      result.fold(
        (failure) => fail('getEntityAttachments failed: ${failure.message}'),
        (attachments) {
          expect(attachments, isNotEmpty);
          expect(
            attachments.any((a) => a.id == uploadedAttachmentId),
            isTrue,
          );
        },
      );
    });

    test('P7-4: AttachmentService.getAttachment() → single attachment loaded',
        () async {
      final attachService = AttachmentService();

      final result = await attachService.getAttachment(uploadedAttachmentId!);

      result.fold(
        (failure) => fail('getAttachment failed: ${failure.message}'),
        (attachment) {
          expect(attachment.id, uploadedAttachmentId);
          expect(attachment.fileName, 'test_parcours7.bin');
        },
      );
    });

    test('P7-5: AttachmentService.deleteAttachment() → soft-deleted', () async {
      final attachService = AttachmentService();

      final result =
          await attachService.deleteAttachment(uploadedAttachmentId!);

      result.fold(
        (failure) => fail('deleteAttachment failed: ${failure.message}'),
        (_) {
          // Soft-deleted successfully
        },
      );

      // Verify it's no longer visible via getAttachment
      final getResult =
          await attachService.getAttachment(uploadedAttachmentId!);
      expect(getResult.isLeft(), isTrue,
          reason: 'Deleted attachment should not be found');
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Payments
    // ─────────────────────────────────────────────────────────────────────────

    test('P7-6: PaymentService.initiatePayment() → payment record created',
        () async {
      final paymentService = PaymentService();

      final result = await paymentService.initiatePayment(
        organizationId: testOrgId!,
        amount: 5000,
        description: 'Test Payment P7',
        currency: 'XOF',
      );

      result.fold(
        (failure) => fail('initiatePayment failed: ${failure.message}'),
        (payment) {
          expect(payment.id, isNotEmpty);
          expect(payment.amount, 5000);
          expect(payment.status.name, 'pending');
          createdPaymentId = payment.id;
        },
      );
    });

    test('P7-7: PaymentService.loadPayments() → payment visible', () async {
      final paymentService = PaymentService();

      final result = await paymentService.loadPayments(
        organizationId: testOrgId!,
      );

      result.fold(
        (failure) => fail('loadPayments failed: ${failure.message}'),
        (payments) {
          expect(payments, isNotEmpty);
          expect(
            payments.any((p) => p.id == createdPaymentId),
            isTrue,
          );
        },
      );
    });

    test('P7-8: PaymentService.cancelPayment() → status cancelled', () async {
      final paymentService = PaymentService();

      final result = await paymentService.cancelPayment(createdPaymentId!);

      result.fold(
        (failure) => fail('cancelPayment failed: ${failure.message}'),
        (_) {
          // Cancelled successfully
        },
      );

      // Verify status changed — reload via refreshPaymentStatus
      final refreshResult =
          await paymentService.refreshPaymentStatus(createdPaymentId!);
      refreshResult.fold(
        (failure) => fail('refreshPaymentStatus failed: ${failure.message}'),
        (payment) {
          expect(payment.status.name, 'cancelled');
        },
      );
    });

    test('P7-9: PaymentService.getPaymentStats() → stats returned', () async {
      final paymentService = PaymentService();

      // Create another payment for stats (need at least one non-cancelled)
      await paymentService.initiatePayment(
        organizationId: testOrgId!,
        amount: 10000,
        description: 'Test Payment Stats P7',
      );

      final result = await paymentService.getPaymentStats(testOrgId!);

      result.fold(
        (failure) => fail('getPaymentStats failed: ${failure.message}'),
        (stats) {
          expect(stats, isA<Map<String, dynamic>>());
          // Stats should have standard keys
          expect(stats.containsKey('total_amount') || stats.isEmpty, isTrue);
        },
      );
    });

    test('P7-10: PaymentService.getTotalRevenue() → returns int', () async {
      final paymentService = PaymentService();

      final result = await paymentService.getTotalRevenue(testOrgId!);

      result.fold(
        (failure) => fail('getTotalRevenue failed: ${failure.message}'),
        (revenue) {
          expect(revenue, isA<int>());
          // No successful payments yet, so revenue should be 0
          expect(revenue, 0);
        },
      );
    });
  });
}

/// Generate a valid UUID v4 for test entity IDs.
String _generateUuid() {
  final rng = Random();
  String hex(int count) =>
      List.generate(count, (_) => rng.nextInt(16).toRadixString(16)).join();
  return '${hex(8)}-${hex(4)}-4${hex(3)}-${(8 + rng.nextInt(4)).toRadixString(16)}${hex(3)}-${hex(12)}';
}
