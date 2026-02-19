import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// Use failures instead of throwing exceptions for expected error cases.
/// This enables proper error handling with [Either] from dartz.
///
/// Example:
/// ```dart
/// Future<Either<Failure, User>> getUser(String id) async {
///   try {
///     final user = await api.getUser(id);
///     return Right(user);
///   } catch (e) {
///     return Left(ServerFailure(message: e.toString()));
///   }
/// }
/// ```
abstract class Failure extends Equatable {
  /// Creates a failure with the given message.
  const Failure({required this.message, this.code});

  /// Human-readable error message.
  final String message;

  /// Optional error code for identification.
  final String? code;

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

// ===== Network Failures =====

/// Failure when there's no internet connection.
class NetworkFailure extends Failure {
  /// Creates a network failure.
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
  });
}

/// Failure when a request times out.
class TimeoutFailure extends Failure {
  /// Creates a timeout failure.
  const TimeoutFailure({
    super.message = 'The request timed out. Please try again.',
    super.code = 'TIMEOUT',
  });
}

// ===== Server Failures =====

/// Failure for server-side errors (5xx).
class ServerFailure extends Failure {
  /// Creates a server failure.
  const ServerFailure({
    super.message = 'Server error. Please try again later.',
    super.code = 'SERVER_ERROR',
    this.statusCode,
  });

  /// HTTP status code if available.
  final int? statusCode;

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Failure when the request is malformed (400).
class BadRequestFailure extends Failure {
  /// Creates a bad request failure.
  const BadRequestFailure({
    super.message = 'Invalid request. Please check your input.',
    super.code = 'BAD_REQUEST',
    this.errors,
  });

  /// Field-specific validation errors.
  final Map<String, List<String>>? errors;

  @override
  List<Object?> get props => [message, code, errors];
}

/// Failure when authentication is required (401).
class UnauthorizedFailure extends Failure {
  /// Creates an unauthorized failure.
  const UnauthorizedFailure({
    super.message = 'Please log in to continue.',
    super.code = 'UNAUTHORIZED',
  });
}

/// Failure when access is denied (403).
class ForbiddenFailure extends Failure {
  /// Creates a forbidden failure.
  const ForbiddenFailure({
    super.message = 'You do not have permission to perform this action.',
    super.code = 'FORBIDDEN',
  });
}

/// Failure when resource is not found (404).
class NotFoundFailure extends Failure {
  /// Creates a not found failure.
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
    super.code = 'NOT_FOUND',
  });
}

/// Failure when there's a conflict (409).
class ConflictFailure extends Failure {
  /// Creates a conflict failure.
  const ConflictFailure({
    super.message = 'A conflict occurred. The resource may already exist.',
    super.code = 'CONFLICT',
  });
}

/// Failure when rate limited (429).
class RateLimitFailure extends Failure {
  /// Creates a rate limit failure.
  const RateLimitFailure({
    super.message = 'Too many requests. Please wait and try again.',
    super.code = 'RATE_LIMIT',
    this.retryAfter,
  });

  /// Duration to wait before retrying.
  final Duration? retryAfter;

  @override
  List<Object?> get props => [message, code, retryAfter];
}

// ===== Cache Failures =====

/// Failure when cache operation fails.
class CacheFailure extends Failure {
  /// Creates a cache failure.
  const CacheFailure({
    super.message = 'Failed to access local data.',
    super.code = 'CACHE_ERROR',
  });
}

/// Failure when cached data is not found.
class CacheNotFoundFailure extends CacheFailure {
  /// Creates a cache not found failure.
  const CacheNotFoundFailure({
    super.message = 'No cached data available.',
    super.code = 'CACHE_NOT_FOUND',
  });
}

/// Failure when cached data has expired.
class CacheExpiredFailure extends CacheFailure {
  /// Creates a cache expired failure.
  const CacheExpiredFailure({
    super.message = 'Cached data has expired.',
    super.code = 'CACHE_EXPIRED',
  });
}

// ===== Auth Failures =====

/// Failure for authentication-related errors.
class AuthFailure extends Failure {
  /// Creates an auth failure.
  const AuthFailure({
    super.message = 'Authentication failed.',
    super.code = 'AUTH_ERROR',
  });
}

/// Failure when credentials are invalid.
class InvalidCredentialsFailure extends AuthFailure {
  /// Creates an invalid credentials failure.
  const InvalidCredentialsFailure({
    super.message = 'Invalid email or password.',
    super.code = 'INVALID_CREDENTIALS',
  });
}

/// Failure when session has expired.
class SessionExpiredFailure extends AuthFailure {
  /// Creates a session expired failure.
  const SessionExpiredFailure({
    super.message = 'Your session has expired. Please log in again.',
    super.code = 'SESSION_EXPIRED',
  });
}

/// Failure when account is not verified.
class AccountNotVerifiedFailure extends AuthFailure {
  /// Creates an account not verified failure.
  const AccountNotVerifiedFailure({
    super.message = 'Please verify your email address to continue.',
    super.code = 'ACCOUNT_NOT_VERIFIED',
  });
}

/// Failure when account is disabled.
class AccountDisabledFailure extends AuthFailure {
  /// Creates an account disabled failure.
  const AccountDisabledFailure({
    super.message = 'Your account has been disabled.',
    super.code = 'ACCOUNT_DISABLED',
  });
}

// ===== Validation Failures =====

/// Failure for validation errors.
class ValidationFailure extends Failure {
  /// Creates a validation failure.
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.field,
    this.errors,
  });

  /// The field that failed validation.
  final String? field;

  /// Multiple validation errors by field.
  final Map<String, List<String>>? errors;

  @override
  List<Object?> get props => [message, code, field, errors];
}

// ===== Other Failures =====

/// Failure when an operation is cancelled.
class CancelledFailure extends Failure {
  /// Creates a cancelled failure.
  const CancelledFailure({
    super.message = 'Operation was cancelled.',
    super.code = 'CANCELLED',
  });
}

/// Failure for unknown or unexpected errors.
class UnknownFailure extends Failure {
  /// Creates an unknown failure.
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.code = 'UNKNOWN_ERROR',
    this.exception,
  });

  /// The original exception if available.
  final Object? exception;

  @override
  List<Object?> get props => [message, code, exception];
}

/// Failure when a feature is not available.
class FeatureNotAvailableFailure extends Failure {
  /// Creates a feature not available failure.
  const FeatureNotAvailableFailure({
    super.message = 'This feature is not available.',
    super.code = 'FEATURE_NOT_AVAILABLE',
  });
}

/// Failure when platform is not supported.
class PlatformNotSupportedFailure extends Failure {
  /// Creates a platform not supported failure.
  const PlatformNotSupportedFailure({
    super.message = 'This feature is not supported on your device.',
    super.code = 'PLATFORM_NOT_SUPPORTED',
  });
}

/// Failure when service is not properly configured.
class ConfigurationFailure extends Failure {
  /// Creates a configuration failure.
  const ConfigurationFailure({
    super.message = 'Service is not properly configured.',
    super.code = 'CONFIGURATION_ERROR',
  });
}
