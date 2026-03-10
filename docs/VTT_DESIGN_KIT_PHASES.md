# VTT Design Kit — 53 Phases / ~430 Décisions

> **Date :** 10 Mars 2026
> **Objectif :** Définir LE design system pour 200+ apps Flutter utilisées par des millions de personnes dans le monde entier.
> **Architecture :** Generic Core + Brand Skins + UX Packs (Flow / Pro / Community)
> **Score cible :** 9.5/10

---

## Stratégie de Priorisation

| Mode | Phases | Quand |
|------|--------|-------|
| **MAINTENANT** | 1-23 | Fondation. Avant d'implémenter quoi que ce soit |
| **APRÈS v1** | 24-37 | Affinage. Après le lancement de LifeFlow v1 |
| **AU SCALING** | 38-53 | Quand 100K+ utilisateurs et déploiement des autres apps |

---

## Familles d'Apps identifiées

| Famille | Apps | UX Dominante |
|---------|------|-------------|
| **Flow** (Croissance personnelle) | LifeFlow, SpiritFlow, IronFlow, MindFlow, PresenceFlow, WealthFlow, LingoFlow, CoupleFlow, ReadFlow | Dashboards + Tracking + Graphiques + IA Coach |
| **Pro** (Outils métier) | HustlePro, ForgePro, StockPilot, StyleFlow, EventPro | WhatsApp-first + Saisie vocale + PDF/Documents + Relances |
| **Community** (Plateformes collectives) | ChurchFlow, PrepExam, CareFlow | Multi-rôles + Notifications + Planning |
| **Platform** (Infrastructure) | NEXUS, ChatFlow | Server-driven UI + SDK + API |

---

# PRIORITÉ 1 — FONDATION (Phases 1-23)

---

## Phase 1 : DESIGN PRINCIPLES (Lois suprêmes)

| # | Décision | Question à trancher |
|---|----------|---------------------|
| 1.1 | **Principe #1** | Quel est le principe le plus important qui tranche TOUT ? (ex: "Calme > Flash", "Clarté avant tout") |
| 1.2 | **Principe #2** | 2e principe directeur (ex: "Progressif > Tout d'un coup", "Simple > Complet") |
| 1.3 | **Principe #3** | 3e principe directeur (ex: "Données de l'utilisateur = sacrées") |
| 1.4 | **Principe #4** | 4e principe directeur (ex: "1 écran = 1 action principale") |
| 1.5 | **Principe #5** | 5e principe optionnel (ex: "L'IA aide, l'humain décide") |
| 1.6 | **Application** | Comment ces principes sont-ils utilisés au quotidien ? (checklist dans les PR ? agents IA qui vérifient ?) |

---

## Phase 2 : EMOTIONAL JOURNEY MAP (Carte émotionnelle)

| # | Décision | Question à trancher |
|---|----------|---------------------|
| 2.1 | **Premier lancement** | Quelle émotion exacte ? (Wow ? Curiosité ? Confiance immédiate ?) |
| 2.2 | **Première action** | L'utilisateur crée son premier contenu — il doit ressentir quoi ? (Facilité ? Fierté ?) |
| 2.3 | **Usage quotidien** | Émotion de la routine (Calme productif ? Flow ? Satisfaction ?) |
| 2.4 | **Accomplissement** | Streak, objectif atteint — émotion cible (Fierté ? Joie explosive ? Sérénité ?) |
| 2.5 | **Erreur / échec** | L'app plante ou l'action échoue — émotion cible (Pas grave ? Réassuré ? Guidé ?) |
| 2.6 | **Retour après absence** | L'user revient après 2 semaines — émotion (Bienvenue chaleureux ? Pas de culpabilité ? Motivation douce ?) |
| 2.7 | **Paiement** | Moment de payer — émotion (Confiance ? Valeur évidente ? Pas de regret ?) |
| 2.8 | **Partage social** | Quand l'user partage un résultat — émotion (Fierté ? Appartenance ?) |

---

## Phase 3 : ETHICAL DESIGN & DIGITAL WELLBEING

| # | Décision | Question à trancher |
|---|----------|---------------------|
| 3.1 | **Anti-addiction** | Pas de scroll infini ? Pas de streaks culpabilisants ? Limites d'utilisation ? |
| 3.2 | **Notifications** | Max combien par jour ? Opt-in obligatoire ? Quiet hours respectées ? |
| 3.3 | **Dark patterns interdits** | Liste des patterns bannis : faux compteurs d'urgence, shame buttons ("Non, je ne veux pas m'améliorer"), hidden costs |
| 3.4 | **Transparence données** | L'utilisateur sait exactement quelles données sont collectées et pourquoi ? |
| 3.5 | **Rappels de pause** | Pour les apps type MindFlow, ReadFlow — "Tu utilises l'app depuis 45 min, fais une pause" ? |
| 3.6 | **Respect du temps** | L'app ne crée pas de FOMO artificiel ? Les offres "limitées" sont vraiment limitées ? |
| 3.7 | **Opt-out facile** | Désabonnement, suppression de compte, export de données = maximum 2 taps, jamais caché |
| 3.8 | **Consentement éclairé** | Pas de pré-coché. Pas de mur de texte juridique. Langage clair. |

---

## Phase 4 : IDENTITÉ DE MARQUE (Brand DNA)

| # | Décision | Question à trancher | Options |
|---|----------|---------------------|---------|
| 4.1 | **Personnalité de marque** | Quels 3-5 traits définissent toutes tes apps ? | Ex: Calme + Précis + Premium + Humain + Intelligent |
| 4.2 | **Proposition émotionnelle** | Quelle émotion doit ressentir l'utilisateur en ouvrant une app VTT ? | Confiance ? Sérénité ? Puissance ? Clarté ? |
| 4.3 | **Nom de famille** | Les apps portent-elles un suffixe commun ? | "Flow" pour les perso, "Pro" pour les métier, libre pour le reste ? |
| 4.4 | **Positionnement visuel** | Où se situer entre minimaliste froid (Linear) et chaleureux riche (Headspace) ? | Échelle de 1 à 5 |
| 4.5 | **Marque mère visible ?** | L'utilisateur voit-il "by VitaTech" ou "Powered by VTT" quelque part ? | Splash, Settings, About ? |

---

## Phase 5 : COULEURS & THÈMES

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 5.1 | **Palette neutre universelle** | Background, Surface, Surface Secondary (light + dark) — déjà fait dans `AppColors` |
| 5.2 | **Système Primary par app** | Primary + PrimaryLight + PrimaryDark + PrimaryContainer — comment chaque app définit sa couleur |
| 5.3 | **Couleur premium/accent** | Une 2e couleur optionnelle pour les apps qui en ont besoin (gold pour Pro, silver pour Premium) |
| 5.4 | **Couleurs sémantiques** | Success, Warning, Error, Info — sont-elles identiques partout ou varient-elles ? |
| 5.5 | **Palette de catégories** | Couleurs pour les tags, domaines de vie, catégories (8-12 couleurs "data viz") |
| 5.6 | **Glassmorphism tokens** | frosted opacity, blur radius, border opacity — communs ou variables ? |
| 5.7 | **Gradient system** | Y a-t-il des gradients ? Si oui, lesquels (primary→primaryDark, surface→transparent) ? |
| 5.8 | **Mode par défaut** | Dark-first ? Light-first ? System-follows ? |

---

