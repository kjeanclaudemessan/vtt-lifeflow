# Design System Config — LifeFlow

> *Généré le 19 Février 2026 — basé sur le Voice & Tone et le BM v3.0*
> *Le DS partagé (Porsche-inspired) est réutilisé. Seules les couleurs et configs spécifiques au projet sont ici.*

---

## ⚠️ Constat : Duplication dans le DS actuel

Avant de configurer, 3 duplications à résoudre :

| Fichier | Emplacement 1 | Emplacement 2 | Action |
|---------|---------------|---------------|--------|
| `app_colors.dart` | `design_system/tokens/` (Porsche, 365 lignes) | `design_system/colors/` (Material generic, 241 lignes) + `ui/common/` | **Garder `design_system/tokens/`** — c'est le DS Porsche. Supprimer les deux autres. Mettre à jour les imports |
| `app_radius.dart` | `design_system/radius/` | `design_system/tokens/` | Fusionner dans `design_system/tokens/`. Supprimer l'autre |
| `app_typography.dart` | `design_system/typography/` | `design_system/tokens/` | Fusionner dans `design_system/tokens/`. Supprimer l'autre |

**→ La source de vérité est `design_system/tokens/`.** Tout ce qui est ailleurs est un vestige du template.

---

## Palette LifeFlow

### Philosophie

L'identité LifeFlow est **calme, claire, bienveillante**. Pas de rouge Porsche agressif. Pas de noir profond intimidant. On veut que l'app respire — que l'utilisateur se sente en paix, pas sous pression.

**Couleur primaire : Indigo profond** — sagesse, structure, confiance. Ni corporate (bleu) ni agressif (rouge). Le indigo est à la fois apaisant et sérieux.

**Couleur accent : Teal/menthe** — fraîcheur, progression, équilibre. C'est la couleur des "bonnes nouvelles" dans l'app.

### Tokens à configurer dans `AppColors`

```
BRAND
├── primary:            #4F46E5  (Indigo 600 — boutons CTA, headers, navigation active)
├── primaryLight:       #818CF8  (Indigo 400 — hover, container léger)
├── primaryDark:        #3730A3  (Indigo 800 — texte sur fond clair, appuyé)
├── primaryContainer:   #EEF2FF  (Indigo 50 — fond de carte active, badge)
├── primaryContainerDark: #1E1B4B  (Indigo 950 — container dark mode)
├── onPrimary:          #FFFFFF  (texte sur primary)

ACCENT / SECONDARY
├── secondary:          #14B8A6  (Teal 500 — succès, progression, streak)
├── secondaryLight:     #5EEAD4  (Teal 300 — fond succès léger)
├── secondaryDark:      #0F766E  (Teal 700 — texte succès)
├── secondaryContainer: #F0FDFA  (Teal 50 — container succès)

SEMANTIC
├── success:            #22C55E  (Green 500 — habitude complétée)
├── successLight:       #F0FDF4  (Green 50)
├── warning:            #F59E0B  (Amber 500 — alerte budget temps)
├── warningLight:       #FFFBEB  (Amber 50)
├── error:              #EF4444  (Red 500 — erreur technique uniquement, JAMAIS pour "raté")
├── errorLight:         #FEF2F2  (Red 50)
├── info:               #3B82F6  (Blue 500)
├── infoLight:          #EFF6FF  (Blue 50)

NEUTRAL (habitude non faite, éléments désactivés)
├── neutral:            #9CA3AF  (Gray 400 — "pas fait" = gris neutre, PAS rouge)
├── neutralLight:       #F3F4F6  (Gray 100)
├── neutralDark:        #4B5563  (Gray 600)

DOMAIN COLORS (couleurs pré-assignées aux 5 domaines par défaut)
├── domainHealth:       #22C55E  (Green — Santé)
├── domainWork:         #3B82F6  (Blue — Travail)
├── domainRelations:    #F59E0B  (Amber — Relations)
├── domainGrowth:       #8B5CF6  (Violet — Développement perso)
├── domainSpiritual:    #EC4899  (Pink — Spiritualité/Créativité)
```

### Thèmes

| Token | Light | Dark |
|-------|-------|------|
| background | `#FFFFFF` | `#0F172A` (Slate 900 — plus doux que le noir pur) |
| surface | `#F8FAFC` (Slate 50) | `#1E293B` (Slate 800) |
| surfaceSecondary | `#F1F5F9` (Slate 100) | `#334155` (Slate 700) |
| textPrimary | `#0F172A` (Slate 900) | `#F8FAFC` (Slate 50) |
| textSecondary | `#64748B` (Slate 500) | `#94A3B8` (Slate 400) |
| textDisabled | `#CBD5E1` (Slate 300) | `#475569` (Slate 600) |
| divider | `#E2E8F0` (Slate 200) | `#334155` (Slate 700) |
| card | `#FFFFFF` | `#1E293B` (Slate 800) |

