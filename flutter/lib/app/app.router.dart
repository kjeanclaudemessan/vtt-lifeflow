// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i22;
import 'package:flutter/material.dart' as _i20;
import 'package:flutter/material.dart';
import 'package:lifeflow/features/bilan/views/bilan_view.dart' as _i19;
import 'package:lifeflow/features/counter/views/counter_view.dart' as _i17;
import 'package:lifeflow/features/domains/views/domains_view.dart' as _i14;
import 'package:lifeflow/features/habits/views/habit_form_view.dart' as _i16;
import 'package:lifeflow/features/habits/views/habits_view.dart' as _i15;
import 'package:lifeflow/features/today/views/today_view.dart' as _i18;
import 'package:lifeflow/modules/auth/views/forgot_password_view.dart' as _i5;
import 'package:lifeflow/modules/auth/views/login_view.dart' as _i3;
import 'package:lifeflow/modules/auth/views/register_view.dart' as _i4;
import 'package:lifeflow/modules/notifications/config/notifications_config.dart'
    as _i25;
import 'package:lifeflow/modules/notifications/views/notifications_view.dart'
    as _i10;
import 'package:lifeflow/modules/onboarding/config/onboarding_config.dart'
    as _i21;
import 'package:lifeflow/modules/onboarding/views/onboarding_view.dart' as _i6;
import 'package:lifeflow/modules/profile/config/profile_config.dart' as _i23;
import 'package:lifeflow/modules/profile/views/edit_profile_view.dart' as _i8;
import 'package:lifeflow/modules/profile/views/profile_view.dart' as _i7;
import 'package:lifeflow/modules/settings/config/settings_config.dart' as _i24;
import 'package:lifeflow/modules/settings/views/settings_view.dart' as _i9;
import 'package:lifeflow/modules/splash/views/splash_view.dart' as _i2;
import 'package:lifeflow/ui/views/design_showcase/design_showcase_view.dart'
    as _i13;
import 'package:lifeflow/ui/views/home/home_view.dart' as _i11;
import 'package:lifeflow/ui/views/startup/startup_view.dart' as _i12;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i26;

class Routes {
  static const splashView = '/';

  static const loginView = '/login-view';

  static const registerView = '/register-view';

  static const forgotPasswordView = '/forgot-password-view';

  static const onboardingView = '/onboarding-view';

  static const profileView = '/profile-view';

  static const editProfileView = '/edit-profile-view';

  static const settingsView = '/settings-view';

  static const notificationsView = '/notifications-view';

  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const designShowcaseView = '/design-showcase-view';

  static const domainsView = '/domains-view';

  static const habitsView = '/habits-view';

  static const habitFormView = '/habit-form-view';

  static const counterView = '/counter-view';

  static const todayView = '/today-view';

  static const bilanView = '/bilan-view';

  static const all = <String>{
    splashView,
    loginView,
    registerView,
    forgotPasswordView,
    onboardingView,
    profileView,
    editProfileView,
    settingsView,
    notificationsView,
    homeView,
    startupView,
    designShowcaseView,
    domainsView,
    habitsView,
    habitFormView,
    counterView,
    todayView,
    bilanView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.splashView,
      page: _i2.SplashView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i3.LoginView,
    ),
    _i1.RouteDef(
      Routes.registerView,
      page: _i4.RegisterView,
    ),
    _i1.RouteDef(
      Routes.forgotPasswordView,
      page: _i5.ForgotPasswordView,
    ),
    _i1.RouteDef(
      Routes.onboardingView,
      page: _i6.OnboardingView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i7.ProfileView,
    ),
    _i1.RouteDef(
      Routes.editProfileView,
      page: _i8.EditProfileView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i9.SettingsView,
    ),
    _i1.RouteDef(
      Routes.notificationsView,
      page: _i10.NotificationsView,
    ),
    _i1.RouteDef(
      Routes.homeView,
      page: _i11.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i12.StartupView,
    ),
    _i1.RouteDef(
      Routes.designShowcaseView,
      page: _i13.DesignShowcaseView,
    ),
    _i1.RouteDef(
      Routes.domainsView,
      page: _i14.DomainsView,
    ),
    _i1.RouteDef(
      Routes.habitsView,
      page: _i15.HabitsView,
    ),
    _i1.RouteDef(
      Routes.habitFormView,
      page: _i16.HabitFormView,
    ),
    _i1.RouteDef(
      Routes.counterView,
      page: _i17.CounterView,
    ),
    _i1.RouteDef(
      Routes.todayView,
      page: _i18.TodayView,
    ),
    _i1.RouteDef(
      Routes.bilanView,
      page: _i19.BilanView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.SplashView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.SplashView(),
        settings: data,
      );
    },
    _i3.LoginView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.LoginView(),
        settings: data,
      );
    },
    _i4.RegisterView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.RegisterView(),
        settings: data,
      );
    },
    _i5.ForgotPasswordView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.ForgotPasswordView(),
        settings: data,
      );
    },
    _i6.OnboardingView: (data) {
      final args = data.getArgs<OnboardingViewArguments>(
        orElse: () => const OnboardingViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i6.OnboardingView(config: args.config, key: args.key),
        settings: data,
      );
    },
    _i7.ProfileView: (data) {
      final args = data.getArgs<ProfileViewArguments>(
        orElse: () => const ProfileViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i7.ProfileView(config: args.config, key: args.key),
        settings: data,
      );
    },
    _i8.EditProfileView: (data) {
      final args = data.getArgs<EditProfileViewArguments>(
        orElse: () => const EditProfileViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.EditProfileView(config: args.config, key: args.key),
        settings: data,
      );
    },
    _i9.SettingsView: (data) {
      final args = data.getArgs<SettingsViewArguments>(
        orElse: () => const SettingsViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i9.SettingsView(config: args.config, key: args.key),
        settings: data,
      );
    },
    _i10.NotificationsView: (data) {
      final args = data.getArgs<NotificationsViewArguments>(
        orElse: () => const NotificationsViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i10.NotificationsView(config: args.config, key: args.key),
        settings: data,
      );
    },
    _i11.HomeView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i11.HomeView(),
        settings: data,
      );
    },
    _i12.StartupView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.StartupView(),
        settings: data,
      );
    },
    _i13.DesignShowcaseView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.DesignShowcaseView(),
        settings: data,
      );
    },
    _i14.DomainsView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i14.DomainsView(),
        settings: data,
      );
    },
    _i15.HabitsView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i15.HabitsView(),
        settings: data,
      );
    },
    _i16.HabitFormView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.HabitFormView(),
        settings: data,
      );
    },
    _i17.CounterView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i17.CounterView(),
        settings: data,
      );
    },
    _i18.TodayView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i18.TodayView(),
        settings: data,
      );
    },
    _i19.BilanView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i19.BilanView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class OnboardingViewArguments {
  const OnboardingViewArguments({
    this.config,
    this.key,
  });

  final _i21.OnboardingConfig? config;

  final _i22.Key? key;

  @override
  String toString() {
    return '{"config": "$config", "key": "$key"}';
  }

  @override
  bool operator ==(covariant OnboardingViewArguments other) {
    if (identical(this, other)) return true;
    return other.config == config && other.key == key;
  }

  @override
  int get hashCode {
    return config.hashCode ^ key.hashCode;
  }
}

