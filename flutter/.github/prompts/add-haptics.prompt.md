```prompt
# Add Haptic Feedback to a ViewModel

Add appropriate haptic feedback to all meaningful user actions in a ViewModel.

## Target

- **ViewModel File**: ${{input:Path to the ViewModel file (e.g., lib/features/habits/viewmodels/habits_viewmodel.dart)}}

## Instructions

### Step 1: Add Import

```dart
import 'package:flutter/services.dart';
```

### Step 2: Identify Actions

Read the ViewModel and categorize every public method by action type:

| Action Type | HapticFeedback Method |
|---|---|
| Success (save, complete, create) | `HapticFeedback.mediumImpact()` |
| Selection (filter, tab, picker) | `HapticFeedback.selectionClick()` |
| Toggle (switch, checkbox) | `HapticFeedback.lightImpact()` |
| Error (validation fail, API error) | `HapticFeedback.heavyImpact()` |
| Milestone (100%, streak) | `HapticFeedback.heavyImpact()` |
| Destructive (delete, archive) | `HapticFeedback.mediumImpact()` |

### Step 3: Apply Pattern

For Either-based results:
```dart
result.fold(
  (failure) {
    HapticFeedback.heavyImpact();
    setError(failure);
  },
  (success) {
    HapticFeedback.mediumImpact();
    // handle success
    rebuildUi();
  },
);
```

For simple toggles:
```dart
void toggleSomething() {
  HapticFeedback.lightImpact();
  _flag = !_flag;
  rebuildUi();
}
```

For selections:
```dart
void selectFilter(FilterType filter) {
  HapticFeedback.selectionClick();
  _activeFilter = filter;
  rebuildUi();
}
```

### Step 4: Skip These Methods

Do NOT add haptic to:
- `init()`, `dispose()` — lifecycle methods
- Private `_loadData()` methods — not user-triggered
- `rebuildUi()` calls alone
- Setter methods called on every keystroke (`setEmail`, `setPassword`)
- Navigation methods — system provides feedback
- Passive data callbacks (`onDataLoaded`, listener callbacks)

### Step 5: Verify

- Every public action method has appropriate haptic
- No haptic on passive/automatic actions
- Error paths have `heavyImpact`
- Success paths have `mediumImpact`
- No duplicate haptic triggers (e.g., don't fire haptic in both `toggleHabit()` and the event listener callback)
```
