---
applyTo: "**/*_view.dart,**/*_viewmodel.dart"
---

# Loading States — Mandatory Patterns

> Every async data fetch MUST show a skeleton/shimmer loading state, never a bare spinner.
> `AppSkeleton` is the DS widget. `AppLoader` is reserved for overlay/submit actions only.

---

## Rules

### 1. Initial Data Load → Skeleton

```dart
// ✅ CORRECT — skeleton layout matching the final UI
body: viewModel.isBusy
    ? _buildSkeleton(context)
    : _buildContent(context, viewModel),

Widget _buildSkeleton(BuildContext context) {
  return ListView(
    padding: EdgeInsets.all(AppSpacing.md),
    children: List.generate(5, (_) => Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          AppSkeleton.circle(size: 48),
          AppSpacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.text(width: 120),
                AppSpacing.verticalXs,
                AppSkeleton.text(),
              ],
            ),
          ),
        ],
      ),
    )),
  );
}
```

```dart
// ❌ FORBIDDEN — bare loader for data lists
body: viewModel.isBusy
    ? const Center(child: AppLoader())
    : _buildContent(context, viewModel),
```

### 2. Submit/Action → AppLoader or Button Loading

```dart
// ✅ CORRECT — loader for form submission
AppButton(
  label: l10n.save,
  isLoading: viewModel.isBusy,
  onPressed: viewModel.save,
)
```

```dart
// ✅ CORRECT — overlay for destructive action
AppLoadingOverlay(
  isLoading: viewModel.isBusy,
  child: _buildForm(context, viewModel),
)
```

### 3. Refresh → Pull-to-Refresh (keeps current content visible)

```dart
// ✅ CORRECT — RefreshIndicator, no skeleton on refresh
RefreshIndicator(
  onRefresh: viewModel.refresh,
  child: ListView.builder(...),
)
```

### 4. Pagination → Inline loader at bottom

```dart
// ✅ CORRECT — small loader at list bottom
if (viewModel.isLoadingMore)
  Padding(
    padding: EdgeInsets.all(AppSpacing.md),
    child: Center(child: AppLoader.small()),
  ),
```

---

## Skeleton Templates by View Type

| View Type | Skeleton Layout |
|---|---|
| **List view** | 5× `Row(AppSkeleton.circle + 2× AppSkeleton.text)` |
| **Card grid** | 4× `AppSkeleton(height: 120, borderRadius: AppRadius.card)` |
| **Detail view** | `AppSkeleton.circle(64)` + 3× `AppSkeleton.text` + `AppSkeleton(height: 200)` |
| **Form view** | 4× `AppSkeleton(height: 56)` stacked vertically |
| **Dashboard** | 2× stat cards (skeleton) + chart placeholder (skeleton) |

---

## ViewModel Pattern

```dart
// ✅ CORRECT — separate busy keys for different operations
Future<void> init() async {
  setBusy(true);  // Shows skeleton
  await _loadData();
  setBusy(false);
}

Future<void> refresh() async {
  // NO setBusy — RefreshIndicator handles visual feedback
  await _loadData();
  rebuildUi();
}

Future<void> loadMore() async {
  setBusyForObject('loadMore', true);
  await _loadNextPage();
  setBusyForObject('loadMore', false);
}

bool get isLoadingMore => busy('loadMore');
```

---

## Self-Check

```bash
# Find bare AppLoader on initial load (should be skeleton instead)
grep -rn "Center(child: AppLoader())" lib/features/ lib/modules/
```
