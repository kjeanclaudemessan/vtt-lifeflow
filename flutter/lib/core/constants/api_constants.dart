/// API-related constants.
///
/// Contains endpoint paths, headers, and other API configuration.
class ApiConstants {
  ApiConstants._();

  // ===== Headers =====

  /// Content-Type header for JSON requests.
  static const String contentTypeJson = 'application/json';

  /// Accept header for JSON responses.
  static const String acceptJson = 'application/json';

  /// Authorization header key.
  static const String authorizationHeader = 'Authorization';

  /// Bearer token prefix.
  static const String bearerPrefix = 'Bearer';

  /// API version header.
  static const String apiVersionHeader = 'X-API-Version';

  /// Current API version.
  static const String apiVersion = '1';

  // ===== Endpoints =====

  /// Authentication endpoints.
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authLogout = '/auth/logout';
  static const String authRefresh = '/auth/refresh';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';
  static const String authVerifyEmail = '/auth/verify-email';

  /// User endpoints.
  static const String userProfile = '/users/me';
  static const String userUpdate = '/users/me';
  static const String userDelete = '/users/me';
  static const String userAvatar = '/users/me/avatar';

  // ===== Pagination =====

  /// Default page size for paginated requests.
  static const int defaultPageSize = 20;

  /// Maximum page size allowed.
  static const int maxPageSize = 100;

  /// Page query parameter name.
  static const String pageParam = 'page';

  /// Page size query parameter name.
  static const String pageSizeParam = 'per_page';

  // ===== Timeouts =====

  /// Connection timeout duration.
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Receive timeout duration.
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Send timeout duration.
  static const Duration sendTimeout = Duration(seconds: 30);

  // ===== Retry =====

  /// Maximum number of retry attempts.
  static const int maxRetries = 3;

  /// Delay between retry attempts.
  static const Duration retryDelay = Duration(seconds: 1);

  // ===== Status Codes =====

  /// Success status codes.
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusNoContent = 204;

  /// Client error status codes.
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusConflict = 409;
  static const int statusUnprocessableEntity = 422;
  static const int statusTooManyRequests = 429;

  /// Server error status codes.
  static const int statusInternalServerError = 500;
  static const int statusBadGateway = 502;
  static const int statusServiceUnavailable = 503;
}
