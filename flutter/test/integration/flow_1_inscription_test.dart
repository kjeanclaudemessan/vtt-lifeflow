// ════════════════════════════════════════════════════════════════════════════
// User Flow 1 — Inscription & premier lancement
// ════════════════════════════════════════════════════════════════════════════
//
// Scénario : Un nouvel utilisateur s'inscrit → profil auto-créé → 5 domaines
// par défaut → DomainsViewModel les affiche → HabitsViewModel est vide →
// TodayViewModel montre un dashboard vide.
//
// Exécution : flutter test test/integration/flow_1_inscription_test.dart
// ════════════════════════════════════════════════════════════════════════════

@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/features/domains/viewmodels/domains_viewmodel.dart';
import 'package:lifeflow/features/habits/viewmodels/habits_viewmodel.dart';
import 'package:lifeflow/features/today/viewmodels/today_viewmodel.dart';

import 'viewmodel_test_helper.dart';

void main() {
  late String testEmail;
  late String testUserId;

  setUpAll(() async {
    await ViewModelTestHelper.initialize();

    // Créer et connecter un utilisateur
    testEmail = generateVmTestEmail();
    final user = await ViewModelTestHelper.createUser(
      email: testEmail,
      firstName: 'Test',
      lastName: 'User',
    );
    testUserId = user.id;
    await ViewModelTestHelper.signIn(email: testEmail);
  });

  tearDownAll(() async {
    await ViewModelTestHelper.deleteUserById(testUserId);
    await ViewModelTestHelper.cleanup();
  });

  group('Flow 1 — Inscription & premier lancement', () {
    test('DomainsViewModel affiche les 5 domaines par défaut après signup',
        () async {
      final vm = DomainsViewModel();
      await vm.init();

      expect(vm.isBusy, isFalse);
      expect(vm.hasError, isFalse);
      expect(vm.activeDomains.length, equals(5));
      expect(vm.archivedDomains, isEmpty);

      final names = vm.activeDomains.map((d) => d.name).toSet();
      expect(
          names,
          containsAll([
            'Santé',
            'Travail',
            'Relations',
            'Finances',
            'Développement personnel',
          ]));

      // Ordre de tri correct
      for (int i = 0; i < vm.activeDomains.length; i++) {
        expect(vm.activeDomains[i].sortOrder, equals(i));
      }
    });

    test('HabitsViewModel montre une liste vide (aucune habitude encore)',
        () async {
      final vm = HabitsViewModel();
      await vm.init();

      expect(vm.isBusy, isFalse);
      expect(vm.hasError, isFalse);
      expect(vm.filteredHabits, isEmpty);
      expect(vm.habitsByTimeSlot, isEmpty);

      // Mais les domaines sont chargés pour le filtre
      expect(vm.domains.length, equals(5));
    });

    test('TodayViewModel montre un dashboard vide', () async {
      final vm = TodayViewModel();
      await vm.init();

      expect(vm.isBusy, isFalse);
      expect(vm.todayHabits, isEmpty);
      expect(vm.completedHabits, isEmpty);
      expect(vm.remainingHabits, isEmpty);
      expect(vm.completionRate, equals(0.0));
      expect(vm.weeklyTotalMinutes, equals(0));
    });

    test('Le profil contient les métadonnées correctes', () async {
      final profile = await ViewModelTestHelper.supabaseService.client
          .from('profiles')
          .select()
          .eq('id', testUserId)
          .single();

      expect(profile['first_name'], equals('Test'));
      expect(profile['last_name'], equals('User'));
      expect(profile['locale'], equals('fr'));
    });
  });
}
