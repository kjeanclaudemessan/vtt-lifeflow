import 'package:equatable/equatable.dart';

/// User role in the system.
enum UserRole {
  user,
  premium,
  moderator,
  admin,
  superAdmin;

  /// Creates a [UserRole] from a string value.
  static UserRole fromString(String? value) {
    return switch (value) {
      'premium' => UserRole.premium,
      'moderator' => UserRole.moderator,
      'admin' => UserRole.admin,
      'super_admin' => UserRole.superAdmin,
      _ => UserRole.user,
    };
  }

  /// Converts this role to a string value for storage.
  String toValue() {
    return switch (this) {
      UserRole.user => 'user',
      UserRole.premium => 'premium',
      UserRole.moderator => 'moderator',
      UserRole.admin => 'admin',
      UserRole.superAdmin => 'super_admin',
    };
  }

  /// Whether this role has admin privileges.
  bool get isAdmin => this == UserRole.admin || this == UserRole.superAdmin;

  /// Whether this role has elevated privileges.
  bool get isElevated => isAdmin || this == UserRole.moderator;
}

/// Represents a user in the domain layer.
///
/// This entity contains all user-related business logic and computed properties.
/// It is framework-agnostic and does not depend on any external packages.
class UserEntity extends Equatable {
  // ─────────────────────────────────────────────────────────────────
  // Identity (from auth.users)
  // ─────────────────────────────────────────────────────────────────

  /// Unique identifier of the user.
  final String id;

  /// User's email address (from auth.users).
  final String? email;

  /// User's phone number (from auth.users).
  final String? phone;

  // ─────────────────────────────────────────────────────────────────
  // Profile (from profiles table)
  // ─────────────────────────────────────────────────────────────────

  /// User's first name.
  final String? firstName;

  /// User's last name.
  final String? lastName;

  /// User's display name.
  final String? displayName;

  /// URL to user's avatar image.
  final String? avatarUrl;

  // ─────────────────────────────────────────────────────────────────
  // Settings
  // ─────────────────────────────────────────────────────────────────

  /// User's preferred locale (e.g., 'fr', 'en').
  final String locale;

  /// User's timezone (e.g., 'Europe/Paris').
  final String timezone;

  // ─────────────────────────────────────────────────────────────────
  // Role & Organization
  // ─────────────────────────────────────────────────────────────────

  /// User's role in the system.
  final UserRole role;

  /// Organization ID for multi-tenant apps (null if not used).
  final String? organizationId;

  // ─────────────────────────────────────────────────────────────────
  // Flexible Data
  // ─────────────────────────────────────────────────────────────────

  /// Business-specific metadata (from JSONB).
  final Map<String, dynamic> metadata;

  /// UI/UX preferences (from JSONB).
  final Map<String, dynamic> preferences;

  // ─────────────────────────────────────────────────────────────────
  // Verification Status (from auth.users)
  // ─────────────────────────────────────────────────────────────────

  /// Whether the user's email is verified.
  final bool isEmailVerified;

  /// Whether the user's phone is verified.
  final bool isPhoneVerified;

  // ─────────────────────────────────────────────────────────────────
  // Timestamps
  // ─────────────────────────────────────────────────────────────────

  /// When the user account was created.
  final DateTime createdAt;

  /// When the user profile was last updated.
  final DateTime? updatedAt;

  /// When the user last signed in.
  final DateTime? lastSignInAt;

  const UserEntity({
    required this.id,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.displayName,
    this.avatarUrl,
    this.locale = 'fr',
    this.timezone = 'Europe/Paris',
    this.role = UserRole.user,
    this.organizationId,
    this.metadata = const {},
    this.preferences = const {},
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    required this.createdAt,
    this.updatedAt,
    this.lastSignInAt,
  });

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties (Business Logic)
  // ─────────────────────────────────────────────────────────────────

  /// Full name combining first and last name.
  String get fullName {
    if (firstName == null && lastName == null) {
      return computedDisplayName;
    }
    return [firstName, lastName].whereType<String>().join(' ').trim();
  }

