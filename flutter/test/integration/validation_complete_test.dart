/// ══════════════════════════════════════════════════════════════════════════
/// VALIDATION COMPLÈTE — Tous les ViewModels + Services contre Supabase réel
///
/// ⚠️  PAS DE CLEANUP — Les données RESTENT dans la DB pour inspection.
///     Ouvrir http://127.0.0.1:54323 (Supabase Studio) après exécution.
///
/// Pré-requis : supabase db reset && supabase start
/// Run : flutter test test/integration/validation_complete_test.dart --reporter expanded
///
/// SCÉNARIO :
///   1. Amadou Diallo : owner, crée l'org, invite, souscrit, tag, comment, favorite, activity, payment
///   2. Fatou Bah : invitée, accepte l'invitation
///   Toutes les données persistent dans la DB pour vérification visuelle.
/// ══════════════════════════════════════════════════════════════════════════
@TestOn('vm')
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lifeflow/modules/auth/viewmodels/forgot_password_viewmodel.dart';
import 'package:lifeflow/modules/auth/viewmodels/login_viewmodel.dart';
import 'package:lifeflow/modules/auth/viewmodels/register_viewmodel.dart';
import 'package:lifeflow/modules/notifications/config/notifications_config.dart';
import 'package:lifeflow/modules/notifications/viewmodels/notifications_viewmodel.dart';
import 'package:lifeflow/modules/onboarding/viewmodels/onboarding_viewmodel.dart';
import 'package:lifeflow/modules/profile/viewmodels/edit_profile_viewmodel.dart';
import 'package:lifeflow/modules/profile/viewmodels/profile_viewmodel.dart';
import 'package:lifeflow/modules/settings/viewmodels/settings_viewmodel.dart';
import 'package:lifeflow/modules/splash/config/splash_config.dart';
import 'package:lifeflow/modules/splash/viewmodels/splash_viewmodel.dart';
import 'package:lifeflow/modules/optional/activities/activity_service.dart';
import 'package:lifeflow/modules/optional/attachments/attachment_service.dart';
import 'package:lifeflow/modules/optional/comments/comment_service.dart';
import 'package:lifeflow/modules/optional/favorites/favorite_service.dart';
import 'package:lifeflow/modules/optional/invitations/invitation_service.dart';
import 'package:lifeflow/modules/optional/organizations/organization_service.dart';
import 'package:lifeflow/modules/optional/payments/payment_service.dart';
import 'package:lifeflow/modules/optional/subscriptions/subscription_service.dart';
import 'package:lifeflow/modules/optional/tags/tag_service.dart';
import 'package:lifeflow/services/moneroo/moneroo_service.dart';

import 'viewmodel_test_helper.dart';
import 'optional/optional_test_helper.dart';

final _locator = GetIt.instance;

/// Emails fixes pour ce test — les données restent dans la DB
const _amadouEmail = 'amadou.diallo.valid@example.com';
const _fatouEmail = 'fatou.bah.valid@example.com';
const _password = 'Test123456!';

