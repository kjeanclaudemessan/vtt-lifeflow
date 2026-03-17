# Content Rules — Le Langage de l'App

> **Ce fichier définit TOUT ce que l'app "dit" à l'utilisateur.**
> Textes, labels, messages, notifications, placeholders, erreurs, vides, célébrations.
> L'IA le lit avant de rédiger tout texte visible dans l'interface.
>
> **Principe** : Chaque mot affiché est un choix de design. Un texte maladroit
> casse l'expérience autant qu'un mauvais layout.
>
> **Dépend de :** product-soul.md (identité), experience-architecture.md (contexte émotionnel)

---

## I. Ton et Voix

### L'app parle comme un ami compétent. Pas comme un robot. Pas comme un coach LinkedIn.

```
L'APP EST :                         L'APP N'EST PAS :
  Calme mais pas froide               Un chatbot qui dit "Hey !"
  Encourageante mais pas infantile     Un coach qui dit "Tu peux le faire !"
  Directe mais pas sèche              Un formulaire administratif
  Précise mais pas technique           Un manuel d'utilisation
  Humble mais pas excusée              Une marque qui s'excuse de tout ("Oups !")
```

### Personnalité en une phrase :

> L'app parle comme un **ami organisé** qui te rappelle les choses importantes
> sans te juger, et qui sait valoriser tes efforts sans en faire trop.

### Matrice de ton selon le contexte :

```
CONTEXTE              TON                     EXEMPLE
─────────────────────────────────────────────────────────────
Premier lancement     Accueillant, sobre      "Bienvenue. Commençons."
Action quotidienne    Neutre, efficace        "Habitude ajoutée"
Progression           Positif, factuel        "12 jours consécutifs"
Milestone             Chaleureux, spécifique  "30 jours de méditation. Impressionnant."
Erreur technique      Honnête, orienté aide   "Impossible de charger. Vérifier la connexion."
Retour après absence  Neutre, positif         "Bon retour. 47 habitudes complétées au total."
Notification          Utile, court            "Routine du soir dans 15 min"
Vide / empty state    Invitant, pas accusant  "Espace libre pour tes premières habitudes"
Suppression           Factuel, réversible     "Supprimé. Annuler ?"
```

---

## II. Règles i18n (internationalisation)

### Convention de Clés

```
FORMAT : module.section.element.qualifier

EXEMPLES :
  habits.home.title              → "Mes habitudes"
  habits.home.empty_title        → "Espace libre pour tes habitudes"
  habits.home.empty_description  → "Commence avec un template ou crée la tienne"
  habits.detail.streak_label     → "Jours consécutifs"
  habits.create.name_hint        → "Nom de l'habitude"
  common.actions.save             → "Enregistrer"
  common.actions.cancel           → "Annuler"
  common.actions.delete           → "Supprimer"
  common.actions.undo             → "Annuler"
  common.errors.network           → "Connexion perdue"
  common.errors.generic           → "Une erreur est survenue"
```

### Hiérarchie des fichiers ARB

```
lib/l10n/
  app_fr.arb          # Français (langue primaire)
  app_en.arb          # Anglais
  app_[locale].arb    # Autres langues

RÈGLES :
  1. La langue primaire est TOUJOURS écrite en premier (fr ou en selon le produit)
  2. Aucun texte hardcodé JAMAIS dans le code Flutter. Zéro exception.
  3. Les clés sont descriptives, pas abrégées (pas "hm_ttl", oui "habits.home.title")
  4. Pluralisation : utiliser les ICU Message Format (one/other, pas de if/else)
  5. Paramètres : {count}, {name}, {date} — pas de concaténation de strings
```

### Pluralisation (ICU)

```json
"habits_completed": "{count, plural, =0{Aucune habitude complétée} =1{1 habitude complétée} other{{count} habitudes complétées}}"
```

### Textes dynamiques avec paramètres

```json
"streak_message": "{count} jours consécutifs",
"welcome_back": "Bon retour. {total} habitudes complétées au total.",
"morning_greeting": "Bonne journée ! {count} habitudes aujourd'hui."
```

---

## III. Textes par Contexte

### Titres d'écran (AppBar)

```
RÈGLE : Court. 1-3 mots. Pas de phrase.
EXEMPLES :
  ✓ "Habitudes"            ✗ "Mes habitudes quotidiennes"
  ✓ "Profil"               ✗ "Mon profil utilisateur"
  ✓ "Routine du soir"      ✗ "Votre routine du soir programmée"
  ✓ "Statistiques"         ✗ "Vos statistiques détaillées"
```

### Labels de boutons

```
RÈGLE : Verbe + objet (sauf actions universelles). Max 3 mots.
EXEMPLES :
  ✓ "Ajouter habitude"     ✗ "Cliquez ici pour ajouter"
  ✓ "Enregistrer"          ✗ "Sauvegarder les modifications"
  ✓ "Commencer"            ✗ "Commencer maintenant !"
  ✓ "Suivant"              ✗ "Passer à l'étape suivante"

BOUTONS DESTRUCTIFS :
  ✓ "Supprimer"            — (rouge, sans exclamation)
  ✓ "Se déconnecter"
  JAMAIS : "Êtes-vous sûr ?" → Utiliser undo snackbar à la place
```

