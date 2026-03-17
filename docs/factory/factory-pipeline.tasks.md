# AI App Factory — Plan Complet

> **Objectif :** Mettre en place le système complet Certified Gate Loop + AI App Factory.
> **Priorité :** Phase 1 (Local) est la fondation — tout le reste en dépend.
> **Date :** 17 Mars 2026

**Légende :**
- `[ ]` À faire
- `[~]` En cours
- `[x]` Terminé
- `[!]` Bloqué
- 🔴 Critique / Bloquant
- 🟡 Important
- 🟢 Nice-to-have

**Dépendances :** Les tâches sont ordonnées — une tâche dépend des précédentes dans sa sous-phase.
**Critère de succès Phase 1 :** 3 apps codées bout en bout, taux de succès gates > 80%, < 3 interventions humaines/app.

---

## PHASE 1 — LOCAL (PC + VS Code) 🔴

> **Objectif :** Pipeline fonctionnel dans VS Code avec gates automatiques, règles encodées, et validation visuelle.
> **Supervision :** Constante (toi devant l'écran)
> **Livrables :** verify-gates.ps1, 4 fichiers de règles produit, intégration speckit.implement, Mobile MCP configuré, 3 apps validées.

---

### 1A — Fichiers de Règles Produit (les inputs pour l'IA) 🔴

> **But :** Encoder l'âme produit, l'architecture émotionnelle, les structures d'écran et le langage
> pour que l'IA produise des apps world-class sans deviner.

- [x] **T001** — Créer `.specify/memory/product-soul.md` 🔴 ✅
  - Philosophie produit, JTBD émotionnel, 7 Vérités Produit, Feeling Framework
  - Tiebreakers (12 règles de départage), Les "Jamais" (produit + UX)
  - **Ajouté v2 :** Monétisation UX, Rétention & Engagement (hook éthique, courbe J1→J90, dégradation gracieuse), Moat Framework (4 fossés), Analytics Principles, Privacy as Feature
  - Cross-ref table vers `.github/instructions/`

- [x] **T002** — Créer `.specify/memory/experience-architecture.md` 🔴 ✅
  - Arc narratif de session, Temps psychologique (4 modes), 6 Moments Critiques
  - 8 archétypes d'écran avec recette émotionnelle
  - **Ajouté v2 :** Rétention Loop Architecture (trigger→action→reward→investment, dégradation, variable rewards), Error Recovery Flows (stratégie émotionnelle par type d'erreur), Profils d'App (Flow/Pro/Community), Progressive Disclosure enrichi (J1→J90)
  - Cross-ref table vers `.github/instructions/`

- [x] **T003** — Créer `.specify/memory/wireframe-rules.md` 🔴 ✅
  - Framework "Users Do", 5 couches structurelles (tables décisionnelles, pas code)
  - Déduction automatique enrichie (Restraint Check + Platform Check)
  - **Ajouté v2 :** Restraint Principle (masque validation, ≤3 zones, ≤2 scrolls, ≤2s hésitation), Platform-Specific UX (iOS vs Android + cross-platform rules)
  - Cross-ref table vers `.github/instructions/`

- [x] **T004** — Créer `.specify/memory/content-rules.md` 🟡 ✅
  - Ton et voix (ami compétent), Matrice de ton par contexte
  - Textes par contexte (titres, boutons, empty states, erreurs, célébrations)
  - Seed data culturellement neutre, Les "Jamais" du contenu
  - **Ajouté v2 :** Voice Profiles par type d'app (Flow/Pro/Community), Error Recovery Content Strategy (wording émotionnel par type d'erreur), Notification Strategy avancée (types, fréquence, dégradation progressive)
  - Cross-ref table vers `.github/instructions/`
  - **Supprimé :** i18n technique (→ .github), icon mapping (→ .github), format dates/nombres (→ .github)

- [x] **T005** — Mettre à jour la constitution pour référencer les 4 fichiers produit 🟡 ✅
  - Ajouté §VIII Product Rules (Design Authority) dans `.specify/memory/constitution.md`
  - Two-Layer Architecture (QUOI/POURQUOI vs COMMENT) documentée
  - Ordre de priorité mis à jour : Constitution > Product Rules > Root > Stack > Instructions > Plan
  - Version bump : 2.0.0 → 3.0.0

---

### 1B — Gate 1 : Compilation (verify-gates.ps1 — fondation) 🔴

> **But :** Le premier gate — dart analyze + format + db reset. Bloquant, automatique, zéro tolérance.

- [x] **T006** — Créer le script `scripts/gates/verify-gates.ps1` 🔴 ✅
  - Paramètres : `-Scope` (file | task | phase | all), `-Gate` (1-7 ou all), `-Json` (sortie JSON), `-Fix` (auto-format)
  - Structure modulaire : verify-gates.ps1 orchestre 7 gate*.ps1 (dot-sourced)
  - Sortie : PASS/FAIL/WARN/SKIP par gate, par fichier, par règle (texte + JSON)
  - Code retour : 0 si tout PASS, 1 si au moins un FAIL
  - Helpers : Add-GateResult, Write-RuleResult, Get-FlutterFiles, Get-RelativePath, Test-FileContent

- [x] **T007** — Implémenter Gate 1 : Compilation 🔴 ✅
  - `dart analyze --no-fatal-infos` → FAIL si warnings/errors
  - `dart format --set-exit-if-changed lib/` → FAIL si fichiers non formatés (+ auto-fix avec -Fix)
  - `supabase db reset` → FAIL si migration cassée (skip si supabase non running)

- [x] **T008** — Tester Gate 1 sur le projet LifeFlow actuel 🔴 ✅
  - Testé via `verify-gates.ps1 -Gate 1 -Scope all`

---

### 1C — Gate 2 : Pattern Structurel (grep antipatterns) 🔴

> **But :** Vérifier par grep que chaque fichier respecte les patterns de la constitution.

- [x] **T009** — Implémenter Gate 2 : Entities 🔴 ✅
  - entity-equatable, entity-props, entity-no-data-import

- [x] **T010** — Implémenter Gate 2 : Models 🔴 ✅
  - model-json-serializable, model-methods (4 requis), model-insert-update (WARN)

- [x] **T011** — Implémenter Gate 2 : Repositories 🔴 ✅
  - repo-either, repo-impl-try-catch (WARN), repo-impl-no-ui-import

- [x] **T012** — Implémenter Gate 2 : Views 🔴 ✅
  - view-no-logic, view-state-machine, view-no-hardcoded-colors, view-i18n, view-typography
  - Exceptions : Colors.transparent/white/black, Text(' avec chiffres/vide filtré

- [x] **T013** — Implémenter Gate 2 : ViewModels 🟡 ✅
  - vm-busy-management (WARN), vm-no-direct-deps (FAIL supabase/http direct)

- [x] **T014** — Implémenter Gate 2 : Design System whitelist 🟡 ✅
  - Auto-extraction App* classes de design_system/, vérification features/modules

- [x] **T015** — Implémenter Gate 2 : Naming Conventions 🟡 ✅
  - Fichiers entity : `*_entity.dart` dans `domain/entities/`
  - Fichiers model : `*_model.dart` dans `data/models/`
  - Fichiers repo interface : `i_*_repository.dart` dans `domain/repositories/`
  - Fichiers repo impl : `*_repository_impl.dart` dans `data/repositories/`
  - Fichiers view : `*_view.dart` dans `views/`
  - Fichiers viewmodel : `*_viewmodel.dart` dans `viewmodels/`
  - Scanner les fichiers mal placés ou mal nommés → WARNING

- [x] **T016** — Tester Gate 2 sur LifeFlow 🔴 ✅
  - Résultat : P:134 F:31 W:10 — violations légitimes détectées (notification_model manque fromEntity, views sans i18n/state machine)
  - Pas de faux positifs majeurs

---

### 1D — Gate 3 : Architecture (import analysis) 🔴

> **But :** Vérifier que les couches ne s'importent pas dans le mauvais sens.

- [x] **T017** — Implémenter Gate 3 : Layer Dependencies 🔴 ✅
  - layer-domain-pure, layer-data-no-ui, layer-view-no-data, layer-vm-no-data

- [x] **T018** — Implémenter Gate 3 : Cross-Feature Isolation 🔴 ✅
  - cross-feature-isolation (features/X vs Y, modules/X vs Y)

- [x] **T019** — Implémenter Gate 3 : Package whitelist 🟡 ✅
  - package-whitelist (http/dio interdit dans features, provider interdit)
  - Support `.gatesignore` pour exceptions

- [x] **T020** — Tester Gate 3 sur LifeFlow 🔴 ✅
  - Résultat : 6/6 PASS — architecture propre

---

### 1E — Gate 4 : Experience 3-Layer Check 🟡

> **But :** Vérifier que chaque écran a les 3 couches d'expérience (fonctionnel + sensory + personality).

- [x] **T021** — Implémenter Gate 4 : Layer 1 — Fonctionnel 🟡 ✅
  - exp-fonctionnel (hasError + isBusy), exp-empty-state (WARN pour listes)

- [x] **T022** — Implémenter Gate 4 : Layer 2 — Sensory 🟡 ✅
  - exp-sensory-animation (18+ patterns), exp-sensory-haptic, exp-sensory-loading (skeleton > spinner)

- [x] **T023** — Implémenter Gate 4 : Layer 3 — Personality 🟡 ✅
  - exp-personality-i18n (context.l10n), exp-personality-tone (no negative empty text)

- [x] **T024** — Tester Gate 4 sur LifeFlow 🟡 ✅
  - Résultat : P:54 F:13 W:33 — calibrage approprié FAIL vs WARN

---

### 1F — Gate 5 : Cross-Screen Reactivity 🟡

> **But :** Vérifier que les mutations (create/update/delete) notifient les écrans concernés.

- [x] **T025** — Implémenter Gate 5 : Reactivity Check 🟡 ✅
  - reactivity-mutations (mutation patterns + notify detection), reactivity-method-notify (per-method deep check)
  - 10+ notify patterns : notifyListeners, rebuildUi, EventService, ReactiveServiceMixin...

- [x] **T026** — Tester Gate 5 sur LifeFlow 🟡 ✅
  - Résultat : 18/18 PASS — tous les viewmodels réactifs notifient correctement

---

### 1G — Gate 6 : Supabase RLS 🟡

> **But :** Vérifier que chaque table Supabase a des RLS policies.

- [x] **T027** — Implémenter Gate 6 : RLS Check 🟡 ✅
  - rls-enabled (FAIL si pas ENABLE ROW LEVEL SECURITY), rls-policies (WARN si 0 policies), rls-crud-coverage (WARN si CRUD incomplet)
  - Merge multi-fichier pour résoudre les cross-references

- [x] **T028** — Tester Gate 6 sur LifeFlow 🟡 ✅
  - Résultat : P:36 F:0 W:3 — profiles manque INSERT/DELETE, payment_methods manque plupart

---

### 1H — Gate 7 : Tests (flutter test) 🟢

> **But :** Exécuter les tests unitaires/widget quand ils existent.

- [x] **T029** — Implémenter Gate 7 : Test Runner 🟢 ✅
  - test-exists (par feature/module — WARN si pas de tests), flutter-test-run (FAIL si échec, PASS si succès, SKIP si aucun test)

- [x] **T030** — Tester Gate 7 sur LifeFlow 🟢 ✅
  - Testé via verify-gates.ps1 -Gate 7

---

### 1I — Intégration dans le Workflow 🔴

> **But :** Les gates ne servent à rien s'ils ne tournent pas automatiquement.

- [x] **T031** — Créer le wrapper d'exécution post-tâche 🔴
  - Script ou instruction qui exécute `verify-gates.ps1 --scope task --task T0XX` après chaque tâche
  - Sortie formatée : quels gates passent, lesquels échouent, quels fichiers sont concernés
  - Max 3 itérations de correction par tâche (compteur d'essais)

- [x] **T032** — Intégrer les gates dans `speckit.implement` 🔴
  - Modifier l'agent `.github/agents/speckit.implement.agent.md` (ou son instruction)
  - Ajouter une étape post-tâche : exécuter verify-gates, analyser le JSON, corriger si FAIL
  - Documenter le prompt de correction ciblée ("Gate 2 FAIL: fichier X, règle Y")

- [x] **T033** — Créer le pre-commit hook 🟡
  - `.git/hooks/pre-commit` → `verify-gates.ps1 --scope staged --gate 1,2,3`
  - Bloque le commit si Gate 1, 2 ou 3 échoue
  - Gate 4-7 en mode WARNING (ne bloque pas le commit)

- [x] **T034** — Documenter le README des gates 🟡
  - `scripts/gates/README.md` : comment exécuter, quels scopes, quels gates
  - Exemples d'usage : `verify-gates.ps1 --gate 2 --scope file --file lib/features/habits/...`
  - Table de référence : quel gate vérifie quelle règle de la constitution

---

### 1J — Mobile MCP + Gate Visuel 🟡

> **But :** Valider visuellement l'app sur émulateur via Mobile MCP.

- [ ] **T035** — Installer et configurer Mobile MCP 🟡
  - `npx @anthropic-ai/mobile-mcp@latest --avd-name Pixel_7_API_34 --port 10000`
  - Vérifier que l'émulateur démarre et que MCP se connecte
  - Ajouter dans `.vscode/mcp.json` la config Mobile MCP
  - Tester : `mobile_screenshot`, `mobile_list_elements`, `mobile_click`

- [ ] **T036** — Créer le script de navigation automatique 🟡
  - Script qui lance l'app debug, navigue vers chaque tab, prend un screenshot
  - Pour chaque écran : screenshot + `mobile_list_elements` → arbre d'accessibilité
  - Stocker les screenshots dans `docs/screenshots/` (pour comparaison)

- [ ] **T037** — Implémenter Gate Visuel (validation par screenshots) 🟢
  - Comparer screenshots pris avec les wireframes attendus (prompt LLM vision)
  - Checklist automatique : éléments visibles, pas tronqués, hiérarchie visuelle
  - Dark mode : basculer thème, re-screenshot, re-valider
  - Résultat : PASS/FAIL + annotations sur le screenshot

- [ ] **T038** — Tester le pipeline visuel sur LifeFlow 🟢
  - Build debug, installer émulateur, naviguer, screenshoter
  - Valider les 5+ écrans existants
  - Documenter les résultats

---

### 1K — Boucle de Correction Complète 🔴

> **But :** La boucle tâche par tâche : coder → gate → corriger → certifier.

- [ ] **T039** — Tester la boucle complète sur 3 tâches existantes 🔴
  - Prendre 3 tâches non cochées dans `tasks.md` de LifeFlow
  - Pour chaque : coder → `verify-gates` → corriger si FAIL → re-gate → marquer [X]
  - Mesurer : combien de corrections nécessaires, temps par tâche, taux PASS première tentative

- [ ] **T040** — Documenter le workflow boucle dans une instruction Copilot 🔴
  - Créer `flutter/.github/instructions/gate-loop.instructions.md`
  - Contenu : "Après chaque tâche, exécuter verify-gates. Si FAIL, corriger et re-gate (max 3x)."
  - Inclure le format exact de la commande et le format de lecture du résultat

- [ ] **T041** — Mesurer les métriques initiales sur LifeFlow 🟡
  - Taux de PASS première tentative (Gate 1, 2, 3, 4 séparément)
  - Taux de correction automatique réussie (sur 3 itérations max)
  - Dérives les plus fréquentes (quel gate échoue le plus)
  - Documenter dans `docs/factory/gate-metrics.md`

---

### 1L — Validation sur LifeFlow (app #1) 🔴

> **But :** Finir Phase 1 de LifeFlow en utilisant le pipeline complet.

- [ ] **T042** — Finir les tâches restantes de LifeFlow Phase 1 avec les gates 🔴
  - Utiliser le workflow : speckit.implement → tâche → verify-gates → correction → certifier
  - Objectif : 100% des 117 tâches cochées (actuellement 70/117 ≈ 60%)
  - Toutes les tâches passent Gate 1-4 minimum

- [ ] **T043** — Checkpoint humain : review visuelle LifeFlow 🟡
  - Screenshots des 5+ écrans sur émulateur (via Mobile MCP si dispo, sinon manuellement)
  - Vérifier cohérence visuelle, dark mode, navigation, état vide, état chargé
  - Documenter les corrections visuelles nécessaires

- [ ] **T044** — Build release LifeFlow 🟡
  - `flutter build apk --release` → doit compiler sans erreur
  - `flutter build appbundle --release` → AAB pour le Play Store
  - Tester l'APK release sur téléphone physique

---

### 1M — Validation sur App #2 (app modèle) 🟡

> **But :** Valider que le pipeline fonctionne from scratch sur une 2ème app.

- [ ] **T045** — Choisir la 2ème app (BM existant, simple) 🟡
  - Critères : template "gestion" ou "santé", ≤ 5 features, BM déjà documenté
  - Candidats probables : IronFlow, Meditation, StockManager, ReadFlow

- [ ] **T046** — Pipeline complet app #2 : BM → spec → plan → tasks 🟡
  - Utiliser speckit.specify avec les 4 fichiers produit (product-soul, experience-architecture, wireframe-rules, content-rules)
  - Vérifier que les wireframes auto-générés sont cohérents
  - speckit.plan → speckit.tasks → valider

- [ ] **T047** — Pipeline complet app #2 : implement + gates 🟡
  - speckit.implement avec verify-gates actif
  - Mesurer le taux de PASS et le nombre de corrections
  - Documenter les patterns nouveaux découverts

- [ ] **T048** — Pipeline complet app #2 : build + test visuel 🟡
  - Build debug, test sur émulateur, screenshots
  - Comparer avec wireframes attendus
  - Build release

---

### 1N — Validation sur App #3 (template différent) 🟡

> **But :** Valider le pipeline sur un template différent (finance, éducation, social...).

- [ ] **T049** — Choisir la 3ème app (template différent de #1 et #2) 🟡
  - Si LifeFlow = santé/productivité et #2 = gestion → #3 = finance ou education
  - Candidats : WealthFlow, TontineFlow, PrepExam

- [ ] **T050** — Pipeline complet app #3 : BM → spec → plan → tasks → implement → gates → build 🟡
  - Pipeline de bout en bout avec métriques

- [ ] **T051** — Rapport de Phase 1 🟡
  - Métriques agrégées des 3 apps (taux PASS, temps, corrections)
  - Gates les plus utiles vs les plus bruyants (faux positifs)
  - Ajustements nécessaires avant Phase 2
  - Checklist de validation Phase 1 (voir critères de migration dans pipeline-strategy.md)

---

### Récapitulatif Phase 1

| Sous-phase | Tâches | Priorité | Dépend de |
|-----------|--------|----------|-----------|
| **1A** Fichiers de règles | T001-T005 | 🔴 | — |
| **1B** Gate 1 Compilation | T006-T008 | 🔴 | — |
| **1C** Gate 2 Patterns | T009-T016 | 🔴 | 1B |
| **1D** Gate 3 Architecture | T017-T020 | 🔴 | 1B |
| **1E** Gate 4 Experience | T021-T024 | 🟡 | 1C |
| **1F** Gate 5 Reactivity | T025-T026 | 🟡 | 1C |
| **1G** Gate 6 RLS | T027-T028 | 🟡 | 1B |
| **1H** Gate 7 Tests | T029-T030 | 🟢 | 1B |
| **1I** Intégration workflow | T031-T034 | 🔴 | 1C, 1D |
| **1J** Mobile MCP + Visuel | T035-T038 | 🟡 | 1B |
| **1K** Boucle correction | T039-T041 | 🔴 | 1I |
| **1L** Validation LifeFlow | T042-T044 | 🔴 | 1K |
| **1M** Validation app #2 | T045-T048 | 🟡 | 1L |
| **1N** Validation app #3 | T049-T051 | 🟡 | 1M |

### Critères de passage Phase 1 → Phase 2

| # | Critère | Seuil |
|---|---------|-------|
| 1 | Apps codées bout en bout | ≥ 3 apps |
| 2 | Taux de succès des gates (auto-corrigé en ≤3 itérations) | > 80% |
| 3 | Temps moyen par app (avec supervision) | < 8h |
| 4 | Interventions humaines par app | ≤ 3 (wireframes + 1-2 décisions) |
| 5 | Build release réussi | 100% |
| 6 | Gate 1-4 passent sur tout le codebase | 100% |

---

## PHASE 2 — ORCHESTRATEUR LOCAL 🟡

> **Objectif :** Une commande → une app. Semi-automatique, supervision ponctuelle.
> **Prérequis :** Phase 1 validée (3 apps, 80% taux succès).
> **Supervision :** Ponctuelle (tu lances et tu reviens vérifier).

---

### 2A — Extraction Automatique BM → Brief

- [ ] **T052** — Créer `tools/factory/extract_brief.py` 🟡
  - Input : `business_model_*.md`
  - Output : `app-brief.yaml` (format structuré)
  - Utilise l'API Claude pour extraire : nom, modules, entities, navigation, personas
  - Valider sur 3 BM existants

- [ ] **T053** — Créer le schema `app-brief.yaml` avec validation 🟡
  - Schema YAML strict (champs requis, types, valeurs possibles)
  - Script de validation : `validate-brief.ps1`

---

### 2B — Orchestrateur factory.py

- [ ] **T054** — Créer `tools/factory/factory.py` — structure de base 🟡
  - Paramètres : `--bm`, `--dry-run`, `--skip-deploy`, `--resume`
  - Étapes séquentielles : extract_brief → clone_template → init → speckit pipeline → gates → build
  - Logging structuré (fichier + console)

- [ ] **T055** — Implémenter l'appel à clone_template.ps1 + init.ps1 🟡
  - `factory.py` appelle les scripts PowerShell existants
  - Configure `vtt.yaml` à partir du brief

- [ ] **T056** — Implémenter l'appel au pipeline SpecKit via API LLM 🟡
  - `llm_client.py` — wrapper API Claude (Anthropic SDK)
  - Appeler speckit.specify, plan, tasks via prompts structurés
  - Sauvegarder les artefacts dans `specs/`

- [ ] **T057** — Implémenter la boucle implement + gates 🟡
  - Pour chaque tâche dans `tasks.md` :
    - Générer le code via API LLM
    - Exécuter `verify-gates.ps1`
    - Si FAIL → renvoyer l'erreur au LLM pour correction (max 3x)
    - Si PASS → marquer [X]
  - Rapport final avec métriques

- [ ] **T058** — Implémenter le build automatique 🟡
  - `flutter build apk --debug` → test
  - Si Mobile MCP dispo → screenshots automatiques
  - `flutter build appbundle --release` → final

- [ ] **T059** — Tester factory.py sur une app from scratch 🟡
  - Lancer : `python factory.py --bm business_model_readflow.md`
  - Mesurer : temps total, interventions nécessaires, succès final

---

### 2C — Améliorations orchestrateur

- [ ] **T060** — Ajouter le mode `--resume` (reprendre après interruption) 🟢
  - Sauvegarder l'état après chaque tâche (fichier `.factory-state.json`)
  - Reprendre à la dernière tâche non cochée

- [ ] **T061** — Ajouter le rapport Markdown post-production 🟢
  - Générer `docs/production-report.md` après chaque app
  - Contenu : métriques gates, temps, corrections, screenshots

- [ ] **T062** — Valider l'orchestrateur sur 3 apps supplémentaires 🟡
  - Apps variées (templates différents)
  - Documenter les patterns stables vs fragiles

---

### Critères de passage Phase 2 → Phase 3

| # | Critère | Seuil |
|---|---------|-------|
| 1 | Apps codées via `factory.py` | ≥ 3 apps |
| 2 | Temps moyen par app | < 4h |
| 3 | Interventions humaines par app | ≤ 3 |
| 4 | Taux de succès pipeline complet | > 70% |

---

## PHASE 3 — VPS + TELEGRAM 🟢

> **Objectif :** Production en série depuis n'importe où. Un message Telegram → une app.
> **Prérequis :** Phase 2 validée.
> **Supervision :** Minimale (screenshots + validation ponctuelle).

---

### 3A — Infrastructure VPS

- [ ] **T063** — Provisionner un VPS (Hetzner CX41 ou équivalent) 🟢
  - Ubuntu 22.04 LTS, 8 vCPU, 16 Go RAM, 160 Go SSD
  - Installer : Flutter SDK, Android SDK, Node.js, Python, Supabase CLI
  - Configurer l'émulateur Android (KVM ou Genymotion Cloud)

- [ ] **T064** — Déployer le pipeline sur le VPS 🟢
  - Copier : `factory.py`, `verify-gates.ps1`, templates VTT, règles
  - Tester : `python factory.py --bm ...` fonctionne sur le VPS
  - Configurer les clés API (Anthropic, Supabase, etc.)

---

### 3B — Bot Telegram

- [ ] **T065** — Créer le bot Telegram de base 🟢
  - Recevoir un message + fichier BM joint
  - Répondre avec accusé de réception
  - Envoyer les wireframes pour validation
  - Recevoir "✅ Go" pour continuer

- [ ] **T066** — Intégrer le pipeline dans le bot 🟢
  - Message → `extract_brief` → `factory.py` → rapports progressifs via Telegram
  - Screenshots émulateur envoyés via Telegram
  - Rapport final avec métriques

- [ ] **T067** — Ajouter le déploiement Play Store 🟢
  - Build release → sign AAB → upload via Fastlane ou Playwright MCP
  - Remplir listing Play Store (titre, description, screenshots, politique confidentialité)
  - Notification Telegram quand l'app est en review

---

### 3C — Production en série

- [ ] **T068** — Produire 10 apps en série via le pipeline 🟢
  - Utiliser les 10 BM les plus simples/complets déjà documentés
  - Mesurer : taux succès, temps moyen, interventions
  - Ajuster les règles et gates selon les retours

- [ ] **T069** — Dashboard de suivi (optionnel) 🟢
  - Page web statique : état des apps (en cours, publiée, erreur)
  - Métriques agrégées : apps/semaine, taux succès, revenus

- [ ] **T070** — Documenter le système complet 🟢
  - Architecture finale
  - Guide d'utilisation
  - Troubleshooting
  - Préparer pour ouverture SaaS éventuelle

---

## Flux d'Exécution Recommandé

```
PRIORITÉ IMMÉDIATE (faire maintenant) :
  T001-T005 (règles)  ←─→  T006-T008 (Gate 1)     [en parallèle]
       ↓                         ↓
  T009-T016 (Gate 2)  ←─→  T017-T020 (Gate 3)     [en parallèle]
       ↓                         ↓ 
  T031-T034 (intégration workflow)
       ↓
  T039-T041 (boucle correction)
       ↓
  T042-T044 (finir LifeFlow)

ENSUITE :
  T021-T030 (Gates 4-7)  ←─→  T035-T038 (Mobile MCP)
       ↓
  T045-T051 (apps #2 et #3)

APRÈS PHASE 1 VALIDÉE :
  T052-T062 (Phase 2 orchestrateur)

APRÈS PHASE 2 VALIDÉE :
  T063-T070 (Phase 3 VPS + Telegram)
```

---

*Créé le : 2026-03-17*
*Dernière mise à jour : 2026-03-18*
*Source : certified-gate-loop.md, certified-gate-loop-part2.md, ai-app-factory.md, pipeline-strategy.md*
