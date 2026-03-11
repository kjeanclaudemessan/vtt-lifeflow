import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/core.dart';
import '../../../design_system/tokens/app_animations.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../../../services/haptic_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../config/splash_config.dart';

/// ViewModel for the Splash screen.
///
/// Handles app initialization, contextual greeting, haptic feedback,
/// choreographed exit animation, and navigation routing.
///
/// This is the **first moment of relationship** with the user.
/// Every transition is intentional — nothing is a hard cut.
class SplashViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final LocalStorageService _storageService = locator<LocalStorageService>();
  final HapticService _hapticService = locator<HapticService>();

  // Auth repository - lazy to avoid issues if not registered yet
  IAuthRepository? _authRepository;
  IAuthRepository get authRepository {
    _authRepository ??= locator<IAuthRepository>();
    return _authRepository!;
  }

  /// Configuration for the splash screen.
  SplashConfig get config => const SplashConfig();

  // ─────────────────────────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────────────────────────

  SplashResult? _result;
  SplashResult? get result => _result;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  double _progress = 0;
  double get progress => _progress;

  bool _isExiting = false;
  bool get isExiting => _isExiting;

  String? _userName;

  // ─────────────────────────────────────────────────────────────────
  // Contextual Greeting
  // ─────────────────────────────────────────────────────────────────

  /// Returns a time-of-day greeting, optionally personalized with user name.
  ///
  /// - Morning (5-12): "Bonjour" / "Good morning"
  /// - Afternoon (12-18): "Bon après-midi" / "Good afternoon"
  /// - Evening (18-5): "Bonsoir" / "Good evening"
  ///
  /// If user is authenticated and name is known, appends their name.
  String contextualGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    final String timeGreeting;

    if (hour >= 5 && hour < 12) {
      timeGreeting = l10n.splashGreetingMorning;
    } else if (hour >= 12 && hour < 18) {
      timeGreeting = l10n.splashGreetingAfternoon;
    } else {
      timeGreeting = l10n.splashGreetingEvening;
    }

    if (_userName != null && _userName!.isNotEmpty) {
      return '$timeGreeting, $_userName';
    }

    return timeGreeting;
  }

  // ─────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────

  /// Initializes the splash screen and determines navigation.
  Future<void> initialize() async {
    try {
      final startTime = DateTime.now();

      // Step 1: Version check (if enabled)
      _progress = 0.2;
      rebuildUi();

      if (config.checkVersion) {
        final needsUpdate = await _checkVersion();
        if (needsUpdate) {
          _result = SplashResult.goToForceUpdate;
          await _exitAndNavigate();
          return;
        }
      }

      // Step 2: Check auth state
      _progress = 0.5;
      rebuildUi();

      final isLoggedIn = authRepository.isAuthenticated;

      if (!isLoggedIn) {
        // Step 3: Check onboarding (for non-authenticated users)
        _progress = 0.8;
        rebuildUi();

        final onboardingCompleted = await _isOnboardingCompleted();

        if (!onboardingCompleted) {
          _result = SplashResult.goToOnboarding;
        } else {
          _result = SplashResult.goToLogin;
        }
      } else {
        // Step 4: Preload user data (if enabled)
        _progress = 0.8;
        rebuildUi();

        if (config.preloadUserData) {
          await _preloadUserData();
        }

        _result = SplashResult.goToHome;
      }

      // Ensure minimum duration
      _progress = 1.0;
      rebuildUi();

      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      final remaining = config.minDurationMs - elapsed;
      if (remaining > 0) {
        await Future.delayed(Duration(milliseconds: remaining));
      }

      // Haptic pulse on ready
      if (config.enableHaptics) {
        _hapticService.light();
      }

      // Choreographed exit
      await _exitAndNavigate();

      // Callback
      config.onComplete?.call();
    } catch (e) {
      _errorMessage = e.toString();
      _result = SplashResult.error;

      if (config.enableHaptics) {
        _hapticService.error();
      }

      setError(e);
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Private Methods
  // ─────────────────────────────────────────────────────────────────

  /// Checks if a version update is required.
  Future<bool> _checkVersion() async {
    if (config.versionCheckUrl == null) return false;

    // TODO: Implement version check API call
    // For now, always return false (no update needed)
    return false;
  }

  /// Checks if onboarding has been completed.
  Future<bool> _isOnboardingCompleted() async {
    return _storageService.getBool('onboarding_completed') ?? false;
  }

  /// Preloads user data after authentication.
  Future<void> _preloadUserData() async {
    try {
      final user = await authRepository.getCurrentUser();
      // Extract user name for contextual greeting
      _userName = user.fold((failure) => null, (user) => user?.displayName);
    } catch (_) {
      // Ignore errors during preload — greeting falls back to tagline
    }
  }

  /// Plays exit animation then navigates.
  ///
  /// The transition OUT is choreographed: content fades/scales out
  /// over 300ms before the navigation happens. This prevents the
  /// jarring "hard cut" effect of instant route changes.
  Future<void> _exitAndNavigate() async {
    if (config.animateExit) {
      _isExiting = true;
      rebuildUi();
      await Future.delayed(AppAnimations.medium);
    }

    _navigateToResult();
  }

  /// Navigates to the appropriate screen based on result.
  void _navigateToResult() {
    final route = switch (_result) {
      SplashResult.goToHome => Routes.homeView,
      SplashResult.goToOnboarding => Routes.onboardingView,
      SplashResult.goToLogin => Routes.loginView,
      SplashResult.goToForceUpdate =>
        Routes.homeView, // TODO: force update route
      SplashResult.error || null => null,
    };

    if (route == null) return; // Stay on splash, show error

    _navigationService.clearStackAndShow(route);
  }

  /// Retries initialization after an error.
  Future<void> retry() async {
    _errorMessage = null;
    _result = null;
    _progress = 0;
    _isExiting = false;
    clearErrors();
    await initialize();
  }
}
