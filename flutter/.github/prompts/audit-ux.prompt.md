```prompt
# Audit UX Quality

Run a comprehensive UX audit on a feature or the entire app, producing scores and actionable fixes.

## Target

- **Scope**: ${{input:Feature path (e.g., lib/features/habits/) or 'all' for the entire app}}

## Audit Dimensions (Score /10 each)

### 1. Dark Mode Compliance
- Scan for `textSecondaryLight`, `textPrimaryLight`, `textTertiaryLight` and all `*Light`/`*Dark` direct references
- Scan for `Colors.white`, `Colors.black`, `Colors.grey`
- Scan for `neutral400`, `neutral500`, `neutral600` direct usage
- Check if `brightness` helpers are used
- Score: 10 = zero violations, 0 = 20+ violations

### 2. Animation Coverage
- Check for `AnimatedSwitcher` on state-driven content
- Check for `AnimatedScale` / `AnimatedContainer` on togglable elements
- Check for `TweenAnimationBuilder` on changing values
- Check if `AppAnimations` tokens are used (not raw Duration/Curves)
- Score: 10 = all state changes animated, 0 = no animations

### 3. Haptic Feedback
- Check all public ViewModel methods for `HapticFeedback` calls
- Verify success → mediumImpact, error → heavyImpact, selection → selectionClick
- Score: 10 = all actions covered, 0 = no haptic

### 4. Accessibility
- Count `Semantics` widgets in views
- Check `Icon` widgets for `semanticLabel`
- Check touch targets (≥ 48dp)
- Check for `ExcludeSemantics` on decorative elements
- Score: 10 = fully annotated, 0 = no semantics

### 5. Internationalization
- Grep for hardcoded strings in views (`Text('...'` without `context.l10n`)
- Check for emoji-prefixed labels
- Check for mixed language strings
- Score: 10 = zero hardcoded, 0 = pervasive hardcoding

### 6. Token Discipline
- Check colors: all via `AppColors` helpers (not Light/Dark direct)
- Check spacing: all via `AppSpacing` / `AppGaps`
- Check typography: all via `AppTypography` (not raw `TextStyle`)
- Check sizing: all via `AppSizing` (not magic numbers)
- Score: 10 = zero violations, 0 = pervasive hardcoding

### 7. Gesture Support
- Check for `RefreshIndicator` on data lists
- Check for `Slidable` or `Dismissible` on list items
- Check for long-press handlers
- Score: 10 = all patterns applied, 0 = tap-only

### 8. Error/Empty/Loading States
- Check views handle `isBusy` (loading)
- Check views handle `hasError` (error with retry)
- Check views handle empty lists (`AppEmptyState`)
- Score: 10 = all states handled, 0 = no state handling

## Output Format

```markdown
## UX Audit Report — [Scope]

| # | Criterion | Score /10 | Violations | Priority |
|---|---|---|---|---|
| 1 | Dark Mode | X | N violations | P0/P1/P2 |
| 2 | Animations | X | ... | ... |
| ... |

### Detailed Findings

#### [Criterion]: [Score]/10

**Violations:**
- `file.dart:L42` — Description of violation
- ...

**Fix:**
- Description of what to do
```

## After Audit

Suggest running these prompts to fix issues:
1. `/fix-dark-mode` for dark mode violations
2. `/add-animations` for missing animations
3. `/add-haptics` for missing haptic feedback
4. `/add-accessibility` for missing semantics
5. `/add-gestures` for missing gestures
```
