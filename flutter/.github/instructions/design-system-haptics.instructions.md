```instructions
---
applyTo: "**/*_viewmodel.dart"
---
# Design System — Haptic Feedback & Sounds

> Haptic feedback is triggered from ViewModels, NEVER from Views.
> Every meaningful user action MUST trigger appropriate haptic.
> Sounds are OFF by default. Toggle in Settings > Preferences.

---

## Haptic Feedback Map

| User Action | Feedback Type | Method |
|---|---|---|
| **Success** (save, complete, confirm) | Medium impact | `HapticFeedback.mediumImpact()` |
| **Selection** (tab, filter, picker, option) | Selection click | `HapticFeedback.selectionClick()` |
| **Toggle** (switch, checkbox, radio) | Light impact | `HapticFeedback.lightImpact()` |
| **Error** (validation fail, network error) | Heavy impact | `HapticFeedback.heavyImpact()` |
| **Milestone** (streak, 100% daily, goal) | Heavy impact | `HapticFeedback.heavyImpact()` |
| **Destructive** (delete, archive) | Medium impact | `HapticFeedback.mediumImpact()` |
| **Long press detected** | Selection click | `HapticFeedback.selectionClick()` |
| **Swipe action triggered** | Light impact | `HapticFeedback.lightImpact()` |
| **Pull-to-refresh triggered** | Light impact | `HapticFeedback.lightImpact()` |

---

## Import

```dart
import 'package:flutter/services.dart'; // For HapticFeedback
```

---

## Patterns

### Success Action

```dart
Future<void> saveHabit() async {
  final result = await runBusyFuture(
    _habitRepository.save(_formData),
    busyObject: saveBusyKey,
  );
  result.fold(
    (failure) {
      HapticFeedback.heavyImpact(); // Error feedback
      setError(failure);
    },
    (success) {
      HapticFeedback.mediumImpact(); // Success feedback
      _navigationService.back();
    },
  );
}
```

### Toggle

```dart
void toggleDarkMode(bool value) {
  HapticFeedback.lightImpact();
  _themeService.setDarkMode(value);
  rebuildUi();
}
```

### Selection

```dart
void setFilter(HabitCategory category) {
  HapticFeedback.selectionClick();
  _activeFilter = category;
  rebuildUi();
}
```

### Milestone

```dart
void _checkDailyCompletion() {
  if (_completionPercentage >= 1.0 && !_milestoneTriggered) {
    _milestoneTriggered = true;
    HapticFeedback.heavyImpact();
    // Trigger celebration overlay
  }
}
```

### Destructive

```dart
Future<void> deleteHabit(String id) async {
  final confirmed = await _dialogHelper.showDestructiveConfirmation(...);
  if (!confirmed) return;
  
  HapticFeedback.mediumImpact();
  await _habitRepository.delete(id);
}
```

---

## Sounds

### Policy

- **Sounds are OFF by default.**
- User enables in **Settings > Preferences > Sounds**.
- When enabled, sounds complement haptics — they don't replace them.

### Sound Map (when enabled)

| Action | Sound | Duration |
|--------|-------|----------|
| Success (save, complete) | Soft chime | ~200ms |
| Milestone (streak, goal) | Celebration chime | ~500ms |
| Error | Subtle buzz/thud | ~150ms |
| Toggle on | Click | ~100ms |

### Implementation

```dart
// Check sound preference before playing
if (_settingsService.soundsEnabled) {
  await _audioService.playSuccess();
}
```

### Rules

- **No autoplay audio** ever.
- **No sound on page transitions** — only on user-initiated actions.
- **Respect device silent mode** — check `RingerMode` before playing.
- **Sound files**: < 50KB each, stored in `assets/sounds/`.

---

## Global Mute Toggle

```dart
// Settings > Preferences
// Toggle: "Haptics & Sounds"
// When OFF: all HapticFeedback calls are skipped, all sounds muted

// Wrap haptic calls with preference check
void _haptic(void Function() feedback) {
  if (_settingsService.hapticsEnabled) {
    feedback();
  }
}

// Usage
_haptic(() => HapticFeedback.mediumImpact());
```

---

## Platform Differences

| Platform | Engine | Behavior |
|----------|--------|----------|
| **iOS** | Taptic Engine | Precise, distinct levels (light/medium/heavy/selection) |
| **Android** | Vibration motor | Less precise, especially on budget devices |

- Always use `HapticFeedback` class (Flutter abstracts platform differences).
- Test on real devices — emulators don't simulate haptics.

---

## Self-Check

Before submitting a ViewModel:
- [ ] Every public method that represents a user action has haptic feedback.
- [ ] Success → `mediumImpact`, Error → `heavyImpact`.
- [ ] Selection → `selectionClick`, Toggle → `lightImpact`.
- [ ] Milestone detection triggers `heavyImpact`.
- [ ] No haptic calls in View files (all in ViewModel).
```
