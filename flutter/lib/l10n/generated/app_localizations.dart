import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'VTT Flutter Template'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @with_.
  ///
  /// In en, this message translates to:
  /// **'with'**
  String get with_;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @ofWord.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofWord;

  /// No description provided for @in_.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get in_;

  /// No description provided for @at.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get on;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// No description provided for @for_.
  ///
  /// In en, this message translates to:
  /// **'for'**
  String get for_;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @less.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get less;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enterVerificationCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @codeExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Code expires in {time}'**
  String codeExpiresIn(String time);

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @loginWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Log in with email'**
  String get loginWithEmail;

  /// No description provided for @loginWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Log in with phone'**
  String get loginWithPhone;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginWithGoogle;

  /// No description provided for @loginWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get loginWithApple;

  /// No description provided for @loginWithGithub.
  ///
  /// In en, this message translates to:
  /// **'Continue with GitHub'**
  String get loginWithGithub;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the {terms} and {privacy}'**
  String agreeToTerms(String terms, String privacy);

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @staySignedIn.
  ///
  /// In en, this message translates to:
  /// **'Stay signed in'**
  String get staySignedIn;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {min} characters'**
  String passwordTooShort(int min);

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneInvalid;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least {min} characters'**
  String nameTooShort(int min);

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get errorUnknown;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized. Please log in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get errorNotFound;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Email is already registered'**
  String get errorEmailAlreadyInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get errorWeakPassword;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get errorUserNotFound;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait and try again.'**
  String get errorTooManyRequests;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email before signing in'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'Verification code has expired'**
  String get errorOtpExpired;

  /// No description provided for @errorUserBanned.
  ///
  /// In en, this message translates to:
  /// **'This account has been suspended'**
  String get errorUserBanned;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get tryAgainLater;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @successSaved.
  ///
  /// In en, this message translates to:
  /// **'Successfully saved'**
  String get successSaved;

  /// No description provided for @successDeleted.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted'**
  String get successDeleted;

  /// No description provided for @successUpdated.
  ///
  /// In en, this message translates to:
  /// **'Successfully updated'**
  String get successUpdated;

  /// No description provided for @successSent.
  ///
  /// In en, this message translates to:
  /// **'Successfully sent'**
  String get successSent;

  /// No description provided for @successCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get successCopied;

  /// No description provided for @successLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Successfully logged in'**
  String get successLoggedIn;

  /// No description provided for @successLoggedOut.
  ///
  /// In en, this message translates to:
  /// **'Successfully logged out'**
  String get successLoggedOut;

  /// No description provided for @successRegistered.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get successRegistered;

  /// No description provided for @successPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get successPasswordReset;

  /// No description provided for @successPasswordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get successPasswordChanged;

  /// No description provided for @successVerificationSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get successVerificationSent;

  /// No description provided for @dialogConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dialogConfirmTitle;

  /// No description provided for @dialogConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get dialogConfirmMessage;

  /// No description provided for @dialogDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialogDeleteTitle;

  /// No description provided for @dialogDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get dialogDeleteMessage;

  /// No description provided for @dialogLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get dialogLogoutTitle;

  /// No description provided for @dialogLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get dialogLogoutMessage;

  /// No description provided for @dialogDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes'**
  String get dialogDiscardTitle;

  /// No description provided for @dialogDiscardMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to discard your changes?'**
  String get dialogDiscardMessage;

  /// No description provided for @dialogExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get dialogExitTitle;

  /// No description provided for @dialogExitMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get dialogExitMessage;

  /// No description provided for @emptyResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get emptyResults;

  /// No description provided for @emptyData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get emptyData;

  /// No description provided for @emptyNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get emptyNotifications;

  /// No description provided for @emptyMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get emptyMessages;

  /// No description provided for @emptySearch.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String emptySearch(String query);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get accountSettings;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalInfo;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate app'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share app'**
  String get shareApp;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @splashInitializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get splashInitializing;

  /// No description provided for @splashCheckingAuth.
  ///
  /// In en, this message translates to:
  /// **'Checking authentication...'**
  String get splashCheckingAuth;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get splashLoading;

  /// No description provided for @splashReady.
  ///
  /// In en, this message translates to:
  /// **'Ready!'**
  String get splashReady;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Build better habits, every day'**
  String get splashTagline;

  /// No description provided for @splashPreparingExperience.
  ///
  /// In en, this message translates to:
  /// **'Preparing your experience...'**
  String get splashPreparingExperience;

  /// No description provided for @splashAlmostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there...'**
  String get splashAlmostThere;

  /// No description provided for @splashFinalTouches.
  ///
  /// In en, this message translates to:
  /// **'Final touches...'**
  String get splashFinalTouches;

  /// No description provided for @splashGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get splashGreetingMorning;

  /// No description provided for @splashGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get splashGreetingAfternoon;

  /// No description provided for @splashGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get splashGreetingEvening;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Build your habits'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Description.
  ///
  /// In en, this message translates to:
  /// **'Create daily habits, organize them by life domain and track your progress every day.'**
  String get onboardingSlide1Description;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Track your time'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Description.
  ///
  /// In en, this message translates to:
  /// **'Visualize the time invested in each domain with the automatic counter. Every checked habit counts.'**
  String get onboardingSlide2Description;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Progress every week'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Description.
  ///
  /// In en, this message translates to:
  /// **'Receive your weekly review, maintain your streaks and become the best version of yourself.'**
  String get onboardingSlide3Description;

  /// No description provided for @onboardingDomainsTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your life domains'**
  String get onboardingDomainsTitle;

  /// No description provided for @onboardingDomainsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the domains you want to track. You can add more later.'**
  String get onboardingDomainsDescription;

  /// No description provided for @onboardingDomainsMinimum.
  ///
  /// In en, this message translates to:
  /// **'Select at least 1 domain'**
  String get onboardingDomainsMinimum;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @welcomeBackUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBackUser(String name);

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get letsGo;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String helloUser(String name);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get settingsLegal;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsPushNotifications;

  /// No description provided for @settingsEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get settingsEmailNotifications;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settingsChangePassword;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settingsLogout;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get settingsRateApp;

  /// No description provided for @settingsShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get settingsShareApp;

  /// No description provided for @settingsSelectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get settingsSelectTheme;

  /// No description provided for @settingsSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settingsSelectLanguage;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow device settings'**
  String get settingsThemeSystemDesc;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeLightDesc.
  ///
  /// In en, this message translates to:
  /// **'Always use light theme'**
  String get settingsThemeLightDesc;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeDarkDesc.
  ///
  /// In en, this message translates to:
  /// **'Always use dark theme'**
  String get settingsThemeDarkDesc;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get settingsLanguageFrench;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications yet. We\'ll let you know when something new happens.'**
  String get notificationsEmptyDescription;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @notificationsChannelMarketing.
  ///
  /// In en, this message translates to:
  /// **'Promotions & Offers'**
  String get notificationsChannelMarketing;

  /// No description provided for @notificationsChannelMarketingDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive special offers and promotions'**
  String get notificationsChannelMarketingDesc;

  /// No description provided for @notificationsChannelOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders & Transactions'**
  String get notificationsChannelOrders;

  /// No description provided for @notificationsChannelOrdersDesc.
  ///
  /// In en, this message translates to:
  /// **'Updates about your orders and payments'**
  String get notificationsChannelOrdersDesc;

  /// No description provided for @notificationsChannelReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notificationsChannelReminders;

  /// No description provided for @notificationsChannelRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Important reminders and alerts'**
  String get notificationsChannelRemindersDesc;

  /// No description provided for @notificationsChannelSocial.
  ///
  /// In en, this message translates to:
  /// **'Social Updates'**
  String get notificationsChannelSocial;

  /// No description provided for @notificationsChannelSocialDesc.
  ///
  /// In en, this message translates to:
  /// **'Activity from people you follow'**
  String get notificationsChannelSocialDesc;

  /// No description provided for @notificationsChannelStreaks.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get notificationsChannelStreaks;

  /// No description provided for @notificationsChannelStreaksDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications when you maintain or lose a streak'**
  String get notificationsChannelStreaksDesc;

  /// No description provided for @notificationsChannelBilan.
  ///
  /// In en, this message translates to:
  /// **'Weekly review'**
  String get notificationsChannelBilan;

  /// No description provided for @notificationsChannelBilanDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive your weekly review every Sunday'**
  String get notificationsChannelBilanDesc;

  /// No description provided for @notificationsChannelGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get notificationsChannelGeneral;

  /// No description provided for @notificationsChannelGeneralDesc.
  ///
  /// In en, this message translates to:
  /// **'General updates and information'**
  String get notificationsChannelGeneralDesc;

  /// No description provided for @domainsTitle.
  ///
  /// In en, this message translates to:
  /// **'Life Domains'**
  String get domainsTitle;

  /// No description provided for @domainsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Domains'**
  String get domainsEmptyTitle;

  /// No description provided for @domainsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your first life domain to organize your habits.'**
  String get domainsEmptyDescription;

  /// No description provided for @domainAdd.
  ///
  /// In en, this message translates to:
  /// **'New Domain'**
  String get domainAdd;

  /// No description provided for @domainName.
  ///
  /// In en, this message translates to:
  /// **'Domain name'**
  String get domainName;

  /// No description provided for @domainIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get domainIcon;

  /// No description provided for @domainColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get domainColor;

  /// No description provided for @domainArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get domainArchive;

  /// No description provided for @domainUnarchive.
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get domainUnarchive;

  /// No description provided for @domainArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get domainArchived;

  /// No description provided for @domainArchivedSection.
  ///
  /// In en, this message translates to:
  /// **'Archived domains'**
  String get domainArchivedSection;

  /// No description provided for @domainCannotArchiveLast.
  ///
  /// In en, this message translates to:
  /// **'You must keep at least one active domain.'**
  String get domainCannotArchiveLast;

  /// No description provided for @domainHabitCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No habits} =1{1 habit} other{{count} habits}}'**
  String domainHabitCount(int count);

  /// No description provided for @habitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get habitsTitle;

  /// No description provided for @habitsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Habits Yet'**
  String get habitsEmptyTitle;

  /// No description provided for @habitsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your first habit to start tracking your time.'**
  String get habitsEmptyDescription;

  /// No description provided for @habitAdd.
  ///
  /// In en, this message translates to:
  /// **'New Habit'**
  String get habitAdd;

  /// No description provided for @habitEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Habit'**
  String get habitEdit;

  /// No description provided for @habitName.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitName;

  /// No description provided for @habitDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get habitDescription;

  /// No description provided for @habitType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get habitType;

  /// No description provided for @habitTypeBinary.
  ///
  /// In en, this message translates to:
  /// **'Yes / No'**
  String get habitTypeBinary;

  /// No description provided for @habitTypeQuantitative.
  ///
  /// In en, this message translates to:
  /// **'Quantitative'**
  String get habitTypeQuantitative;

  /// No description provided for @habitTargetValue.
  ///
  /// In en, this message translates to:
  /// **'Target value'**
  String get habitTargetValue;

  /// No description provided for @habitUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get habitUnit;

  /// No description provided for @habitEstimatedDuration.
  ///
  /// In en, this message translates to:
  /// **'Estimated duration'**
  String get habitEstimatedDuration;

  /// No description provided for @habitEstimatedDurationHelper.
  ///
  /// In en, this message translates to:
  /// **'This time counts toward your counter'**
  String get habitEstimatedDurationHelper;

  /// No description provided for @habitEstimatedDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String habitEstimatedDurationMinutes(int minutes);

  /// No description provided for @habitTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Time range'**
  String get habitTimeRange;

  /// No description provided for @habitEndTimeComputed.
  ///
  /// In en, this message translates to:
  /// **'End time is calculated from start + duration'**
  String get habitEndTimeComputed;

  /// No description provided for @habitNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get habitNotifications;

  /// No description provided for @habitReminderOffset.
  ///
  /// In en, this message translates to:
  /// **'Reminder before start time'**
  String get habitReminderOffset;

  /// No description provided for @habitReminderAtTime.
  ///
  /// In en, this message translates to:
  /// **'At time'**
  String get habitReminderAtTime;

  /// No description provided for @habitReminderBefore.
  ///
  /// In en, this message translates to:
  /// **'before'**
  String get habitReminderBefore;

  /// No description provided for @habitValueComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete!'**
  String get habitValueComplete;

  /// No description provided for @habitValueSave.
  ///
  /// In en, this message translates to:
  /// **'Save value'**
  String get habitValueSave;

  /// No description provided for @habitTimeEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust actual execution time'**
  String get habitTimeEditSubtitle;

  /// No description provided for @habitActualStart.
  ///
  /// In en, this message translates to:
  /// **'Started at'**
  String get habitActualStart;

  /// No description provided for @habitActualEnd.
  ///
  /// In en, this message translates to:
  /// **'Ended at'**
  String get habitActualEnd;

  /// No description provided for @habitActualDuration.
  ///
  /// In en, this message translates to:
  /// **'Actual duration'**
  String get habitActualDuration;

  /// No description provided for @habitFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get habitFrequency;

  /// No description provided for @habitFrequencyDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get habitFrequencyDaily;

  /// No description provided for @habitFrequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'Specific days'**
  String get habitFrequencyWeekly;

  /// No description provided for @habitFrequencyCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get habitFrequencyCustom;

  /// No description provided for @habitArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive this habit'**
  String get habitArchive;

  /// No description provided for @habitDomain.
  ///
  /// In en, this message translates to:
  /// **'Domain'**
  String get habitDomain;

  /// No description provided for @habitSelectDomain.
  ///
  /// In en, this message translates to:
  /// **'Select a domain'**
  String get habitSelectDomain;

  /// No description provided for @habitChecked.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get habitChecked;

  /// No description provided for @habitUnchecked.
  ///
  /// In en, this message translates to:
  /// **'Unchecked'**
  String get habitUnchecked;

  /// No description provided for @habitBackdateLimit.
  ///
  /// In en, this message translates to:
  /// **'You can only backdate up to 7 days.'**
  String get habitBackdateLimit;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count}d'**
  String streakDays(int count);

  /// No description provided for @streakBest.
  ///
  /// In en, this message translates to:
  /// **'Best: {count}d'**
  String streakBest(int count);

  /// No description provided for @streakFreezeActive.
  ///
  /// In en, this message translates to:
  /// **'Freeze active'**
  String get streakFreezeActive;

  /// No description provided for @streakFreezeUsed.
  ///
  /// In en, this message translates to:
  /// **'Freeze used'**
  String get streakFreezeUsed;

  /// No description provided for @streakFreezeAvailable.
  ///
  /// In en, this message translates to:
  /// **'1 freeze available per week'**
  String get streakFreezeAvailable;

  /// No description provided for @streakDetail.
  ///
  /// In en, this message translates to:
  /// **'Streak Detail'**
  String get streakDetail;

  /// No description provided for @streakFreeze.
  ///
  /// In en, this message translates to:
  /// **'Streak Freeze'**
  String get streakFreeze;

  /// No description provided for @streakFreezeDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically preserves your streak if you miss one day per week.'**
  String get streakFreezeDescription;

  /// No description provided for @streakFreezeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Streak freeze enabled'**
  String get streakFreezeEnabled;

  /// No description provided for @counterTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Counter'**
  String get counterTitle;

  /// No description provided for @counterEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Data Yet'**
  String get counterEmptyTitle;

  /// No description provided for @counterEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Check off habits to see your time per domain.'**
  String get counterEmptyDescription;

  /// No description provided for @counterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get counterThisWeek;

  /// No description provided for @counterLastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get counterLastWeek;

  /// No description provided for @counterTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get counterTotal;

  /// No description provided for @counterHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String counterHours(int hours, int minutes);

  /// No description provided for @counterDelta.
  ///
  /// In en, this message translates to:
  /// **'{sign}{hours}h {minutes}m vs last week'**
  String counterDelta(String sign, int hours, int minutes);

  /// No description provided for @counterPerHabit.
  ///
  /// In en, this message translates to:
  /// **'{minutes}min × {days}d'**
  String counterPerHabit(int minutes, int days);

  /// No description provided for @todayEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No habits yet'**
  String get todayEmptyTitle;

  /// No description provided for @todayEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first habit!'**
  String get todayEmptySubtitle;

  /// No description provided for @todayGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning ☀️'**
  String get todayGreetingMorning;

  /// No description provided for @todayGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Keep going 💪'**
  String get todayGreetingAfternoon;

  /// No description provided for @todayGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Well done today 🌙'**
  String get todayGreetingEvening;

  /// No description provided for @todayHabitsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All done!} =1{1 habit remaining} other{{count} habits remaining}}'**
  String todayHabitsRemaining(int count);

  /// No description provided for @todayProgress.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} habits done'**
  String todayProgress(int done, int total);

  /// No description provided for @todayNoHabits.
  ///
  /// In en, this message translates to:
  /// **'No habits for today'**
  String get todayNoHabits;

  /// No description provided for @todayCounterSummary.
  ///
  /// In en, this message translates to:
  /// **'This week: {hours}h {minutes}m'**
  String todayCounterSummary(int hours, int minutes);

  /// No description provided for @todaySectionMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get todaySectionMorning;

  /// No description provided for @todaySectionAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get todaySectionAfternoon;

  /// No description provided for @todaySectionEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get todaySectionEvening;

  /// No description provided for @todaySectionAnytime.
  ///
  /// In en, this message translates to:
  /// **'Anytime'**
  String get todaySectionAnytime;

  /// No description provided for @bilanTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get bilanTitle;

  /// No description provided for @bilanReady.
  ///
  /// In en, this message translates to:
  /// **'📊 Your summary is ready!'**
  String get bilanReady;

  /// No description provided for @bilanShare.
  ///
  /// In en, this message translates to:
  /// **'Share my summary'**
  String get bilanShare;

  /// No description provided for @bilanCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion rate'**
  String get bilanCompletionRate;

  /// No description provided for @bilanTopHabit.
  ///
  /// In en, this message translates to:
  /// **'Top habit'**
  String get bilanTopHabit;

  /// No description provided for @bilanLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest streak'**
  String get bilanLongestStreak;

  /// No description provided for @bilanFirstWeek.
  ///
  /// In en, this message translates to:
  /// **'This is your first week — no comparison yet. Keep going!'**
  String get bilanFirstWeek;

  /// No description provided for @bilanDomainBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Domain breakdown'**
  String get bilanDomainBreakdown;

  /// No description provided for @bilanWeekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String bilanWeekOf(String date);

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get navHabits;

  /// No description provided for @navCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get navCounter;

  /// No description provided for @todayDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get todayDone;

  /// No description provided for @todayRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get todayRemaining;

  /// No description provided for @profileCompletion.
  ///
  /// In en, this message translates to:
  /// **'Profile Completion'**
  String get profileCompletion;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @counterTotalWithTime.
  ///
  /// In en, this message translates to:
  /// **'Total: {time}'**
  String counterTotalWithTime(String time);

  /// No description provided for @counterDeltaVsLastWeek.
  ///
  /// In en, this message translates to:
  /// **'{delta} vs last week'**
  String counterDeltaVsLastWeek(String delta);

  /// No description provided for @bilanViewSummary.
  ///
  /// In en, this message translates to:
  /// **'View summary →'**
  String get bilanViewSummary;

  /// No description provided for @bilanHighlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get bilanHighlights;

  /// No description provided for @bilanTotalTime.
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get bilanTotalTime;

  /// No description provided for @bilanNoDataThisWeek.
  ///
  /// In en, this message translates to:
  /// **'No data this week.'**
  String get bilanNoDataThisWeek;

  /// No description provided for @bilanWeeklyReady.
  ///
  /// In en, this message translates to:
  /// **'Your weekly summary is ready!'**
  String get bilanWeeklyReady;

  /// No description provided for @habitNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: Meditate'**
  String get habitNameHint;

  /// No description provided for @habitDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional description...'**
  String get habitDescriptionHint;

  /// No description provided for @minuteShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minuteShort;

  /// No description provided for @domainsReorderHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder, tap to edit'**
  String get domainsReorderHint;

  /// No description provided for @domainEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Domain'**
  String get domainEdit;

  /// No description provided for @domainArchiveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive \"{name}\"?'**
  String domainArchiveConfirmTitle(String name);

  /// No description provided for @domainArchiveConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This domain will be hidden but not deleted. You can restore it.'**
  String get domainArchiveConfirmMessage;

  /// No description provided for @streakConsecutiveDays.
  ///
  /// In en, this message translates to:
  /// **'{count} consecutive days'**
  String streakConsecutiveDays(int count);

  /// No description provided for @streakFreezeUsedCount.
  ///
  /// In en, this message translates to:
  /// **'Freeze used {count} times'**
  String streakFreezeUsedCount(int count);

  /// No description provided for @streakFreezeRule.
  ///
  /// In en, this message translates to:
  /// **'Rule: 1 freeze max per 7-day period'**
  String get streakFreezeRule;

  /// No description provided for @errorExportData.
  ///
  /// In en, this message translates to:
  /// **'Error during export: {error}'**
  String errorExportData(String error);

  /// No description provided for @errorLoadingImage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load image'**
  String get errorLoadingImage;

  /// No description provided for @avatarTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get avatarTakePhoto;

  /// No description provided for @avatarChooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get avatarChooseFromGallery;

  /// No description provided for @avatarRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get avatarRemovePhoto;

  /// No description provided for @passwordResetSentMessage.
  ///
  /// In en, this message translates to:
  /// **'We sent an email to {email} with instructions to reset your password.'**
  String passwordResetSentMessage(String email);

  /// No description provided for @semanticsCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get semanticsCompleted;

  /// No description provided for @semanticsNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'not completed'**
  String get semanticsNotCompleted;

  /// No description provided for @archivedCount.
  ///
  /// In en, this message translates to:
  /// **'Archived ({count})'**
  String archivedCount(int count);

  /// No description provided for @domainFormIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get domainFormIcon;

  /// No description provided for @domainFormName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get domainFormName;

  /// No description provided for @domainFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: Health'**
  String get domainFormNameHint;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @todayDaySummary.
  ///
  /// In en, this message translates to:
  /// **'📊 Today'**
  String get todayDaySummary;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @agreeToTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeToTermsPrefix;

  /// No description provided for @defaultDomainHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get defaultDomainHealth;

  /// No description provided for @defaultDomainWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get defaultDomainWork;

  /// No description provided for @defaultDomainRelationships.
  ///
  /// In en, this message translates to:
  /// **'Relationships'**
  String get defaultDomainRelationships;

  /// No description provided for @defaultDomainFinances.
  ///
  /// In en, this message translates to:
  /// **'Finances'**
  String get defaultDomainFinances;

  /// No description provided for @defaultDomainPersonalDev.
  ///
  /// In en, this message translates to:
  /// **'Personal Development'**
  String get defaultDomainPersonalDev;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @timeAgoJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeAgoJustNow;

  /// No description provided for @timeAgoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String timeAgoMinutes(int count);

  /// No description provided for @timeAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String timeAgoHours(int count);

  /// No description provided for @timeAgoDays.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String timeAgoDays(int count);

  /// No description provided for @dialogDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get dialogDeleteAccountTitle;

  /// No description provided for @dialogDeleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get dialogDeleteAccountMessage;

  /// No description provided for @dialogDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialogDeleteAccountConfirm;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get passwordStrengthMedium;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @counterPreviousWeek.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get counterPreviousWeek;

  /// No description provided for @counterNextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get counterNextWeek;

  /// No description provided for @searchHabits.
  ///
  /// In en, this message translates to:
  /// **'Search habits...'**
  String get searchHabits;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActionsTitle;

  /// No description provided for @editHabit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editHabit;

  /// No description provided for @archiveHabit.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveHabit;

  /// No description provided for @archivedLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} (archived)'**
  String archivedLabel(String name);

  /// No description provided for @notifHabitReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'⏰ {habitName}'**
  String notifHabitReminderTitle(String habitName);

  /// No description provided for @notifHabitReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Time for your habit!'**
  String get notifHabitReminderBody;

  /// No description provided for @notifWeeklyBilanTitle.
  ///
  /// In en, this message translates to:
  /// **'📊 Weekly review'**
  String get notifWeeklyBilanTitle;

  /// No description provided for @notifWeeklyBilanBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s Sunday! Review your week.'**
  String get notifWeeklyBilanBody;

  /// No description provided for @notifChannelReminders.
  ///
  /// In en, this message translates to:
  /// **'Habit reminders'**
  String get notifChannelReminders;

  /// No description provided for @notifChannelRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders for your habits'**
  String get notifChannelRemindersDesc;

  /// No description provided for @notifChannelStreaks.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get notifChannelStreaks;

  /// No description provided for @notifChannelStreaksDesc.
  ///
  /// In en, this message translates to:
  /// **'Streak and achievement notifications'**
  String get notifChannelStreaksDesc;

  /// No description provided for @notifChannelBilan.
  ///
  /// In en, this message translates to:
  /// **'Weekly review'**
  String get notifChannelBilan;

  /// No description provided for @notifChannelBilanDesc.
  ///
  /// In en, this message translates to:
  /// **'Weekly review reminder'**
  String get notifChannelBilanDesc;

  /// No description provided for @celebrationMicroDone.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get celebrationMicroDone;

  /// No description provided for @celebrationMicroNice.
  ///
  /// In en, this message translates to:
  /// **'Nice!'**
  String get celebrationMicroNice;

  /// No description provided for @celebrationMicroChecked.
  ///
  /// In en, this message translates to:
  /// **'Checked!'**
  String get celebrationMicroChecked;

  /// No description provided for @celebrationMicroSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved!'**
  String get celebrationMicroSaved;

  /// No description provided for @celebrationMicroGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get celebrationMicroGotIt;

  /// No description provided for @celebrationMediumStreak.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak — keep it up!'**
  String celebrationMediumStreak(int count);

  /// No description provided for @celebrationMediumWeeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal reached!'**
  String get celebrationMediumWeeklyGoal;

  /// No description provided for @celebrationMediumProgress.
  ///
  /// In en, this message translates to:
  /// **'Great progress — you\'re at {percent}%!'**
  String celebrationMediumProgress(int percent);

  /// No description provided for @celebrationMediumConsistency.
  ///
  /// In en, this message translates to:
  /// **'You\'re building consistency!'**
  String get celebrationMediumConsistency;

  /// No description provided for @celebrationMajorMonthStreak.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak — incredible!'**
  String celebrationMajorMonthStreak(int count);

  /// No description provided for @celebrationMajorGoalComplete.
  ///
  /// In en, this message translates to:
  /// **'Goal complete — well done!'**
  String get celebrationMajorGoalComplete;

  /// No description provided for @celebrationMajorMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone unlocked!'**
  String get celebrationMajorMilestone;

  /// No description provided for @celebrationMajor100Days.
  ///
  /// In en, this message translates to:
  /// **'100 days — legendary!'**
  String get celebrationMajor100Days;

  /// No description provided for @encouragementKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going, you\'re doing great!'**
  String get encouragementKeepGoing;

  /// No description provided for @encouragementAlmostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there!'**
  String get encouragementAlmostThere;

  /// No description provided for @encouragementSmallSteps.
  ///
  /// In en, this message translates to:
  /// **'Small steps lead to big changes.'**
  String get encouragementSmallSteps;

  /// No description provided for @encouragementProud.
  ///
  /// In en, this message translates to:
  /// **'You should be proud!'**
  String get encouragementProud;

  /// No description provided for @encouragementComeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back — let\'s pick up where you left off.'**
  String get encouragementComeBack;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
