# Spec Quality Checklist

> **Usage** : Avant de valider une spec (spec.md) et de passer à l'implémentation, passe-la dans cette checklist.
> Chaque item est un ✅ ou ❌. Si plus de 2 items sont ❌, la spec n'est PAS prête.
> L'IA peut auto-évaluer. Le créateur doit valider.

---

# Checklist qualité — [NOM DE LA FEATURE / SPEC]

> *Évaluée le [DATE]*

---

## 1. Clarté du problème

| # | Critère | ✅/❌ | Note |
|---|---------|-------|------|
| 1.1 | Le problème utilisateur est décrit en termes HUMAINS (pas techniques) | | |
| 1.2 | On sait POURQUOI ce problème existe (pas juste QUOI) | | |
| 1.3 | Le coût de ne PAS résoudre ce problème est explicite | | |
| 1.4 | Le moment déclencheur est identifié (quand l'utilisateur ressent le besoin) | | |

---

## 2. Alignement avec le BM

| # | Critère | ✅/❌ | Note |
|---|---------|-------|------|
| 2.1 | La feature est présente dans le feature scoring avec un score ≥ seuil de la phase | | |
| 2.2 | La feature est cohérente avec la "phrase qui tue" du BM | | |
| 2.3 | La feature respecte TOUTES les convictions du créateur | | |
| 2.4 | La feature ne crée pas de chevauchement avec un concurrent qu'on ne peut pas battre | | |

---

## 3. User Stories

| # | Critère | ✅/❌ | Note |
|---|---------|-------|------|
| 3.1 | Chaque user story suit le format "En tant que [QUI], je veux [QUOI], afin de [POURQUOI]" | | |
| 3.2 | Le "afin de" exprime un BÉNÉFICE HUMAIN (pas technique) | | |
| 3.3 | Chaque user story a des critères d'acceptation VÉRIFIABLES | | |
| 3.4 | Les edge cases sont listés (connexion perdue, données vides, erreurs) | | |
| 3.5 | Le persona primaire est servi en priorité | | |

---

## 4. Scope & limites

| # | Critère | ✅/❌ | Note |
|---|---------|-------|------|
| 4.1 | Ce qui est IN scope est listé explicitement | | |
| 4.2 | Ce qui est OUT of scope est listé explicitement | | |
| 4.3 | La spec ne dépasse PAS ce qui est nécessaire pour la phase actuelle | | |
| 4.4 | Les dépendances avec d'autres features sont identifiées | | |

---

## 5. Data Model

| # | Critère | ✅/❌ | Note |
|---|---------|-------|------|
| 5.1 | Les entités sont définies avec leurs champs, types et contraintes | | |
| 5.2 | Les relations entre entités sont explicites | | |
| 5.3 | Les règles de validation sont documentées | | |
| 5.4 | Les transitions d'état sont documentées (si applicable) | | |
| 5.5 | Les index et RLS policies sont prévus | | |

---

## 6. UX & Wireframes

| # | Critère | ✅/❌ | Note |
|---|---------|-------|------|
| 6.1 | Les écrans principaux sont wireframés | | |
| 6.2 | Le flux utilisateur complet est clair (entrée → action → résultat) | | |
| 6.3 | Les états vides (empty states) sont prévus | | |
| 6.4 | Les états d'erreur sont prévus | | |
| 6.5 | Les états de chargement sont prévus | | |
| 6.6 | L'app est utilisable par le persona primaire en MOINS de 30 secondes après ouverture | | |
| 6.7 | Le wireframe utilise les composants du design system (pas des inventions) | | |

---

## 7. Testabilité

| # | Critère | ✅/❌ | Note |
|---|---------|-------|------|
| 7.1 | Chaque critère d'acceptation peut être traduit en test automatisé | | |
| 7.2 | Les scénarios de test end-to-end sont listés dans quickstart.md | | |
| 7.3 | Le "aha moment" du persona est testable (on peut vérifier qu'il arrive) | | |

---

## 8. Cohérence technique

| # | Critère | ✅/❌ | Note |
|---|---------|-------|------|
| 8.1 | L'architecture respecte la constitution du projet | | |
| 8.2 | La séparation Entity/Model est respectée | | |
| 8.3 | Les noms suivent les conventions cross-layer (snake_case tables, kebab-case routes, etc.) | | |
| 8.4 | Les migrations Supabase sont prévues (si nouvelles tables) | | |
| 8.5 | Les RLS policies sont prévues (si nouvelles tables) | | |

---

## 9. Priorisation

| # | Critère | ✅/❌ | Note |
|---|---------|-------|------|
| 9.1 | La spec est découpée en tâches ordonnées avec dépendances | | |
| 9.2 | Les tâches suivent l'ordre : Supabase → Domain → Data → Features | | |
| 9.3 | Aucune tâche ne dépasse 4h de travail estimé | | |
| 9.4 | Le chemin critique est identifié | | |

---

## Verdict

| Résultat | Condition |
|----------|-----------|
| ✅ **PRÊTE** | 0-1 item ❌ et aucun ❌ dans la section 1 (Clarté du problème) |
| ⚠️ **À CORRIGER** | 2-3 items ❌ |
| ❌ **PAS PRÊTE** | 4+ items ❌ OU tout item ❌ dans section 1 ou 2 |

### Score

```
[___] / 35 items validés
Verdict : [PRÊTE / À CORRIGER / PAS PRÊTE]
```

### Items à corriger

| # | Item | Ce qui manque | Qui corrige (IA / créateur) |
|---|------|--------------|----------------------------|
| | | | |
