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
  String get resetPassword => 'Reset password';

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
  String get createAccount => 'Create account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

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
  String get successLoggedIn => 'Successfully logged in';

  @override
  String get successLoggedOut => 'Successfully logged out';

  @override
  String get successRegistered => 'Account created successfully';

  @override
  String get successPasswordReset => 'Password reset email sent';

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
  String get onboardingSlide1Title => 'Welcome';

  @override
  String get onboardingSlide1Description =>
      'Discover all the features of our app designed to make your life easier.';

  @override
  String get onboardingSlide2Title => 'Stay Connected';

  @override
  String get onboardingSlide2Description =>
      'Get real-time updates and notifications to never miss anything important.';

  @override
  String get onboardingSlide3Title => 'Get Started';

  @override
  String get onboardingSlide3Description =>
      'Create your account and start your journey with us today.';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String welcomeBackUser(String name) {
    return 'Welcome back, $name!';
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
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

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
}
