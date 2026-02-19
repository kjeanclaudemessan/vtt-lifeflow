import 'dart:async' as async;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../config/app_config.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Handles errors and converts them to appropriate [Failure] types.
///
/// Use this class to standardize error handling across the app.
///
/// Example:
/// ```dart
/// Future<Either<Failure, User>> getUser() async {
///   try {
///     final response = await api.getUser();
///     return Right(User.fromJson(response));
///   } catch (e) {
///     return Left(ErrorHandler.handle(e));
///   }
/// }
/// ```
class ErrorHandler {
  ErrorHandler._();

  /// Converts any error to an appropriate [Failure].
  ///
  /// Handles common error types:
  /// - [DioException] - HTTP/network errors
  /// - [SocketException] - No internet
  /// - [async.TimeoutException] - Request timeout (dart:async)
  /// - [TimeoutException] - Request timeout (app exception)
  /// - [AppException] - Custom app exceptions
  /// - [FormatException] - Parsing errors
  static Failure handle(Object error, [StackTrace? stackTrace]) {
    _log(error, stackTrace);

    return switch (error) {
      DioException() => _handleDioException(error),
      SocketException() => const NetworkFailure(),
      async.TimeoutException() => const TimeoutFailure(),
      AppException() => _handleAppException(error),
      FormatException() => UnknownFailure(
          message: 'Failed to parse data: ${error.message}',
          exception: error,
        ),
      Failure() => error,
      supabase.AuthException() => _handleSupabaseAuthException(error),
      _ => UnknownFailure(
          message: error.toString(),
          exception: error,
        ),
    };
  }

  /// Handles [DioException] and converts to appropriate failure.
  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badCertificate:
        return const ServerFailure(
          message: 'Certificate verification failed.',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return const CancelledFailure();

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkFailure();
        }
        return UnknownFailure(
          message: error.message ?? 'Unknown network error.',
          exception: error,
        );
    }
  }

  /// Handles bad HTTP responses based on status code.
  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure();
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // Try to extract error message from response
    final message = _extractErrorMessage(data);
    final code = _extractErrorCode(data);

    return switch (statusCode) {
      400 => BadRequestFailure(
          message: message ?? 'Invalid request.',
          code: code ?? 'BAD_REQUEST',
          errors: _extractValidationErrors(data),
        ),
      401 => UnauthorizedFailure(
          message: message ?? 'Authentication required.',
          code: code ?? 'UNAUTHORIZED',
        ),
      403 => ForbiddenFailure(
          message: message ?? 'Access denied.',
          code: code ?? 'FORBIDDEN',
        ),
      404 => NotFoundFailure(
          message: message ?? 'Resource not found.',
          code: code ?? 'NOT_FOUND',
        ),
      409 => ConflictFailure(
          message: message ?? 'Conflict occurred.',
          code: code ?? 'CONFLICT',
        ),
      422 => ValidationFailure(
          message: message ?? 'Validation failed.',
          code: code ?? 'VALIDATION_ERROR',
          errors: _extractValidationErrors(data),
        ),
      429 => RateLimitFailure(
          message: message ?? 'Too many requests.',
          code: code ?? 'RATE_LIMIT',
          retryAfter: _extractRetryAfter(response),
        ),
      >= 500 && < 600 => ServerFailure(
          message: message ?? 'Server error.',
          code: code ?? 'SERVER_ERROR',
          statusCode: statusCode,
        ),
      _ => ServerFailure(
          message: message ?? 'Request failed.',
          code: code ?? 'HTTP_ERROR',
          statusCode: statusCode,
        ),
    };
  }

  /// Handles custom app exceptions.
  static Failure _handleAppException(AppException error) {
    return switch (error) {
      NoInternetException() => const NetworkFailure(),
      TimeoutException() => const TimeoutFailure(),
      NetworkException() => NetworkFailure(
          message: error.message,
          code: error.code,
        ),
      CacheNotFoundException() => const CacheNotFoundFailure(),
      CacheException() => CacheFailure(
          message: error.message,
          code: error.code,
        ),
      ServerException() => ServerFailure(
          message: error.message,
          code: error.code,
          statusCode: error.statusCode,
        ),
      UnauthenticatedException() => const UnauthorizedFailure(),
      TokenRefreshException() => const SessionExpiredFailure(),
      AuthException() => AuthFailure(
          message: error.message,
          code: error.code,
        ),
      ValidationException() => ValidationFailure(
          message: error.message,
          code: error.code,
          field: error.field,
          errors: error.errors,
        ),
      _ => UnknownFailure(
          message: error.message,
          code: error.code,
          exception: error,
        ),
    };
  }

  /// Handles Supabase [AuthException] and converts to user-friendly [AuthFailure].
  static Failure _handleSupabaseAuthException(supabase.AuthException error) {
    final code = error.code ?? '';
    final message = switch (code) {
      'invalid_credentials' => 'Email ou mot de passe incorrect.',
      'user_not_found' => 'Aucun compte trouvé avec cet email.',
      'email_not_confirmed' =>
        'Veuillez confirmer votre email avant de vous connecter.',
      'user_already_exists' ||
      'email_exists' =>
        'Un compte avec cet email existe déjà.',
      'weak_password' => 'Le mot de passe est trop faible.',
      'over_request_rate_limit' ||
      'rate_limit' =>
        'Trop de tentatives. Réessayez dans quelques minutes.',
      'otp_expired' => 'Le code de vérification a expiré.',
      'session_not_found' => 'Session expirée. Veuillez vous reconnecter.',
      'user_banned' => 'Ce compte a été suspendu.',
      _ => error.message,
    };

    return AuthFailure(
      message: message,
      code: code.isNotEmpty ? code : 'AUTH_ERROR',
    );
  }

  /// Extracts error message from response data.
  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is! Map<String, dynamic>) return null;

    // Common error message field names
    return data['message'] as String? ??
        data['error'] as String? ??
        data['error_description'] as String? ??
        data['detail'] as String?;
  }

  /// Extracts error code from response data.
  static String? _extractErrorCode(dynamic data) {
    if (data == null) return null;
    if (data is! Map<String, dynamic>) return null;

    return data['code'] as String? ?? data['error_code'] as String?;
  }

  /// Extracts validation errors from response data.
  static Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data == null) return null;
    if (data is! Map<String, dynamic>) return null;

    final errors = data['errors'];
    if (errors == null) return null;

    if (errors is Map<String, dynamic>) {
      return errors.map((key, value) {
        if (value is List) {
          return MapEntry(key, value.map((e) => e.toString()).toList());
        }
        return MapEntry(key, [value.toString()]);
      });
    }

    return null;
  }

  /// Extracts retry-after duration from response headers.
  static Duration? _extractRetryAfter(Response response) {
    final retryAfter = response.headers.value('retry-after');
    if (retryAfter == null) return null;

    final seconds = int.tryParse(retryAfter);
    if (seconds != null) {
      return Duration(seconds: seconds);
    }

    return null;
  }

  /// Logs the error if logging is enabled.
  static void _log(Object error, StackTrace? stackTrace) {
    if (!AppConfig.instance.enableLogging) return;

    // TODO: Replace with proper logger when implemented
    // ignore: avoid_print
    print('Error: $error');
    if (stackTrace != null) {
      // ignore: avoid_print
      print('StackTrace: $stackTrace');
    }
  }
}
