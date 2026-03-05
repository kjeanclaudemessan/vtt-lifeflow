/// Lightweight event bus for habit data changes.
///
/// When any habit is created, updated, archived, or toggled,
/// call [notifyHabitChanged] to inform all listening viewmodels.
///
/// Consumers subscribe via [addListener] / [removeListener]
/// and typically reload their data from Supabase in the callback.
///
/// Registered as a [LazySingleton] in the locator.
class HabitEventService {
  final List<void Function()> _listeners = [];

  /// Subscribes to habit data changes.
  void addListener(void Function() callback) => _listeners.add(callback);

  /// Unsubscribes from habit data changes.
  void removeListener(void Function() callback) => _listeners.remove(callback);

  /// Notifies all listeners that habit data has changed.
  ///
  /// Called from [HabitFormViewModel] on create/update,
  /// [HabitsViewModel] on archive, and toggle methods.
  void notifyHabitChanged() {
    // Iterate on a copy to avoid concurrent modification
    for (final listener in List.of(_listeners)) {
      listener();
    }
  }
}
