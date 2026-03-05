import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wrapper adding long-press gesture with optional haptic feedback.
///
/// Centralizes the GestureDetector + HapticFeedback pattern used
/// for contextual menus, quick actions, drag start, etc.
///
/// Reusable for: habit quick actions, task context menu,
/// inbox long-press, OKR re-ordering, etc.
///
/// Usage:
/// ```dart
/// AppLongPressWrapper(
///   onLongPress: () => showQuickActions(context, item),
///   child: MyListTile(...),
/// )
/// ```
class AppLongPressWrapper extends StatelessWidget {
  /// Called on long-press after haptic feedback.
  final VoidCallback onLongPress;

  /// Child widget receiving the gesture.
  final Widget child;

  /// Whether to trigger haptic feedback on long-press.
  /// Defaults to `true`.
  final bool enableHaptic;

  /// Type of haptic feedback.
  /// Defaults to [HapticFeedbackType.medium].
  final HapticFeedbackType hapticType;

  /// Optional tap callback (for forwarding taps).
  final VoidCallback? onTap;

  /// Hit test behavior. Defaults to [HitTestBehavior.opaque].
  final HitTestBehavior behavior;

  const AppLongPressWrapper({
    super.key,
    required this.onLongPress,
    required this.child,
    this.enableHaptic = true,
    this.hapticType = HapticFeedbackType.medium,
    this.onTap,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: onTap,
      onLongPress: () {
        if (enableHaptic) {
          switch (hapticType) {
            case HapticFeedbackType.light:
              HapticFeedback.lightImpact();
            case HapticFeedbackType.medium:
              HapticFeedback.mediumImpact();
            case HapticFeedbackType.heavy:
              HapticFeedback.heavyImpact();
            case HapticFeedbackType.selection:
              HapticFeedback.selectionClick();
          }
        }
        onLongPress();
      },
      child: child,
    );
  }
}

/// Haptic feedback intensity levels.
enum HapticFeedbackType {
  /// Light impact — subtle confirmation.
  light,

  /// Medium impact — standard contextual action.
  medium,

  /// Heavy impact — important/destructive action.
  heavy,

  /// Selection click — toggle/select.
  selection,
}
