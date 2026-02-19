import 'package:dartz/dartz.dart';
import 'package:moneroo_flutter_sdk/moneroo_flutter_sdk.dart';
import 'package:moneroo_flutter_sdk/src/models/methods.dart';
import 'package:stacked/stacked.dart';

import '../../core/config/app_config.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';

/// Service for Moneroo payment integration.
///
/// Provides payment processing functionality using the Moneroo SDK.
///
/// Example:
/// ```dart
/// final service = locator<MonerooService>();
///
/// // Initialize
/// await service.initialize(apiKey: 'your_api_key');
///
/// // Create payment
/// final result = await service.initializePayment(
///   amount: 10000,
///   currency: MonerooCurrency.XOF,
///   customer: MonerooCustomer(email: 'user@example.com'),
///   description: 'Premium subscription',
/// );
/// ```
class MonerooService with ListenableServiceMixin {
  static const String _tag = 'MonerooService';

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  MonerooApi? _api;
  bool _isInitialized = false;
  bool _isSandbox = false;
  String? _apiKey;

  /// Whether the service is initialized.
  bool get isInitialized => _isInitialized;

  /// Whether sandbox mode is enabled.
  bool get isSandbox => _isSandbox;

  /// The Moneroo API instance.
  MonerooApi? get api => _api;

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Initializes the Moneroo service.
  ///
  /// [apiKey] - Your Moneroo API key (from dashboard).
  /// [sandbox] - Whether to use sandbox mode for testing.
  Future<Either<Failure, void>> initialize({
    String? apiKey,
    bool? sandbox,
  }) async {
    try {
      Log.d('Initializing MonerooService', tag: _tag);

      // Get API key from parameter or config
      _apiKey = apiKey ?? AppConfig.monerooApiKey;
      _isSandbox = sandbox ?? AppConfig.isDebug;

      if (_apiKey == null || _apiKey!.isEmpty) {
        Log.w('Moneroo API key not configured', tag: _tag);
        return const Left(
          ConfigurationFailure(message: 'Moneroo API key not configured'),
        );
      }

      _api = MonerooApi(
        apiKey: _apiKey!,
        sandbox: _isSandbox,
      );

      _isInitialized = true;
      Log.i('MonerooService initialized (sandbox: $_isSandbox)', tag: _tag);
      notifyListeners();

      return const Right(null);
    } catch (e, s) {
      Log.e('Error initializing MonerooService',
          tag: _tag, error: e, stackTrace: s);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYMENT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Initializes a new payment.
  ///
  /// Returns payment with id and checkoutUrl.
  Future<Either<Failure, MonerooPayment>> initializePayment({
    required int amount,
    required MonerooCurrency currency,
    required MonerooCustomer customer,
    required String description,
    String? callbackUrl,
    Map<String, dynamic>? metadata,
  }) async {
    if (!_isInitialized || _api == null) {
      return const Left(
        ConfigurationFailure(message: 'MonerooService not initialized'),
      );
    }

    try {
      Log.d('Initializing payment: $amount $currency', tag: _tag);

      final payment = await _api!.initPayment(
        amount: amount,
        customer: customer,
        currency: currency,
        description: description,
        callbackUrl: callbackUrl,
        metadata: metadata,
      );

      Log.i('Payment initialized: ${payment.id}', tag: _tag);
      return Right(payment);
    } catch (e, s) {
      Log.e('Error initializing payment', tag: _tag, error: e, stackTrace: s);
      return Left(_handleException(e));
    }
  }

  /// Gets payment status and details.
  Future<Either<Failure, MonerooPaymentInfos>> getPaymentStatus(
    String paymentId,
  ) async {
    if (!_isInitialized || _api == null) {
      return const Left(
        ConfigurationFailure(message: 'MonerooService not initialized'),
      );
    }

    try {
      Log.d('Getting payment status: $paymentId', tag: _tag);

      final payment = await _api!.getMonerooPaymentInfos(paymentId: paymentId);

      Log.d('Payment status: ${payment.status}', tag: _tag);
      return Right(payment);
    } catch (e, s) {
      Log.e('Error getting payment status', tag: _tag, error: e, stackTrace: s);
      return Left(_handleException(e));
    }
  }

  /// Gets available payment methods.
  ///
  /// Returns a list of MonerooRemoteMethod objects from the SDK.
  Future<Either<Failure, List<MonerooRemoteMethod>>> getPaymentMethods() async {
    if (!_isInitialized || _api == null) {
      return const Left(
        ConfigurationFailure(message: 'MonerooService not initialized'),
      );
    }

    try {
      Log.d('Getting payment methods', tag: _tag);

      final methods = await _api!.getMonerooPaymentMethods();

      Log.d('Found ${methods.length} payment methods', tag: _tag);
      return Right(methods);
    } catch (e, s) {
      Log.e('Error getting payment methods',
          tag: _tag, error: e, stackTrace: s);
      return Left(_handleException(e));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Creates a MonerooCustomer from user data.
  MonerooCustomer createCustomer({
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    String? country,
  }) {
    return MonerooCustomer(
      email: email,
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      phone: phone,
      country: country,
    );
  }

  /// Converts a currency code string to MonerooCurrency.
  MonerooCurrency? getCurrency(String code) {
    switch (code.toUpperCase()) {
      case 'XOF':
        return MonerooCurrency.XOF;
      case 'XAF':
        return MonerooCurrency.XAF;
      case 'NGN':
        return MonerooCurrency.NGN;
      case 'GHS':
        return MonerooCurrency.GHS;
      case 'KES':
        return MonerooCurrency.KES;
      case 'USD':
        return MonerooCurrency.USD;
      case 'EUR':
        return MonerooCurrency.EUR;
      default:
        return null;
    }
  }

  /// Maps MonerooStatus to PaymentStatus string.
  String mapStatus(MonerooStatus status) {
    switch (status) {
      case MonerooStatus.success:
        return 'success';
      case MonerooStatus.pending:
        return 'pending';
      case MonerooStatus.failed:
        return 'failed';
      case MonerooStatus.cancelled:
        return 'cancelled';
      case MonerooStatus.initiated:
        return 'pending'; // Map initiated to pending for our status
    }
  }

  /// Handles exceptions from Moneroo SDK.
  Failure _handleException(Object e) {
    // The SDK may throw various exceptions
    // We handle them generically since specific types may not be exported
    final message = e.toString();

    if (message.contains('401') || message.contains('Unauthorized')) {
      return const UnauthorizedFailure(message: 'Invalid API key');
    }
    if (message.contains('404') || message.contains('Not Found')) {
      return const NotFoundFailure(message: 'Payment not found');
    }
    if (message.contains('network') || message.contains('connection')) {
      return const NetworkFailure(message: 'Payment service unavailable');
    }

    return ServerFailure(message: message);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEANUP
  // ═══════════════════════════════════════════════════════════════════════════

  /// Disposes the service.
  void dispose() {
    _api = null;
    _isInitialized = false;
    Log.d('MonerooService disposed', tag: _tag);
  }
}
