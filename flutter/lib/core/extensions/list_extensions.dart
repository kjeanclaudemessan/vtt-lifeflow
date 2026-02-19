/// Extensions on [List] for common list operations.
extension ListExtensions<T> on List<T> {
  /// Returns the first element or null if the list is empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element or null if the list is empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Returns the element at [index] or null if out of bounds.
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Returns the first element matching [test] or null if not found.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the last element matching [test] or null if not found.
  T? lastWhereOrNull(bool Function(T element) test) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) return this[i];
    }
    return null;
  }

  /// Returns `true` if all elements satisfy [test].
  bool all(bool Function(T element) test) {
    for (final element in this) {
      if (!test(element)) return false;
    }
    return true;
  }

  /// Returns `true` if no elements satisfy [test].
  bool none(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return false;
    }
    return true;
  }

  /// Returns a new list with duplicates removed.
  List<T> distinct() => toSet().toList();

  /// Returns a new list with duplicates removed based on [keySelector].
  List<T> distinctBy<K>(K Function(T element) keySelector) {
    final seen = <K>{};
    return where((element) => seen.add(keySelector(element))).toList();
  }

  /// Splits the list into chunks of [size].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 4, 5].chunked(2) // [[1, 2], [3, 4], [5]]
  /// ```
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size > length) ? length : i + size));
    }
    return chunks;
  }

  /// Returns a new list with elements separated by [separator].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].separatedBy(0) // [1, 0, 2, 0, 3]
  /// ```
  List<T> separatedBy(T separator) {
    if (length <= 1) return [...this];
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(separator);
      }
    }
    return result;
  }

  /// Returns a copy of the list sorted by [keySelector].
  List<T> sortedBy<K extends Comparable<K>>(K Function(T element) keySelector) {
    return [...this]..sort((a, b) => keySelector(a).compareTo(keySelector(b)));
  }

  /// Returns a copy of the list sorted by [keySelector] in descending order.
  List<T> sortedByDescending<K extends Comparable<K>>(
    K Function(T element) keySelector,
  ) {
    return [...this]..sort((a, b) => keySelector(b).compareTo(keySelector(a)));
  }

  /// Groups elements by [keySelector].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 4, 5].groupBy((n) => n % 2) // {1: [1, 3, 5], 0: [2, 4]}
  /// ```
  Map<K, List<T>> groupBy<K>(K Function(T element) keySelector) {
    final result = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      (result[key] ??= []).add(element);
    }
    return result;
  }

  /// Returns a random element from the list.
  ///
  /// Throws [StateError] if the list is empty.
  T random() {
    if (isEmpty) throw StateError('Cannot get random element from empty list');
    return this[(DateTime.now().microsecondsSinceEpoch % length)];
  }

  /// Returns a random element or null if the list is empty.
  T? randomOrNull() {
    if (isEmpty) return null;
    return this[(DateTime.now().microsecondsSinceEpoch % length)];
  }

  /// Swaps elements at [i] and [j].
  void swap(int i, int j) {
    final temp = this[i];
    this[i] = this[j];
    this[j] = temp;
  }

  /// Returns a new list with elements in reversed order.
  List<T> get reversedList => reversed.toList();

  /// Returns `true` if the list contains all elements of [other].
  bool containsAll(Iterable<T> other) {
    for (final element in other) {
      if (!contains(element)) return false;
    }
    return true;
  }

  /// Returns the index of the first element matching [test] or -1 if not found.
  int indexWhereOrNegative(bool Function(T element) test) {
    final index = indexWhere(test);
    return index;
  }

  /// Returns a map with elements as keys and their index as values.
  Map<T, int> toIndexMap() {
    return {for (var i = 0; i < length; i++) this[i]: i};
  }

  /// Converts a list to a map using [keySelector] for keys.
  Map<K, T> toMap<K>(K Function(T element) keySelector) {
    return {for (final element in this) keySelector(element): element};
  }

  /// Converts a list to a map using [keySelector] and [valueSelector].
  Map<K, V> toMapWithValue<K, V>(
    K Function(T element) keySelector,
    V Function(T element) valueSelector,
  ) {
    return {
      for (final element in this) keySelector(element): valueSelector(element),
    };
  }
}

/// Extensions on nullable [List].
extension NullableListExtensions<T> on List<T>? {
  /// Returns `true` if the list is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns `true` if the list is not null and not empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns the list or an empty list if null.
  List<T> get orEmpty => this ?? [];

  /// Returns the length or 0 if null.
  int get lengthOrZero => this?.length ?? 0;
}

/// Extensions on [Iterable].
extension IterableExtensions<T> on Iterable<T> {
  /// Returns the sum of all elements using [selector].
  num sumBy(num Function(T element) selector) {
    return fold(0, (sum, element) => sum + selector(element));
  }

  /// Returns the average of all elements using [selector].
  double averageBy(num Function(T element) selector) {
    if (isEmpty) return 0;
    return sumBy(selector) / length;
  }

  /// Returns the maximum element using [selector].
  T? maxBy<K extends Comparable<K>>(K Function(T element) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) > 0 ? a : b);
  }

  /// Returns the minimum element using [selector].
  T? minBy<K extends Comparable<K>>(K Function(T element) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) < 0 ? a : b);
  }
}
