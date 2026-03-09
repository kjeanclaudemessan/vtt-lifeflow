import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../app/app.locator.dart';
import '../../core/enums/auth_enums.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../services/supabase/supabase_auth_service.dart';
import '../../services/supabase/supabase_service.dart';

/// Implementation of [IAuthRepository] using Supabase.
///
/// This repository bridges the domain layer with the Supabase auth service,
/// converting between Supabase User objects and domain UserEntity.
/// It uses the RPC functions defined in the migration for profile operations.
class AuthRepositoryImpl implements IAuthRepository {
  final SupabaseAuthService _authService;
  final SupabaseService _supabaseService;

  AuthRepositoryImpl({
    SupabaseAuthService? authService,
    SupabaseService? supabaseService,
  }) : _authService = authService ?? locator<SupabaseAuthService>(),
       _supabaseService = supabaseService ?? locator<SupabaseService>();

  // ─────────────────────────────────────────────────────────────────
  // Private Helpers
  // ─────────────────────────────────────────────────────────────────

  /// Converts a Supabase User to UserEntity (basic, without profile data).
  UserEntity _toBasicEntity(supabase.User user) {
    final userJson = <String, dynamic>{
      'id': user.id,
      'email': user.email,
      'phone': user.phone,
      'created_at': user.createdAt,
      'updated_at': user.updatedAt,
      'last_sign_in_at': user.lastSignInAt,
      'email_confirmed_at': user.emailConfirmedAt,
      'phone_confirmed_at': user.phoneConfirmedAt,
      'user_metadata': user.userMetadata,
    };
    return UserModel.fromSupabaseUser(userJson).toEntity();
  }

  /// Fetches full profile using get_my_profile RPC.
  Future<UserEntity?> _fetchFullProfile() async {
    try {
      final response = await _supabaseService.client
          .rpc('get_my_profile')
          .select()
          .single();

      return UserModel.fromProfileRpc(response).toEntity();
    } catch (e) {
      // If RPC fails, return null (profile might not exist yet)
      return null;
    }
  }

  /// Converts core OtpType to Supabase OtpType.
  supabase.OtpType _toSupabaseOtpType(OtpType type) {
    return switch (type) {
      OtpType.sms => supabase.OtpType.sms,
      OtpType.email => supabase.OtpType.email,
      OtpType.magicLink => supabase.OtpType.magiclink,
      OtpType.phoneCall => supabase.OtpType.sms,
      OtpType.whatsapp => supabase.OtpType.sms,
    };
  }

  /// Converts core OAuthProvider to Supabase OAuthProvider.
  supabase.OAuthProvider _toSupabaseProvider(OAuthProvider provider) {
    return switch (provider) {
      OAuthProvider.google => supabase.OAuthProvider.google,
      OAuthProvider.apple => supabase.OAuthProvider.apple,
      OAuthProvider.facebook => supabase.OAuthProvider.facebook,
      OAuthProvider.github => supabase.OAuthProvider.github,
      OAuthProvider.twitter => supabase.OAuthProvider.twitter,
      OAuthProvider.microsoft => supabase.OAuthProvider.azure,
      OAuthProvider.discord => supabase.OAuthProvider.discord,
      OAuthProvider.slack => supabase.OAuthProvider.slack,
      OAuthProvider.linkedin => supabase.OAuthProvider.linkedin,
    };
  }

  // ─────────────────────────────────────────────────────────────────
  // Current User
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _authService.currentUser;
      if (user == null) {
        return const Right(null);
      }

      // Try to get full profile with RPC
      final fullProfile = await _fetchFullProfile();
      if (fullProfile != null) {
        return Right(fullProfile);
      }

      // Fallback to basic entity
      return Right(_toBasicEntity(user));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Stream<UserEntity?> watchAuthState() {
    return _authService.authStateChanges.asyncMap((user) async {
      if (user == null) return null;

      // Try to get full profile
      final fullProfile = await _fetchFullProfile();
      return fullProfile ?? _toBasicEntity(user);
    });
  }

  @override
  bool get isAuthenticated => _authService.isAuthenticated;

  // ─────────────────────────────────────────────────────────────────
  // Email Authentication
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    if (result.isLeft())
      return result.fold((f) => Left(f), (_) => throw 'unreachable');

