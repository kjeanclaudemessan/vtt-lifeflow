// ════════════════════════════════════════════════════════════════════════════
// User Flow 2 — Gestion complète des domaines
// ════════════════════════════════════════════════════════════════════════════
//
// Scénario : L'utilisateur gère ses domaines de vie via DomainsViewModel.
// Créer un domaine custom → renommer → réordonner → archiver → désarchiver
// → vérifier que HabitsViewModel reflète les changements.
//
// Exécution : flutter test test/integration/flow_2_domain_management_test.dart
// ════════════════════════════════════════════════════════════════════════════

@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/domain/entities/domain_entity.dart';
import 'package:lifeflow/features/domains/viewmodels/domains_viewmodel.dart';
import 'package:lifeflow/features/habits/viewmodels/habits_viewmodel.dart';

import 'viewmodel_test_helper.dart';

void main() {
  late String testEmail;
  late String testUserId;

  setUpAll(() async {
    await ViewModelTestHelper.initialize();
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

  group('Flow 2 — Gestion complète des domaines', () {
    test('Créer un domaine personnalisé "Sport"', () async {
      final vm = DomainsViewModel();
      await vm.init();
      expect(vm.activeDomains.length, equals(5));

      final now = DateTime.now();
      await vm.createDomain(DomainEntity(
        id: '',
        userId: testUserId,
        name: 'Sport',
        icon: '⚽',
        color: '#FF5722',
        createdAt: now,
        updatedAt: now,
      ));

      expect(vm.hasError, isFalse);
      expect(vm.activeDomains.length, equals(6));
      final sport = vm.activeDomains.firstWhere((d) => d.name == 'Sport');
      expect(sport.icon, equals('⚽'));
      expect(sport.color, equals('#FF5722'));
    });

    test('Renommer le domaine "Sport" en "Fitness"', () async {
      final vm = DomainsViewModel();
      await vm.init();

      final sport = vm.activeDomains.firstWhere((d) => d.name == 'Sport');
      await vm.updateDomain(sport.copyWith(name: 'Fitness', icon: '🏋️'));

      expect(vm.hasError, isFalse);
      final fitness = vm.activeDomains.firstWhere((d) => d.id == sport.id);
      expect(fitness.name, equals('Fitness'));
      expect(fitness.icon, equals('🏋️'));
    });

    test('Réordonner les domaines (Fitness en premier)', () async {
      final vm = DomainsViewModel();
      await vm.init();

      final fitnessIndex =
          vm.activeDomains.indexWhere((d) => d.name == 'Fitness');
      expect(fitnessIndex, greaterThan(0));

      await vm.reorderDomains(fitnessIndex, 0);

      expect(vm.activeDomains.first.name, equals('Fitness'));
    });

    test('Archiver le domaine "Finances"', () async {
      final vm = DomainsViewModel();
      await vm.init();

      final finances = vm.activeDomains.firstWhere((d) => d.name == 'Finances');
      final countBefore = vm.activeDomains.length;

      final success = await vm.archiveDomain(finances.id);

      expect(success, isTrue);
      expect(vm.activeDomains.length, equals(countBefore - 1));
      expect(vm.activeDomains.any((d) => d.name == 'Finances'), isFalse);
      expect(vm.archivedDomains.any((d) => d.name == 'Finances'), isTrue);
    });

    test('Désarchiver "Finances"', () async {
      final vm = DomainsViewModel();
      await vm.init();

      final archived =
          vm.archivedDomains.firstWhere((d) => d.name == 'Finances');
      final countBefore = vm.activeDomains.length;

      await vm.unarchiveDomain(archived.id);

      expect(vm.hasError, isFalse);
      expect(vm.activeDomains.length, equals(countBefore + 1));
      expect(vm.activeDomains.any((d) => d.name == 'Finances'), isTrue);
    });

    test('Impossible d\'archiver le dernier domaine actif', () async {
      final vm = DomainsViewModel();
      await vm.init();

      // Archiver tous sauf un
      while (vm.activeDomains.length > 1) {
        await vm.archiveDomain(vm.activeDomains.last.id);
      }
      expect(vm.activeDomains.length, equals(1));

      // Tenter d'archiver le dernier → refusé par le VM
      final success = await vm.archiveDomain(vm.activeDomains.first.id);
      expect(success, isFalse);
      expect(vm.activeDomains.length, equals(1));

      // Restaurer tout pour la suite
      for (final d in vm.archivedDomains) {
        await vm.unarchiveDomain(d.id);
      }
    });

    test('HabitsViewModel reflète les domaines', () async {
      final domainsVm = DomainsViewModel();
      await domainsVm.init();

      final habitsVm = HabitsViewModel();
      await habitsVm.init();

      expect(habitsVm.domains.length, equals(domainsVm.activeDomains.length));
      expect(habitsVm.domains.any((d) => d.name == 'Fitness'), isTrue);
    });
  });
}
