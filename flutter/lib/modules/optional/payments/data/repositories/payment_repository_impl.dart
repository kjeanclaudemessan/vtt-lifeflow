import 'package:dartz/dartz.dart';
import 'package:moneroo_flutter_sdk/moneroo_flutter_sdk.dart';

import '../../../../../app/app.locator.dart';
import '../../../../../core/config/app_config.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../services/moneroo/moneroo_service.dart';
import '../../../../../services/supabase/supabase_service.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/i_payment_repository.dart';
import '../models/payment_model.dart';

/// Supabase + Moneroo implementation of [IPaymentRepository].
///
/// This implementation:
/// 1. Creates payment records in Supabase
/// 2. Initiates real payments via Moneroo API
/// 3. Syncs payment status between Moneroo and Supabase
class PaymentRepositoryImpl implements IPaymentRepository {
  final SupabaseService _supabase;
  final MonerooService _moneroo;

  PaymentRepositoryImpl(this._supabase) : _moneroo = locator<MonerooService>();

  @override
  Future<Either<Failure, List<PaymentEntity>>> getOrganizationPayments(
    String organizationId, {
    int? limit,
    PaymentStatus? status,
  }) async {
    try {
      var query = _supabase.client
          .from('payments')
          .select()
          .eq('organization_id', organizationId);

      if (status != null) {
        query = query.eq('status', status.name);
      }

      final orderedQuery = query.order('created_at', ascending: false);

      final limitedQuery =
          limit != null ? orderedQuery.limit(limit) : orderedQuery;

      final response = await limitedQuery;

      final payments = (response as List)
          .map((json) => PaymentModel.fromJson(json).toEntity())
          .toList();

      return Right(payments);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPayment(String id) async {
    try {
      final response = await _supabase.client
          .from('payments')
          .select()
          .eq('id', id)
          .single();

      return Right(PaymentModel.fromJson(response).toEntity());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentByProviderTxId(
    String providerTxId,
  ) async {
    try {
      final response = await _supabase.client
          .from('payments')
          .select()
          .eq('provider_tx_id', providerTxId)
          .single();

      return Right(PaymentModel.fromJson(response).toEntity());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> initiatePayment({
    required String organizationId,
    required int amount,
    required String description,
    String? subscriptionId,
    String currency = 'XOF',
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final userId = _supabase.currentUser?.id;
      if (userId == null) {
        return const Left(UnauthorizedFailure());
      }

      final userEmail = _supabase.currentUser?.email;
      if (userEmail == null) {
        return const Left(
          ValidationFailure(message: 'User email is required for payment'),
        );
      }

      // 1. Create payment record in Supabase first (status: initiated)
      final paymentResponse = await _supabase.client
          .from('payments')
          .insert({
            'organization_id': organizationId,
            'user_id': userId,
            'subscription_id': subscriptionId,
            'amount': amount,
            'currency': currency,
            'description': description,
            'metadata': metadata ?? {},
            'provider': 'moneroo',
            'status': 'pending',
          })
          .select()
          .single();

      final paymentId = paymentResponse['id'] as String;

      // 2. Initialize payment with Moneroo
      if (_moneroo.isInitialized) {
        final monerooResult = await _moneroo.initializePayment(
          amount: amount,
          currency: _moneroo.getCurrency(currency) ?? MonerooCurrency.XOF,
          customer: _moneroo.createCustomer(
            email: userEmail,
            firstName: _supabase.currentUser?.userMetadata?['first_name'],
            lastName: _supabase.currentUser?.userMetadata?['last_name'],
          ),
          description: description,
          callbackUrl: AppConfig.paymentWebhookUrl.isNotEmpty
              ? AppConfig.paymentWebhookUrl
              : null,
          metadata: {
            'payment_id': paymentId,
            'organization_id': organizationId,
            'subscription_id': subscriptionId,
            ...?metadata,
          },
        );

        return monerooResult.fold(
          (failure) async {
            // Update payment as failed if Moneroo init fails
            await _supabase.client.from('payments').update({
              'status': 'failed',
              'metadata': {
                ...?metadata,
                'error': failure.message,
              },
            }).eq('id', paymentId);

            return Left(failure);
          },
          (monerooPayment) async {
            // 3. Update payment with Moneroo details
            // MonerooPayment has 'checkoutUrl' property for checkout URL
            final updatedResponse = await _supabase.client
                .from('payments')
                .update({
                  'provider_tx_id': monerooPayment.id,
                  'checkout_url': monerooPayment.checkoutUrl,
                  'status': 'pending',
                })
                .eq('id', paymentId)
                .select()
                .single();

            return Right(PaymentModel.fromJson(updatedResponse).toEntity());
          },
        );
      } else {
        // Moneroo not initialized - return payment without checkout URL
        return Right(PaymentModel.fromJson(paymentResponse).toEntity());
      }
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, String>> getCheckoutUrl(String paymentId) async {
    try {
      final response = await _supabase.client
          .from('payments')
          .select('checkout_url')
          .eq('id', paymentId)
          .single();

      final url = response['checkout_url'] as String?;
      if (url == null || url.isEmpty) {
        return const Left(
          NotFoundFailure(message: 'Checkout URL not available'),
        );
      }

      return Right(url);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> refreshPaymentStatus(String id) async {
    try {
      // Get payment from DB
      final response = await _supabase.client
          .from('payments')
          .select()
          .eq('id', id)
          .single();

      final providerTxId = response['provider_tx_id'] as String?;

      // If we have a Moneroo transaction ID, check status with Moneroo
      if (providerTxId != null && _moneroo.isInitialized) {
        final statusResult = await _moneroo.getPaymentStatus(providerTxId);

        return statusResult.fold(
          (failure) => Right(PaymentModel.fromJson(response).toEntity()),
          (monerooPayment) async {
            // Update status in DB if we have a status from Moneroo
            final monerooStatus = monerooPayment.status;
            if (monerooStatus == null) {
              return Right(PaymentModel.fromJson(response).toEntity());
            }

            final newStatus = _moneroo.mapStatus(monerooStatus);
            if (response['status'] != newStatus) {
              final updatedResponse = await _supabase.client
                  .from('payments')
                  .update({
                    'status': newStatus,
                    'completed_at': monerooStatus == MonerooStatus.success
                        ? DateTime.now().toIso8601String()
                        : null,
                  })
                  .eq('id', id)
                  .select()
                  .single();

              return Right(PaymentModel.fromJson(updatedResponse).toEntity());
            }

            return Right(PaymentModel.fromJson(response).toEntity());
          },
        );
      }

      return Right(PaymentModel.fromJson(response).toEntity());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPaymentStats(
    String organizationId, {
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final response = await _supabase.client.rpc(
        'get_org_payment_stats',
        params: {
          'p_org_id': organizationId,
          if (from != null) 'p_start_date': from.toIso8601String(),
          if (to != null) 'p_end_date': to.toIso8601String(),
        },
      );

      // RPC with RETURNS TABLE returns a List — take first row or empty map
      if (response is List && response.isNotEmpty) {
        return Right(response.first as Map<String, dynamic>);
      } else if (response is Map<String, dynamic>) {
        return Right(response);
      }
      return const Right({});
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalRevenue(
    String organizationId, {
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      var query = _supabase.client
          .from('payments')
          .select('amount')
          .eq('organization_id', organizationId)
          .eq('status', 'success');

      if (from != null) {
        query = query.gte('created_at', from.toIso8601String());
      }
      if (to != null) {
        query = query.lte('created_at', to.toIso8601String());
      }

      final response = await query;

      final total = (response as List)
          .fold<int>(0, (sum, r) => sum + (r['amount'] as int));

      return Right(total);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> cancelPayment(String id) async {
    try {
      await _supabase.client
          .from('payments')
          .update({'status': 'cancelled'})
          .eq('id', id)
          .eq('status', 'pending');

      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> retryPayment(String id) async {
    try {
      // Get original payment
      final original = await _supabase.client
          .from('payments')
          .select()
          .eq('id', id)
          .single();

      // Create new payment with same details
      return initiatePayment(
        organizationId: original['organization_id'] as String,
        amount: original['amount'] as int,
        description: original['description'] as String,
        subscriptionId: original['subscription_id'] as String?,
        currency: original['currency'] as String? ?? 'XOF',
        metadata: {
          ...(original['metadata'] as Map<String, dynamic>? ?? {}),
          'retry_of': id,
        },
      );
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  /// Handles webhook notification from Moneroo.
  ///
  /// Call this when receiving a webhook with payment status update.
  Future<Either<Failure, PaymentEntity>> handleWebhook({
    required String providerTxId,
    required String status,
    DateTime? completedAt,
  }) async {
    try {
      final updatedResponse = await _supabase.client
          .from('payments')
          .update({
            'status': status,
            if (completedAt != null)
              'completed_at': completedAt.toIso8601String(),
          })
          .eq('provider_tx_id', providerTxId)
          .select()
          .single();

      return Right(PaymentModel.fromJson(updatedResponse).toEntity());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(dynamic e) {
    if (e.toString().contains('PGRST116')) {
      return const NotFoundFailure(message: 'Payment not found');
    }
    return ServerFailure(message: e.toString());
  }
}
