import 'package:flutter/services.dart';

/// Centralized haptic feedback service.
///
/// Provides semantic methods for consistent haptic feedback across the app.
/// Registered as [LazySingleton] in the locator.
///
/// Usage:
/// ```dart
/// final _haptic = locator<HapticService>();
/// _haptic.success();   // mediumImpact — save, complete, toggle ON
/// _haptic.error();     // heavyImpact — failure, delete confirm
/// _haptic.selection(); // selectionClick — filter, tab, pick
/// _haptic.light();     // lightImpact — toggle, increment, minor action
/// _haptic.warning();   // heavyImpact — destructive preview
/// ```
class HapticService {
  /// Haptic for successful actions (save, complete habit, login).
  void success() => HapticFeedback.mediumImpact();

  /// Haptic for errors and failures.
  void error() => HapticFeedback.heavyImpact();

  /// Haptic for selection changes (filter, tab switch, picker).
  void selection() => HapticFeedback.selectionClick();

  /// Haptic for light interactions (toggle, increment counter).
  void light() => HapticFeedback.lightImpact();

  /// Haptic for destructive action confirmation.
  void warning() => HapticFeedback.heavyImpact();
}
