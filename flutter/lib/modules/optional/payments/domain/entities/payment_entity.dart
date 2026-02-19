import 'package:equatable/equatable.dart';

/// Payment status.
enum PaymentStatus {
  pending,
  processing,
  success,
  failed,
  cancelled,
  refunded,
  expired,
}

/// Represents a payment transaction.
class PaymentEntity extends Equatable {
  final String id;
  final String? organizationId;
  final String? userId;
  final String? subscriptionId;
  final int amount;
  final String currency;
  final String? description;
  final PaymentStatus status;
  final String provider;
  final String? providerTxId;
  final String? paymentMethod;
  final String? checkoutUrl;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? errorCode;
  final String? errorMessage;

  const PaymentEntity({
    required this.id,
    this.organizationId,
    this.userId,
    this.subscriptionId,
    required this.amount,
    this.currency = 'XOF',
    this.description,
    this.status = PaymentStatus.pending,
    this.provider = 'moneroo',
    this.providerTxId,
    this.paymentMethod,
    this.checkoutUrl,
    this.metadata = const {},
    required this.createdAt,
    this.completedAt,
    this.errorCode,
    this.errorMessage,
  });

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  /// Whether the payment is successful.
  bool get isSuccessful => status == PaymentStatus.success;

  /// Whether the payment is pending.
  bool get isPending =>
      status == PaymentStatus.pending || status == PaymentStatus.processing;

  /// Whether the payment failed.
  bool get isFailed =>
      status == PaymentStatus.failed || status == PaymentStatus.cancelled;

  /// Whether the payment can be retried.
  bool get canRetry => isFailed || status == PaymentStatus.expired;

  /// Formatted amount with currency.
  String get formattedAmount => '$amount $currency';

  /// Human-readable status.
  String get statusDisplayName {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.success:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.cancelled:
        return 'Cancelled';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.expired:
        return 'Expired';
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // CopyWith
  // ─────────────────────────────────────────────────────────────────

  PaymentEntity copyWith({
    String? id,
    String? organizationId,
    String? userId,
    String? subscriptionId,
    int? amount,
    String? currency,
    String? description,
    PaymentStatus? status,
    String? provider,
    String? providerTxId,
    String? paymentMethod,
    String? checkoutUrl,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? completedAt,
    String? errorCode,
    String? errorMessage,
  }) {
    return PaymentEntity(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      userId: userId ?? this.userId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      providerTxId: providerTxId ?? this.providerTxId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        organizationId,
        userId,
        subscriptionId,
        amount,
        currency,
        description,
        status,
        provider,
        providerTxId,
        paymentMethod,
        checkoutUrl,
        createdAt,
        completedAt,
        errorCode,
        errorMessage,
      ];
}
