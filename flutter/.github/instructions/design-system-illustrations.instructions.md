```instructions
---
applyTo: "**/*.dart"
---
# Design System — Iconography & Illustrations

> Consistent visual language across all 200+ VTT apps.
> Icons from Lucide. Illustrations flat 2D + Lottie for animations.
> All assets accessible (semantic labels mandatory).

---

## Icon System

### Pack: Lucide Icons

- **Package**: `lucide_icons` (or `flutter_lucide` if available).
- **Why Lucide**: Clean, consistent, 1000+ icons, open source, actively maintained.
- **Stroke width**: Default (2px). Do NOT customize stroke width per-icon.

### Style Rules

| Context | Style | Example |
|---------|-------|---------|
| Navigation (active) | **Filled** | Bottom nav selected tab |
| Navigation (inactive) | **Outlined** | Bottom nav unselected tab |
| Body icons | **Outlined** | List icons, action buttons |
| Status indicators | **Outlined** | Check, warning, info |
| Decorative / hero | **Outlined** | Empty state, onboarding |

### Sizes (via `AppSizing`)

| Token | Size | Usage |
|-------|------|-------|
| `AppSizing.iconXs` | 12dp | Inline indicators (badge dot) |
| `AppSizing.iconSm` | 16dp | Trailing actions, secondary |
| `AppSizing.iconMd` | 20dp | Default body icons |
| `AppSizing.iconLg` | 24dp | Nav bar, primary action buttons |
| `AppSizing.iconXl` | 32dp | Section headers, empty states |
| `AppSizing.iconXxl` | 48dp | Hero icons, onboarding |

### Color Rules

```dart
// ✅ CORRECT — theme-aware icon colors
Icon(LucideIcons.home, 
  size: AppSizing.iconLg,
  color: context.colorScheme.onSurface,
  semanticLabel: context.l10n.home,
)

// ✅ CORRECT — primary accent
Icon(LucideIcons.check, 
  size: AppSizing.iconMd,
  color: context.colorScheme.primary,
  semanticLabel: context.l10n.completed,
)

// ✅ CORRECT — semantic color
Icon(LucideIcons.alertTriangle,
  size: AppSizing.iconMd,
  color: AppColors.warning,
  semanticLabel: context.l10n.warning,
)

// ❌ FORBIDDEN
Icon(Icons.home, size: 24)  // Raw Material icon + magic number
Icon(LucideIcons.home, color: Colors.white)  // Raw color
Icon(LucideIcons.home)  // Missing semanticLabel
```

### Accessibility

- **EVERY icon** MUST have a `semanticLabel` (from `context.l10n`).
- **Decorative-only icons** (purely visual, next to text that describes them) get `ExcludeSemantics`.

```dart
// Decorative icon next to text label — exclude from screen readers
ExcludeSemantics(
  child: Icon(LucideIcons.calendar, size: AppSizing.iconSm),
)
```

---

## Illustrations

### Style

- **Primary style**: Flat 2D vector illustrations.
- **Animation**: Lottie for animated illustrations (onboarding, celebrations, empty states).
- **Consistency**: All illustrations share the same visual language — clean lines, limited colors, geometric shapes.

### Shared Library

Illustrations are **shared across apps** via a common assets package:

```
assets/
├── illustrations/
│   ├── empty_state_generic.svg
│   ├── empty_state_list.svg
│   ├── empty_state_search.svg
│   ├── error_generic.svg
│   ├── error_network.svg
│   ├── onboarding_01.svg
│   ├── onboarding_02.svg
│   ├── onboarding_03.svg
│   ├── maintenance.svg
│   └── success.svg
├── lottie/
│   ├── confetti.json
│   ├── checkmark.json
│   ├── loading.json
│   └── celebration.json
```

### Empty State Illustrations

Style: **Minimal + Informative**.

```dart
// ✅ Standard empty state pattern
AppEmptyState(
  illustration: AppIllustrations.emptyList, // SVG
  title: context.l10n.noHabitsYet,
  description: context.l10n.noHabitsDescription,
  ctaLabel: context.l10n.addFirstHabit,
  onCtaPressed: viewModel.addHabit,
)
```

### App Icon Style

Each app icon follows a consistent pattern:
- **Background**: Solid primary color of the app.
- **Foreground**: White glyph/symbol representing the app.
- **Shape**: Rounded square (Android adaptive icon) / iOS standard.
- **Consistency**: Same border radius, same padding ratio, same glyph weight.

| App | Background | Glyph |
|-----|-----------|-------|
| LifeFlow | `#0D9488` (Teal) | Leaf / Flow symbol |
| IronFlow | `#DC2626` (Red) | Dumbbell |
| SpiritFlow | `#7C3AED` (Violet) | Flame / Spirit |
| MindFlow | `#2563EB` (Blue) | Brain / Wave |
| WealthFlow | `#059669` (Emerald) | Chart / Coin |
| HustlePro | `#F59E0B` (Amber) | Lightning / Dollar |

---

## Forbidden Patterns

```dart
// ❌ NEVER use Material Icons when Lucide equivalent exists
Icon(Icons.home)           // Use LucideIcons.home
Icon(Icons.settings)       // Use LucideIcons.settings
Icon(Icons.delete)         // Use LucideIcons.trash2

// ❌ NEVER use inline SVG strings
SvgPicture.string('<svg...')  // Use SvgPicture.asset('assets/...')

// ❌ NEVER hardcode icon sizes
Icon(LucideIcons.home, size: 24)  // Use AppSizing.iconLg

// ❌ NEVER use icons without semantic labels
Icon(LucideIcons.home)  // Missing semanticLabel parameter
```
```
