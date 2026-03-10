import 'package:flutter/material.dart';

import 'ux_pack.dart';

/// ============================================================================
/// VTT DESIGN SYSTEM — BRAND SKIN
///
/// Each VTT app injects a unique visual identity through this ThemeExtension.
/// A skin = 12 design tokens that customize the Generic Core without any
/// code change in shared widgets.
///
/// ## Architecture
///
/// ```
/// ┌─────────────────────────────────────────────────────┐
/// │              Generic Core (shared)                   │
/// │  AppColors, AppTypography, AppSpacing, AppRadius     │
/// │  Components: AppButton, AppCard, AppListTile...      │
/// ├─────────────────────────────────────────────────────┤
/// │           Brand Skin (per app)                       │
/// │  12 tokens → ThemeExtension<AppBrandSkin>            │
/// │  LifeFlowSkin, IronFlowSkin, SpiritFlowSkin...       │
/// ├─────────────────────────────────────────────────────┤
/// │           UX Pack (per family)                       │
/// │  FlowPack, ProPack, CommunityPack                    │
/// │  Specialized widgets per app family                  │
/// └─────────────────────────────────────────────────────┘
/// ```
///
/// ## Usage
///
/// ```dart
/// // Access from any widget:
/// final skin = context.brandSkin;
/// final primary = skin.primary;
/// final name = skin.appName;
///
/// // Or via Theme:
/// final skin = Theme.of(context).extension<AppBrandSkin>()!;
/// ```
/// ============================================================================
@immutable
class AppBrandSkin extends ThemeExtension<AppBrandSkin> {
  /// Primary brand color (e.g. Teal #0D9488 for LifeFlow).
  final Color primary;

  /// Lighter variant of primary (hover states, subtle backgrounds).
  final Color primaryLight;

  /// Darker variant of primary (pressed states, emphasis).
  final Color primaryDark;

  /// Container color for primary (light: very light tint, dark: deep tint).
  final Color primaryContainer;

  /// Color for text/icons ON primary surfaces.
  final Color onPrimary;

  /// Secondary accent color (premium gold #D4A853, or app-specific).
  final Color accentColor;

  /// Display name of the app (e.g. "LifeFlow", "IronFlow").
  final String appName;

  /// Path to the app icon SVG asset (e.g. "assets/icons/lifeflow.svg").
  final String appIcon;

  /// Which UX Pack this app belongs to (Flow, Pro, Community).
  final UxPack uxPack;

  /// Font family override. Defaults to "Inter" but skins can override.
  final String fontFamily;

  /// Whether dark mode is the default for this app.
  final bool darkModeDefault;

  /// Duration of the splash screen animation.
  final Duration splashDuration;

  /// Creates an [AppBrandSkin] with all 12 tokens.
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
    this.fontFamily = 'Inter',
    this.darkModeDefault = true,
    this.splashDuration = const Duration(milliseconds: 1500),
  });

  @override
  AppBrandSkin copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? primaryContainer,
    Color? onPrimary,
    Color? accentColor,
    String? appName,
    String? appIcon,
    UxPack? uxPack,
    String? fontFamily,
    bool? darkModeDefault,
    Duration? splashDuration,
  }) {
    return AppBrandSkin(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      accentColor: accentColor ?? this.accentColor,
      appName: appName ?? this.appName,
      appIcon: appIcon ?? this.appIcon,
      uxPack: uxPack ?? this.uxPack,
      fontFamily: fontFamily ?? this.fontFamily,
      darkModeDefault: darkModeDefault ?? this.darkModeDefault,
      splashDuration: splashDuration ?? this.splashDuration,
    );
  }

  @override
  AppBrandSkin lerp(AppBrandSkin? other, double t) {
    if (other is! AppBrandSkin) return this;
    return AppBrandSkin(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      appName: t < 0.5 ? appName : other.appName,
      appIcon: t < 0.5 ? appIcon : other.appIcon,
      uxPack: t < 0.5 ? uxPack : other.uxPack,
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
      darkModeDefault: t < 0.5 ? darkModeDefault : other.darkModeDefault,
      splashDuration: Duration(
        milliseconds:
            (splashDuration.inMilliseconds +
                    (other.splashDuration.inMilliseconds -
                            splashDuration.inMilliseconds) *
                        t)
                .round(),
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppBrandSkin &&
        other.primary == primary &&
        other.primaryLight == primaryLight &&
        other.primaryDark == primaryDark &&
        other.primaryContainer == primaryContainer &&
        other.onPrimary == onPrimary &&
        other.accentColor == accentColor &&
        other.appName == appName &&
        other.appIcon == appIcon &&
        other.uxPack == uxPack &&
        other.fontFamily == fontFamily &&
        other.darkModeDefault == darkModeDefault &&
        other.splashDuration == splashDuration;
  }

  @override
  int get hashCode => Object.hash(
    primary,
    primaryLight,
    primaryDark,
    primaryContainer,
    onPrimary,
    accentColor,
    appName,
    appIcon,
    uxPack,
    fontFamily,
    darkModeDefault,
    splashDuration,
  );

  @override
  String toString() => 'AppBrandSkin(appName: $appName, primary: $primary)';
}

/// Convenience extension to access the brand skin from [BuildContext].
///
/// ```dart
/// final skin = context.brandSkin;
/// final primary = skin.primary;
/// ```
extension BrandSkinContext on BuildContext {
  /// Returns the active [AppBrandSkin] from the nearest [Theme].
  AppBrandSkin get brandSkin => Theme.of(this).extension<AppBrandSkin>()!;
}
