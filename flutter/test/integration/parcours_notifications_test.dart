/// Parcours 9 — Notifications Lifecycle
///
/// End-to-end flow: user opens notifications, filters, marks as read,
/// deletes, clears all. Uses mock data (no Supabase).
///
/// Run: dart test test/integration/parcours_notifications_test.dart
@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/modules/notifications/viewmodels/notifications_viewmodel.dart';
import 'package:lifeflow/modules/notifications/config/notifications_config.dart';

import 'viewmodel_test_helper.dart';

void main() {
  setUpAll(() async {
    await ViewModelTestHelper.initialize();
  });

  tearDownAll(() async {
    await ViewModelTestHelper.cleanup();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Parcours 9 — Notifications Lifecycle
  // ═══════════════════════════════════════════════════════════════════════════

  group('Parcours 9 — Notifications Lifecycle', () {
    test('P9-1: NotificationsVM.init() → notifications loaded (5 mock items)',
        () async {
      final vm = NotificationsViewModel();
      await vm.init();

      expect(vm.isBusy, isFalse);
      expect(vm.hasError, isFalse);
      expect(vm.hasNotifications, isTrue);
      expect(vm.notifications.length, 5);
      // 4 unread (id 3 is pre-read)
      expect(vm.unreadCount, 4);
      expect(vm.allRead, isFalse);
    });

    test('P9-2: setFilter(marketing) → only marketing notifications', () async {
      final vm = NotificationsViewModel();
      await vm.init();

      expect(vm.selectedFilter, isNull);

      vm.setFilter(NotificationType.marketing);

      expect(vm.selectedFilter, NotificationType.marketing);
      expect(vm.filteredNotifications.length, 1);
      expect(vm.filteredNotifications.first.title, 'Special Offer');

      // clearFilter → back to all
      vm.clearFilter();
      expect(vm.selectedFilter, isNull);
      expect(vm.filteredNotifications.length, 5);
    });

    test('P9-3: markAsRead(id) → notification marked, unreadCount decrements',
        () async {
      final vm = NotificationsViewModel();
      await vm.init();

      final unreadBefore = vm.unreadCount;
      expect(vm.notifications.firstWhere((n) => n.id == '1').isRead, isFalse);

      await vm.markAsRead('1');

      expect(vm.notifications.firstWhere((n) => n.id == '1').isRead, isTrue);
      expect(vm.unreadCount, unreadBefore - 1);
    });

    test('P9-4: markAllAsRead() → all read, unreadCount = 0', () async {
      final vm = NotificationsViewModel();
      await vm.init();

      expect(vm.unreadCount, greaterThan(0));

      await vm.markAllAsRead();

      expect(vm.unreadCount, 0);
      expect(vm.allRead, isTrue);
      for (final n in vm.notifications) {
        expect(n.isRead, isTrue, reason: 'Notification ${n.id} should be read');
      }
    });

    test('P9-5: deleteNotification(id) → removed from list', () async {
      final vm = NotificationsViewModel();
      await vm.init();

      expect(vm.notifications.length, 5);

      await vm.deleteNotification('1');

      expect(vm.notifications.length, 4);
      expect(vm.notifications.any((n) => n.id == '1'), isFalse);
    });

    test('P9-6: clearAll() → list empty', () async {
      final vm = NotificationsViewModel();
      await vm.init();

      expect(vm.hasNotifications, isTrue);

      await vm.clearAll();

      expect(vm.hasNotifications, isFalse);
      expect(vm.notifications, isEmpty);
      expect(vm.unreadCount, 0);
    });

    test('P9-7: groupedNotifications → grouped by date', () async {
      final vm = NotificationsViewModel();
      await vm.init();

      final grouped = vm.groupedNotifications;

      // Should have at least 1 group (mock data spans multiple days)
      expect(grouped, isNotEmpty);
      // Each key is a date-only DateTime (no time component)
      for (final date in grouped.keys) {
        expect(date.hour, 0);
        expect(date.minute, 0);
        expect(date.second, 0);
      }
      // Total notifications across groups = all filtered
      final totalInGroups =
          grouped.values.fold<int>(0, (sum, list) => sum + list.length);
      expect(totalInGroups, vm.filteredNotifications.length);
    });
  });
}