### Messages vides (Empty States)

```
RÈGLE : L'empty state est une INVITATION, pas un constat d'échec.

STRUCTURE :
  [Illustration douce / icône]
  Titre : Invitation positive (pas "Rien ici")
  Description : Explication + ce que l'utilisateur peut faire
  CTA : Bouton pour commencer

EXEMPLES PAR CONTEXTE :

First-run (jamais utilisé) :
  ✓ Titre : "Tes habitudes t'attendent"
  ✓ Description : "Commence avec un template populaire ou crée les tiennes"
  ✓ CTA : "Explorer les templates"
  ✗ Titre : "Aucune habitude"
  ✗ Description : "Vous n'avez pas encore créé d'habitudes"

Cleared (tout fait) :
  ✓ Titre : "Tout est fait pour aujourd'hui 🎯"
  ✓ Description : "Repose-toi, tu reprends demain"
  ✗ Titre : "Liste vide"

Recherche sans résultat :
  ✓ "Aucun résultat pour '{query}'"
  ✓ CTA : "Modifier la recherche"
  ✗ "0 résultats trouvés"
```

### Messages d'erreur

```
RÈGLE : Honnête + Orienté solution. Pas de jargon technique.

STRUCTURE :
  QUOI s'est passé + QUOI faire

EXEMPLES :
  Réseau :
    ✓ "Connexion perdue. Vérifier le Wi-Fi et réessayer."
    ✗ "Error: NetworkException - timeout after 30000ms"
    ✗ "Oups ! Quelque chose s'est mal passé"
  
  Serveur :
    ✓ "Service temporairement indisponible. Réessayer dans quelques minutes."
    ✗ "500 Internal Server Error"
  
  Validation :
    ✓ "Le nom est requis" (sous le champ, en rouge)
    ✗ "Veuillez remplir tous les champs obligatoires" (en haut, vague)
  
  Permission :
    ✓ "LifeFlow a besoin d'accéder aux notifications pour te rappeler tes routines."
    ✗ "L'application nécessite les permissions de notification"

INTERDITS ABSOLUS :
  ✗ "Oups !"
  ✗ "Quelque chose s'est mal passé"  (vague)
  ✗ "Erreur inattendue"              (tout est inattendu pour l'utilisateur)
  ✗ Stack traces ou codes techniques
  ✗ Blâmer l'utilisateur ("Vous avez entré un email invalide")
    → Préférer : "Format d'email incorrect" (factuel, pas accusateur)
```

### Messages de félicitation / célébration

```
RÈGLE : Spécifique + Proportionnel. Pas de "Bravo !" sans contexte.

PROPORTIONNALITÉ :
  Tier 1 (micro) — Action quotidienne :
    → Pas de texte visible. Feedback tactile/visuel suffit.
  
  Tier 2 (midi) — Milestone court :
    → "7 jours consécutifs 🔥"  (bref, factuel)
    → "Routine terminée"
  
  Tier 3 (macro) — Milestone significatif :
    → "30 jours de méditation. Impressionnant."
    → "Objectif atteint : 5km de course"
  
  Tier 4 (méga) — Accomplissement rare :
    → "100 jours. Cent jours. Ce n'est pas un hasard, c'est de la constance."
    → Message unique, JAMAIS réutilisé ailleurs

INTERDITS :
  ✗ "Bravo !" seul (générique, vide de sens)
  ✗ "Tu es génial !" (l'app n'est pas un cheerleader)
  ✗ "Continue comme ça !" (injonction déguisée)
  ✗ Emojis excessifs (1 par message max, et seulement si il ajoute du sens)
```

### Notifications push

```
RÈGLE : Chaque notification doit JUSTIFIER son interruption.
        Si l'utilisateur peut vivre sans, ne pas l'envoyer.

STRUCTURE :
  Titre : Contexte court (nom de la routine, type)
  Body : Info utile + action implicite

EXEMPLES :
  ✓ Titre : "Routine du soir"
    Body : "3 habitudes en attente. 15 minutes estimées."
  
  ✓ Titre : "Bilan hebdomadaire"
    Body : "Semaine à 78%. Voir le détail."
  
  ✗ Titre : "N'oubliez pas !"
    Body : "Vous avez des habitudes à compléter"
    → Culpabilisant, vague, pas utile

FRÉQUENCE :
  - Max 3 notifications/jour (rappels routines + 1 bilan)
  - 0 notification après 22h (mode REPOS)
  - L'utilisateur contrôle TOUT dans les settings
  - Si l'utilisateur a tout fait → pas de notification
```

---

## IV. Icônes et Visuels

### Convention d'icônes

