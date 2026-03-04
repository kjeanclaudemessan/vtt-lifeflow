import 'package:dartz/dartz.dart';

import '../../app/app.locator.dart';
import '../../core/errors/error_handler.dart';
import '../../core/typedefs/typedefs.dart';
import '../../data/models/notification_model.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/i_notification_repository.dart';
import '../../services/supabase/supabase_service.dart';

/// Implementation of [INotificationRepository] using Supabase.
class NotificationRepositoryImpl implements INotificationRepository {
  final SupabaseService _supabaseService;

  NotificationRepositoryImpl({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? locator<SupabaseService>();

  /// Current authenticated user ID.
  String get _userId => _supabaseService.client.auth.currentUser!.id;

  // ─────────────────────────────────────────────────────────────────
  // Read
  // ─────────────────────────────────────────────────────────────────

  @override
  FutureResult<List<NotificationEntity>> getNotifications() async {
    try {
      final response = await _supabaseService.client
          .from('notifications')
          .select()
          .eq('user_id', _userId)
          .order('created_at', ascending: false);

      final notifications = (response as List)
          .map((json) =>
              NotificationModel.fromJson(json as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();

      return Right(notifications);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<int> getUnreadCount() async {
    try {
      final response = await _supabaseService.client
          .from('notifications')
          .select('id')
          .eq('user_id', _userId)
          .eq('is_read', false);

      return Right((response as List).length);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Update
  // ─────────────────────────────────────────────────────────────────

  @override
  FutureResult<void> markAsRead(String notificationId) async {
    try {
      await _supabaseService.client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId)
          .eq('user_id', _userId);

      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<void> markAllAsRead() async {
    try {
      await _supabaseService.client
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', _userId)
          .eq('is_read', false);

      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Delete
  // ─────────────────────────────────────────────────────────────────

  @override
  FutureResult<void> deleteNotification(String notificationId) async {
    try {
      await _supabaseService.client
          .from('notifications')
          .delete()
          .eq('id', notificationId)
          .eq('user_id', _userId);

      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<void> clearAll() async {
    try {
      await _supabaseService.client
          .from('notifications')
          .delete()
          .eq('user_id', _userId);

      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }
}
