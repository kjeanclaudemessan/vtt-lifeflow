import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ============================================================================
/// VTT DESIGN SYSTEM - SPACING
/// Inspired by Porsche Design System
/// Fluid spacing that scales with viewport
/// ============================================================================

/// Porsche-inspired spacing system with both static and fluid values.
///
/// Design principles:
/// - Fluid spacing for responsive layouts
/// - Static spacing for consistent UI elements
/// - Grid-based layout system
/// - Generous whitespace for premium feel
abstract final class AppSpacing {
  // ═══════════════════════════════════════════════════════════════════════════
  // STATIC SPACING - Fixed values for UI components
  // ═══════════════════════════════════════════════════════════════════════════

  /// No spacing - 0
  static double get none => 0;

  /// Static X-Small - 4dp
  static double get staticXs => 4.w;

  /// Static Small - 8dp
  static double get staticSm => 8.w;

  /// Static Medium - 16dp
  static double get staticMd => 16.w;

  /// Static Large - 24dp
  static double get staticLg => 24.w;

  /// Static X-Large - 32dp
  static double get staticXl => 32.w;

  /// Static XX-Large - 48dp
  static double get staticXxl => 48.w;

  // ═══════════════════════════════════════════════════════════════════════════
  // FLUID SPACING - Scales with viewport (Porsche style)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Fluid X-Small - 8dp base, scales
  static double get fluidXs => 8.w;

  /// Fluid Small - 16dp base, scales
  static double get fluidSm => 16.w;

  /// Fluid Medium - 24dp base, scales (DEFAULT)
  static double get fluidMd => 24.w;

  /// Fluid Large - 40dp base, scales
  static double get fluidLg => 40.w;

  /// Fluid X-Large - 56dp base, scales
  static double get fluidXl => 56.w;

  /// Fluid XX-Large - 80dp base, scales
  static double get fluidXxl => 80.w;

  // ═══════════════════════════════════════════════════════════════════════════
  // LEGACY ALIASES (for backward compatibility)
  // ═══════════════════════════════════════════════════════════════════════════

  static double get xxxs => 2.w;
  static double get xxs => 4.w;
  static double get xs => 8.w;
  static double get sm => 12.w;
  static double get md => 16.w;
  static double get lg => 24.w;
  static double get xl => 32.w;
  static double get xxl => 40.w;
  static double get xxxl => 48.w;
  static double get huge => 56.w;
  static double get massive => 64.w;
  static double get giant => 80.w;

  // ═══════════════════════════════════════════════════════════════════════════
  // GRID GAP - Porsche grid system
  // ═══════════════════════════════════════════════════════════════════════════

  /// Grid gap between columns/items
  static double get gridGap => 16.w;

  // ═══════════════════════════════════════════════════════════════════════════
  // ICON SIZES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Small icon - 16dp
  static double get iconSm => 16.sp;

  /// Medium icon - 24dp
  static double get iconMd => 24.sp;

  /// Large icon - 32dp
  static double get iconLg => 32.sp;

  /// Extra large icon - 48dp
  static double get iconXl => 48.sp;

  // ═══════════════════════════════════════════════════════════════════════════
  // BUTTON HEIGHTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Small button height - 40dp
  static double get buttonHeightSm => 40.h;

  /// Medium button height - 48dp
  static double get buttonHeightMd => 48.h;

  /// Large button height - 56dp
  static double get buttonHeightLg => 56.h;

  // ═══════════════════════════════════════════════════════════════════════════
  // INPUT HEIGHTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Input field height - 56dp
  static double get inputHeight => 56.h;

  /// Text area min height - 120dp
  static double get textAreaMinHeight => 120.h;

  // ═══════════════════════════════════════════════════════════════════════════
  // AVATAR SIZES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Small avatar - 32dp
  static double get avatarSm => 32.w;

  /// Medium avatar - 48dp
  static double get avatarMd => 48.w;

  /// Large avatar - 64dp
  static double get avatarLg => 64.w;

  /// Extra large avatar - 96dp
  static double get avatarXl => 96.w;

  // ═══════════════════════════════════════════════════════════════════════════
  // PADDING PRESETS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Screen padding - fluid medium all around
  static EdgeInsets get screenPadding => EdgeInsets.symmetric(
        horizontal: fluidMd,
        vertical: fluidSm,
      );

  /// Screen horizontal padding only
  static EdgeInsets get screenHorizontal => EdgeInsets.symmetric(
        horizontal: fluidMd,
      );

