// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'VTT Flutter Template';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get retry => 'Retry';

  @override
  String get continue_ => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get submit => 'Submit';

  @override
  String get search => 'Search';

  @override
  String get clear => 'Clear';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading...';

  @override
  String get seeAll => 'See all';

  @override
  String get learnMore => 'Learn more';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get or => 'or';

  @override
  String get and => 'and';

  @override
  String get with_ => 'with';

  @override
  String get from => 'from';

  @override
  String get to => 'to';

  @override
  String get ofWord => 'of';

  @override
  String get in_ => 'in';

  @override
  String get at => 'at';

  @override
  String get on => 'on';

  @override
  String get by => 'by';

  @override
  String get for_ => 'for';

  @override
  String get all => 'All';

  @override
  String get none => 'None';

  @override
  String get more => 'More';

  @override
  String get less => 'Less';

  @override
  String get other => 'Other';

  @override
  String get optional => 'Optional';

  @override
  String get required => 'Required';

  @override
  String get empty => 'Empty';

  @override
  String get unknown => 'Unknown';

  @override
  String get notAvailable => 'Not available';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get login => 'Log in';

  @override
  String get logout => 'Log out';

  @override
  String get register => 'Register';

  @override
  String get signUp => 'Sign up';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get email => 'Email';

  @override
  String get emailAddress => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPassword => 'It happens to everyone';

  @override
  String get newPassword => 'New password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get fullName => 'Full name';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get username => 'Username';

  @override
  String get verificationCode => 'Verification code';

  @override
  String get enterVerificationCode => 'Enter verification code';

  @override
  String get resendCode => 'Resend code';

  @override
  String codeExpiresIn(String time) {
    return 'Code expires in $time';
  }

  @override
  String get createAccount => 'Let\'s get to know each other';

  @override
  String get createAccountAction => 'Create my account';

  @override
  String get alreadyHaveAccount => 'Already one of us?';

  @override
  String get dontHaveAccount => 'First time here?';

  @override
  String get authLoginSubtitle => 'Come on in';

  @override
  String get authRegisterSubtitle => 'It takes 30 seconds';

  @override
  String get authForgotSubtitle => 'We\'ll send you a rescue link';

  @override
  String get loginWithEmail => 'Log in with email';

  @override
  String get loginWithPhone => 'Log in with phone';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get loginWithApple => 'Continue with Apple';

  @override
  String get loginWithGithub => 'Continue with GitHub';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String agreeToTerms(String terms, String privacy) {
    return 'I agree to the $terms and $privacy';
  }

  @override
  String get rememberMe => 'Remember me';

  @override
  String get staySignedIn => 'Stay signed in';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String passwordTooShort(int min) {
    return 'Password must be at least $min characters';
  }

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Please enter a valid phone number';

  @override
  String get nameRequired => 'Name is required';

  @override
  String nameTooShort(int min) {
    return 'Name must be at least $min characters';
  }

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get errorUnknown => 'An unknown error occurred';

  @override
  String get errorNetwork => 'Network error. Please check your connection.';

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get errorUnauthorized => 'Unauthorized. Please log in again.';

  @override
  String get errorForbidden => 'Access denied';

  @override
  String get errorNotFound => 'Not found';

  @override
  String get errorInvalidCredentials => 'Invalid email or password';

  @override
  String get errorEmailAlreadyInUse => 'Email is already registered';

  @override
  String get errorWeakPassword => 'Password is too weak';

  @override
  String get errorUserNotFound => 'User not found';

  @override
  String get errorTooManyRequests =>
      'Too many requests. Please wait and try again.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get errorEmailNotConfirmed =>
      'Please confirm your email before signing in';

  @override
  String get errorOtpExpired => 'Verification code has expired';

  @override
  String get errorUserBanned => 'This account has been suspended';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get tryAgainLater => 'Please try again later';

  @override
  String get success => 'Success';

  @override
  String get successSaved => 'Successfully saved';

  @override
  String get successDeleted => 'Successfully deleted';

  @override
  String get successUpdated => 'Successfully updated';

  @override
  String get successSent => 'Successfully sent';

  @override
  String get successCopied => 'Copied to clipboard';

  @override
  String get successLoggedIn => 'There you are!';

  @override
  String get successLoggedOut => 'See you soon';

  @override
  String get successRegistered => 'Welcome aboard!';

  @override
  String get successPasswordReset => 'Check your inbox';

  @override
  String get successPasswordChanged => 'Password changed successfully';

  @override
  String get successVerificationSent => 'Verification code sent';

  @override
  String get dialogConfirmTitle => 'Confirm';

  @override
  String get dialogConfirmMessage => 'Are you sure?';

  @override
  String get dialogDeleteTitle => 'Delete';

  @override
  String get dialogDeleteMessage => 'Are you sure you want to delete this?';

  @override
  String get dialogLogoutTitle => 'Log out';

  @override
  String get dialogLogoutMessage => 'Are you sure you want to log out?';

  @override
  String get dialogDiscardTitle => 'Discard changes';

  @override
  String get dialogDiscardMessage =>
      'Are you sure you want to discard your changes?';

  @override
  String get dialogExitTitle => 'Exit';

  @override
  String get dialogExitMessage => 'Are you sure you want to exit?';

  @override
  String get emptyResults => 'No results found';

  @override
  String get emptyData => 'No data available';

  @override
  String get emptyNotifications => 'No notifications';

  @override
  String get emptyMessages => 'No messages';

  @override
  String emptySearch(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get profile => 'Profile';

  @override
  String get myProfile => 'My Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get accountSettings => 'Account settings';

  @override
  String get personalInfo => 'Personal information';

  @override
  String get changePassword => 'Change password';

  @override
  String get notifications => 'Notifications';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get help => 'Help';

  @override
  String get support => 'Support';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateApp => 'Rate app';

  @override
  String get shareApp => 'Share app';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get now => 'Now';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get splashInitializing => 'Initializing...';

  @override
  String get splashCheckingAuth => 'Checking authentication...';

  @override
  String get splashLoading => 'Loading...';

  @override
  String get splashReady => 'Ready!';

  @override
  String get splashTagline => 'Build better habits, every day';

  @override
  String get splashPreparingExperience => 'Preparing your experience...';

  @override
  String get splashAlmostThere => 'Almost there...';

  @override
  String get splashFinalTouches => 'Final touches...';

  @override
  String get splashGreetingMorning => 'Good morning';

  @override
  String get splashGreetingAfternoon => 'Good afternoon';

  @override
  String get splashGreetingEvening => 'Good evening';

  @override
  String get onboardingSlide1Title => 'Your space, your rules';

  @override
  String get onboardingSlide1Description =>
      'Create your habits, organize your life by domains, and track your progress at your own pace.';

  @override
  String get onboardingSlide2Title => 'Every minute counts';

  @override
  String get onboardingSlide2Description =>
      'See the time you invest in each domain. Every habit you check off matters.';

  @override
  String get onboardingSlide3Title => 'Week after week';

  @override
  String get onboardingSlide3Description =>
      'Get your weekly review, keep your streaks alive, and become who you want to be.';

  @override
  String get onboardingDomainsTitle => 'Choose your life domains';

  @override
  String get onboardingDomainsDescription =>
      'Select the domains you want to track. You can add more later.';

  @override
  String get onboardingDomainsMinimum => 'Select at least 1 domain';

  @override
  String get welcomeBack => 'Good to see you again';

  @override
  String welcomeBackUser(String name) {
    return 'Good to see you, $name';
  }

  @override
  String get getStarted => 'Get started';

  @override
  String get letsGo => 'Let\'s go!';

  @override
  String get hello => 'Hello';

  @override
  String helloUser(String name) {
    return 'Hello, $name!';
  }

  @override
  String get settings => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsLegal => 'Legal';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsPushNotifications => 'Push Notifications';

  @override
  String get settingsEmailNotifications => 'Email Notifications';

  @override
  String get settingsTerms => 'Terms of Service';

  @override
  String get settingsPrivacy => 'Privacy Policy';

  @override
  String get settingsChangePassword => 'Change Password';

  @override
  String get settingsLogout => 'Log out';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsRateApp => 'Rate App';

  @override
  String get settingsShareApp => 'Share App';

  @override
  String get settingsSelectTheme => 'Select Theme';

  @override
  String get settingsSelectLanguage => 'Select Language';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeSystemDesc => 'Follow device settings';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeLightDesc => 'Always use light theme';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeDarkDesc => 'Always use dark theme';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageFrench => 'French';

  @override
  String get settingsDeleteAccountConfirm =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get notificationsEmptyTitle => 'No Notifications';

  @override
  String get notificationsEmptyDescription =>
      'You don\'t have any notifications yet. We\'ll let you know when something new happens.';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get clearAll => 'Clear all';

  @override
  String get notificationsChannelMarketing => 'Promotions & Offers';

  @override
  String get notificationsChannelMarketingDesc =>
      'Receive special offers and promotions';

  @override
  String get notificationsChannelOrders => 'Orders & Transactions';

  @override
  String get notificationsChannelOrdersDesc =>
      'Updates about your orders and payments';

  @override
  String get notificationsChannelReminders => 'Reminders';

  @override
  String get notificationsChannelRemindersDesc =>
      'Important reminders and alerts';

  @override
  String get notificationsChannelSocial => 'Social Updates';

  @override
  String get notificationsChannelSocialDesc =>
      'Activity from people you follow';

  @override
  String get notificationsChannelStreaks => 'Streaks';

  @override
  String get notificationsChannelStreaksDesc =>
      'Notifications when you maintain or lose a streak';

  @override
  String get notificationsChannelBilan => 'Weekly review';

  @override
  String get notificationsChannelBilanDesc =>
      'Receive your weekly review every Sunday';

  @override
  String get notificationsChannelGeneral => 'General';

  @override
  String get notificationsChannelGeneralDesc =>
      'General updates and information';

  @override
  String get domainsTitle => 'Life Domains';

  @override
  String get domainsEmptyTitle => 'No Domains';

  @override
  String get domainsEmptyDescription =>
      'Add your first life domain to organize your habits.';

  @override
  String get domainAdd => 'New Domain';

  @override
  String get domainName => 'Domain name';

  @override
  String get domainIcon => 'Icon';

  @override
  String get domainColor => 'Color';

  @override
  String get domainArchive => 'Archive';

  @override
  String get domainUnarchive => 'Unarchive';

  @override
  String get domainArchived => 'Archived';

  @override
  String get domainArchivedSection => 'Archived domains';

  @override
  String get domainCannotArchiveLast =>
      'You must keep at least one active domain.';

  @override
  String domainHabitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habits',
      one: '1 habit',
      zero: 'No habits',
    );
    return '$_temp0';
  }

  @override
  String get habitsTitle => 'Habits';

  @override
  String get habitsEmptyTitle => 'No Habits Yet';

  @override
  String get habitsEmptyDescription =>
      'Create your first habit to start tracking your time.';

  @override
  String get habitAdd => 'New Habit';

  @override
  String get habitEdit => 'Edit Habit';

  @override
  String get habitName => 'Habit name';

  @override
  String get habitDescription => 'Description (optional)';

  @override
  String get habitType => 'Type';

  @override
  String get habitTypeBinary => 'Yes / No';

  @override
  String get habitTypeQuantitative => 'Quantitative';

  @override
  String get habitTargetValue => 'Target value';

  @override
  String get habitUnit => 'Unit';

  @override
  String get habitEstimatedDuration => 'Estimated duration';

  @override
  String get habitEstimatedDurationHelper =>
      'This time counts toward your counter';

  @override
  String habitEstimatedDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get habitTimeRange => 'Time range';

  @override
  String get habitEndTimeComputed =>
      'End time is calculated from start + duration';

  @override
  String get habitNotifications => 'Notifications';

  @override
  String get habitReminderOffset => 'Reminder before start time';

  @override
  String get habitReminderAtTime => 'At time';

  @override
  String get habitReminderBefore => 'before';

  @override
  String get habitValueComplete => 'Complete!';

  @override
  String get habitValueSave => 'Save value';

  @override
  String get habitTimeEditSubtitle => 'Adjust actual execution time';

  @override
  String get habitActualStart => 'Started at';

  @override
  String get habitActualEnd => 'Ended at';

  @override
  String get habitActualDuration => 'Actual duration';

  @override
  String get habitFrequency => 'Frequency';

  @override
  String get habitFrequencyDaily => 'Every day';

  @override
  String get habitFrequencyWeekly => 'Specific days';

  @override
  String get habitFrequencyCustom => 'Custom';

  @override
  String get habitArchive => 'Archive this habit';

  @override
  String get habitDomain => 'Domain';

  @override
  String get habitSelectDomain => 'Select a domain';

  @override
  String get habitChecked => 'Done!';

  @override
  String get habitUnchecked => 'Unchecked';

  @override
  String get habitBackdateLimit => 'You can only backdate up to 7 days.';

  @override
  String streakDays(int count) {
    return '${count}d';
  }

  @override
  String streakBest(int count) {
    return 'Best: ${count}d';
  }

  @override
  String get streakFreezeActive => 'Freeze active';

  @override
  String get streakFreezeUsed => 'Freeze used';

  @override
  String get streakFreezeAvailable => '1 freeze available per week';

  @override
  String get streakDetail => 'Streak Detail';

  @override
  String get streakFreeze => 'Streak Freeze';

  @override
  String get streakFreezeDescription =>
      'Automatically preserves your streak if you miss one day per week.';

  @override
  String get streakFreezeEnabled => 'Streak freeze enabled';

  @override
  String get counterTitle => 'Time Counter';

  @override
  String get counterEmptyTitle => 'No Data Yet';

  @override
  String get counterEmptyDescription =>
      'Check off habits to see your time per domain.';

  @override
  String get counterThisWeek => 'This week';

  @override
  String get counterLastWeek => 'Last week';

  @override
  String get counterTotal => 'Total';

  @override
  String counterHours(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String counterDelta(String sign, int hours, int minutes) {
    return '$sign${hours}h ${minutes}m vs last week';
  }

  @override
  String counterPerHabit(int minutes, int days) {
    return '${minutes}min × ${days}d';
  }

  @override
  String get todayEmptyTitle => 'No habits yet';

  @override
  String get todayEmptySubtitle => 'Start by adding your first habit!';

  @override
  String get todayGreetingMorning => 'Good morning ☀️';

  @override
  String get todayGreetingAfternoon => 'Keep going 💪';

  @override
  String get todayGreetingEvening => 'Well done today 🌙';

  @override
  String todayHabitsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habits remaining',
      one: '1 habit remaining',
      zero: 'All done!',
    );
    return '$_temp0';
  }

  @override
  String todayProgress(int done, int total) {
    return '$done/$total habits done';
  }

  @override
  String get todayNoHabits => 'No habits for today';

  @override
  String todayCounterSummary(int hours, int minutes) {
    return 'This week: ${hours}h ${minutes}m';
  }

  @override
  String get todaySectionMorning => 'Morning';

  @override
  String get todaySectionAfternoon => 'Afternoon';

  @override
  String get todaySectionEvening => 'Evening';

  @override
  String get todaySectionAnytime => 'Anytime';

  @override
  String get bilanTitle => 'Weekly Summary';

  @override
  String get bilanReady => '📊 Your summary is ready!';

  @override
  String get bilanShare => 'Share my summary';

  @override
  String get bilanCompletionRate => 'Completion rate';

  @override
  String get bilanTopHabit => 'Top habit';

  @override
  String get bilanLongestStreak => 'Longest streak';

  @override
  String get bilanFirstWeek =>
      'This is your first week — no comparison yet. Keep going!';

  @override
  String get bilanDomainBreakdown => 'Domain breakdown';

  @override
  String bilanWeekOf(String date) {
    return 'Week of $date';
  }

  @override
  String get navToday => 'Today';

  @override
  String get navHabits => 'Habits';

  @override
  String get navCounter => 'Counter';

  @override
  String get todayDone => 'Done';

  @override
  String get todayRemaining => 'Remaining';

  @override
  String get profileCompletion => 'Profile Completion';

  @override
  String get exportData => 'Export Data';

  @override
  String counterTotalWithTime(String time) {
    return 'Total: $time';
  }

  @override
  String counterDeltaVsLastWeek(String delta) {
    return '$delta vs last week';
  }

  @override
  String get bilanViewSummary => 'View summary →';

  @override
  String get bilanHighlights => 'Highlights';

  @override
  String get bilanTotalTime => 'Total time';

  @override
  String get bilanNoDataThisWeek => 'No data this week.';

  @override
  String get bilanWeeklyReady => 'Your weekly summary is ready!';

  @override
  String get habitNameHint => 'E.g.: Meditate';

  @override
  String get habitDescriptionHint => 'Optional description...';

  @override
  String get minuteShort => 'min';

  @override
  String get domainsReorderHint => 'Drag to reorder, tap to edit';

  @override
  String get domainEdit => 'Edit Domain';

  @override
  String domainArchiveConfirmTitle(String name) {
    return 'Archive \"$name\"?';
  }

  @override
  String get domainArchiveConfirmMessage =>
      'This domain will be hidden but not deleted. You can restore it.';

  @override
  String streakConsecutiveDays(int count) {
    return '$count consecutive days';
  }

  @override
  String streakFreezeUsedCount(int count) {
    return 'Freeze used $count times';
  }

  @override
  String get streakFreezeRule => 'Rule: 1 freeze max per 7-day period';

  @override
  String errorExportData(String error) {
    return 'Error during export: $error';
  }

  @override
  String get errorLoadingImage => 'Unable to load image';

  @override
  String get avatarTakePhoto => 'Take Photo';

  @override
  String get avatarChooseFromGallery => 'Choose from Gallery';

  @override
  String get avatarRemovePhoto => 'Remove Photo';

  @override
  String passwordResetSentMessage(String email) {
    return 'A link is waiting for you in $email\'s inbox. Check spam too, just in case.';
  }

  @override
  String get semanticsCompleted => 'completed';

  @override
  String get semanticsNotCompleted => 'not completed';

  @override
  String archivedCount(int count) {
    return 'Archived ($count)';
  }

  @override
  String get domainFormIcon => 'Icon';

  @override
  String get domainFormName => 'Name';

  @override
  String get domainFormNameHint => 'E.g.: Health';

  @override
  String get create => 'Create';

  @override
  String get todayDaySummary => '📊 Today';

  @override
  String get total => 'Total';

  @override
  String get agreeToTermsPrefix => 'I agree to the ';

  @override
  String get defaultDomainHealth => 'Health';

  @override
  String get defaultDomainWork => 'Work';

  @override
  String get defaultDomainRelationships => 'Relationships';

  @override
  String get defaultDomainFinances => 'Finances';

  @override
  String get defaultDomainPersonalDev => 'Personal Development';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get timeAgoJustNow => 'Just now';

  @override
  String timeAgoMinutes(int count) {
    return '${count}m ago';
  }

  @override
  String timeAgoHours(int count) {
    return '${count}h ago';
  }

  @override
  String timeAgoDays(int count) {
    return '${count}d ago';
  }

  @override
  String get dialogDeleteAccountTitle => 'Delete Account';

  @override
  String get dialogDeleteAccountMessage =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get dialogDeleteAccountConfirm => 'Delete';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthMedium => 'Medium';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get restore => 'Restore';

  @override
  String get counterPreviousWeek => 'Previous week';

  @override
  String get counterNextWeek => 'Next week';

  @override
  String get searchHabits => 'Search habits...';

  @override
  String get quickActionsTitle => 'Quick actions';

  @override
  String get editHabit => 'Edit';

  @override
  String get archiveHabit => 'Archive';

  @override
  String archivedLabel(String name) {
    return '$name (archived)';
  }

  @override
  String notifHabitReminderTitle(String habitName) {
    return '⏰ $habitName';
  }

  @override
  String get notifHabitReminderBody => 'Time for your habit!';

  @override
  String get notifWeeklyBilanTitle => '📊 Weekly review';

  @override
  String get notifWeeklyBilanBody => 'It\'s Sunday! Review your week.';

  @override
  String get notifChannelReminders => 'Habit reminders';

  @override
  String get notifChannelRemindersDesc => 'Daily reminders for your habits';

  @override
  String get notifChannelStreaks => 'Streaks';

  @override
  String get notifChannelStreaksDesc => 'Streak and achievement notifications';

  @override
  String get notifChannelBilan => 'Weekly review';

  @override
  String get notifChannelBilanDesc => 'Weekly review reminder';

  @override
  String get celebrationMicroDone => 'Done!';

  @override
  String get celebrationMicroNice => 'Nice!';

  @override
  String get celebrationMicroChecked => 'Checked!';

  @override
  String get celebrationMicroSaved => 'Saved!';

  @override
  String get celebrationMicroGotIt => 'Got it!';

  @override
  String celebrationMediumStreak(int count) {
    return '$count-day streak — keep it up!';
  }

  @override
  String get celebrationMediumWeeklyGoal => 'Weekly goal reached!';

  @override
  String celebrationMediumProgress(int percent) {
    return 'Great progress — you\'re at $percent%!';
  }

  @override
  String get celebrationMediumConsistency => 'You\'re building consistency!';

  @override
  String celebrationMajorMonthStreak(int count) {
    return '$count-day streak — incredible!';
  }

  @override
  String get celebrationMajorGoalComplete => 'Goal complete — well done!';

  @override
  String get celebrationMajorMilestone => 'Milestone unlocked!';

  @override
  String get celebrationMajor100Days => '100 days — legendary!';

  @override
  String get encouragementKeepGoing => 'Keep going, you\'re doing great!';

  @override
  String get encouragementAlmostThere => 'Almost there!';

  @override
  String get encouragementSmallSteps => 'Small steps lead to big changes.';

  @override
  String get encouragementProud => 'You should be proud!';

  @override
  String get encouragementComeBack =>
      'Welcome back — let\'s pick up where you left off.';
}
