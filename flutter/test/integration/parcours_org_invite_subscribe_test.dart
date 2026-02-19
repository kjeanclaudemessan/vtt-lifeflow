/// Parcours 5 — Organization → Invitation → Subscription
///
/// End-to-end flow: user creates an org, invites a member, subscribes to a plan.
/// Tests the REAL optional module services against local Supabase.
///
/// Run: dart test test/integration/parcours_org_invite_subscribe_test.dart
/// Requires: `supabase start` running locally.
@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/modules/optional/organizations/organization_service.dart';
import 'package:lifeflow/modules/optional/invitations/invitation_service.dart';
import 'package:lifeflow/modules/optional/subscriptions/subscription_service.dart';

import 'viewmodel_test_helper.dart';
import 'optional/optional_test_helper.dart';

void main() {
  late String testEmail;
  late String inviteeEmail;
  const testPassword = 'Test123456!';

  setUpAll(() async {
    await ViewModelTestHelper.initialize();

    testEmail = generateVmTestEmail();
    inviteeEmail = generateVmTestEmail();

    // Create org owner
    await ViewModelTestHelper.createUser(
      email: testEmail,
      password: testPassword,
      firstName: 'Org',
      lastName: 'Owner',
    );
    // Create invitee
    await ViewModelTestHelper.createUser(
      email: inviteeEmail,
      password: testPassword,
      firstName: 'Org',
      lastName: 'Invitee',
    );
  });

  tearDownAll(() async {
    await ViewModelTestHelper.signOut();
    await OptionalTestHelper.cleanupAllTestData();
    await ViewModelTestHelper.deleteUser(testEmail);
    await ViewModelTestHelper.deleteUser(inviteeEmail);
    await ViewModelTestHelper.cleanup();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Parcours 5 — Organization → Invitation → Subscription
  // ═══════════════════════════════════════════════════════════════════════════

  group('Parcours 5 — Organization → Invitation → Subscription', () {
    test('P5-1: Login → session active', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      expect(ViewModelTestHelper.supabaseService.isAuthenticated, isTrue);
    });

    test('P5-2: OrganizationService.createOrganization() → org created',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final orgService = OrganizationService();
      final result = await orgService.createOrganization(
        name: 'Test Org Parcours5',
        description: 'Created via parcours 5 test',
      );

      result.fold(
        (failure) => fail('createOrganization failed: ${failure.message}'),
        (org) {
          expect(org.name, 'Test Org Parcours5');
          expect(org.id, isNotEmpty);
        },
      );
    });

    test('P5-3: OrganizationService.loadUserOrganizations() → contains new org',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final orgService = OrganizationService();
      // Create org first
      await orgService.createOrganization(name: 'Test Org P5-3');

      final result = await orgService.loadUserOrganizations();

      result.fold(
        (failure) => fail('loadUserOrganizations failed: ${failure.message}'),
        (orgs) {
          expect(orgs, isNotEmpty);
          expect(orgs.any((o) => o.name == 'Test Org P5-3'), isTrue);
        },
      );
    });

    test('P5-4: OrganizationService.loadMembers() → user is owner', () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final orgService = OrganizationService();
      final createResult =
          await orgService.createOrganization(name: 'Test Org P5-4');
      final orgId = createResult.getOrElse(() => throw Exception('no org')).id;

      // Select the org first
      await orgService.selectOrganization(orgId);

      final membersResult = await orgService.loadMembers();

      membersResult.fold(
        (failure) => fail('loadMembers failed: ${failure.message}'),
        (members) {
          expect(members, isNotEmpty);
          // The creator should be owner or admin
          expect(
            members
                .any((m) => m.role.name == 'owner' || m.role.name == 'admin'),
            isTrue,
          );
        },
      );
    });

    test('P5-5: InvitationService.sendInvitation() → invitation created',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final orgService = OrganizationService();
      final createResult =
          await orgService.createOrganization(name: 'Test Org P5-5');
      final orgId = createResult.getOrElse(() => throw Exception('no org')).id;

      final invService = InvitationService();
      final result = await invService.sendInvitation(
        organizationId: orgId,
        email: inviteeEmail,
        role: 'member',
        message: 'Join our org!',
      );

      result.fold(
        (failure) => fail('sendInvitation failed: ${failure.message}'),
        (invitation) {
          expect(invitation.email, inviteeEmail);
          expect(invitation.token, isNotEmpty);
          expect(invitation.status.name, 'pending');
        },
      );
    });

    test(
        'P5-6: InvitationService.loadOrganizationInvitations() → invitation visible',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      final orgService = OrganizationService();
      final createResult =
          await orgService.createOrganization(name: 'Test Org P5-6');
      final orgId = createResult.getOrElse(() => throw Exception('no org')).id;

      // Send invitation
      final invService = InvitationService();
      await invService.sendInvitation(
        organizationId: orgId,
        email: inviteeEmail,
        role: 'member',
      );

      // Load org invitations
      final result = await invService.loadOrganizationInvitations(orgId);

      result.fold(
        (failure) =>
            fail('loadOrganizationInvitations failed: ${failure.message}'),
        (invitations) {
          expect(invitations, isNotEmpty);
          expect(invitations.any((i) => i.email == inviteeEmail), isTrue);
        },
      );
    });

    test('P5-7: SubscriptionService.loadAvailablePlans() → plans available',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      // Create a test plan via admin
      await OptionalTestHelper.createTestPlan(
        name: 'Test Plan P5-7',
        code: 'test-p5-7-${DateTime.now().millisecondsSinceEpoch}',
        priceMonthly: 999,
      );

      final subService = SubscriptionService();
      final result = await subService.loadAvailablePlans();

      result.fold(
        (failure) => fail('loadAvailablePlans failed: ${failure.message}'),
        (plans) {
          expect(plans, isNotEmpty);
          expect(plans.any((p) => p.name == 'Test Plan P5-7'), isTrue);
        },
      );
    });

    test('P5-8: SubscriptionService.subscribe() → subscription active',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      // Create org
      final orgService = OrganizationService();
      final createResult =
          await orgService.createOrganization(name: 'Test Org P5-8');
      final orgId = createResult.getOrElse(() => throw Exception('no org')).id;

      // Create plan
      final planId = await OptionalTestHelper.createTestPlan(
        name: 'Test Plan P5-8',
        code: 'test-p5-8-${DateTime.now().millisecondsSinceEpoch}',
        priceMonthly: 1999,
      );

      final subService = SubscriptionService();
      final result = await subService.subscribe(
        organizationId: orgId,
        planId: planId,
      );

      result.fold(
        (failure) => fail('subscribe failed: ${failure.message}'),
        (subscription) {
          expect(subscription.organizationId, orgId);
          expect(subscription.planId, planId);
          expect(
            subscription.status.name,
            anyOf(equals('active'), equals('trialing')),
          );
        },
      );
    });

    test('P5-9: SubscriptionService.loadSubscription() → correct plan',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      // Create org + plan + subscription
      final orgService = OrganizationService();
      final createResult =
          await orgService.createOrganization(name: 'Test Org P5-9');
      final orgId = createResult.getOrElse(() => throw Exception('no org')).id;

      final planId = await OptionalTestHelper.createTestPlan(
        name: 'Test Plan P5-9',
        code: 'test-p5-9-${DateTime.now().millisecondsSinceEpoch}',
        priceMonthly: 2999,
      );

      final subService = SubscriptionService();
      await subService.subscribe(organizationId: orgId, planId: planId);

      // Reload subscription
      final result = await subService.loadSubscription(organizationId: orgId);

      result.fold(
        (failure) => fail('loadSubscription failed: ${failure.message}'),
        (subscription) {
          expect(subscription, isNotNull);
          expect(subscription!.planId, planId);
          expect(subscription.organizationId, orgId);
        },
      );
    });

    test('P5-10: SubscriptionService.hasFeature() → checks plan limits',
        () async {
      await ViewModelTestHelper.signIn(email: testEmail);

      // Create org + plan + subscription
      final orgService = OrganizationService();
      final createResult =
          await orgService.createOrganization(name: 'Test Org P5-10');
      final orgId = createResult.getOrElse(() => throw Exception('no org')).id;

      final planId = await OptionalTestHelper.createTestPlan(
        name: 'Test Plan P5-10',
        code: 'test-p5-10-${DateTime.now().millisecondsSinceEpoch}',
        priceMonthly: 3999,
      );

      final subService = SubscriptionService();
      await subService.subscribe(organizationId: orgId, planId: planId);

      // Init loads current subscription
      await subService.init(organizationId: orgId);

      // hasFeature checks against plan features
      // The test plan has features: ['feature1', 'feature2']
      expect(subService.hasFeature('feature1'), isTrue);
      expect(subService.hasFeature('nonexistent_feature'), isFalse);

      // getFeatureLimit checks against plan limits
      // The test plan has limits: {'max_members': 5, 'storage_gb': 10}
      expect(subService.getFeatureLimit('max_members'), 5);
      expect(subService.isLimitReached('max_members', 5), isTrue);
      expect(subService.isLimitReached('max_members', 3), isFalse);
    });
  });
}
