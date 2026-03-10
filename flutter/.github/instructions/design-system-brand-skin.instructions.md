```instructions
---
applyTo: "**/*.dart"
---
# Design System — Brand Skin System

> Each VTT app gets a unique visual identity through a Brand Skin.
> A skin = 12 design tokens injected via ThemeExtension.
> Generic Core stays identical — only the skin changes.

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│              Generic Core (shared)               │
│  AppColors, AppTypography, AppSpacing, AppRadius │
│  AppShadows, AppAnimations, AppSizing            │
│  Components: AppButton, AppCard, AppListTile...  │
├─────────────────────────────────────────────────┤
│           Brand Skin (per app)                   │
│  12 tokens → ThemeExtension<AppBrandSkin>        │
│  LifeFlowSkin, IronFlowSkin, SpiritFlowSkin...   │
├─────────────────────────────────────────────────┤
│           UX Pack (per family)                   │
│  FlowPack, ProPack, CommunityPack               │
│  Specialized widgets per app family              │
└─────────────────────────────────────────────────┘
```

---

## The 12 Skin Tokens

| # | Token | Type | Example (LifeFlow) |
|---|-------|------|--------------------|
| 1 | `primary` | `Color` | `#0D9488` (Teal) |
| 2 | `primaryLight` | `Color` | `#14B8A6` |
| 3 | `primaryDark` | `Color` | `#0F766E` |
| 4 | `primaryContainer` | `Color` | `#E6F7F5` (L) / `#042F2E` (D) |
| 5 | `onPrimary` | `Color` | `#FFFFFF` |
| 6 | `accentColor` | `Color` | `#D4A853` (Gold premium) |
| 7 | `appName` | `String` | `"LifeFlow"` |
| 8 | `appIcon` | `String` | `"assets/icons/lifeflow.svg"` |
| 9 | `uxPack` | `UxPack` | `UxPack.flow` |
| 10 | `fontFamily` | `String` | `"Inter"` (can override) |
| 11 | `darkModeDefault` | `bool` | `true` |
| 12 | `splashDuration` | `Duration` | `Duration(milliseconds: 1500)` |

---

## ThemeExtension Implementation

```dart
@immutable
class AppBrandSkin extends ThemeExtension<AppBrandSkin> {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color primaryContainer;
  final Color onPrimary;
  final Color accentColor;
  final String appName;
  final String appIcon;
  final UxPack uxPack;
  final String fontFamily;
  final bool darkModeDefault;
  final Duration splashDuration;

  const AppBrandSkin({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.primaryContainer,
    required this.onPrimary,
    required this.accentColor,
    required this.appName,
    required this.appIcon,
    required this.uxPack,
    required this.fontFamily,
    required this.darkModeDefault,
    required this.splashDuration,
  });

  @override
  AppBrandSkin copyWith({...}) { ... }

  @override
  AppBrandSkin lerp(AppBrandSkin? other, double t) { ... }
}
```

### Access in Widgets

```dart
// ✅ CORRECT — access brand skin from theme
final skin = Theme.of(context).extension<AppBrandSkin>()!;

// Use skin tokens
Text(skin.appName, style: AppTypography.headingLarge);
Icon(color: skin.primary);
```

---

## Pre-Built Skins

### LifeFlow (Default / Fallback)

```dart
static const lifeFlow = AppBrandSkin(
  primary: Color(0xFF0D9488),       // Teal
  primaryLight: Color(0xFF14B8A6),
  primaryDark: Color(0xFF0F766E),
  primaryContainer: Color(0xFFE6F7F5),
  onPrimary: Color(0xFFFFFFFF),
  accentColor: Color(0xFFD4A853),   // Gold
  appName: 'LifeFlow',
  appIcon: 'assets/icons/lifeflow.svg',
  uxPack: UxPack.flow,
  fontFamily: 'Inter',
  darkModeDefault: true,
  splashDuration: Duration(milliseconds: 1500),
);
```

### IronFlow

```dart
static const ironFlow = AppBrandSkin(
  primary: Color(0xFFDC2626),       // Red
  primaryLight: Color(0xFFEF4444),
  primaryDark: Color(0xFFB91C1C),
  primaryContainer: Color(0xFFFEE2E2),
  onPrimary: Color(0xFFFFFFFF),
  accentColor: Color(0xFFD4A853),
  appName: 'IronFlow',
  appIcon: 'assets/icons/ironflow.svg',
  uxPack: UxPack.flow,
  fontFamily: 'Inter',
  darkModeDefault: true,
  splashDuration: Duration(milliseconds: 1500),
);
```

