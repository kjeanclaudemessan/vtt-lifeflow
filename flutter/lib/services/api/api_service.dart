import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import 'api_interceptors.dart';
import 'api_response.dart';

/// HTTP client service using Dio.
///
/// Provides a clean interface for making HTTP requests with
/// automatic error handling, authentication, and logging.
///
/// Example:
/// ```dart
/// final apiService = locator<ApiService>();
///
/// // GET request
/// final result = await apiService.get<Map<String, dynamic>>('/users/1');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (data) => print('User: $data'),
/// );
///
/// // POST request
/// final createResult = await apiService.post<Map<String, dynamic>>(
///   '/users',
///   data: {'name': 'John', 'email': 'john@example.com'},
/// );
/// ```
class ApiService {
  late final Dio _dio;

  /// Creates an [ApiService] and configures Dio.
  ApiService() {
    _dio = Dio(_baseOptions);
    _setupInterceptors();
  }

  /// Base options for all requests.
  BaseOptions get _baseOptions => BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      );

  /// Sets up request/response interceptors.
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(logBody: AppConfig.instance.enableLogging),
      ErrorInterceptor(),
      RetryInterceptor(dio: _dio, maxRetries: 3),
    ]);
  }

  /// Performs a GET request.
  ///
  /// Returns [Either] with [Failure] on error or response data on success.
  Future<Either<Failure, T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _executeRequest(() => _dio.get<T>(
          path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ));
  }

  /// Performs a POST request.
  Future<Either<Failure, T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _executeRequest(() => _dio.post<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ));
  }

  /// Performs a PUT request.
  Future<Either<Failure, T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _executeRequest(() => _dio.put<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ));
  }

  /// Performs a PATCH request.
  Future<Either<Failure, T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _executeRequest(() => _dio.patch<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ));
  }

  /// Performs a DELETE request.
  Future<Either<Failure, T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _executeRequest(() => _dio.delete<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ));
  }

  /// Uploads a file with multipart form data.
  Future<Either<Failure, T>> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? data,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final formData = FormData.fromMap({
      ...?data,
      fieldName: await MultipartFile.fromFile(filePath),
    });

    return _executeRequest(() => _dio.post<T>(
          path,
          data: formData,
          onSendProgress: onSendProgress,
          cancelToken: cancelToken,
        ));
  }

  /// Downloads a file.
  Future<Either<Failure, String>> downloadFile(
    String url,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return Right(savePath);
    } on DioException catch (e) {
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Parses response into ApiResponse wrapper.
  ApiResponse<T> parseResponse<T>(
    Response response,
    T Function(dynamic json)? fromJson,
  ) {
    if (response.data is Map<String, dynamic>) {
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        fromJson,
      );
    }
    return ApiResponse.success(data: response.data as T?);
  }

  /// Executes a request and handles errors.
  Future<Either<Failure, T>> _executeRequest<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      final response = await request();

      // Check for error status codes
      if (response.statusCode != null && response.statusCode! >= 400) {
        return Left(_handleErrorResponse(response));
      }

      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Handles error responses.
  Failure _handleErrorResponse(Response response) {
    final statusCode = response.statusCode ?? 500;
    final message = _extractErrorMessage(response.data);

    return switch (statusCode) {
      400 => ValidationFailure(message: message),
      401 => UnauthorizedFailure(message: message),
      403 => ForbiddenFailure(message: message),
      404 => NotFoundFailure(message: message),
      408 => TimeoutFailure(message: message),
      422 => ValidationFailure(message: message),
      429 => RateLimitFailure(message: message),
      _ when statusCode >= 500 => ServerFailure(
          message: message,
          statusCode: statusCode,
        ),
      _ => UnknownFailure(message: message),
    };
  }

  /// Extracts error message from response data.
  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          'An error occurred';
    }
    return 'An error occurred';
  }

  /// Updates the authorization token.
  void updateToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Clears the authorization token.
  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }
}
