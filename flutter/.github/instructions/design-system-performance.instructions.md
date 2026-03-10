```instructions
---
applyTo: "**/*_view.dart,**/*_viewmodel.dart,**/*_service.dart"
---
# Design System — Loading & Performance UX (Phase 29)

> Users must NEVER see a blank screen while waiting.
> Skeletons for initial load, spinners for actions, optimistic for speed.
> Performance budgets exist — respect them on low-end devices.
> Smooth 60fps always. Degrade gracefully on weak hardware.

---

## Loading Hierarchy

| Context | Pattern | Widget | Duration |
|---------|---------|--------|----------|
| **Initial page load** | Skeleton shimmer | `AppSkeleton.list()` | Until data arrives |
| **Button action** | Spinner inside button | `AppButton(isLoading: true)` | Until response |
| **Pull to refresh** | Material indicator | `RefreshIndicator` | Until response |
| **Pagination (bottom)** | Inline circular loader | `AppProgress.circular(size: sm)` | Until page loads |
| **Image loading** | Shimmer → fade-in | `AppSkeleton.custom()` → image | Until decoded |
| **Background sync** | Silent (or subtle dot) | No UI block | Invisible |
| **Navigation transition** | Route animation | `AppAnimations.pageRoute` | 300ms |

---

## Optimistic Updates (29.2)

For fast-feeling interactions, apply the change **immediately** in the UI before the server confirms. Roll back only if the server returns an error.

### When to Use

| Action | Optimistic? | Reason |
|--------|------------|--------|
| Toggle (like, complete, favorite) | **YES** | Instant feedback critical |
| Mark as read | **YES** | Low-risk, reversible |
| Delete | **NO** — confirm first | Destructive, irreversible |
| Create new item | **NO** — show loader | Needs server-generated ID |
| Update text field | **NO** — save on blur | Complex merge |
| Reorder list | **YES** | Visual feedback must be instant |

### Implementation

```dart
// ✅ CORRECT — optimistic toggle with rollback
Future<void> toggleComplete(HabitItem item) async {
  // 1. Apply optimistically
  final previousState = item.isCompleted;
  item.isCompleted = !item.isCompleted;
  rebuildUi();
  HapticFeedback.lightImpact();

  // 2. Sync with server
  final result = await _habitRepository.toggleComplete(item.id);

  // 3. Rollback on error
  result.fold(
    (failure) {
      item.isCompleted = previousState;
      rebuildUi();
      HapticFeedback.heavyImpact();
      _snackbarService.showError(message: failure.userMessage);
    },
    (_) {
      // Celebration for completion
      if (item.isCompleted) {
        _celebrationService.micro();
      }
    },
  );
}

// ❌ FORBIDDEN — wait for server before updating UI
Future<void> toggleComplete(HabitItem item) async {
  setBusy(true); // blocks UI for 200-500ms
  await _habitRepository.toggleComplete(item.id);
  item.isCompleted = !item.isCompleted;
  setBusy(false);
}
```

---

## Pagination & Infinite Scroll (29.3, 29.4)

### Strategy: Infinite Scroll (Default)

Infinite scroll is the default for all list views. Load more button is a fallback for low-connectivity regions.

### Trigger Threshold

Load the next page when the user scrolls to **3 items before the end** of the current list.

```dart
// ✅ CORRECT — infinite scroll with pre-fetch threshold
class PaginatedListView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  static const int _prefetchThreshold = 3;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent -
            (_itemHeight * _prefetchThreshold)) {
      viewModel.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: viewModel.items.length + (viewModel.hasMorePages ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == viewModel.items.length) {
          return Padding(
            padding: EdgeInsets.all(AppSpacing.staticLg),
            child: Center(child: AppProgress.circular()),
          );
        }
        return ItemTile(item: viewModel.items[index]);
      },
    );
  }
}

