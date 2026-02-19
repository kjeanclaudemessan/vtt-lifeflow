/// Extensions on [num] (int and double) for common operations.
extension NumExtensions on num {
  /// Returns `true` if this number is between [min] and [max] (inclusive).
  bool isBetween(num min, num max) => this >= min && this <= max;

  /// Clamps this number to be within [min] and [max].
  num clampTo(num min, num max) => clamp(min, max);

  /// Returns this number as a percentage string.
  ///
  /// Example:
  /// ```dart
  /// 0.5.toPercentage() // '50%'
  /// 0.756.toPercentage(decimals: 1) // '75.6%'
  /// ```
  String toPercentage({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  /// Returns a [Duration] representing this value in milliseconds.
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Returns a [Duration] representing this value in seconds.
  Duration get seconds => Duration(seconds: toInt());

  /// Returns a [Duration] representing this value in minutes.
  Duration get minutes => Duration(minutes: toInt());

  /// Returns a [Duration] representing this value in hours.
  Duration get hours => Duration(hours: toInt());

  /// Returns a [Duration] representing this value in days.
  Duration get days => Duration(days: toInt());

  /// Returns `true` if this number is positive.
  bool get isPositive => this > 0;

  /// Returns `true` if this number is negative.
  bool get isNegative => this < 0;

  /// Returns `true` if this number is zero.
  bool get isZero => this == 0;

  /// Returns the absolute value as the same type.
  num get absoluteValue => abs();
}

/// Extensions on [int].
extension IntExtensions on int {
  /// Returns an ordinal string representation.
  ///
  /// Example:
  /// ```dart
  /// 1.ordinal // '1st'
  /// 2.ordinal // '2nd'
  /// 3.ordinal // '3rd'
  /// 11.ordinal // '11th'
  /// ```
  String get ordinal {
    final absValue = abs();
    final lastDigit = absValue % 10;
    final lastTwoDigits = absValue % 100;

    String suffix;
    if (lastTwoDigits >= 11 && lastTwoDigits <= 13) {
      suffix = 'th';
    } else {
      switch (lastDigit) {
        case 1:
          suffix = 'st';
        case 2:
          suffix = 'nd';
        case 3:
          suffix = 'rd';
        default:
          suffix = 'th';
      }
    }

    return '$this$suffix';
  }

  /// Returns `true` if this integer is even.
  bool get isEven => this % 2 == 0;

  /// Returns `true` if this integer is odd.
  bool get isOdd => this % 2 != 0;

  /// Pads this integer with leading zeros to [width] characters.
  ///
  /// Example:
  /// ```dart
  /// 5.padLeft(3) // '005'
  /// 42.padLeft(5) // '00042'
  /// ```
  String padLeft(int width) => toString().padLeft(width, '0');

  /// Returns a list of integers from 0 to this value (exclusive).
  ///
  /// Example:
  /// ```dart
  /// 5.range // [0, 1, 2, 3, 4]
  /// ```
  List<int> get range => List.generate(this, (i) => i);

  /// Executes [action] this many times.
  ///
  /// Example:
  /// ```dart
  /// 3.times(() => print('Hello'));
  /// // Prints 'Hello' 3 times
  /// ```
  void times(void Function() action) {
    for (var i = 0; i < this; i++) {
      action();
    }
  }

  /// Executes [action] this many times with the index.
  ///
  /// Example:
  /// ```dart
  /// 3.timesIndexed((i) => print('Item $i'));
  /// // Prints 'Item 0', 'Item 1', 'Item 2'
  /// ```
  void timesIndexed(void Function(int index) action) {
    for (var i = 0; i < this; i++) {
      action(i);
    }
  }
}

/// Extensions on [double].
extension DoubleExtensions on double {
  /// Rounds to [decimalPlaces] decimal places.
  ///
  /// Example:
  /// ```dart
  /// 3.14159.roundTo(2) // 3.14
  /// 3.14159.roundTo(3) // 3.142
  /// ```
  double roundTo(int decimalPlaces) {
    final mod = _pow10(decimalPlaces);
    return (this * mod).round() / mod;
  }

  /// Floors to [decimalPlaces] decimal places.
  double floorTo(int decimalPlaces) {
    final mod = _pow10(decimalPlaces);
    return (this * mod).floor() / mod;
  }

  /// Ceils to [decimalPlaces] decimal places.
  double ceilTo(int decimalPlaces) {
    final mod = _pow10(decimalPlaces);
    return (this * mod).ceil() / mod;
  }

  static double _pow10(int exponent) {
    var result = 1.0;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }

  /// Returns the integer part as int.
  int get integerPart => truncate();

  /// Returns the decimal part.
  double get decimalPart => this - truncate();

  /// Returns `true` if this is approximately equal to [other].
  bool approximatelyEquals(double other, {double epsilon = 0.0001}) {
    return (this - other).abs() < epsilon;
  }
}

/// Extensions on nullable [num].
extension NullableNumExtensions on num? {
  /// Returns the value or 0 if null.
  num get orZero => this ?? 0;

  /// Returns `true` if null or zero.
  bool get isNullOrZero => this == null || this == 0;

  /// Returns `true` if not null and positive.
  bool get isNotNullAndPositive => this != null && this! > 0;
}
