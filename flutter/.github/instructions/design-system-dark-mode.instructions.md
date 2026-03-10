```instructions
---
applyTo: "**/*.dart"
---
# Design System — Dark Mode Strategy

> VTT apps are **dark-first**: dark theme is the default at first launch.
> Light mode is always available and equally polished.
> Both modes MUST be tested before any PR is merged.

---

## Default Mode

- **First launch**: Dark mode.
- **User can switch**: Settings > Appearance > Dark / Light / System.
- **System-follow** is available but not the default (dark is).

---

## Color Architecture

### Surface Hierarchy (Dark)

| Level | Token | Hex | Usage |
|-------|-------|-----|-------|
| L0 — Background | `colorScheme.surface` | `#0E0E0E` | Scaffold base |
| L1 — Surface | `surfaceContainerLow` | `#1A1A1A` | Cards, tiles |
| L2 — Surface elevated | `surfaceContainer` | `#262626` | Grouped sections, bottom sheets |
| L3 — Surface highest | `surfaceContainerHighest` | `#303030` | Dialogs, popovers |

### Surface Hierarchy (Light)

| Level | Token | Hex | Usage |
|-------|-------|-----|-------|
| L0 — Background | `colorScheme.surface` | `#F7F7F7` | Scaffold base |
| L1 — Surface | `surfaceContainerLow` | `#FFFFFF` | Cards, tiles |
| L2 — Surface elevated | `surfaceContainer` | `#EEEEEE` | Grouped sections |
| L3 — Surface highest | `surfaceContainerHighest` | `#E0E0E0` | Dialogs |

### Text Colors

| Purpose | Dark | Light | Access |
|---------|------|-------|--------|
| Primary text | `#FFFFFF` | `#000000` | `colorScheme.onSurface` |
| Secondary text | `#9E9E9E` | `#757575` | `AppColors.textSecondary(brightness)` |
| Tertiary text | `#616161` | `#BDBDBD` | `AppColors.textTertiary(brightness)` |
| On primary | `#FFFFFF` | `#FFFFFF` | `colorScheme.onPrimary` |

---

## Rules

### 1. NEVER Use Direct Light/Dark References

```dart
// ❌ FORBIDDEN — Direct theme-specific references in views
color: AppColors.textSecondaryLight
color: AppColors.backgroundDark
color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight

// ✅ CORRECT — Theme-aware access
color: context.colorScheme.onSurface        // primary text
color: AppColors.textSecondary(brightness)   // secondary text
color: context.colorScheme.surface           // background
```

### 2. Shadows in Dark Mode

- **Light mode**: Standard `AppShadows.sm`, `AppShadows.md`, etc.
- **Dark mode**: Shadows are invisible on dark backgrounds. Use **borders** or **surface elevation** instead.

```dart
// ✅ CORRECT — adaptive shadow
decoration: BoxDecoration(
  boxShadow: isDark ? [] : AppShadows.sm,
  border: isDark 
    ? Border.all(color: context.colorScheme.outlineVariant)
    : null,
  borderRadius: AppRadius.card,
),
```

### 3. Semantic Colors Are Constant

These colors do NOT change between light and dark:

| Token | Value | Usage |
|-------|-------|-------|
| `AppColors.success` | `#10B981` | Positive states, confirmations |
| `AppColors.warning` | `#F59E0B` | Caution states |
| `AppColors.error` | `#EF4444` | Error states, destructive actions |
| `AppColors.info` | `#3B82F6` | Informational states |
| `AppColors.premium` | `#D4A853` | Gold accent, premium features |

They may have adjusted `onColor` and `container` variants per theme.

### 4. Primary Color Is App-Specific

The `primary` color comes from the Brand Skin (ThemeExtension). It is constant across modes:

| App | Primary | Hex |
|-----|---------|-----|
| LifeFlow | Teal | `#0D9488` |
| IronFlow | Red | `#DC2626` |
| SpiritFlow | Violet | `#7C3AED` |
| MindFlow | Blue | `#2563EB` |
| WealthFlow | Emerald | `#059669` |
| HustlePro | Amber | `#F59E0B` |

### 5. Glassmorphism Adapts

```dart
// Dark mode glassmorphism
Container(
  decoration: BoxDecoration(
    color: AppColors.frostedDark, // opacity 0.8
    border: Border.all(color: Colors.white.withOpacity(0.1)),
    borderRadius: AppRadius.lg,
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
    child: content,
  ),
)

// Light mode glassmorphism
Container(
  decoration: BoxDecoration(
    color: AppColors.frostedLight, // opacity 0.9
    border: Border.all(color: Colors.black.withOpacity(0.05)),
    borderRadius: AppRadius.lg,
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
    child: content,
  ),
)
```

### 6. Icons & Illustrations

- Icons use `colorScheme.onSurface` or `colorScheme.onSurfaceVariant`.
- Illustrations use theme-aware SVGs or have light/dark variants.
- Never use `Colors.white` / `Colors.black` for icons.

### 7. Gradients

```dart
// ✅ CORRECT — theme-aware gradient
LinearGradient(
  colors: [
    context.colorScheme.primary,
    AppColors.primaryDark,
  ],
)

// ❌ FORBIDDEN — hardcoded gradient colors
LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF0F766E)])
```

---

## Testing Checklist

Before every PR that touches UI:

- [ ] Screenshot dark mode — all screens affected
- [ ] Screenshot light mode — all screens affected
- [ ] Verify contrast ratio ≥ 4.5:1 for all text
- [ ] Verify no `*Light` / `*Dark` direct references in views
- [ ] Verify shadows disabled/replaced in dark mode
- [ ] Verify semantic colors render correctly on both backgrounds
- [ ] Verify glassmorphism readability in both modes
```
