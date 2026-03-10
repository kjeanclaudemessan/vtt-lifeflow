```instructions
---
applyTo: "**/*.dart"
---
# Design System — Tokens Reference (Colors, Typography, Spacing, Radius, Shadows)

> Comprehensive reference for all design token classes.
> NEVER use raw values — always use token classes.
> These tokens are the SINGLE SOURCE OF TRUTH for visual properties.

---

## Color Tokens (`AppColors`)

### Brand Colors

| Token | Value | Usage |
|-------|-------|-------|
| `AppColors.primary` | `#0D9488` (LifeFlow) | CTAs, highlights, brand moments |
| `AppColors.primaryLight` | `#14B8A6` | Hover states, lighter accents |
| `AppColors.primaryDark` | `#0F766E` | Pressed states, darker accents |
| `AppColors.primaryContainer` | `#E6F7F5` (L) / `#042F2E` (D) | Chip backgrounds, subtle fills |
| `AppColors.onPrimary` | `#FFFFFF` | Text/icons on primary backgrounds |

> Primary color changes per app via Brand Skin (ThemeExtension). See `design-system-brand-skin.instructions.md`.

### Semantic Colors (constant across all apps and modes)

| Token | Value | Usage |
|-------|-------|-------|
| `AppColors.success` | `#10B981` | Positive outcomes, completed states |
| `AppColors.warning` | `#F59E0B` | Caution, pending actions |
| `AppColors.error` | `#EF4444` | Errors, destructive actions |
| `AppColors.info` | `#3B82F6` | Information, tips, links |
| `AppColors.premium` | `#D4A853` | Gold accent for premium features |

### Access Patterns

```dart
// Surface colors — ALWAYS via colorScheme
context.colorScheme.surface          // page background
context.colorScheme.surfaceContainerLow  // cards
context.colorScheme.onSurface        // primary text

// Semantic colors — via AppColors directly
AppColors.success
AppColors.error

// Brightness-aware text — via helper methods
AppColors.textSecondary(brightness)
AppColors.textTertiary(brightness)

// ❌ FORBIDDEN
AppColors.textSecondaryLight  // direct Light/Dark reference
Colors.white                  // raw Material color
Color(0xFF757575)             // magic hex
```

### Data Visualization Palette (8 colors)

For charts, tags, categories — use in order:

```dart
// Defined in AppColors or via ThemeExtension
static const dataViz = [
  Color(0xFF0D9488), // Teal
  Color(0xFF3B82F6), // Blue
  Color(0xFFF59E0B), // Amber
  Color(0xFFEF4444), // Red
  Color(0xFF8B5CF6), // Purple
  Color(0xFF10B981), // Green
  Color(0xFFEC4899), // Pink
  Color(0xFFF97316), // Orange
];
```

---

## Typography Tokens (`AppTypography`)

### Font

- **Family**: Inter (via `google_fonts`).
- **Weights**: Regular (400), SemiBold (600), Bold (700). No other weights allowed.
- **Minimum size**: 12sp for any user-facing text.

### Scale

| Token | Size | Weight | Height | Usage |
|-------|------|--------|--------|-------|
| `displayLarge` | 84sp | Bold | 1.1 | Hero moments, splash stats |
| `displayMedium` | 60sp | Bold | 1.15 | Large section headers |
| `displaySmall` | 44sp | Bold | 1.2 | Feature highlight numbers |
| `headingXXLarge` | 36sp | Bold | 1.25 | Page titles |
| `headingXLarge` | 32sp | Bold | 1.25 | Section titles |
| `headingLarge` | 28sp | SemiBold | 1.3 | Card titles |
| `headingMedium` | 24sp | SemiBold | 1.3 | Subsection titles |
| `headingSmall` | 20sp | SemiBold | 1.35 | List group headers |
| `bodyLarge` | 18sp | Regular | 1.5 | Large body text |
| `bodyMedium` | 16sp | Regular | 1.5 | Default body text |
| `bodySmall` | 14sp | Regular | 1.5 | Secondary body text |
| `labelLarge` | 16sp | SemiBold | 1.4 | Button labels |
| `labelMedium` | 14sp | SemiBold | 1.4 | Chip labels, tabs |
| `labelSmall` | 12sp | SemiBold | 1.4 | Badges, overlines |
| `caption` | 12sp | Regular | 1.4 | Timestamps, footnotes |

