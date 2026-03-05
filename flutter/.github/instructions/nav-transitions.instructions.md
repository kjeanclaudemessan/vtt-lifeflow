---
applyTo: "**/*_viewmodel.dart,**/app.dart"
---

# Navigation Transitions — Mandatory Patterns

> Navigation between views MUST use intentional transitions, not just platform defaults.
> Transitions communicate hierarchy: push = forward, pop = back, modal = overlay.

---

## Transition Types

| Navigation Type | Transition | Duration | Use Case |
|---|---|---|---|
| **Push (forward)** | Slide right-to-left + fade | 300ms | Detail view, sub-screen |
| **Pop (back)** | Slide left-to-right + fade | 250ms | Return to parent (default) |
| **Modal (overlay)** | Slide bottom-to-top | 350ms | Forms, pickers, sheets |
| **Replace (swap)** | Cross-fade | 250ms | Auth → Home, onboarding → main |
| **Tab switch** | Fade | 200ms | Bottom nav tabs |

---

## Implementation with Stacked

### Custom Route Transitions in `app.dart`

```dart
// ✅ CORRECT — define transitions per route
@StackedApp(
  routes: [
    MaterialRoute(page: HomeView, initial: true),
    // Forward navigation — slide
    CustomRoute(
      page: HabitDetailView,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 300,
    ),
    // Modal — bottom slide
    CustomRoute(
      page: HabitFormView,
      transitionsBuilder: TransitionsBuilders.slideBottom,
      durationInMilliseconds: 350,
    ),
    // Replace — cross-fade
    CustomRoute(
      page: HomeView,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 250,
    ),
  ],
)
```

### ViewModel Navigation

```dart
// ✅ CORRECT — use Stacked NavigationService
Future<void> goToDetail(String id) async {
  await _navigationService.navigateToHabitDetailView(id: id);
}

// ✅ CORRECT — replace for auth flow
Future<void> onLoginSuccess() async {
  await _navigationService.clearStackAndShow(Routes.homeView);
}
```

---

## Bottom Sheet & Dialog Transitions

```dart
// ✅ CORRECT — sheets use built-in spring animation
await showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  transitionAnimationController: AnimationController(
    vsync: navigator,
    duration: const Duration(milliseconds: 350),
  ),
  builder: (context) => const MySheet(),
);
```

---

## Rules

1. **Never use `Navigator.push` directly** — always go through `NavigationService`
2. **Modal views slide from bottom** — forms, pickers, creation screens
3. **Detail views slide from right** — drill-down navigation
4. **Auth transitions cross-fade** — no directional implication
5. **Back always has a slightly shorter duration** than forward (250ms vs 300ms)
6. **Hero animations** where the same element appears on both screens

---

## Hero Animation Pattern

```dart
// ✅ CORRECT — on source screen
Hero(
  tag: 'habit-$id',
  child: AppAvatar(name: habit.name, color: habit.color),
)

// ✅ CORRECT — on destination screen
Hero(
  tag: 'habit-$id',
  child: AppAvatar(name: habit.name, color: habit.color, size: 64),
)
```

---

## Self-Check

```bash
# Find raw Navigator.push usage (should use NavigationService)
grep -rn "Navigator.push\|Navigator.of" lib/features/ lib/modules/
```
