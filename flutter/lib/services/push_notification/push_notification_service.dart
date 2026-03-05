import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../app/app.locator.dart';
import '../supabase/supabase_service.dart';

/// Service for push notifications using Firebase Cloud Messaging (FCM)
/// and flutter_local_notifications for foreground display.
///
/// Features:
/// - FCM token management (get, refresh, save to backend)
/// - Permission request (iOS)
/// - Foreground notification display via local notifications
/// - Background/terminated notification handling
/// - Topic subscription
///
/// Requires:
/// - `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)
/// - Firebase project configured with FCM
///
/// Usage:
/// ```dart
/// final pushService = locator<PushNotificationService>();
/// await pushService.init();
/// final token = await pushService.getToken();
/// ```
class PushNotificationService {
  FirebaseMessaging? _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Whether the service is initialized and ready.
  bool get isInitialized => _isInitialized;

  /// FCM token for this device.
  String? _token;
  String? get token => _token;

  /// Callback when a notification is tapped (app was in background/terminated).
  void Function(Map<String, dynamic> data)? onNotificationTapped;

  /// Callback when FCM token refreshes.
  void Function(String newToken)? onTokenRefresh;

  /// Android notification channel for foreground notifications.
  static const _androidChannel = AndroidNotificationChannel(
    'lifeflow_default',
    'LifeFlow Notifications',
    description: 'Default notification channel for LifeFlow',
    importance: Importance.high,
  );

  /// Initializes push notification service.
  ///
  /// Safely handles the case where Firebase is not configured
  /// (no google-services.json). In that case, the service remains
  /// disabled and all methods are no-ops.
  Future<void> init() async {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isEmpty) {
        debugPrint('[Push] Firebase not initialized — push disabled');
        return;
      }

      _messaging = FirebaseMessaging.instance;

      // Request permission (iOS)
      if (!kIsWeb && Platform.isIOS) {
        final settings = await _messaging!.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );
        if (settings.authorizationStatus == AuthorizationStatus.denied) {
          debugPrint('[Push] Permission denied');
          return;
        }
      }

      // Android: also request permission (Android 13+)
      if (!kIsWeb && Platform.isAndroid) {
        await _messaging!.requestPermission();
      }

      // Setup local notifications for foreground display
      await _setupLocalNotifications();

      // Get initial token
      _token = await _messaging!.getToken();
      debugPrint('[Push] FCM Token: ${_token?.substring(0, 20)}...');

      // Listen for token refresh
      _messaging!.onTokenRefresh.listen((newToken) {
        _token = newToken;
        onTokenRefresh?.call(newToken);
        saveTokenToSupabase();
        debugPrint('[Push] Token refreshed');
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps (app in background)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Handle notification that launched the app (terminated state)
      final initialMessage = await _messaging!.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      _isInitialized = true;
      debugPrint('[Push] Push notification service initialized');
    } catch (e) {
      debugPrint('[Push] Failed to initialize: $e');
    }
  }

  /// Gets the current FCM token.
  Future<String?> getToken() async {
    if (!_isInitialized) return null;
    _token = await _messaging?.getToken();
    return _token;
  }

  /// Subscribes to a topic for targeted push notifications.
  Future<void> subscribeTopic(String topic) async {
    if (!_isInitialized) return;
    await _messaging?.subscribeToTopic(topic);
    debugPrint('[Push] Subscribed to topic: $topic');
  }

  /// Unsubscribes from a topic.
  Future<void> unsubscribeTopic(String topic) async {
    if (!_isInitialized) return;
    await _messaging?.unsubscribeFromTopic(topic);
    debugPrint('[Push] Unsubscribed from topic: $topic');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Token persistence (Supabase device_tokens)
  // ═══════════════════════════════════════════════════════════════════════

  /// Saves the current FCM token to Supabase `device_tokens` table.
  ///
  /// Call this after login or when the user is authenticated.
  /// Uses upsert to avoid duplicates (unique constraint on user_id + token).
  Future<void> saveTokenToSupabase() async {
    if (_token == null) return;

    try {
      final supabase = locator<SupabaseService>().client;
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('[Push] No authenticated user — skipping token save');
        return;
      }

      final platform = kIsWeb
          ? 'web'
          : Platform.isAndroid
              ? 'android'
              : 'ios';

      await supabase.from('device_tokens').upsert(
        {
          'user_id': userId,
          'token': _token,
          'platform': platform,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'user_id,token',
      );

      debugPrint('[Push] Token saved to Supabase');
    } catch (e) {
      debugPrint('[Push] Failed to save token: $e');
    }
  }

  /// Removes the current device's FCM token from Supabase.
  ///
  /// Call this on logout to stop receiving push notifications on this device.
  Future<void> removeTokenFromSupabase() async {
    if (_token == null) return;

    try {
      final supabase = locator<SupabaseService>().client;
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase
          .from('device_tokens')
          .delete()
          .eq('user_id', userId)
          .eq('token', _token!);

      debugPrint('[Push] Token removed from Supabase');
    } catch (e) {
      debugPrint('[Push] Failed to remove token: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Private helpers
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _setupLocalNotifications() async {
    // Android initialization
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // Already requested via FCM
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap from foreground notification
        if (response.payload != null) {
          onNotificationTapped?.call({'payload': response.payload});
        }
      },
    );

    // Create Android notification channel
    if (!kIsWeb && Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[Push] Foreground message: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    // Display as local notification (FCM doesn't show in foreground by default)
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    debugPrint(
        '[Push] Notification tapped: ${message.notification?.title}');
    onNotificationTapped?.call(message.data);
  }
}

/// Top-level background message handler.
///
/// Must be a top-level function (not a class method).
/// Register in main.dart: `FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);`
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('[Push] Background message: ${message.messageId}');
}
