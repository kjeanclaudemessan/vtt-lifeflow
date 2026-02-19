import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

/// Data model representing a user from the API/database.
///
/// This model handles JSON serialization and converts to/from [UserEntity].
/// It maps to the `get_my_profile()` RPC response or `active_profiles` view.
@JsonSerializable()
class UserModel extends Equatable {
  // ─────────────────────────────────────────────────────────────────
  // Identity (from auth.users)
  // ─────────────────────────────────────────────────────────────────

  /// Unique identifier of the user.
  final String id;

  /// User's email address.
  final String? email;

  /// User's phone number.
  final String? phone;

  // ─────────────────────────────────────────────────────────────────
  // Profile (from profiles table)
  // ─────────────────────────────────────────────────────────────────

  /// User's first name.
  @JsonKey(name: 'first_name')
  final String? firstName;

  /// User's last name.
  @JsonKey(name: 'last_name')
  final String? lastName;

  /// User's display name.
  @JsonKey(name: 'display_name')
  final String? displayName;

  /// Computed full name (from view/RPC).
  @JsonKey(name: 'full_name')
  final String? fullName;

  /// URL to user's avatar image.
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  // ─────────────────────────────────────────────────────────────────
  // Settings
  // ─────────────────────────────────────────────────────────────────

  /// User's preferred locale.
  final String locale;

  /// User's timezone.
  final String timezone;

  // ─────────────────────────────────────────────────────────────────
  // Role & Organization
  // ─────────────────────────────────────────────────────────────────

  /// User's role in the system.
  final String role;

  /// Organization ID for multi-tenant apps.
  @JsonKey(name: 'organization_id')
  final String? organizationId;

  // ─────────────────────────────────────────────────────────────────
  // Flexible Data
  // ─────────────────────────────────────────────────────────────────

  /// Business-specific metadata.
  final Map<String, dynamic> metadata;

  /// UI/UX preferences.
  final Map<String, dynamic> preferences;

  // ─────────────────────────────────────────────────────────────────
  // Verification Status
  // ─────────────────────────────────────────────────────────────────

  /// Whether the user's email is verified.
  @JsonKey(name: 'is_email_verified')
  final bool isEmailVerified;

  /// Whether the user's phone is verified.
  @JsonKey(name: 'is_phone_verified')
  final bool isPhoneVerified;

  // ─────────────────────────────────────────────────────────────────
  // Timestamps
  // ─────────────────────────────────────────────────────────────────

  /// When the user account was created.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When the user profile was last updated.
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// When the user last signed in.
  @JsonKey(name: 'last_sign_in_at')
  final DateTime? lastSignInAt;

  const UserModel({
    required this.id,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.displayName,
    this.fullName,
    this.avatarUrl,
    this.locale = 'fr',
    this.timezone = 'Europe/Paris',
    this.role = 'user',
    this.organizationId,
    this.metadata = const {},
    this.preferences = const {},
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    required this.createdAt,
    this.updatedAt,
    this.lastSignInAt,
  });

  /// Creates a [UserModel] from JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this model to JSON map.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Converts this model to domain [UserEntity].
  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        displayName: displayName,
        avatarUrl: avatarUrl,
        locale: locale,
        timezone: timezone,
        role: UserRole.fromString(role),
        organizationId: organizationId,
        metadata: metadata,
        preferences: preferences,
        isEmailVerified: isEmailVerified,
        isPhoneVerified: isPhoneVerified,
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastSignInAt: lastSignInAt,
      );

  /// Creates a [UserModel] from domain [UserEntity].
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        email: entity.email,
        phone: entity.phone,
        firstName: entity.firstName,
        lastName: entity.lastName,
        displayName: entity.displayName,
        avatarUrl: entity.avatarUrl,
        locale: entity.locale,
        timezone: entity.timezone,
        role: entity.role.toValue(),
        organizationId: entity.organizationId,
        metadata: entity.metadata,
        preferences: entity.preferences,
        isEmailVerified: entity.isEmailVerified,
        isPhoneVerified: entity.isPhoneVerified,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        lastSignInAt: entity.lastSignInAt,
      );

  /// Creates a [UserModel] from Supabase auth.users object.
  ///
  /// Use this when you only have the auth user (e.g., after sign in).
  /// For full profile data, use [fromJson] with `get_my_profile()` RPC response.
  factory UserModel.fromSupabaseUser(Map<String, dynamic> userData) {
    final userMetadata =
        userData['user_metadata'] as Map<String, dynamic>? ?? {};

    return UserModel(
      id: userData['id'] as String,
      email: userData['email'] as String?,
      phone: userData['phone'] as String?,
      firstName: userMetadata['first_name'] as String?,
      lastName: userMetadata['last_name'] as String?,
      displayName: userMetadata['display_name'] as String?,
      avatarUrl: userMetadata['avatar_url'] as String?,
      locale: (userMetadata['locale'] as String?) ?? 'fr',
      timezone: (userMetadata['timezone'] as String?) ?? 'Europe/Paris',
      role: 'user', // Role is in profiles, not in auth.users
      metadata: const {},
      preferences: const {},
      isEmailVerified: userData['email_confirmed_at'] != null,
      isPhoneVerified: userData['phone_confirmed_at'] != null,
      createdAt: DateTime.parse(userData['created_at'] as String),
      updatedAt: userData['updated_at'] != null
          ? DateTime.parse(userData['updated_at'] as String)
          : null,
      lastSignInAt: userData['last_sign_in_at'] != null
          ? DateTime.parse(userData['last_sign_in_at'] as String)
          : null,
    );
  }

  /// Creates a [UserModel] from `get_my_profile()` RPC response.
  ///
  /// This is the recommended way to create a UserModel as it includes
  /// all profile data including role, metadata, and preferences.
  factory UserModel.fromProfileRpc(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] as String,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      firstName: data['first_name'] as String?,
      lastName: data['last_name'] as String?,
      displayName: data['display_name'] as String?,
      fullName: data['full_name'] as String?,
      avatarUrl: data['avatar_url'] as String?,
      locale: (data['locale'] as String?) ?? 'fr',
      timezone: (data['timezone'] as String?) ?? 'Europe/Paris',
      role: (data['role'] as String?) ?? 'user',
      organizationId: data['organization_id'] as String?,
      metadata: (data['metadata'] as Map<String, dynamic>?) ?? {},
      preferences: (data['preferences'] as Map<String, dynamic>?) ?? {},
      isEmailVerified: (data['is_email_verified'] as bool?) ?? false,
      isPhoneVerified: (data['is_phone_verified'] as bool?) ?? false,
      createdAt: data['created_at'] is String
          ? DateTime.parse(data['created_at'] as String)
          : data['created_at'] as DateTime,
      updatedAt: data['updated_at'] != null
          ? (data['updated_at'] is String
              ? DateTime.parse(data['updated_at'] as String)
              : data['updated_at'] as DateTime)
          : null,
      lastSignInAt: data['last_sign_in_at'] != null
          ? (data['last_sign_in_at'] is String
              ? DateTime.parse(data['last_sign_in_at'] as String)
              : data['last_sign_in_at'] as DateTime)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        firstName,
        lastName,
        displayName,
        fullName,
        avatarUrl,
        locale,
        timezone,
        role,
        organizationId,
        metadata,
        preferences,
        isEmailVerified,
        isPhoneVerified,
        createdAt,
        updatedAt,
        lastSignInAt,
      ];
}
