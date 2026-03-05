```instructions
---
applyTo: "**/*.dart"
---
# Accessibility Instructions

> These instructions apply to ALL Dart files.
> Ensures WCAG 2.1 AA compliance and screen reader support.

---

## Core Rule

**Every interactive or informative element MUST be accessible.**
Screen readers (TalkBack/VoiceOver) must convey the same information as the visual interface.

---

## Semantics Requirements

### Interactive Elements

Every tappable element must have a semantic label:

```dart
// ✅ REQUIRED — Semantics on custom tappable widgets
Semantics(
  label: 'Toggle habit: Morning meditation',
  hint: 'Double tap to mark as completed',
  toggled: isCompleted,
  child: GestureDetector(
    onTap: onToggle,
    child: _buildCheckArea(),
  ),
)

// ✅ REQUIRED — InkWell / GestureDetector wrappers
Semantics(
  button: true,
  label: 'Edit profile',
  child: InkWell(
    onTap: onEdit,
    child: Icon(Icons.edit),
  ),
)
```

### Icons

Every `Icon` widget must have a `semanticLabel`:

```dart
// ✅ REQUIRED
Icon(Icons.check, semanticLabel: 'Completed')
Icon(Icons.notifications, semanticLabel: 'Notifications')
Icon(Icons.arrow_back, semanticLabel: 'Go back')

// ❌ FORBIDDEN
Icon(Icons.check)  // No semantic label
Icon(Icons.notifications)
```

### Decorative Elements

Elements that add no information should be excluded:

```dart
// ✅ CORRECT — exclude decorative elements
ExcludeSemantics(
  child: Icon(Icons.circle, color: AppColors.primary, size: 8),
)

// ✅ CORRECT — exclude decorative images
Image.asset(
  'assets/images/decoration.png',
  semanticLabel: '',  // Empty = decorative
  excludeFromSemantics: true,
)
```

### Images

All informative images must have descriptions:

```dart
// ✅ REQUIRED
Image.asset(
  'assets/images/onboarding_1.png',
  semanticLabel: 'Person meditating in a peaceful garden',
)

// For SVG
SvgPicture.asset(
  'assets/images/empty_state.svg',
  semanticsLabel: 'No habits found illustration',
)
```

---

## Semantic Grouping

### Cards and List Items

Group related information into a single semantic node:

```dart
// ✅ REQUIRED — merge semantics for card content
Semantics(
  label: 'Habit: Morning meditation, completed 3 of 5 days this week',
  child: MergeSemantics(
    child: AppCard(
      child: Column(
        children: [
          Text(habit.name),
          Text('${habit.completedDays}/5 days'),
          _buildProgressBar(habit.progress),
        ],
      ),
    ),
  ),
)
```

### Progress Indicators

```dart
// ✅ REQUIRED
Semantics(
  label: 'Daily progress: 75%',
  value: '75%',
  child: CircularProgressIndicator(value: 0.75),
)
```

---

## Contrast Requirements

### WCAG 2.1 AA Minimum Ratios

| Element | Minimum Ratio | Check |
|---|---|---|
| Normal text (< 18sp) | 4.5:1 | Required |
| Large text (≥ 18sp or ≥ 14sp bold) | 3:1 | Required |
| UI components (icons, borders) | 3:1 | Required |
| Decorative elements | No requirement | — |

### Danger Zones in Current Palette

```dart
// ⚠️ CHECK — these combinations may fail contrast:
// AppColors.textTertiary on AppColors.surface → verify ratio
// AppColors.contrastLow on AppColors.background → verify ratio
// AppColors.neutral400 on white → borderline (check in dark mode too)
```

---

## Touch Target Size

Minimum touch target: **48x48 dp** (Material Design guideline).

```dart
// ✅ REQUIRED — ensure minimum touch target
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(
    icon: Icon(Icons.edit),
    onPressed: onEdit,
  ),
)

// ❌ FORBIDDEN — too small (below 44x44)
SizedBox(
  width: 24,
  height: 24,
  child: GestureDetector(
    onTap: onTap,
    child: Icon(Icons.close, size: 16),
  ),
)
```

---

## Focus and Navigation

### Tab Order

Ensure logical tab order for keyboard/switch access:

```dart
// ✅ REQUIRED — explicit focus order when needed
FocusTraversalGroup(
  policy: OrderedTraversalPolicy(),
  child: Column(
    children: [
      FocusTraversalOrder(
        order: NumericFocusOrder(1),
        child: AppTextField(label: 'Email'),
      ),
      FocusTraversalOrder(
        order: NumericFocusOrder(2),
        child: AppTextField(label: 'Password'),
      ),
      FocusTraversalOrder(
        order: NumericFocusOrder(3),
        child: AppButton(label: 'Login', onPressed: onLogin),
      ),
    ],
  ),
)
```

---

## Text Scaling

Support system text size preferences:

```dart
// ✅ CORRECT — text scales with system settings
Text('Title', style: AppTypography.headlineLarge)  // Uses .sp internally

// ❌ FORBIDDEN — fixed text sizes
Text('Title', style: TextStyle(fontSize: 24))  // Won't scale
```

---

## Announcements

For dynamic content changes, announce to screen readers:

```dart
// ✅ REQUIRED — announce state changes
SemanticsService.announce(
  'Habit marked as completed',
  TextDirection.ltr,
);
```

---

## Checklist per View

Before submitting any view, verify:

- [ ] All `Icon` widgets have `semanticLabel`
- [ ] All `GestureDetector` / `InkWell` are wrapped in `Semantics`
- [ ] All images have `semanticLabel` (or `excludeFromSemantics: true`)
- [ ] All progress indicators have semantic `label` and `value`
- [ ] Touch targets are ≥ 48x48 dp
- [ ] Text uses `AppTypography` (not hardcoded `fontSize`)
- [ ] Decorative elements are excluded from semantics
- [ ] Dynamic state changes are announced
```
