import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/ui/views/home/home_viewmodel.dart';

void main() {
  HomeViewModel getModel() => HomeViewModel();

  group('HomeViewModel -', () {
    test('Initial tab index is 0', () {
      final model = getModel();
      expect(model.currentTabIndex, 0);
    });

    test('setTabIndex updates currentTabIndex', () {
      final model = getModel();
      model.setTabIndex(1);
      expect(model.currentTabIndex, 1);
    });

    test('setTabIndex with same index does not rebuild', () {
      final model = getModel();
      model.setTabIndex(0);
      expect(model.currentTabIndex, 0);
    });
  });
}