**Note** : on utilise la palette Slate (bleutée) au lieu de Gray (neutre) pour le dark mode. Ça donne un fond plus chaleureux et cohérent avec le indigo primaire.

---

## Règles d'usage des couleurs dans LifeFlow

| Contexte | Couleur | ❌ Jamais |
|----------|---------|-----------|
| Habitude complétée | `success` (vert) | Pas de rouge si non complétée |
| Habitude non faite | `neutral` (gris) | **JAMAIS de rouge, JAMAIS d'orange** |
| Streak actif | `secondary` (teal) | — |
| Streak en pause (freeze) | `neutral` (gris) avec icône pause | Pas de rouge "streak cassé" |
| Compteur temps — en équilibre | `textPrimary` (neutre) | — |
| Compteur temps — en retard | `warning` (amber, doux) | Pas de `error` (rouge) |
| Erreur technique | `error` (rouge) | Uniquement pour les bugs/erreurs serveur |
| Domaine de vie | Sa couleur dédiée (voir domainColors) | Pas de couleur partagée entre domaines |
| CTA principal | `primary` (indigo) | — |
| CTA secondaire | `outline` sur fond transparent | — |
| Fond de carte active | `primaryContainer` | — |

**Principe fondamental** : le rouge (`error`) n'apparaît JAMAIS dans un contexte d'habitude/tâche/streak. Le rouge est réservé aux erreurs techniques. C'est la traduction design du Voice & Tone "jamais de culpabilité".

---

## Typographie

Le DS partagé utilise **Inter**. On le garde tel quel pour LifeFlow — c'est lisible, professionnel, neutre. Pas de changement.

---

## Composants DS à créer (manquants)

Ces composants n'existent pas encore dans le DS partagé. À créer quand on en aura besoin :

| Composant | Usage LifeFlow | Priorité |
|-----------|---------------|----------|
| `AppDomainBadge` | Badge coloré rond avec nom du domaine | P1 (utilisé partout) |
| `AppStreakIndicator` | Affichage streak avec flamme ou nombre + état (actif/pause) | P1 |
| `AppTimeCounter` | Compteur heures par domaine (barre de progression + chiffre) | P1 |
| `AppWeeklyChart` | Mini barres horizontales pour le bilan hebdo | P1 |
| `AppContextualCard` | Carte qui change selon l'heure (TodayView) | P1 |
| `AppHabitCheckbox` | Checkbox custom avec animation haptic | P1 |

**Règle** : ces composants seront créés dans le DS partagé (`design_system/`), pas dans le code feature. Ils doivent être réutilisables pour d'autres projets si possible.

---

## Assets spécifiques LifeFlow

| Asset | Description | Statut |
|-------|-------------|--------|
| App icon | Cercle indigo avec symbole balance/flux | À créer |
| Splash screen | Fond indigo, logo blanc centré | À créer |
| Onboarding illustrations | 3 illustrations minimalistes (domaines, habitudes, compteur) | À créer |
| Domain icons | 5 icônes pour les domaines par défaut | Material Icons suffisent en MVP |
| Empty state illustrations | Illustrations légères pour les états vides | À créer (ou utiliser des icônes) |

---

## Résumé des décisions

| Décision | Choix | Raison |
|----------|-------|--------|
| Couleur primaire | Indigo `#4F46E5` | Calme, structure, confiance — aligné avec "bienveillant, clair, ancré" |
| Couleur accent | Teal `#14B8A6` | Fraîcheur, progression — les bonnes nouvelles sont en teal |
| Palette neutre | Slate (bleutée) | Plus chaleureuse que Gray, cohérente avec l'indigo |
| Dark mode fond | Slate 900 `#0F172A` | Plus doux que le noir pur `#000000` |
| Rouge | Erreurs techniques UNIQUEMENT | Voice & Tone : jamais de culpabilité visuelle |
| Gris | "Pas fait" | Neutre, sans jugement |
| Domaines | 5 couleurs pré-assignées | Reconnaissance visuelle immédiate, pas de config nécessaire |
| Font | Inter (inchangée) | Déjà dans le DS, lisible, neutre |
