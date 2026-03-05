import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// ============================================================================
/// VTT DESIGN SYSTEM - THEME
/// LifeFlow Design System
/// Premium • Calm • High Contrast • Monochromatic + Teal
/// ============================================================================

/// App theme configuration for LifeFlow.
///
/// Design principles:
/// - Light theme as primary choice
/// - High contrast for accessibility
/// - Monochromatic base with calming teal accent
/// - Clean, refined components
abstract final class AppTheme {
  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Light theme - Primary choice for Porsche-style applications
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.inter().fontFamily,

      // ───────────────────────────────────────────────────────────────────────
      // COLOR SCHEME
      // ───────────────────────────────────────────────────────────────────────
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.contrastHighLight,
        onSecondary: AppColors.white,
        tertiary: AppColors.info,
        onTertiary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.onError,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        surfaceContainerHighest: AppColors.surfaceSecondaryLight,
        outline: AppColors.borderLight,
        outlineVariant: AppColors.dividerLight,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // SCAFFOLD
      // ───────────────────────────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // ───────────────────────────────────────────────────────────────────────
      // APP BAR - Clean, minimal header
      // ───────────────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimaryLight,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.contrastHighLight,
          size: 24,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // CARD - Clean, subtle border (Porsche style)
      // ───────────────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: const BorderSide(color: AppColors.contrastLowLight),
        ),
        margin: EdgeInsets.zero,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // ELEVATED BUTTON - Primary action (Porsche Red)
      // ───────────────────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.contrastLowLight,
          disabledForegroundColor: AppColors.contrastMediumLight,
          padding: AppSpacing.buttonPadding,
          minimumSize: Size(0, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryDark;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.stateHoverLight;
            }
            return null;
          }),
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // OUTLINED BUTTON - Secondary action (Black border)
      // ───────────────────────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.contrastHighLight,
          disabledForegroundColor: AppColors.contrastMediumLight,
          padding: AppSpacing.buttonPadding,
          minimumSize: Size(0, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          side: const BorderSide(color: AppColors.contrastHighLight, width: 2),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // TEXT BUTTON - Tertiary action
      // ───────────────────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.contrastHighLight,
          disabledForegroundColor: AppColors.contrastMediumLight,
          padding: AppSpacing.buttonPadding,
          minimumSize: Size(0, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // ICON BUTTON
      // ───────────────────────────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.contrastHighLight,
          disabledForegroundColor: AppColors.contrastMediumLight,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // INPUT DECORATION - Clean underline style (Porsche style)
      // ───────────────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.contrastLowLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.contrastLowLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide:
              const BorderSide(color: AppColors.contrastHighLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.contrastLowLight),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.contrastMediumLight,
          fontSize: 16,
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.contrastMediumLight,
          fontSize: 16,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          color: AppColors.contrastHighLight,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: GoogleFonts.inter(
          color: AppColors.error,
          fontSize: 12,
        ),
        prefixIconColor: AppColors.contrastMediumLight,
        suffixIconColor: AppColors.contrastMediumLight,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // CHIP - Tag style
      // ───────────────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceSecondaryLight,
        selectedColor: AppColors.contrastHighLight,
        disabledColor: AppColors.contrastLowLight,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.contrastHighLight,
        ),
        padding: AppSpacing.chipPadding,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.chip),
        side: BorderSide.none,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // BOTTOM NAVIGATION
      // ───────────────────────────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundLight,
        selectedItemColor: AppColors.contrastHighLight,
        unselectedItemColor: AppColors.contrastMediumLight,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // NAVIGATION BAR (Material 3)
      // ───────────────────────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.backgroundLight,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.contrastHighLight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.contrastHighLight,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.contrastMediumLight,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.white, size: 24);
          }
          return const IconThemeData(
              color: AppColors.contrastMediumLight, size: 24);
        }),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // BOTTOM SHEET
      // ───────────────────────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.backgroundLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.bottomSheet),
        elevation: 0,
        dragHandleColor: AppColors.contrastLowLight,
        dragHandleSize: const Size(40, 4),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // DIALOG
      // ───────────────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.backgroundLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.textSecondaryLight,
          height: 1.5,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // DIVIDER
      // ───────────────────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.contrastLowLight,
        thickness: 1,
        space: 1,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // SNACKBAR
      // ───────────────────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.contrastHighLight,
        contentTextStyle: GoogleFonts.inter(
          color: AppColors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        behavior: SnackBarBehavior.floating,
        actionTextColor: AppColors.primary,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // PROGRESS INDICATOR
      // ───────────────────────────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.contrastLowLight,
        circularTrackColor: AppColors.contrastLowLight,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // SWITCH
      // ───────────────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.contrastHighLight;
          }
          return AppColors.contrastMediumLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.contrastLowLight;
          }
          return AppColors.surfaceSecondaryLight;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.contrastHighLight;
          }
          return AppColors.contrastMediumLight;
        }),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // CHECKBOX
      // ───────────────────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.contrastHighLight;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: const BorderSide(color: AppColors.contrastMediumLight, width: 2),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xs),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // RADIO
      // ───────────────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.contrastHighLight;
          }
          return AppColors.contrastMediumLight;
        }),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // TAB BAR
      // ───────────────────────────────────────────────────────────────────────
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.contrastHighLight,
        unselectedLabelColor: AppColors.contrastMediumLight,
        indicatorColor: AppColors.contrastHighLight,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.contrastLowLight,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // FLOATING ACTION BUTTON
      // ───────────────────────────────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: CircleBorder(),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // LIST TILE
      // ───────────────────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: AppSpacing.listItemPadding,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryLight,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondaryLight,
        ),
        iconColor: AppColors.contrastMediumLight,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // POPUP MENU
      // ───────────────────────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.backgroundLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.popover),
        elevation: 8,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textPrimaryLight,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // TOOLTIP
      // ───────────────────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.contrastHighLight,
          borderRadius: AppRadius.xs,
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.white,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // DATE PICKER - Porsche styled
      // ───────────────────────────────────────────────────────────────────────
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surfaceLight,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: AppColors.textOnPrimary,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textDisabledLight;
          }
          return AppColors.textPrimaryLight;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        todayForegroundColor: WidgetStateProperty.all(AppColors.primary),
        todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
        todayBorder: const BorderSide(color: AppColors.primary, width: 1),
        yearForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return AppColors.textPrimaryLight;
        }),
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        dayShape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppRadius.xs),
        ),
        headerHeadlineStyle: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textOnPrimary,
        ),
        headerHelpStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textOnPrimary.withValues(alpha: 0.7),
        ),
        dayStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        weekdayStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondaryLight,
        ),
        yearStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // TIME PICKER - Porsche styled
      // ───────────────────────────────────────────────────────────────────────
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
        hourMinuteColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.15);
          }
          return AppColors.surfaceSecondaryLight;
        }),
        hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textPrimaryLight;
        }),
        dayPeriodColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return AppColors.textPrimaryLight;
        }),
        dialHandColor: AppColors.primary,
        dialBackgroundColor: AppColors.surfaceSecondaryLight,
        dialTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return AppColors.textPrimaryLight;
        }),
        entryModeIconColor: AppColors.primary,
        helpTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondaryLight,
        ),
        hourMinuteTextStyle: GoogleFonts.inter(
          fontSize: 56,
          fontWeight: FontWeight.w600,
        ),
        dayPeriodTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hourMinuteShape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        dayPeriodShape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        dayPeriodBorderSide: const BorderSide(color: AppColors.borderLight),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Dark theme - Secondary option
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.inter().fontFamily,

      // ───────────────────────────────────────────────────────────────────────
      // COLOR SCHEME
      // ───────────────────────────────────────────────────────────────────────
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainerDark,
        onPrimaryContainer: AppColors.primaryLight,
        secondary: AppColors.contrastHighDark,
        onSecondary: AppColors.black,
        tertiary: AppColors.info,
        onTertiary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.onError,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.surfaceSecondaryDark,
        outline: AppColors.borderDark,
        outlineVariant: AppColors.dividerDark,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // SCAFFOLD
      // ───────────────────────────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // ───────────────────────────────────────────────────────────────────────
      // APP BAR
      // ───────────────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.contrastHighDark,
          size: 24,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // CARD
      // ───────────────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: const BorderSide(color: AppColors.contrastLowDark),
        ),
        margin: EdgeInsets.zero,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // ELEVATED BUTTON
      // ───────────────────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.contrastLowDark,
          disabledForegroundColor: AppColors.contrastMediumDark,
          padding: AppSpacing.buttonPadding,
          minimumSize: Size(0, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // OUTLINED BUTTON
      // ───────────────────────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.contrastHighDark,
          disabledForegroundColor: AppColors.contrastMediumDark,
          padding: AppSpacing.buttonPadding,
          minimumSize: Size(0, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          side: const BorderSide(color: AppColors.contrastHighDark, width: 2),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // TEXT BUTTON
      // ───────────────────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.contrastHighDark,
          disabledForegroundColor: AppColors.contrastMediumDark,
          padding: AppSpacing.buttonPadding,
          minimumSize: Size(0, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // ICON BUTTON
      // ───────────────────────────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.contrastHighDark,
          disabledForegroundColor: AppColors.contrastMediumDark,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // INPUT DECORATION
      // ───────────────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.contrastLowDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.contrastLowDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide:
              const BorderSide(color: AppColors.contrastHighDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: const BorderSide(color: AppColors.contrastLowDark),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.contrastMediumDark,
          fontSize: 16,
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.contrastMediumDark,
          fontSize: 16,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          color: AppColors.contrastHighDark,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: GoogleFonts.inter(
          color: AppColors.error,
          fontSize: 12,
        ),
        prefixIconColor: AppColors.contrastMediumDark,
        suffixIconColor: AppColors.contrastMediumDark,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // CHIP
      // ───────────────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceSecondaryDark,
        selectedColor: AppColors.contrastHighDark,
        disabledColor: AppColors.contrastLowDark,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.contrastHighDark,
        ),
        padding: AppSpacing.chipPadding,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.chip),
        side: BorderSide.none,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // BOTTOM NAVIGATION
      // ───────────────────────────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundDark,
        selectedItemColor: AppColors.contrastHighDark,
        unselectedItemColor: AppColors.contrastMediumDark,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // NAVIGATION BAR
      // ───────────────────────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.backgroundDark,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.contrastHighDark,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.contrastHighDark,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.contrastMediumDark,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.black, size: 24);
          }
          return const IconThemeData(
              color: AppColors.contrastMediumDark, size: 24);
        }),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // BOTTOM SHEET
      // ───────────────────────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.bottomSheet),
        elevation: 0,
        dragHandleColor: AppColors.contrastLowDark,
        dragHandleSize: const Size(40, 4),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // DIALOG
      // ───────────────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.textSecondaryDark,
          height: 1.5,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // DIVIDER
      // ───────────────────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.contrastLowDark,
        thickness: 1,
        space: 1,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // SNACKBAR
      // ───────────────────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.contrastHighDark,
        contentTextStyle: GoogleFonts.inter(
          color: AppColors.black,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        behavior: SnackBarBehavior.floating,
        actionTextColor: AppColors.primary,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // PROGRESS INDICATOR
      // ───────────────────────────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.contrastLowDark,
        circularTrackColor: AppColors.contrastLowDark,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // SWITCH
      // ───────────────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.contrastHighDark;
          }
          return AppColors.contrastMediumDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.contrastLowDark;
          }
          return AppColors.surfaceSecondaryDark;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.contrastHighDark;
          }
          return AppColors.contrastMediumDark;
        }),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // CHECKBOX
      // ───────────────────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.contrastHighDark;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.black),
        side: const BorderSide(color: AppColors.contrastMediumDark, width: 2),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xs),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // RADIO
      // ───────────────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.contrastHighDark;
          }
          return AppColors.contrastMediumDark;
        }),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // TAB BAR
      // ───────────────────────────────────────────────────────────────────────
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.contrastHighDark,
        unselectedLabelColor: AppColors.contrastMediumDark,
        indicatorColor: AppColors.contrastHighDark,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.contrastLowDark,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // FLOATING ACTION BUTTON
      // ───────────────────────────────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: CircleBorder(),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // LIST TILE
      // ───────────────────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: AppSpacing.listItemPadding,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryDark,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondaryDark,
        ),
        iconColor: AppColors.contrastMediumDark,
      ),

      // ───────────────────────────────────────────────────────────────────────
      // POPUP MENU
      // ───────────────────────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.popover),
        elevation: 8,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textPrimaryDark,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // TOOLTIP
      // ───────────────────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.contrastHighDark,
          borderRadius: AppRadius.xs,
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.black,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // DATE PICKER - Porsche styled (Dark)
      // ───────────────────────────────────────────────────────────────────────
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surfaceDark,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: AppColors.textOnPrimary,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textDisabledDark;
          }
          return AppColors.textPrimaryDark;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        todayForegroundColor: WidgetStateProperty.all(AppColors.primary),
        todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
        todayBorder: const BorderSide(color: AppColors.primary, width: 1),
        yearForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return AppColors.textPrimaryDark;
        }),
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        dayShape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppRadius.xs),
        ),
        headerHeadlineStyle: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textOnPrimary,
        ),
        headerHelpStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textOnPrimary.withValues(alpha: 0.7),
        ),
        dayStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        weekdayStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondaryDark,
        ),
        yearStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ───────────────────────────────────────────────────────────────────────
      // TIME PICKER - Porsche styled (Dark)
      // ───────────────────────────────────────────────────────────────────────
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
        hourMinuteColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.2);
          }
          return AppColors.surfaceSecondaryDark;
        }),
        hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textPrimaryDark;
        }),
        dayPeriodColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return AppColors.textPrimaryDark;
        }),
        dialHandColor: AppColors.primary,
        dialBackgroundColor: AppColors.surfaceSecondaryDark,
        dialTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return AppColors.textPrimaryDark;
        }),
        entryModeIconColor: AppColors.primary,
        helpTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondaryDark,
        ),
        hourMinuteTextStyle: GoogleFonts.inter(
          fontSize: 56,
          fontWeight: FontWeight.w600,
        ),
        dayPeriodTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hourMinuteShape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        dayPeriodShape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        dayPeriodBorderSide: const BorderSide(color: AppColors.borderDark),
      ),
    );
  }
}
