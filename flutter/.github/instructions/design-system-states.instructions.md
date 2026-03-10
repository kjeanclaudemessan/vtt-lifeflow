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

## Corrupt Data Recovery (28.9)

If JSON is malformed or data is corrupted locally, **never crash**. Show a recoverable state.

```dart
// ✅ CORRECT — graceful corrupt data handling
try {
  final data = MyModel.fromJson(jsonDecode(rawJson));
  return data;
} on FormatException catch (e) {
  // Log to error reporting
  ErrorReportingService.report(e);
  // Clear corrupted cache
  await _cacheService.clear(cacheKey);
  // Return null — triggers empty state, not crash
  return null;
} on TypeError catch (e) {
  ErrorReportingService.report(e);
  await _cacheService.clear(cacheKey);
  return null;
}

// ❌ FORBIDDEN — crash on bad data
final data = MyModel.fromJson(jsonDecode(rawJson)); // unguarded
```

---

## Maintenance Screen (28.10)

When the server returns a maintenance status (HTTP 503 or a feature flag), show a **full-screen blocking** maintenance view.

```
┌──────────────────────────┐
│                          │
│      🔧                  │  ← Maintenance illustration
│                          │
│  Maintenance en cours    │  ← headingMedium
│                          │
│  Nous améliorons l'app   │  ← bodyMd, onSurfaceVariant
│  Reviens dans quelques   │
│  minutes.                │
│                          │
│  [Réessayer]             │  ← Primary button, checks status
│                          │
│  Temps estimé : ~15min   │  ← labelSmall, optional
└──────────────────────────┘
```

```dart
// ✅ CORRECT — maintenance screen
class MaintenanceView extends StatelessWidget {
  final VoidCallback onRetry;
  final String? estimatedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.staticLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/illustrations/maintenance.svg',
                  height: 200, semanticsLabel: context.l10n.maintenance),
              AppGaps.verticalXl,
              Text(context.l10n.maintenanceTitle,
                  style: AppTypography.headingMedium, textAlign: TextAlign.center),
              AppGaps.verticalSm,
              Text(context.l10n.maintenanceDescription,
                  style: AppTypography.bodyMd.copyWith(
                      color: context.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center),
              if (estimatedTime != null) ...[
                AppGaps.verticalMd,
                Text(context.l10n.estimatedTime(estimatedTime!),
                    style: AppTypography.labelSmall),
              ],
              AppGaps.verticalXl,
              AppButton(
                label: context.l10n.commonRetry,
                variant: AppButtonVariant.primary,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Force Update Screen (28.11)

When the app version is below the minimum required, show a **blocking** update screen. The user **cannot dismiss** it.

```
┌──────────────────────────┐
│                          │
│      📱⬆️                │  ← Update illustration
│                          │
│  Mise à jour requise     │  ← headingMedium
│                          │
│  Une nouvelle version    │  ← bodyMd
│  est disponible avec des │
│  améliorations           │
│  importantes.            │
│                          │
│  [Mettre à jour]         │  ← Primary, opens store
│                          │
└──────────────────────────┘
```

### Rules

| Rule | Value |
|------|-------|
| Display | Full screen, no AppBar, no back button |
| CTA | Opens App Store / Play Store link |
| Dismissibility | **NOT** dismissible — must update |
| Check frequency | On app launch + every cold resume from background |
| Version source | Remote Config / Supabase `app_config` table |

```dart
// ✅ CORRECT — force update check in startup
Future<void> checkMinimumVersion() async {
  final minVersion = await _remoteConfigService.getMinVersion();
  final currentVersion = await PackageInfo.fromPlatform();

  if (_isVersionBelow(currentVersion.version, minVersion)) {
    _navigationService.clearStackAndShow(Routes.forceUpdateView);
  }
}
```

---

## Feature Flag Off (28.12)

When a feature is disabled via server-side feature flags, **hide it gracefully** — never show a broken or empty view.

### Strategies

| Strategy | When to use | Visual |
|----------|------------|--------|
| **Hide completely** | Feature never released to this user | Remove from nav/list (as if it doesn't exist) |
| **Lock with message** | Feature exists but disabled temporarily | Lock icon + "Bientôt disponible" |
| **Degrade gracefully** | Partial feature disabled | Show read-only, hide write actions |

```dart
// ✅ CORRECT — hide feature from navigation
if (featureFlagService.isEnabled(Feature.analytics)) {
  destinations.add(AppNavDestination(
    icon: LucideIcons.barChart3,
    label: context.l10n.analytics,
    route: Routes.analyticsView,
  ));
}

// ✅ CORRECT — lock with "coming soon"
AppListTile(
  leading: Icon(LucideIcons.lock, color: context.colorScheme.onSurfaceVariant,
                semanticLabel: context.l10n.featureLockedLabel),
  title: context.l10n.advancedExport,
  subtitle: context.l10n.comingSoon,
  trailing: AppBadge.label(label: context.l10n.soon, color: AppColors.info),
  enabled: false,
)

// ❌ FORBIDDEN — show feature that crashes when tapped
AppListTile(
  title: context.l10n.advancedExport,
  onTap: () => throw UnimplementedError(), // will crash
)
```

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