  /// Display name with fallback to first name or email.
  String get computedDisplayName {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!;
    }
    if (firstName != null && firstName!.isNotEmpty) {
      return firstName!;
    }
    if (email != null && email!.isNotEmpty) {
      return email!.split('@').first;
    }
    return phone ?? '';
  }

  /// User's initials (max 2 characters).
  String get initials {
    if (firstName != null && lastName != null) {
      final first = firstName!.isNotEmpty ? firstName![0] : '';
      final last = lastName!.isNotEmpty ? lastName![0] : '';
      return '$first$last'.toUpperCase();
    }
    if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    }
    final identifier = email ?? phone ?? '';
    return identifier.isNotEmpty ? identifier[0].toUpperCase() : '?';
  }

  /// Whether the user has a profile picture.
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  /// Whether the user has completed their profile.
  bool get isProfileComplete =>
      firstName != null &&
      lastName != null &&
      firstName!.isNotEmpty &&
      lastName!.isNotEmpty;

  /// Whether the user is verified (email or phone).
  bool get isVerified => isEmailVerified || isPhoneVerified;

  /// How long ago the user was created.
  Duration get accountAge => DateTime.now().difference(createdAt);

  /// Whether this is a new user (created within last 7 days).
  bool get isNewUser => accountAge.inDays <= 7;

  /// Whether the user signed in with email.
  bool get hasEmail => email != null && email!.isNotEmpty;

  /// Whether the user signed in with phone.
  bool get hasPhone => phone != null && phone!.isNotEmpty;

  /// Whether onboarding is completed (from metadata).
  bool get isOnboardingCompleted => metadata['onboarding_completed'] == true;

  /// Current onboarding step (from metadata).
  int get onboardingStep => (metadata['onboarding_step'] as int?) ?? 0;

  /// Theme preference (from preferences).
  String get themePreference => (preferences['theme'] as String?) ?? 'system';

  /// Whether notifications are enabled (from preferences).
  bool get notificationsEnabled =>
      (preferences['notifications']?['push'] as bool?) ?? true;

  // ─────────────────────────────────────────────────────────────────
  // CopyWith
  // ─────────────────────────────────────────────────────────────────

  /// Creates a copy of this entity with the given fields replaced.
  UserEntity copyWith({
    String? id,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? displayName,
    String? avatarUrl,
    String? locale,
    String? timezone,
    UserRole? role,
    String? organizationId,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? preferences,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSignInAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      locale: locale ?? this.locale,
      timezone: timezone ?? this.timezone,
      role: role ?? this.role,
      organizationId: organizationId ?? this.organizationId,
      metadata: metadata ?? this.metadata,
      preferences: preferences ?? this.preferences,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Equatable
  // ─────────────────────────────────────────────────────────────────

  @override
  List<Object?> get props => [
    id,
    email,
    phone,
    firstName,
    lastName,
    displayName,
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

  @override
  String toString() =>
      'UserEntity(id: $id, email: $email, name: $computedDisplayName)';

  // ─────────────────────────────────────────────────────────────────
  // Factory Constructors
  // ─────────────────────────────────────────────────────────────────

  /// Creates an empty user entity (useful for initial state).
  factory UserEntity.empty() => UserEntity(id: '', createdAt: DateTime.now());

  /// Creates a mock user entity (useful for testing/preview).
  factory UserEntity.mock({
    String id = 'mock-user-id',
    String email = 'john.doe@example.com',
    String firstName = 'John',
    String lastName = 'Doe',
    UserRole role = UserRole.user,
  }) => UserEntity(
    id: id,
    email: email,
    phone: '+33612345678',
    firstName: firstName,
    lastName: lastName,
    displayName: firstName,
    avatarUrl: 'https://i.pravatar.cc/150?u=$id',
    locale: 'fr',
    timezone: 'Europe/Paris',
    role: role,
    metadata: const {'onboarding_completed': true},
    preferences: const {'theme': 'system'},
    isEmailVerified: true,
    isPhoneVerified: false,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    lastSignInAt: DateTime.now().subtract(const Duration(hours: 2)),
  );
}
