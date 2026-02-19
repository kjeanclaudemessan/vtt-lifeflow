import 'dart:async';

/// A utility class for debouncing function calls.
///
/// Useful for search inputs, button clicks, and other scenarios
/// where you want to limit the rate of function execution.
///
/// Example:
/// ```dart
/// final debouncer = Debouncer(milliseconds: 500);
///
/// void onSearchChanged(String query) {
///   debouncer.run(() => searchApi(query));
/// }
///
/// // Don't forget to dispose
/// @override
/// void dispose() {
///   debouncer.dispose();
/// }
/// ```
class Debouncer {
  /// Creates a debouncer with the specified delay.
  Debouncer({
    this.milliseconds = 500,
  });

  /// The delay in milliseconds before executing the action.
  final int milliseconds;

  Timer? _timer;

  /// Schedules [action] to be executed after [milliseconds] delay.
  ///
  /// If called again before the delay expires, the previous
  /// scheduled action is cancelled and a new one is scheduled.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels any pending action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Disposes of the debouncer and cancels any pending action.
  void dispose() {
    cancel();
  }

  /// Returns `true` if there is a pending action.
  bool get isActive => _timer?.isActive ?? false;
}

/// A callback that takes no arguments and returns nothing.
typedef VoidCallback = void Function();

/// A utility class for throttling function calls.
///
/// Unlike debouncing, throttling ensures the function is called
/// at most once per specified interval.
///
/// Example:
/// ```dart
/// final throttler = Throttler(milliseconds: 1000);
///
/// void onScroll() {
///   throttler.run(() => loadMoreItems());
/// }
/// ```
class Throttler {
  /// Creates a throttler with the specified interval.
  Throttler({
    this.milliseconds = 500,
  });

  /// The minimum interval in milliseconds between executions.
  final int milliseconds;

  DateTime? _lastExecutionTime;
  Timer? _timer;
  VoidCallback? _pendingAction;

  /// Executes [action] immediately if the interval has passed,
  /// otherwise schedules it for later.
  void run(VoidCallback action) {
    final now = DateTime.now();

    if (_lastExecutionTime == null ||
        now.difference(_lastExecutionTime!).inMilliseconds >= milliseconds) {
      _executeAction(action);
    } else {
      _pendingAction = action;
      _scheduleNextExecution();
    }
  }

  void _executeAction(VoidCallback action) {
    _lastExecutionTime = DateTime.now();
    action();
  }

  void _scheduleNextExecution() {
    if (_timer?.isActive ?? false) return;

    final timeSinceLastExecution =
        DateTime.now().difference(_lastExecutionTime!).inMilliseconds;
    final delay = milliseconds - timeSinceLastExecution;

    _timer = Timer(Duration(milliseconds: delay), () {
      if (_pendingAction != null) {
        _executeAction(_pendingAction!);
        _pendingAction = null;
      }
    });
  }

  /// Cancels any pending action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _pendingAction = null;
  }

  /// Disposes of the throttler and cancels any pending action.
  void dispose() {
    cancel();
    _lastExecutionTime = null;
  }

  /// Returns `true` if there is a pending action.
  bool get hasPending => _pendingAction != null;
}

/// Extension to create debounced functions easily.
extension DebouncedFunction on Function {
  /// Creates a debounced version of this function.
  ///
  /// Example:
  /// ```dart
  /// final debouncedSearch = search.debounced(500);
  /// debouncedSearch('query'); // Will only execute after 500ms of inactivity
  /// ```
  void Function(T) debounced<T>(int milliseconds) {
    final debouncer = Debouncer(milliseconds: milliseconds);
    return (T arg) => debouncer.run(() => this(arg));
  }
}
