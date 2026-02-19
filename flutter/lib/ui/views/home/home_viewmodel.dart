import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  int _currentTabIndex = 0;

  /// Current bottom nav tab index.
  int get currentTabIndex => _currentTabIndex;

  /// Set active tab index.
  void setTabIndex(int index) {
    if (_currentTabIndex == index) return;
    _currentTabIndex = index;
    rebuildUi();
  }
}
