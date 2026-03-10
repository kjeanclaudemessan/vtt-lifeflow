```instructions
---
applyTo: "**/*.dart,**/CHANGELOG.md,**/pubspec.yaml"
---
# Design System — Versioning & Governance (Phase 37)

> The design system is a **shared product** used by 200+ apps.
> It MUST be versioned, documented, and governed like a package.
> Breaking changes require migration guides. All apps stay in sync.

---

## Semantic Versioning (37.1)

The design system follows strict [SemVer](https://semver.org/):

```
MAJOR.MINOR.PATCH
  │      │     └─ Bug fixes, typo corrections, no API change
  │      └─── New tokens, new components, new variants (backward-compatible)
  └──────── Breaking changes: renamed tokens, removed components, API changes
```

### Version Examples

| Change | Version bump | Example |
|--------|-------------|---------|
| Fix `AppButton` padding on dark mode | `1.0.0` → `1.0.1` | Patch |
| Add `AppChip.outline` variant | `1.0.1` → `1.1.0` | Minor |
| Add new `AppTimePicker` component | `1.1.0` → `1.2.0` | Minor |
| Rename `AppColors.grey` → `AppColors.neutral` | `1.2.0` → `2.0.0` | Major |
| Remove `AppCard.flat` variant | `2.0.0` → `3.0.0` | Major |
| Add new instruction file | No version bump | Doc only |

### Current Version

```yaml
# In pubspec.yaml (or ds_version.dart)
# design_system_version: 1.0.0
```

```dart
// lib/design_system/ds_version.dart
class DesignSystemVersion {
  static const String version = '1.0.0';
  static const String releaseDate = '2026-01-15';
  static const String minFlutterSdk = '3.8.0';
}
```

---

## Breaking Changes (37.2)

### What Counts as Breaking

| Change type | Breaking? | Action required |
|-------------|----------|-----------------|
| Rename a token (`AppColors.grey` → `AppColors.neutral`) | ✅ YES | Major bump + migration guide |
| Remove a component or variant | ✅ YES | Major bump + migration guide |
| Change component API (required param added) | ✅ YES | Major bump + migration guide |
| Change default value of a token | ⚠️ MAYBE | Minor if visual-only, Major if behavioral |
| Add new token/component | ❌ NO | Minor bump |
| Fix a bug | ❌ NO | Patch bump |
| Add new instruction file | ❌ NO | No version bump |

### Deprecation Process

Never remove immediately. Follow a 2-version deprecation cycle:

```dart
// ✅ CORRECT — deprecation with migration hint
@Deprecated('Use AppColors.neutral instead. Will be removed in v3.0.0.')
static const Color grey = Color(0xFF9E9E9E);

// New replacement
static const Color neutral = Color(0xFF9E9E9E);
```

```
v1.0.0: AppColors.grey exists (original)
v2.0.0: AppColors.grey deprecated, AppColors.neutral added (both work)
v3.0.0: AppColors.grey removed (breaking)
```

---

## Migration Guide (37.3)

Every major version bump produces a migration guide in `docs/migrations/`.

### Migration File Format

```
docs/migrations/
├── migration-v1-to-v2.md
├── migration-v2-to-v3.md
└── ...
```

### Migration Guide Template

```markdown
# Design System Migration: v1.x → v2.0

## Breaking Changes

### 1. `AppColors.grey` renamed to `AppColors.neutral`

**Before:**
```dart
color: AppColors.grey
```

**After:**
```dart
color: AppColors.neutral
```

**Find & Replace:** `AppColors.grey` → `AppColors.neutral`

---

### 2. `AppCard.flat` removed — use `AppCard.outlined` instead

**Before:**
```dart
AppCard.flat(child: content)
```

**After:**
```dart
AppCard.outlined(child: content)
```

---

## New Features (non-breaking)

