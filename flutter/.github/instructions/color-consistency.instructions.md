---
applyTo: "**/*_view.dart,**/*.dart"
---

# Color Consistency — Mandatory Patterns

> ALL Scaffold backgrounds and surface colors MUST come from `context.colorScheme`,
> never from direct `AppColors.*Light` / `AppColors.*Dark` references.
> This ensures automatic theme adaptation and visual consistency across screens.

---

## Rules

### 1. Scaffold Background

```dart
// ✅ CORRECT — uses theme colorScheme (auto-adapts light/dark)
Scaffold(
  backgroundColor: context.colorScheme.surface,
)

// ✅ CORRECT — grouped/iOS-style with elevated sections
Scaffold(
  backgroundColor: context.colorScheme.surfaceContainerHighest,
)
```

```dart
// ❌ FORBIDDEN — hardcoded theme-specific color
Scaffold(
  backgroundColor: isDark ? AppColors.backgroundDark : AppColors.surfaceSecondaryLight,
)

// ❌ FORBIDDEN — direct AppColors reference
Scaffold(
  backgroundColor: AppColors.surfaceLight,
)
```

### 2. Card & Container Backgrounds

```dart
// ✅ CORRECT
Container(
  color: context.colorScheme.surfaceContainerLow,
)

// ❌ FORBIDDEN
Container(
  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
)
```

### 3. Color Hierarchy

| Purpose | colorScheme Property | Light Value | Dark Value |
|---|---|---|---|
| **Page background** | `surface` | `#F7F7F7` | `#1A1A1A` |
| **Grouped background** | `surfaceContainerHighest` | `#EEEEEE` | `#262626` |
| **Card on page** | `surfaceContainerLow` | `#FFFFFF` | `#1A1A1A` |
| **Primary text** | `onSurface` | `#000000` | `#FFFFFF` |
| **Border** | `outline` | `#E0E0E0` | `#3D3D3D` |
| **Divider** | `outlineVariant` | `#E0E0E0` | `#3D3D3D` |
| **Accent** | `primary` | `#D5001C` | `#D5001C` |

### 4. When to Use AppColors Directly

`AppColors` direct usage is ONLY acceptable for:
- Design system widget internals (inside `design_system/`)
- Semantic colors: `AppColors.success`, `AppColors.error`, `AppColors.warning`, `AppColors.info`
- Gradients: `AppColors.primaryGradient`, `AppColors.sheenGradient`
- Computed colors: `AppColors.primaryWithOpacity(0.1)`
- Brightness helper calls: `AppColors.textSecondary(brightness)` (when colorScheme doesn't cover the case)

### 5. Consistency Check

Every view in the app MUST use the same background for the same level of hierarchy:
- All "main" screens → `context.colorScheme.surface`
- All "grouped/settings" screens → `context.colorScheme.surfaceContainerHighest`
- All "modal" screens → `context.colorScheme.surface`
- All "detail" screens → `context.colorScheme.surface`

---

## Migration Table

| Old Pattern | New Pattern |
|---|---|
| `isDark ? AppColors.backgroundDark : AppColors.backgroundLight` | `context.colorScheme.surface` |
| `isDark ? AppColors.surfaceDark : AppColors.surfaceLight` | `context.colorScheme.surface` |
| `isDark ? AppColors.backgroundDark : AppColors.surfaceSecondaryLight` | `context.colorScheme.surfaceContainerHighest` |
| `isDark ? AppColors.surfaceSecondaryDark : AppColors.surfaceSecondaryLight` | `context.colorScheme.surfaceContainerHighest` |
| `AppColors.surfaceLight` | `context.colorScheme.surface` |
| `AppColors.backgroundLight` | `context.colorScheme.surface` |

---

## Self-Check

```bash
# Find hardcoded scaffold backgrounds
grep -rn "backgroundColor:.*AppColors\." lib/features/ lib/modules/
```
