// ════════════════════════════════════════════════════════════════════════════
// Play Store Screenshot Golden Tests
// ════════════════════════════════════════════════════════════════════════════
//
// Generates screenshot PNGs for Google Play Store listing.
// Uses golden tests to render each screen without an emulator.
//
// Run:
//   flutter test test/golden/playstore_screenshots_test.dart --update-goldens
//
// Output:
//   test/golden/goldens/playstore/  (PNG files)
//
// Then frame them:
//   cd tools && uv run lifeflow playstore frame ../flutter/test/golden/goldens/playstore
//
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lifeflow/modules/auth/views/login_view.dart';
import 'package:lifeflow/ui/views/home/home_view.dart';
import 'package:lifeflow/features/domains/views/domains_view.dart';
import 'package:lifeflow/modules/profile/views/profile_view.dart';
import 'package:lifeflow/modules/settings/views/settings_view.dart';

import 'golden_test_helper.dart';

// Phone size matching Play Store requirements (logical pixels for 3x)
// Using 412x892 (Pixel 7 dimensions) to avoid overflow in constrained layouts
const _phoneSize = Size(412, 892);

void main() {
  // Disable GoogleFonts HTTP fetching — use Roboto fallback in tests
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await GoldenTestHelper.initialize();

    // Suppress overflow errors in golden tests — we're after visuals, not layout perfection
    final defaultOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      final isOverflow = details.exception.toString().contains('overflowed');
      if (!isOverflow) {
        defaultOnError?.call(details);
      }
    };
  });

  tearDown(() async {
    // Don't fully reset between tests — services stay registered
  });

  tearDownAll(() async {
    await GoldenTestHelper.cleanup();
  });

  // ═══════════════════════════════════════════════════════════════════════
  // 1. LOGIN SCREEN
  // ═══════════════════════════════════════════════════════════════════════
  testWidgets(
    '01_login — Play Store screenshot',
    (tester) async {
      tester.view.physicalSize = _phoneSize * 3.0;
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        GoldenTestHelper.wrapWidget(
          const LoginView(),
          surfaceSize: _phoneSize,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/playstore/01_login.png'),
      );
    },
  );

  // ═══════════════════════════════════════════════════════════════════════
  // 2. TODAY DASHBOARD (HomeView - first tab)
  // ═══════════════════════════════════════════════════════════════════════
  testWidgets(
    '02_dashboard — Play Store screenshot',
    (tester) async {
      tester.view.physicalSize = _phoneSize * 3.0;
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        GoldenTestHelper.wrapWidget(
          const HomeView(),
          surfaceSize: _phoneSize,
        ),
      );
      // Pump multiple frames to let ViewModels initialize
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/playstore/02_dashboard.png'),
      );
    },
  );

  // ═══════════════════════════════════════════════════════════════════════
  // 3. HABITS LIST (HomeView - second tab)
  // ═══════════════════════════════════════════════════════════════════════
  testWidgets(
    '03_habits — Play Store screenshot',
    (tester) async {
      tester.view.physicalSize = _phoneSize * 3.0;
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        GoldenTestHelper.wrapWidget(
          const HomeView(),
          surfaceSize: _phoneSize,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Tap the second tab (Habits)
      final habitsTab = find.text('Habitudes');
      if (habitsTab.evaluate().isNotEmpty) {
        await tester.tap(habitsTab);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));
      }

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/playstore/03_habits.png'),
      );
    },
  );

  // ═══════════════════════════════════════════════════════════════════════
  // 4. DOMAINS
  // ═══════════════════════════════════════════════════════════════════════
  testWidgets(
    '04_domains — Play Store screenshot',
    (tester) async {
      tester.view.physicalSize = _phoneSize * 3.0;
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        GoldenTestHelper.wrapWidget(
          const DomainsView(),
          surfaceSize: _phoneSize,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/playstore/04_domains.png'),
      );
    },
  );

  // ═══════════════════════════════════════════════════════════════════════
  // 5. PROFILE
  // ═══════════════════════════════════════════════════════════════════════
  testWidgets(
    '05_profile — Play Store screenshot',
    (tester) async {
      tester.view.physicalSize = _phoneSize * 3.0;
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        GoldenTestHelper.wrapWidget(
          const ProfileView(),
          surfaceSize: _phoneSize,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/playstore/05_profile.png'),
      );
    },
  );

  // ═══════════════════════════════════════════════════════════════════════
  // 6. SETTINGS
  // ═══════════════════════════════════════════════════════════════════════
  testWidgets(
    '06_settings — Play Store screenshot',
    (tester) async {
      tester.view.physicalSize = _phoneSize * 3.0;
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        GoldenTestHelper.wrapWidget(
          const SettingsView(),
          surfaceSize: _phoneSize,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/playstore/06_settings.png'),
      );
    },
  );
}
