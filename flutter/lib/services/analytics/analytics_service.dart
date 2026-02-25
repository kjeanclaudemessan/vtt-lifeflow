import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import '../../core/config/app_config.dart';

/// Analytics and error tracking service powered by PostHog.
///
/// Combines analytics (events, screens, user identification) and
/// error tracking (crash reporting, manual exception capture) in a
/// single service.
///
/// PostHog replaces both Firebase Analytics and Sentry:
/// - Event tracking and user properties
/// - Automatic screen tracking
/// - Feature flags
/// - Session replay
/// - Error/crash reporting
///
/// Usage:
/// ```dart
/// final analytics = locator<AnalyticsService>();
///
/// // Track custom event
/// analytics.capture('button_clicked', properties: {'button': 'checkout'});
///
/// // Identify user
/// analytics.identify(userId: 'user_123', properties: {'plan': 'premium'});
///
/// // Capture error manually
/// analytics.captureError(error, stackTrace);
/// ```
class AnalyticsService {
  Posthog get _posthog => Posthog();

  bool _isInitialized = false;

  /// Whether PostHog is initialized and ready.
  bool get isInitialized => _isInitialized;

  /// Initializes PostHog with the current environment configuration.
  ///
  /// Enables:
  /// - Automatic error capture (Flutter errors, platform errors, isolate errors)
  /// - Feature flag preloading
  /// - Session replay (mobile only)
  /// - Application lifecycle events
  ///
  /// Call this in [bootstrap] after [AppConfig.initialize].
  Future<void> init() async {
    final config = AppConfig.instance;

    // Skip initialization if no API key provided
    if (config.posthogApiKey.isEmpty) {
      debugPrint('[PostHog] No API key — analytics disabled');
      return;
    }

    try {
      final posthogConfig = PostHogConfig(config.posthogApiKey);

      // Host configuration
      posthogConfig.host = config.posthogHost;

      // Debug mode in non-production
      posthogConfig.debug = !AppConfig.isProduction;

      // Event batching
      posthogConfig.flushAt = 20;
      posthogConfig.maxQueueSize = 1000;
      posthogConfig.maxBatchSize = 50;
      posthogConfig.flushInterval = const Duration(seconds: 30);

      // Feature flags
      posthogConfig.sendFeatureFlagEvents = true;
      posthogConfig.preloadFeatureFlags = true;

      // Privacy
      posthogConfig.personProfiles = PostHogPersonProfiles.identifiedOnly;

      // Session replay (mobile only, not in dev)
      if (!AppConfig.isDevelopment) {
        posthogConfig.sessionReplay = true;
        posthogConfig.sessionReplayConfig.maskAllTexts = false;
        posthogConfig.sessionReplayConfig.maskAllImages = false;
      }

      // Lifecycle events
      posthogConfig.captureApplicationLifecycleEvents = true;

      // Error tracking (not supported on Flutter Web)
      if (!kIsWeb && config.enableCrashReporting) {
        posthogConfig.errorTrackingConfig.captureFlutterErrors = true;
        posthogConfig.errorTrackingConfig.capturePlatformDispatcherErrors = true;
        posthogConfig.errorTrackingConfig.captureIsolateErrors = true;
        posthogConfig.errorTrackingConfig.captureNativeExceptions = false;
        posthogConfig.errorTrackingConfig.captureSilentFlutterErrors = false;
        posthogConfig.errorTrackingConfig.inAppIncludes.add('package:lifeflow');
        posthogConfig.errorTrackingConfig.inAppByDefault = true;
      }

      await _posthog.setup(posthogConfig);
      _isInitialized = true;

      debugPrint('[PostHog] Initialized (host: ${config.posthogHost})');
    } catch (e) {
      debugPrint('[PostHog] Failed to initialize: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Analytics — Events
  // ═══════════════════════════════════════════════════════════════════════

  /// Captures a custom analytics event.
  ///
  /// Example:
  /// ```dart
  /// analytics.capture('habit_created', properties: {
  ///   'domain': 'health',
  ///   'frequency': 'daily',
  /// });
  /// ```
  Future<void> capture(String eventName, {Map<String, Object>? properties}) async {
    if (!_isInitialized) return;
    await _posthog.capture(eventName: eventName, properties: properties);
  }

  /// Tracks a screen view.
  ///
  /// Prefer using [PosthogObserver] in [MaterialApp.navigatorObservers]
  /// for automatic screen tracking. Use this for manual tracking only.
  Future<void> screen(String screenName, {Map<String, Object>? properties}) async {
    if (!_isInitialized) return;
    await _posthog.screen(screenName: screenName, properties: properties);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Analytics — User Identity
  // ═══════════════════════════════════════════════════════════════════════

  /// Identifies the current user for analytics.
  ///
  /// Call this after successful login/signup.
  /// [userId] should be the Supabase user ID.
  Future<void> identify({
    required String userId,
    Map<String, Object>? properties,
  }) async {
    if (!_isInitialized) return;
    await _posthog.identify(
      userId: userId,
      userProperties: properties,
      userPropertiesSetOnce: {
        'first_seen': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Resets the user identity (call on logout).
  Future<void> reset() async {
    if (!_isInitialized) return;
    await _posthog.reset();
  }

  /// Sets persistent user properties (super properties).
  Future<void> setUserProperties(Map<String, Object> properties) async {
    if (!_isInitialized) return;
    await _posthog.setPersonProperties(
      userPropertiesToSet: properties,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Feature Flags
  // ═══════════════════════════════════════════════════════════════════════

  /// Checks if a feature flag is enabled.
  Future<bool> isFeatureEnabled(String flagKey) async {
    if (!_isInitialized) return false;
    return _posthog.isFeatureEnabled(flagKey);
  }

  /// Gets the value of a feature flag.
  Future<dynamic> getFeatureFlag(String flagKey) async {
    if (!_isInitialized) return null;
    return _posthog.getFeatureFlag(flagKey);
  }

  /// Gets the payload associated with a feature flag.
  Future<dynamic> getFeatureFlagPayload(String flagKey) async {
    if (!_isInitialized) return null;
    final result = await _posthog.getFeatureFlagResult(flagKey);
    return result?.payload;
  }

  /// Reloads feature flags from PostHog.
  Future<void> reloadFeatureFlags() async {
    if (!_isInitialized) return;
    await _posthog.reloadFeatureFlags();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Error Tracking
  // ═══════════════════════════════════════════════════════════════════════

  /// Manually captures an exception/error.
  ///
  /// Use this in catch blocks for important errors:
  /// ```dart
  /// try {
  ///   await riskyOperation();
  /// } catch (e, st) {
  ///   analytics.captureError(e, st, properties: {'context': 'checkout'});
  /// }
  /// ```
  Future<void> captureError(
    dynamic error,
    StackTrace? stackTrace, {
    Map<String, Object>? properties,
  }) async {
    if (!_isInitialized) return;
    try {
      await _posthog.captureException(
        error: error is Exception ? error : Exception(error.toString()),
        stackTrace: stackTrace,
        properties: properties,
      );
    } catch (e) {
      debugPrint('[PostHog] Error capturing exception: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Opt-in/out
  // ═══════════════════════════════════════════════════════════════════════

  /// Opts user out of analytics tracking.
  Future<void> optOut() async {
    if (!_isInitialized) return;
    await _posthog.disable();
  }

  /// Opts user back in to analytics tracking.
  Future<void> optIn() async {
    if (!_isInitialized) return;
    await _posthog.enable();
  }

  /// Flushes any pending events.
  Future<void> flush() async {
    if (!_isInitialized) return;
    await _posthog.flush();
  }
}
