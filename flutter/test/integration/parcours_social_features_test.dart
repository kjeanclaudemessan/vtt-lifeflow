/// Parcours 6 — Social Features: Tags → Comments → Favorites → Activities
///
/// End-to-end flow: user creates tags, comments on an entity, favorites it,
/// and all activities are logged.
/// Tests the REAL optional module services against local Supabase.
///
/// Run: dart test test/integration/parcours_social_features_test.dart
/// Requires: `supabase start` running locally.
@TestOn('vm')
library;

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';
import 'package:lifeflow/modules/optional/activities/activity_service.dart';
import 'package:lifeflow/modules/optional/comments/comment_service.dart';
import 'package:lifeflow/modules/optional/favorites/favorite_service.dart';
import 'package:lifeflow/modules/optional/tags/tag_service.dart';

import 'viewmodel_test_helper.dart';
import 'optional/optional_test_helper.dart';

void main() {
  late String testEmail;
  const testPassword = 'Test123456!';

  // Synthetic entity for polymorphic operations
  late String testEntityId;
  const testEntityType = 'test_entity';

  // Shared state across sequential tests
  late String createdTagId;
  late String createdCommentId;

  setUpAll(() async {
    await ViewModelTestHelper.initialize();

    testEmail = generateVmTestEmail();
    testEntityId = _generateUuid();

    await ViewModelTestHelper.createUser(
      email: testEmail,
      password: testPassword,
      firstName: 'Social',
      lastName: 'Tester',
    );
  });

  tearDownAll(() async {
    await ViewModelTestHelper.signOut();
    await OptionalTestHelper.cleanupAllTestData();
    await ViewModelTestHelper.deleteUser(testEmail);
    await ViewModelTestHelper.cleanup();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Parcours 6 — Social Features
  // ═══════════════════════════════════════════════════════════════════════════

  group('Parcours 6 — Social Features', () {
    test('P6-1: Login → session active', () async {
      await ViewModelTestHelper.signIn(email: testEmail);
      // Wait for profile trigger
      await Future.delayed(const Duration(milliseconds: 500));

      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Tags
    // ─────────────────────────────────────────────────────────────────────────

    test('P6-2: TagService.createTag() → user-scoped tag created', () async {
      final tagService = TagService();

      final result = await tagService.createTag(
        name: 'Test Social Tag',
        color: '#FF5733',
        category: 'test',
      );

      result.fold(
        (failure) => fail('createTag failed: ${failure.message}'),
        (tag) {
          expect(tag.name, 'Test Social Tag');
          expect(tag.color, '#FF5733');
          expect(tag.id, isNotEmpty);
          expect(tag.slug, isNotEmpty);
          createdTagId = tag.id;
        },
      );
    });

    test('P6-3: TagService.tagEntity() → tag associated to entity', () async {
      final tagService = TagService();

      final result = await tagService.tagEntity(
        tagId: createdTagId,
        entityType: testEntityType,
        entityId: testEntityId,
      );

      result.fold(
        (failure) => fail('tagEntity failed: ${failure.message}'),
        (_) {
          // Association created successfully
        },
      );
    });

    test('P6-4: TagService.getEntityTags() → tag visible on entity', () async {
      final tagService = TagService();

      final result = await tagService.getEntityTags(
        entityType: testEntityType,
        entityId: testEntityId,
      );

      result.fold(
        (failure) => fail('getEntityTags failed: ${failure.message}'),
        (tags) {
          expect(tags, isNotEmpty);
          expect(tags.any((t) => t.id == createdTagId), isTrue);
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Comments
    // ─────────────────────────────────────────────────────────────────────────

    test('P6-5: CommentService.addComment() → comment created', () async {
      final commentService = CommentService();

      final result = await commentService.addComment(
        entityType: testEntityType,
        entityId: testEntityId,
        content: 'This is a test comment from parcours 6',
      );

      result.fold(
        (failure) => fail('addComment failed: ${failure.message}'),
        (comment) {
          expect(comment.content, 'This is a test comment from parcours 6');
          expect(comment.userId, isNotEmpty);
          expect(comment.id, isNotEmpty);
          createdCommentId = comment.id;
        },
      );
    });

    test('P6-6: CommentService.loadComments() → comment visible', () async {
      final commentService = CommentService();

      final result = await commentService.loadComments(
        entityType: testEntityType,
        entityId: testEntityId,
      );

      result.fold(
        (failure) => fail('loadComments failed: ${failure.message}'),
        (comments) {
          expect(comments, isNotEmpty);
          expect(
            comments.any((c) => c.id == createdCommentId),
            isTrue,
          );
        },
      );
    });

    test('P6-7: CommentService.toggleLike() → like toggled', () async {
      final commentService = CommentService();

      final result = await commentService.toggleLike(createdCommentId);

      result.fold(
        (failure) => fail('toggleLike failed: ${failure.message}'),
        (isLiked) {
          expect(isLiked, isTrue);
        },
      );
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Favorites
    // ─────────────────────────────────────────────────────────────────────────

    test('P6-8: FavoriteService.toggleFavorite() → favorite added', () async {
      final favoriteService = FavoriteService();

      final result = await favoriteService.toggleFavorite(
        entityType: testEntityType,
        entityId: testEntityId,
      );

      result.fold(
        (failure) => fail('toggleFavorite failed: ${failure.message}'),
        (isFavorited) {
          expect(isFavorited, isTrue);
        },
      );
    });

    test('P6-9: FavoriteService.isFavorite() → returns true', () async {
      final favoriteService = FavoriteService();

      // Check local cache first
      final localCheck = favoriteService.isFavorite(
        testEntityType,
        testEntityId,
      );
      // If cache is empty, check via repo
      if (!localCheck) {
        // Load favorites to populate cache
        await favoriteService.loadFavorites(entityType: testEntityType);
        final afterLoad = favoriteService.isFavorite(
          testEntityType,
          testEntityId,
        );
        expect(afterLoad, isTrue);
      } else {
        expect(localCheck, isTrue);
      }
    });

    // ─────────────────────────────────────────────────────────────────────────
    // Activities
    // ─────────────────────────────────────────────────────────────────────────

    test('P6-10: ActivityService.logActivity() → activity recorded', () async {
      final activityService = ActivityService();

      final result = await activityService.logActivity(
        action: 'test_action',
        targetType: testEntityType,
        targetId: testEntityId,
        targetName: 'Test Entity',
        description: 'Parcours 6 test activity',
      );

      result.fold(
        (failure) => fail('logActivity failed: ${failure.message}'),
        (activity) {
          expect(activity.action, 'test_action');
          expect(activity.targetType, testEntityType);
          expect(activity.targetId, testEntityId);
        },
      );
    });

    test('P6-11: ActivityService.loadEntityActivities() → history visible',
        () async {
      final activityService = ActivityService();

      final result = await activityService.loadEntityActivities(
        entityType: testEntityType,
        entityId: testEntityId,
      );

      result.fold(
        (failure) => fail('loadEntityActivities failed: ${failure.message}'),
        (activities) {
          expect(activities, isNotEmpty);
          expect(
            activities.any((a) => a.action == 'test_action'),
            isTrue,
          );
        },
      );
    });
  });
}

/// Generate a valid UUID v4 for test entity IDs.
String _generateUuid() {
  final rng = Random();
  String _hex(int count) =>
      List.generate(count, (_) => rng.nextInt(16).toRadixString(16)).join();
  return '${_hex(8)}-${_hex(4)}-4${_hex(3)}-${(8 + rng.nextInt(4)).toRadixString(16)}${_hex(3)}-${_hex(12)}';
}
