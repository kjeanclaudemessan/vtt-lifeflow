// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  displayName: json['display_name'] as String?,
  fullName: json['full_name'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  locale: json['locale'] as String? ?? 'fr',
  timezone: json['timezone'] as String? ?? 'Europe/Paris',
  role: json['role'] as String? ?? 'user',
  organizationId: json['organization_id'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
  preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
  isEmailVerified: json['is_email_verified'] as bool? ?? false,
  isPhoneVerified: json['is_phone_verified'] as bool? ?? false,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  lastSignInAt: json['last_sign_in_at'] == null
      ? null
      : DateTime.parse(json['last_sign_in_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'phone': instance.phone,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'display_name': instance.displayName,
  'full_name': instance.fullName,
  'avatar_url': instance.avatarUrl,
  'locale': instance.locale,
  'timezone': instance.timezone,
  'role': instance.role,
  'organization_id': instance.organizationId,
  'metadata': instance.metadata,
  'preferences': instance.preferences,
  'is_email_verified': instance.isEmailVerified,
  'is_phone_verified': instance.isPhoneVerified,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'last_sign_in_at': instance.lastSignInAt?.toIso8601String(),
};
