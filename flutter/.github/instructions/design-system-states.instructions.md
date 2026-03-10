```instructions
---
applyTo: "**/*_view.dart,**/*_viewmodel.dart"
---
# Design System — Component States & Feedback

> Every component MUST handle all possible states.
> The state machine is: Error → Loading → Empty → Content.
> No user should ever see a blank screen.

---

## Universal State Machine

Every data-driven view follows this priority order:

```dart
@override
Widget builder(BuildContext context, MyViewModel viewModel, Widget? child) {
  // 1. ERROR — highest priority
  if (viewModel.hasError) {
    return AppEmptyState.error(
      title: context.l10n.somethingWentWrong,
      description: context.l10n.tapToRetry,
      onRetry: viewModel.initialise,
    );
  }

  // 2. LOADING (initial) — skeleton, not spinner
  if (viewModel.isBusy && viewModel.data == null) {
    return AppSkeleton.list(itemCount: 5);
  }

  // 3. EMPTY — invitation to act, not dead end
  if (viewModel.data?.isEmpty ?? true) {
    return AppEmptyState(
      illustration: AppIllustrations.emptyList,
      title: context.l10n.noItemsYet,
      description: context.l10n.addFirstItemPrompt,
      ctaLabel: context.l10n.addItem,
      onCtaPressed: viewModel.addItem,
    );
  }

  // 4. CONTENT — the actual data
  return _buildContent(context, viewModel);
}
```

---

## State Definitions

| State | Visual | Trigger |
|-------|--------|---------|
| **Default** | Normal appearance | No user interaction |
| **Pressed** | Scale 0.95 + slight opacity | During tap (GestureDetector) |
| **Focused** | Primary border outline | Keyboard/a11y focus |
| **Disabled** | 40% opacity, no interaction | `onPressed: null` |
| **Loading** | Skeleton shimmer or spinner | `isBusy == true` |
| **Error** | Red border/text + retry action | `hasError == true` |
| **Success** | Green accent + checkmark + haptic | After successful action |

---

## Feedback Patterns

### Tap Feedback

```dart
// ✅ Interactive cards use AnimatedScale
GestureDetector(
  onTapDown: (_) => setState(() => _pressed = true),
  onTapUp: (_) => setState(() => _pressed = false),
  onTapCancel: () => setState(() => _pressed = false),
  onTap: onTap,
  child: AnimatedScale(
    scale: _pressed ? 0.98 : 1.0,
    duration: AppAnimations.fast,
    curve: AppAnimations.easeOut,
    child: card,
  ),
)

// ❌ FORBIDDEN — no visual feedback on tap
GestureDetector(onTap: onTap, child: card)
```

### Loading States

| Context | Pattern | Widget |
|---------|---------|--------|
| **Initial page load** | Skeleton shimmer | `AppSkeleton.list()` |
| **Button action** | Spinner in button | `AppButton(isLoading: true)` |
| **Pull to refresh** | Standard indicator | `RefreshIndicator` |
| **Pagination** | Inline loader at bottom | `AppProgress.circular(size: sm)` |
| **Image loading** | Shimmer placeholder | `AppSkeleton.custom()` → fade to image |

```dart
// ✅ CORRECT — skeleton for initial load
if (viewModel.isBusy && viewModel.habits.isEmpty) {
  return AppSkeleton.list(itemCount: 5);
}

// ❌ FORBIDDEN — bare spinner for initial load
if (viewModel.isBusy) {
  return const Center(child: CircularProgressIndicator());
}
```

### Error States

| Context | Pattern | Widget |
|---------|---------|--------|
| **Full page error** | Illustration + retry | `AppEmptyState.error()` |
| **Action error** | Snackbar | `AppSnackbar.error()` |
| **Field error** | Inline red text | `AppTextField(errorText: ...)` |
| **Network error** | Persistent banner | `MaterialBanner` at top |

```dart
// ✅ CORRECT — human-readable error with retry
AppEmptyState.error(
  title: context.l10n.somethingWentWrong,
  description: context.l10n.checkConnectionAndRetry,
  onRetry: viewModel.loadData,
)

// ❌ FORBIDDEN — technical error message
Text('Error: SocketException: Connection refused')
```

### Empty States

Rules:
- **Always an invitation** to act, never a dead end.
- **Title**: short, positive ("Pas encore d'habitudes").
- **Description**: explains what will appear here.
- **CTA**: action button ("Ajoute ta première habitude").
- **Illustration**: optional, from shared library.

### Offline State

```dart
// Persistent banner at top of screen
if (!viewModel.isOnline) {
  MaterialBanner(
    content: Text(context.l10n.offlineMode),
    leading: Icon(LucideIcons.wifiOff, color: AppColors.warning),
    backgroundColor: AppColors.warning.withOpacity(0.1),
    actions: [
      TextButton(
        onPressed: viewModel.retry,
        child: Text(context.l10n.retry),
      ),
    ],
  )
}
```

---

## Form Validation

### Strategy: Submit-first, then inline

1. **First submit**: validate all fields at once, scroll to first error.
2. **After first error**: validate each field on change (real-time).
3. **Error display**: inline below the field, red text, with icon.

```dart
// ViewModel
String? validateEmail(String value) {
  if (value.isEmpty) return context.l10n.emailRequired;
  if (!RegExp(r'^.+@.+\..+$').hasMatch(value)) return context.l10n.emailInvalid;
  return null;
}

// After first submit attempt, enable real-time validation
bool _hasAttemptedSubmit = false;

void submit() {
  _hasAttemptedSubmit = true;
  if (!_validate()) {
    HapticFeedback.heavyImpact();
    rebuildUi();
    return;
  }
  // proceed...
}
```

---

## Success Feedback

After a successful action:

1. `HapticFeedback.mediumImpact()` (from ViewModel).
2. `AppSnackbar.success(message: context.l10n.saved)` — 3 seconds.
3. Animated checkmark if inline (e.g., habit completion).
4. Navigate back if creation flow.

---

## State Combinations

| Loading? | Error? | Empty? | Show |
|----------|--------|--------|------|
| ✅ first | — | — | Skeleton |
| ✅ refresh | — | — | Content + RefreshIndicator spinning |
| — | ✅ | — | Error + Retry |
| — | — | ✅ | Empty state + CTA |
| — | — | — | Content |
| ✅ action | — | — | Button spinner, content stays |
```