// ❌ FORBIDDEN — load more button as primary pagination
ElevatedButton(onPressed: loadMore, child: Text('Load more'))
```

### Pagination Rules

| Rule | Value |
|------|-------|
| Page size | 20 items (default) |
| Prefetch threshold | 3 items before end |
| Loading indicator | `AppProgress.circular()` at list bottom |
| End of list | `Text(context.l10n.noMoreItems)` — subtle, muted |
| Error during load | Inline error + retry button at list bottom |
| Empty first page | `AppEmptyState` with CTA |

---

## Image Loading (29.6)

### Placeholder Strategy

| Strategy | When | Example |
|----------|------|---------|
| **Shimmer** | Default — card thumbnails, avatars | `AppSkeleton.custom(width: w, height: h)` |
| **BlurHash** | When blur hash is available from API | `BlurHash(hash: item.blurHash)` |
| **Dominant color** | When dominant color is stored | `Container(color: item.dominantColor)` |
| **Icon fallback** | When image fails to load | `Icon(LucideIcons.imageOff)` |

### Implementation

```dart
// ✅ CORRECT — image with shimmer placeholder + error fallback + fade-in
CachedNetworkImage(
  imageUrl: item.imageUrl,
  placeholder: (context, url) => AppSkeleton.custom(
    width: double.infinity,
    height: 200,
    borderRadius: AppRadius.md,
  ),
  errorWidget: (context, url, error) => Container(
    height: 200,
    decoration: BoxDecoration(
      color: context.colorScheme.surfaceContainerHighest,
      borderRadius: AppRadius.md,
    ),
    child: Icon(LucideIcons.imageOff,
        color: context.colorScheme.onSurfaceVariant,
        semanticLabel: context.l10n.imageLoadFailed),
  ),
  fadeInDuration: AppAnimations.normal,
  fit: BoxFit.cover,
)

// ❌ FORBIDDEN — bare Image.network with no placeholder
Image.network(item.imageUrl) // shows nothing during load, crashes on error
```

---

## Animation Budget (29.7)

### Performance Budget

| Constraint | Value |
|-----------|-------|
| Target frame rate | **60fps** (16.6ms per frame) |
| Max simultaneous animations | **3** per screen |
| Max shadow blur | **8dp** on low-end, **24dp** on high-end |
| Max concurrent particles | **50** (celebrations) |
| Shimmer frame budget | Batch repaints — never > 2 shimmer groups animating simultaneously |

### Low-End Device Detection

```dart
// ✅ CORRECT — detect and degrade for low-end devices
class PerformanceService {
  bool get isLowEndDevice {
    // Check device memory (if available via device_info_plus)
    // < 3GB RAM or old GPU → low-end
    return _deviceMemoryGB < 3;
  }

  /// Apply performance optimizations for weak devices
  void applyLowEndOptimizations() {
    // Disable blur effects
    _disableBlur = true;
    // Reduce shadow elevation
    _maxShadowElevation = 4;
    // Disable particle celebrations
    _celebrationsEnabled = false;
    // Reduce animation count
    _maxConcurrentAnimations = 1;
  }
}
```

### Degradation Rules

| Feature | High-end | Low-end |
|---------|----------|---------|
| `BackdropFilter` (blur) | Yes (blur: 10) | No — use solid color with opacity |
| `BoxShadow` | Full (elevation 4-24) | Reduced (elevation 0-4) or border only |
| `AppCelebrationOverlay` | Confetti particles | Simple scale + haptic only |
| `AppStaggeredFadeIn` | Full stagger animation | Immediate render (no stagger) |
| `Hero` transitions | Enabled | Enabled (lightweight) |
| Image quality | High-res | Request lower resolution from CDN |

```dart
// ✅ CORRECT — conditional blur based on performance
decoration: BoxDecoration(
  boxShadow: performanceService.isLowEndDevice
      ? [] // no shadow on low-end
      : AppShadows.md,
)
```

---

## Virtualized Lists (29.8)

### Rules

| List size | Widget | Reason |
|-----------|--------|--------|
| < 10 items | `Column` or `ListView(children: [...])` | Fine for small lists |
| 10-100 items | `ListView.builder` | Lazy construction |
| 100+ items | `ListView.builder` + `AutomaticKeepAlive` | Lazy + cached visible |
| 1000+ items | `ListView.builder` + pagination | Never load all at once |

```dart
// ✅ CORRECT — builder for any dynamic list
ListView.builder(
  itemCount: viewModel.items.length,
  itemBuilder: (context, index) => ItemTile(
    key: ValueKey(viewModel.items[index].id),
    item: viewModel.items[index],
  ),
)

// ❌ FORBIDDEN — building all items eagerly for large lists
ListView(
  children: viewModel.items.map((i) => ItemTile(item: i)).toList(), // builds ALL
)