### RTL Fonts

- **Arabic fallback**: Noto Sans Arabic.
- Set via `fontFamilyFallback: ['NotoSansArabic']` in theme configuration.

### Usage

```dart
// ✅ CORRECT
Text('Title', style: AppTypography.headingLarge)
Text('Body', style: AppTypography.bodyMedium)

// ❌ FORBIDDEN
Text('Title', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600))
```

---

## Spacing Tokens (`AppSpacing`)

### Base Grid

- **Grid unit**: 4px.
- All spacing values are multiples of 4.

### Static Scale

| Token | Value | Usage |
|-------|-------|-------|
| `AppSpacing.none` | 0 | No spacing |
| `AppSpacing.staticXs` | 4dp | Icon-label gap, tight grouping |
| `AppSpacing.staticSm` | 8dp | Between related elements |
| `AppSpacing.staticMd` | 16dp | Page padding, card padding, section gaps |
| `AppSpacing.staticLg` | 24dp | Major section separators |
| `AppSpacing.staticXl` | 32dp | Large visual breaks |
| `AppSpacing.staticXxl` | 48dp | Page-level separators |

### Fluid Scale (viewport-responsive)

| Token | Base | Usage |
|-------|------|-------|
| `AppSpacing.fluidXs` | 8dp | Compact responsive gap |
| `AppSpacing.fluidSm` | 16dp | Default responsive padding |
| `AppSpacing.fluidMd` | 24dp | Medium responsive padding |
| `AppSpacing.fluidLg` | 40dp | Large responsive gap |
| `AppSpacing.fluidXl` | 56dp | Hero section spacing |
| `AppSpacing.fluidXxl` | 80dp | Maximum responsive space |

### Standard Page Layout

```dart
Scaffold(
  body: Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.staticMd), // 16dp
    child: content,
  ),
)
```

### Gap Widgets (`AppGaps`)

Pre-built `SizedBox` widgets for common spacing:

```dart
// Vertical gaps
AppGaps.h4   // SizedBox(height: 4)
AppGaps.h8   // SizedBox(height: 8)
AppGaps.h12  // SizedBox(height: 12)
AppGaps.h16  // SizedBox(height: 16)
AppGaps.h24  // SizedBox(height: 24)
AppGaps.h32  // SizedBox(height: 32)

// Horizontal gaps
AppGaps.w4   // SizedBox(width: 4)
AppGaps.w8   // SizedBox(width: 8)
AppGaps.w16  // SizedBox(width: 16)

// ❌ FORBIDDEN
SizedBox(height: 16) // Use AppGaps.h16 instead
```

---

## Radius Tokens (`AppRadius`)

### Scale

| Token | Value | Usage |
|-------|-------|-------|
| `AppRadius.none` | 0 | No rounding |
| `AppRadius.xs` | 4dp | Buttons, inputs, chips — clean Porsche style |
| `AppRadius.sm` | 8dp | Cards, containers |
| `AppRadius.md` | 12dp | Large cards, modals |
| `AppRadius.lg` | 16dp | Bottom sheets, large surfaces |
| `AppRadius.xl` | 24dp | BottomSheet handle area, hero cards |
| `AppRadius.pill` | 100dp | Avatars, badges, fully rounded elements |

### Component Presets

| Component | Token | Result |
|-----------|-------|--------|
| `AppRadius.button` | `xs` (4dp) | Clean, refined buttons |
| `AppRadius.card` | `sm` (8dp) | Standard card rounding |
| `AppRadius.input` | `xs` (4dp) | Text fields |
| `AppRadius.chip` | `xs` (4dp) | Consistent with buttons |
| `AppRadius.bottomSheet` | `xl` (24dp) | Top corners of bottom sheets |
| Avatar | `pill` (100dp) | Fully circular |

---

## Shadow Tokens (`AppShadows`)

