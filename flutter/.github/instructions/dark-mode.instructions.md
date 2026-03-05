```instructions
---
applyTo: "**/*.dart"
---
# Dark Mode Instructions

> These instructions apply to ALL Dart files.
> Ensures proper dark mode support across the entire app.

---

## Core Rule

**NEVER use `*Light` or `*Dark` color variants directly.**
Always use brightness-aware helpers or `Theme.of(context)`.

---

## Forbidden Patterns

### Direct Light/Dark Color References

```dart
// ❌ FORBIDDEN — hardcodes light mode
color: AppColors.textSecondaryLight,
color: AppColors.textPrimaryLight,
color: AppColors.textTertiaryLight,
color: AppColors.textSecondaryDark,
color: AppColors.textPrimaryDark,
color: AppColors.contrastHighLight,
color: AppColors.contrastMediumLight,
color: AppColors.surfaceLight,
color: AppColors.surfaceDark,
color: AppColors.backgroundLight,
color: AppColors.backgroundDark,
color: AppColors.borderLight,
color: AppColors.borderDark,
color: AppColors.surfaceSecondaryLight,
color: AppColors.surfaceSecondaryDark,

// ✅ CORRECT — adapts to current theme
color: AppColors.textSecondary(Theme.of(context).brightness),
color: AppColors.textPrimary(Theme.of(context).brightness),
color: AppColors.textTertiary(Theme.of(context).brightness),
color: AppColors.contrastHigh(Theme.of(context).brightness),
color: AppColors.contrastMedium(Theme.of(context).brightness),
```

### Raw Material Colors

```dart
// ❌ FORBIDDEN
color: Colors.white,
color: Colors.black,
color: Colors.grey,
color: Colors.grey[400],
color: Color(0xFFFFFFFF),
color: Color(0xFF000000),

// ✅ CORRECT — theme-aware
color: Theme.of(context).colorScheme.surface,
color: Theme.of(context).colorScheme.onSurface,
color: Theme.of(context).colorScheme.outline,
color: AppColors.white,   // Only for fixed-color contexts (e.g., on primary)
color: AppColors.black,   // Only for fixed-color contexts
```

### Raw Neutral References

```dart
// ❌ FORBIDDEN — neutral shades without brightness context
color: AppColors.neutral400,
color: AppColors.neutral500,
color: AppColors.neutral600,

// ✅ CORRECT
color: AppColors.contrastMedium(Theme.of(context).brightness),
color: Theme.of(context).colorScheme.outline,
```

---

## Brightness Access Patterns

### In Widgets (BuildContext available)

```dart
Widget build(BuildContext context) {
  final brightness = Theme.of(context).brightness;

  return Text(
    'Subtitle',
    style: TextStyle(
      color: AppColors.textSecondary(brightness),
    ),
  );
}
```

### In Stacked Views (ViewModel builder)

```dart
@override
Widget builder(BuildContext context, MyViewModel viewModel, Widget? child) {
  final brightness = Theme.of(context).brightness;
  final isDark = brightness == Brightness.dark;

  return Container(
    color: AppColors.surface(brightness),
    child: Text(
      'Title',
      style: TextStyle(
        color: AppColors.textPrimary(brightness),
      ),
    ),
  );
}
```

### In Extract Methods

```dart
// Always pass brightness as parameter to extracted methods
Widget _buildHeader(BuildContext context, Brightness brightness) {
  return Text(
    'Header',
    style: TextStyle(
      color: AppColors.textSecondary(brightness),
    ),
  );
}
```

---

## Allowed Exceptions

### Fixed-Color Contexts

These are acceptable when the background color is guaranteed:

```dart
// ✅ OK — text on primary-colored background (always dark)
Container(
  color: AppColors.primary,
  child: Text(
    'Label',
    style: TextStyle(color: AppColors.onPrimary), // Always white
  ),
)

// ✅ OK — icon on error-colored background
Container(
  color: AppColors.error,
  child: Icon(Icons.close, color: AppColors.white),
)
```

### Design Showcase / Debug Views

```dart
// ✅ OK — design_showcase_view.dart is allowed to reference
// both Light and Dark variants for display purposes only
_ColorItem('Text Primary Light', AppColors.textPrimaryLight),
_ColorItem('Text Primary Dark', AppColors.textPrimaryDark),
```

---

## Available Helpers in AppColors

Reference these helpers instead of direct Light/Dark variants:

| Helper Method | Usage |
|---|---|
| `AppColors.textPrimary(brightness)` | Main text color |
| `AppColors.textSecondary(brightness)` | Subtitle / secondary text |
| `AppColors.textTertiary(brightness)` | Hint / placeholder text |
| `AppColors.surface(brightness)` | Card / container surfaces |
| `AppColors.background(brightness)` | Page background |
| `AppColors.border(brightness)` | Dividers and borders |
| `AppColors.contrastHigh(brightness)` | High emphasis elements |
| `AppColors.contrastMedium(brightness)` | Medium emphasis elements |
| `AppColors.contrastLow(brightness)` | Subtle backgrounds |

If a helper doesn't exist for your use case, **add it to `app_colors.dart`** following the same pattern — don't hardcode.

---

## Self-Check Before Committing

Run this grep to find violations:

```bash
grep -rn "textSecondaryLight\|textPrimaryLight\|textTertiaryLight\|textSecondaryDark\|textPrimaryDark\|Colors\.white\|Colors\.black\|Colors\.grey" lib/
```

Any match outside `design_system/` or `design_showcase` is a violation.
```
