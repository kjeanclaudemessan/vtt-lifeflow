import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:moneroo_flutter_sdk/moneroo_flutter_sdk.dart';
import 'package:moneroo_flutter_sdk/src/models/methods.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app.locator.dart';
import '../../../core/config/app_config.dart';
import '../../../core/errors/failures.dart';
import '../../../services/moneroo/moneroo_service.dart';
import '../../../services/supabase/supabase_service.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'domain/entities/payment_entity.dart';
import 'domain/repositories/i_payment_repository.dart';

/// Service for managing payments and transactions.
///
/// Integrates with Moneroo for mobile money payments in Africa.
///
/// Example:
/// ```dart
/// final service = locator<PaymentService>();
///
/// // Initialize Moneroo
/// await service.initializeMoneroo();
///
/// // Initiate payment
/// final result = await service.initiatePayment(
///   organizationId: 'org_123',
///   amount: 10000,
///   currency: 'XOF',
///   description: 'Pro Plan Subscription',
/// );
///
/// // Open checkout
/// result.fold(
///   (failure) => showError(failure.message),
///   (payment) => service.openCheckout(context, payment),
/// );
/// ```
class PaymentService with ListenableServiceMixin {
  // ═══════════════════════════════════════════════════════════════════════════
  // DEPENDENCIES
  // ═══════════════════════════════════════════════════════════════════════════

  final _supabase = locator<SupabaseService>();
  final _moneroo = locator<MonerooService>();
  late final IPaymentRepository _repository;

  // ═══════════════════════════════════════════════════════════════════════════
  // REACTIVE VALUES
  // ═══════════════════════════════════════════════════════════════════════════

  final _payments = ReactiveValue<List<PaymentEntity>>([]);
  final _currentPayment = ReactiveValue<PaymentEntity?>(null);
  final _isLoading = ReactiveValue<bool>(false);
  final _isProcessing = ReactiveValue<bool>(false);
  final _isMonerooReady = ReactiveValue<bool>(false);

  /// List of payments.
  List<PaymentEntity> get payments => _payments.value;

  /// Current payment being processed.
  PaymentEntity? get currentPayment => _currentPayment.value;

  /// Whether service is loading.
  bool get isLoading => _isLoading.value;

  /// Whether a payment is being processed.
  bool get isProcessing => _isProcessing.value;

  /// Whether Moneroo is initialized and ready.
  bool get isMonerooReady => _isMonerooReady.value;

  /// Recent successful payments.
  List<PaymentEntity> get successfulPayments =>
      _payments.value.where((p) => p.status == PaymentStatus.success).toList();

  /// Pending payments.
  List<PaymentEntity> get pendingPayments =>
      _payments.value.where((p) => p.status == PaymentStatus.pending).toList();

  /// Total amount paid (in default currency).
  int get totalPaid => successfulPayments.fold(0, (sum, p) => sum + p.amount);

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTRUCTOR
  // ═══════════════════════════════════════════════════════════════════════════

