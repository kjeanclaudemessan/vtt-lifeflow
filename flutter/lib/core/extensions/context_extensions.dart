import 'package:flutter/material.dart';
import 'package:lifeflow/l10n/generated/app_localizations.dart';

/// Extensions on [BuildContext] for convenient access to common properties.
extension ContextExtensions on BuildContext {
  // ===== Theme =====

  /// Gets the current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Gets the current [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;

  /// Gets the current [TextTheme].
  TextTheme get textTheme => theme.textTheme;

  /// Returns `true` if the current theme is dark.
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Returns `true` if the current theme is light.
  bool get isLightMode => theme.brightness == Brightness.light;

  // ===== MediaQuery =====

  /// Gets the current [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Gets the screen size.
  Size get screenSize => mediaQuery.size;

  /// Gets the screen width.
  double get screenWidth => screenSize.width;

  /// Gets the screen height.
  double get screenHeight => screenSize.height;

  /// Gets the screen padding (safe area).
  EdgeInsets get padding => mediaQuery.padding;

  /// Gets the view insets (keyboard, etc.).
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Gets the device pixel ratio.
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Gets the text scale factor.
  double get textScaleFactor => mediaQuery.textScaler.scale(1.0);

  /// Returns `true` if the keyboard is visible.
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Gets the orientation of the device.
  Orientation get orientation => mediaQuery.orientation;

  /// Returns `true` if the device is in portrait mode.
  bool get isPortrait => orientation == Orientation.portrait;

  /// Returns `true` if the device is in landscape mode.
  bool get isLandscape => orientation == Orientation.landscape;

  // ===== Responsive Breakpoints =====

  /// Returns `true` if the screen width is mobile size (< 600).
  bool get isMobile => screenWidth < 600;

  /// Returns `true` if the screen width is tablet size (>= 600 and < 1200).
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Returns `true` if the screen width is desktop size (>= 1200).
  bool get isDesktop => screenWidth >= 1200;

  /// Returns the responsive value based on screen size.
  ///
  /// Example:
  /// ```dart
  /// final padding = context.responsive<double>(
  ///   mobile: 16,
  ///   tablet: 24,
  ///   desktop: 32,
  /// );
  /// ```
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // ===== Navigation =====

  /// Gets the current [NavigatorState].
  NavigatorState get navigator => Navigator.of(this);

  /// Pops the current route.
  void pop<T>([T? result]) => navigator.pop(result);

  /// Returns `true` if the navigator can pop.
  bool get canPop => navigator.canPop();

  /// Pushes a named route.
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Pushes a route and removes all previous routes.
  Future<T?> pushNamedAndRemoveAll<T>(String routeName, {Object? arguments}) {
    return navigator.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Replaces the current route with a named route.
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return navigator.pushReplacementNamed<T, void>(
      routeName,
      arguments: arguments,
    );
  }

  // ===== Focus =====

  /// Gets the current [FocusScopeNode].
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Unfocuses the current focus (hides keyboard).
  void unfocus() => focusScope.unfocus();

  /// Requests focus on the next focusable element.
  void nextFocus() => focusScope.nextFocus();

  /// Requests focus on the previous focusable element.
  void previousFocus() => focusScope.previousFocus();

  // ===== Scaffold =====

  /// Gets the nearest [ScaffoldState].
  ScaffoldState get scaffold => Scaffold.of(this);

  /// Gets the nearest [ScaffoldMessengerState].
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Shows a [SnackBar].
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar,
  ) {
    return scaffoldMessenger.showSnackBar(snackBar);
  }

  /// Shows a simple text [SnackBar].
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showTextSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    return showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  /// Hides the current [SnackBar].
  void hideSnackBar() => scaffoldMessenger.hideCurrentSnackBar();

  /// Opens the drawer if present.
  void openDrawer() => scaffold.openDrawer();

  /// Opens the end drawer if present.
  void openEndDrawer() => scaffold.openEndDrawer();

  /// Closes the drawer if open.
  void closeDrawer() {
    if (scaffold.isDrawerOpen) {
      navigator.pop();
    }
  }

  /// Closes the end drawer if open.
  void closeEndDrawer() {
    if (scaffold.isEndDrawerOpen) {
      navigator.pop();
    }
  }

  // ===== Modal =====

  /// Gets the current [ModalRoute].
  ModalRoute<Object?>? get modalRoute => ModalRoute.of(this);

  /// Gets the route arguments.
  Object? get routeArguments => modalRoute?.settings.arguments;

  /// Gets typed route arguments.
  T? args<T>() => routeArguments as T?;

  // ===== Localization =====

  /// Gets the current [AppLocalizations] instance.
  ///
  /// Example:
  /// ```dart
  /// Text(context.l10n.appName);
  /// Text(context.l10n.helloUser('John'));
  /// ```
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Gets the current locale.
  Locale get locale => Localizations.localeOf(this);

  /// Gets the current language code (e.g., 'en', 'fr').
  String get languageCode => locale.languageCode;

  /// Returns `true` if the current locale is English.
  bool get isEnglish => languageCode == 'en';

  /// Returns `true` if the current locale is French.
  bool get isFrench => languageCode == 'fr';
}
