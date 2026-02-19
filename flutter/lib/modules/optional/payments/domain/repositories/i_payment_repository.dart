import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/payment_entity.dart';

/// Repository contract for payment operations.
abstract interface class IPaymentRepository {
  /// Gets payments for an organization.
  Future<Either<Failure, List<PaymentEntity>>> getOrganizationPayments(
    String organizationId, {
    int? limit,
    PaymentStatus? status,
  });

  /// Gets a payment by ID.
  Future<Either<Failure, PaymentEntity>> getPayment(String id);

  /// Gets a payment by provider transaction ID.
  Future<Either<Failure, PaymentEntity>> getPaymentByProviderTxId(
    String providerTxId,
  );

  /// Initiates a new payment.
  Future<Either<Failure, PaymentEntity>> initiatePayment({
    required String organizationId,
    required int amount,
    required String description,
    String? subscriptionId,
    String currency = 'XOF',
    Map<String, dynamic>? metadata,
  });

  /// Gets the checkout URL for a pending payment.
  Future<Either<Failure, String>> getCheckoutUrl(String paymentId);

  /// Refreshes payment status from the provider.
  Future<Either<Failure, PaymentEntity>> refreshPaymentStatus(String id);

  /// Gets payment statistics for an organization.
  Future<Either<Failure, Map<String, dynamic>>> getPaymentStats(
    String organizationId, {
    DateTime? from,
    DateTime? to,
  });

  /// Gets total revenue for an organization.
  Future<Either<Failure, int>> getTotalRevenue(
    String organizationId, {
    DateTime? from,
    DateTime? to,
  });

  /// Cancels a pending payment.
  Future<Either<Failure, void>> cancelPayment(String id);

  /// Retries a failed payment.
  Future<Either<Failure, PaymentEntity>> retryPayment(String id);
}
