# Quickstart: Phase 1 — Le Cockpit Quotidien

**Branch**: `001-phase1-daily-foundations` | **Date**: 2026-02-19 | **Revised**: 2026-02-19
**Purpose**: Scénarios E2E pour valider chaque user story après implémentation.

## Prerequisites

1. Supabase running localement (`supabase start`)
2. `supabase db reset` passe avec zéro erreur
3. Flutter app compile (`dart analyze` = 0 errors)
4. Session utilisateur authentifié
5. Onboarding complété (domaines sélectionnés)

---

## Scenario 1: Onboarding → Première habitude → Premier check

**Teste**: US1 (Domaines) + US2 (Habitudes) + US3 (Compteur)

```text
1. Lancer l'app → l'onboarding démarre
2. Étape domaines : 5 domaines pré-cochés
3. Décocher "Finances", garder les 4 autres → Continuer
4. Vérifier : 4 domaines créés dans `domains` table
5. Naviguer vers tab Habitudes → AppEmptyState visible
6. Tap FAB (+) → HabitFormView
7. Remplir :
   - Nom: "Méditer"
   - Type: Binaire
   - Domaine: Santé (via picker)
   - Temps estimé: 10 min
   - Plage: 06:00 – 08:00
   - Fréquence: Chaque jour
8. Sauvegarder → retour HabitsView, habitude visible
9. Naviguer vers TodayView
10. Vérifier : "Méditer" dans section "Matin (6h – 12h)"
11. Cocher "Méditer"
12. Vérifier : ✅ coché, 🔥 1j, compteur mini "+10min Santé"
13. Naviguer vers tab Compteur
14. Vérifier : "Santé: 10min" affiché
```

**DB state attendu**:
- `domains`: 4 rows (Santé, Travail, Relations, Dev perso)
- `habits`: 1 row (Méditer, binary, domain_id → Santé, estimated_duration_minutes = 10)
- `habit_logs`: 1 row (log_date = today, completed = true)

---

## Scenario 2: Habitude quantitative (unité = min)

**Teste**: US2 (Habitudes quantitatives) + US3 (Compteur avec valeur réelle)

```text
1. Créer habitude :
   - Nom: "Lire"
   - Type: Quantitatif
   - Objectif: 30
   - Unité: min
   - Domaine: Dev perso
   - Temps estimé: 30 min (auto-suggestion car unité = min)
2. Sur TodayView, tap "Lire"
3. Saisir valeur: 25 min
4. Vérifier : progression 83% (25/30), pas complété (< target)
5. Naviguer vers Compteur
6. Vérifier : "Dev perso: 25min" (valeur RÉELLE, pas estimé, car unité = min)
7. Retour TodayView, modifier valeur à 35 min
8. Vérifier : progression 117%, habit cochée (≥ target)
9. Compteur : "Dev perso: 35min"
```

---

## Scenario 3: Habitude quantitative (unité ≠ min)

**Teste**: US2 + US3 (Compteur avec estimated_duration)

```text
1. Créer habitude :
   - Nom: "Boire 2L"
   - Type: Quantitatif
   - Objectif: 2000
   - Unité: ml
   - Domaine: Santé
   - Temps estimé: 5 min
2. Sur TodayView, saisir 1500 ml
3. Vérifier : progression 75%, non complété
4. Compteur : "Santé: 5min" (durée estimée, PAS 1500)
```

---

## Scenario 4: 7 jours de tracking → Bilan hebdo

**Teste**: US2 + US3 + US6 (Bilan)

```text
1. Avec 3 habitudes actives :
   - Méditer (10min, Santé)
   - Sport (60min, Santé)
   - Lire (30min, Dev perso)
2. Cocher toutes les habitudes pendant 7 jours consécutifs
3. Le dimanche soir, ouvrir TodayView
4. Vérifier : carte "📊 Ton bilan de la semaine est prêt !" visible
5. Tap → BilanView s'ouvre
6. Vérifier :
   - Total: 11h40 (70min × 7 + 30min × 7)
   - Santé: 8h10 (70min × 7)
   - Dev perso: 3h30 (30min × 7)
   - Top habit: Méditer (100%, 7/7)
   - Plus long streak: les 3 sont à 7j
   - Taux complétion: 100%
   - "Première semaine !" (pas de delta)
7. Tap "Partager"
8. Vérifier : image générée, sheet de partage système s'ouvre
```