  /// Card padding - fluid medium
  static EdgeInsets get cardPadding => EdgeInsets.all(fluidMd);

  /// Card padding compact - fluid small
  static EdgeInsets get cardPaddingCompact => EdgeInsets.all(fluidSm);

  /// Card padding large - fluid large
  static EdgeInsets get cardPaddingLarge => EdgeInsets.all(fluidLg);

  /// List item padding
  static EdgeInsets get listItemPadding => EdgeInsets.symmetric(
        horizontal: fluidSm,
        vertical: staticMd,
      );

  /// Button padding - generous for touch targets
  static EdgeInsets get buttonPadding => EdgeInsets.symmetric(
        horizontal: fluidMd,
        vertical: staticMd,
      );

  /// Button padding large
  static EdgeInsets get buttonPaddingLarge => EdgeInsets.symmetric(
        horizontal: fluidLg,
        vertical: staticLg,
      );

  /// Chip padding
  static EdgeInsets get chipPadding => EdgeInsets.symmetric(
        horizontal: staticMd,
        vertical: staticXs,
      );

  /// Badge padding
  static EdgeInsets get badgePadding => EdgeInsets.symmetric(
        horizontal: staticSm,
        vertical: staticXs,
      );

  /// Section padding
  static EdgeInsets get sectionPadding => EdgeInsets.symmetric(
        horizontal: fluidMd,
        vertical: fluidLg,
      );

  /// Input content padding
  static EdgeInsets get inputPadding => EdgeInsets.symmetric(
        horizontal: fluidSm,
        vertical: staticMd,
      );

  /// Dialog padding
  static EdgeInsets get dialogPadding => EdgeInsets.all(fluidMd);

  /// Bottom sheet padding
  static EdgeInsets get bottomSheetPadding => EdgeInsets.fromLTRB(
        fluidMd,
        fluidSm,
        fluidMd,
        fluidLg,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // HORIZONTAL SPACERS (Widgets)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Horizontal spacer - 4dp
  static Widget get horizontalXxs => SizedBox(width: xxs);

  /// Horizontal spacer - 8dp
  static Widget get horizontalXs => SizedBox(width: xs);

  /// Horizontal spacer - 12dp
  static Widget get horizontalSm => SizedBox(width: sm);

  /// Horizontal spacer - 16dp
  static Widget get horizontalMd => SizedBox(width: md);

  /// Horizontal spacer - 24dp
  static Widget get horizontalLg => SizedBox(width: lg);

  /// Horizontal spacer - 32dp
  static Widget get horizontalXl => SizedBox(width: xl);

  /// Horizontal spacer - 40dp
  static Widget get horizontalXxl => SizedBox(width: xxl);

  /// Horizontal spacer - 48dp
  static Widget get horizontalXxxl => SizedBox(width: xxxl);

  // ═══════════════════════════════════════════════════════════════════════════
  // VERTICAL SPACERS (Widgets)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Vertical spacer - 4dp
  static Widget get verticalXxs => SizedBox(height: xxs);

  /// Vertical spacer - 8dp
  static Widget get verticalXs => SizedBox(height: xs);

  /// Vertical spacer - 12dp
  static Widget get verticalSm => SizedBox(height: sm);

  /// Vertical spacer - 16dp
  static Widget get verticalMd => SizedBox(height: md);

  /// Vertical spacer - 24dp
  static Widget get verticalLg => SizedBox(height: lg);

  /// Vertical spacer - 32dp
  static Widget get verticalXl => SizedBox(height: xl);

  /// Vertical spacer - 40dp
  static Widget get verticalXxl => SizedBox(height: xxl);

  /// Vertical spacer - 48dp
  static Widget get verticalXxxl => SizedBox(height: xxxl);

  /// Vertical spacer - 56dp
  static Widget get verticalHuge => SizedBox(height: huge);

  /// Vertical spacer - 64dp
  static Widget get verticalMassive => SizedBox(height: massive);

  // ═══════════════════════════════════════════════════════════════════════════
  // CUSTOM SPACER FACTORY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Creates a horizontal spacer with custom width
  static Widget horizontal(double width) => SizedBox(width: width.w);

  /// Creates a vertical spacer with custom height
  static Widget vertical(double height) => SizedBox(height: height.h);

  /// Creates a square spacer
  static Widget square(double size) => SizedBox(width: size.w, height: size.h);
}
