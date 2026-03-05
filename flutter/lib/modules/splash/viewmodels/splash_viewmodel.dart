import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../../../services/storage/local_storage_service.dart';
import '../config/splash_config.dart';

/// ViewModel for the Splash screen.
///
/// Handles app initialization, auth checking, and navigation routing.
class SplashViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final LocalStorageService _storageService = locator<LocalStorageService>();

  // Auth repository - lazy to avoid issues if not registered yet
  IAuthRepository? _authRepository;
  IAuthRepository get authRepository {
    _authRepository ??= locator<IAuthRepository>();
    return _authRepository!;
  }

  /// Configuration for the splash screen.
  ///
  /// This can be customized by overriding in a subclass or by registering
  /// a custom SplashConfig in the service locator.
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
          _navigateToResult();
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

      // Navigate
      _navigateToResult();

      // Callback
      config.onComplete?.call();
    } catch (e) {
      _errorMessage = e.toString();
      _result = SplashResult.error;
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
      await authRepository.getCurrentUser();
    } catch (_) {
      // Ignore errors during preload
    }
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
    clearErrors();
    await initialize();
  }
}
