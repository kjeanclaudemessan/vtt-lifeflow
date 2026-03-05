```prompt
# Fix Dark Mode Violations

Scan and fix all dark mode violations in the specified file or scope.

## Target

- **Scope**: ${{input:File path or folder to scan (e.g., lib/modules/auth/ or lib/features/today/views/today_view.dart)}}

## Instructions

### Step 1: Identify Violations

Search for these patterns in the target scope:

1. `AppColors.textSecondaryLight` → replace with `AppColors.textSecondary(Theme.of(context).brightness)`
2. `AppColors.textPrimaryLight` → replace with `AppColors.textPrimary(Theme.of(context).brightness)`
3. `AppColors.textTertiaryLight` → replace with `AppColors.textTertiary(Theme.of(context).brightness)`
4. `AppColors.textSecondaryDark` → replace with `AppColors.textSecondary(Theme.of(context).brightness)`
5. `AppColors.textPrimaryDark` → replace with `AppColors.textPrimary(Theme.of(context).brightness)`
6. `Colors.white` → replace with `Theme.of(context).colorScheme.surface` (or `AppColors.white` if on primary background)
7. `Colors.black` → replace with `Theme.of(context).colorScheme.onSurface` (or `AppColors.black` if on light-only context)
8. `AppColors.neutral400` / `neutral500` / `neutral600` → replace with `AppColors.contrastMedium(brightness)` or similar semantic helper
9. `AppColors.contrastHighLight` / `contrastMediumLight` / `contrastLowLight` → replace with brightness-aware helpers
10. `AppColors.surfaceLight` / `surfaceDark` → replace with `AppColors.surface(brightness)` or `Theme.of(context).colorScheme.surface`
11. `AppColors.backgroundLight` / `backgroundDark` → replace with `Theme.of(context).colorScheme.surface`
12. `AppColors.borderLight` / `borderDark` → replace with `AppColors.border(brightness)`

### Step 2: Add Brightness Variable

If the file doesn't already extract `brightness`, add it at the top of the builder or build method:

```dart
final brightness = Theme.of(context).brightness;
```

For extracted methods that use colors, pass `brightness` as parameter:

```dart
Widget _buildHeader(BuildContext context, Brightness brightness) { ... }
```

### Step 3: Check for Missing Helpers

If `AppColors` doesn't have a helper for a needed pattern (e.g., `surfaceSecondary(brightness)`), add it to `lib/design_system/tokens/app_colors.dart` following the existing pattern:

```dart
static Color surfaceSecondary(Brightness brightness) =>
    brightness == Brightness.light ? surfaceSecondaryLight : surfaceSecondaryDark;
```

### Step 4: Verify

After fixes, run:

```bash
grep -rn "textSecondaryLight\|textPrimaryLight\|textTertiaryLight\|Colors\.white\|Colors\.black" <target>
```

Report should show 0 matches (excluding design_showcase).

## Exclusions

- `design_system/tokens/` → These DEFINE the colors, don't change them
- `design_showcase_view.dart` → Intentionally shows both Light/Dark variants
- `AppColors.onPrimary` (white on primary) → This is correct, don't change
```
