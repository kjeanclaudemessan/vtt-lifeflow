```instructions
---
applyTo: "**/*.dart"
---
# Design System — Accessibility (a11y)

> WCAG AA compliance is mandatory for all VTT apps.
> Accessibility is NOT optional — it's a foundation requirement.
> Every component, icon, and interactive element must be accessible.

---

## Standards

- **Level**: WCAG 2.1 **AA** (not AAA — targeting AA as baseline).
- **Platforms**: iOS VoiceOver + Android TalkBack.
- **Font scaling**: Support system scaling from 1.0× to 2.0×.
- **Reduce motion**: Respect `MediaQuery.disableAnimations`.

---

## Contrast Requirements

| Element | Minimum Ratio | How to Check |
|---------|--------------|--------------|
| **Body text** (< 18sp) | 4.5:1 | Primary text on surface |
| **Large text** (≥ 18sp / 14sp bold) | 3:1 | Headings on surface |
| **UI components** (borders, icons) | 3:1 | Icons, borders, focus indicators |
| **Decorative elements** | No requirement | Non-essential visual elements |

### Current Palette Compliance

| Combination | Ratio | Pass? |
|-------------|-------|-------|
| `#FFFFFF` on `#0E0E0E` (dark) | 19.1:1 | ✅ |
| `#000000` on `#F7F7F7` (light) | 17.4:1 | ✅ |
| `#9E9E9E` on `#0E0E0E` (secondary dark) | 6.8:1 | ✅ |
| `#757575` on `#F7F7F7` (secondary light) | 4.6:1 | ✅ |
| `#0D9488` on `#0E0E0E` (primary dark) | 5.3:1 | ✅ |
| `#0D9488` on `#F7F7F7` (primary light) | 3.7:1 | ⚠️ Use on large text only |

---

## Touch Targets

| Element | Minimum Size | Token |
|---------|-------------|-------|
| **Buttons, icons, tappable areas** | 48×48dp | `AppSizing.touchTarget` |
| **Apple HIG minimum** | 44×44dp | `AppSizing.touchTargetMin` |
| **Primary action buttons** | 56×56dp | `AppSizing.touchTargetLg` |

```dart
// ✅ CORRECT — adequate touch target
SizedBox(
  width: AppSizing.touchTarget,
  height: AppSizing.touchTarget,
  child: IconButton(
    icon: Icon(LucideIcons.edit, semanticLabel: context.l10n.edit),
    onPressed: viewModel.edit,
  ),
)

// ❌ FORBIDDEN — too small
IconButton(
  iconSize: 16,  // Touch target too small
  icon: Icon(LucideIcons.edit),
  onPressed: viewModel.edit,
)
```

---

## Semantic Labels

### Every Icon Needs a Label

```dart
// ✅ CORRECT
Icon(
  LucideIcons.home,
  size: AppSizing.iconLg,
  semanticLabel: context.l10n.home,
)

// ❌ FORBIDDEN — missing semanticLabel
Icon(LucideIcons.home, size: AppSizing.iconLg)
```

### Every Image Needs a Description

```dart
// ✅ CORRECT
Image.asset(
  'assets/images/profile.png',
  semanticLabel: context.l10n.profilePhoto,
)

// For SVGs
SvgPicture.asset(
  'assets/icons/logo.svg',
  semanticLabel: context.l10n.appLogo,
)
```

### Decorative Elements Get Excluded

```dart
// ✅ CORRECT — decorative icon next to text (text is sufficient)
ExcludeSemantics(
  child: Icon(LucideIcons.calendar, size: AppSizing.iconSm),
)
```

### Interactive Widgets Need Semantics

```dart
// ✅ CORRECT — full semantic annotation
Semantics(
  button: true,
  label: context.l10n.markAsComplete,
  child: GestureDetector(
    onTap: viewModel.complete,
    child: habitCard,
  ),
)
```

---

## Color Alone = Never

Information must NEVER be conveyed by color alone. Always add:

- **Icon** (checkmark for success, X for error).
- **Text** label describing the state.
- **Pattern** or shape difference.

```dart
// ✅ CORRECT — color + icon + text
Row(
  children: [
    Icon(LucideIcons.checkCircle, color: AppColors.success, semanticLabel: context.l10n.completed),
    AppGaps.w8,
    Text(context.l10n.completed, style: AppTypography.bodySmall.copyWith(color: AppColors.success)),
  ],
)

// ❌ FORBIDDEN — color only
Container(
  width: 12,
  height: 12,
  color: AppColors.success, // What does this mean to a colorblind user?
)
```

---

## Font Scaling

### Support Range: 1.0× to 2.0×

```dart
// ✅ CORRECT — use AppTypography (already uses .sp for scaling)
Text(title, style: AppTypography.headingLarge)

// ✅ CORRECT — test with MediaQuery textScaleFactor
// Ensure layouts don't overflow at 2.0× text scale.
```

### Layout Rules for Scaling

- **Never constrain text height** with fixed-size containers.
- **Use `Flexible` / `Expanded`** in rows with text + icon.
- **Test at 2.0× scale** — text should wrap, never overflow or clip.

```dart
// ✅ CORRECT — text can grow
Flexible(
  child: Text(longTitle, style: AppTypography.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
)

// ❌ FORBIDDEN — fixed height clips scaled text
SizedBox(
  height: 20,
  child: Text(title), // Clips at 2.0× scaling
)
```

---

## Reduce Motion

```dart
// ✅ REQUIRED — respect accessibility preference
final reduceMotion = MediaQuery.of(context).disableAnimations;

// Skip animations when reduce motion is on
AnimatedSwitcher(
  duration: reduceMotion ? Duration.zero : AppAnimations.medium,
  child: content,
)

// No parallax, no auto-playing animations when reduce motion is on
if (!reduceMotion) {
  _playEntranceAnimation();
}
```

---

## Screen Reader Navigation Order

- **Logical reading order**: Top to bottom, left to right (LTR) or right to left (RTL).
- **Focus order** matches visual order.
- **Skip links**: important CTAs should be reachable quickly.

```dart
// ✅ CORRECT — semantic traversal order
Semantics(
  sortKey: OrdinalSortKey(1.0),
  child: title,
)
Semantics(
  sortKey: OrdinalSortKey(2.0),
  child: subtitle,
)
Semantics(
  sortKey: OrdinalSortKey(3.0),
  child: actionButton,
)
```

---

## Checklist (Per Screen)

Before any view is submitted:

- [ ] All `Icon` widgets have `semanticLabel`
- [ ] All `Image`/`SvgPicture` have `semanticLabel`
- [ ] All tappable areas ≥ 48dp (use `AppSizing.touchTarget`)
- [ ] No information conveyed by color alone
- [ ] Layout tested at 2.0× text scale
- [ ] `MediaQuery.disableAnimations` respected
- [ ] Interactive elements wrapped in `Semantics` when not natively accessible
- [ ] Decorative elements wrapped in `ExcludeSemantics`
- [ ] Contrast ratio ≥ 4.5:1 for body text, ≥ 3:1 for large text
- [ ] Screen reader navigation order is logical
```
