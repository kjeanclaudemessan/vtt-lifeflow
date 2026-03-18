// ════════════════════════════════════════════════════════════════════════════
// User Flow 3 — Création et gestion d'habitudes
// ════════════════════════════════════════════════════════════════════════════
//
// Scénario : L'utilisateur crée des habitudes via HabitFormViewModel,
// les consulte dans HabitsViewModel, filtre par domaine, modifie,
// archive, et vérifie le regroupement par time slot.
//
// Exécution : flutter test test/integration/flow_3_habit_creation_test.dart
// ════════════════════════════════════════════════════════════════════════════

@Tags(['integration'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/core/enums/lifeflow_enums.dart';
import 'package:lifeflow/features/habits/viewmodels/habit_form_viewmodel.dart';
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

  group('Flow 3 — Création et gestion d\'habitudes', () {
    test(
      'Créer une habitude binaire "Méditation" via HabitFormViewModel',
      () async {
        final formVm = HabitFormViewModel();
        await formVm.init();

        expect(formVm.isEditMode, isFalse);
        expect(formVm.domains.length, greaterThanOrEqualTo(5));

        // Remplir le formulaire
        formVm.nameController.text = 'Méditation';
        formVm.descriptionController.text = '10 min de pleine conscience';
        formVm.setType(HabitType.binary);
        formVm.setEstimatedDuration(10);
        formVm.setStartTime(const TimeOfDay(hour: 7, minute: 0));
        formVm.setFrequency(HabitFrequency.daily);

        final sante = formVm.domains.firstWhere((d) => d.name == 'Santé');
        formVm.setSelectedDomain(sante);

        await formVm.save();

        // Vérifier via HabitsViewModel
        final habitsVm = HabitsViewModel();
        await habitsVm.init();

        expect(habitsVm.filteredHabits.length, equals(1));
        final med = habitsVm.filteredHabits.first;
        expect(med.name, equals('Méditation'));
        expect(med.type, equals(HabitType.binary));
        expect(med.estimatedDurationMinutes, equals(10));
        expect(med.domainId, equals(sante.id));
        expect(med.frequency, equals(HabitFrequency.daily));
        expect(med.startTime, equals(const TimeOfDay(hour: 7, minute: 0)));

        formVm.dispose();
      },
    );

    test(
      'Créer une habitude quantitative "Eau" via HabitFormViewModel',
      () async {
        final formVm = HabitFormViewModel();
        await formVm.init();

        formVm.nameController.text = 'Boire de l\'eau';
        formVm.setType(HabitType.quantitative);
        formVm.targetValueController.text = '2000';
        formVm.unitController.text = 'ml';
        formVm.setEstimatedDuration(5);
        formVm.setFrequency(HabitFrequency.daily);

        final sante = formVm.domains.firstWhere((d) => d.name == 'Santé');
        formVm.setSelectedDomain(sante);

        await formVm.save();

        final habitsVm = HabitsViewModel();
        await habitsVm.init();

        expect(habitsVm.filteredHabits.length, equals(2));
        final water = habitsVm.filteredHabits.firstWhere(
          (h) => h.name == 'Boire de l\'eau',
        );
        expect(water.type, equals(HabitType.quantitative));
        expect(water.targetValue, equals(2000));
        expect(water.unit, equals('ml'));

        formVm.dispose();
      },
    );

    test('Créer une habitude hebdomadaire "Sport en salle"', () async {
      final formVm = HabitFormViewModel();
      await formVm.init();

      formVm.nameController.text = 'Sport en salle';
      formVm.setType(HabitType.binary);
      formVm.setEstimatedDuration(60);
      formVm.setFrequency(HabitFrequency.weekly);
      formVm.toggleFrequencyDay(1); // Lundi
      formVm.toggleFrequencyDay(3); // Mercredi
      formVm.toggleFrequencyDay(5); // Vendredi

      final travail = formVm.domains.firstWhere((d) => d.name == 'Travail');
      formVm.setSelectedDomain(travail);

      await formVm.save();

      final habitsVm = HabitsViewModel();
      await habitsVm.init();

      expect(habitsVm.filteredHabits.length, equals(3));
      final sport = habitsVm.filteredHabits.firstWhere(
        (h) => h.name == 'Sport en salle',
      );
      expect(sport.frequency, equals(HabitFrequency.weekly));
      expect(sport.frequencyDays, containsAll([1, 3, 5]));
      expect(sport.estimatedDurationMinutes, equals(60));

      formVm.dispose();
    });

    test('Validation du formulaire (nom vide, pas de domaine)', () async {
      final formVm = HabitFormViewModel();
      await formVm.init();

      // Sauver sans rien remplir
      await formVm.save();
      expect(formVm.nameError, equals('Le nom est requis'));

      // Mettre un nom mais pas de domaine
      formVm.nameController.text = 'Test';
      await formVm.save();
      expect(formVm.domainError, equals('Choisissez un domaine'));

      formVm.dispose();
    });

    test('Filtrer les habitudes par domaine dans HabitsViewModel', () async {
      final habitsVm = HabitsViewModel();
      await habitsVm.init();

      expect(habitsVm.filteredHabits.length, equals(3));

      // Filtrer par Santé
      final sante = habitsVm.domains.firstWhere((d) => d.name == 'Santé');
      habitsVm.filterByDomain(sante.id);

      expect(habitsVm.selectedDomainId, equals(sante.id));
      expect(habitsVm.filteredHabits.length, equals(2));
      for (final h in habitsVm.filteredHabits) {
        expect(h.domainId, equals(sante.id));
      }

      // Filtrer par Travail
      final travail = habitsVm.domains.firstWhere((d) => d.name == 'Travail');
      habitsVm.filterByDomain(travail.id);

      expect(habitsVm.filteredHabits.length, equals(1));
      expect(habitsVm.filteredHabits.first.domainId, equals(travail.id));

      // Enlever le filtre (toggle)
      habitsVm.filterByDomain(travail.id);
      expect(habitsVm.selectedDomainId, isNull);
      expect(habitsVm.filteredHabits.length, equals(3));
    });

    test('Modifier une habitude existante via HabitFormViewModel', () async {
      final habitsVm = HabitsViewModel();
      await habitsVm.init();
      final meditation = habitsVm.filteredHabits.firstWhere(
        (h) => h.name == 'Méditation',
      );

      // Ouvrir le formulaire en mode édition
      final formVm = HabitFormViewModel();
      await formVm.init(habit: meditation);

      expect(formVm.isEditMode, isTrue);
      expect(formVm.nameController.text, equals('Méditation'));
      expect(formVm.estimatedDurationMinutes, equals(10));

      formVm.nameController.text = 'Méditation pleine conscience';
      formVm.setEstimatedDuration(20);

      await formVm.save();

      // Vérifier la persistance
      final habitsVm2 = HabitsViewModel();
      await habitsVm2.init();
      final updated = habitsVm2.filteredHabits.firstWhere(
        (h) => h.id == meditation.id,
      );
      expect(updated.name, equals('Méditation pleine conscience'));
      expect(updated.estimatedDurationMinutes, equals(20));

      formVm.dispose();
    });

    test('Archiver une habitude depuis HabitsViewModel', () async {
      final habitsVm = HabitsViewModel();
      await habitsVm.init();

      final water = habitsVm.filteredHabits.firstWhere(
        (h) => h.name == 'Boire de l\'eau',
      );

      await habitsVm.archiveHabit(water.id);

      expect(habitsVm.hasError, isFalse);
      expect(
        habitsVm.filteredHabits.any((h) => h.name == 'Boire de l\'eau'),
        isFalse,
      );
      expect(habitsVm.filteredHabits.length, equals(2));
    });

    test('Habitudes regroupées par TimeSlot dans HabitsViewModel', () async {
      final habitsVm = HabitsViewModel();
      await habitsVm.init();

      final bySlot = habitsVm.habitsByTimeSlot;

      // Méditation a startTime 7h → morning
      final morningHabits = bySlot[TimeSlot.morning] ?? [];
      expect(
        morningHabits.any((h) => h.name == 'Méditation pleine conscience'),
        isTrue,
      );

      // Sport n'a pas de startTime → anytime
      final anytimeHabits = bySlot[TimeSlot.anytime] ?? [];
      expect(anytimeHabits.any((h) => h.name == 'Sport en salle'), isTrue);
    });
  });
}