## Phase 6 : TYPOGRAPHIE

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 6.1 | **Fonte principale** | Inter pour tout ? Ou une fonte display pour les titres + Inter pour le body ? |
| 6.2 | **Échelle typographique** | Nombre de niveaux (Display, H1, H2, H3, Body, Caption, Overline, etc.) |
| 6.3 | **Poids utilisés** | Regular (400), Medium (500), SemiBold (600), Bold (700) — lesquels garder ? |
| 6.4 | **Line-heights** | Ratio par taille (headline: 1.2, body: 1.5, caption: 1.4) |
| 6.5 | **Letter-spacing** | Serré pour les titres, normal pour le body, wide pour l'overline ? |
| 6.6 | **Taille min accessible** | 12sp ? 14sp ? Quelle taille minimum pour le body ? |
| 6.7 | **Fonte arabe/locale** | Si les apps ciblent des marchés RTL, prévoir fonte arabe ? |

---

## Phase 7 : SPACING & LAYOUT

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 7.1 | **Grille de base** | 4px ou 8px ? (déjà 8px dans le projet) |
| 7.2 | **Échelle de spacing** | xs(4), sm(8), md(12), lg(16), xl(24), 2xl(32), 3xl(48), 4xl(64) |
| 7.3 | **Padding de page** | Horizontal padding standard (16? 20? 24?) |
| 7.4 | **Gap system** | Espacements entre éléments : gap-xs à gap-3xl |
| 7.5 | **Cards padding interne** | Padding intérieur des cartes (12? 16? 20?) |
| 7.6 | **Safe areas** | Gestion du notch, barre de navigation, keyboard |
| 7.7 | **Grid columns** | Nombre de colonnes pour tablette (2, 3, 4 colonnes adaptatives ?) |
| 7.8 | **Max content width** | Largeur max du contenu sur tablette/web (600? 720? 840?) |

---

## Phase 8 : FORMES & RADIUS

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 8.1 | **Shape language** | Arrondi doux (tous radius > 8) ? Mixte ? Angulaire ? |
| 8.2 | **Échelle de radius** | none(0), xs(4), sm(8), md(12), lg(16), xl(24), 2xl(32), full(999) |
| 8.3 | **Radius par composant** | Button=md, Card=lg, TextField=md, BottomSheet=xl, Avatar=full |
| 8.4 | **Borders** | Épaisseur (0.5, 1, 1.5, 2) × Styles (solid, dashed pour focus) |
| 8.5 | **Dividers** | Épaisseur, couleur, avec/sans padding horizontal |

---

## Phase 9 : OMBRES & ÉLÉVATION

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 9.1 | **Système d'élévation** | Combien de niveaux (sm, md, lg, xl) ? |
| 9.2 | **Style d'ombre** | Diffuse douce (premium) vs nette (Material) |
| 9.3 | **Ombres en dark mode** | Ombres visibles en dark ? Ou glow/border à la place ? |
| 9.4 | **Glow accent** | Glow teinté de la couleur primary pour les éléments interactifs ? |

---

## Phase 10 : ICONOGRAPHIE & ILLUSTRATIONS

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 10.1 | **Pack d'icônes** | Lucide ? Material Symbols ? Phosphor ? Tabler ? Iconsax ? |
| 10.2 | **Style d'icônes** | Outlined ? Filled ? Duo-tone ? |
| 10.3 | **Taille d'icônes** | 16, 20, 24, 28, 32 — quels niveaux ? |
| 10.4 | **Style d'illustrations** | Flat 2D ? 3D isométrique ? Line art ? Gradient organic ? Lottie animées ? |
| 10.5 | **Illustrations par app ou shared ?** | Bibliothèque commune ou spécifiques à chaque app ? |
| 10.6 | **Illustrations d'états vides** | Style des empty states (cute, minimal, informative) |
| 10.7 | **App icon style** | Gradient ? Flat ? Glyph sur fond couleur ? Consistance inter-apps |

---

## Phase 11 : MOTION & ANIMATIONS

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 11.1 | **Courbes d'animation** | easeInOut, easeOut, spring, bouncy — lesquelles ? |
| 11.2 | **Durées standard** | instant(100ms), fast(200ms), normal(300ms), slow(500ms), dramatic(800ms) |
| 11.3 | **Transitions de page** | Slide ? Fade ? SharedAxis ? Hero ? |
| 11.4 | **Micro-interactions** | Bouton press (scale 0.95?), toggle switch, checkbox animation |
| 11.5 | **Stagger entrée de liste** | Delay entre chaque item (50ms? 80ms?) + direction (top→bottom, fade) |
| 11.6 | **Skeleton loading** | Shimmer ? Pulse ? Couleur (surface+10%) ? |
| 11.7 | **Pull-to-refresh** | Standard Material ? Custom avec logo ? |
| 11.8 | **Scroll effects** | Parallax ? Shrinking header ? Fade on scroll ? |

---

## Phase 12 : HAPTICS & SONS

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 12.1 | **Retour haptique** | Sur quelles actions ? (tap bouton, toggle, success, error, swipe) |
| 12.2 | **Niveaux haptiques** | light, medium, heavy, selection, error, success |
| 12.3 | **Micro-sons** | Activer ou non ? Si oui : success chime, error buzz, unlock sound |
| 12.4 | **Son de célébration** | Un son pour les streaks, objectifs atteints, etc. |
| 12.5 | **Mode silencieux** | Toggle global dans Settings pour couper haptics+sons |

---

## Phase 13 : ÉTATS DES COMPOSANTS

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 13.1 | **États universels** | Default, Hover, Pressed, Focused, Disabled, Loading, Error, Success |
| 13.2 | **Feedback de tap** | InkWell ripple ? Scale down ? Opacity change ? Highlight ? |
| 13.3 | **État loading** | Spinner ? Shimmer ? Skeleton ? Texte "Chargement..." ? |
| 13.4 | **État erreur** | Rouge + icône ? Toast ? Snackbar ? Inline sous le champ ? |
| 13.5 | **État vide** | Illustration + titre + description + CTA ? Ou minimaliste ? |
| 13.6 | **État offline** | Banner en haut ? Indicateur subtil ? Fonctionnement dégradé ? |
| 13.7 | **Validation formulaire** | Temps réel (chaque frappe) ou à la soumission ? |

---

## Phase 14 : CÉLÉBRATIONS & GAMIFICATION

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 14.1 | **Quand célébrer** | Signup, première action, streak 7j, objectif atteint, level up ? |
| 14.2 | **Intensité** | Subtile (icon bounce + haptic) vs dramatique (confetti fullscreen + son) |
| 14.3 | **Types visuels** | Confetti, particles, glow pulse, checkmark animé, lottie custom ? |
| 14.4 | **Streaks** | Compteur + flamme ? Ou calendrier type GitHub contribution graph ? |
| 14.5 | **Niveaux / XP** | Système de progression visible ? Badges ? |
| 14.6 | **Ton des messages** | "Bravo !" ? "Mission accomplie" ? "Excellent travail" ? |

---

## Phase 15 : NAVIGATION & ARCHITECTURE INFO

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 15.1 | **Pattern principal** | Bottom Navigation (3-5 tabs) + Stack screens ? |
| 15.2 | **Drawer** | Présent ou non ? Si oui, pour quoi ? |
| 15.3 | **Tab bar style** | Icons only ? Icons + labels ? Animated indicator ? |
| 15.4 | **FAB** | Présent ? Pour quelles actions ? Style (circle, extended, mini) ? |
| 15.5 | **AppBar style** | Transparent ? Solid ? Collapsing/SliverAppBar ? |
| 15.6 | **Back navigation** | Flèche standard ? X pour les modals ? Swipe back iOS ? |
| 15.7 | **Bottom sheets** | Modal ? Pour quels cas (filtres, actions, détails) ? |
| 15.8 | **Modals vs full-screen** | À quel moment basculer (création = full, filtre = modal) ? |

---

## Phase 16 : CATALOGUE DE COMPOSANTS

