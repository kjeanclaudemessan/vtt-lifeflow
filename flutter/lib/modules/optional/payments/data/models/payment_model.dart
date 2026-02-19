import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/payment_entity.dart';

part 'payment_model.g.dart';

/// JSON serializable model for [PaymentEntity].
@JsonSerializable()
class PaymentModel extends Equatable {
  final String id;
  @JsonKey(name: 'organization_id')
  final String? organizationId;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'subscription_id')
  final String? subscriptionId;
  final int amount;
  final String currency;
  final String? description;
  final String status;
  final String provider;
  @JsonKey(name: 'provider_tx_id')
  final String? providerTxId;
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @JsonKey(name: 'checkout_url')
  final String? checkoutUrl;
  final Map<String, dynamic> metadata;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @JsonKey(name: 'error_code')
  final String? errorCode;
  @JsonKey(name: 'error_message')
  final String? errorMessage;

  const PaymentModel({
    required this.id,
    this.organizationId,
    this.userId,
    this.subscriptionId,
    required this.amount,
    this.currency = 'XOF',
    this.description,
    this.status = 'pending',
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

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);

  /// Converts this model to a domain entity.
  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      organizationId: organizationId,
      userId: userId,
      subscriptionId: subscriptionId,
      amount: amount,
      currency: currency,
      description: description,
      status: _parseStatus(status),
      provider: provider,
      providerTxId: providerTxId,
      paymentMethod: paymentMethod,
      checkoutUrl: checkoutUrl,
      metadata: metadata,
      createdAt: createdAt,
      completedAt: completedAt,
      errorCode: errorCode,
      errorMessage: errorMessage,
    );
  }

  /// Creates a model from a domain entity.
  factory PaymentModel.fromEntity(PaymentEntity entity) {
    return PaymentModel(
      id: entity.id,
      organizationId: entity.organizationId,
      userId: entity.userId,
      subscriptionId: entity.subscriptionId,
      amount: entity.amount,
      currency: entity.currency,
      description: entity.description,
      status: entity.status.name,
      provider: entity.provider,
      providerTxId: entity.providerTxId,
      paymentMethod: entity.paymentMethod,
      checkoutUrl: entity.checkoutUrl,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
      errorCode: entity.errorCode,
      errorMessage: entity.errorMessage,
    );
  }

  static PaymentStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return PaymentStatus.pending;
      case 'processing':
        return PaymentStatus.processing;
      case 'success':
        return PaymentStatus.success;
      case 'failed':
        return PaymentStatus.failed;
      case 'cancelled':
        return PaymentStatus.cancelled;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'expired':
        return PaymentStatus.expired;
      default:
        return PaymentStatus.pending;
    }
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
