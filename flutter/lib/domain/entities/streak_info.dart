import 'package:equatable/equatable.dart';

/// Information about a habit's streak.
///
/// Used by streak calculation and badge display.
class StreakInfo extends Equatable {
  /// Current consecutive days count (including freeze days).
  final int currentStreak;

  /// Best streak ever achieved.
  final int bestStreak;

  /// Dates where streak freeze was applied.
  final List<DateTime> freezeUsedDates;

  /// Whether the freeze is currently active (used today or yesterday).
  final bool isFreezeActive;

  const StreakInfo({
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.freezeUsedDates = const [],
    this.isFreezeActive = false,
  });

  /// An empty streak (no history).
  static const empty = StreakInfo();

  @override
  List<Object?> get props =>
      [currentStreak, bestStreak, freezeUsedDates, isFreezeActive];
}
