import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';

/// Notification payload types.
///
/// Used to determine which screen to navigate to when a notification is tapped.
enum NotificationType {
  habitReminder,
  weeklyBilan,
  streak,
  general,
}

/// Routes notification taps to the correct screen.
///
/// Handles payloads from both local notifications and push notifications (FCM).
/// Registered as a singleton in the locator.
///
/// Usage in bootstrap:
/// ```dart
/// final router = locator<NotificationRouter>();
/// pushService.onNotificationTapped = router.handlePushTap;
/// localScheduler.onNotificationTapped = router.handleLocalTap;
/// ```
class NotificationRouter {
  final NavigationService _navigationService = locator<NavigationService>();

  /// Handles a tap on a local notification.
  ///
  /// [payload] is a JSON-encoded string with `type` and optional data fields.
  void handleLocalTap(String? payload) {
    if (payload == null || payload.isEmpty) {
      _navigateToHome();
      return;
    }

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _routeFromData(data);
    } catch (e) {
      debugPrint('[NotifRouter] Failed to parse local payload: $e');
      _navigateToHome();
    }
  }

  /// Handles a tap on a push notification (FCM).
  ///
  /// [data] is the raw data map from the FCM message.
  void handlePushTap(Map<String, dynamic> data) {
    _routeFromData(data);
  }

  /// Routes to the correct screen based on notification data.
  void _routeFromData(Map<String, dynamic> data) {
    final typeStr = data['type'] as String? ?? 'general';
    final type = NotificationType.values.firstWhere(
      (t) => t.name == typeStr,
      orElse: () => NotificationType.general,
    );

    debugPrint('[NotifRouter] Routing: type=$type, data=$data');

    switch (type) {
      case NotificationType.habitReminder:
        // Navigate to today view to check off the habit
        _navigationService.clearStackAndShow(Routes.homeView);

      case NotificationType.weeklyBilan:
        // Navigate to bilan view
        _navigationService.clearStackAndShow(Routes.homeView);
        // After home is loaded, navigate to bilan
        Future.delayed(const Duration(milliseconds: 300), () {
          _navigationService.navigateTo(Routes.bilanView);
        });

      case NotificationType.streak:
        // Navigate to today view to see streaks
        _navigationService.clearStackAndShow(Routes.homeView);

      case NotificationType.general:
        _navigateToHome();
    }
  }

  void _navigateToHome() {
    _navigationService.clearStackAndShow(Routes.homeView);
  }
}