| # | Composant | Variantes à définir |
|---|-----------|-------------------|
| 16.1 | **AppButton** | Primary, Secondary, Ghost, Destructive, Icon-only, Loading state |
| 16.2 | **AppTextField** | Outlined, Filled, Search, Password, Multiline, Error, Disabled |
| 16.3 | **AppCard** | Flat, Elevated, Outlined, Interactive, Glassmorphic |
| 16.4 | **AppListTile** | Simple, With subtitle, With trailing, With leading icon, Swipeable |
| 16.5 | **AppBadge** | Count, Status dot, Text label |
| 16.6 | **AppChip** | Filter, Action, Input, Selectable |
| 16.7 | **AppToggle** | Switch, Checkbox, Radio |
| 16.8 | **AppProgress** | Linear, Circular, Ring with percentage |
| 16.9 | **AppEmptyState** | With illustration, Without, With CTA, Compact |
| 16.10 | **AppBottomNav** | 3-tab, 4-tab, 5-tab, With FAB notch |
| 16.11 | **AppSnackbar/Toast** | Info, Success, Warning, Error, With action |
| 16.12 | **AppDialog** | Confirmation, Destructive, Input, Custom content |
| 16.13 | **AppBottomSheet** | Handle bar, Drag to dismiss, Scrollable content |
| 16.14 | **AppAvatar** | Image, Initials, Icon, With badge, Group |
| 16.15 | **AppDivider** | Horizontal, With label, Section separator |
| 16.16 | **AppSkeleton** | Text, Card, List, Circle, Custom shape |

---

## Phase 17 : PATTERNS UX RÉUTILISABLES

| # | Pattern | Ce qu'il faut standardiser |
|---|---------|---------------------------|
| 17.1 | **Auth flow** | Login → Register → Forgot Password → OTP → Onboarding |
| 17.2 | **Onboarding** | Nombre de pages, style indicator, skip button, CTA final |
| 17.3 | **Settings** | Structure (sections, toggles, navigation), profil en haut |
| 17.4 | **Search** | Barre + filtres + résultats + empty + recent |
| 17.5 | **List → Detail** | Transition, layout du détail, actions (edit, delete, share) |
| 17.6 | **Form patterns** | Validation, multi-step, save draft, confirmation |
| 17.7 | **Error handling** | Try again, fallback, error boundary, graceful degradation |
| 17.8 | **Paywall / Upsell** | Quand apparaît, design, pricing display, restore purchase |
| 17.9 | **Notifications center** | In-app, grouped, read/unread, swipe actions |
| 17.10 | **Profile screen** | Avatar, infos, stats summary, actions |

---

## Phase 18 : UX PACKS SPÉCIALISÉS

| # | Pack | Composants spécifiques à définir |
|---|------|--------------------------------|
| 18.1 | **Flow Pack** | Dashboard card, Habit tracker row, Streak counter, Progress ring, Weekly chart, IA chat bubble, Check-in slider, Review template |
| 18.2 | **Pro Pack** | Voice input FAB, Client card, Document preview, Payment timeline, WhatsApp share button, Quick-entry bottom sheet, Debt tracker, PDF viewer |
| 18.3 | **Community Pack** | Role badge, Member card, Event card, Calendar view, Notification bell with count, Admin KPI card, Attendance tracker |

---

## Phase 19 : UX WRITING & VOIX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 19.1 | **Ton global** | Tutoiement ou vouvoiement ? (tu pour Flow, vous pour Pro ?) |
| 19.2 | **Longueur des messages** | Titres max X mots, descriptions max Y mots |
| 19.3 | **Labels des boutons** | Verbe d'action ("Commencer", "Ajouter") vs nom ("Suivant", "OK") |
| 19.4 | **Messages d'erreur** | Techniques ou humains ? ("Erreur 500" vs "Oups, quelque chose a cassé") |
| 19.5 | **Messages de succès** | Neutre ("Enregistré") vs encourageant ("C'est noté !") |
| 19.6 | **Texte loading** | Rien ? Dots animés ? Message rotatif ("Préparation...") |
| 19.7 | **Langue par défaut** | Français ? Anglais ? Les deux dès le départ ? |
| 19.8 | **Format dates** | "Il y a 3 min" vs "10 mars 2026" vs "10/03/26" |

---

## Phase 20 : MICRO-COPY EMOTIONAL LIBRARY

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 20.1 | **Catégories d'émotions** | Encouragement, Félicitation, Réconfort, Motivation, Humour léger, Urgence douce |
| 20.2 | **Nb de variantes par catégorie** | 5 ? 10 ? 20 phrases alternatives pour éviter la répétition ? |
| 20.3 | **Encouragement** | "Tu es sur la bonne voie", "Continue comme ça", "Chaque pas compte" — style ? |
| 20.4 | **Félicitation** | "Bravo !", "Objectif atteint !", "Tu gères !" — intensité ? |
| 20.5 | **Réconfort (après échec/erreur)** | "Pas de souci", "On réessaie ?", "Ça arrive à tout le monde" — ton ? |
| 20.6 | **Motivation (retour après absence)** | "Content de te revoir !", "Reprends là où tu en étais" — culpabilité = 0 |
| 20.7 | **Messages contextuels par app** | IronFlow: métaphores sport. SpiritFlow: langage inspirant. HustlePro: langage business |
| 20.8 | **Format technique** | Fichier JSON/YAML avec clés ? Ou intégré dans les fichiers ARB de localisation ? |

---

## Phase 21 : ACCESSIBILITÉ

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 21.1 | **Contraste minimum** | WCAG AA (4.5:1) ou AAA (7:1) ? |
| 21.2 | **Taille touch target** | 44×44pt minimum ? 48×48pt ? |
| 21.3 | **Semantic labels** | Toutes les icônes/images ont un label ? |
| 21.4 | **Font scaling** | Supporter le scaling système (1.0→2.0) ? |
| 21.5 | **Couleur seule = non** | Ne jamais communiquer par la couleur seule (ajouter icône/texte) |
| 21.6 | **Reduce motion** | Respecter le setting OS pour désactiver les animations |

---

## Phase 22 : BRAND SKIN SYSTEM (Architecture technique)

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 22.1 | **Structure du fichier skin** | Combien de tokens par skin ? (12? 20? 30?) |
| 22.2 | **Injection** | GetIt ? InheritedWidget ? ThemeExtension ? |
| 22.3 | **Hot-swap** | Peut-on changer de skin au runtime (pour un mode "Preview") ? |
| 22.4 | **Skin par module** | Les modules optionnels (chat, AI) ont-ils leur propre sous-skin ? |
| 22.5 | **Fallback** | Que se passe-t-il si un token skin n'est pas défini ? Défaut = LifeFlow |

---

## Phase 23 : FICHIERS À PRODUIRE (Output final)

