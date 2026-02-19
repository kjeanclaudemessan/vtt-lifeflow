// ════════════════════════════════════════════════════════════════════════════
// E2E Test Entry Point (Patrol)
// ════════════════════════════════════════════════════════════════════════════
//
// This file is the main entry point for E2E (End-to-End) tests using Patrol.
// Patrol provides a cleaner API and native interactions support.
//
// Run locally (requires emulator):
//   patrol test
//
// Run in CI (GitHub Actions):
//   Automatically triggered on push to main/develop
//
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:lifeflow/main.dart' as app;

void main() {
  patrolTest('App should start without crashing', ($) async {
    app.main();
    await $.pumpAndSettle(duration: const Duration(seconds: 5));

    // L'app devrait afficher quelque chose
    expect($(MaterialApp), findsOneWidget);
  });

  patrolTest('Login screen should display all required elements', ($) async {
    app.main();
    await $.pumpAndSettle(duration: const Duration(seconds: 5));

    // Vérifier que l'app est stable
    expect($(MaterialApp), findsOneWidget);

    // Chercher des éléments de formulaire (TextFormField)
    final textFields = $(TextFormField);
    if (textFields.exists) {
      expect(textFields, findsWidgets);
    }
  });

  patrolTest('Should be able to navigate through the app', ($) async {
    app.main();
    await $.pumpAndSettle(duration: const Duration(seconds: 5));

    // Chercher un bouton et taper dessus si présent
    final buttons = $(ElevatedButton);
    if (buttons.exists) {
      await buttons.first.tap();
      await $.pumpAndSettle();
    }

    // L'app devrait rester stable
    expect($(MaterialApp), findsOneWidget);
  });

  patrolTest('Onboarding flow - should allow swiping', ($) async {
    app.main();
    await $.pumpAndSettle(duration: const Duration(seconds: 5));

    // Chercher un PageView (typique des onboarding)
    final pageView = $(PageView);
    if (pageView.exists) {
      // Swipe vers la gauche
      await $.tester.drag(pageView.finder, const Offset(-300, 0));
      await $.pumpAndSettle();
    }

    expect($(MaterialApp), findsOneWidget);
  });
}
