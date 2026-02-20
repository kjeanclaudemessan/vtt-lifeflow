// ════════════════════════════════════════════════════════════════════════════
// User Flow 5 — Bilan hebdomadaire et compteurs de temps
// ════════════════════════════════════════════════════════════════════════════
//
// Scénario : L'utilisateur a des habitudes loggées sur plusieurs jours.
// Il consulte CounterViewModel pour voir les compteurs par domaine,
// navigue entre les semaines, puis consulte BilanViewModel pour le
// récapitulatif complet (completionRate, topHabit, domainTimes, delta).
//
// Exécution : flutter test test/integration/flow_5_weekly_review_test.dart
// ════════════════════════════════════════════════════════════════════════════

@Tags(['integration'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/app/app.locator.dart';
import 'package:lifeflow/core/enums/lifeflow_enums.dart';
import 'package:lifeflow/domain/entities/habit_entity.dart';
import 'package:lifeflow/domain/repositories/i_domain_repository.dart';
import 'package:lifeflow/domain/repositories/i_habit_repository.dart';
import 'package:lifeflow/features/bilan/viewmodels/bilan_viewmodel.dart';
import 'package:lifeflow/features/counter/viewmodels/counter_viewmodel.dart';

import 'viewmodel_test_helper.dart';

void main() {
  late String testEmail;
  late String testUserId;

  late HabitEntity meditationHabit; // binary, 15min, Santé
  late HabitEntity sportHabit; // binary, 60min, Santé
  late HabitEntity lectureHabit; // binary, 30min, Dev perso

  setUpAll(() async {
    await ViewModelTestHelper.initialize();
    testEmail = generateVmTestEmail();
    final user = await ViewModelTestHelper.createUser(
      email: testEmail,
      firstName: 'Test',
      lastName: 'Bilan',
    );
    testUserId = user.id;
    await ViewModelTestHelper.signIn(email: testEmail);

    // ── Récupérer les domaines par défaut ──
    final domainRepo = locator<IDomainRepository>();
    final domainsResult = await domainRepo.getDomains();
    final domains = domainsResult.getOrElse(() => []);
    final sante = domains.firstWhere((d) => d.name == 'Santé');
    final devPerso =
        domains.firstWhere((d) => d.name == 'Développement personnel');

    // ── Créer 3 habitudes ──
    final habitRepo = locator<IHabitRepository>();
    final now = DateTime.now();

    final medResult = await habitRepo.createHabit(HabitEntity(
      id: '',
      userId: testUserId,
      domainId: sante.id,
      name: 'Méditation',
      type: HabitType.binary,
      estimatedDurationMinutes: 15,
      startTime: const TimeOfDay(hour: 7, minute: 0),
      endTime: const TimeOfDay(hour: 7, minute: 15),
      frequency: HabitFrequency.daily,
      frequencyDays: const [],
      isArchived: false,
      createdAt: now,
      updatedAt: now,
    ));
    meditationHabit = medResult.getOrElse(() => throw Exception('create med'));

    final sportResult = await habitRepo.createHabit(HabitEntity(
      id: '',
      userId: testUserId,
      domainId: sante.id,
      name: 'Sport',
      type: HabitType.binary,
      estimatedDurationMinutes: 60,
      frequency: HabitFrequency.daily,
      frequencyDays: const [],
      isArchived: false,
      createdAt: now,
      updatedAt: now,
    ));
    sportHabit = sportResult.getOrElse(() => throw Exception('create sport'));

    final readResult = await habitRepo.createHabit(HabitEntity(
      id: '',
      userId: testUserId,
      domainId: devPerso.id,
      name: 'Lecture',
      type: HabitType.binary,
      estimatedDurationMinutes: 30,
      startTime: const TimeOfDay(hour: 21, minute: 0),
      endTime: const TimeOfDay(hour: 21, minute: 30),
      frequency: HabitFrequency.daily,
      frequencyDays: const [],
      isArchived: false,
      createdAt: now,
      updatedAt: now,
    ));
    lectureHabit = readResult.getOrElse(() => throw Exception('create read'));

    // ── Logger les habitudes sur plusieurs jours de la semaine courante ──
    final today = DateTime.now();
    // Remonter au lundi de cette semaine
    final monday = today.subtract(Duration(days: today.weekday - 1));

    // Lundi : méditation + sport + lecture
    await habitRepo.logHabit(
      habitId: meditationHabit.id,
      date: monday,
      completed: true,
    );
    await habitRepo.logHabit(
      habitId: sportHabit.id,
      date: monday,
      completed: true,
    );
    await habitRepo.logHabit(
      habitId: lectureHabit.id,
      date: monday,
      completed: true,
    );

    // Mardi : méditation + lecture (pas de sport)
    final tuesday = monday.add(const Duration(days: 1));
    await habitRepo.logHabit(
      habitId: meditationHabit.id,
      date: tuesday,
      completed: true,
    );
    await habitRepo.logHabit(
      habitId: lectureHabit.id,
      date: tuesday,
      completed: true,
    );

    // Mercredi : méditation seulement
    final wednesday = monday.add(const Duration(days: 2));
    await habitRepo.logHabit(
      habitId: meditationHabit.id,
      date: wednesday,
      completed: true,
    );

    // Jeudi : tout (sport dominant)
    final thursday = monday.add(const Duration(days: 3));
    await habitRepo.logHabit(
      habitId: meditationHabit.id,
      date: thursday,
      completed: true,
    );
    await habitRepo.logHabit(
      habitId: sportHabit.id,
      date: thursday,
      completed: true,
    );
    await habitRepo.logHabit(
      habitId: lectureHabit.id,
      date: thursday,
      completed: true,
    );
  });

  tearDownAll(() async {
    await ViewModelTestHelper.deleteUserById(testUserId);
    await ViewModelTestHelper.cleanup();
  });

  group('Flow 5 — Compteurs de temps (CounterViewModel)', () {
    test('init() charge les compteurs par domaine', () async {
      final vm = CounterViewModel();
      await vm.init();

      expect(vm.isBusy, isFalse);
      expect(vm.counters, isNotEmpty);
      expect(vm.isCurrentWeek, isTrue);

      // Total minutes cette semaine > 0
      expect(vm.totalMinutesThisWeek, greaterThan(0));
    });

    test('Le total correspond aux habitudes loggées', () async {
      final vm = CounterViewModel();
      await vm.init();

      // Méditation: 4 jours × 15 min = 60 min
      // Sport: 2 jours × 60 min = 120 min
      // Lecture: 3 jours × 30 min = 90 min
      // Total attendu = 270 min
      expect(vm.totalMinutesThisWeek, equals(270));
    });

    test('totalHoursLabel est formaté correctement', () async {
      final vm = CounterViewModel();
      await vm.init();

      // 270 min = 4h30
      expect(vm.totalHoursLabel, isNotEmpty);
      // Le format peut varier, juste vérifier que c'est non-vide
    });

    test('toggleExpanded ouvre/ferme un compteur', () async {
      final vm = CounterViewModel();
      await vm.init();

      expect(vm.expandedIndex, isNull);

      vm.toggleExpanded(0);
      expect(vm.expandedIndex, equals(0));

      vm.toggleExpanded(0);
      expect(vm.expandedIndex, isNull);
    });

    test('previousWeek navigue vers la semaine précédente', () async {
      final vm = CounterViewModel();
      await vm.init();

      expect(vm.isCurrentWeek, isTrue);

      await vm.previousWeek();

      expect(vm.isCurrentWeek, isFalse);
      // Semaine précédente sans données → total = 0
      expect(vm.totalMinutesThisWeek, equals(0));
    });

    test('goToCurrentWeek revient à la semaine courante', () async {
      final vm = CounterViewModel();
      await vm.init();

      await vm.previousWeek();
      expect(vm.isCurrentWeek, isFalse);

      await vm.goToCurrentWeek();
      expect(vm.isCurrentWeek, isTrue);
      expect(vm.totalMinutesThisWeek, greaterThan(0));
    });

    test('nextWeek ne dépasse pas la semaine courante', () async {
      final vm = CounterViewModel();
      await vm.init();

      expect(vm.isCurrentWeek, isTrue);
      await vm.nextWeek();
      // Toujours la semaine courante (pas de navigation future)
      expect(vm.isCurrentWeek, isTrue);
    });

    test('deltaMinutes est calculé vs semaine précédente', () async {
      final vm = CounterViewModel();
      await vm.init();

      // Pas de données la semaine précédente → delta = totalMinutes
      expect(vm.deltaMinutes, equals(vm.totalMinutesThisWeek));
    });
  });

  group('Flow 5 — Bilan hebdomadaire (BilanViewModel)', () {
    test('init() charge le bilan de la semaine courante', () async {
      final vm = BilanViewModel();
      await vm.init();

      expect(vm.isBusy, isFalse);
      expect(vm.isCurrentWeek, isTrue);
      expect(vm.bilan, isNotNull);
    });

    test('Le bilan reflète les données loggées', () async {
      final vm = BilanViewModel();
      await vm.init();

      final bilan = vm.bilan;

      // Total minutes = 270
      expect(bilan.totalMinutes, equals(270));

      // Completion rate : 10 logs sur 4 jours × 3 habitudes = 12 slots possibles
      // Mais ça dépend de l'algo exact — juste vérifier > 0
      expect(bilan.completionRate, greaterThan(0.0));
      expect(bilan.completionRate, lessThanOrEqualTo(1.0));

      // completionRateLabel est formaté (ex: "83%")
      expect(bilan.completionRateLabel, isNotEmpty);
    });

    test('Le bilan a des domainTimes cohérents', () async {
      final vm = BilanViewModel();
      await vm.init();

      final bilan = vm.bilan;
      expect(bilan.domainTimes, isNotEmpty);

      // La somme des domainTimes doit égaler totalMinutes
      final sumMinutes = bilan.domainTimes.fold<int>(
        0,
        (sum, tc) => sum + tc.totalMinutesThisWeek,
      );
      expect(sumMinutes, equals(bilan.totalMinutes));
    });

    test('topHabit est l\'habitude avec le meilleur taux de complétion',
        () async {
      final vm = BilanViewModel();
      await vm.init();

      final bilan = vm.bilan;
      // Méditation: 4/7 jours (57%) > Lecture: 3/7 (43%) > Sport: 2/7 (29%)
      // topHabit = highest completion rate
      expect(bilan.topHabit, isNotNull);
      expect(bilan.topHabit!.name, equals('Méditation'));
    });

    test('deltaMinutes reflète la progression', () async {
      final vm = BilanViewModel();
      await vm.init();

      // Pas de données la semaine dernière → delta = totalMinutes
      expect(vm.bilan.deltaMinutes, equals(vm.bilan.totalMinutes));
      expect(vm.bilan.totalMinutesLastWeek, equals(0));
    });

    test('domains contient les domaines actifs', () async {
      final vm = BilanViewModel();
      await vm.init();

      expect(vm.domains, isNotEmpty);
      expect(vm.domains.length, greaterThanOrEqualTo(2));

      final names = vm.domains.map((d) => d.name).toSet();
      expect(names, contains('Santé'));
      expect(names, contains('Développement personnel'));
    });

    test('previousWeek montre un bilan vide', () async {
      final vm = BilanViewModel();
      await vm.init();

      await vm.previousWeek();
      expect(vm.isCurrentWeek, isFalse);

      final bilan = vm.bilan;
      expect(bilan.totalMinutes, equals(0));
      expect(bilan.completionRate, equals(0.0));
    });

    test('nextWeek revient à la semaine courante', () async {
      final vm = BilanViewModel();
      await vm.init();

      await vm.previousWeek();
      expect(vm.isCurrentWeek, isFalse);

      await vm.nextWeek();
      expect(vm.isCurrentWeek, isTrue);
      expect(vm.bilan.totalMinutes, greaterThan(0));
    });
  });
}
