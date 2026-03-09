import '../../core/enums/auth_enums.dart';
import '../../core/typedefs/typedefs.dart';
import '../entities/user_entity.dart';

/// Contract for authentication operations.
///
/// This interface is framework-agnostic and does not depend on any
/// specific auth provider (Supabase, Firebase, etc.).
///
/// Implementations:
/// - [AuthRepositoryImpl] - Supabase-based implementation
abstract class IAuthRepository {
  // ─────────────────────────────────────────────────────────────────
  // Current User
  // ─────────────────────────────────────────────────────────────────

  /// Gets the current authenticated user with full profile data.
  ///
  /// Returns [UserEntity] if authenticated, `null` if not.
  FutureResult<UserEntity?> getCurrentUser();

  /// Stream of authentication state changes.
  ///
  /// Emits [UserEntity] when authenticated, `null` when signed out.
  Stream<UserEntity?> watchAuthState();

  /// Whether the user is currently authenticated.
  bool get isAuthenticated;

  // ─────────────────────────────────────────────────────────────────
  // Email Authentication
  // ─────────────────────────────────────────────────────────────────

  /// Signs in a user with email and password.
  ///
  /// Returns [UserEntity] on success, [Failure] on error.
  FutureResult<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  /// Registers a new user with email and password.
  ///
  /// [metadata] can include additional user data like first_name, last_name.
  /// Returns [UserEntity] on success, [Failure] on error.
  FutureResult<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  });

  // ─────────────────────────────────────────────────────────────────
  // Phone Authentication
  // ─────────────────────────────────────────────────────────────────

  /// Initiates phone sign-in by sending an OTP.
  ///
  /// Returns [Unit] on success (OTP sent), [Failure] on error.
  FutureUnitResult signInWithPhone({required String phone});

  /// Initiates phone sign-up by sending an OTP.
  ///
  /// [metadata] can include additional user data like first_name, last_name.
  /// Returns [Unit] on success (OTP sent), [Failure] on error.
  FutureUnitResult signUpWithPhone({
    required String phone,
    Map<String, dynamic>? metadata,
  });

  /// Verifies the phone OTP and completes authentication.
  ///
  /// [type] defaults to [OtpType.sms].
  /// Returns [UserEntity] on success, [Failure] on error.
  FutureResult<UserEntity> verifyPhoneOtp({
    required String phone,
    required String token,
    OtpType type = OtpType.sms,
  });

  /// Resends the phone OTP.
  ///
  /// Returns [Unit] on success, [Failure] on error.
  FutureUnitResult resendPhoneOtp({required String phone});

  // ─────────────────────────────────────────────────────────────────
  // OAuth Authentication
  // ─────────────────────────────────────────────────────────────────

  /// Signs in with an OAuth provider (Google, Apple, etc.).
  ///
  /// Returns `true` if OAuth flow started successfully.
  FutureResult<bool> signInWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
  });

  // ─────────────────────────────────────────────────────────────────
  // Magic Link Authentication
  // ─────────────────────────────────────────────────────────────────

  /// Sends a magic link to the user's email.
  ///
  /// Returns [Unit] on success, [Failure] on error.
  FutureUnitResult sendMagicLink({required String email, String? redirectTo});

  // ─────────────────────────────────────────────────────────────────
  // Password Management
  // ─────────────────────────────────────────────────────────────────

  /// Sends a password reset email.
  ///
  /// Returns [Unit] on success, [Failure] on error.
  FutureUnitResult resetPassword({required String email, String? redirectTo});

  /// Updates the user's password.
  ///
  /// Requires the user to be authenticated.
  /// Returns [UserEntity] on success, [Failure] on error.
  FutureResult<UserEntity> updatePassword({required String newPassword});

  // ─────────────────────────────────────────────────────────────────
  // Profile Management
  // ─────────────────────────────────────────────────────────────────

  /// Updates the user's profile data.
  ///
  /// Uses the `update_my_profile` RPC function.
  /// Returns updated [UserEntity] on success, [Failure] on error.
  FutureResult<UserEntity> updateProfile({
    String? firstName,
    String? lastName,
    String? displayName,
    String? avatarUrl,
    String? locale,
    String? timezone,
    Map<String, dynamic>? metadata,
  });

  /// Updates the user's metadata (merges with existing).
  ///
  /// Uses the `update_my_metadata` RPC function.
  /// Returns updated metadata on success, [Failure] on error.
  FutureResult<Map<String, dynamic>> updateMetadata(
    Map<String, dynamic> metadata,
  );

  /// Updates the user's preferences (merges with existing).
  ///
  /// Uses the `update_my_preferences` RPC function.
  /// Returns updated preferences on success, [Failure] on error.
  FutureResult<Map<String, dynamic>> updatePreferences(
    Map<String, dynamic> preferences,
  );

  // ─────────────────────────────────────────────────────────────────
  // Session Management
  // ─────────────────────────────────────────────────────────────────

  /// Signs out the current user.
  ///
  /// Returns [Unit] on success, [Failure] on error.
  FutureUnitResult signOut();

  /// Refreshes the current session.
  ///
  /// Returns [UserEntity] on success, [Failure] on error.
  FutureResult<UserEntity> refreshSession();

  // ─────────────────────────────────────────────────────────────────
  // Account Management
  // ─────────────────────────────────────────────────────────────────

  /// Soft deletes the current user's account.
  ///
  /// Uses the `delete_my_account` RPC function.
  /// Returns `true` on success, [Failure] on error.
  FutureResult<bool> deleteAccount();
}
