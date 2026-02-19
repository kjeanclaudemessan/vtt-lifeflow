// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'VTT Flutter Template';

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
  String get resetPassword => 'Réinitialiser le mot de passe';

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
  String get createAccount => 'Créer un compte';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ?';

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
  String get errorInvalidCredentials => 'Email ou mot de passe invalide';

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
  String get successLoggedIn => 'Connexion réussie';

  @override
  String get successLoggedOut => 'Déconnexion réussie';

  @override
  String get successRegistered => 'Compte créé avec succès';

  @override
  String get successPasswordReset => 'Email de réinitialisation envoyé';

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
  String get onboardingSlide1Title => 'Bienvenue';

  @override
  String get onboardingSlide1Description =>
      'Découvrez toutes les fonctionnalités de notre application conçue pour vous simplifier la vie.';

  @override
  String get onboardingSlide2Title => 'Restez Connecté';

  @override
  String get onboardingSlide2Description =>
      'Recevez des mises à jour et notifications en temps réel pour ne rien manquer d\'important.';

  @override
  String get onboardingSlide3Title => 'Commencez';

  @override
  String get onboardingSlide3Description =>
      'Créez votre compte et démarrez votre aventure avec nous dès aujourd\'hui.';

  @override
  String get onboardingDomainsTitle => 'Choisis tes domaines de vie';

  @override
  String get onboardingDomainsDescription =>
      'Sélectionne les domaines que tu veux tracker. Tu pourras en ajouter plus tard.';

  @override
  String get onboardingDomainsMinimum => 'Choisis au moins 1 domaine';

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String welcomeBackUser(String name) {
    return 'Bon retour, $name !';
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
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

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
  String get notificationsEmptyTitle => 'Aucune notification';

  @override
  String get notificationsEmptyDescription =>
      'Vous n\'avez pas encore de notifications. Nous vous informerons quand quelque chose de nouveau arrivera.';

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
  String get domainsTitle => 'Domaines de vie';

  @override
  String get domainsEmptyTitle => 'Aucun domaine';

  @override
  String get domainsEmptyDescription =>
      'Ajoutez votre premier domaine de vie pour organiser vos habitudes.';

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
      'Vous devez garder au moins un domaine actif.';

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
  String get habitsEmptyTitle => 'Aucune habitude';

  @override
  String get habitsEmptyDescription =>
      'Créez votre première habitude pour commencer à tracker votre temps.';

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
  String get todayEmptyTitle => 'Pas encore d\'habitudes';

  @override
  String get todayEmptySubtitle =>
      'Commence par ajouter ta première habitude !';

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
}
