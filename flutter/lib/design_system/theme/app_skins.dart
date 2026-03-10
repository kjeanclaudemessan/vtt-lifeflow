import 'package:flutter/material.dart';

import 'app_brand_skin.dart';
import 'ux_pack.dart';

/// ============================================================================
/// VTT DESIGN SYSTEM — BRAND SKINS REGISTRY
///
/// Each VTT app has a static skin definition here.
/// The active skin is injected into AppTheme via ThemeExtension.
///
/// To add a new app:
/// 1. Create a static const AppBrandSkin below
/// 2. Add light + dark primaryContainer variants
/// 3. Reference it in your app's main.dart: `AppSkins.yourApp`
/// ============================================================================
abstract final class AppSkins {
  // ═══════════════════════════════════════════════════════════════════════════
  // FLOW FAMILY — Personal growth apps
  // ═══════════════════════════════════════════════════════════════════════════

  /// LifeFlow — Habit tracking & personal growth.
  /// Primary: Teal #0D9488
  static const lifeFlow = AppBrandSkin(
    primary: Color(0xFF0D9488),
    primaryLight: Color(0xFF14B8A6),
    primaryDark: Color(0xFF0F766E),
    primaryContainer: Color(0xFFE6F7F5), // light variant
    onPrimary: Color(0xFFFFFFFF),
    accentColor: Color(0xFFD4A853), // Premium gold
    appName: 'LifeFlow',
    appIcon: 'assets/icons/lifeflow.svg',
    uxPack: UxPack.flow,
  );

  /// LifeFlow dark container variant.
  static const _lifeFlowDarkContainer = Color(0xFF042F2E);

  /// IronFlow — Fitness & workout tracking.
  /// Primary: Red #DC2626
  static const ironFlow = AppBrandSkin(
    primary: Color(0xFFDC2626),
    primaryLight: Color(0xFFEF4444),
    primaryDark: Color(0xFFB91C1C),
    primaryContainer: Color(0xFFFEE2E2),
    onPrimary: Color(0xFFFFFFFF),
    accentColor: Color(0xFFD4A853),
    appName: 'IronFlow',
    appIcon: 'assets/icons/ironflow.svg',
    uxPack: UxPack.flow,
  );

  static const _ironFlowDarkContainer = Color(0xFF450A0A);

  /// SpiritFlow — Faith & spiritual growth.
  /// Primary: Purple #7C3AED
  static const spiritFlow = AppBrandSkin(
    primary: Color(0xFF7C3AED),
    primaryLight: Color(0xFF8B5CF6),
    primaryDark: Color(0xFF6D28D9),
    primaryContainer: Color(0xFFEDE9FE),
    onPrimary: Color(0xFFFFFFFF),
    accentColor: Color(0xFFD4A853),
    appName: 'SpiritFlow',
    appIcon: 'assets/icons/spiritflow.svg',
    uxPack: UxPack.flow,
  );

  static const _spiritFlowDarkContainer = Color(0xFF2E1065);

  /// MindFlow — Mindfulness & meditation.
  /// Primary: Blue #2563EB
  static const mindFlow = AppBrandSkin(
    primary: Color(0xFF2563EB),
    primaryLight: Color(0xFF3B82F6),
    primaryDark: Color(0xFF1D4ED8),
    primaryContainer: Color(0xFFDBEAFE),
    onPrimary: Color(0xFFFFFFFF),
    accentColor: Color(0xFFD4A853),
    appName: 'MindFlow',
    appIcon: 'assets/icons/mindflow.svg',
    uxPack: UxPack.flow,
  );

  static const _mindFlowDarkContainer = Color(0xFF1E3A5F);

  /// WealthFlow — Finance & wealth management.
  /// Primary: Emerald #059669
  static const wealthFlow = AppBrandSkin(
    primary: Color(0xFF059669),
    primaryLight: Color(0xFF10B981),
    primaryDark: Color(0xFF047857),
    primaryContainer: Color(0xFFD1FAE5),
    onPrimary: Color(0xFFFFFFFF),
    accentColor: Color(0xFFD4A853),
    appName: 'WealthFlow',
    appIcon: 'assets/icons/wealthflow.svg',
    uxPack: UxPack.flow,
  );

  static const _wealthFlowDarkContainer = Color(0xFF064E3B);

  // ═══════════════════════════════════════════════════════════════════════════
  // PRO FAMILY — Business apps
  // ═══════════════════════════════════════════════════════════════════════════

  /// HustlePro — Small business management.
  /// Primary: Amber #F59E0B
  static const hustlePro = AppBrandSkin(
    primary: Color(0xFFF59E0B),
    primaryLight: Color(0xFFFBBF24),
    primaryDark: Color(0xFFD97706),
    primaryContainer: Color(0xFFFEF3C7),
    onPrimary: Color(0xFF000000), // Dark text on bright yellow
    accentColor: Color(0xFFD4A853),
    appName: 'HustlePro',
    appIcon: 'assets/icons/hustlepro.svg',
    uxPack: UxPack.pro,
  );

  static const _hustleProDarkContainer = Color(0xFF451A03);

  /// ForgePro — Project management & invoicing.
  /// Primary: Slate #475569
  static const forgePro = AppBrandSkin(
    primary: Color(0xFF475569),
    primaryLight: Color(0xFF64748B),
    primaryDark: Color(0xFF334155),
    primaryContainer: Color(0xFFF1F5F9),
    onPrimary: Color(0xFFFFFFFF),
    accentColor: Color(0xFFD4A853),
    appName: 'ForgePro',
    appIcon: 'assets/icons/forgepro.svg',
    uxPack: UxPack.pro,
  );

  static const _forgeProDarkContainer = Color(0xFF0F172A);

  // ═══════════════════════════════════════════════════════════════════════════
  // COMMUNITY FAMILY — Collective platform apps
  // ═══════════════════════════════════════════════════════════════════════════

  /// ChurchFlow — Church management.
  /// Primary: Indigo #4F46E5
  static const churchFlow = AppBrandSkin(
    primary: Color(0xFF4F46E5),
    primaryLight: Color(0xFF6366F1),
    primaryDark: Color(0xFF4338CA),
    primaryContainer: Color(0xFFE0E7FF),
    onPrimary: Color(0xFFFFFFFF),
    accentColor: Color(0xFFD4A853),
    appName: 'ChurchFlow',
    appIcon: 'assets/icons/churchflow.svg',
    uxPack: UxPack.community,
  );

  static const _churchFlowDarkContainer = Color(0xFF1E1B4B);

  // ═══════════════════════════════════════════════════════════════════════════
  // DEFAULT / FALLBACK
  // ═══════════════════════════════════════════════════════════════════════════

  /// Default skin — used when no skin is explicitly set.
  /// Falls back to LifeFlow.
  static const defaultSkin = lifeFlow;

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER — Get dark-mode primaryContainer variant
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns the dark-mode primaryContainer variant for a given skin.
  static Color darkContainerFor(AppBrandSkin skin) {
    return switch (skin.appName) {
      'LifeFlow' => _lifeFlowDarkContainer,
      'IronFlow' => _ironFlowDarkContainer,
      'SpiritFlow' => _spiritFlowDarkContainer,
      'MindFlow' => _mindFlowDarkContainer,
      'WealthFlow' => _wealthFlowDarkContainer,
      'HustlePro' => _hustleProDarkContainer,
      'ForgePro' => _forgeProDarkContainer,
      'ChurchFlow' => _churchFlowDarkContainer,
      _ => _lifeFlowDarkContainer, // fallback
    };
  }
}
