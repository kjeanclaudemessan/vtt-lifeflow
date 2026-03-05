```instructions
---
applyTo: "**/*_view.dart"
---
# Animation Instructions

> These instructions apply to all View files.
> Ensures proper use of animations and micro-interactions.

---

## Core Rule

**Every state change visible to the user MUST be animated.**
Use `AppAnimations` tokens for durations and curves. No raw `Duration` or `Curves` in views.

---

## Required Animation Patterns

### 1. Content Switching — AnimatedSwitcher

When a view displays different content based on state (tabs, modes, filters):

```dart
// ✅ REQUIRED — animate content transitions
AnimatedSwitcher(
  duration: AppAnimations.normal,  // 300ms
  switchInCurve: AppAnimations.emphasizedDecelerate,
  switchOutCurve: AppAnimations.emphasizedAccelerate,
  transitionBuilder: AppAnimations.fadeScale,  // or AppAnimations.fadeSlideUp
  child: KeyedSubtree(
    key: ValueKey(viewModel.currentMode),
    child: _buildContentForMode(viewModel.currentMode),
  ),
)

// ❌ FORBIDDEN — instant swap
viewModel.currentMode == Mode.a
    ? _buildModeA()
    : _buildModeB()
```

### 2. List Changes — AnimatedList or AnimatedSwitcher

When items are added, removed, or filtered:

```dart
// ✅ REQUIRED — animate list transitions
AnimatedSwitcher(
  duration: AppAnimations.normal,
  child: KeyedSubtree(
    key: ValueKey(viewModel.activeFilter),
    child: ListView.builder(
      itemCount: viewModel.filteredItems.length,
      itemBuilder: (context, index) => _buildItem(viewModel.filteredItems[index]),
    ),
  ),
)
```

### 3. Success Checkmark — AnimatedScale

When a binary action completes (habit checked, task done):

```dart
// ✅ REQUIRED — bounce animation on check
AnimatedScale(
  scale: isChecked ? 1.0 : 0.0,
  duration: AppAnimations.fast,  // 200ms
  curve: AppAnimations.spring,
  child: Icon(Icons.check, color: AppColors.success),
)
```

### 4. Progress Updates — TweenAnimationBuilder

When numeric values change (counters, progress bars):

```dart
// ✅ REQUIRED — animate counter changes
TweenAnimationBuilder<double>(
  tween: Tween(begin: oldValue, end: newValue),
  duration: AppAnimations.normal,
  curve: AppAnimations.emphasizedDecelerate,
  builder: (context, value, child) {
    return Text(
      '${value.toInt()}%',
      style: AppTypography.headlineLarge,
    );
  },
)
```

### 5. Appearance — FadeTransition or SlideTransition

When widgets appear for the first time (cards, sections):

```dart
// ✅ RECOMMENDED — staggered fade-in for lists
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0.0, end: 1.0),
  duration: Duration(milliseconds: 200 + (index * 50)),
  curve: AppAnimations.emphasizedDecelerate,
  builder: (context, value, child) {
    return Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: child,
      ),
    );
  },
  child: _buildCard(item),
)
```

### 6. Container Changes — AnimatedContainer

When visual properties change (color, size, padding):

```dart
// ✅ REQUIRED — animate property changes
AnimatedContainer(
  duration: AppAnimations.fast,
  curve: AppAnimations.standard,
  decoration: BoxDecoration(
    color: isActive ? AppColors.primary : AppColors.surface(brightness),
    borderRadius: AppRadius.md,
  ),
  padding: isExpanded ? AppSpacing.edgeInsets.lg : AppSpacing.edgeInsets.md,
  child: content,
)
```

---

## AppAnimations Token Reference

Always use these instead of raw values:

| Token | Value | Use Case |
|---|---|---|
| `AppAnimations.fastest` | 100ms | Micro-feedback (opacity, color) |
| `AppAnimations.fast` | 200ms | Quick transitions (check, toggle) |
| `AppAnimations.normal` | 300ms | Standard transitions (content swap) |
| `AppAnimations.slow` | 500ms | Emphasis transitions (modal, page) |
| `AppAnimations.standard` | `Curves.easeInOut` | Default curve |
| `AppAnimations.emphasizedDecelerate` | `Curves.easeOut` | Elements entering |
| `AppAnimations.emphasizedAccelerate` | `Curves.easeIn` | Elements leaving |
| `AppAnimations.spring` | `Curves.elasticOut` | Bouncy feedback |
| `AppAnimations.fadeScale` | Builder function | Fade + scale transition |
| `AppAnimations.fadeSlideUp` | Builder function | Fade + slide up transition |

---

## Views That MUST Have Animations

| View | Required Animation |
|---|---|
| `TodayView` | `AnimatedSwitcher` on mode switching (morning/progress/bilan) |
| `HabitsView` | `AnimatedSwitcher` on domain filter change |
| `CounterView` | `TweenAnimationBuilder` on weekly totals |
| `HabitCheckTile` | `AnimatedScale` on check/uncheck |
| `ProfileView` | `TweenAnimationBuilder` on completion percentage |
| `HabitFormView` | Field error `AnimatedSize` + shake on validation error |
| Any list view | Staggered fade-in on initial load |

---

## Don'ts

```dart
// ❌ Don't use raw Duration
duration: Duration(milliseconds: 300),  // Use AppAnimations.normal

// ❌ Don't use raw Curves
curve: Curves.easeOut,  // Use AppAnimations.emphasizedDecelerate

// ❌ Don't skip animations on state changes
if (isLoading) return LoadingWidget();
return ContentWidget();
// → Wrap in AnimatedSwitcher

// ❌ Don't animate everything at once
// Only animate user-triggered or data-driven changes
```
```