class ProfileViewArguments {
  const ProfileViewArguments({
    this.config,
    this.key,
  });

  final _i23.ProfileConfig? config;

  final _i22.Key? key;

  @override
  String toString() {
    return '{"config": "$config", "key": "$key"}';
  }

  @override
  bool operator ==(covariant ProfileViewArguments other) {
    if (identical(this, other)) return true;
    return other.config == config && other.key == key;
  }

  @override
  int get hashCode {
    return config.hashCode ^ key.hashCode;
  }
}

class EditProfileViewArguments {
  const EditProfileViewArguments({
    this.config,
    this.key,
  });

  final _i23.ProfileConfig? config;

  final _i22.Key? key;

  @override
  String toString() {
    return '{"config": "$config", "key": "$key"}';
  }

  @override
  bool operator ==(covariant EditProfileViewArguments other) {
    if (identical(this, other)) return true;
    return other.config == config && other.key == key;
  }

  @override
  int get hashCode {
    return config.hashCode ^ key.hashCode;
  }
}

class SettingsViewArguments {
  const SettingsViewArguments({
    this.config,
    this.key,
  });

  final _i24.SettingsConfig? config;

  final _i22.Key? key;

  @override
  String toString() {
    return '{"config": "$config", "key": "$key"}';
  }

  @override
  bool operator ==(covariant SettingsViewArguments other) {
    if (identical(this, other)) return true;
    return other.config == config && other.key == key;
  }

  @override
  int get hashCode {
    return config.hashCode ^ key.hashCode;
  }
}

class NotificationsViewArguments {
  const NotificationsViewArguments({
    this.config,
    this.key,
  });

  final _i25.NotificationsConfig? config;

  final _i22.Key? key;

  @override
  String toString() {
    return '{"config": "$config", "key": "$key"}';
  }

  @override
  bool operator ==(covariant NotificationsViewArguments other) {
    if (identical(this, other)) return true;
    return other.config == config && other.key == key;
  }

  @override
  int get hashCode {
    return config.hashCode ^ key.hashCode;
  }
}

extension NavigatorStateExtension on _i26.NavigationService {
  Future<dynamic> navigateToSplashView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.splashView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.registerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForgotPasswordView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.forgotPasswordView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOnboardingView({
    _i21.OnboardingConfig? config,
    _i22.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.onboardingView,
        arguments: OnboardingViewArguments(config: config, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView({
    _i23.ProfileConfig? config,
    _i22.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.profileView,
        arguments: ProfileViewArguments(config: config, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEditProfileView({
    _i23.ProfileConfig? config,
    _i22.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.editProfileView,
        arguments: EditProfileViewArguments(config: config, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView({
    _i24.SettingsConfig? config,
    _i22.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.settingsView,
        arguments: SettingsViewArguments(config: config, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNotificationsView({
    _i25.NotificationsConfig? config,
    _i22.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.notificationsView,
        arguments: NotificationsViewArguments(config: config, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDesignShowcaseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.designShowcaseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDomainsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.domainsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHabitsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.habitsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHabitFormView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.habitFormView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCounterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.counterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTodayView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.todayView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBilanView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.bilanView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplashView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.splashView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.registerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithForgotPasswordView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.forgotPasswordView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOnboardingView({
    _i21.OnboardingConfig? config,
    _i22.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.onboardingView,
        arguments: OnboardingViewArguments(config: config, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView({
    _i23.ProfileConfig? config,
    _i22.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.profileView,
        arguments: ProfileViewArguments(config: config, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEditProfileView({
    _i23.ProfileConfig? config,
    _i22.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.editProfileView,
        arguments: EditProfileViewArguments(config: config, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView({
    _i24.SettingsConfig? config,
    _i22.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.settingsView,
        arguments: SettingsViewArguments(config: config, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNotificationsView({
    _i25.NotificationsConfig? config,
    _i22.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.notificationsView,
        arguments: NotificationsViewArguments(config: config, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDesignShowcaseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.designShowcaseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDomainsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.domainsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHabitsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.habitsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHabitFormView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.habitFormView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCounterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.counterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTodayView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.todayView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBilanView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.bilanView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
