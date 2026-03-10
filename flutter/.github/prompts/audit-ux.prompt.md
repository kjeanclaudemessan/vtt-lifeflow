```prompt
# Audit UX Quality

> **⚠️ UPGRADED**: This prompt now uses the **12-dimension VTT Design Kit** audit system.
> For a screen-focused audit, see also `/audit-screen-design`.

Run a comprehensive UX audit on a feature or the entire app, producing scores and actionable fixes across **12 dimensions**.

## Target

- **Scope**: ${{input:Feature path (e.g., lib/features/habits/) or 'all' for the entire app}}

## Audit Dimensions (Score /10 each)

| # | Dimension | What to Check |
|---|-----------|---------------|
| 1 | Design Principles | ONE primary objective per screen, progressive disclosure, no dark patterns |
| 2 | Token Discipline | All colors via `AppColors`/`colorScheme`, spacing via `AppSpacing`, typography via `AppTypography`, sizing via `AppSizing`, radius via `AppRadius`, animations via `AppAnimations` |
| 3 | Dark Mode | No `*Light`/`*Dark` direct refs, no `Colors.white`/`black`/`grey`, surfaces from `colorScheme` |
| 4 | Component Usage | DS components (AppButton, AppCard, AppTextField...) not raw Material widgets |
| 5 | State Machine | Error → Loading → Empty → Content order, skeleton loading, human error messages + retry |
| 6 | Animation Coverage | `AnimatedSwitcher`, `AnimatedScale`, `TweenAnimationBuilder`, `AppAnimations` tokens |
| 7 | Haptic Feedback | All ViewModel actions have haptic (success=medium, error=heavy, selection=click, toggle=light) |
| 8 | Accessibility | `semanticLabel` on all icons/images, touch targets ≥ 48dp, no color-only info, WCAG AA |
| 9 | Navigation | Bottom nav with labels, no drawer, AppBar ≤ 2 actions, correct transitions |
| 10 | UX Writing / i18n | Zero hardcoded strings, `context.l10n`, action verb buttons, human error messages |
| 11 | Iconography | Lucide icons (not `Icons.*`), sizes via `AppSizing.icon*`, all have `semanticLabel` |
| 12 | Celebrations | Milestones trigger celebrations, no addiction patterns, message rotation |

## Output Format

```markdown
## UX Audit Report — [Scope]

| # | Dimension | Score /10 | Violations | Priority |
|---|-----------|-----------|------------|----------|
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
| 12 | Celebrations | X | N | Px |
| **Total** | | **/120** | **N** | |

### Weighted Score: X.X/10

### Detailed Findings

#### [Dimension]: [Score]/10

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
5. `/audit-screen-design` for a focused per-screen audit

## References

- All 14 `flutter/.github/instructions/design-system-*.instructions.md`
- `flutter/.github/agents/design-system-auditor.md` — Full auditor methodology
```
