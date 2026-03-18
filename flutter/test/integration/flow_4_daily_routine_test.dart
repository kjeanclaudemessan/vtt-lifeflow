// ════════════════════════════════════════════════════════════════════════════
// User Flow 4 — Routine quotidienne (suivi des habitudes du jour)
// ════════════════════════════════════════════════════════════════════════════
//
// Scénario : L'utilisateur a 3 habitudes. Il ouvre TodayViewModel, coche
// une habitude binaire, renseigne une valeur quantitative, vérifie le
// taux de complétion, décoche puis recoche, vérifie les streaks et les
// minutes par domaine / semaine.
//
// Exécution : flutter test test/integration/flow_4_daily_routine_test.dart
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
import 'package:lifeflow/features/habits/viewmodels/habits_viewmodel.dart';
import 'package:lifeflow/features/today/viewmodels/today_viewmodel.dart';

import 'viewmodel_test_helper.dart';

void main() {
  late String testEmail;
  late String testUserId;

  /// Habitudes pré-créées pour le test
  late HabitEntity meditationHabit;
  late HabitEntity waterHabit;
  late HabitEntity readingHabit;
  late String santeDomainId;
  late String devPersoDomainId;

  setUpAll(() async {
    await ViewModelTestHelper.initialize();
    testEmail = generateVmTestEmail();
    final user = await ViewModelTestHelper.createUser(
      email: testEmail,
      firstName: 'Test',
      lastName: 'Routine',
    );
    testUserId = user.id;
    await ViewModelTestHelper.signIn(email: testEmail);

    // ── Préparer les données : récupérer domaines par défaut ──
    final domainRepo = locator<IDomainRepository>();
    final domainsResult = await domainRepo.getDomains();
    final domains = domainsResult.getOrElse(() => []);
    final sante = domains.firstWhere((d) => d.name == 'Santé');
    final devPerso = domains.firstWhere(
      (d) => d.name == 'Développement personnel',
    );
    santeDomainId = sante.id;
    devPersoDomainId = devPerso.id;

    // ── Créer 3 habitudes via le repository ──
    final habitRepo = locator<IHabitRepository>();
    final now = DateTime.now();

    final medResult = await habitRepo.createHabit(
      HabitEntity(
        id: '',
        userId: testUserId,
        domainId: santeDomainId,
        name: 'Méditation',
        type: HabitType.binary,
        estimatedDurationMinutes: 15,
        startTime: const TimeOfDay(hour: 7, minute: 0),
        frequency: HabitFrequency.daily,
        frequencyDays: const [],
        isArchived: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
    meditationHabit = medResult.getOrElse(() => throw Exception('create med'));

    final waterResult = await habitRepo.createHabit(
      HabitEntity(
        id: '',
        userId: testUserId,
        domainId: santeDomainId,
        name: 'Boire de l\'eau',
        type: HabitType.quantitative,
        targetValue: 2000,
        unit: 'ml',
        estimatedDurationMinutes: 5,
        frequency: HabitFrequency.daily,
        frequencyDays: const [],
        isArchived: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
    waterHabit = waterResult.getOrElse(() => throw Exception('create water'));

    final readResult = await habitRepo.createHabit(
      HabitEntity(
        id: '',
        userId: testUserId,
        domainId: devPersoDomainId,
        name: 'Lecture',
        type: HabitType.binary,
        estimatedDurationMinutes: 30,
        startTime: const TimeOfDay(hour: 21, minute: 0),
        frequency: HabitFrequency.daily,
        frequencyDays: const [],
        isArchived: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
    readingHabit = readResult.getOrElse(() => throw Exception('create read'));
  });

  tearDownAll(() async {
    await ViewModelTestHelper.deleteUserById(testUserId);
    await ViewModelTestHelper.cleanup();
  });

  group('Flow 4 — Routine quotidienne', () {
    test(
      'TodayViewModel affiche 3 habitudes planifiées aujourd\'hui',
      () async {
        final vm = TodayViewModel();
        await vm.init();

        expect(vm.isBusy, isFalse);
        expect(vm.todayHabits.length, equals(3));
        expect(vm.completedHabits, isEmpty);
        expect(vm.remainingHabits.length, equals(3));
        expect(vm.completionRate, equals(0.0));
      },
    );

    test('Cocher la méditation (binaire) → completion rate monte', () async {
      final vm = TodayViewModel();
      await vm.init();

      await vm.toggleHabit(meditationHabit.id);

      expect(vm.completedHabits.length, equals(1));
      expect(vm.remainingHabits.length, equals(2));
      // 1/3 ≈ 0.333...
      expect(vm.completionRate, closeTo(1 / 3, 0.01));

      // Le log est bien créé
      final log = vm.todayLogFor(meditationHabit.id);
      expect(log, isNotNull);
      expect(log!.completed, isTrue);
    });

    test('Logger l\'eau (quantitative avec valeur)', () async {
      final vm = TodayViewModel();
      await vm.init();

      await vm.toggleHabit(waterHabit.id, value: 1500);

      final log = vm.todayLogFor(waterHabit.id);
      expect(log, isNotNull);
      expect(log!.completed, isTrue);
      expect(log.value, equals(1500));

      // 2 sur 3 complétées
      expect(vm.completedHabits.length, equals(2));
      expect(vm.completionRate, closeTo(2 / 3, 0.01));
    });

    test('Cocher la lecture → 100% completion', () async {
      final vm = TodayViewModel();
      await vm.init();

      await vm.toggleHabit(readingHabit.id);

      expect(vm.completedHabits.length, equals(3));
      expect(vm.remainingHabits, isEmpty);
      expect(vm.completionRate, equals(1.0));
    });

    test('Décocher la méditation → retour à 2/3', () async {
      final vm = TodayViewModel();
      await vm.init();

      // Toggle déjà cochée → uncheck
      await vm.toggleHabit(meditationHabit.id);

      expect(vm.completedHabits.length, equals(2));
      expect(vm.remainingHabits.length, equals(1));
      expect(vm.completionRate, closeTo(2 / 3, 0.01));

      final log = vm.todayLogFor(meditationHabit.id);
      // Log soit null soit not completed
      if (log != null) {
        expect(log.completed, isFalse);
      }
    });

    test('Recocher la méditation → retour à 100%', () async {
      final vm = TodayViewModel();
      await vm.init();

      await vm.toggleHabit(meditationHabit.id);

      expect(vm.completedHabits.length, equals(3));
      expect(vm.completionRate, equals(1.0));
    });

    test('Habitudes regroupées par TimeSlot', () async {
      final vm = TodayViewModel();
      await vm.init();

      final bySlot = vm.habitsByTimeSlot;

      // Méditation (7h) → morning
      final morning = bySlot[TimeSlot.morning] ?? [];
      expect(morning.any((h) => h.name == 'Méditation'), isTrue);

      // Lecture (21h) → evening
      final evening = bySlot[TimeSlot.evening] ?? [];
      expect(evening.any((h) => h.name == 'Lecture'), isTrue);

      // Eau (pas de startTime) → anytime
      final anytime = bySlot[TimeSlot.anytime] ?? [];
      expect(anytime.any((h) => h.name == 'Boire de l\'eau'), isTrue);
    });

    test('todayDomainMinutes reflète les habitudes complétées', () async {
      final vm = TodayViewModel();
      await vm.init();

      final domainMinutes = vm.todayDomainMinutes;

      // Santé : méditation (15min) + eau (5min) = 20 min
      expect(domainMinutes[santeDomainId], greaterThanOrEqualTo(15));

      // Dev perso : lecture (30min) = 30 min
      expect(domainMinutes[devPersoDomainId], equals(30));
    });

    test('weeklyTotalMinutes est > 0 après avoir loggé', () async {
      final vm = TodayViewModel();
      await vm.init();

      // On a loggé 3 habitudes : 15 + 5 + 30 = 50 min minimum
      expect(vm.weeklyTotalMinutes, greaterThanOrEqualTo(45));
    });

    test('StreakInfo indique un streak de 1 jour', () async {
      final vm = TodayViewModel();
      await vm.init();

      final streak = vm.streakFor(meditationHabit.id);
      expect(streak.currentStreak, greaterThanOrEqualTo(1));
      expect(streak.bestStreak, greaterThanOrEqualTo(1));
    });

    test('HabitsViewModel montre les mêmes logs que TodayViewModel', () async {
      final todayVm = TodayViewModel();
      await todayVm.init();

      final habitsVm = HabitsViewModel();
      await habitsVm.init();

      // Les deux VMs voient les mêmes habitudes
      expect(habitsVm.filteredHabits.length, equals(3));

      // Vérifier que HabitsViewModel voit aussi les logs
      final medLog = habitsVm.todayLogFor(meditationHabit.id);
      expect(medLog, isNotNull);
      expect(medLog!.completed, isTrue);

      final waterLog = habitsVm.todayLogFor(waterHabit.id);
      expect(waterLog, isNotNull);
      expect(waterLog!.value, equals(1500));
    });
  });
}