    final user = result.getOrElse(() => throw 'unreachable');
    final fullProfile = await _fetchFullProfile();
    return Right(fullProfile ?? _toBasicEntity(user));
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    final result = await _authService.signUpWithEmail(
      email: email,
      password: password,
      metadata: metadata,
    );

    return result.fold(
      (failure) => Left(failure),
      (user) => Right(_toBasicEntity(user)),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Phone Authentication
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> signInWithPhone({required String phone}) async {
    final result = await _authService.signInWithPhone(phone: phone);
    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, Unit>> signUpWithPhone({
    required String phone,
    Map<String, dynamic>? metadata,
  }) async {
    final result = await _authService.signUpWithPhone(
      phone: phone,
      metadata: metadata,
    );
    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, UserEntity>> verifyPhoneOtp({
    required String phone,
    required String token,
    OtpType type = OtpType.sms,
  }) async {
    final result = await _authService.verifyPhoneOtp(
      phone: phone,
      token: token,
      type: _toSupabaseOtpType(type),
    );

    if (result.isLeft())
      return result.fold((f) => Left(f), (_) => throw 'unreachable');

    final user = result.getOrElse(() => throw 'unreachable');
    final fullProfile = await _fetchFullProfile();
    return Right(fullProfile ?? _toBasicEntity(user));
  }

  @override
  Future<Either<Failure, Unit>> resendPhoneOtp({required String phone}) async {
    final result = await _authService.resendPhoneOtp(phone: phone);
    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  // ─────────────────────────────────────────────────────────────────
  // OAuth Authentication
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, bool>> signInWithOAuth({
    required OAuthProvider provider,
    String? redirectTo,
  }) async {
    return _authService.signInWithOAuth(
      _toSupabaseProvider(provider),
      redirectTo: redirectTo,
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Magic Link Authentication
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> sendMagicLink({
    required String email,
    String? redirectTo,
  }) async {
    try {
      await _supabaseService.client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: redirectTo,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Password Management
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    String? redirectTo,
  }) async {
    final result = await _authService.resetPassword(email);
    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, UserEntity>> updatePassword({
    required String newPassword,
  }) async {
    final result = await _authService.updatePassword(newPassword);

    if (result.isLeft())
      return result.fold((f) => Left(f), (_) => throw 'unreachable');

    final user = result.getOrElse(() => throw 'unreachable');
    final fullProfile = await _fetchFullProfile();
    return Right(fullProfile ?? _toBasicEntity(user));
  }

  // ─────────────────────────────────────────────────────────────────
  // Profile Management
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
    String? displayName,
    String? avatarUrl,
    String? locale,
    String? timezone,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabaseService.client.rpc(
        'update_my_profile',
        params: {
          'p_first_name': firstName,
          'p_last_name': lastName,
          'p_display_name': displayName,
          'p_avatar_url': avatarUrl,
          'p_locale': locale,
          'p_timezone': timezone,
          'p_metadata': metadata,
        },
      );

      // Fetch updated full profile
      final fullProfile = await _fetchFullProfile();
      if (fullProfile != null) {
        return Right(fullProfile);
      }

      // Fallback if fetch fails
      return const Left(
        ServerFailure(message: 'Failed to fetch updated profile'),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateMetadata(
    Map<String, dynamic> metadata,
  ) async {
    try {
      final response = await _supabaseService.client.rpc(
        'update_my_metadata',
        params: {'p_metadata': metadata},
      );

      return Right(response as Map<String, dynamic>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final response = await _supabaseService.client.rpc(
        'update_my_preferences',
        params: {'p_preferences': preferences},
      );

      return Right(response as Map<String, dynamic>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Session Management
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> signOut() async {
    final result = await _authService.signOut();
    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, UserEntity>> refreshSession() async {
    final result = await _authService.refreshSession();

    if (result.isLeft())
      return result.fold((f) => Left(f), (_) => throw 'unreachable');

    final user = _authService.currentUser;
    if (user == null) {
      return const Left(AuthFailure(message: 'No user after session refresh'));
    }
    final fullProfile = await _fetchFullProfile();
    return Right(fullProfile ?? _toBasicEntity(user));
  }

  // ─────────────────────────────────────────────────────────────────
  // Account Management
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, bool>> deleteAccount() async {
    try {
      final response = await _supabaseService.client.rpc('delete_my_account');
      return Right(response as bool? ?? false);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