- Added `AppTimePicker` component
- Added `AppChip.outline` variant
- Added `AppColors.premium` token (#D4A853)

## Automated Migration

Run the migration script:
```bash
dart run tools/migrate_ds_v2.dart
```
```

---

## Changelog (37.4)

Maintain a `CHANGELOG.md` in the design system directory.

### Format (Keep a Changelog)

```markdown
# Design System Changelog

All notable changes to the VTT Design System.

## [Unreleased]

### Added
- `AppTimePicker` component with hour/minute selection

### Changed
- `AppButton` padding adjusted from 12dp to 16dp horizontal

### Deprecated
- `AppColors.grey` — use `AppColors.neutral` instead

### Removed
- Nothing

### Fixed
- `AppCard` shadow not applying in dark mode

---

## [1.0.0] - 2026-01-15

### Added
- Initial design system release
- 12 core tokens (AppColors, AppTypography, AppSpacing, AppRadius, AppShadows, AppSizing, AppAnimations)
- 10 components (AppButton, AppCard, AppListTile, AppTextField, AppBottomSheet, AppDialog, AppBadge, AppProgress, AppEmptyState, AppAvatar)
- Brand Skin system (ThemeExtension<AppBrandSkin>, 12 tokens, 8 skins)
- UX Pack system (FlowPack, ProPack, CommunityPack)
- 14 instruction files
- 10 agent files
- 19 prompt files
```

---

## Shared Package Strategy (37.5)

### Architecture

The design system evolves from local code to a **shared Dart package** importable by all VTT apps.

```
Phase 1 (Current): Local copy in each app
  └── lib/design_system/ copied via VTT template

Phase 2 (Next): Private Git package
  └── vtt_design_system (git dependency in pubspec.yaml)
  └── All apps point to same git repo + version tag

Phase 3 (Future): Published package
  └── vtt_design_system on private pub server
  └── Version pinning via pubspec.yaml
```

### pubspec.yaml (Phase 2)

```yaml
# In each app's pubspec.yaml
dependencies:
  vtt_design_system:
    git:
      url: https://github.com/vtt-org/vtt_design_system.git
      ref: v1.0.0  # pinned to version tag
```

### Package Structure

```
vtt_design_system/
├── lib/
│   ├── vtt_design_system.dart     # barrel export
│   ├── tokens/                    # AppColors, AppTypography, etc.
│   ├── components/                # AppButton, AppCard, etc.
│   ├── skins/                     # AppBrandSkin, individual skins
│   ├── services/                  # HapticService, CelebrationService
│   └── extensions/                # context extensions
├── test/
├── example/                       # Widgetbook demo app
├── CHANGELOG.md
├── pubspec.yaml
└── README.md
```

### Rules

| Rule | Value |
|------|-------|
| Version pinning | Always pin to exact version (`ref: v1.0.0`), never `main` |
| Update process | Bump version tag → update `ref` in apps → test → deploy |
| No app-specific code | Package contains ONLY generic design system |
| Skin registration | Skins still live in the package (shared across apps) |
| App-specific overrides | Apps extend via `ThemeExtension`, never modify package directly |

---

## Widgetbook / Component Catalogue (37.6)

A dedicated demo app to visualize all DS components, tokens, and skins.

### Widgetbook Setup

```yaml
# In vtt_design_system/example/pubspec.yaml
dependencies:
  widgetbook: ^3.7.0
  widgetbook_annotation: ^3.1.0
  vtt_design_system:
    path: ../
```

### what to showcase

| Category | Items |
|----------|-------|
| **Tokens** | Colors (light/dark), Typography scale, Spacing scale, Radius, Shadows, Sizing |
| **Components** | AppButton (all variants), AppCard (all variants), AppTextField, AppListTile, AppBadge, AppProgress, AppEmptyState, AppDialog, AppBottomSheet, AppAvatar |
| **States** | Loading (skeleton), Error, Empty, Disabled, Focused, Pressed |
| **Brand Skins** | All 8 skins side by side (LifeFlow, IronFlow, SpiritFlow...) |
| **UX Patterns** | Auth flow mockup, Settings, Search, Notifications, Paywall |
| **Dark Mode** | Every component in light AND dark mode |
| **Responsive** | Breakpoint demos (compact, medium, expanded) |

### Widgetbook Use Cases

```dart
// ✅ CORRECT — Widgetbook use case for AppButton
@UseCase(name: 'Primary Button', type: AppButton)
Widget primaryButton(BuildContext context) {
  return AppButton(
    label: context.knobs.string(label: 'Label', initialValue: 'Enregistrer'),
    variant: context.knobs.list(
      label: 'Variant',
      options: AppButtonVariant.values,
      initialOption: AppButtonVariant.primary,
    ),
    isLoading: context.knobs.boolean(label: 'Loading', initialValue: false),
    onPressed: () {},
  );
}
```

### Widgetbook Addons

| Addon | Purpose |
|-------|---------|
| **ThemeAddon** | Switch between light/dark mode |
| **DeviceFrameAddon** | Preview on different device sizes |
| **LocalizationAddon** | Switch between FR/EN/AR |
| **TextScaleAddon** | Test accessibility text scaling |
| **AlignmentAddon** | Test component alignment |

---

## Governance Checklist

- [ ] Design system has a version number in `ds_version.dart`
- [ ] CHANGELOG.md is maintained with every change
- [ ] Breaking changes follow 2-version deprecation cycle
- [ ] Migration guides exist for every major version
- [ ] All apps pin to a specific DS version (not `main`)
- [ ] Widgetbook showcases all components, tokens, and skins
- [ ] Widgetbook tests both light and dark mode
- [ ] No app-specific code in the design system package
- [ ] Version bump PR reviewed by at least 1 team member
- [ ] CI runs Widgetbook build + golden tests on DS changes
```
