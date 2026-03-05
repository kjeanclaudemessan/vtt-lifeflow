```prompt
# Add Accessibility to a View/Widget

Add Semantics, semantic labels, and accessibility support to an existing view or widget.

## Target

- **File**: ${{input:Path to the view or widget file (e.g., lib/features/habits/widgets/habit_check_tile.dart)}}

## Instructions

### Step 1: Audit Current State

Read the file and identify:
1. **Icons** without `semanticLabel`
2. **GestureDetector / InkWell** without `Semantics` wrapper
3. **Images** without `semanticLabel`
4. **Progress indicators** without semantic value
5. **Custom interactive widgets** without semantic annotation
6. **Decorative elements** that should be excluded
7. **Touch targets** smaller than 48x48 dp

### Step 2: Add Icon Labels

```dart
// Before
Icon(Icons.check, size: AppSizing.iconMd)

// After
Icon(Icons.check, size: AppSizing.iconMd, semanticLabel: context.l10n.completed)
```

### Step 3: Wrap Interactive Elements

```dart
// Before
GestureDetector(
  onTap: onToggle,
  child: _buildCheckArea(),
)

// After
Semantics(
  label: '${context.l10n.toggleHabit}: ${habit.name}',
  hint: context.l10n.doubleTapToToggle,
  toggled: habit.isCompleted,
  child: GestureDetector(
    onTap: onToggle,
    child: _buildCheckArea(),
  ),
)
```

### Step 4: Add Progress Semantics

```dart
// Before
CircularProgressIndicator(value: progress)

// After
Semantics(
  label: '${context.l10n.progress}: ${(progress * 100).toInt()}%',
  value: '${(progress * 100).toInt()}%',
  child: CircularProgressIndicator(value: progress),
)
```

### Step 5: Exclude Decorative Elements

```dart
// Decorative icons, dividers, background images
ExcludeSemantics(
  child: Icon(Icons.circle, size: 8, color: AppColors.primary),
)
```

### Step 6: Group Card Content

```dart
// Merge related content into one semantic node
MergeSemantics(
  child: Card(
    child: Column(
      children: [
        Text(habit.name),
        Text('${habit.streak} day streak'),
      ],
    ),
  ),
)
```

### Step 7: Verify Touch Targets

Ensure all tappable elements are at least 48x48:

```dart
// If too small, wrap in SizedBox
SizedBox(
  width: AppSizing.touchTarget,
  height: AppSizing.touchTarget,
  child: Center(child: smallWidget),
)
```

### Step 8: Add State Announcements

For dynamic changes (habit completed, data loaded):

```dart
import 'package:flutter/semantics.dart';

SemanticsService.announce(
  context.l10n.habitMarkedComplete(habitName),
  TextDirection.ltr,
);
```

## Verification Checklist

- [ ] All `Icon` have `semanticLabel`
- [ ] All tappable areas wrapped in `Semantics`
- [ ] All informative images have `semanticLabel`
- [ ] Decorative elements have `ExcludeSemantics`
- [ ] Progress indicators have semantic `value`
- [ ] Touch targets ≥ 48x48 dp
- [ ] Related card content merged with `MergeSemantics`
- [ ] i18n strings used for all labels (not hardcoded)
```
