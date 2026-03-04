/// Configuration for the Splash module.
class SplashConfig {
  /// Minimum duration to display splash screen (milliseconds).
  ///
  /// Default: 2000ms (2 seconds)
  final int minDurationMs;

  /// Animation type for the logo.
  final SplashAnimation animation;

  /// Whether to check app version (force update).
  final bool checkVersion;

  /// URL to check app version (if [checkVersion] is true).
  final String? versionCheckUrl;

  /// Whether to preload user data after auth check.
  final bool preloadUserData;

  /// Custom logo asset path (uses app logo if null).
  final String? logoAsset;

  /// Background color (uses theme if null).
  final int? backgroundColor;

  /// Callback when initialization is complete.
  final void Function()? onComplete;

  const SplashConfig({
    this.minDurationMs = 2000,
    this.animation = SplashAnimation.fadeScale,
    this.checkVersion = false,
    this.versionCheckUrl,
    this.preloadUserData = true,
    this.logoAsset = 'assets/icon/app_icon.png',
    this.backgroundColor,
    this.onComplete,
  });

  /// Default configuration.
  static const defaultConfig = SplashConfig();

  /// Creates a copy with the given fields replaced.
  SplashConfig copyWith({
    int? minDurationMs,
    SplashAnimation? animation,
    bool? checkVersion,
    String? versionCheckUrl,
    bool? preloadUserData,
    String? logoAsset,
    int? backgroundColor,
    void Function()? onComplete,
  }) {
    return SplashConfig(
      minDurationMs: minDurationMs ?? this.minDurationMs,
      animation: animation ?? this.animation,
      checkVersion: checkVersion ?? this.checkVersion,
      versionCheckUrl: versionCheckUrl ?? this.versionCheckUrl,
      preloadUserData: preloadUserData ?? this.preloadUserData,
      logoAsset: logoAsset ?? this.logoAsset,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      onComplete: onComplete ?? this.onComplete,
    );
  }
}

/// Animation types for the splash logo.
enum SplashAnimation {
  /// Fade in with scale effect.
  fadeScale,

  /// Bounce effect.
  bounce,

  /// Slide up from bottom.
  slideUp,

  /// Pulse effect.
  pulse,

  /// No animation.
  none;

  /// Animation duration in milliseconds.
  int get durationMs {
    return switch (this) {
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
