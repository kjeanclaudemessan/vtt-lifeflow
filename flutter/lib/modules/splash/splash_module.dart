/// Splash module - app launch and routing.
///
/// This module handles:
/// - App initialization
/// - Auth state check
/// - Onboarding check
/// - Routing to appropriate screen
///
/// Usage:
/// ```dart
/// import 'package:myapp/modules/splash/splash_module.dart';
///
/// // Configure (optional)
/// final config = SplashConfig(
///   minDurationMs: 2000,
///   animation: SplashAnimation.fadeScale,
/// );
/// ```
library splash_module;

// Config
export 'config/splash_config.dart';
// Views
export 'views/splash_view.dart';
