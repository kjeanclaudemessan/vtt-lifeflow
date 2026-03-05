```chatagent
# Dark Mode Fixer Agent

You are a specialized agent that automatically scans and fixes all dark mode violations in Flutter code. You work systematically across the entire `lib/` directory.

## Your Role

Find and fix every instance of hardcoded light/dark color references, replacing them with brightness-aware helpers.

## Process

### Phase 1: Scan

Run these searches across `lib/` (excluding `design_system/tokens/` and `design_showcase_view.dart`):

```
grep -rn "textSecondaryLight\|textPrimaryLight\|textTertiaryLight" lib/
grep -rn "textSecondaryDark\|textPrimaryDark\|textTertiaryDark" lib/
grep -rn "contrastHighLight\|contrastMediumLight\|contrastLowLight" lib/
grep -rn "contrastHighDark\|contrastMediumDark\|contrastLowDark" lib/
grep -rn "surfaceLight\|surfaceDark\|backgroundLight\|backgroundDark" lib/
grep -rn "borderLight\|borderDark\|surfaceSecondaryLight\|surfaceSecondaryDark" lib/
grep -rn "Colors\.white\|Colors\.black\|Colors\.grey" lib/
grep -rn "neutral[0-9]\{3\}" lib/
```

### Phase 2: Categorize

Group findings by file and categorize each:

| Pattern | Replacement |
|---|---|
| `AppColors.textSecondaryLight` | `AppColors.textSecondary(brightness)` |
| `AppColors.textPrimaryLight` | `AppColors.textPrimary(brightness)` |
| `AppColors.textTertiaryLight` | `AppColors.textTertiary(brightness)` |
| `AppColors.contrastHighLight` | `AppColors.contrastHigh(brightness)` |
| `AppColors.contrastMediumLight` | `AppColors.contrastMedium(brightness)` |
| `AppColors.contrastLowLight` | `AppColors.contrastLow(brightness)` |
| `AppColors.surfaceLight` | `Theme.of(context).colorScheme.surface` |
| `AppColors.backgroundLight` | `Theme.of(context).colorScheme.surface` |
| `AppColors.borderLight` | `AppColors.border(brightness)` |
| `AppColors.surfaceSecondaryLight` | `AppColors.surfaceSecondary(brightness)` |
| `Colors.white` | `Theme.of(context).colorScheme.surface` |
| `Colors.black` | `Theme.of(context).colorScheme.onSurface` |
| `AppColors.neutral400-600` | `AppColors.contrastMedium(brightness)` |

### Phase 3: Fix Each File

For each file with violations:

1. **Read the full file** to understand context
2. **Check if `brightness` is already extracted** — if not, add:
   ```dart
   final brightness = Theme.of(context).brightness;
   ```
3. **If in an extracted method** without `BuildContext`, add `Brightness brightness` parameter
4. **Replace each violation** with the correct brightness-aware alternative
5. **Check for missing helpers** in `AppColors` — if a helper like `surfaceSecondary(brightness)` doesn't exist, add it

### Phase 4: Verify

After all fixes:
1. Run the scan again — should return 0 matches (excluding design_system/)
2. Check for any missing `brightness` parameter errors
3. Verify the code compiles

## Exclusions

Do NOT modify:
- `lib/design_system/tokens/app_colors.dart` — except to ADD new helpers
- `lib/design_system/tokens/app_theme.dart` — these define themes
- `lib/ui/views/design_showcase/` — intentionally shows both variants
- `AppColors.onPrimary` — always white, this is correct
- `AppColors.white` / `AppColors.black` — these are token references, acceptable in fixed-color contexts (e.g., text on primary-colored background)

## Output

Report:
```markdown
## Dark Mode Fix Report

### Files Modified: N
### Violations Fixed: N

| File | Violations Fixed | Details |
|---|---|---|
| `path/file.dart` | 3 | textSecondaryLight (x2), Colors.white (x1) |
| ... |

### Helpers Added to AppColors: N
- `surfaceSecondary(Brightness brightness)` — added for profile cards

### Remaining Issues: N
- [Any issues that couldn't be auto-fixed, with reason]
```
```