| # | Fichier | Contenu |
|---|---------|---------|
| 23.1 | `flutter/.github/instructions/design-system-tokens.md` | Règles d'utilisation des tokens (spacing, colors, typography) |
| 23.2 | `flutter/.github/instructions/design-system-components.md` | Catalogue des composants + variantes + quand utiliser |
| 23.3 | `flutter/.github/instructions/design-system-motion.md` | Animations, transitions, micro-interactions |
| 23.4 | `flutter/.github/instructions/design-system-haptics.md` | Haptics + sons |
| 23.5 | `flutter/.github/instructions/design-system-states.md` | États des composants |
| 23.6 | `flutter/.github/instructions/design-system-celebrations.md` | Célébrations, gamification |
| 23.7 | `flutter/.github/instructions/design-system-navigation.md` | Patterns navigation |
| 23.8 | `flutter/.github/instructions/design-system-ux-writing.md` | Voix, ton, formats, micro-copy library |
| 23.9 | `flutter/.github/instructions/design-system-accessibility.md` | Règles a11y |
| 23.10 | `flutter/.github/instructions/design-system-brand-skin.md` | Comment créer un skin pour une nouvelle app |
| 23.11 | `flutter/.github/instructions/design-system-ux-packs.md` | Flow Pack, Pro Pack, Community Pack |
| 23.12 | `flutter/.github/instructions/design-system-illustrations.md` | Icônes, illustrations, assets |
| 23.13 | `flutter/.github/instructions/design-system-dark-mode.md` | Règles dark mode |
| 23.14 | `flutter/.github/instructions/design-system-principles.md` | Design principles + emotional journey + ethical design |
| 23.15 | `flutter/.github/agents/design-system-auditor.md` | Agent qui vérifie la conformité au DS |
| 23.16 | `flutter/.github/agents/brand-skin-creator.md` | Agent qui génère un skin pour une nouvelle app |
| 23.17 | `flutter/.github/agents/ux-pack-selector.md` | Agent qui recommande quel pack UX utiliser |
| 23.18 | `flutter/.github/prompts/create-new-app-skin.prompt.md` | Prompt pour générer une skin |
| 23.19 | `flutter/.github/prompts/audit-screen-design.prompt.md` | Prompt pour auditer un écran |
| 23.20 | `flutter/.github/prompts/generate-component.prompt.md` | Prompt pour créer un nouveau composant DS |

---

# PRIORITÉ 2 — AFFINAGE (Phases 24-37)

---

## Phase 24 : GESTES & INTERACTIONS TACTILES

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 24.1 | **Swipe actions** | Swipe-to-delete ? Swipe-to-archive ? Direction (gauche/droite) ? Couleur derrière ? |
| 24.2 | **Long press** | Déclenche quoi ? Menu contextuel ? Mode sélection multiple ? Haptic feedback ? |
| 24.3 | **Drag & drop** | Pour réordonner les listes ? Les habits ? Les tâches ? Handle icon visible ? |
| 24.4 | **Pull-to-refresh** | Indicator style (Material classique vs custom) ? Seuil de distance ? |
| 24.5 | **Pinch-to-zoom** | Pour les graphiques ? Les images ? Les PDF ? |
| 24.6 | **Double-tap** | Utilisé ou non ? Pour quoi (like, zoom, edit) ? |
| 24.7 | **Swipe entre tabs** | PageView horizontal pour naviguer entre sections ? |
| 24.8 | **Swipe back (iOS)** | Edge swipe natif sur iOS ? Comportement Android ? |
| 24.9 | **Seuils de vitesse** | Flick rapide vs drag lent — différents comportements ? |

---

