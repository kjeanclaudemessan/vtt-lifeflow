import 'package:stacked/stacked.dart';
import 'package:lifeflow/app/app.locator.dart';
import 'package:lifeflow/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/storage/local_storage_service.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _localStorage = locator<LocalStorageService>();

  Future runStartupLogic() async {
    // Brief splash delay
    await Future.delayed(const Duration(seconds: 1));

    // Check auth status
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      // Not authenticated → login
      _navigationService.replaceWithLoginView();
      return;
    }

    // Check onboarding
    final onboardingDone =
        _localStorage.getBool('onboarding_completed') ?? false;

    if (!onboardingDone) {
      _navigationService.replaceWithOnboardingView();
      return;
    }

    // All good → home
    _navigationService.replaceWithHomeView();
  }
}
