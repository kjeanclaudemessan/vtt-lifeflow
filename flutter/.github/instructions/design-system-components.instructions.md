```instructions
---
applyTo: "**/*.dart"
---
# Design System — Component Catalog

> 16 core components that form the building blocks of all VTT apps.
> Components live in `lib/design_system/` or `lib/ui/widgets/`.
> Each component uses design tokens exclusively — zero hardcoded values.

---

## Component Rules

1. **All components use `AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`, `AppSizing`** — never raw values.
2. **All components support light & dark mode** via `context.colorScheme`.
3. **All interactive components trigger haptic feedback** (via ViewModel, not in widget).
4. **All components have `semanticLabel`** or are wrapped in `Semantics`.
5. **All components support loading, disabled, and error states** where applicable.

---

## 1. AppButton

| Variant | Usage | Style |
|---------|-------|-------|
| **Primary** | Main CTA ("Sauvegarder", "Continuer") | Filled primary, white text |
| **Secondary** | Alternative action | Outlined primary border, primary text |
| **Ghost** | Tertiary action | No border, primary text |
| **Destructive** | Delete, remove | Filled error red, white text |
| **Icon-only** | Compact action | Circular, icon centered |
| **Loading** | Async action in progress | Spinner replaces label, disabled |

```dart
AppButton(
  label: context.l10n.save,
  variant: AppButtonVariant.primary,
  onPressed: viewModel.save,
  isLoading: viewModel.busy(saveBusyKey),
)
```

**Rules**:
- Min width: 88dp. Min height: `AppSizing.touchTarget` (48dp).
- Border radius: `AppRadius.button` (4dp).
- Label style: `AppTypography.labelLarge`.

---

## 2. AppTextField

| Variant | Usage |
|---------|-------|
| **Outlined** | Default input style |
| **Filled** | On surfaces where outlined would blend |
| **Search** | With magnifying glass prefix icon |
| **Password** | With visibility toggle suffix |
| **Multiline** | TextArea with maxLines |
| **Error** | Red border + error message below |
| **Disabled** | Greyed out, non-interactive |

```dart
AppTextField(
  label: context.l10n.email,
  controller: viewModel.emailController,
  keyboardType: TextInputType.emailAddress,
  errorText: viewModel.emailError,
  prefixIcon: LucideIcons.mail,
)
```

**Rules**:
- Border radius: `AppRadius.input` (4dp).
- Min height: `AppSizing.touchTarget` (48dp).
- Error text: 12sp, `AppColors.error`, appears inline below field.
- Validation: on submit + inline after first error.

---

## 3. AppCard

| Variant | Usage |
|---------|-------|
| **Flat** | No elevation, used on elevated surfaces |
| **Elevated** | `AppShadows.sm`, main content cards |
| **Outlined** | Border only, subtle separation |
| **Interactive** | Tap action, ripple effect, scale feedback |
| **Glassmorphic** | Frosted glass, premium sections |

```dart
AppCard(
  variant: AppCardVariant.elevated,
  padding: EdgeInsets.all(AppSpacing.staticMd),
  onTap: () => viewModel.openDetail(item),
  child: content,
)
```

**Rules**:
- Border radius: `AppRadius.card` (8dp).
- Padding: `AppSpacing.staticMd` (16dp).
- Interactive cards: `AnimatedScale` on press (0.98 scale).

---

## 4. AppListTile

| Variant | Usage |
|---------|-------|
| **Simple** | Title only |
| **With subtitle** | Title + secondary text |
| **With trailing** | Right-side widget (chevron, switch, badge) |
| **With leading icon** | Left icon or avatar |
| **Swipeable** | Slidable with delete/edit actions |

```dart
AppListTile(
  leading: Icon(LucideIcons.target, size: AppSizing.iconLg, semanticLabel: context.l10n.habit),
  title: habit.name,
  subtitle: habit.category,
  trailing: AppBadge.status(isCompleted: habit.done),
  onTap: () => viewModel.openHabit(habit.id),
)
```

---

## 5. AppBadge

| Variant | Usage |
|---------|-------|
| **Count** | Notification count (red dot + number) |
| **Status dot** | Online/offline, active/inactive indicator |
| **Text label** | Category label, role badge ("Admin", "Pro") |

---

## 6. AppChip

| Variant | Usage |
|---------|-------|
| **Filter** | Active/inactive toggle for filtering lists |
| **Action** | Performs an action on tap |
| **Input** | Removable tag (x to remove) |
| **Selectable** | Multi-select with checkmark |

**Rules**:
- Border radius: `AppRadius.chip` (4dp).
- Height: 32dp.
- Selected state: primary fill, white text.
- Unselected state: outlined, onSurface text.

---

## 7. AppToggle

| Variant | Usage |
|---------|-------|
| **Switch** | On/off binary setting |
| **Checkbox** | Multi-select option |
| **Radio** | Single-select from group |

**Rules**: All toggles trigger `HapticFeedback.lightImpact()` on change.

---

## 8. AppProgress

| Variant | Usage |
|---------|-------|
| **Linear** | Form steps, download progress |
| **Circular** | Loading indicator |
| **Ring with percentage** | Habit completion, daily score |

```dart
AppProgress.ring(
  value: viewModel.dailyCompletion, // 0.0 to 1.0
  size: AppSizing.circularProgressLg,
  strokeWidth: AppSizing.linearProgressHeightLg,
  label: '${(viewModel.dailyCompletion * 100).toInt()}%',
)
```

---

## 9. AppEmptyState

| Variant | Usage |
|---------|-------|
| **With illustration** | Full empty state (SVG + title + desc + CTA) |
| **Without illustration** | Compact (title + desc + CTA) |
| **With CTA** | Actionable ("Ajoute ta première habitude") |
| **Compact** | Inline in cards (smaller text, no illustration) |

```dart
AppEmptyState(
  illustration: AppIllustrations.emptyList,
  title: context.l10n.noHabitsYet,
  description: context.l10n.createFirstHabitPrompt,
  ctaLabel: context.l10n.addHabit,
  onCtaPressed: viewModel.navigateToAddHabit,
)
```

---

## 10. AppBottomNav

| Variant | Usage |
|---------|-------|
| **3-tab** | Simple apps |
| **4-tab** | Standard (recommended) |
| **5-tab** | Content-heavy apps |
| **With FAB notch** | When FAB overlaps bottom nav |

**Rules**:
- Max 5 tabs.
- Icons: Lucide, `AppSizing.iconLg` (24dp).
- Labels: Always visible below icons (`AppTypography.labelSmall`).
- Active icon: Filled variant + primary color.
- Inactive icon: Outlined + `onSurfaceVariant`.
- Animated indicator: Underline or dot under active tab.

---

## 11. AppSnackbar / Toast

| Variant | Usage | Color |
|---------|-------|-------|
| **Info** | Neutral message | `AppColors.info` |
| **Success** | Positive confirmation | `AppColors.success` |
| **Warning** | Cautionary info | `AppColors.warning` |
| **Error** | Something went wrong | `AppColors.error` |
| **With action** | Undo, retry | + Text button |

**Rules**: Duration 3s (info/success), 5s (error with undo action). Bottom-positioned.

---

## 12. AppDialog

| Variant | Usage |
|---------|-------|
| **Confirmation** | "Es-tu sûr ?" → Confirm/Cancel |
| **Destructive** | Red CTA for irreversible actions |
| **Input** | Text field inside dialog |
| **Custom** | Any custom content |

**Rules**:
- Border radius: `AppRadius.md` (12dp).
- Max width: 320dp.
- Title: `AppTypography.headingSmall`.
- Actions: Right-aligned. Destructive button is red.

---

## 13. AppBottomSheet

| Variant | Usage |
|---------|-------|
| **Standard** | With handle bar, drag to dismiss |
| **Scrollable** | Long content with DraggableScrollableSheet |
| **Action sheet** | List of actions (iOS-style) |

**Rules**:
- Top radius: `AppRadius.xl` (24dp).
- Handle bar: 40×4dp, centered, `outlineVariant` color.
- Max height: 90% of screen.

---

## 14. AppAvatar

| Variant | Usage |
|---------|-------|
| **Image** | User photo (NetworkImage) |
| **Initials** | Fallback when no image (first + last initial) |
| **Icon** | Fallback with placeholder icon |
| **With badge** | Online status dot overlay |
| **Group** | Overlapping stack (max 3 + "+N") |

---

## 15. AppDivider

| Variant | Usage |
|---------|-------|
| **Horizontal** | Standard section separator |
| **With label** | "— OR —" between sections |
| **Section** | Thicker, with vertical margin |

**Rules**: Thickness 0.5px. Color: `context.colorScheme.outlineVariant`.

---

## 16. AppSkeleton

| Variant | Usage |
|---------|-------|
| **Text** | Shimmer line placeholder |
| **Card** | Full card placeholder |
| **List** | 3–5 shimmer rows |
| **Circle** | Avatar placeholder |
| **Custom** | Any shape via `ClipPath` |

```dart
// ✅ Show skeleton during initial load
if (viewModel.isBusy && viewModel.items.isEmpty) {
  return AppSkeleton.list(itemCount: 5);
}
```

**Rules**: Shimmer color: surface + 10% lighter. Animation: 1.5s cycle, left-to-right.

---

## 17. AppDropdown

Styled dropdown selector, consistent with design system tokens.

| Prop | Type | Description |
|------|------|-------------|
| `items` | `List<DropdownItem<T>>` | List of selectable options |
| `value` | `T?` | Currently selected value |
| `onChanged` | `ValueChanged<T?>` | Selection callback |
| `label` | `String?` | Field label |
| `hint` | `String?` | Placeholder text |
| `errorText` | `String?` | Validation error |
| `isExpanded` | `bool` | Full width (default: `true`) |

```dart
AppDropdown<String>(
  label: context.l10n.habitType,
  hint: context.l10n.selectType,
  value: viewModel.selectedType,
  items: viewModel.types.map((t) => DropdownItem(
    value: t.name,
    label: t.displayName,
  )).toList(),
  onChanged: viewModel.setType,
  errorText: viewModel.typeError,
)
```

**Rules**: Use `AppDropdown` instead of raw `DropdownButtonFormField`. Style inherits from `AppTextField` (same border radius, padding, font).

---

## Usage Decision Tree

```
Need a primary action?          → AppButton.primary
Need user input?                → AppTextField
Need a selection from a list?   → AppDropdown
Need to display data?           → AppCard + AppListTile
Need status indicator?          → AppBadge
Need filtering?                 → AppChip.filter
Need on/off?                    → AppToggle.switch
Need progress?                  → AppProgress (linear/ring)
Need empty state?               → AppEmptyState
Need navigation?                → AppBottomNav
Need feedback message?          → AppSnackbar
Need user confirmation?         → AppDialog
Need extra options?             → AppBottomSheet
Need user identity?             → AppAvatar
Need separation?                → AppDivider
Need loading placeholder?       → AppSkeleton
```