## Phase 25 : DATA VISUALIZATION

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 25.1 | **Librairie de graphiques** | fl_chart ? syncfusion ? graphic ? custom painter ? |
| 25.2 | **Types de graphiques** | Line, Bar, Pie/Donut, Radar, Heatmap, Sparkline — lesquels garder ? |
| 25.3 | **Couleurs de données** | Palette de 8-12 couleurs pour series multiples (pas la primary seule) |
| 25.4 | **Style des axes** | Visible ? Masqué ? Labels at bottom ? Grille de fond ? |
| 25.5 | **Tooltips/hover** | Info-bulle au tap sur un point de données ? Style ? |
| 25.6 | **Animation d'entrée** | Les graphiques s'animent à l'apparition ? (draw-in, grow, fade) |
| 25.7 | **Mode comparaison** | Afficher semaine précédente en pointillé ? Toggle avant/après ? |
| 25.8 | **Sparklines** | Mini-graphiques inline dans les cartes de dashboard ? |
| 25.9 | **Progress rings** | Style (épaisseur, gradient sur l'arc, label au centre) |
| 25.10 | **Heatmap calendrier** | Style GitHub contribution graph pour les streaks |
| 25.11 | **Ratio texte/graphique** | Un graphique est toujours accompagné d'une stat textuelle ? |

---

## Phase 26 : RESPONSIVE & MULTI-DEVICE

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 26.1 | **Breakpoints** | Phone (<600), Tablet (600-1024), Desktop (>1024) |
| 26.2 | **Layout adaptatif** | Single column phone → 2 columns tablet → 3 columns desktop ? |
| 26.3 | **Navigation adaptative** | Bottom nav phone → Rail tablet → Sidebar desktop ? |
| 26.4 | **Master-detail** | Liste à gauche + détail à droite sur tablette ? |
| 26.5 | **Taille des touch targets** | Plus grands sur phone, précision souris sur desktop |
| 26.6 | **Densité de contenu** | Compact (phone), Comfortable (tablet), Dense (desktop) |
| 26.7 | **Orientation** | Portrait-only phone ? Landscape supporté tablette ? |
| 26.8 | **Foldables** | Gérer les écrans pliants (Galaxy Fold) ? |
| 26.9 | **Web** | Flutter web = prévu ? Si oui, hover states, curseur, keyboard shortcuts |
| 26.10 | **Keyboard shortcuts** | Tablette avec clavier : Ctrl+S, Escape, Tab navigation |

---

## Phase 27 : INTERNATIONALISATION (i18n/l10n)

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 27.1 | **Langues au lancement** | Français seul ? Français + Anglais ? + Arabe ? + Langues locales ? |
| 27.2 | **RTL support** | Arabe/Hébreu = layout miroir complet. Prévu ou pas ? |
| 27.3 | **Pluralisation** | "1 tâche" vs "3 tâches" — via ICU message format ? |
| 27.4 | **Format des nombres** | 1.000,50 (FR) vs 1,000.50 (EN) — locale-aware ? |
| 27.5 | **Format monétaire** | FCFA, EUR, USD — positionnement du symbole |
| 27.6 | **Format dates** | "10 mars 2026" (FR) vs "March 10, 2026" (EN) |
| 27.7 | **Texte qui déborde** | L'allemand est 30% plus long que l'anglais — les UI s'adaptent ? |
| 27.8 | **Images avec texte** | Pas de texte dans les images (sinon il faut les localiser) |
| 27.9 | **Outil de traduction** | ARB files ? Slang ? Crowdin ? Lokalise ? |
| 27.10 | **Fallback** | Si une clé de traduction manque, français par défaut ? |

---

## Phase 28 : GESTION DES ERREURS (Taxonomie complète)

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 28.1 | **Erreur réseau** | Pas de connexion → Banner persistante + mode offline |
| 28.2 | **Timeout** | Requête > 15s → Message + bouton "Réessayer" |
| 28.3 | **Erreur serveur (5xx)** | Écran dédié ou snackbar ? Retry automatique ? |
| 28.4 | **Erreur auth (401/403)** | Redirect login ? Token refresh silencieux ? |
| 28.5 | **Validation inline** | Erreur sous le champ en rouge — au blur ou à la frappe ? |
| 28.6 | **Validation formulaire** | Scroll vers la première erreur ? Focus automatique ? |
| 28.7 | **Erreur critique (crash)** | Écran de fallback ? Bouton "Signaler" ? Redémarrage ? |
| 28.8 | **Rate limiting** | Trop de requêtes → "Patiente quelques secondes" |
| 28.9 | **Données corrompues** | Si le JSON est invalide → fallback, pas de crash |
| 28.10 | **Maintenance** | Écran "L'app est en maintenance, reviens dans X minutes" |
| 28.11 | **Force update** | Version trop vieille → écran bloquant "Mets à jour" |
| 28.12 | **Feature flag off** | Fonctionnalité désactivée côté serveur → comment cacher ? |

---

## Phase 29 : LOADING & PERFORMANCE

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 29.1 | **Skeleton screens** | Carte = rectangle arrondi shimmer. Liste = 3-5 lignes shimmer. Couleur ? |
| 29.2 | **Optimistic updates** | Les actions UI s'appliquent avant la réponse serveur ? Rollback si erreur ? |
| 29.3 | **Pagination** | Infinite scroll ? Load more button ? Page numbers ? |
| 29.4 | **Infinite scroll seuil** | Déclencher le chargement à X items avant la fin ? |
| 29.5 | **Cache strategy** | Afficher le cache d'abord, rafraîchir en arrière-plan (stale-while-revalidate) ? |
| 29.6 | **Image loading** | Placeholder (blur hash, couleur dominante, shimmer) ? Fade-in à l'arrivée ? |
| 29.7 | **Animation budget** | Max 60fps. Désactiver les ombres/blur sur les appareils bas de gamme ? |
| 29.8 | **Liste virtualisée** | À partir de combien d'items utiliser un ListView.builder ? |
| 29.9 | **Splash duration** | Minimum et maximum de temps sur le splash (1.5s? 3s max?) |
| 29.10 | **Preloading** | Précharger les données de l'écran suivant pendant que l'utilisateur est sur l'actuel ? |

---

## Phase 30 : MONÉTISATION UX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 30.1 | **Placement du paywall** | Après combien d'actions gratuites ? Sur quel écran ? |
| 30.2 | **Design du paywall** | Comparaison plans ? Features lock icons ? Gradient premium ? |
| 30.3 | **Pricing display** | Par mois affiché ? Par an avec économie ? Les deux côte à côte ? |
| 30.4 | **Trial UX** | "7 jours gratuits" — barre de progression des jours restants ? |
| 30.5 | **Feature gates** | Icône cadenas sur les features premium ? Ou les cacher complètement ? |
| 30.6 | **Downgrade** | Que voit l'utilisateur quand son abonnement expire ? Données conservées ? |
| 30.7 | **Upsell moments** | "Tu as atteint ta limite de X. Passe à Pro !" — quand exactement ? |
| 30.8 | **Social proof** | "Rejoint par X utilisateurs" sur le paywall ? |
| 30.9 | **CTA wording** | "Commencer l'essai" vs "Débloquer Pro" vs "Continuer" |
| 30.10 | **Restore purchase** | Bouton visible mais discret. Emplacement ? |

---

## Phase 31 : ONBOARDING & FIRST-TIME UX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 31.1 | **Splash → Onboarding** | Toujours montré ? Seulement au 1er lancement ? |
| 31.2 | **Nombre de pages** | 3 ? 4 ? 5 pages max ? |
| 31.3 | **Style** | Illustration + titre + sous-titre ? Vidéo ? Interactif (l'user agit) ? |
| 31.4 | **Skip** | Bouton skip visible ? Ou obligatoire de tout lire ? |
| 31.5 | **Login/Register placement** | Après l'onboarding ? Ou avant avec "continuer sans compte" ? |
| 31.6 | **Permissions demandées** | Notifications, caméra, micro — quand exactement ? Au besoin ou pendant l'onboarding ? |
| 31.7 | **Coach marks / Tooltips** | Bulle "Tap ici pour..." au premier écran ? Combien ? |
| 31.8 | **Checklist de démarrage** | "Complète ton profil (1/5)" visible sur le dashboard après signup ? |
| 31.9 | **Progressive disclosure** | Montrer les features avancées seulement après X jours d'usage ? |
| 31.10 | **Empty → First content** | Transformer les empty states en prompts d'action ("Ajoute ta première habitude") |

---

## Phase 32 : OFFLINE & SYNC

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 32.1 | **Mode offline** | Quelles features marchent hors-ligne ? Lecture seule ? Écriture locale ? |
| 32.2 | **Indicateur offline** | Banner en haut ? Icône dans l'AppBar ? Snackbar une fois ? |
| 32.3 | **Queue d'actions** | Les actions en offline s'empilent et se sync au retour ? |
| 32.4 | **Conflit de sync** | Deux appareils modifient la même donnée — last write wins ? Merge ? Prompt user ? |
| 32.5 | **Données locales** | Hive ? SharedPreferences ? SQLite ? Drift ? Quel stockage ? |
| 32.6 | **Sync indicator** | Un spinner discret "Synchronisation..." ? Ou silencieux ? |

---

## Phase 33 : NOTIFICATIONS UX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 33.1 | **Push notification style** | Titre court + body. Avec image (big picture) ? |
| 33.2 | **Deep link depuis push** | Le tap ouvre l'écran exact concerné ? |
| 33.3 | **In-app notifications** | Centre de notifications dans l'app ? Badge sur l'icône cloche ? |
| 33.4 | **Notification grouping** | Grouper par type (rappels, social, system) ? |
| 33.5 | **Quiet hours** | L'app respecte un créneau "Ne pas déranger" configurable ? |
| 33.6 | **Notification settings** | Granularité : par type ? Par channel ? Toggle global ? |
| 33.7 | **In-app banners** | Banner en haut pour "Nouvelle version dispo" ou "Offre spéciale" ? |
| 33.8 | **Badge count** | Nombre sur l'icône de l'app (iOS) ? Sur le bottom nav tab ? |

---

## Phase 34 : SÉCURITÉ & PRIVACY UX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 34.1 | **Biometric lock** | Option Face ID / Fingerprint pour ouvrir l'app ? |
| 34.2 | **App lock timeout** | Après combien de temps en background re-demander l'auth ? |
| 34.3 | **Données sensibles** | Masquer les montants / données perso dans le task switcher ? |
| 34.4 | **Screenshot policy** | Bloquer les screenshots sur certains écrans (finances, mots de passe) ? |
| 34.5 | **Privacy labels** | Texte clair "Tes données sont chiffrées" visible ? |
| 34.6 | **Delete account** | Processus clair, confirmation forte, délai de grâce (30j ?) |
| 34.7 | **Export data** | GDPR — bouton "Exporter mes données" dans Settings ? |
| 34.8 | **Consent dialogs** | Analytics opt-in ? Cookie/tracking consent ? |

---

## Phase 35 : IMPRESSION & EXPORT

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 35.1 | **PDF export style** | En-tête avec logo, couleurs de l'app, pied de page "Généré par X" |
| 35.2 | **Share cards** | Image partageable sur les réseaux (stats, streaks, achievements) |
| 35.3 | **CSV export** | Pour les données structurées (dépenses, tracking, ventes) |
| 35.4 | **Impression** | Support direct de l'impression via le système ? |
| 35.5 | **QR codes** | Générer des QR codes de partage ? Style (couleur, logo au centre) |

---

## Phase 36 : WHITE-LABELING (pour les apps Community)

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 36.1 | **Logo d'église/entreprise** | Remplace le logo de l'app ? Ou à côté ? |
| 36.2 | **Couleurs custom** | Le client peut-il changer la primary ? Ou seulement le logo ? |
| 36.3 | **Nom custom** | "ChurchFlow de ICC" ou "ICC App powered by ChurchFlow" ? |
| 36.4 | **Domaine custom** | Sous-domaine ? (icc.churchflow.app) |
| 36.5 | **Splash custom** | Splash avec logo de l'église ou splash ChurchFlow ? |

---

## Phase 37 : VERSIONING DU DESIGN SYSTEM

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 37.1 | **Semantic versioning** | v1.0.0, v1.1.0, v2.0.0 — pour le design system lui-même |
| 37.2 | **Breaking changes** | Comment signaler un breaking change (composant retiré, token renommé) |
| 37.3 | **Migration guide** | Document de migration quand on passe de v1 à v2 |
| 37.4 | **Changelog** | Historique des changements du DS |
| 37.5 | **Package partagé** | Le DS devient-il un package Dart séparé importé par toutes les apps ? |
| 37.6 | **Storybook / Catalogue** | App de démonstration (Widgetbook) pour visualiser tous les composants ? |

---

# PRIORITÉ 3 — SCALING (Phases 38-53)

---

## Phase 38 : IA & UX CONVERSATIONNELLE

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 38.1 | **Style de bulles** | User à droite (primary), IA à gauche (surface). Radius, spacing, max-width |
| 38.2 | **Streaming token-by-token** | Le texte IA apparaît mot par mot ? Curseur clignotant pendant ? |
| 38.3 | **Avatar IA** | Icône générique VTT ? Ou spécifique par app (haltère pour IronFlow, croix pour SpiritFlow) ? |
| 38.4 | **Typing indicator** | 3 dots animés ? Texte "L'IA réfléchit..." ? Shimmer dans la bulle ? |
| 38.5 | **Actions dans la bulle** | Boutons inline (quiz, suggestions, liens) ? Cards interactives ? |
| 38.6 | **Input vocal** | Bouton micro dans le chat ? Waveform pendant l'enregistrement ? |
| 38.7 | **Markdown dans les réponses** | Bold, listes, code blocks, tableaux — supportés et stylisés ? |
| 38.8 | **Feedback sur la réponse** | 👍👎 sous chaque réponse IA ? "Régénérer" ? "Copier" ? |
| 38.9 | **Historique des conversations** | Liste de conversations précédentes ? Ou un seul fil continu ? |
| 38.10 | **Coût/limites visibles** | "3/10 questions gratuites aujourd'hui" — barre de progression ? |
| 38.11 | **Disclaimer** | "L'IA peut se tromper" — placement, style, fréquence ? |
| 38.12 | **Mode hors-ligne** | Message "L'IA n'est pas disponible hors connexion" — quand ? |

---

## Phase 39 : ADAPTATION CULTURELLE (MONDIALE)

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 39.1 | **Devises** | FCFA, USD, EUR, GBP, BRL, INR, JPY, GHS, KES — format par locale (symbole avant/après, décimales) |
| 39.2 | **Noms de personnes** | Prénom+Nom (Occident), Nom+Prénom (Asie), nom unique (certaines cultures) |
| 39.3 | **Numéros de téléphone** | Format par pays, input mask intelligent, validation libphonenumber |
| 39.4 | **Calendrier** | Lundi-first (Europe, Afrique), Dimanche-first (US, Moyen-Orient), samedi-first (certains pays arabes) |
| 39.5 | **Greetings** | Contextuels selon l'heure ET la culture. Formels vs informels par marché |
| 39.6 | **Représentation dans les illustrations** | Diversité de carnations, cheveux, vêtements — pas un seul "type" |
| 39.7 | **Vocabulaire** | Adapter par marché : "Mobile Money" (Afrique), "digital wallet" (US), "porte-monnaie" (France) |
| 39.8 | **Canaux de partage** | WhatsApp (Afrique, Inde, Brésil), WeChat (Chine), LINE (Japon), iMessage (US), Telegram (Europe Est) |
| 39.9 | **Ton culturel** | Direct (US/Northern Europe) vs indirect (Asie, Afrique). Critique positive vs franche |
| 39.10 | **Sensibilité religieuse/politique** | Multi-cadre opt-in. Jamais assumer une religion. Contenus neutres par défaut |
| 39.11 | **Unités de mesure** | kg/lbs, km/miles, °C/°F — toggle ou auto par locale |
| 39.12 | **Format d'adresse** | Varie radicalement : US (123 Street, City, State, ZIP) vs France (rue, code postal, ville) vs Japon (inversé) |

---

## Phase 40 : PERFORMANCE SUR APPAREILS BAS DE GAMME

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 40.1 | **Taille APK/AAB** | Budget max : 30MB ? 50MB ? Chaque MB compte pour les données mobiles |
| 40.2 | **Images optimisées** | WebP ? Qualité max ? Lazy loading systématique ? |
| 40.3 | **Animations conditionnelles** | Pas de Lottie/blur/shadow lourds sur les appareils < 3Go RAM |
| 40.4 | **Android min SDK** | API 21 (Android 5) ? API 23 (Android 6) ? API 26 (Android 8) ? |
| 40.5 | **Mémoire** | Libérer les images hors-écran ? Limiter le cache d'images en RAM ? |
| 40.6 | **Démarrage à froid** | Objectif < 2 secondes sur un appareil milieu de gamme |
| 40.7 | **Réseau lent** | Timeout adaptatif ? Compression des requêtes ? Images en basse qualité d'abord ? |
| 40.8 | **Stockage local** | Budget stockage max ? Nettoyage automatique du cache > X jours ? |
| 40.9 | **Battery drain** | Pas de polling continu. Pas de location en arrière-plan sauf nécessité. |
| 40.10 | **Fallback SVG** | SVG au lieu de Lottie/GIF pour les illustrations si appareil bas de gamme ? |

---

## Phase 41 : GROWTH & VIRALITÉ UX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 41.1 | **Share cards** | Image stylisée auto-générée ("J'ai tenu 30 jours de streak sur IronFlow") |
| 41.2 | **Invite flow** | "Invite un ami" — SMS + WhatsApp + copier le lien |
| 41.3 | **Referral reward** | "Invite 3 amis → 1 mois Premium gratuit" — UX de la jauge |
| 41.4 | **App Store rating** | Quand demander ? (après succès, jamais après erreur). InAppReview API. |
| 41.5 | **Social proof** | "12.847 personnes utilisent IronFlow" — placement, format |
| 41.6 | **FOMO** | "Ton ami David a complété son objectif" — notifications sociales opt-in |
| 41.7 | **Onboarding viral** | Les apps Pro (HustlePro, EventPro, StyleFlow) partagent des PDF au client → le client découvre l'app |
| 41.8 | **Watermark** | "Créé avec ForgePro" en bas du PDF gratuit ? Retiré en Premium ? |
| 41.9 | **Deep links** | Liens universels qui ouvrent l'app (ou le Store si pas installée) |
| 41.10 | **Attribution** | Tracker quel canal a amené l'utilisateur (UTM, referrer) |

---

## Phase 42 : PAIEMENT & MOBILE MONEY UX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 42.1 | **Méthodes de paiement** | Ordre d'affichage : Mobile Money > Carte > PayPal ? |
| 42.2 | **Mobile Money UX** | Input numéro → envoi USSD → wait for callback → confirmation |
| 42.3 | **Providers supportés** | Orange Money, Wave, MTN MoMo, Airtel Money, M-Pesa |
| 42.4 | **Gateway** | Moneroo ? Paystack ? Flutterwave ? CinetPay ? |
| 42.5 | **Pending state** | "Paiement en attente de confirmation" — écran d'attente avec timer |
| 42.6 | **Receipt** | Reçu de paiement in-app + envoyé par email/WhatsApp ? |
| 42.7 | **Échec de paiement** | "Le paiement a échoué. Réessaie ou change de méthode." |
| 42.8 | **Pricing localisé** | 3000 FCFA au Sénégal, $4.99 aux USA, 3.99€ en France — comment gérer ? |
| 42.9 | **In-App Purchase** | Google Play / App Store IAP obligatoire ? Ou paiement externe ? |
| 42.10 | **Free tier** | Quelles features sont toujours gratuites ? Comment indiquer visuellement ? |

---

## Phase 43 : INPUT VOCAL & CAMÉRA UX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 43.1 | **Bouton d'enregistrement** | FAB micro ? Long-press ? Tap to start / tap to stop ? |
| 43.2 | **Waveform pendant l'enregistrement** | Visualisation de l'amplitude en temps réel ? |
| 43.3 | **Transcription affichée** | Montrer le texte transcrit avant validation ? Éditable ? |
| 43.4 | **Langues vocales** | Français, anglais, + langues locales (wolof, nouchi, pidgin) — supportées ? |
| 43.5 | **Bruit de fond** | Indicateur si l'environnement est trop bruyant ? |
| 43.6 | **Camera UX** | Plein écran ? Cadrage guidé (rectangle pour documents, cercle pour avatar) ? |
| 43.7 | **Photo review** | Prévisualisation avant envoi. "Reprendre" ou "Utiliser cette photo" ? |
| 43.8 | **OCR feedback** | "Lecture en cours..." puis texte extrait affiché pour validation |
| 43.9 | **Galerie vs Camera** | Les deux options toujours ? Ou prioriser selon le contexte ? |
| 43.10 | **Permissions** | Demande de permission micro/caméra contextuelle (au moment du besoin, pas au démarrage) |

---

## Phase 44 : FEATURE FLAGS & A/B TESTING UX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 44.1 | **Feature flag system** | Comment cacher/montrer une feature côté client ? (RemoteConfig, Supabase flags, PostHog) |
| 44.2 | **A/B test UX** | Deux variantes d'un écran — l'utilisateur ne voit qu'une. Tracking des conversions. |
| 44.3 | **Gradual rollout** | 10% → 50% → 100% des utilisateurs. Comment gérer ? |
| 44.4 | **Fallback** | Si le flag service est down, quelle variante par défaut ? |
| 44.5 | **Debug menu** | Écran caché (tap 7x sur la version) pour forcer les flags en dev ? |
| 44.6 | **Kill switch** | Désactiver une feature en prod en < 1 minute si problème |

---

## Phase 45 : MULTI-COMPTE & PROFILS

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 45.1 | **Rôles visuels** | Badge de rôle (Admin, Membre, Responsable) — couleur, placement |
| 45.2 | **Switch de rôle** | Si quelqu'un est admin ET membre, comment basculer ? |
| 45.3 | **Multi-organisation** | Un utilisateur dans plusieurs églises/entreprises — org picker UX |
| 45.4 | **Permissions UI** | Cacher les features non autorisées ? Ou les montrer grisées + "Vous n'avez pas accès" ? |
| 45.5 | **Admin dashboard** | Composants spécifiques : KPI cards, user list, activity feed |
| 45.6 | **Onboarding par rôle** | Le nouveau admin voit un onboarding différent du nouveau membre |
| 45.7 | **Invitation flow** | QR code, lien WhatsApp, code PIN — pour rejoindre une organisation |

---

## Phase 46 : ANALYTICS & TRACKING UX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 46.1 | **Events à tracker** | screen_view, button_tap, feature_used, error_occurred, funnel_step |
| 46.2 | **Naming convention** | snake_case ? camelCase ? Hierarchical (auth.login.tap_submit) ? |
| 46.3 | **Properties standard** | screen_name, user_role, app_version, device_tier, connection_type |
| 46.4 | **Funnel events** | Onboarding completion, Signup → First action → Day 7 retention |
| 46.5 | **Performance metrics** | TTI (Time to Interactive), FCP (First Contentful Paint), crash rate |
| 46.6 | **UX quality signals** | Rage taps (taps répétés sur un élément non-interactif) → détection automatique |
| 46.7 | **Privacy-first** | Pas de PII dans les events. Anonymisation. Consent opt-in. |
| 46.8 | **Outil** | PostHog (déjà intégré) ? Mixpanel ? Amplitude ? Rester sur PostHog ? |
| 46.9 | **Dashboard standard** | Chaque app a le même dashboard analytics avec les mêmes KPIs |
| 46.10 | **Heatmaps** | Session recording / heatmaps via PostHog pour identifier les frictions ? |

---

## Phase 47 : CONVENTIONS PLATEFORME (iOS vs Android)

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 47.1 | **Material vs Cupertino** | 100% Material Design ? Ou adaptive (CupertinoNavigationBar sur iOS, AppBar sur Android) ? |
| 47.2 | **Navigation back** | Swipe-from-edge (iOS natif) toujours actif ? Flèche back (Android) ? Les deux ? |
| 47.3 | **Page transitions** | Slide-from-right (iOS) vs fade (Android) ? Ou une transition unifiée ? |
| 47.4 | **Switches** | CupertinoSwitch sur iOS, Material Switch sur Android ? Ou un seul style partout ? |
| 47.5 | **Date/Time pickers** | Cupertino wheel (iOS) vs Material calendar (Android) ? Ou un picker custom unifié ? |
| 47.6 | **Alerts/Dialogs** | CupertinoAlertDialog (iOS) vs AlertDialog (Android) ? Ou unifié ? |
| 47.7 | **Scroll physics** | BouncingScrollPhysics (iOS) vs ClampingScrollPhysics (Android) ? |
| 47.8 | **Status bar** | Style adapté par plateforme (notch, Dynamic Island, punch-hole) |
| 47.9 | **Haptics** | HapticFeedback natif iOS (Taptic Engine) vs Android vibration patterns |
| 47.10 | **Font system** | Inter partout ? Ou SF Pro sur iOS, Roboto sur Android si on veut le natif ? |

---

## Phase 48 : COMPLIANCE LÉGALE MONDIALE

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 48.1 | **GDPR (Europe)** | Consent banner, droit à l'oubli, accès aux données, portabilité |
| 48.2 | **CCPA (Californie)** | "Do Not Sell My Personal Information" — lien visible |
| 48.3 | **LGPD (Brésil)** | Consentement explicite, DPO contact visible |
| 48.4 | **POPIA (Afrique du Sud)** | Notice de collecte de données |
| 48.5 | **COPPA (mineurs US)** | PrepExam cible des élèves — si <13 ans, restrictions majeures |
| 48.6 | **App Store guidelines** | Apple exige "Sign in with Apple" si social login. Google exige delete account. |
| 48.7 | **Placement légal** | Liens CGU, Politique de confidentialité — au signup + dans Settings |
| 48.8 | **Cookie/tracking consent** | Écran de consentement AVANT le tracking analytics — opt-in ou opt-out ? |
| 48.9 | **Age gate** | Vérification d'âge pour certaines apps ? (question simple ou vrai gate) |
| 48.10 | **Audit trail** | Historique des consentements donné/retiré par l'utilisateur |

---

## Phase 49 : SUPPORT CLIENT IN-APP

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 49.1 | **Centre d'aide** | FAQ searchable dans l'app ? WebView vers un site ? |
| 49.2 | **Chat support** | Live chat avec un humain ? Chatbot d'abord ? |
| 49.3 | **Ticket system** | Formulaire de contact avec catégories (bug, paiement, compte, feature request) |
| 49.4 | **Placement** | Bouton "?" dans Settings ? FAB "Aide" ? Menu dans le drawer ? |
| 49.5 | **Bug report** | Screenshot automatique + logs + device info envoyés avec le ticket |
| 49.6 | **Feedback in-app** | "Cette page t'a été utile ?" — micro-survey contextuel |
| 49.7 | **Status page** | Indicateur si le service est down. Lien vers status.vitatech.app |
| 49.8 | **Changelog in-app** | "Quoi de neuf" — affiché après une mise à jour |

---

## Phase 50 : CONTENU DYNAMIQUE & MEDIA

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 50.1 | **Image formats** | WebP prioritaire ? Fallback PNG ? SVG pour les icônes ? |
| 50.2 | **Video player** | Style du player (contrôles, progress bar, fullscreen) |
| 50.3 | **Audio player** | Minibar en bas ? Waveform ? Play/pause/seek ? |
| 50.4 | **Markdown renderer** | Pour le contenu riche (articles, descriptions, réponses IA) — style des headers, listes, code |
| 50.5 | **Lightbox** | Tap sur image → plein écran avec zoom pinch ? |
| 50.6 | **Carrousel** | Auto-scroll ? Indicateur dots/line ? Snap behavior ? |
| 50.7 | **Empty media** | Placeholder quand une image ne charge pas (icône, couleur, initiales) |
| 50.8 | **User-generated content** | Modération ? Signalement ? Filtres de contenu inapproprié ? |

---

## Phase 51 : ACCESSIBILITÉ AVANCÉE (au-delà du visuel)

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 51.1 | **Daltonisme** | Mode protanopie/deutéranopie/tritanopie — ne jamais coder l'info par couleur seule |
| 51.2 | **Mode haut contraste** | Thème spécial avec contraste renforcé activable dans Settings |
| 51.3 | **Motricité réduite** | Gestes simplifiés (pas de double-tap, pas de long-press obligatoire) — toujours une alternative |
| 51.4 | **TalkBack / VoiceOver** | Semantic labels sur tous les widgets, traversal order logique |
| 51.5 | **Cognitive** | Pas plus de 3 actions principales par écran. Langage simple. Pas de surcharge visuelle |
| 51.6 | **Reduce motion** | Respecter `MediaQuery.disableAnimations`. Pas de parallax, pas d'auto-play |
| 51.7 | **Bold text** | Respecter le setting système "Bold Text" sur iOS |
| 51.8 | **Switch Access** | Navigation possible uniquement au clavier/switch pour les utilisateurs à mobilité très réduite |

---

## Phase 52 : DESIGN ↔ DEV WORKFLOW

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 52.1 | **Figma** | Le design system vit-il dans Figma en parallèle du code ? |
| 52.2 | **Design tokens sync** | Figma Variables → Dart tokens automatiquement ? (Style Dictionary, Figma Tokens) |
| 52.3 | **Widgetbook** | App catalogue pour pré-visualiser chaque composant avec ses variantes |
| 52.4 | **Golden tests** | Chaque composant a un test golden (screenshot) pour détecter les régressions visuelles |
| 52.5 | **Code review DS** | Toute modification du DS nécessite review par le "DS owner" |
| 52.6 | **Linting rules** | Lint custom qui interdit `Color(0xFF...)` en dehors du DS (force `AppColors.xxx`) |
| 52.7 | **Documentation** | Chaque composant a un docstring avec : quand l'utiliser, quand NE PAS l'utiliser |
| 52.8 | **Contribution guide** | Comment un dev ajoute un nouveau composant au DS (PR template, checklist) |

---

## Phase 53 : TESTING & QUALITÉ UX

| # | Décision | Ce qu'il faut définir |
|---|----------|-----------------------|
| 53.1 | **Golden tests** | Chaque écran majeur a un test golden pour chaque combinaison (light/dark × data/empty/error) |
| 53.2 | **Widget tests** | Chaque composant DS a un test unitaire (rendu, tap, états) |
| 53.3 | **Integration tests** | Flows critiques testés end-to-end (signup, paiement, création) |
| 53.4 | **Performance benchmarks** | Startup time, frame rate, memory usage — CI/CD checks |
| 53.5 | **Accessibility audit** | CI qui vérifie : taille touch target, contrast ratio, semantic labels |
| 53.6 | **Visual regression** | Comparaison pixel par pixel à chaque PR via golden tests |
| 53.7 | **Device matrix** | Tester sur : petit phone (SE), grand phone (Ultra), tablette 10", différents OS |
| 53.8 | **User testing protocol** | Quand et comment tester avec de vrais utilisateurs (5 users, think aloud) |

---

# Récapitulatif

| # | Phase | Décisions | Catégorie | Priorité |
|---|-------|-----------|-----------|----------|
| 1 | Design Principles | 6 | Fondation | MAINTENANT |
| 2 | Emotional Journey Map | 8 | Fondation | MAINTENANT |
| 3 | Ethical Design & Wellbeing | 8 | Fondation | MAINTENANT |
| 4 | Identité de marque | 5 | Fondation | MAINTENANT |
| 5 | Couleurs & Thèmes | 8 | Fondation | MAINTENANT |
| 6 | Typographie | 7 | Fondation | MAINTENANT |
| 7 | Spacing & Layout | 8 | Fondation | MAINTENANT |
| 8 | Formes & Radius | 5 | Fondation | MAINTENANT |
| 9 | Ombres & Élévation | 4 | Fondation | MAINTENANT |
| 10 | Iconographie & Illustrations | 7 | Fondation | MAINTENANT |
| 11 | Motion & Animations | 8 | Interaction | MAINTENANT |
| 12 | Haptics & Sons | 5 | Interaction | MAINTENANT |
| 13 | États des composants | 7 | Interaction | MAINTENANT |
| 14 | Célébrations & Gamification | 6 | Interaction | MAINTENANT |
| 15 | Navigation & Architecture | 8 | Structure | MAINTENANT |
| 16 | Catalogue de composants | 16 | Composants | MAINTENANT |
| 17 | Patterns UX réutilisables | 10 | Composants | MAINTENANT |
| 18 | UX Packs spécialisés | 3 | Composants | MAINTENANT |
| 19 | UX Writing & Voix | 8 | Communication | MAINTENANT |
| 20 | Micro-copy Emotional Library | 8 | Communication | MAINTENANT |
| 21 | Accessibilité | 6 | Inclusion | MAINTENANT |
| 22 | Brand Skin System | 5 | Architecture | MAINTENANT |
| 23 | Fichiers à produire | 20 | Livrable | MAINTENANT |
| 24 | Gestes & Interactions tactiles | 9 | Interaction | APRÈS v1 |
| 25 | Data Visualization | 11 | Contenu | APRÈS v1 |
| 26 | Responsive & Multi-device | 10 | Adaptabilité | APRÈS v1 |
| 27 | Internationalisation | 10 | Global | APRÈS v1 |
| 28 | Gestion des erreurs | 12 | Résilience | APRÈS v1 |
| 29 | Loading & Performance | 10 | Résilience | APRÈS v1 |
| 30 | Monétisation UX | 10 | Business | APRÈS v1 |
| 31 | Onboarding & First-time UX | 10 | Croissance | APRÈS v1 |
| 32 | Offline & Sync | 6 | Résilience | APRÈS v1 |
| 33 | Notifications UX | 8 | Engagement | APRÈS v1 |
| 34 | Sécurité & Privacy UX | 8 | Confiance | APRÈS v1 |
| 35 | Impression & Export | 5 | Fonctionnel | APRÈS v1 |
| 36 | White-labeling | 5 | Business | APRÈS v1 |
| 37 | Versioning du DS | 6 | Gouvernance | APRÈS v1 |
| 38 | IA & UX Conversationnelle | 12 | Contenu | SCALING |
| 39 | Adaptation culturelle MONDIALE | 12 | Global | SCALING |
| 40 | Performance bas de gamme | 10 | Inclusion | SCALING |
| 41 | Growth & Viralité UX | 10 | Croissance | SCALING |
| 42 | Paiement & Mobile Money | 10 | Business | SCALING |
| 43 | Input vocal & Caméra | 10 | Fonctionnel | SCALING |
| 44 | Feature flags & A/B Testing | 6 | Itération | SCALING |
| 45 | Multi-compte & Profils | 7 | Structure | SCALING |
| 46 | Analytics & Tracking UX | 10 | Itération | SCALING |
| 47 | Conventions plateforme iOS/Android | 10 | Adaptabilité | SCALING |
| 48 | Compliance légale mondiale | 10 | Global | SCALING |
| 49 | Support client in-app | 8 | Confiance | SCALING |
| 50 | Contenu dynamique & Media | 8 | Contenu | SCALING |
| 51 | Accessibilité avancée | 8 | Inclusion | SCALING |
| 52 | Design ↔ Dev Workflow | 8 | Gouvernance | SCALING |
| 53 | Testing & Qualité UX | 8 | Gouvernance | SCALING |
| | **TOTAL** | **~430** | | |
