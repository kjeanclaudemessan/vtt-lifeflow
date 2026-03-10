```instructions
---
applyTo: "**/*_view.dart"
---
# Design System — Motion & Animation

> Every visible state change MUST be animated.
> Use `AppAnimations` tokens exclusively — zero raw `Duration` or `Curves`.
> Animations serve clarity, not decoration.

---

## Principles

1. **Functional first** — animations guide attention and communicate state changes.
2. **Subtle by default** — no gratuitous bouncing, shaking, or flashing.
3. **Respect user preferences** — honor `MediaQuery.disableAnimations`.
4. **Performance budget** — 60fps minimum. Disable heavy effects on low-end devices.

---

## Duration Scale

| Token | Value | When |
|-------|-------|------|
| `AppAnimations.instant` | 0ms | No noticeable delay |
| `AppAnimations.extraFast` | 100ms | Micro-feedback (ripple, opacity) |
| `AppAnimations.fast` | 150ms | Button press, toggle |
| `AppAnimations.normal` | 200ms | Default transitions, fade |
| `AppAnimations.medium` | 300ms | Page transitions, content switch |
| `AppAnimations.slow` | 400ms | Complex entrances, slide-in |
| `AppAnimations.extraSlow` | 500ms | Celebration, emphasis |

---

## Curve Scale

| Token | Curve | When |
|-------|-------|------|
| `AppAnimations.defaultCurve` | `easeInOut` | General purpose |
| `AppAnimations.easeOut` | `easeOut` | Element entering screen |
| `AppAnimations.easeIn` | `easeIn` | Element leaving screen |
| `AppAnimations.easeOutCubic` | `easeOutCubic` | Page transitions |
| `AppAnimations.spring` | `elasticOut` | Success, celebration |
| `AppAnimations.decelerate` | `decelerate` | Smooth stopping |

---

## Required Patterns

### 1. Content Switch → AnimatedSwitcher

Every `if/else` or ternary that swaps visible content:

```dart
// ✅ REQUIRED
AnimatedSwitcher(
  duration: AppAnimations.medium,
  switchInCurve: AppAnimations.easeOut,
  switchOutCurve: AppAnimations.easeIn,
  child: KeyedSubtree(
    key: ValueKey(viewModel.currentTab),
    child: _buildTabContent(viewModel.currentTab),
  ),
)

// ❌ FORBIDDEN — instant swap
viewModel.showA ? WidgetA() : WidgetB()
```

### 2. Toggle / Check → AnimatedScale

Binary state changes (checkbox, habit completion):

```dart
AnimatedScale(
  scale: isChecked ? 1.0 : 0.0,
  duration: AppAnimations.fast,
  curve: AppAnimations.spring,
  child: Icon(LucideIcons.check, color: AppColors.success),
)
```

### 3. Progress / Counter → TweenAnimationBuilder

Numeric values that change (percentages, counts, scores):

```dart
TweenAnimationBuilder<double>(
  tween: Tween(begin: _oldValue, end: viewModel.progress),
  duration: AppAnimations.medium,
  curve: AppAnimations.decelerate,
  builder: (context, value, _) => Text(
    '${(value * 100).toInt()}%',
    style: AppTypography.headingLarge,
  ),
)
```

### 4. List Stagger → Delay per item

Items appearing sequentially:

```dart
// 50ms delay between each item, top-to-bottom
AnimatedBuilder(
  delay: Duration(milliseconds: 50 * index),
  child: FadeTransition(
    opacity: animation,
    child: SlideTransition(
      position: Tween(begin: Offset(0, 0.1), end: Offset.zero).animate(animation),
      child: listItem,
    ),
  ),
)
```

- **Delay**: 50ms per item.
- **Direction**: Top → bottom (fade + slight slide up).
- **Max stagger**: First 10 items only (don't delay items 50+).

### 5. Skeleton Loading → Shimmer

```dart
AppSkeleton(
  // Shimmer: left-to-right sweep, 1.5s cycle
  // Color: surface + 10% lighter
  // Shapes match actual content layout
)
```

### 6. Pull-to-Refresh → Standard Material

```dart
RefreshIndicator(
  onRefresh: viewModel.refresh,
  color: context.colorScheme.primary,
  backgroundColor: context.colorScheme.surface,
  child: listView,
)
```

### 7. Scroll Effects → SliverAppBar

```dart
// Collapsing header on scroll
SliverAppBar(
  expandedHeight: 200,
  floating: false,
  pinned: true,
  flexibleSpace: FlexibleSpaceBar(
    collapseMode: CollapseMode.parallax,
    // content...
  ),
)
```

---

## Micro-Interactions

### Button Press

```dart
// Scale to 0.95 on press, duration: fast
AnimatedScale(
  scale: isPressed ? 0.95 : 1.0,
  duration: AppAnimations.fast,
  curve: AppAnimations.easeOut,
  child: button,
)
```

### Toggle Switch

- Switch: standard Material/Cupertino animation (built-in).
- Haptic: `lightImpact()` from ViewModel on change.

### Checkbox Bounce

- AnimatedScale with `spring` curve on check.
- Scale 0→1.0 on check, 1.0→0 on uncheck.

---

## Page Transitions

| Type | From/To | Transition | Duration |
|------|---------|------------|----------|
| Push | List → Detail | Slide from right | `medium` |
| Modal | Any → Creation form | Slide from bottom | `medium` |
| Replace | Splash → Home | Cross-fade | `medium` |
| Back | Detail → List | Reverse slide | `medium` |
| Hero | Shared element | Hero animation | `medium` |

```dart
// ✅ Hero animation for shared elements
Hero(
  tag: 'habit-${habit.id}',
  child: AppCard(child: habitContent),
)
```

---

## Reduce Motion

```dart
// ✅ REQUIRED — respect system accessibility setting
final reduceMotion = MediaQuery.of(context).disableAnimations;

AnimatedSwitcher(
  duration: reduceMotion ? Duration.zero : AppAnimations.medium,
  child: content,
)
```

---

## Performance Rules

1. **No `Opacity` widget** for fading — use `FadeTransition` (GPU-accelerated).
2. **No `Transform` with repaint boundary breaks** — use `AnimatedBuilder`.
3. **Disable complex effects** (blur, glassmorphism, heavy shadows) on devices with < 3GB RAM.
4. **Skeleton shimmer budget**: max 5 skeleton items visible at once.
5. **List animations**: only first 10 visible items get staggered entrance.
```
