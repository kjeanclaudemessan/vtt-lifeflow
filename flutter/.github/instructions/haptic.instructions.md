```instructions
---
applyTo: "**/*_viewmodel.dart"
---
# Haptic Feedback Instructions

> These instructions apply to all ViewModel files.
> Ensures proper haptic feedback on user interactions.

---

## Core Rule

**Every meaningful user action MUST trigger appropriate haptic feedback.**
Haptic feedback is triggered from ViewModels, never from Views.

---

## Import

```dart
import 'package:flutter/services.dart';  // For HapticFeedback
```

---

## Haptic Feedback Map

| User Action | Feedback Type | Method |
|---|---|---|
| **Success** (habit checked, form saved, goal reached) | Medium impact | `HapticFeedback.mediumImpact()` |
| **Selection** (tab change, filter pick, option select) | Selection click | `HapticFeedback.selectionClick()` |
| **Toggle** (switch, checkbox, radio) | Light impact | `HapticFeedback.lightImpact()` |
| **Error** (validation fail, network error) | Heavy impact | `HapticFeedback.heavyImpact()` |
| **Milestone** (100% daily, streak record) | Heavy impact | `HapticFeedback.heavyImpact()` |
| **Destructive** (delete, archive) | Medium impact | `HapticFeedback.mediumImpact()` |
| **Long press detected** | Selection click | `HapticFeedback.selectionClick()` |
| **Swipe action triggered** | Light impact | `HapticFeedback.lightImpact()` |

---

## Patterns

### Success Action

```dart
Future<void> toggleHabit(String habitId) async {
  final result = await _habitRepository.toggle(habitId);
  result.fold(
    (failure) {
      HapticFeedback.heavyImpact();  // Error feedback
      setError(failure);
    },
    (success) {
      HapticFeedback.mediumImpact();  // Success feedback
      _checkDailyCompletion();  // May trigger milestone haptic
      rebuildUi();
    },
  );
}
```

### Milestone Detection

```dart
void _checkDailyCompletion() {
  if (_completionPercentage >= 1.0 && !_milestoneTriggered) {
    _milestoneTriggered = true;
    HapticFeedback.heavyImpact();
    // Show celebration overlay
  }
}
```

### Selection / Filter

```dart
void setFilter(HabitDomain domain) {
  HapticFeedback.selectionClick();
  _activeFilter = domain;
  rebuildUi();
}
```

### Form Validation Error

```dart
Future<void> save() async {
  if (!_validate()) {
    HapticFeedback.heavyImpact();
    rebuildUi();
    return;
  }

  final result = await runBusyFuture(_repository.save(_formData));
  result.fold(
    (failure) {
      HapticFeedback.heavyImpact();
      setError(failure);
    },
    (success) {
      HapticFeedback.mediumImpact();
      _navigationService.back();
    },
  );
}
```

### Toggle

```dart
void toggleNotifications(bool value) {
  HapticFeedback.lightImpact();
  _notificationsEnabled = value;
  rebuildUi();
}
```

---

## When NOT to Use Haptic Feedback

```dart
// ❌ Don't add haptic on passive events
void onDataLoaded(List<Habit> habits) {
  // No haptic — user didn't trigger this
  _habits = habits;
  rebuildUi();
}

// ❌ Don't add haptic on navigation (system handles it)
void goToDetail(String id) {
  _navigationService.navigateTo(Routes.detail, arguments: id);
  // No haptic — navigation provides its own feedback
}

// ❌ Don't add haptic on every keystroke
void setEmail(String value) {
  _email = value;
  // No haptic — too frequent
  rebuildUi();
}

// ❌ Don't double-trigger (animation + haptic is fine, but not haptic + haptic)
```

---

## ViewModels That MUST Have Haptic Feedback

| ViewModel | Actions | Feedback |
|---|---|---|
| `HabitsViewModel` | `toggleHabit()`, `archiveHabit()` | medium, medium |
| `TodayViewModel` | `toggleHabit()`, `setMode()` | medium, selection |
| `CounterViewModel` | `incrementHabit()` | light |
| `HabitFormViewModel` | `save()` success/error | medium, heavy |
| `ProfileViewModel` | `pickAvatar()`, `exportData()` | selection, medium |
| `SettingsViewModel` | all toggles, `setTheme()`, `setLanguage()` | light, selection |
| `NotificationsViewModel` | `markAsRead()`, `dismissAll()` | light, medium |
```
