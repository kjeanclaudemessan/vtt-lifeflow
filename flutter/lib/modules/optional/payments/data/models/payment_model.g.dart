// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
  id: json['id'] as String,
  organizationId: json['organization_id'] as String?,
  userId: json['user_id'] as String?,
  subscriptionId: json['subscription_id'] as String?,
  amount: (json['amount'] as num).toInt(),
  currency: json['currency'] as String? ?? 'XOF',
  description: json['description'] as String?,
  status: json['status'] as String? ?? 'pending',
  provider: json['provider'] as String? ?? 'moneroo',
  providerTxId: json['provider_tx_id'] as String?,
  paymentMethod: json['payment_method'] as String?,
  checkoutUrl: json['checkout_url'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
  createdAt: DateTime.parse(json['created_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  errorCode: json['error_code'] as String?,
  errorMessage: json['error_message'] as String?,
);

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'user_id': instance.userId,
      'subscription_id': instance.subscriptionId,
      'amount': instance.amount,
      'currency': instance.currency,
      'description': instance.description,
      'status': instance.status,
      'provider': instance.provider,
      'provider_tx_id': instance.providerTxId,
      'payment_method': instance.paymentMethod,
      'checkout_url': instance.checkoutUrl,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'error_code': instance.errorCode,
      'error_message': instance.errorMessage,
    };
