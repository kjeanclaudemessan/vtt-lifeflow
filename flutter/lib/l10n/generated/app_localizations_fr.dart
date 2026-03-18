// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'LifeFlow';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get done => 'Terminé';

  @override
  String get retry => 'Réessayer';

  @override
  String get continue_ => 'Continuer';

  @override
  String get skip => 'Passer';

  @override
  String get submit => 'Soumettre';

  @override
  String get search => 'Rechercher';

  @override
  String get clear => 'Effacer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get loading => 'Chargement...';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get learnMore => 'En savoir plus';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get or => 'ou';

  @override
  String get and => 'et';

  @override
  String get with_ => 'avec';

  @override
  String get from => 'de';

  @override
  String get to => 'à';

  @override
  String get ofWord => 'de';

  @override
  String get in_ => 'dans';

  @override
  String get at => 'à';

  @override
  String get on => 'sur';

  @override
  String get by => 'par';

  @override
  String get for_ => 'pour';

  @override
  String get all => 'Tout';

  @override
  String get none => 'Aucun';

  @override
  String get more => 'Plus';

  @override
  String get less => 'Moins';

  @override
  String get other => 'Autre';

  @override
  String get optional => 'Optionnel';

  @override
  String get required => 'Requis';

  @override
  String get empty => 'Vide';

  @override
  String get unknown => 'Inconnu';

  @override
  String get notAvailable => 'Non disponible';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get login => 'Se connecter';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get register => 'S\'inscrire';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get email => 'Email';

  @override
  String get emailAddress => 'Adresse email';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetPassword => 'Ça arrive à tout le monde';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get fullName => 'Nom complet';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get verificationCode => 'Code de vérification';

  @override
  String get enterVerificationCode => 'Entrez le code de vérification';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String codeExpiresIn(String time) {
    return 'Le code expire dans $time';
  }

  @override
  String get createAccount => 'On fait connaissance ?';

  @override
  String get createAccountAction => 'Créer mon compte';

  @override
  String get alreadyHaveAccount => 'Déjà parmi nous ?';

  @override
  String get dontHaveAccount => 'Première fois ici ?';

  @override
  String get authLoginSubtitle => 'Entre chez toi';

  @override
  String get authRegisterSubtitle => 'Ça prend 30 secondes';

  @override
  String get authForgotSubtitle => 'On t\'envoie un lien de secours';

  @override
  String get loginWithEmail => 'Se connecter avec email';

  @override
  String get loginWithPhone => 'Se connecter avec téléphone';

  @override
  String get loginWithGoogle => 'Continuer avec Google';

  @override
  String get loginWithApple => 'Continuer avec Apple';

  @override
  String get loginWithGithub => 'Continuer avec GitHub';

  @override
  String get termsAndConditions => 'Conditions générales';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String agreeToTerms(String terms, String privacy) {
    return 'J\'accepte les $terms et la $privacy';
  }

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get staySignedIn => 'Rester connecté';

  @override
  String get fieldRequired => 'Ce champ est requis';

  @override
  String get emailRequired => 'L\'email est requis';

  @override
  String get emailInvalid => 'Veuillez entrer un email valide';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String passwordTooShort(int min) {
    return 'Le mot de passe doit contenir au moins $min caractères';
  }

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get phoneRequired => 'Le numéro de téléphone est requis';

  @override
  String get phoneInvalid => 'Veuillez entrer un numéro de téléphone valide';

  @override
  String get nameRequired => 'Le nom est requis';

  @override
  String nameTooShort(int min) {
    return 'Le nom doit contenir au moins $min caractères';
  }

  @override
  String get errorOccurred => 'Une erreur s\'est produite';

  @override
  String get errorUnknown => 'Une erreur inconnue s\'est produite';

  @override
  String get errorNetwork =>
      'Erreur réseau. Veuillez vérifier votre connexion.';

  @override
  String get errorServer => 'Erreur serveur. Veuillez réessayer plus tard.';

  @override
  String get errorTimeout => 'La requête a expiré. Veuillez réessayer.';

  @override
  String get errorUnauthorized => 'Non autorisé. Veuillez vous reconnecter.';

  @override
  String get errorForbidden => 'Accès refusé';

  @override
  String get errorNotFound => 'Non trouvé';

  @override
  String get errorInvalidCredentials => 'Email ou mot de passe incorrect';

  @override
  String get errorEmailAlreadyInUse => 'Cet email est déjà utilisé';

  @override
  String get errorWeakPassword => 'Le mot de passe est trop faible';

  @override
  String get errorUserNotFound => 'Utilisateur non trouvé';

  @override
  String get errorTooManyRequests =>
      'Trop de requêtes. Veuillez patienter et réessayer.';

  @override
  String get errorSessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get errorEmailNotConfirmed =>
      'Veuillez confirmer votre email avant de vous connecter';

  @override
  String get errorOtpExpired => 'Le code de vérification a expiré';

  @override
  String get errorUserBanned => 'Ce compte a été suspendu';

  @override
  String get noInternetConnection => 'Pas de connexion internet';

  @override
  String get tryAgainLater => 'Veuillez réessayer plus tard';

  @override
  String get success => 'Succès';

  @override
  String get successSaved => 'Enregistré avec succès';

  @override
  String get successDeleted => 'Supprimé avec succès';

  @override
  String get successUpdated => 'Mis à jour avec succès';

  @override
  String get successSent => 'Envoyé avec succès';

  @override
  String get successCopied => 'Copié dans le presse-papiers';

  @override
  String get successLoggedIn => 'Te voilà !';

  @override
  String get successLoggedOut => 'À bientôt';

  @override
  String get successRegistered => 'Bienvenue parmi nous !';

  @override
  String get successPasswordReset => 'Check ta boîte mail';

  @override
  String get successPasswordChanged => 'Mot de passe modifié avec succès';

  @override
  String get successVerificationSent => 'Code de vérification envoyé';

  @override
  String get dialogConfirmTitle => 'Confirmer';

  @override
  String get dialogConfirmMessage => 'Êtes-vous sûr ?';

  @override
  String get dialogDeleteTitle => 'Supprimer';

  @override
  String get dialogDeleteMessage => 'Êtes-vous sûr de vouloir supprimer ceci ?';

  @override
  String get dialogLogoutTitle => 'Déconnexion';

  @override
  String get dialogLogoutMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get dialogDiscardTitle => 'Abandonner les modifications';

  @override
  String get dialogDiscardMessage =>
      'Êtes-vous sûr de vouloir abandonner vos modifications ?';

  @override
  String get dialogExitTitle => 'Quitter';

  @override
  String get dialogExitMessage => 'Êtes-vous sûr de vouloir quitter ?';

  @override
  String get emptyResults => 'Aucun résultat trouvé';

  @override
  String get emptyData => 'Aucune donnée disponible';

  @override
  String get emptyNotifications => 'Aucune notification';

  @override
  String get emptyMessages => 'Aucun message';

  @override
  String emptySearch(String query) {
    return 'Aucun résultat pour \"$query\"';
  }

  @override
  String get profile => 'Profil';

  @override
  String get myProfile => 'Mon Profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get accountSettings => 'Paramètres du compte';

  @override
  String get personalInfo => 'Informations personnelles';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get notifications => 'Notifications';

  @override
  String get preferences => 'Préférences';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get help => 'Aide';

  @override
  String get support => 'Support';

  @override
  String get feedback => 'Commentaires';

  @override
  String get rateApp => 'Noter l\'application';

  @override
  String get shareApp => 'Partager l\'application';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get tomorrow => 'Demain';

  @override
  String get now => 'Maintenant';

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count minutes',
      one: 'Il y a 1 minute',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count heures',
      one: 'Il y a 1 heure',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count jours',
      one: 'Il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get splashInitializing => 'Initialisation...';

  @override
  String get splashCheckingAuth => 'Vérification de l\'authentification...';

  @override
  String get splashLoading => 'Chargement...';

  @override
  String get splashReady => 'Prêt !';

  @override
  String get splashTagline => 'Construis de meilleures habitudes, chaque jour';

  @override
  String get splashPreparingExperience => 'Préparation de ton expérience...';

  @override
  String get splashAlmostThere => 'Presque prêt...';

  @override
  String get splashFinalTouches => 'Dernières retouches...';

  @override
  String get splashGreetingMorning => 'Bonjour';

  @override
  String get splashGreetingAfternoon => 'Bon après-midi';

  @override
  String get splashGreetingEvening => 'Bonsoir';

  @override
  String get onboardingSlide1Title => 'Ton espace, tes règles';

  @override
  String get onboardingSlide1Description =>
      'Crée tes habitudes, organise ta vie par domaines et suis ta progression à ton rythme.';

  @override
  String get onboardingSlide2Title => 'Chaque minute compte';

  @override
  String get onboardingSlide2Description =>
      'Visualise le temps investi dans chaque domaine. Chaque habitude cochée, ça compte.';

  @override
  String get onboardingSlide3Title => 'Semaine après semaine';

  @override
  String get onboardingSlide3Description =>
      'Reçois ton bilan hebdo, maintiens tes séries et deviens qui tu veux être.';

  @override
  String get onboardingDomainsTitle => 'Choisis tes domaines de vie';

  @override
  String get onboardingDomainsDescription =>
      'Sélectionne les domaines que tu veux tracker. Tu pourras en ajouter plus tard.';

  @override
  String get onboardingDomainsMinimum => 'Choisis au moins 1 domaine';

  @override
  String get welcomeBack => 'Content de te revoir';

  @override
  String welcomeBackUser(String name) {
    return 'Content de te revoir, $name';
  }

  @override
  String get getStarted => 'Commencer';

  @override
  String get letsGo => 'C\'est parti !';

  @override
  String get hello => 'Bonjour';

  @override
  String helloUser(String name) {
    return 'Bonjour, $name !';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsLegal => 'Légal';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsPushNotifications => 'Notifications Push';

  @override
  String get settingsEmailNotifications => 'Notifications Email';

  @override
  String get settingsTerms => 'Conditions d\'utilisation';

  @override
  String get settingsPrivacy => 'Politique de confidentialité';

  @override
  String get settingsChangePassword => 'Changer le mot de passe';

  @override
  String get settingsLogout => 'Se déconnecter';

  @override
  String get settingsDeleteAccount => 'Supprimer le compte';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsRateApp => 'Noter l\'application';

  @override
  String get settingsShareApp => 'Partager l\'application';

  @override
  String get settingsSelectTheme => 'Sélectionner le thème';

  @override
  String get settingsSelectLanguage => 'Sélectionner la langue';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeSystemDesc => 'Suivre les paramètres de l\'appareil';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeLightDesc => 'Toujours utiliser le thème clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeDarkDesc => 'Toujours utiliser le thème sombre';

  @override
  String get settingsLanguageEnglish => 'Anglais';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsDeleteAccountConfirm =>
      'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.';

  @override
  String get notificationPreferences => 'Préférences de notification';

  @override
  String get notificationsEmptyTitle => 'Tout est calme';

  @override
  String get notificationsEmptyDescription =>
      'Tes notifications apparaîtront ici.';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get notificationsChannelMarketing => 'Promotions et offres';

  @override
  String get notificationsChannelMarketingDesc =>
      'Recevez des offres spéciales et promotions';

  @override
  String get notificationsChannelOrders => 'Commandes et transactions';

  @override
  String get notificationsChannelOrdersDesc =>
      'Mises à jour sur vos commandes et paiements';

  @override
  String get notificationsChannelReminders => 'Rappels';

  @override
  String get notificationsChannelRemindersDesc =>
      'Rappels et alertes importants';

  @override
  String get notificationsChannelSocial => 'Activité sociale';

  @override
  String get notificationsChannelSocialDesc =>
      'Activité des personnes que vous suivez';

  @override
  String get notificationsChannelStreaks => 'Séries';

  @override
  String get notificationsChannelStreaksDesc =>
      'Notifications quand tu maintiens ou perds une série';

  @override
  String get notificationsChannelBilan => 'Bilan hebdomadaire';

  @override
  String get notificationsChannelBilanDesc =>
      'Reçois ton bilan chaque dimanche';

  @override
  String get notificationsChannelGeneral => 'Général';

  @override
  String get notificationsChannelGeneralDesc =>
      'Mises à jour et informations générales';

  @override
  String get domainsTitle => 'Domaines de vie';

  @override
  String get domainsEmptyTitle => 'Organise ta vie par domaines';

  @override
  String get domainsEmptyDescription =>
      'Crée ton premier domaine pour regrouper tes habitudes.';

  @override
  String get domainAdd => 'Nouveau domaine';

  @override
  String get domainName => 'Nom du domaine';

  @override
  String get domainIcon => 'Icône';

  @override
  String get domainColor => 'Couleur';

  @override
  String get domainArchive => 'Archiver';

  @override
  String get domainUnarchive => 'Désarchiver';

  @override
  String get domainArchived => 'Archivé';

  @override
  String get domainArchivedSection => 'Domaines archivés';

  @override
  String get domainCannotArchiveLast =>
      'Tu dois garder au moins un domaine actif.';

  @override
  String domainHabitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habitudes',
      one: '1 habitude',
      zero: 'Aucune habitude',
    );
    return '$_temp0';
  }

  @override
  String get habitsTitle => 'Habitudes';

  @override
  String get habitsEmptyTitle => 'Prêt à créer ta première habitude ?';

  @override
  String get habitsEmptyDescription =>
      'Crée ta première habitude et commence ton parcours.';

  @override
  String get habitAdd => 'Nouvelle habitude';

  @override
  String get habitEdit => 'Modifier l\'habitude';

  @override
  String get habitName => 'Nom de l\'habitude';

  @override
  String get habitDescription => 'Description (optionnel)';

  @override
  String get habitType => 'Type';

  @override
  String get habitTypeBinary => 'Oui / Non';

  @override
  String get habitTypeQuantitative => 'Quantitative';

  @override
  String get habitTargetValue => 'Valeur cible';

  @override
  String get habitUnit => 'Unité';

  @override
  String get habitEstimatedDuration => 'Durée estimée';

  @override
  String get habitEstimatedDurationHelper =>
      'Ce temps sera compté dans ton compteur';

  @override
  String habitEstimatedDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get habitTimeRange => 'Plage horaire';

  @override
  String get habitEndTimeComputed =>
      'L\'heure de fin est calculée à partir du début + durée';

  @override
  String get habitNotifications => 'Notifications';

  @override
  String get habitReminderOffset => 'Rappel avant l\'heure de début';

  @override
  String get habitReminderAtTime => 'À l\'heure';

  @override
  String get habitReminderBefore => 'avant';

  @override
  String get habitValueComplete => 'Terminé !';

  @override
  String get habitValueSave => 'Enregistrer la valeur';

  @override
  String get habitTimeEditSubtitle => 'Ajuster l\'heure réelle d\'exécution';

  @override
  String get habitActualStart => 'Commencé à';

  @override
  String get habitActualEnd => 'Terminé à';

  @override
  String get habitActualDuration => 'Durée réelle';

  @override
  String get habitFrequency => 'Fréquence';

  @override
  String get habitFrequencyDaily => 'Tous les jours';

  @override
  String get habitFrequencyWeekly => 'Jours spécifiques';

  @override
  String get habitFrequencyCustom => 'Personnalisé';

  @override
  String get habitArchive => 'Archiver cette habitude';

  @override
  String get habitDomain => 'Domaine';

  @override
  String get habitSelectDomain => 'Choisir un domaine';

  @override
  String get habitChecked => 'Fait !';

  @override
  String get habitUnchecked => 'Décochée';

  @override
  String get habitBackdateLimit => 'Vous pouvez antidater jusqu\'à 7 jours.';

  @override
  String streakDays(int count) {
    return '${count}j';
  }

  @override
  String streakBest(int count) {
    return 'Record : ${count}j';
  }

  @override
  String get streakFreezeActive => 'Freeze actif';

  @override
  String get streakFreezeUsed => 'Freeze utilisé';

  @override
  String get streakFreezeAvailable => '1 freeze disponible par semaine';

  @override
  String get streakDetail => 'Détail du streak';

  @override
  String get streakFreeze => 'Streak Freeze';

  @override
  String get streakFreezeDescription =>
      'Préserve automatiquement ton streak si tu rates un jour par semaine.';

  @override
  String get streakFreezeEnabled => 'Streak freeze activé';

  @override
  String get counterTitle => 'Compteur temps';

  @override
  String get counterEmptyTitle => 'Pas encore de données';

  @override
  String get counterEmptyDescription =>
      'Coche tes habitudes pour voir ton temps par domaine.';

  @override
  String get counterThisWeek => 'Cette semaine';

  @override
  String get counterLastWeek => 'Semaine dernière';

  @override
  String get counterTotal => 'Total';

  @override
  String counterHours(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String counterDelta(String sign, int hours, int minutes) {
    return '$sign${hours}h ${minutes}m vs semaine dernière';
  }

  @override
  String counterPerHabit(int minutes, int days) {
    return '${minutes}min × ${days}j';
  }

  @override
  String get todayEmptyTitle => 'Ta journée commence ici';

  @override
  String get todayEmptySubtitle =>
      'Ajoute ta première habitude pour démarrer !';

  @override
  String get todayGreetingMorning => 'Bonjour ☀️';

  @override
  String get todayGreetingAfternoon => 'Continue comme ça 💪';

  @override
  String get todayGreetingEvening => 'Belle journée 🌙';

  @override
  String todayHabitsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habitudes restantes',
      one: '1 habitude restante',
      zero: 'Tout est fait !',
    );
    return '$_temp0';
  }

  @override
  String todayProgress(int done, int total) {
    return '$done/$total habitudes faites';
  }

  @override
  String get todayNoHabits => 'Pas d\'habitudes pour aujourd\'hui';

  @override
  String todayCounterSummary(int hours, int minutes) {
    return 'Cette semaine : ${hours}h ${minutes}m';
  }

  @override
  String get todaySectionMorning => 'Matin';

  @override
  String get todaySectionAfternoon => 'Après-midi';

  @override
  String get todaySectionEvening => 'Soir';

  @override
  String get todaySectionAnytime => 'Sans horaire';

  @override
  String get bilanTitle => 'Bilan hebdomadaire';

  @override
  String get bilanReady => '📊 Ton bilan est prêt !';

  @override
  String get bilanShare => 'Partager mon bilan';

  @override
  String get bilanCompletionRate => 'Taux de complétion';

  @override
  String get bilanTopHabit => 'Habitude star';

  @override
  String get bilanLongestStreak => 'Plus long streak';

  @override
  String get bilanFirstWeek =>
      'C\'est ta première semaine — pas de comparaison encore. Continue !';

  @override
  String get bilanDomainBreakdown => 'Répartition par domaine';

  @override
  String bilanWeekOf(String date) {
    return 'Semaine du $date';
  }

  @override
  String get navToday => 'Aujourd\'hui';

  @override
  String get navHabits => 'Habitudes';

  @override
  String get navCounter => 'Compteur';

  @override
  String get todayDone => 'Faites';

  @override
  String get todayRemaining => 'Restantes';

  @override
  String get profileCompletion => 'Complétion du profil';

  @override
  String get exportData => 'Exporter les données';

  @override
  String counterTotalWithTime(String time) {
    return 'Total : $time';
  }

  @override
  String counterDeltaVsLastWeek(String delta) {
    return '$delta vs sem. dernière';
  }

  @override
  String get bilanViewSummary => 'Voir le bilan →';

  @override
  String get bilanHighlights => 'Points forts';

  @override
  String get bilanTotalTime => 'Temps total';

  @override
  String get bilanNoDataThisWeek => 'Aucune donnée pour cette semaine.';

  @override
  String get bilanWeeklyReady => 'Ton bilan de la semaine est prêt !';

  @override
  String get habitNameHint => 'Ex : Méditer';

  @override
  String get habitDescriptionHint => 'Description optionnelle...';

  @override
  String get minuteShort => 'min';

  @override
  String get domainsReorderHint =>
      'Glissez pour réordonner, appuyez pour modifier';

  @override
  String get domainEdit => 'Modifier le domaine';

  @override
  String domainArchiveConfirmTitle(String name) {
    return 'Archiver \"$name\" ?';
  }

  @override
  String get domainArchiveConfirmMessage =>
      'Ce domaine sera masqué mais pas supprimé. Vous pourrez le restaurer.';

  @override
  String streakConsecutiveDays(int count) {
    return '$count jours consécutifs';
  }

  @override
  String streakFreezeUsedCount(int count) {
    return 'Freeze utilisé $count fois';
  }

  @override
  String get streakFreezeRule => 'Règle : 1 freeze max par période de 7 jours';

  @override
  String errorExportData(String error) {
    return 'Erreur lors de l\'export : $error';
  }

  @override
  String get errorLoadingImage => 'Impossible de charger l\'image';

  @override
  String get avatarTakePhoto => 'Prendre une photo';

  @override
  String get avatarChooseFromGallery => 'Choisir dans la galerie';

  @override
  String get avatarRemovePhoto => 'Supprimer la photo';

  @override
  String passwordResetSentMessage(String email) {
    return 'Un lien t\'attend dans la boîte de $email. Vérifie aussi les spams, on sait jamais.';
  }

  @override
  String get semanticsCompleted => 'complété';

  @override
  String get semanticsNotCompleted => 'non complété';

  @override
  String archivedCount(int count) {
    return 'Archivés ($count)';
  }

  @override
  String get domainFormIcon => 'Icône';

  @override
  String get domainFormName => 'Nom';

  @override
  String get domainFormNameHint => 'Ex : Santé';

  @override
  String get create => 'Créer';

  @override
  String get todayDaySummary => '📊 Aujourd\'hui';

  @override
  String get total => 'Total';

  @override
  String get agreeToTermsPrefix => 'J\'accepte les ';

  @override
  String get defaultDomainHealth => 'Santé';

  @override
  String get defaultDomainWork => 'Travail';

  @override
  String get defaultDomainRelationships => 'Relations';

  @override
  String get defaultDomainFinances => 'Finances';

  @override
  String get defaultDomainPersonalDev => 'Développement personnel';

  @override
  String get emailHint => 'Entrez votre email';

  @override
  String get passwordHint => 'Entrez votre mot de passe';

  @override
  String get timeAgoJustNow => 'À l\'instant';

  @override
  String timeAgoMinutes(int count) {
    return 'il y a $count min';
  }

  @override
  String timeAgoHours(int count) {
    return 'il y a ${count}h';
  }

  @override
  String timeAgoDays(int count) {
    return 'il y a ${count}j';
  }

  @override
  String get dialogDeleteAccountTitle => 'Supprimer le compte';

  @override
  String get dialogDeleteAccountMessage =>
      'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.';

  @override
  String get dialogDeleteAccountConfirm => 'Supprimer';

  @override
  String get passwordStrengthWeak => 'Faible';

  @override
  String get passwordStrengthMedium => 'Moyen';

  @override
  String get passwordStrengthStrong => 'Fort';

  @override
  String get restore => 'Restaurer';

  @override
  String get counterPreviousWeek => 'Semaine précédente';

  @override
  String get counterNextWeek => 'Semaine suivante';

  @override
  String get searchHabits => 'Rechercher des habitudes...';

  @override
  String get quickActionsTitle => 'Actions rapides';

  @override
  String get editHabit => 'Modifier';

  @override
  String get archiveHabit => 'Archiver';

  @override
  String archivedLabel(String name) {
    return '$name (archivé)';
  }

  @override
  String notifHabitReminderTitle(String habitName) {
    return '⏰ $habitName';
  }

  @override
  String get notifHabitReminderBody => 'C\'est l\'heure de ton habitude !';

  @override
  String get notifWeeklyBilanTitle => '📊 Bilan hebdomadaire';

  @override
  String get notifWeeklyBilanBody =>
      'C\'est dimanche ! Fais le point sur ta semaine.';

  @override
  String get notifChannelReminders => 'Rappels d\'habitudes';

  @override
  String get notifChannelRemindersDesc =>
      'Rappels quotidiens pour tes habitudes';

  @override
  String get notifChannelStreaks => 'Séries';

  @override
  String get notifChannelStreaksDesc =>
      'Notifications de séries et accomplissements';

  @override
  String get notifChannelBilan => 'Bilan hebdomadaire';

  @override
  String get notifChannelBilanDesc => 'Rappel pour ton bilan de la semaine';

  @override
  String get celebrationMicroDone => 'Fait !';

  @override
  String get celebrationMicroNice => 'Bien joué !';

  @override
  String get celebrationMicroChecked => 'Coché !';

  @override
  String get celebrationMicroSaved => 'Enregistré !';

  @override
  String get celebrationMicroGotIt => 'C\'est noté !';

  @override
  String celebrationMediumStreak(int count) {
    return 'Série de $count jours — continue !';
  }

  @override
  String get celebrationMediumWeeklyGoal => 'Objectif de la semaine atteint !';

  @override
  String celebrationMediumProgress(int percent) {
    return 'Belle progression — tu es à $percent % !';
  }

  @override
  String get celebrationMediumConsistency => 'Tu deviens régulier !';

  @override
  String celebrationMajorMonthStreak(int count) {
    return 'Série de $count jours — incroyable !';
  }

  @override
  String get celebrationMajorGoalComplete => 'Objectif atteint — bravo !';

  @override
  String get celebrationMajorMilestone => 'Étape franchie !';

  @override
  String get celebrationMajor100Days => '100 jours — légendaire !';

  @override
  String get encouragementKeepGoing => 'Continue, tu assures !';

  @override
  String get encouragementAlmostThere => 'Presque là !';

  @override
  String get encouragementSmallSteps =>
      'Les petits pas mènent aux grands changements.';

  @override
  String get encouragementProud => 'Tu peux être fier de toi !';

  @override
  String get encouragementComeBack =>
      'Content de te revoir — on reprend ensemble ?';
}
