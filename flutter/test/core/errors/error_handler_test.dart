import 'dart:async' as async;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/core/config/app_config.dart';
import 'package:lifeflow/core/config/env/environment.dart';
import 'package:lifeflow/core/errors/error_handler.dart';
import 'package:lifeflow/core/errors/exceptions.dart';
import 'package:lifeflow/core/errors/failures.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────
  // ErrorHandler Tests
  // ─────────────────────────────────────────────────────────────────

  setUpAll(() {
    AppConfig.initialize(Environment.development);
  });

  tearDownAll(() {
    AppConfig.reset();
  });

  group('ErrorHandler', () {
    // ───────────────────────────────────────────────────────────────
    // General errors
    // ───────────────────────────────────────────────────────────────
    group('handle', () {
      test('should return NetworkFailure for SocketException', () {
        final failure =
            ErrorHandler.handle(const SocketException('No internet'));
        expect(failure, isA<NetworkFailure>());
      });

      test('should return TimeoutFailure for dart:async TimeoutException', () {
        final failure =
            ErrorHandler.handle(async.TimeoutException('Timed out'));
        expect(failure, isA<TimeoutFailure>());
      });

      test('should return TimeoutFailure for app TimeoutException', () {
        final failure = ErrorHandler.handle(const TimeoutException());
        expect(failure, isA<TimeoutFailure>());
      });

      test('should return UnknownFailure for FormatException', () {
        final failure =
            ErrorHandler.handle(const FormatException('Parse error'));
        expect(failure, isA<UnknownFailure>());
        expect(failure.message, contains('Parse error'));
      });

      test('should return same Failure if passed a Failure', () {
        const originalFailure = ValidationFailure(message: 'Test error');
        final failure = ErrorHandler.handle(originalFailure);
        expect(failure, equals(originalFailure));
      });

      test('should return UnknownFailure for unknown errors', () {
        final failure = ErrorHandler.handle(Exception('Unknown'));
        expect(failure, isA<UnknownFailure>());
      });
    });

    // ───────────────────────────────────────────────────────────────
    // DioException handling
    // ───────────────────────────────────────────────────────────────
    group('DioException handling', () {
      test('should return TimeoutFailure for connection timeout', () {
        final dioError = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: '/test'),
        );
        final failure = ErrorHandler.handle(dioError);
        expect(failure, isA<TimeoutFailure>());
      });

      test('should return TimeoutFailure for send timeout', () {
        final dioError = DioException(
          type: DioExceptionType.sendTimeout,
          requestOptions: RequestOptions(path: '/test'),
        );
        final failure = ErrorHandler.handle(dioError);
        expect(failure, isA<TimeoutFailure>());
      });

      test('should return TimeoutFailure for receive timeout', () {
        final dioError = DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(path: '/test'),
        );
        final failure = ErrorHandler.handle(dioError);
        expect(failure, isA<TimeoutFailure>());
      });

      test('should return NetworkFailure for connection error', () {
        final dioError = DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: '/test'),
        );
        final failure = ErrorHandler.handle(dioError);
        expect(failure, isA<NetworkFailure>());
      });

      test('should return CancelledFailure for cancelled request', () {
        final dioError = DioException(
          type: DioExceptionType.cancel,
          requestOptions: RequestOptions(path: '/test'),
        );
        final failure = ErrorHandler.handle(dioError);
        expect(failure, isA<CancelledFailure>());
      });

      test('should return UnauthorizedFailure for 401 response', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        final failure = ErrorHandler.handle(dioError);
        expect(failure, isA<UnauthorizedFailure>());
      });

      test('should return ForbiddenFailure for 403 response', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        final failure = ErrorHandler.handle(dioError);
        expect(failure, isA<ForbiddenFailure>());
      });

      test('should return NotFoundFailure for 404 response', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        final failure = ErrorHandler.handle(dioError);
        expect(failure, isA<NotFoundFailure>());
      });

      test('should return ServerFailure for 500 response', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        final failure = ErrorHandler.handle(dioError);
        expect(failure, isA<ServerFailure>());
      });

      test('should return ValidationFailure for 422 response', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 422,
            data: {'message': 'Validation failed'},
            requestOptions: RequestOptions(path: '/test'),
          ),
        );
        final failure = ErrorHandler.handle(dioError);
        expect(failure, isA<ValidationFailure>());
      });
    });

    // ───────────────────────────────────────────────────────────────
    // AppException handling
    // ───────────────────────────────────────────────────────────────
    group('AppException handling', () {
      test('should return NetworkFailure for NetworkException', () {
        final failure = ErrorHandler.handle(const NetworkException());
        expect(failure, isA<NetworkFailure>());
      });

      test('should return CacheFailure for CacheException', () {
        final failure = ErrorHandler.handle(const CacheException());
        expect(failure, isA<CacheFailure>());
      });

      test('should return ServerFailure for ServerException', () {
        final failure = ErrorHandler.handle(const ServerException());
        expect(failure, isA<ServerFailure>());
      });

      test('should return ValidationFailure for ValidationException', () {
        final failure = ErrorHandler.handle(
          const ValidationException(message: 'Validation error'),
        );
        expect(failure, isA<ValidationFailure>());
      });

      test('should return UnauthorizedFailure for UnauthenticatedException',
          () {
        final failure = ErrorHandler.handle(const UnauthenticatedException());
        expect(failure, isA<UnauthorizedFailure>());
      });
    });
  });
}