// ❌ FORBIDDEN — SliverList without builder for dynamic content
SliverList(
  delegate: SliverChildListDelegate(
    viewModel.items.map((i) => ItemTile(item: i)).toList(), // no lazy build
  ),
)
```

---

## Preloading (29.10)

Preload data for the **most likely next screen** while the user is on the current one.

### Strategy

| Current screen | Preload | Priority |
|---------------|---------|----------|
| **List** | First item's detail (if only a few items) | Low |
| **Dashboard** | Tab content for the 2nd tab | Medium |
| **Onboarding page N** | Page N+1 illustration asset | High |
| **Auth (login)** | Home screen data (after login success) | High |

### Implementation

```dart
// ✅ CORRECT — preload next screen's data
class DashboardViewModel extends BaseViewModel {
  @override
  Future<void> initialise() async {
    // Load current tab data
    await _loadActiveTab();

    // Preload adjacent tab data in background (fire-and-forget)
    unawaited(_preloadAdjacentTabs());
  }

  Future<void> _preloadAdjacentTabs() async {
    // Don't block UI — fire and forget with error swallowing
    try {
      await Future.wait([
        _habitRepository.getHabits(), // preloads cache
        _goalRepository.getGoals(),
      ]);
    } catch (_) {
      // Preload failures are non-critical — silently ignore
    }
  }
}

// ❌ FORBIDDEN — loading everything sequentially
await _loadTab1();
await _loadTab2(); // blocks user unnecessarily
await _loadTab3();
```

### Asset Preloading

```dart
// ✅ CORRECT — precache images during splash
Future<void> precacheAssets(BuildContext context) async {
  await Future.wait([
    precacheImage(AssetImage('assets/images/onboarding_1.png'), context),
    precacheImage(AssetImage('assets/images/onboarding_2.png'), context),
    precacheImage(AssetImage('assets/images/onboarding_3.png'), context),
  ]);
}
```

---

## Cache Strategy (29.5)

### Stale-While-Revalidate (Default)

1. **Show cached data immediately** (if available).
2. **Fetch fresh data** from server in the background.
3. **Update UI silently** when fresh data arrives.
4. **If no cache**: show skeleton → fetch → show data.

```dart
// ✅ CORRECT — stale-while-revalidate pattern
Future<void> loadHabits() async {
  // 1. Show cache immediately
  final cached = await _cacheService.get<List<Habit>>('habits');
  if (cached != null) {
    _habits = cached;
    rebuildUi(); // immediate render with stale data
  } else {
    setBusy(true); // skeleton — no cache available
  }

  // 2. Fetch fresh in background
  final result = await _habitRepository.getHabits();
  result.fold(
    (failure) {
      if (cached == null) setError(failure); // only error if no cache
    },
    (freshHabits) {
      _habits = freshHabits;
      _cacheService.set('habits', freshHabits);
      rebuildUi(); // silent update
    },
  );
  setBusy(false);
}
```

---

## Splash Duration (29.9)

| Rule | Value |
|------|-------|
| Minimum | **1.5 seconds** (brand impression) |
| Maximum | **3.0 seconds** (user patience) |
| Source | `context.brandSkin.splashDuration` |
| During splash | Initialize services + auth check + precache assets |
| After splash | Navigate to: Onboarding (first launch) OR Home (authenticated) OR Login (unauthenticated) |

```dart
// ✅ CORRECT — splash with minimum duration + actual work
Future<void> runSplashLogic() async {
  await Future.wait([
    Future.delayed(brandSkin.splashDuration), // minimum brand impression
    _initializeServices(),                     // actual initialization
    _checkAuthStatus(),                        // auth check
  ]);
  // Navigate based on auth + first-launch status
  _navigateToNextScreen();
}
```

---

## Performance Testing Checklist

- [ ] Initial load shows skeleton within 16ms (first frame)
- [ ] No jank during scroll (maintain 60fps)
- [ ] Optimistic updates feel instant (< 100ms visual response)
- [ ] Infinite scroll triggers at 3 items before end
- [ ] Images show placeholder during load, fade in on arrival
- [ ] Blur/shadow effects disabled on low-end devices
- [ ] Lists with 100+ items use `ListView.builder`
- [ ] Pagination loads 20 items per page
- [ ] Cache shows stale data immediately on revisit
- [ ] Splash is between 1.5s and 3.0s
- [ ] No `Future.wait` blocking UI thread for non-critical preloading
```
