---
applyTo: "**/*_view.dart,**/*_viewmodel.dart"
---

# Error States — Mandatory Patterns

> Every async operation MUST handle errors gracefully with a consistent UX pattern.
> Never show raw error messages, stack traces, or unhandled exceptions to users.

---

## Rules

### 1. Data Load Error → AppEmptyState with retry

```dart
// ✅ CORRECT — error state with retry action
body: viewModel.hasError
    ? AppEmptyState(
        icon: Icons.error_outline,
        title: l10n.errorGenericTitle,
        description: l10n.errorGenericDescription,
        actionLabel: l10n.retry,
        onAction: viewModel.init,
      )
    : viewModel.isBusy
        ? _buildSkeleton(context)
        : _buildContent(context, viewModel),
```

```dart
// ❌ FORBIDDEN — no error handling
body: viewModel.isBusy
    ? AppLoader()
    : _buildContent(context, viewModel),
```

### 2. Action Error → SnackBar (non-blocking)

```dart
// ✅ CORRECT — in ViewModel, set error for view to display
Future<void> toggleHabit(String id) async {
  final result = await _repository.toggle(id);
  result.fold(
    (failure) {
      HapticFeedback.heavyImpact();
      setError(failure.message);
    },
    (success) {
      HapticFeedback.mediumImpact();
      rebuildUi();
    },
  );
}
```

```dart
// ✅ CORRECT — in View, listen to errors via onViewModelReady or builder
if (viewModel.hasError) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    AppSnackBar.error(
      context,
      message: viewModel.modelError.toString(),
    );
    viewModel.clearErrors();
  });
}
```

### 3. Form Validation Error → Inline field errors

```dart
// ✅ CORRECT — field-level validation
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return l10n.fieldRequired;
    }
    return null;
  },
)
```

### 4. Network Error → Specific messaging

```dart
// ✅ CORRECT — distinguish network vs server errors
result.fold(
  (failure) {
    final message = switch (failure) {
      NetworkFailure() => l10n.errorNoConnection,
      ServerFailure() => l10n.errorServer,
      AuthFailure() => l10n.errorSessionExpired,
      _ => l10n.errorGeneric,
    };
    setError(message);
  },
  (data) => _handleSuccess(data),
);
```

---

## Error State Priority Order

```
1. viewModel.hasError → Show error state with retry
2. viewModel.isBusy → Show skeleton
3. data.isEmpty → Show AppEmptyState
4. data.isNotEmpty → Show content
```

```dart
// ✅ CORRECT — full state machine in view builder
Widget builder(BuildContext context, MyViewModel viewModel, Widget? child) {
  if (viewModel.hasError) {
    return _buildErrorState(context, viewModel);
  }
  if (viewModel.isBusy) {
    return _buildSkeleton(context);
  }
  if (viewModel.items.isEmpty) {
    return _buildEmptyState(context);
  }
  return _buildContent(context, viewModel);
}
```

---

## ViewModel Error Handling Pattern

```dart
// ✅ CORRECT — unified error handling with Either
Future<void> init() async {
  setBusy(true);
  final result = await _repository.getAll();
  result.fold(
    (failure) => setError(failure.userMessage),
    (data) => _items = data,
  );
  setBusy(false);
}

// ✅ CORRECT — runBusyFuture with error callback
Future<void> save() async {
  final result = await runBusyFuture(
    _repository.create(entity),
    throwException: false,
  );
  // result handling...
}
```

---

## Forbidden Patterns

| Pattern | Why | Fix |
|---|---|---|
| `try/catch` showing `e.toString()` | Raw error leaks | Use `Failure.userMessage` |
| No `hasError` check in view | Silent failure | Always check `hasError` first |
| `print(error)` in production | Debug leak | Use `AppConfig.isDebug` guard |
| Dismissing errors without user awareness | UX gap | Show SnackBar minimum |

---

## Self-Check

```bash
# Find views without error handling
grep -rn "viewModel.isBusy" lib/features/ lib/modules/ | grep -v "hasError"
```
