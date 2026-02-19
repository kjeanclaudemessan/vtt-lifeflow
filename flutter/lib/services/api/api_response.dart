import 'package:equatable/equatable.dart';

/// Generic API response wrapper.
///
/// Wraps API responses with metadata like status, message, and pagination.
///
/// Example:
/// ```dart
/// final response = ApiResponse<UserModel>(
///   data: UserModel.fromJson(json),
///   message: 'User fetched successfully',
///   success: true,
/// );
/// ```
class ApiResponse<T> extends Equatable {
  /// The response data.
  final T? data;

  /// Response message from the server.
  final String? message;

  /// Whether the request was successful.
  final bool success;

  /// HTTP status code.
  final int? statusCode;

  /// Pagination info (if applicable).
  final PaginationMeta? pagination;

  /// Creates an [ApiResponse].
  const ApiResponse({
    this.data,
    this.message,
    this.success = true,
    this.statusCode,
    this.pagination,
  });

  /// Creates a successful response.
  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
    PaginationMeta? pagination,
  }) {
    return ApiResponse<T>(
      data: data,
      message: message,
      success: true,
      statusCode: statusCode,
      pagination: pagination,
    );
  }

  /// Creates an error response.
  factory ApiResponse.error({
    String? message,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      data: null,
      message: message,
      success: false,
      statusCode: statusCode,
    );
  }

  /// Creates from JSON with a data parser.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      message: json['message'] as String?,
      success: json['success'] as bool? ?? true,
      statusCode: json['statusCode'] as int?,
      pagination: json['pagination'] != null
          ? PaginationMeta.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Whether response has data.
  bool get hasData => data != null;

  /// Whether response is paginated.
  bool get isPaginated => pagination != null;

  /// Whether there are more pages.
  bool get hasMorePages => pagination?.hasNextPage ?? false;

  @override
  List<Object?> get props => [data, message, success, statusCode, pagination];
}

/// Pagination metadata.
///
/// Contains information about paginated responses.
class PaginationMeta extends Equatable {
  /// Current page number (1-indexed).
  final int currentPage;

  /// Total number of pages.
  final int totalPages;

  /// Total number of items.
  final int totalItems;

  /// Items per page.
  final int perPage;

  /// Creates a [PaginationMeta].
  const PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
  });

  /// Creates from JSON.
  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: json['totalItems'] as int? ?? 0,
      perPage: json['perPage'] as int? ?? 10,
    );
  }

  /// Whether there is a next page.
  bool get hasNextPage => currentPage < totalPages;

  /// Whether there is a previous page.
  bool get hasPrevPage => currentPage > 1;

  /// Next page number (null if no next page).
  int? get nextPage => hasNextPage ? currentPage + 1 : null;

  /// Previous page number (null if no previous page).
  int? get prevPage => hasPrevPage ? currentPage - 1 : null;

  @override
  List<Object?> get props => [currentPage, totalPages, totalItems, perPage];
}
