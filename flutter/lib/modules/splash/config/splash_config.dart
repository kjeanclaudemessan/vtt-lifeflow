/// Configuration for the Splash module.
///
/// Controls the splash screen's visual presentation, animation choreography,
/// contextual greeting, and initialization behavior.
class SplashConfig {
  /// Minimum duration to display splash screen (milliseconds).
  ///
  /// Default: 2500ms — enough to feel intentional without feeling slow.
  final int minDurationMs;

  /// Visual layout style of the splash screen.
  final SplashStyle style;

  /// Animation style for the logo entrance.
  final SplashAnimation animation;

  /// Whether to check app version (force update).
  final bool checkVersion;

  /// URL to check app version (if [checkVersion] is true).
  final String? versionCheckUrl;

  /// Whether to preload user data after auth check.
  final bool preloadUserData;

  /// Custom logo asset path (uses app icon if null).
  final String? logoAsset;

  /// Background color override (uses theme surface if null).
  final int? backgroundColor;

  /// Whether to show a contextual greeting based on time of day.
  ///
  /// When true, displays "Bonjour", "Bon après-midi", or "Bonsoir"
  /// followed by the user's name (if authenticated) or brand tagline.
  final bool showGreeting;

  /// Whether to show the app tagline below the app name.
  final bool showTagline;

  /// Whether to enable haptic feedback on splash ready.
  final bool enableHaptics;

  /// Whether to animate the transition OUT of the splash screen.
  ///
  /// When true, content fades/scales out before navigation.
  final bool animateExit;

  /// Callback when initialization is complete.
  final void Function()? onComplete;

  const SplashConfig({
    this.minDurationMs = 2500,
    this.style = SplashStyle.centered,
    this.animation = SplashAnimation.breathe,
    this.checkVersion = false,
    this.versionCheckUrl,
    this.preloadUserData = true,
    this.logoAsset = 'assets/icon/app_icon.png',
    this.backgroundColor,
    this.showGreeting = true,
    this.showTagline = true,
    this.enableHaptics = true,
    this.animateExit = true,
    this.onComplete,
  });

  /// Default configuration.
  static const defaultConfig = SplashConfig();

  /// Creates a copy with the given fields replaced.
  SplashConfig copyWith({
    int? minDurationMs,
    SplashStyle? style,
    SplashAnimation? animation,
    bool? checkVersion,
    String? versionCheckUrl,
    bool? preloadUserData,
    String? logoAsset,
    int? backgroundColor,
    bool? showGreeting,
    bool? showTagline,
    bool? enableHaptics,
    bool? animateExit,
    void Function()? onComplete,
  }) {
    return SplashConfig(
      minDurationMs: minDurationMs ?? this.minDurationMs,
      style: style ?? this.style,
      animation: animation ?? this.animation,
      checkVersion: checkVersion ?? this.checkVersion,
      versionCheckUrl: versionCheckUrl ?? this.versionCheckUrl,
      preloadUserData: preloadUserData ?? this.preloadUserData,
      logoAsset: logoAsset ?? this.logoAsset,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showGreeting: showGreeting ?? this.showGreeting,
      showTagline: showTagline ?? this.showTagline,
      enableHaptics: enableHaptics ?? this.enableHaptics,
      animateExit: animateExit ?? this.animateExit,
      onComplete: onComplete ?? this.onComplete,
    );
  }
}

/// Visual layout styles for the splash screen.
enum SplashStyle {
  /// Centered layout — logo in the middle with greeting below.
  centered,

  /// Minimal layout — logo only, no greeting or tagline, clean.
  minimal,

  /// Branded layout — large logo with gradient background.
  branded,
}

/// Animation types for the splash logo.
enum SplashAnimation {
  /// Breathing scale effect — logo gently pulses in like a heartbeat.
  /// Warm, organic, human. The default for all apps.
  breathe,

  /// Fade in with scale effect.
  fadeScale,

  /// Bounce effect.
  bounce,

  /// Slide up from bottom.
  slideUp,

  /// Pulse effect (continuous).
  pulse,

  /// No animation.
  none;

  /// Animation duration in milliseconds.
  int get durationMs {
    return switch (this) {
      SplashAnimation.breathe => 1200,
      SplashAnimation.fadeScale => 800,
      SplashAnimation.bounce => 1000,
      SplashAnimation.slideUp => 600,
      SplashAnimation.pulse => 1200,
      SplashAnimation.none => 0,
    };
  }
}

/// Result of the splash initialization process.
enum SplashResult {
  /// User is authenticated, go to home.
  goToHome,

  /// User needs onboarding.
  goToOnboarding,

  /// User needs to login.
  goToLogin,

  /// App needs update.
  goToForceUpdate,

  /// Error during initialization.
  error,
}