### SpiritFlow

```dart
static const spiritFlow = AppBrandSkin(
  primary: Color(0xFF7C3AED),       // Violet
  primaryLight: Color(0xFF8B5CF6),
  primaryDark: Color(0xFF6D28D9),
  primaryContainer: Color(0xFFEDE9FE),
  onPrimary: Color(0xFFFFFFFF),
  accentColor: Color(0xFFD4A853),
  appName: 'SpiritFlow',
  appIcon: 'assets/icons/spiritflow.svg',
  uxPack: UxPack.flow,
  fontFamily: 'Inter',
  darkModeDefault: true,
  splashDuration: Duration(milliseconds: 1500),
);
```

### MindFlow

```dart
static const mindFlow = AppBrandSkin(
  primary: Color(0xFF2563EB),       // Blue
  primaryLight: Color(0xFF3B82F6),
  primaryDark: Color(0xFF1D4ED8),
  primaryContainer: Color(0xFFDBEAFE),
  onPrimary: Color(0xFFFFFFFF),
  accentColor: Color(0xFFD4A853),
  appName: 'MindFlow',
  appIcon: 'assets/icons/mindflow.svg',
  uxPack: UxPack.flow,
  fontFamily: 'Inter',
  darkModeDefault: true,
  splashDuration: Duration(milliseconds: 1500),
);
```

### WealthFlow

```dart
static const wealthFlow = AppBrandSkin(
  primary: Color(0xFF059669),       // Emerald
  primaryLight: Color(0xFF10B981),
  primaryDark: Color(0xFF047857),
  primaryContainer: Color(0xFFD1FAE5),
  onPrimary: Color(0xFFFFFFFF),
  accentColor: Color(0xFFD4A853),
  appName: 'WealthFlow',
  appIcon: 'assets/icons/wealthflow.svg',
  uxPack: UxPack.flow,
  fontFamily: 'Inter',
  darkModeDefault: true,
  splashDuration: Duration(milliseconds: 1500),
);
```

### HustlePro

```dart
static const hustlePro = AppBrandSkin(
  primary: Color(0xFFF59E0B),       // Amber
  primaryLight: Color(0xFFFBBF24),
  primaryDark: Color(0xFFD97706),
  primaryContainer: Color(0xFFFEF3C7),
  onPrimary: Color(0xFF000000),     // Dark text on amber
  accentColor: Color(0xFFD4A853),
  appName: 'HustlePro',
  appIcon: 'assets/icons/hustlepro.svg',
  uxPack: UxPack.pro,
  fontFamily: 'Inter',
  darkModeDefault: true,
  splashDuration: Duration(milliseconds: 1500),
);
```

---

## Injection

### In `main.dart` / `bootstrap.dart`

```dart
MaterialApp(
  theme: AppTheme.light(skin: AppBrandSkin.lifeFlow),
  darkTheme: AppTheme.dark(skin: AppBrandSkin.lifeFlow),
  themeMode: skin.darkModeDefault ? ThemeMode.dark : ThemeMode.system,
)
```

### In `AppTheme`

```dart
class AppTheme {
  static ThemeData dark({required AppBrandSkin skin}) {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: skin.primary,
        onPrimary: skin.onPrimary,
        // ... map all skin tokens to colorScheme
      ),
      extensions: [skin],
    );
  }
}
```

---

## Hot-Swap (Preview Mode)

Skins CAN be changed at runtime for preview/demo purposes:

```dart
// In a demo/preview screen — change skin dynamically
setState(() {
  _currentSkin = AppBrandSkin.ironFlow;
});
```

This is for development/demo only — in production, each app has ONE fixed skin.

---

## Fallback Strategy

If a skin token is not defined or null → **LifeFlow skin is the fallback**.

```dart
final skin = Theme.of(context).extension<AppBrandSkin>() ?? AppBrandSkin.lifeFlow;
```

---

## Rules

1. **Each app has exactly ONE skin** — no runtime switching in production.
2. **12 tokens only** — do NOT add custom tokens per app. If you need more, it goes in the Generic Core.
3. **No sub-skins per module** — chat module, AI module use the same skin.
4. **LifeFlow is always the fallback** — if skin resolution fails, LifeFlow renders correctly.
5. **Skin files live in** `lib/design_system/skins/` — one file per app.
6. **Test every skin** in both light and dark mode before release.
```
