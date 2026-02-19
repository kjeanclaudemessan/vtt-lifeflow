import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Extensions on [Either] for convenient error handling.
extension EitherExtensions<L, R> on Either<L, R> {
  /// Returns `true` if this is a [Left].
  bool get isLeft => fold((_) => true, (_) => false);

  /// Returns `true` if this is a [Right].
  bool get isRight => fold((_) => false, (_) => true);

  /// Gets the left value or null.
  L? get leftOrNull => fold((l) => l, (_) => null);

  /// Gets the right value or null.
  R? get rightOrNull => fold((_) => null, (r) => r);

  /// Gets the right value or throws the left value.
  ///
  /// Use with caution - prefer using [fold] for proper error handling.
  R getOrThrow() {
    return fold(
      (l) => throw l is Exception ? l : Exception(l.toString()),
      (r) => r,
    );
  }

  /// Gets the right value or returns [defaultValue].
  R getOrElse(R defaultValue) => fold((_) => defaultValue, (r) => r);

  /// Gets the right value or computes it from [orElse].
  R getOrElseCompute(R Function(L left) orElse) => fold(orElse, (r) => r);

  /// Maps the right value.
  Either<L, T> mapRight<T>(T Function(R right) mapper) {
    return fold(
      (l) => Left(l),
      (r) => Right(mapper(r)),
    );
  }

  /// Maps the left value.
  Either<T, R> mapLeft<T>(T Function(L left) mapper) {
    return fold(
      (l) => Left(mapper(l)),
      (r) => Right(r),
    );
  }

  /// Flat maps the right value.
  Either<L, T> flatMapRight<T>(Either<L, T> Function(R right) mapper) {
    return fold(
      (l) => Left(l),
      (r) => mapper(r),
    );
  }

  /// Executes [onRight] if this is a Right, otherwise does nothing.
  void ifRight(void Function(R right) onRight) {
    fold((_) {}, onRight);
  }

  /// Executes [onLeft] if this is a Left, otherwise does nothing.
  void ifLeft(void Function(L left) onLeft) {
    fold(onLeft, (_) {});
  }

  /// Swaps Left and Right.
  Either<R, L> swap() => fold((l) => Right(l), (r) => Left(r));
}

/// Extensions on [Either<Failure, T>] for common failure handling.
extension FailureEitherExtensions<T> on Either<Failure, T> {
  /// Gets the failure message or null if successful.
  String? get failureMessage => leftOrNull?.message;

  /// Gets the failure code or null if successful.
  String? get failureCode => leftOrNull?.code;

  /// Returns `true` if this is a network failure.
  bool get isNetworkFailure => leftOrNull is NetworkFailure;

  /// Returns `true` if this is an auth failure.
  bool get isAuthFailure => leftOrNull is AuthFailure;

  /// Returns `true` if this is a validation failure.
  bool get isValidationFailure => leftOrNull is ValidationFailure;

  /// Returns `true` if this is a server failure.
  bool get isServerFailure => leftOrNull is ServerFailure;

  /// Converts the failure to a user-friendly error message.
  String? get userFriendlyError {
    return fold(
      (failure) => failure.message,
      (_) => null,
    );
  }
}

/// Extensions for Future<Either>.
extension FutureEitherExtensions<L, R> on Future<Either<L, R>> {
  /// Maps the right value asynchronously.
  Future<Either<L, T>> mapRightAsync<T>(
    Future<T> Function(R right) mapper,
  ) async {
    final either = await this;
    return either.fold(
      (l) => Left(l),
      (r) async => Right(await mapper(r)),
    );
  }

  /// Flat maps the right value asynchronously.
  Future<Either<L, T>> flatMapRightAsync<T>(
    Future<Either<L, T>> Function(R right) mapper,
  ) async {
    final either = await this;
    return either.fold(
      (l) => Left(l),
      (r) => mapper(r),
    );
  }

  /// Executes [onRight] if successful, [onLeft] if failure.
  Future<void> handle({
    required void Function(R right) onRight,
    required void Function(L left) onLeft,
  }) async {
    final either = await this;
    either.fold(onLeft, onRight);
  }
}

/// Extensions on [Option] from dartz.
extension OptionExtensions<T> on Option<T> {
  /// Gets the value or null.
  T? get valueOrNull => fold(() => null, (t) => t);

  /// Gets the value or returns [defaultValue].
  T getOrElse(T defaultValue) => fold(() => defaultValue, (t) => t);

  /// Gets the value or computes it from [orElse].
  T getOrElseCompute(T Function() orElse) => fold(orElse, (t) => t);

  /// Returns `true` if this is a Some.
  bool get isSome => fold(() => false, (_) => true);

  /// Returns `true` if this is a None.
  bool get isNone => fold(() => true, (_) => false);

  /// Maps the value.
  Option<R> mapOption<R>(R Function(T value) mapper) {
    return fold(() => const None(), (t) => Some(mapper(t)));
  }

  /// Converts to Either with [leftValue] if None.
  Either<L, T> toEither<L>(L leftValue) {
    return fold(() => Left(leftValue), (t) => Right(t));
  }
}
