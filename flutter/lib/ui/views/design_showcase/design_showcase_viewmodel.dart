import 'package:stacked/stacked.dart';

/// ViewModel for the Design Showcase View.
class DesignShowcaseViewModel extends BaseViewModel {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Toggles between light and dark theme.
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    rebuildUi();
  }

  /// Simulates a loading state for button demo.
  Future<void> simulateLoading() async {
    _isLoading = true;
    rebuildUi();
    await Future.delayed(const Duration(seconds: 2));
    _isLoading = false;
    rebuildUi();
  }
}