/// State partagé entre les parcours (tests séquentiels)
String? _orgId;
String? _invitationToken;
String? _createdTagId;
String? _createdCommentId;
String? _uploadedAttachmentId;
String? _createdPaymentId;
String? _planId;

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // SETUP GLOBAL — PAS DE CLEANUP
  // ─────────────────────────────────────────────────────────────────────────

  setUpAll(() async {
    await ViewModelTestHelper.initialize();

    // Register MonerooService (required by PaymentService)
    if (!_locator.isRegistered<MonerooService>()) {
      _locator.registerSingleton<MonerooService>(MonerooService());
    }

    // Supprimer les anciens utilisateurs de test s'ils existent
    await ViewModelTestHelper.deleteUser(_amadouEmail);
    await ViewModelTestHelper.deleteUser(_fatouEmail);

    // Nettoyer les anciennes données
    await OptionalTestHelper.cleanupAllTestData();

    await ViewModelTestHelper.signOut();
  });

  // ⚠️ PAS de tearDownAll — les données RESTENT

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 1 — Splash + Onboarding (SplashVM, OnboardingVM)
  //
  // Simule le tout premier lancement de l'app :
  // - Splash détecte qu'il n'y a pas de session → goToOnboarding
  // - L'utilisateur parcourt les slides d'onboarding
  // - L'utilisateur finit l'onboarding → skip() persiste le flag
  // - Re-splash → onboarding fait, pas de session → goToLogin
  // ═══════════════════════════════════════════════════════════════════════════

  group('P1 — Splash + Onboarding', () {
    test('P1-1: SplashVM sans session → goToOnboarding', () async {
      await ViewModelTestHelper.localStorage.clear();
      final vm = SplashViewModel();
      try {
        await vm.initialize();
      } catch (_) {}

      expect(vm.result, SplashResult.goToOnboarding);
    });

    test('P1-2: OnboardingVM — page 0, pas dernière slide', () {
      final vm = OnboardingViewModel();
      expect(vm.currentIndex, 0);
      expect(vm.isFirstSlide, isTrue);
      expect(vm.isLastSlide, isFalse);
    });

    test('P1-3: OnboardingVM.next() parcourt toutes les slides', () {
      final vm = OnboardingViewModel();
      final count = vm.config.slideCount;
      for (int i = 0; i < count - 1; i++) {
        expect(vm.currentIndex, i);
        vm.next();
      }
      expect(vm.currentIndex, count - 1);
      expect(vm.isLastSlide, isTrue);
    });

    test('P1-4: OnboardingVM.skip() persiste onboarding_completed', () async {
      final vm = OnboardingViewModel();
      try {
        vm.skip();
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 100));
      final completed =
          ViewModelTestHelper.localStorage.getBool(vm.config.storageKey);
      expect(completed, isTrue);
    });

    test('P1-5: Re-splash → onboarding fait, pas de session → goToLogin',
        () async {
      await ViewModelTestHelper.localStorage
          .setBool('onboarding_completed', true);
      final vm = SplashViewModel();
      try {
        await vm.initialize();
      } catch (_) {}
      expect(vm.result, SplashResult.goToLogin);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 2 — Register Amadou (RegisterVM)
  //
  // Amadou Diallo s'inscrit via RegisterViewModel :
  // - Remplit firstName, lastName, email, password
  // - register() crée le compte dans Supabase + auto-login
  // - La session est active après inscription
  // ═══════════════════════════════════════════════════════════════════════════

  group('P2 — Register Amadou', () {
    test('P2-1: RegisterVM → inscription Amadou Diallo', () async {
      await ViewModelTestHelper.signOut();
      final vm = RegisterViewModel();
      vm.setFirstName('Amadou');
      vm.setLastName('Diallo');
      vm.setEmail(_amadouEmail);
      vm.setPassword(_password);
      if (vm.config.showTermsCheckbox) {
        vm.setAcceptedTerms(true);
      }
      expect(vm.canSubmit, isTrue);
      try {
        await vm.register();
      } catch (_) {}
      expect(vm.hasError, isFalse);
      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
    });

    test('P2-2: ProfileVM après inscription → profil chargé', () async {
      // Amadou est déjà connecté du test précédent
      await Future.delayed(const Duration(milliseconds: 500));
      final vm = ProfileViewModel();
      await vm.init();
      expect(vm.user, isNotNull);
      expect(vm.email, _amadouEmail);
      expect(vm.hasError, isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 3 — EditProfile (EditProfileVM)
  //
  // Amadou modifie son profil :
  // - EditProfileVM.init() pré-remplit les champs
  // - setFieldValue('display_name', ...) → isDirty = true
  // - save() persiste via RPC update_my_profile
  // - ProfileVM.loadProfile() → displayName mis à jour
  // ═══════════════════════════════════════════════════════════════════════════

  group('P3 — Edit Profile', () {
    test('P3-1: EditProfileVM.init() → champs pré-remplis', () async {
      final vm = EditProfileViewModel();
      await vm.init();
      expect(vm.hasError, isFalse);
    });

    test('P3-2: setFieldValue → isDirty = true, canSubmit = true', () async {
      final vm = EditProfileViewModel();
      await vm.init();
      expect(vm.isDirty, isFalse);
      vm.setFieldValue('display_name', 'Amadou Diallo Pro');
      expect(vm.isDirty, isTrue);
      expect(vm.isValid, isTrue);
      expect(vm.canSubmit, isTrue);
    });

    test('P3-3: EditProfileVM.save() → persiste le changement', () async {
      final vm = EditProfileViewModel();
      await vm.init();
      vm.setFieldValue('display_name', 'Amadou Diallo Pro');
      try {
        await vm.save();
      } catch (_) {}
      expect(vm.hasError, isFalse);
    });

    test('P3-4: ProfileVM.loadProfile() → displayName mis à jour', () async {
      final vm = ProfileViewModel();
      await vm.loadProfile();
      expect(vm.user, isNotNull);
      expect(vm.displayName, contains('Amadou'));
      expect(vm.hasError, isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 4 — Settings (SettingsVM)
  //
  // Amadou change ses préférences :
  // - init() → thème system, locale fr, notifications on
  // - setThemeMode(dark) → persiste dans LocalStorage
  // - setLocale(en) → persiste dans LocalStorage
  // - Les préférences sont restaurées après re-init
  // ═══════════════════════════════════════════════════════════════════════════

  group('P4 — Settings', () {
    test('P4-1: SettingsVM.init() → préférences par défaut', () async {
      final vm = SettingsViewModel();
      await vm.init();
      expect(vm.themeMode, ThemeMode.system);
      expect(vm.locale, const Locale('fr'));
      expect(vm.pushNotificationsEnabled, isTrue);
      expect(vm.hasError, isFalse);
    });

    test('P4-2: setThemeMode(dark) → persiste', () async {
      final vm = SettingsViewModel();
      await vm.init();
      await vm.setThemeMode(ThemeMode.dark);
      expect(vm.themeMode, ThemeMode.dark);
      final stored = ViewModelTestHelper.localStorage.getInt('theme_mode');
      expect(stored, ThemeMode.dark.index);
    });

    test('P4-3: setLocale(en) → persiste', () async {
      final vm = SettingsViewModel();
      await vm.init();
      await vm.setLocale(const Locale('en'));
      expect(vm.locale, const Locale('en'));
      final stored = ViewModelTestHelper.localStorage.getString('locale');
      expect(stored, 'en');
    });

    test('P4-4: Préférences restaurées après re-init', () async {
      final vm = SettingsViewModel();
      await vm.init();
      expect(vm.themeMode, ThemeMode.dark);
      expect(vm.locale, const Locale('en'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 5 — ForgotPassword (ForgotPasswordVM)
  //
  // Amadou demande un reset de mot de passe :
  // - setEmail() + sendResetEmail() → emailSent = true
  // - Pas d'erreur, le reset email est envoyé via Supabase
  // ═══════════════════════════════════════════════════════════════════════════

  group('P5 — Forgot Password', () {
    test('P5-1: ForgotPasswordVM → email envoyé sans erreur', () async {
      final vm = ForgotPasswordViewModel();
      vm.setEmail(_amadouEmail);
      expect(vm.canSubmit, isTrue);
      await vm.sendResetEmail();
      expect(vm.hasError, isFalse);
      expect(vm.emailSent, isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 6 — Notifications (NotificationsVM)
  //
  // Amadou gère ses notifications (mock data intégrées au VM) :
  // - init() → 5 notifications mock chargées, 4 non lues
  // - setFilter(marketing) → filtre les notifications
  // - markAsRead('1') → décremente unreadCount
  // - markAllAsRead() → tout lu
  // - deleteNotification('1') → supprimée de la liste
  // - clearAll() → liste vide
  // - groupedNotifications → groupées par date
  // ═══════════════════════════════════════════════════════════════════════════

  group('P6 — Notifications', () {
    test('P6-1: NotificationsVM.init() → 5 items, 4 non lues', () async {
      final vm = NotificationsViewModel();
      await vm.init();
      expect(vm.hasNotifications, isTrue);
      expect(vm.notifications.length, 5);
      expect(vm.unreadCount, 4);
      expect(vm.allRead, isFalse);
    });

    test('P6-2: setFilter(marketing) → filtre, clearFilter → tout', () async {
      final vm = NotificationsViewModel();
      await vm.init();
      vm.setFilter(NotificationType.marketing);
      expect(vm.filteredNotifications.length, 1);
      vm.clearFilter();
      expect(vm.filteredNotifications.length, 5);
    });

    test('P6-3: markAsRead → unreadCount décremente', () async {
      final vm = NotificationsViewModel();
      await vm.init();
      final before = vm.unreadCount;
      await vm.markAsRead('1');
      expect(vm.unreadCount, before - 1);
    });

    test('P6-4: markAllAsRead → unreadCount = 0', () async {
      final vm = NotificationsViewModel();
      await vm.init();
      await vm.markAllAsRead();
      expect(vm.unreadCount, 0);
      expect(vm.allRead, isTrue);
    });

    test('P6-5: deleteNotification → supprimée', () async {
      final vm = NotificationsViewModel();
      await vm.init();
      await vm.deleteNotification('1');
      expect(vm.notifications.length, 4);
      expect(vm.notifications.any((n) => n.id == '1'), isFalse);
    });

    test('P6-6: clearAll → vide', () async {
      final vm = NotificationsViewModel();
      await vm.init();
      await vm.clearAll();
      expect(vm.hasNotifications, isFalse);
      expect(vm.notifications, isEmpty);
    });

    test('P6-7: groupedNotifications → groupées par date', () async {
      final vm = NotificationsViewModel();
      await vm.init();
      final grouped = vm.groupedNotifications;
      expect(grouped, isNotEmpty);
      for (final date in grouped.keys) {
        expect(date.hour, 0);
        expect(date.minute, 0);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 7 — Organization + Members (OrganizationService)
  //
  // Amadou crée une organisation :
  // - createOrganization('IronFlow Industries') → org créée avec slug auto
  // - loadUserOrganizations() → contient l'org
  // - selectOrganization() + loadMembers() → Amadou est owner
  // ═══════════════════════════════════════════════════════════════════════════

  group('P7 — Organization + Members', () {
    test('P7-1: OrganizationService.createOrganization()', () async {
      final svc = OrganizationService();
      final result = await svc.createOrganization(
        name: 'IronFlow Industries',
        description: 'Forge industrielle',
      );
      result.fold(
        (f) => fail('createOrganization failed: ${f.message}'),
        (org) {
          expect(org.name, 'IronFlow Industries');
          expect(org.id, isNotEmpty);
          _orgId = org.id;
        },
      );
    });

    test('P7-2: loadUserOrganizations() → contient IronFlow', () async {
      final svc = OrganizationService();
      final result = await svc.loadUserOrganizations();
      result.fold(
        (f) => fail('loadUserOrganizations failed: ${f.message}'),
        (orgs) {
          expect(orgs, isNotEmpty);
          expect(orgs.any((o) => o.name == 'IronFlow Industries'), isTrue);
        },
      );
    });

    test('P7-3: loadMembers() → Amadou est owner', () async {
      final svc = OrganizationService();
      await svc.selectOrganization(_orgId!);
      final result = await svc.loadMembers();
      result.fold(
        (f) => fail('loadMembers failed: ${f.message}'),
        (members) {
          expect(members, isNotEmpty);
          expect(
            members
                .any((m) => m.role.name == 'owner' || m.role.name == 'admin'),
            isTrue,
          );
        },
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 8 — Invitation (InvitationService)
  //
  // Amadou invite Fatou à rejoindre IronFlow :
  // - sendInvitation(email: fatou) → invitation avec token
  // - loadOrganizationInvitations() → invitation visible
  // ═══════════════════════════════════════════════════════════════════════════

  group('P8 — Invitation', () {
    test('P8-0: Créer le compte Fatou (admin)', () async {
      // On crée le compte Fatou via admin pour qu'elle puisse accepter
      await ViewModelTestHelper.createUser(
        email: _fatouEmail,
        password: _password,
        firstName: 'Fatou',
        lastName: 'Bah',
      );
    });

    test('P8-1: InvitationService.sendInvitation() → invitation créée',
        () async {
      final svc = InvitationService();
      final result = await svc.sendInvitation(
        organizationId: _orgId!,
        email: _fatouEmail,
        role: 'member',
        message: 'Bienvenue chez IronFlow!',
      );
      result.fold(
        (f) => fail('sendInvitation failed: ${f.message}'),
        (inv) {
          expect(inv.email, _fatouEmail);
          expect(inv.token, isNotEmpty);
          expect(inv.status.name, 'pending');
          _invitationToken = inv.token;
        },
      );
    });

    test('P8-2: loadOrganizationInvitations() → invitation visible', () async {
      final svc = InvitationService();
      final result = await svc.loadOrganizationInvitations(_orgId!);
      result.fold(
        (f) => fail('loadOrganizationInvitations failed: ${f.message}'),
        (invs) {
          expect(invs, isNotEmpty);
          expect(invs.any((i) => i.email == _fatouEmail), isTrue);
        },
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 9 — Subscription (SubscriptionService)
  //
  // Amadou souscrit à un plan pour IronFlow :
  // - Création d'un plan de test via admin
  // - loadAvailablePlans() → plans disponibles
  // - subscribe(orgId, planId) → abonnement actif
  // - loadSubscription() → abonnement vérifié
  // - hasFeature() → vérifie les features du plan
  // ═══════════════════════════════════════════════════════════════════════════

  group('P9 — Subscription', () {
    test('P9-1: Créer un plan de test + loadAvailablePlans()', () async {
      _planId = await OptionalTestHelper.createTestPlan(
        name: 'Test Plan IronFlow',
        code: 'ironflow-${DateTime.now().millisecondsSinceEpoch}',
        priceMonthly: 2999,
      );
      final svc = SubscriptionService();
      final result = await svc.loadAvailablePlans();
      result.fold(
        (f) => fail('loadAvailablePlans failed: ${f.message}'),
        (plans) {
          expect(plans, isNotEmpty);
          expect(plans.any((p) => p.name == 'Test Plan IronFlow'), isTrue);
        },
      );
    });

    test('P9-2: subscribe() → abonnement actif', () async {
      final svc = SubscriptionService();
      final result = await svc.subscribe(
        organizationId: _orgId!,
        planId: _planId!,
      );
      result.fold(
        (f) => fail('subscribe failed: ${f.message}'),
        (sub) {
          expect(sub.organizationId, _orgId);
          expect(sub.planId, _planId);
          expect(sub.status.name, anyOf(equals('active'), equals('trialing')));
        },
      );
    });

    test('P9-3: loadSubscription() → correct plan', () async {
      final svc = SubscriptionService();
      final result = await svc.loadSubscription(organizationId: _orgId!);
      result.fold(
        (f) => fail('loadSubscription failed: ${f.message}'),
        (sub) {
          expect(sub, isNotNull);
          expect(sub!.planId, _planId);
        },
      );
    });

    test('P9-4: hasFeature() → vérifie features du plan', () async {
      final svc = SubscriptionService();
      await svc.init(organizationId: _orgId!);
      // _loadPlan is fire-and-forget inside loadSubscription — wait for it
      await Future.delayed(const Duration(milliseconds: 500));
      expect(svc.hasFeature('feature1'), isTrue);
      expect(svc.hasFeature('nonexistent'), isFalse);
      expect(svc.getFeatureLimit('max_members'), 5);
      expect(svc.isLimitReached('max_members', 5), isTrue);
      expect(svc.isLimitReached('max_members', 3), isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 10 — Tags (TagService)
  //
  // Amadou crée un tag et l'associe à une entité :
  // - createTag('Forge Premium') → tag créé
  // - tagEntity(entityType, entityId) → association
  // - getEntityTags() → tag visible sur l'entité
  // ═══════════════════════════════════════════════════════════════════════════

  group('P10 — Tags', () {
    final testEntityId = _generateUuid();
    const testEntityType = 'test_entity';

    test('P10-1: TagService.createTag() → tag créé', () async {
      final svc = TagService();
      final result = await svc.createTag(
        name: 'Forge Premium',
        color: '#FF5733',
        category: 'quality',
      );
      result.fold(
        (f) => fail('createTag failed: ${f.message}'),
        (tag) {
          expect(tag.name, 'Forge Premium');
          expect(tag.id, isNotEmpty);
          _createdTagId = tag.id;
        },
      );
    });

    test('P10-2: tagEntity() → association créée', () async {
      final svc = TagService();
      final result = await svc.tagEntity(
        tagId: _createdTagId!,
        entityType: testEntityType,
        entityId: testEntityId,
      );
      result.fold(
        (f) => fail('tagEntity failed: ${f.message}'),
        (_) {},
      );
    });

    test('P10-3: getEntityTags() → tag visible', () async {
      final svc = TagService();
      final result = await svc.getEntityTags(
        entityType: testEntityType,
        entityId: testEntityId,
      );
      result.fold(
        (f) => fail('getEntityTags failed: ${f.message}'),
        (tags) {
          expect(tags, isNotEmpty);
          expect(tags.any((t) => t.id == _createdTagId), isTrue);
        },
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 11 — Comments (CommentService)
  //
  // Amadou commente une entité :
  // - addComment() → commentaire créé
  // - loadComments() → commentaire visible
  // - toggleLike() → like basculé
  // ═══════════════════════════════════════════════════════════════════════════

  group('P11 — Comments', () {
    final testEntityId = _generateUuid();
    const testEntityType = 'test_entity';

    test('P11-1: CommentService.addComment() → commentaire créé', () async {
      final svc = CommentService();
      final result = await svc.addComment(
        entityType: testEntityType,
        entityId: testEntityId,
        content: 'Excellente forge, qualité exceptionnelle!',
      );
      result.fold(
        (f) => fail('addComment failed: ${f.message}'),
        (comment) {
          expect(comment.content, 'Excellente forge, qualité exceptionnelle!');
          expect(comment.id, isNotEmpty);
          _createdCommentId = comment.id;
        },
      );
    });

    test('P11-2: loadComments() → commentaire visible', () async {
      final svc = CommentService();
      final result = await svc.loadComments(
        entityType: testEntityType,
        entityId: testEntityId,
      );
      result.fold(
        (f) => fail('loadComments failed: ${f.message}'),
        (comments) {
          expect(comments, isNotEmpty);
          expect(comments.any((c) => c.id == _createdCommentId), isTrue);
        },
      );
    });

    test('P11-3: toggleLike() → like basculé', () async {
      final svc = CommentService();
      final result = await svc.toggleLike(_createdCommentId!);
      result.fold(
        (f) => fail('toggleLike failed: ${f.message}'),
        (isLiked) => expect(isLiked, isTrue),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 12 — Favorites (FavoriteService)
  //
  // Amadou met une entité en favori :
  // - toggleFavorite() → favori ajouté
  // - loadFavorites() + isFavorite() → vérifié
  // ═══════════════════════════════════════════════════════════════════════════

  group('P12 — Favorites', () {
    final testEntityId = _generateUuid();
    const testEntityType = 'test_entity';

    test('P12-1: FavoriteService.toggleFavorite() → favori ajouté', () async {
      final svc = FavoriteService();
      final result = await svc.toggleFavorite(
        entityType: testEntityType,
        entityId: testEntityId,
      );
      result.fold(
        (f) => fail('toggleFavorite failed: ${f.message}'),
        (isFav) => expect(isFav, isTrue),
      );
    });

    test('P12-2: isFavorite() → true après toggle', () async {
      final svc = FavoriteService();
      await svc.loadFavorites(entityType: testEntityType);
      expect(svc.isFavorite(testEntityType, testEntityId), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 13 — Activities (ActivityService)
  //
  // Amadou logue une activité :
  // - logActivity() → activité enregistrée
  // - loadEntityActivities() → historique visible
  // ═══════════════════════════════════════════════════════════════════════════

  group('P13 — Activities', () {
    final testEntityId = _generateUuid();
    const testEntityType = 'test_entity';

    test('P13-1: ActivityService.logActivity() → activité enregistrée',
        () async {
      final svc = ActivityService();
      final result = await svc.logActivity(
        action: 'forge_completed',
        targetType: testEntityType,
        targetId: testEntityId,
        targetName: 'IronFlow Batch #42',
        description: 'Forge terminée avec succès',
      );
      result.fold(
        (f) => fail('logActivity failed: ${f.message}'),
        (activity) {
          expect(activity.action, 'forge_completed');
          expect(activity.targetType, testEntityType);
        },
      );
    });

    test('P13-2: loadEntityActivities() → historique visible', () async {
      final svc = ActivityService();
      final result = await svc.loadEntityActivities(
        entityType: testEntityType,
        entityId: testEntityId,
      );
      result.fold(
        (f) => fail('loadEntityActivities failed: ${f.message}'),
        (activities) {
          expect(activities, isNotEmpty);
          expect(activities.any((a) => a.action == 'forge_completed'), isTrue);
        },
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 14 — Attachments (AttachmentService)
  //
  // Amadou ajoute une pièce jointe (via admin insert dans DB) :
  // - Insert attachment record → ID récupéré
  // - getEntityAttachments() → pièce jointe visible
  // - getAttachment(id) → détails chargés
  // ═══════════════════════════════════════════════════════════════════════════

  group('P14 — Attachments', () {
    final testEntityId = _generateUuid();
    const testEntityType = 'test_entity';

    test('P14-1: Insert attachment (admin) → enregistrement créé', () async {
      final userId = ViewModelTestHelper.supabaseService.currentUser!.id;
      final response = await ViewModelTestHelper.adminClient
          .from('attachments')
          .insert({
            'user_id': userId,
            'attachable_type': testEntityType,
            'attachable_id': testEntityId,
            'file_name': 'forge_report.pdf',
            'file_size': 2048,
            'file_type': 'application/pdf',
            'file_extension': 'pdf',
            'storage_bucket': 'attachments',
            'storage_path': 'test/$testEntityId/forge_report.pdf',
            'public_url':
                'http://127.0.0.1:54321/storage/v1/object/public/attachments/test/forge_report.pdf',
            'metadata': {},
          })
          .select()
          .single();
      expect(response['id'], isNotEmpty);
      _uploadedAttachmentId = response['id'] as String;
    });

    test('P14-2: getEntityAttachments() → pièce jointe visible', () async {
      final svc = AttachmentService();
      final result = await svc.getEntityAttachments(
        entityType: testEntityType,
        entityId: testEntityId,
      );
      result.fold(
        (f) => fail('getEntityAttachments failed: ${f.message}'),
        (attachments) {
          expect(attachments, isNotEmpty);
          expect(attachments.any((a) => a.id == _uploadedAttachmentId), isTrue);
        },
      );
    });

    test('P14-3: getAttachment(id) → détails chargés', () async {
      final svc = AttachmentService();
      final result = await svc.getAttachment(_uploadedAttachmentId!);
      result.fold(
        (f) => fail('getAttachment failed: ${f.message}'),
        (att) {
          expect(att.id, _uploadedAttachmentId);
          expect(att.fileName, 'forge_report.pdf');
        },
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 15 — Payments (PaymentService)
  //
  // Amadou crée un paiement pour IronFlow :
  // - initiatePayment() → paiement pending créé
  // - loadPayments() → paiement visible
  // - getPaymentStats() → statistiques retournées
  // ═══════════════════════════════════════════════════════════════════════════

  group('P15 — Payments', () {
    test('P15-1: PaymentService.initiatePayment() → paiement créé', () async {
      final svc = PaymentService();
      final result = await svc.initiatePayment(
        organizationId: _orgId!,
        amount: 15000,
        description: 'Test Paiement IronFlow',
        currency: 'XOF',
      );
      result.fold(
        (f) => fail('initiatePayment failed: ${f.message}'),
        (payment) {
          expect(payment.id, isNotEmpty);
          expect(payment.amount, 15000);
          expect(payment.status.name, 'pending');
          _createdPaymentId = payment.id;
        },
      );
    });

    test('P15-2: loadPayments() → paiement visible', () async {
      final svc = PaymentService();
      final result = await svc.loadPayments(organizationId: _orgId!);
      result.fold(
        (f) => fail('loadPayments failed: ${f.message}'),
        (payments) {
          expect(payments, isNotEmpty);
          expect(payments.any((p) => p.id == _createdPaymentId), isTrue);
        },
      );
    });

    test('P15-3: getPaymentStats() → stats retournées', () async {
      final svc = PaymentService();
      final result = await svc.getPaymentStats(_orgId!);
      result.fold(
        (f) => fail('getPaymentStats failed: ${f.message}'),
        (stats) => expect(stats, isA<Map<String, dynamic>>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PARCOURS 16 — Returning User (SplashVM avec session)
  //
  // Amadou revient, splash détecte la session :
  // - SplashVM.initialize() → goToHome (session active + onboarding fait)
  // - progress = 1.0, pas d'erreur
  // ═══════════════════════════════════════════════════════════════════════════

  group('P16 — Returning User', () {
    test('P16-1: SplashVM avec session → goToHome', () async {
      // Amadou est toujours connecté
      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);

      await ViewModelTestHelper.localStorage
          .setBool('onboarding_completed', true);

      final vm = SplashViewModel();
      await vm.initialize();

      expect(vm.result, SplashResult.goToHome);
      expect(vm.progress, 1.0);
      expect(vm.hasError, isFalse);
    });
  });
}

/// Génère un UUID v4 pour les entity IDs de test.
String _generateUuid() {
  final rng = Random();
  String hex(int count) =>
      List.generate(count, (_) => rng.nextInt(16).toRadixString(16)).join();
  return '${hex(8)}-${hex(4)}-4${hex(3)}-${(8 + rng.nextInt(4)).toRadixString(16)}${hex(3)}-${hex(12)}';
}
