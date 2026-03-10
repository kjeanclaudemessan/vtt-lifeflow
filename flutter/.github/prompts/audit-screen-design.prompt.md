```prompt
# Audit Screen Design System Compliance

Run a focused design system compliance audit on a specific screen or feature, checking all VTT Design Kit rules.

## Target

- **Screen or Feature**: ${{input:Screen path (e.g., lib/features/habits/presentation/views/habits_view.dart)}}

## Instructions

Audit the target screen against **all 12 dimensions** of the VTT Design Kit. Use `grep_search` and `read_file` to analyze the code.

## Audit Checklist

### 1. Design Principles
- [ ] Screen has ONE primary objective (not overloaded)
- [ ] Progressive disclosure (advanced features hidden behind tap)
- [ ] Destructive actions have confirmation dialog
- [ ] AI features display disclaimer and are dismissible
- [ ] No dark patterns (fake urgency, shame buttons, hidden costs)

### 2. Token Discipline
Grep for violations in the target file:

```
Color(0x                    → Must use AppColors
TextStyle(font              → Must use AppTypography
SizedBox(height:            → Must use AppGaps (unless in layout)
BorderRadius.circular       → Must use AppRadius
Duration(milliseconds       → Must use AppAnimations
BoxShadow(                  → Must use AppShadows
EdgeInsets(                 → Must use AppSpacing with EdgeInsets.all/symmetric
```

### 3. Dark Mode
- [ ] No `Colors.white`, `Colors.black`, `Colors.grey`
- [ ] No `*Light`/`*Dark` direct token references
- [ ] Background from `context.colorScheme.surface`
- [ ] Text colors from `context.colorScheme.onSurface` / `onSurfaceVariant`
- [ ] Shadows adapted for dark mode (use `AppShadows.forBrightness(context)`)

### 4. Component Usage
- [ ] Uses `AppButton` (not raw `ElevatedButton`/`TextButton`)
- [ ] Uses `AppCard` (not raw `Card`/`Container`)
- [ ] Uses `AppTextField` (not raw `TextField`)
- [ ] Uses `AppDialog` (not raw `AlertDialog`)
- [ ] Uses `AppSnackbar` (not raw `ScaffoldMessenger`)
- [ ] Uses `AppSkeleton` for loading (not `CircularProgressIndicator`)
- [ ] Bottom sheets have handle bars

### 5. State Machine
- [ ] Handles loading state (skeleton/shimmer)
- [ ] Handles error state (human message + retry CTA)
- [ ] Handles empty state (`AppEmptyState` with illustration + CTA)
- [ ] Handles offline state (banner if applicable)
- [ ] State check order: `hasError` → `isBusy` → `isEmpty` → content

### 6. Animations
- [ ] State transitions use `AnimatedSwitcher`
- [ ] Toggles use `AnimatedScale` or `AnimatedContainer`
- [ ] Counters/values use `TweenAnimationBuilder`
- [ ] List items stagger with 50ms delay
- [ ] `AppAnimations` tokens used (durations + curves)
- [ ] `MediaQuery.disableAnimations` respected

### 7. Haptic Feedback
- [ ] Every ViewModel action calls appropriate haptic
- [ ] Success → `HapticFeedback.mediumImpact()`
- [ ] Error → `HapticFeedback.heavyImpact()`
- [ ] Selection → `HapticFeedback.selectionClick()`
- [ ] Haptic called from ViewModel (not View)

### 8. Accessibility
- [ ] Every `Icon` has `semanticLabel`
- [ ] Every `Image`/`SvgPicture` has `semanticLabel`
- [ ] Touch targets ≥ 48dp (`AppSizing.touchTarget`)
- [ ] No color-only information (always icon/text too)
- [ ] Decorative elements in `ExcludeSemantics`
- [ ] Semantic traversal order is logical

### 9. Navigation
- [ ] Correct transition type (push=slide, modal=bottom, replace=fade)
- [ ] AppBar has ≤ 2 actions
- [ ] Back button is arrow (push screens) or X (modals)
- [ ] No raw `Navigator.push` — uses router

### 10. UX Writing
- [ ] Zero hardcoded user-facing strings
- [ ] All text via `context.l10n.*`
- [ ] Button labels are action verbs
- [ ] Error messages are human-readable with next-action
- [ ] Dates use relative format when < 24h

### 11. Iconography
- [ ] Uses Lucide icons (not `Icons.*`)
- [ ] Icon sizes via `AppSizing.icon*`
- [ ] All icons have `semanticLabel`

### 12. Brand Skin Compliance
- [ ] Primary color from `AppBrandSkin` (not hardcoded)
- [ ] No cross-skin color contamination
- [ ] Accent color only for premium features

## Output Format

```markdown
## Design System Audit — [Screen Name]

### Overall Score: X.X/10

| # | Dimension | Score /10 | Violations | Fix Priority |
|---|-----------|-----------|------------|--------------|
| 1 | Principles | X | N | Px |
| 2 | Tokens | X | N | Px |
| 3 | Dark Mode | X | N | Px |
| 4 | Components | X | N | Px |
| 5 | States | X | N | Px |
| 6 | Animations | X | N | Px |
| 7 | Haptics | X | N | Px |
| 8 | Accessibility | X | N | Px |
| 9 | Navigation | X | N | Px |
| 10 | UX Writing | X | N | Px |
| 11 | Icons | X | N | Px |
| 12 | Brand Skin | X | N | Px |
| **Total** | | **/120** | - | - |

### Critical Fixes (P0)
{List with file:line references and exact fix}

### Important Fixes (P1)
{List with file:line references}

### Nice-to-Have (P2)
{List}
```

## References

- `flutter/.github/instructions/design-system-*.instructions.md` — All 14 instruction files
- `flutter/.github/agents/design-system-auditor.md` — Full auditor methodology
```
