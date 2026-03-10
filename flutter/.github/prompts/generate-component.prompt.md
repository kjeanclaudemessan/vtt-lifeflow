```prompt
# Generate Design System Component

Generate a new design system component following VTT Design Kit conventions, including the widget code, documentation, and tests.

## Input

- **Component Name**: ${{input:Component name in PascalCase (e.g., AppRatingBar, AppTimePicker)}}
- **Description**: ${{input:Brief description of what the component does}}
- **Variants**: ${{input:List of variants (e.g., "filled, outlined, compact") or 'single' for no variants}}

## Instructions

### Step 1 — Gather Context

Before generating, read existing components for patterns:

1. Read `lib/ui/widgets/` to see existing widget structure.
2. Read at least 2 existing DS components (e.g., `app_button.dart`, `app_card.dart`) to match code style.
3. Read `lib/design_system/tokens/` to reference all available tokens.
4. Read `flutter/.github/instructions/design-system-components.instructions.md` for component rules.

### Step 2 — Apply Design System Rules

The component MUST follow these rules:

#### Tokens Only
```dart
// ✅ CORRECT
color: AppColors.primary,
padding: EdgeInsets.all(AppSpacing.staticMd),
borderRadius: AppRadius.sm,
style: AppTypography.bodyMd,

// ❌ FORBIDDEN
color: Color(0xFF0D9488),
padding: EdgeInsets.all(16),
borderRadius: BorderRadius.circular(8),
style: TextStyle(fontSize: 14),
```

#### Dark Mode Automatic
```dart
// ✅ Use context-aware colors
final colorScheme = Theme.of(context).colorScheme;
color: colorScheme.surface,
color: colorScheme.onSurface,

// ❌ Never reference *Light/*Dark directly
color: AppColors.surfaceLight,  // WRONG in widget code
```

#### Accessibility Mandatory
```dart
// Every interactive element
Semantics(
  label: semanticLabel ?? 'Component description',
  child: ...
)

// Touch targets
constraints: BoxConstraints(
  minWidth: AppSizing.touchTarget,   // 48dp
  minHeight: AppSizing.touchTarget,
),
```

#### Animation Required
```dart
// State changes must animate
AnimatedContainer(
  duration: AppAnimations.normal,
  curve: AppAnimations.curveStandard,
  ...
)
```

### Step 3 — Generate Widget File

Create: `lib/ui/widgets/{component_name_snake}.dart`

Follow this structure:

```dart
import 'package:flutter/material.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import '../../design_system/tokens/app_radius.dart';
import '../../design_system/tokens/app_sizing.dart';
import '../../design_system/tokens/app_animations.dart';
import '../../design_system/tokens/app_shadows.dart';

/// {Description}.
///
/// ## Variants
/// - `{Component}.{variant1}` — {description}
/// - `{Component}.{variant2}` — {description}
///
/// ## Usage
/// ```dart
/// {Component}(
///   {required params},
/// )
/// ```
///
/// ## Design System Compliance
/// - Tokens: AppColors, AppSpacing, AppTypography, AppRadius
/// - Dark mode: Automatic via colorScheme
/// - Accessibility: Semantic label, 48dp touch target
/// - Animation: State transitions animated
class {Component} extends StatelessWidget {
  const {Component}({
    super.key,
    // Required params first
    // Optional params with defaults
    this.semanticLabel,
  });

  // Named constructors for variants
  const {Component}.{variant}({
    super.key,
    this.semanticLabel,
  });

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: semanticLabel ?? '{default label}',
      child: // Widget tree using ONLY design tokens
    );
  }
}
```

### Step 4 — Generate Test File

Create: `test/ui/widgets/{component_name_snake}_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{app}/ui/widgets/{component_name_snake}.dart';

void main() {
  group('{Component}', () {
    // 1. Renders correctly
    testWidgets('renders default variant', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: {Component}(/* required params */)),
        ),
      );
      expect(find.byType({Component}), findsOneWidget);
    });

    // 2. Each variant renders
    testWidgets('renders {variant} variant', (tester) async { ... });

    // 3. Accessibility
    testWidgets('has semantic label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: {Component}(semanticLabel: 'Test')),
        ),
      );
      expect(
        tester.getSemantics(find.byType({Component})),
        matchesSemantics(label: 'Test'),
      );
    });

    // 4. Touch target size
    testWidgets('meets minimum touch target', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: {Component}(/* params */)),
        ),
      );
      final size = tester.getSize(find.byType({Component}));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    });

    // 5. Dark mode
    testWidgets('renders correctly in dark mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(body: {Component}(/* params */)),
        ),
      );
      expect(find.byType({Component}), findsOneWidget);
    });
  });
}
```

### Step 5 — Generate Documentation

Add inline documentation in the widget file (already included in Step 3 template).

Additionally, suggest adding the component to `design-system-components.instructions.md`:

```markdown
### App{Component} (New)
| Variant | Usage |
|---------|-------|
| `.{variant1}` | {When to use} |
| `.{variant2}` | {When to use} |

**Props:** {key props}
**Tokens:** {which tokens it uses}
**A11y:** Semantic label, 48dp touch target
```

### Step 6 — Output Checklist

Before delivering:

- [ ] All colors via `AppColors` or `colorScheme`
- [ ] All spacing via `AppSpacing`
- [ ] All typography via `AppTypography`
- [ ] All radius via `AppRadius`
- [ ] All sizing via `AppSizing`
- [ ] All animations via `AppAnimations`
- [ ] `semanticLabel` parameter exists
- [ ] Touch target ≥ 48dp
- [ ] Dark mode works automatically (no `*Light`/`*Dark` references)
- [ ] State changes animated
- [ ] Named constructors for each variant
- [ ] Test file covers: render, variants, a11y, touch target, dark mode
- [ ] Doc comment with usage example

## References

- `flutter/.github/instructions/design-system-components.instructions.md`
- `flutter/.github/instructions/design-system-tokens.instructions.md`
- `flutter/.github/instructions/design-system-accessibility.instructions.md`
- `flutter/.github/instructions/design-system-motion.instructions.md`
- `flutter/.github/instructions/design-system-dark-mode.instructions.md`
```
