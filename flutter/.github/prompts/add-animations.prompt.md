```prompt
# Add Animations to a View

Add micro-interactions and transitions to an existing view following the animation guidelines.

## Target

- **View File**: ${{input:Path to the view file (e.g., lib/features/today/views/today_view.dart)}}
- **Animation Focus**: ${{input:What to animate: content-switching, list-items, progress, check-actions, or all}}

## Instructions

### Step 1: Analyze the View

Read the target view and identify:
1. **State-driven content switches** (if/else, switch, ternary that change displayed widgets)
2. **Lists** that load, filter, or change dynamically
3. **Progress indicators** or counters that update
4. **Toggle/check actions** (binary or quantitative)
5. **Loading → content transitions**

### Step 2: Apply Animation Patterns

For each identified opportunity, apply the matching pattern:

#### Content Switching → AnimatedSwitcher
```dart
AnimatedSwitcher(
  duration: AppAnimations.normal,
  switchInCurve: AppAnimations.emphasizedDecelerate,
  switchOutCurve: AppAnimations.emphasizedAccelerate,
  transitionBuilder: AppAnimations.fadeScale,
  child: KeyedSubtree(
    key: ValueKey(currentState),
    child: _buildForState(currentState),
  ),
)
```

#### Check/Toggle → AnimatedScale
```dart
AnimatedScale(
  scale: isChecked ? 1.0 : 0.8,
  duration: AppAnimations.fast,
  curve: AppAnimations.spring,
  child: checkWidget,
)
```

#### Progress → TweenAnimationBuilder
```dart
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: progress),
  duration: AppAnimations.normal,
  curve: AppAnimations.emphasizedDecelerate,
  builder: (context, value, child) => _buildProgress(value),
)
```

#### Container property changes → AnimatedContainer
```dart
AnimatedContainer(
  duration: AppAnimations.fast,
  curve: AppAnimations.standard,
  // ... changing properties
)
```

#### List appearance → Staggered fade-in
```dart
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0.0, end: 1.0),
  duration: Duration(milliseconds: 200 + (index * 50)),
  curve: AppAnimations.emphasizedDecelerate,
  builder: (context, value, child) => Opacity(
    opacity: value,
    child: Transform.translate(
      offset: Offset(0, 20 * (1 - value)),
      child: child,
    ),
  ),
  child: itemWidget,
)
```

### Step 3: Import AppAnimations

Ensure the file imports the animations token:

```dart
import 'package:lifeflow/design_system/design_system.dart';
```

### Step 4: Verify

- No raw `Duration(milliseconds: ...)` — use `AppAnimations` tokens
- No raw `Curves.*` — use `AppAnimations` curves
- `AnimatedSwitcher` children have unique `Key` (via `ValueKey` or `KeyedSubtree`)
- Animations don't conflict (no nested AnimatedSwitcher with same duration)

## Rules

- Don't over-animate — only animate user-triggered or data-driven changes
- Keep durations between 100ms–500ms
- Use `AppAnimations` tokens for ALL durations and curves
- Test with slow animations (`timeDilation = 5.0`) to verify smoothness
```
