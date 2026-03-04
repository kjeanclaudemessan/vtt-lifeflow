import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:lifeflow/app/app.locator.dart';
import 'package:lifeflow/app/app.router.dart';
import 'package:lifeflow/bootstrap.dart';
import 'package:lifeflow/core/config/env/environment.dart';
import 'package:lifeflow/design_system/theme/app_theme.dart';
import 'package:lifeflow/l10n/generated/app_localizations.dart';
import 'package:lifeflow/services/push_notification/push_notification_service.dart';
import 'package:lifeflow/services/settings/app_settings_service.dart';

Future<void> main() async {
  // Read environment from --dart-define=ENV=staging (or development/production)
  // Defaults to development when not specified (e.g. plain `flutter run`)
  const envName = String.fromEnvironment('ENV', defaultValue: 'development');
  final environment = Environment.values.firstWhere(
    (e) => e.name == envName,
    orElse: () => Environment.development,
  );

  // Register background message handler (must be top-level)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await bootstrap(environment: environment);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = locator<AppSettingsService>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: settings.themeMode,
          builder: (context, themeMode, _) {
            return ValueListenableBuilder<Locale>(
              valueListenable: settings.locale,
              builder: (context, locale, _) {
                return PostHogWidget(
                  child: MaterialApp(
                    title: 'LifeFlow',
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.light,
                    darkTheme: AppTheme.dark,
                    themeMode: themeMode,

                    // Localization
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: locale,

                    initialRoute: Routes.splashView,
                    onGenerateRoute: StackedRouter().onGenerateRoute,
                    navigatorKey: StackedService.navigatorKey,
                    navigatorObservers: [
                      StackedService.routeObserver,
                      PosthogObserver(),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
