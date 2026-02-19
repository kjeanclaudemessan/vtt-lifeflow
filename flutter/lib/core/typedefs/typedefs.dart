import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Common type definitions used throughout the application.

/// A Future that returns an [Either] with a [Failure] or a value.
typedef FutureResult<T> = Future<Either<Failure, T>>;

/// A Future that returns an [Either] with a [Failure] or void.
typedef FutureVoidResult = Future<Either<Failure, void>>;

/// A Future that returns an [Either] with a [Failure] or unit (void).
typedef FutureUnitResult = Future<Either<Failure, Unit>>;

/// A synchronous result with either a [Failure] or a value.
typedef Result<T> = Either<Failure, T>;

/// A synchronous result with either a [Failure] or void.
typedef VoidResult = Either<Failure, void>;

/// A JSON map type.
typedef Json = Map<String, dynamic>;

/// A list of JSON maps.
typedef JsonList = List<Map<String, dynamic>>;

/// A callback that receives a value of type [T].
typedef ValueCallback<T> = void Function(T value);

/// A callback that receives a value and returns a result.
typedef ValueMapper<T, R> = R Function(T value);

/// An async callback that receives a value and returns a Future.
typedef AsyncValueCallback<T> = Future<void> Function(T value);

/// An async callback that receives a value and returns a Future result.
typedef AsyncValueMapper<T, R> = Future<R> Function(T value);

/// A predicate function that returns true or false for a value.
typedef Predicate<T> = bool Function(T value);

/// A comparator function for sorting.
typedef Comparator<T> = int Function(T a, T b);

/// A factory function that creates an instance.
typedef Factory<T> = T Function();

/// An async factory function that creates an instance.
typedef AsyncFactory<T> = Future<T> Function();

/// A dispose function.
typedef Dispose = void Function();

/// An async dispose function.
typedef AsyncDispose = Future<void> Function();

/// A JSON converter function.
typedef FromJson<T> = T Function(Map<String, dynamic> json);

/// A JSON serializer function.
typedef ToJson<T> = Map<String, dynamic> Function(T value);

/// A string converter function.
typedef StringMapper = String Function(String value);

/// A validation function that returns an error message or null.
typedef Validator = String? Function(String? value);

/// A form field validation function.
typedef FieldValidator<T> = String? Function(T? value);