  PaymentService() {
    _repository = PaymentRepositoryImpl(_supabase);
    listenToReactiveValues([
      _payments,
      _currentPayment,
      _isLoading,
      _isProcessing,
      _isMonerooReady,
    ]);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Initializes Moneroo payment provider.
  ///
  /// Call this before processing any payments.
  Future<Either<Failure, void>> initializeMoneroo({
    String? apiKey,
    bool? sandbox,
  }) async {
    final result = await _moneroo.initialize(
      apiKey: apiKey,
      sandbox: sandbox,
    );

    result.fold(
      (failure) => _isMonerooReady.value = false,
      (_) => _isMonerooReady.value = true,
    );

    notifyListeners();
    return result;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD PAYMENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Loads payments for an organization.
  Future<Either<Failure, List<PaymentEntity>>> loadPayments({
    required String organizationId,
    int? limit,
    PaymentStatus? status,
  }) async {
    _isLoading.value = true;
    notifyListeners();

    try {
      final result = await _repository.getOrganizationPayments(
        organizationId,
        limit: limit,
        status: status,
      );

      result.fold(
        (failure) => null,
        (paymentList) {
          _payments.value = paymentList;
          notifyListeners();
        },
      );

      return result;
    } finally {
      _isLoading.value = false;
      notifyListeners();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYMENT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Initiates a new payment.
  ///
  /// Returns the payment with `checkoutUrl` to redirect user for payment.
  Future<Either<Failure, PaymentEntity>> initiatePayment({
    required String organizationId,
    required int amount,
    required String description,
    String? subscriptionId,
    String currency = 'XOF',
    Map<String, dynamic>? metadata,
  }) async {
    _isProcessing.value = true;
    notifyListeners();

    try {
      final result = await _repository.initiatePayment(
        organizationId: organizationId,
        amount: amount,
        description: description,
        subscriptionId: subscriptionId,
        currency: currency,
        metadata: metadata,
      );

      result.fold(
        (failure) => null,
        (payment) {
          _currentPayment.value = payment;
          _payments.value = [payment, ..._payments.value];
          notifyListeners();
        },
      );

      return result;
    } finally {
      _isProcessing.value = false;
      notifyListeners();
    }
  }

  /// Opens the Moneroo checkout page.
  ///
  /// Option 1: Open in WebView (recommended for mobile)
  /// Option 2: Open in external browser
  Future<void> openCheckout(
    BuildContext context,
    PaymentEntity payment, {
    bool useWebView = true,
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
    VoidCallback? onCancel,
  }) async {
    if (payment.checkoutUrl == null || payment.checkoutUrl!.isEmpty) {
      onFailure?.call();
      return;
    }

    if (useWebView && _moneroo.isInitialized) {
      // Use Moneroo's built-in WebView widget
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Moneroo(
            amount: payment.amount,
            apiKey: AppConfig.monerooApiKey,
            sandbox: AppConfig.isDebug,
            currency:
                _moneroo.getCurrency(payment.currency) ?? MonerooCurrency.XOF,
            customer: MonerooCustomer(
              email: _supabase.currentUser?.email ?? '',
              firstName: _supabase.currentUser?.userMetadata?['first_name'],
              lastName: _supabase.currentUser?.userMetadata?['last_name'],
            ),
            description: payment.description ?? '',
            onPaymentCompleted: (infos, ctx) {
              Navigator.of(ctx).pop();
              if (infos.status == MonerooStatus.success) {
                _handlePaymentSuccess(payment.id);
                onSuccess?.call();
              } else if (infos.status == MonerooStatus.cancelled) {
                onCancel?.call();
              } else {
                onFailure?.call();
              }
            },
            onError: (error, ctx) {
              Navigator.of(ctx).pop();
              onFailure?.call();
            },
          ),
        ),
      );
    } else {
      // Open in external browser
      final uri = Uri.parse(payment.checkoutUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _handlePaymentSuccess(String paymentId) async {
    final result = await _repository.refreshPaymentStatus(paymentId);
    result.fold(
      (failure) => null,
      (payment) {
        _currentPayment.value = payment;
        _updatePaymentInList(payment);
        notifyListeners();
      },
    );
  }

  /// Gets checkout URL for a pending payment.
  Future<Either<Failure, String>> getCheckoutUrl(String paymentId) async {
    return _repository.getCheckoutUrl(paymentId);
  }

  /// Refreshes a payment status from the provider.
  Future<Either<Failure, PaymentEntity>> refreshPaymentStatus(
    String paymentId,
  ) async {
    final result = await _repository.refreshPaymentStatus(paymentId);

    result.fold(
      (failure) => null,
      (payment) {
        if (_currentPayment.value?.id == paymentId) {
          _currentPayment.value = payment;
        }
        _updatePaymentInList(payment);
        notifyListeners();
      },
    );

    return result;
  }

  /// Cancels a pending payment.
  Future<Either<Failure, void>> cancelPayment(String paymentId) async {
    final result = await _repository.cancelPayment(paymentId);

    result.fold(
      (failure) => null,
      (_) {
        _payments.value =
            _payments.value.where((p) => p.id != paymentId).toList();
        if (_currentPayment.value?.id == paymentId) {
          _currentPayment.value = null;
        }
        notifyListeners();
      },
    );

    return result;
  }

  /// Retries a failed payment.
  Future<Either<Failure, PaymentEntity>> retryPayment(String paymentId) async {
    final result = await _repository.retryPayment(paymentId);

    result.fold(
      (failure) => null,
      (payment) {
        _currentPayment.value = payment;
        _updatePaymentInList(payment);
        notifyListeners();
      },
    );

    return result;
  }

  void _updatePaymentInList(PaymentEntity payment) {
    final index = _payments.value.indexWhere((p) => p.id == payment.id);
    if (index >= 0) {
      final updated = List<PaymentEntity>.from(_payments.value);
      updated[index] = payment;
      _payments.value = updated;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYMENT METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gets available payment methods from Moneroo.
  Future<Either<Failure, List<MonerooRemoteMethod>>> getPaymentMethods() async {
    return _moneroo.getPaymentMethods();
  }

  /// Gets supported payment methods for a currency (static list).
  List<String> getSupportedPaymentMethodsForCurrency(String currency) {
    switch (currency.toUpperCase()) {
      case 'XOF':
      case 'XAF':
        return [
          'orange_money',
          'mtn_money',
          'moov_money',
          'wave',
          'free_money',
        ];
      case 'GHS':
        return ['mtn_money', 'vodafone_cash', 'airtel_money'];
      case 'KES':
        return ['mpesa'];
      case 'NGN':
        return ['card', 'bank_transfer'];
      default:
        return ['card'];
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gets payment statistics for an organization.
  Future<Either<Failure, Map<String, dynamic>>> getPaymentStats(
    String organizationId, {
    DateTime? from,
    DateTime? to,
  }) async {
    return _repository.getPaymentStats(organizationId, from: from, to: to);
  }

  /// Gets total revenue for an organization.
  Future<Either<Failure, int>> getTotalRevenue(
    String organizationId, {
    DateTime? from,
    DateTime? to,
  }) async {
    return _repository.getTotalRevenue(organizationId, from: from, to: to);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INVOICE / CHECKOUT HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gets checkout URL for a payment.
  String? getPaymentCheckoutUrl(String paymentId) {
    final payment = _payments.value.where((p) => p.id == paymentId).firstOrNull;
    return payment?.checkoutUrl;
  }

  /// Formats amount with currency symbol.
  String formatAmount(int amount, String currency) {
    final symbol = _getCurrencySymbol(currency);
    final formatted = (amount / 100).toStringAsFixed(0);
    return '$symbol $formatted';
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'XOF':
      case 'XAF':
        return 'FCFA';
      case 'NGN':
        return '₦';
      case 'GHS':
        return 'GH₵';
      case 'KES':
        return 'KSh';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      default:
        return currency;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEANUP
  // ═══════════════════════════════════════════════════════════════════════════

  /// Clears all payment state.
  void clear() {
    _payments.value = [];
    _currentPayment.value = null;
    notifyListeners();
  }
}