```
BIBLIOTHÈQUE : LucideIcons exclusivement (cohérence design)

MAPPING PAR CONCEPT :
  Habitudes       → lucide.repeat / lucide.check_circle
  Routines        → lucide.list_checks / lucide.clock
  Domaines de vie → lucide.compass / lucide.layers
  Profil          → lucide.user
  Settings        → lucide.settings
  Stats           → lucide.bar_chart_3 / lucide.trending_up
  Ajout           → lucide.plus
  Retour          → lucide.arrow_left
  Suppression     → lucide.trash_2
  Édition         → lucide.edit_3
  Recherche       → lucide.search
  Notification    → lucide.bell
  Streak/Feu      → lucide.flame
  Partage         → lucide.share_2

RÈGLES :
  - Chaque icône est accompagnée d'un label SAUF dans l'AppBar (+ tooltip)
  - Taille standard : 24dp (icônes de contenu), 20dp (icônes de navigation)
  - Couleur : AppColors.icon (neutre) ou AppColors.primary (action/actif)
```

---

## V. Seed Data et Contenu Pré-rempli

### Pourquoi du seed data ?

```
L'écran vide est l'ENNEMI de l'onboarding. Le seed data élimine le vide.
L'utilisateur voit de la valeur AVANT de fournir des données.
```

### Règles de seed data

```
1. CULTURELLEMENT NEUTRE
   Les exemples doivent fonctionner à Paris, Tokyo, Lagos, São Paulo et New York.
   ✓ "Méditation 10 min", "Lire 20 pages", "Marche 30 min", "Boire 2L d'eau"
   ✗ Référence à une cuisine locale, une religion, une saison spécifique
   
2. UNIVERSELLEMENT DÉSIRABLE
   Les habitudes/templates proposées doivent être des aspirations partagées.
   ✓ Santé, apprentissage, exercice, créativité, connexion sociale
   ✗ Niche, controversé, culturellement marqué

3. TEMPLATES PAR CATÉGORIE
   Les templates sont regroupés par domaine de vie :
   - Santé & Bien-être : hydratation, sommeil, exercice, méditation
   - Productivité : deep work, planification, review
   - Relations : appeler un proche, gratitude, quality time
   - Apprentissage : lecture, pratique d'une compétence, journaling
   - Finance : suivi dépenses, épargne, review budget

4. RÉALISTE
   Les templates proposent des PETITS premiers pas, pas des objectifs intimidants.
   ✓ "Méditation 5 min" (atteignable)
   ✗ "Méditation 1h" (décourageant pour un débutant)
   ✓ "Lire 10 pages"
   ✗ "Lire 1 livre par semaine"

5. MODIFIABLE
   Chaque template est un POINT DE DÉPART. L'utilisateur peut tout modifier.
   L'app dit : "Adapte ces suggestions à ton rythme"
```

---

## VI. Conventions de Format

### Dates et heures

```
AFFICHAGE :
  Aujourd'hui    → "Aujourd'hui" (pas la date)
  Hier           → "Hier"
  Cette semaine  → "Lundi", "Mardi" (nom du jour)
  Plus ancien    → "12 mars" (sans l'année si c'est l'année courante)
  Autre année    → "12 mars 2025"
  
HEURES :
  Format 24h ou 12h selon la locale du device (pas hardcodé)
  Durées : "2h30", "45 min", "5 min" (pas "2 heures et 30 minutes")

RELATIF :
  < 1 min   → "À l'instant"
  < 1 heure → "il y a 23 min"
  < 24h     → "il y a 3h"
  > 24h     → Date absolue
```

### Nombres et métriques

```
GRANDS NOMBRES :
  1 000     → "1 000" (espace insécable, pas de virgule)
  1 000 000 → "1M" (abrégé au-delà du million)

POURCENTAGES :
  Arrondir à l'entier : "72%" (pas "72.3%")
  Exception : si la précision a du sens (finance), garder 1 décimale

COMPTEURS :
  0 → Traitement spécial (empty state, pas juste "0 habitudes")
  1 → Singulier ("1 habitude")
  2+ → Pluriel ("3 habitudes")
  Format ICU pour les pluriels (voir section i18n)
```

---

## VII. Les "Jamais" du Contenu

```
✗ "Oups" / "Oops"                 → L'app est sérieuse, pas maladroite
✗ "Hey !" / "Salut !"             → L'app est un outil, pas un ami sur Instagram
✗ "N'oubliez pas !"               → Culpabilisant
✗ "Veuillez" dans l'UI            → Trop formel pour mobile
✗ Points d'exclamation multiples   → "Bravo !!!" = non. "Bravo." = oui
✗ MAJUSCULES pour emphasis         → Utiliser le bold à la place
✗ Texte placeholder "Lorem ipsum"  → Chaque texte est final ou marqué TODO
✗ Abréviations non universelles    → "Hab." pour "Habitude" = non
✗ Jargon technique visible         → "Synchronisation", "Cache vidé" = non
✗ Double négation                  → "Ne voulez-vous pas ne pas..." = cauchemar
✗ Condescendance                   → "C'est facile !" (ça ne l'est peut-être pas pour lui)
✗ Gendered language (en anglais)   → "his/her" → "their"
```

---

*Créé le : 2026-03-17*
*Dernière mise à jour : 2026-03-17*
*Dépend de : product-soul.md, experience-architecture.md*
