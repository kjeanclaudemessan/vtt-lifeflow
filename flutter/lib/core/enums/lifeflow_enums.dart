/// LifeFlow-specific enums.
///
/// Shared enums used across features in Phase 1.

/// Time slot for grouping habits in TodayView.
enum TimeSlot {
  /// Morning habits (before 12:00).
  morning,

  /// Afternoon habits (12:00–18:00).
  afternoon,

  /// Evening habits (after 18:00).
  evening,

  /// Habits without a specific time range.
  anytime;

  /// Determines the [TimeSlot] from an hour (0–23).
  ///
  /// Returns [anytime] if [hour] is null.
  static TimeSlot fromHour(int? hour) {
    if (hour == null) return TimeSlot.anytime;
    if (hour < 12) return TimeSlot.morning;
    if (hour < 18) return TimeSlot.afternoon;
    return TimeSlot.evening;
  }

  /// Human-readable label for this slot (used as section header).
  String get label => switch (this) {
        TimeSlot.morning => 'Matin',
        TimeSlot.afternoon => 'Après-midi',
        TimeSlot.evening => 'Soir',
        TimeSlot.anytime => 'Sans horaire',
      };

  /// Sort weight for ordering sections.
  int get sortWeight => switch (this) {
        TimeSlot.morning => 0,
        TimeSlot.afternoon => 1,
        TimeSlot.evening => 2,
        TimeSlot.anytime => 3,
      };
}

/// The contextual mode of TodayView based on current hour.
enum TodayMode {
  /// Morning mode (5h–12h): greeting, habits by slot, mini counter.
  morning,

  /// Progress mode (12h–18h): X/Y done, progress bar, remaining habits.
  progress,

  /// Bilan mode (18h–5h): day summary, time per domain today.
  bilan;

  /// Determines the [TodayMode] from the current hour (0–23).
  static TodayMode fromHour(int hour) {
    if (hour >= 5 && hour < 12) return TodayMode.morning;
    if (hour >= 12 && hour < 18) return TodayMode.progress;
    return TodayMode.bilan;
  }
}

/// The type of a habit.
enum HabitType {
  /// A binary habit — either done or not done.
  binary,

  /// A quantitative habit — tracked with a numeric value toward a target.
  quantitative;

  /// Creates a [HabitType] from a string value.
  static HabitType fromString(String? value) {
    return switch (value) {
      'quantitative' => HabitType.quantitative,
      _ => HabitType.binary,
    };
  }

  /// Converts this type to a string for storage.
  String toValue() => name;
}

/// How often a habit should be tracked.
enum HabitFrequency {
  /// Every day.
  daily,

  /// Specific days of the week.
  weekly,

  /// Custom schedule.
  custom;

  /// Creates a [HabitFrequency] from a string value.
  static HabitFrequency fromString(String? value) {
    return switch (value) {
      'weekly' => HabitFrequency.weekly,
      'custom' => HabitFrequency.custom,
      _ => HabitFrequency.daily,
    };
  }

  /// Converts this frequency to a string for storage.
  String toValue() => name;
}

/// Priority level of a task.
enum TaskPriority {
  /// Low priority.
  low,

  /// Medium priority.
  medium,

  /// High priority.
  high;

  /// Creates a [TaskPriority] from a string value.
  static TaskPriority fromString(String? value) {
    return switch (value) {
      'medium' => TaskPriority.medium,
      'high' => TaskPriority.high,
      _ => TaskPriority.low,
    };
  }

  /// Converts this priority to a string for storage.
  String toValue() => name;

  /// Sort weight (higher = more important).
  int get sortWeight => switch (this) {
        TaskPriority.high => 3,
        TaskPriority.medium => 2,
        TaskPriority.low => 1,
      };
}

/// Status of an inbox item.
enum InboxItemStatus {
  /// Not yet triaged.
  pending,

  /// Triaged into a task or habit.
  processed,

  /// Discarded by the user.
  discarded;

  /// Creates an [InboxItemStatus] from a string value.
  static InboxItemStatus fromString(String? value) {
    return switch (value) {
      'processed' => InboxItemStatus.processed,
      'discarded' => InboxItemStatus.discarded,
      _ => InboxItemStatus.pending,
    };
  }

  /// Converts this status to a string for storage.
  String toValue() => name;
}

/// Status of a routine execution log.
enum RoutineLogStatus {
  /// Routine was completed fully.
  completed,

  /// Routine was abandoned before completion.
  abandoned;

  /// Creates a [RoutineLogStatus] from a string value.
  static RoutineLogStatus fromString(String? value) {
    return switch (value) {
      'abandoned' => RoutineLogStatus.abandoned,
      _ => RoutineLogStatus.completed,
    };
  }

  /// Converts this status to a string for storage.
  String toValue() => name;
}
