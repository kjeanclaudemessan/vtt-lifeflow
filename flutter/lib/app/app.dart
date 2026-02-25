import 'package:lifeflow/services/analytics/analytics_service.dart';
import 'package:lifeflow/services/moneroo/moneroo_service.dart';
import 'package:lifeflow/services/push_notification/push_notification_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:lifeflow/data/repositories/auth_repository_impl.dart';
import 'package:lifeflow/data/repositories/domain_repository_impl.dart';
import 'package:lifeflow/data/repositories/habit_repository_impl.dart';
import 'package:lifeflow/domain/repositories/i_auth_repository.dart';
import 'package:lifeflow/domain/repositories/i_domain_repository.dart';
import 'package:lifeflow/domain/repositories/i_habit_repository.dart';
import 'package:lifeflow/modules/auth/views/forgot_password_view.dart';
import 'package:lifeflow/modules/auth/views/login_view.dart';
import 'package:lifeflow/modules/auth/views/register_view.dart';
import 'package:lifeflow/modules/notifications/views/notifications_view.dart';
import 'package:lifeflow/modules/onboarding/views/onboarding_view.dart';
import 'package:lifeflow/modules/optional/payments/payment_service.dart';
import 'package:lifeflow/modules/profile/views/edit_profile_view.dart';
import 'package:lifeflow/modules/profile/views/profile_view.dart';
import 'package:lifeflow/modules/settings/views/settings_view.dart';
import 'package:lifeflow/modules/splash/views/splash_view.dart';
import 'package:lifeflow/features/domains/views/domains_view.dart';
import 'package:lifeflow/features/habits/views/habits_view.dart';
import 'package:lifeflow/features/habits/views/habit_form_view.dart';
import 'package:lifeflow/features/counter/views/counter_view.dart';
import 'package:lifeflow/features/today/views/today_view.dart';
import 'package:lifeflow/features/bilan/views/bilan_view.dart';
import 'package:lifeflow/services/api/api_service.dart';
import 'package:lifeflow/services/bilan_service.dart';
import 'package:lifeflow/services/connectivity/connectivity_service.dart';
import 'package:lifeflow/services/dialog/dialog_helper.dart';
import 'package:lifeflow/services/storage/local_storage_service.dart';
import 'package:lifeflow/services/storage/secure_storage_service.dart';
import 'package:lifeflow/services/storage/storage_service.dart';
import 'package:lifeflow/services/supabase/supabase_auth_service.dart';
import 'package:lifeflow/services/supabase/supabase_service.dart';
import 'package:lifeflow/services/time_counter_service.dart';
import 'package:lifeflow/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:lifeflow/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:lifeflow/ui/views/design_showcase/design_showcase_view.dart';
import 'package:lifeflow/ui/views/home/home_view.dart';
import 'package:lifeflow/ui/views/startup/startup_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    // ═══════════════════════════════════════════════════════════════════════
    // MODULE ROUTES
    // ═══════════════════════════════════════════════════════════════════════
    MaterialRoute(page: SplashView, initial: true),

    // Auth module routes
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: ForgotPasswordView),

    // Onboarding module routes
    MaterialRoute(page: OnboardingView),

    // Profile module routes
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: EditProfileView),

    // Settings module routes
    MaterialRoute(page: SettingsView),

    // Notifications module routes
    MaterialRoute(page: NotificationsView),

    // ═══════════════════════════════════════════════════════════════════════
    // UI ROUTES
    // ═══════════════════════════════════════════════════════════════════════
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: DesignShowcaseView),

    // ═══════════════════════════════════════════════════════════════════════
    // FEATURE ROUTES (Phase 1)
    // ═══════════════════════════════════════════════════════════════════════
    MaterialRoute(page: DomainsView),
    MaterialRoute(page: HabitsView),
    MaterialRoute(page: HabitFormView),
    MaterialRoute(page: CounterView),
    MaterialRoute(page: TodayView),
    MaterialRoute(page: BilanView),

    // ═══════════════════════════════════════════════════════════════════════
    // FEATURE ROUTES (Development)
    // ═══════════════════════════════════════════════════════════════════════
    // @stacked-route
  ],
  dependencies: [
    // ═══════════════════════════════════════════════════════════════════════
    // STACKED SERVICES
    // ═══════════════════════════════════════════════════════════════════════
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SnackbarService),

    // ═══════════════════════════════════════════════════════════════════════
    // STORAGE SERVICES (require init)
    // ═══════════════════════════════════════════════════════════════════════
    Singleton(classType: LocalStorageService),
    LazySingleton(classType: SecureStorageService),

    // ═══════════════════════════════════════════════════════════════════════
    // APP SERVICES
    // ═══════════════════════════════════════════════════════════════════════
    LazySingleton(classType: ApiService),
    Singleton(classType: ConnectivityService),
    LazySingleton(classType: DialogHelper),

    // ═══════════════════════════════════════════════════════════════════════
    // SUPABASE SERVICES
    // ═══════════════════════════════════════════════════════════════════════
    LazySingleton(classType: SupabaseService),
    LazySingleton(classType: SupabaseAuthService),
    LazySingleton(classType: StorageService),

    // ═══════════════════════════════════════════════════════════════════════
    // DEVICE SERVICES
    // ═══════════════════════════════════════════════════════════════════════

    // ═══════════════════════════════════════════════════════════════════════
    // FIREBASE SERVICES
    // ═══════════════════════════════════════════════════════════════════════

    // ═══════════════════════════════════════════════════════════════════════
    // ═══════════════════════════════════════════════════════════════════════

    // ═══════════════════════════════════════════════════════════════════════
    // ANALYTICS & ERROR REPORTING (PostHog)
    // ═══════════════════════════════════════════════════════════════════════
    LazySingleton(classType: AnalyticsService),

    // ═══════════════════════════════════════════════════════════════════════
    // PUSH NOTIFICATIONS (FCM)
    // ═══════════════════════════════════════════════════════════════════════
    LazySingleton(classType: PushNotificationService),

    // ═══════════════════════════════════════════════════════════════════════
    // REPOSITORIES
    // ═══════════════════════════════════════════════════════════════════════
    LazySingleton(classType: AuthRepositoryImpl, asType: IAuthRepository),
    LazySingleton(classType: DomainRepositoryImpl, asType: IDomainRepository),
    LazySingleton(classType: HabitRepositoryImpl, asType: IHabitRepository),

    // ═══════════════════════════════════════════════════════════════════════
    // FEATURE SERVICES (Phase 1)
    // ═══════════════════════════════════════════════════════════════════════
    LazySingleton(classType: TimeCounterService),
    LazySingleton(classType: BilanService),

    // ═══════════════════════════════════════════════════════════════════════
    // OPTIONAL MODULE SERVICES
    // ═══════════════════════════════════════════════════════════════════════
    LazySingleton(classType: PaymentService),
    LazySingleton(classType: MonerooService),

    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
