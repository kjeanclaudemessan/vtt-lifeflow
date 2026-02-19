/// Base exception for all app exceptions.
///
/// Unlike [Failure], exceptions are for truly exceptional cases
/// that should not be caught locally (programming errors, etc.).
///
/// In most cases, prefer using [Failure] with [Either] for error handling.
abstract class AppException implements Exception {
  /// Creates an app exception.
  const AppException({required this.message, this.code});

  /// Human-readable error message.
  final String message;

  /// Optional error code.
  final String? code;

  @override
  String toString() => '$runtimeType: $message (code: $code)';
}

// ===== Network Exceptions =====

/// Exception for network-related errors.
class NetworkException extends AppException {
  /// Creates a network exception.
  const NetworkException({
    super.message = 'Network error occurred.',
    super.code = 'NETWORK_ERROR',
    this.statusCode,
    this.response,
  });

  /// HTTP status code if available.
  final int? statusCode;

  /// Raw response data if available.
  final dynamic response;

  @override
  String toString() =>
      'NetworkException: $message (statusCode: $statusCode, code: $code)';
}

/// Exception when no internet connection is available.
class NoInternetException extends NetworkException {
  /// Creates a no internet exception.
  const NoInternetException({
    super.message = 'No internet connection.',
    super.code = 'NO_INTERNET',
  });
}

/// Exception when a request times out.
class TimeoutException extends NetworkException {
  /// Creates a timeout exception.
  const TimeoutException({
    super.message = 'Request timed out.',
    super.code = 'TIMEOUT',
  });
}

// ===== Server Exceptions =====

/// Exception for server errors (5xx).
class ServerException extends AppException {
  /// Creates a server exception.
  const ServerException({
    super.message = 'Server error occurred.',
    super.code = 'SERVER_ERROR',
    this.statusCode,
  });

  /// HTTP status code.
  final int? statusCode;
}

// ===== Cache Exceptions =====

/// Exception for cache-related errors.
class CacheException extends AppException {
  /// Creates a cache exception.
  const CacheException({
    super.message = 'Cache error occurred.',
    super.code = 'CACHE_ERROR',
  });
}

/// Exception when cached data is not found.
class CacheNotFoundException extends CacheException {
  /// Creates a cache not found exception.
  const CacheNotFoundException({
    super.message = 'Cached data not found.',
    super.code = 'CACHE_NOT_FOUND',
  });
}

// ===== Auth Exceptions =====

/// Exception for authentication errors.
class AuthException extends AppException {
  /// Creates an auth exception.
  const AuthException({
    super.message = 'Authentication error occurred.',
    super.code = 'AUTH_ERROR',
  });
}

/// Exception when user is not authenticated.
class UnauthenticatedException extends AuthException {
  /// Creates an unauthenticated exception.
  const UnauthenticatedException({
    super.message = 'User is not authenticated.',
    super.code = 'UNAUTHENTICATED',
  });
}

/// Exception when token refresh fails.
class TokenRefreshException extends AuthException {
  /// Creates a token refresh exception.
  const TokenRefreshException({
    super.message = 'Failed to refresh authentication token.',
    super.code = 'TOKEN_REFRESH_FAILED',
  });
}

// ===== Validation Exceptions =====

/// Exception for validation errors.
class ValidationException extends AppException {
  /// Creates a validation exception.
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.field,
    this.errors,
  });

  /// The field that failed validation.
  final String? field;

  /// Multiple validation errors.
  final Map<String, List<String>>? errors;
}

// ===== Parse Exceptions =====

/// Exception when parsing data fails.
class ParseException extends AppException {
  /// Creates a parse exception.
  const ParseException({
    super.message = 'Failed to parse data.',
    super.code = 'PARSE_ERROR',
    this.source,
  });

  /// The source data that failed to parse.
  final dynamic source;
}

/// Exception when JSON parsing fails.
class JsonParseException extends ParseException {
  /// Creates a JSON parse exception.
  const JsonParseException({
    super.message = 'Failed to parse JSON.',
    super.code = 'JSON_PARSE_ERROR',
    super.source,
  });
}

// ===== Storage Exceptions =====

/// Exception for storage-related errors.
class StorageException extends AppException {
  /// Creates a storage exception.
  const StorageException({
    super.message = 'Storage error occurred.',
    super.code = 'STORAGE_ERROR',
  });
}

/// Exception when storage is full.
class StorageFullException extends StorageException {
  /// Creates a storage full exception.
  const StorageFullException({
    super.message = 'Storage is full.',
    super.code = 'STORAGE_FULL',
  });
}

// ===== Permission Exceptions =====

/// Exception when a permission is denied.
class PermissionDeniedException extends AppException {
  /// Creates a permission denied exception.
  const PermissionDeniedException({
    super.message = 'Permission denied.',
    super.code = 'PERMISSION_DENIED',
    this.permission,
  });

  /// The permission that was denied.
  final String? permission;
}

// ===== Other Exceptions =====

/// Exception when an operation is not supported.
class NotSupportedException extends AppException {
  /// Creates a not supported exception.
  const NotSupportedException({
    super.message = 'Operation not supported.',
    super.code = 'NOT_SUPPORTED',
  });
}

/// Exception when configuration is invalid.
class ConfigurationException extends AppException {
  /// Creates a configuration exception.
  const ConfigurationException({
    super.message = 'Invalid configuration.',
    super.code = 'CONFIGURATION_ERROR',
  });
}