---

## Scenario 5: Streak freeze

**Teste**: US5 (Streak freeze)

```text
1. Créer habitude "Sport" (binaire, quotidien)
2. Cocher Sport pendant 5 jours consécutifs (streak = 5)
3. Jour 6 : NE PAS cocher
4. Jour 7 : Cocher
5. Vérifier : streak = 7 (pas 1)
6. Vérifier : badge ❄️ sur le jour 6 dans le détail streak
7. Jour 8 : NE PAS cocher
8. Jour 9 : Cocher
9. Vérifier : streak = 1 (cassé — le freeze était déjà utilisé dans les 7 derniers jours)
```

---

## Scenario 6: TodayView contextuel (3 modes)

**Teste**: US4 (TodayView contextuel)

```text
Mode Matin (tester entre 5h et 12h) :
1. Ouvrir l'app
2. Vérifier : "Bonjour [prénom]", habitudes groupées par plage, mini compteur
3. Habitudes du matin en premier

Mode Progression (tester entre 12h et 18h) :
4. Cocher 2/4 habitudes du matin
5. Ouvrir l'app après 12h
6. Vérifier : "2/4 habitudes faites", barre de progression 50%
7. Section "Faites" avec les 2 cochées, "Restantes" avec les 2 non cochées

Mode Bilan (tester entre 18h et 5h) :
8. Cocher 1 habitude de plus
9. Ouvrir l'app après 18h
10. Vérifier : "Tu as fait 3 habitudes aujourd'hui", résumé temps du jour
```

*Note : pour tester les 3 modes sans attendre, on peut override `DateTime.now()` dans le ViewModel en dev.*

---

## Scenario 7: Gestion des domaines

**Teste**: US1 (Domaines CRUD)

```text
1. Settings → Mes domaines
2. Vérifier : 4 domaines listés (ordre initial)
3. Drag "Dev perso" en position 1
4. Vérifier : sort_order mis à jour (Dev perso = 0)
5. Swipe ← sur "Relations" → Archiver
6. Confirmer → "Relations" disparaît de la liste active
7. Section "Archivés" apparaît avec "Relations"
8. Aller créer une habitude → domain picker
9. Vérifier : "Relations" n'apparaît plus dans le picker
10. Retour domaines → Restaurer "Relations"
11. Vérifier : "Relations" revient dans la liste active
12. Tenter d'archiver les 3 domaines restants un par un
13. Au dernier : message "Tu dois garder au moins un domaine actif"
```

---

## Scenario 8: Backdate habit (rattrapage)

**Teste**: US2 (Backdating 7 jours)

```text
1. Créer habitude "Gratitude" aujourd'hui (mardi)
2. Sur TodayView, constater que l'habitude est non cochée pour aujourd'hui
3. Accéder au détail/historique de l'habitude
4. Cocher pour hier (lundi) → ✅
5. Cocher pour dimanche → ✅
6. Tenter de cocher pour le mardi d'avant (8 jours) → ❌ refusé
7. Vérifier : streak = 3 (dim, lun, mar si coché aujourd'hui)
8. Compteur mis à jour avec les 3 jours
```

---

## Scenario 9: Edge case — 0 de tout

**Teste**: Empty states

```text
1. Nouvel utilisateur, onboarding terminé avec domaines
2. TodayView → empty state "Ta journée est vide"
3. Habitudes tab → empty state
4. Compteur tab → empty state "Ton temps t'attend"
5. Créer 1 habitude → les 3 empty states disparaissent
6. Archiver l'habitude → les 3 empty states réapparaissent
```

---

## Validation Gates

| Gate | Commande | Critère |
|------|----------|---------|
| DB | `supabase db reset` | 0 erreurs |
| Lint | `dart analyze` | 0 erreurs, 0 warnings |
| Format | `dart format . --set-exit-if-changed` | 0 fichiers modifiés |
| App | `flutter run -d chrome` | App démarre, 3 tabs visibles |
| RLS | Test multi-user : créer 2 users, vérifier isolation | User A ne voit pas les données de User B |