### Light Mode Shadows

| Token | Blur | Offset | Usage |
|-------|------|--------|-------|
| `AppShadows.none` | 0 | 0,0 | Flat elements |
| `AppShadows.xs` | 4 | 0,1 | Subtle lift (resting cards) |
| `AppShadows.sm` | 8 | 0,2 | Cards at rest |
| `AppShadows.md` | 16 | 0,4 | Elevated elements (Porsche default) |
| `AppShadows.lg` | 24 | 0,8 | Modals, popovers |
| `AppShadows.xl` | 32 | 0,12 | Flyouts, important elements |

### Dark Mode Shadows

- Standard shadows are **invisible** on dark backgrounds.
- Use `AppShadows.darkSm`, `AppShadows.darkMd` for dark mode.
- Alternatively, use **border outlines** instead of shadows in dark mode.

### Glow Effects

```dart
// Primary-tinted glow for interactive elements in dark mode
BoxShadow(
  color: context.colorScheme.primary.withOpacity(0.3),
  blurRadius: 12,
  spreadRadius: -2,
)
```

---

## Sizing Tokens (`AppSizing`)

### Icons

| Token | Size | Usage |
|-------|------|-------|
| `AppSizing.iconXs` | 12dp | Inline indicators |
| `AppSizing.iconSm` | 16dp | Trailing, secondary |
| `AppSizing.iconMd` | 20dp | Default body icons |
| `AppSizing.iconLg` | 24dp | Nav bar, primary actions |
| `AppSizing.iconXl` | 32dp | Headers, empty states |
| `AppSizing.iconXxl` | 48dp | Hero icons, onboarding |

### Avatars

| Token | Size | Usage |
|-------|------|-------|
| `AppSizing.avatarSm` | 32dp | List items (compact) |
| `AppSizing.avatarMd` | 40dp | Default list items |
| `AppSizing.avatarLg` | 56dp | Profile header, cards |
| `AppSizing.avatarXl` | 80dp | Profile page hero |
| `AppSizing.avatarXxl` | 100dp | Edit profile |

### Touch Targets

| Token | Size | Usage |
|-------|------|-------|
| `AppSizing.touchTargetMin` | 44dp | Apple HIG minimum |
| `AppSizing.touchTarget` | 48dp | Material / WCAG AA default |
| `AppSizing.touchTargetLg` | 56dp | Primary action buttons |

---

## Animation Tokens (`AppAnimations`)

### Durations

| Token | Value | Usage |
|-------|-------|-------|
| `AppAnimations.instant` | 0ms | No animation |
| `AppAnimations.extraFast` | 100ms | Micro-feedback |
| `AppAnimations.fast` | 150ms | Button press, toggle |
| `AppAnimations.normal` | 200ms | Default transitions |
| `AppAnimations.medium` | 300ms | Page transitions, content swap |
| `AppAnimations.slow` | 400ms | Complex animations |
| `AppAnimations.extraSlow` | 500ms | Celebration, emphasis |

### Curves

| Token | Curve | Usage |
|-------|-------|-------|
| `AppAnimations.defaultCurve` | `easeInOut` | General purpose |
| `AppAnimations.easeOut` | `easeOut` | Entrances |
| `AppAnimations.easeIn` | `easeIn` | Exits |
| `AppAnimations.easeOutCubic` | `easeOutCubic` | Page transitions |
| `AppAnimations.spring` | `elasticOut` | Bouncy celebrations |
| `AppAnimations.decelerate` | `decelerate` | Smooth deceleration |

---

## Absolute Rules

1. **ZERO magic numbers** — every size, spacing, color, radius, shadow, animation MUST use a token.
2. **ZERO raw `Color(0xFF...)`** outside `design_system/` directory.
3. **ZERO raw `TextStyle(fontSize: ...)`** outside `design_system/` directory.
4. **ZERO raw `SizedBox(height: 16)`** — use `AppGaps.h16`.
5. **ZERO raw `Duration(milliseconds: 300)`** — use `AppAnimations.medium`.
6. **ZERO raw `BorderRadius.circular(8)`** — use `AppRadius.sm`.
```
