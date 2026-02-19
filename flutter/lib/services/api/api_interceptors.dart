import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../app/app.locator.dart';
import '../storage/secure_storage_service.dart';

/// Interceptor that adds authentication token to requests.
///
/// Automatically adds the Bearer token from secure storage
/// to all outgoing requests.
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip if explicitly marked as no-auth
    if (options.extra['skipAuth'] == true) {
      return handler.next(options);
    }

    try {
      final secureStorage = locator<SecureStorageService>();
      final token = await secureStorage.getAccessToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      developer.log('AuthInterceptor: Failed to get token - $e');
    }

    handler.next(options);
  }
}

/// Interceptor for logging HTTP requests and responses.
///
/// Logs request details, response status, and errors for debugging.
class LoggingInterceptor extends Interceptor {
  /// Whether to log request/response bodies.
  final bool logBody;

  /// Creates a [LoggingInterceptor].
  LoggingInterceptor({this.logBody = false});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '→ ${options.method} ${options.uri}',
      name: 'API',
    );

    if (logBody && options.data != null) {
      developer.log(
        '  Body: ${options.data}',
        name: 'API',
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      name: 'API',
    );

    if (logBody && response.data != null) {
      developer.log(
        '  Response: ${response.data}',
        name: 'API',
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '✗ ${err.response?.statusCode ?? 'NO_RESPONSE'} ${err.requestOptions.uri}',
      name: 'API',
      error: err.message,
    );

    handler.next(err);
  }
}

/// Interceptor for handling common errors.
///
/// Handles token refresh on 401, network errors, etc.
class ErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - attempt token refresh
    if (err.response?.statusCode == 401) {
      // TODO: Implement token refresh logic
      // final refreshed = await _refreshToken();
      // if (refreshed) {
      //   return handler.resolve(await _retry(err.requestOptions));
      // }
    }

    handler.next(err);
  }
}

/// Interceptor that adds retry logic for failed requests.
///
/// Automatically retries failed requests with exponential backoff.
class RetryInterceptor extends Interceptor {
  /// Maximum number of retry attempts.
  final int maxRetries;

  /// Initial retry delay.
  final Duration retryDelay;

  /// HTTP status codes to retry.
  final List<int> retryStatusCodes;

  final Dio _dio;

  /// Creates a [RetryInterceptor].
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryStatusCodes = const [408, 500, 502, 503, 504],
  }) : _dio = dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    // Check if we should retry
    final shouldRetry = retryCount < maxRetries &&
        (statusCode == null || retryStatusCodes.contains(statusCode));

    if (shouldRetry) {
      // Calculate delay with exponential backoff
      final delay = retryDelay * (retryCount + 1);
      await Future<void>.delayed(delay);

      developer.log(
        '↻ Retry ${retryCount + 1}/$maxRetries for ${err.requestOptions.uri}',
        name: 'API',
      );

      // Update retry count
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      try {
        final response = await _dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }

    handler.next(err);
  }
}
