// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i21;
import 'package:flutter/material.dart' as _i20;
import 'package:flutter/material.dart';
import 'package:lifeflow/domain/entities/habit_entity.dart' as _i26;
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
    as _i22;
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
import 'package:stacked_services/stacked_services.dart' as _i27;

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
      final args = data.getArgs<SplashViewArguments>(
        orElse: () => const SplashViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.SplashView(key: args.key),
        settings: data,
      );
    },
    _i3.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.LoginView(key: args.key),
        settings: data,
      );
    },
    _i4.RegisterView: (data) {
      final args = data.getArgs<RegisterViewArguments>(
        orElse: () => const RegisterViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.RegisterView(key: args.key),
        settings: data,
      );
    },
    _i5.ForgotPasswordView: (data) {
      final args = data.getArgs<ForgotPasswordViewArguments>(
        orElse: () => const ForgotPasswordViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.ForgotPasswordView(key: args.key),
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
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i11.HomeView(key: args.key),
        settings: data,
      );
    },
    _i12.StartupView: (data) {
      final args = data.getArgs<StartupViewArguments>(
        orElse: () => const StartupViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.StartupView(key: args.key),
        settings: data,
      );
    },
    _i13.DesignShowcaseView: (data) {
      final args = data.getArgs<DesignShowcaseViewArguments>(
        orElse: () => const DesignShowcaseViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i13.DesignShowcaseView(key: args.key),
        settings: data,
      );
    },
    _i14.DomainsView: (data) {
      final args = data.getArgs<DomainsViewArguments>(
        orElse: () => const DomainsViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i14.DomainsView(key: args.key),
        settings: data,
      );
    },
    _i15.HabitsView: (data) {
      final args = data.getArgs<HabitsViewArguments>(
        orElse: () => const HabitsViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i15.HabitsView(key: args.key),
        settings: data,
      );
    },
    _i16.HabitFormView: (data) {
      final args = data.getArgs<HabitFormViewArguments>(
        orElse: () => const HabitFormViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i16.HabitFormView(key: args.key, habit: args.habit),
        settings: data,
      );
    },
    _i17.CounterView: (data) {
      final args = data.getArgs<CounterViewArguments>(
        orElse: () => const CounterViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i17.CounterView(key: args.key),
        settings: data,
      );
    },
    _i18.TodayView: (data) {
      final args = data.getArgs<TodayViewArguments>(
        orElse: () => const TodayViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i18.TodayView(key: args.key),
        settings: data,
      );
    },
    _i19.BilanView: (data) {
      final args = data.getArgs<BilanViewArguments>(
        orElse: () => const BilanViewArguments(),
      );
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => _i19.BilanView(key: args.key),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class SplashViewArguments {
  const SplashViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SplashViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class RegisterViewArguments {
  const RegisterViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant RegisterViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ForgotPasswordViewArguments {
  const ForgotPasswordViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ForgotPasswordViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class OnboardingViewArguments {
  const OnboardingViewArguments({
    this.config,
    this.key,
  });

  final _i22.OnboardingConfig? config;

  final _i21.Key? key;

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

  final _i21.Key? key;

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

  final _i21.Key? key;

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

  final _i21.Key? key;

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

  final _i21.Key? key;

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

class HomeViewArguments {
  const HomeViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HomeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class StartupViewArguments {
  const StartupViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant StartupViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class DesignShowcaseViewArguments {
  const DesignShowcaseViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant DesignShowcaseViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class DomainsViewArguments {
  const DomainsViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant DomainsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class HabitsViewArguments {
  const HabitsViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HabitsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class HabitFormViewArguments {
  const HabitFormViewArguments({
    this.key,
    this.habit,
  });

  final _i21.Key? key;

  final _i26.HabitEntity? habit;

  @override
  String toString() {
    return '{"key": "$key", "habit": "$habit"}';
  }

  @override
  bool operator ==(covariant HabitFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.habit == habit;
  }

  @override
  int get hashCode {
    return key.hashCode ^ habit.hashCode;
  }
}

class CounterViewArguments {
  const CounterViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant CounterViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class TodayViewArguments {
  const TodayViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant TodayViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class BilanViewArguments {
  const BilanViewArguments({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant BilanViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

extension NavigatorStateExtension on _i27.NavigationService {
  Future<dynamic> navigateToSplashView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.splashView,
        arguments: SplashViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRegisterView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.registerView,
        arguments: RegisterViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForgotPasswordView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.forgotPasswordView,
        arguments: ForgotPasswordViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOnboardingView({
    _i22.OnboardingConfig? config,
    _i21.Key? key,
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
    _i21.Key? key,
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
    _i21.Key? key,
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
    _i21.Key? key,
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
    _i21.Key? key,
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

  Future<dynamic> navigateToHomeView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.homeView,
        arguments: HomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.startupView,
        arguments: StartupViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDesignShowcaseView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.designShowcaseView,
        arguments: DesignShowcaseViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDomainsView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.domainsView,
        arguments: DomainsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHabitsView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.habitsView,
        arguments: HabitsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHabitFormView({
    _i21.Key? key,
    _i26.HabitEntity? habit,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.habitFormView,
        arguments: HabitFormViewArguments(key: key, habit: habit),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCounterView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.counterView,
        arguments: CounterViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTodayView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.todayView,
        arguments: TodayViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBilanView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.bilanView,
        arguments: BilanViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplashView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.splashView,
        arguments: SplashViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRegisterView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.registerView,
        arguments: RegisterViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithForgotPasswordView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.forgotPasswordView,
        arguments: ForgotPasswordViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOnboardingView({
    _i22.OnboardingConfig? config,
    _i21.Key? key,
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
    _i21.Key? key,
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
    _i21.Key? key,
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
    _i21.Key? key,
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
    _i21.Key? key,
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

  Future<dynamic> replaceWithHomeView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.homeView,
        arguments: HomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.startupView,
        arguments: StartupViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDesignShowcaseView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.designShowcaseView,
        arguments: DesignShowcaseViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDomainsView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.domainsView,
        arguments: DomainsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHabitsView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.habitsView,
        arguments: HabitsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHabitFormView({
    _i21.Key? key,
    _i26.HabitEntity? habit,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.habitFormView,
        arguments: HabitFormViewArguments(key: key, habit: habit),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCounterView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.counterView,
        arguments: CounterViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTodayView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.todayView,
        arguments: TodayViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBilanView({
    _i21.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.bilanView,
        arguments: BilanViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
