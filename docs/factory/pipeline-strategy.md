# Pipeline Strategy — Du BM Local à l'App Déployée

> **"Un Business Model en entrée → une app publiée en sortie."**

**Version :** 1.0  
**Date :** 16 Mars 2026  
**Statut :** Conception  
**Lien :** [AI App Factory](ai-app-factory.md) | [Certified Gate Loop — Partie 1](certified-gate-loop.md) | [Partie 2](certified-gate-loop-part2.md)

---

## Table des Matières

1. [Le Flux Actuel](#1-le-flux-actuel)
2. [L'Évolution en 3 Phases](#2-lévolution-en-3-phases)
3. [Phase 1 : Local (PC + VS Code)](#3-phase-1--local-pc--vs-code)
4. [Phase 2 : Orchestrateur Local](#4-phase-2--orchestrateur-local)
5. [Phase 3 : VPS + Telegram](#5-phase-3--vps--telegram)
6. [Le Brief Structuré — L'Input Standardisé](#6-le-brief-structuré--linput-standardisé)
7. [Critères de Migration Local → VPS](#7-critères-de-migration-local--vps)
8. [Décisions d'Architecture](#8-décisions-darchitecture)

---

## 1. Le Flux Actuel

Aujourd'hui, pour créer une nouvelle app depuis le template VTT :

```
1. Éditer vtt.yaml (nom, modules, preset)
2. Lancer clone_template.ps1 → copie le template
3. Lancer init.ps1 → configure, supprime modules désactivés, renomme
4. Ouvrir dans VS Code
5. Passer le Business Model à Copilot
6. Suivre le pipeline SpecKit manuellement :
   speckit.specify → speckit.plan → speckit.tasks → speckit.implement
7. Coder feature par feature, tâche par tâche
8. Build, tester, corriger, déployer
```

**Ce qui fonctionne :** le template, le pipeline SpecKit, les instructions Copilot, le design system.

**Ce qui manque :** l'automatisation entre "voici le BM" et "voici l'app certifiée". C'est le gap que le Certified Gate Loop et l'orchestrateur doivent combler.

---

## 2. L'Évolution en 3 Phases

```
Phase 1 (maintenant)          Phase 2 (intermédiaire)         Phase 3 (cible)
┌──────────────────┐          ┌──────────────────┐            ┌──────────────────┐
│   Mon PC          │          │   Mon PC          │            │   VPS distant     │
│   VS Code         │          │   Script Python   │            │   Telegram Bot    │
│   Copilot Agent   │          │   Orchestrateur   │            │   Web UI          │
│                   │          │                   │            │                   │
│   Manuel +        │          │   Semi-auto       │            │   Full auto       │
│   Certified Gates │          │   Une commande    │            │   Un message      │
└──────────────────┘          └──────────────────┘            └──────────────────┘
         │                              │                              │
    Supervision                    Supervision                   Screenshots
    constante                     ponctuelle                    + validation
    ~8h/app                        ~2h/app                      ~30min/app
```

---

## 3. Phase 1 : Local (PC + VS Code)

### 3.1 Ce qu'on fait

- **Où :** PC local, VS Code avec Copilot
- **Interface :** VS Code chat + terminal
- **Supervision :** Constante (toi devant l'écran)
- **Objectif :** Valider que le pipeline SpecKit + Certified Gates produit du code de qualité

### 3.2 Le workflow concret

```
1. Tu ouvres le BM (business_model_lifeflow.md)
2. Tu lances speckit.specify → Copilot génère spec.md + wireframes
3. Tu valides les wireframes (5 min de review)
4. Tu lances speckit.plan → plan.md, data-model.md
5. Tu lances speckit.tasks → tasks.md
6. Tu lances speckit.implement :
   - Copilot code tâche par tâche
   - Les Certified Gates vérifient après chaque tâche :
     Gate 1: dart analyze + compilation
     Gate 2: patterns grep (Either, Equatable, DS components...)
     Gate 3: imports architecture
     Gate 4: experience 3-layer
   - Si un gate échoue → Copilot corrige → re-gate
7. Build + test sur émulateur (Mobile MCP si configuré)
8. Corrections finales
```

### 3.3 Pourquoi commencer local

| Raison | Détail |
|--------|--------|
| **Debugging facile** | Tu vois tout en temps réel dans VS Code quand le pipeline casse |
| **Itération rapide** | Ajuster gates, règles, prompts sans latence réseau |
| **Coût zéro d'infra** | Pas de VPS à payer tant que ça ne marche pas |
| **Émulateur performant** | Mobile MCP a besoin de GPU pour l'AVD — un VPS sans GPU = lent ou impossible |
| **Apprentissage** | Tu comprends les limites et les patterns qui marchent |

### 3.4 Livrables de la Phase 1

- [ ] `verify-gates.ps1` — script de gates exécutables (Gate 1-4)
- [ ] `wireframe-rules.md` — règles de structure d'écran
- [ ] `decisions.md` — empreinte du créateur
- [ ] `content-rules.md` — ton, icônes, seeds
- [ ] 3 apps codées bout en bout avec le pipeline
- [ ] Taux de succès des gates documenté

---

## 4. Phase 2 : Orchestrateur Local

### 4.1 Ce qu'on fait

- **Où :** PC local, terminal
- **Interface :** Une seule commande Python
- **Supervision :** Ponctuelle (tu lances et tu reviens vérifier)
- **Objectif :** Automatiser le flux clone → configure → speckit → gates → build

### 4.2 La commande cible

```powershell
# Lancer la création complète
python factory.py --bm business_model_lifeflow.md

# Avec options
python factory.py --bm business_model_lifeflow.md --dry-run       # Preview sans coder
python factory.py --bm business_model_lifeflow.md --skip-deploy   # Stop avant déploiement
python factory.py --bm business_model_lifeflow.md --resume         # Reprendre après interruption
```

### 4.3 Ce que fait l'orchestrateur

```python
# factory.py — Orchestrateur local (~500 lignes)

def create_app(bm_path: str):
    """Pipeline complet : BM → App certifiée."""

    # ── Étape 1 : Extraire le brief structuré du BM ──────────────
    brief = extract_brief(bm_path)        # BM → app-brief.yaml
    log(f"Brief extrait : {brief.name}, {len(brief.modules)} modules")

    # ── Étape 2 : Cloner le template ─────────────────────────────
    project_dir = clone_template(brief)    # clone_template.ps1
    configure_vtt_yaml(project_dir, brief) # Remplir vtt.yaml
    run_init(project_dir)                  # init.ps1

    # ── Étape 3 : SpecKit Pipeline ────────────────────────────────
    spec = run_speckit_specify(project_dir, brief)  # → spec.md
    plan = run_speckit_plan(project_dir, spec)       # → plan.md + data-model.md
    tasks = run_speckit_tasks(project_dir, plan)     # → tasks.md

    # ── Étape 4 : Checkpoint humain (wireframes) ─────────────────
    notify("Wireframes prêtes. Review ?", screenshots=spec.wireframes)
    await_human_validation()  # Optionnel — skip si --auto

    # ── Étape 5 : Implémentation avec gates ──────────────────────
    for task in tasks:
        implement_task(project_dir, task)   # LLM code la tâche
        gate_result = run_gates(project_dir)  # Gates 1-4

        retries = 0
        while not gate_result.passed and retries < 3:
            fix_from_gate(project_dir, gate_result)  # LLM corrige
            gate_result = run_gates(project_dir)
            retries += 1

        if not gate_result.passed:
            notify(f"⚠️ Tâche bloquée : {task.title}")
            await_human_intervention()

    # ── Étape 6 : Build + Test visuel ─────────────────────────────
    build_debug_apk(project_dir)
    if mobile_mcp_available():
        visual_result = run_visual_gates(project_dir)  # Gate 6
    
    # ── Étape 7 : Rapport final ───────────────────────────────────
    report = generate_report(project_dir, tasks, gate_results)
    notify("✅ App prête", report=report)
```

### 4.4 L'orchestrateur n'est PAS le Copilot SDK

Le Copilot SDK (v0.1.32) est en Technical Preview — trop instable pour un pipeline de production. Pour la Phase 2 :

| Approche | Recommandé |
|----------|-----------|
| Copilot SDK | ❌ Pas encore — trop tôt, API instable |
| API Claude directe (Anthropic) | ✅ Stable, contrôle total |
| API OpenAI directe | ✅ Alternative stable |
| Script Python + subprocess | ✅ Pour les commandes CLI (flutter, dart, git) |

L'orchestrateur est un **script Python de ~500 lignes**, pas un framework lourd. Il appelle les API LLM pour la génération et les CLI pour le build/test.

### 4.5 Livrables de la Phase 2

- [ ] `factory.py` — orchestrateur principal
- [ ] `extract_brief.py` — BM → app-brief.yaml
- [ ] `gate_runner.py` — exécution des gates
- [ ] `llm_client.py` — wrapper API Claude/GPT
- [ ] Résumé après chaque app (rapport Markdown)

---

## 5. Phase 3 : VPS + Telegram

### 5.1 Ce qu'on fait

- **Où :** VPS distant (Linux)
- **Interface :** Bot Telegram + Web UI optionnelle
- **Supervision :** Minimale (screenshots + validation)
- **Objectif :** Produire des apps en série, depuis n'importe où

### 5.2 Le flux Telegram

```
Toi (Telegram)                          VPS
─────────────                           ────
"Crée LifeFlow"                    →    Reçoit commande
+ fichier BM joint                 →    Sauvegarde le BM

                                        extract_brief()
                                        clone_template()
                                        speckit.specify()

"Voici les wireframes.             ←    Envoie wireframes ASCII
 Valide ?"                              + screenshots si Pencil MCP

"✅ Go"                            →    Continue pipeline

                                        speckit.plan()
                                        speckit.tasks()
                                        speckit.implement() + gates

"Tâche 12/24 — Gate 2 échoué.     ←    Rapport d'avancement
 Correction auto en cours..."

"✅ 24/24 tâches. Build OK.        ←    Screenshots émulateur
 Voici les screenshots."

"Parfait, déploie"                 →    Build release + upload

"✅ AAB uploadé sur Play Console.  ←    Lien Play Console
 En attente de review Google."
```

### 5.3 Infrastructure VPS

| Composant | Recommandation | Coût/mois |
|-----------|---------------|-----------|
| **VPS** | Hetzner CX41 (8 vCPU, 16 Go RAM) | ~€15 |
| **GPU** (optionnel) | Hetzner GPU instance ou pas d'émulateur | ~€50 si GPU |
| **Stockage** | 160 Go SSD | Inclus |
| **OS** | Ubuntu 22.04 LTS | Inclus |
| **Alternative émulateur** | Genymotion Cloud ou test sur vrai device | $30/mois |

### 5.4 Problème de l'émulateur sur VPS

L'émulateur Android standard nécessite KVM (virtualisation matérielle) :
- **Hetzner dedicated** : KVM disponible ✅
- **Hetzner cloud** : KVM disponible sur certaines instances ✅  
- **Alternative** : Genymotion Cloud (émulateur dans le cloud, accès API)
- **Alternative** : Tester sur un vrai téléphone connecté en USB au VPS (ADB over network)

### 5.5 Livrables de la Phase 3

- [ ] Bot Telegram fonctionnel
- [ ] VPS configuré (Flutter SDK, Android SDK, émulateur)
- [ ] Pipeline complet automatisé de bout en bout
- [ ] Dashboard web statique (optionnel) — état des apps en production

---

## 6. Le Brief Structuré — L'Input Standardisé

### 6.1 Pourquoi le BM ne suffit pas directement

Le Business Model (`business_model_lifeflow.md`) fait 700+ lignes. C'est riche et utile pour comprendre le produit, mais l'IA a besoin d'un **résumé structuré** pour :
- Sélectionner le bon template
- Générer les wireframes avec les bonnes règles
- Configurer `vtt.yaml`
- Structurer les modules

### 6.2 Format app-brief.yaml

```yaml
# app-brief.yaml — Généré automatiquement depuis le BM
# C'est la première étape du pipeline : BM → brief

app:
  name: lifeflow
  display_name: LifeFlow
  tagline: "Vis selon tes valeurs. Chaque jour compte."
  bundle_id: com.mondomaine.lifeflow
  category: productivity

template: gestion  # e-commerce | gestion | communaute | finance | education | sante

modules:
  core:
    - auth
    - profile
    - settings
    - notifications
  business:
    - organizations: false
    - invitations: false
    - payments: false
    - subscriptions: true
  custom:
    - foundation       # Valeurs, Vision, Domaines de vie
    - objectives        # OKR, Key Results
    - habits            # Habitudes liées aux KR
    - routines          # Séquences d'étapes avec timer
    - time_blocks       # Blocs de temps avec tâches
    - tasks             # Tâches & Projets
    - calendar          # Calendrier unifié
    - time_budget       # Budget temps par domaine
    - reviews           # Revues quotidien/hebdo/mensuel

navigation:
  type: bottom_nav
  tabs:
    - id: home
      label: Accueil
      icon: home
      screen: dashboard
    - id: calendar
      label: Calendrier
      icon: calendar
      screen: unified_calendar
    - id: tasks
      label: Tâches
      icon: check_square
      screen: task_list
    - id: stats
      label: Stats
      icon: bar_chart_3
      screen: time_budget_dashboard
    - id: settings
      label: Paramètres
      icon: settings
      screen: settings_grouped

entities:
  - name: life_domain
    fields: [name, icon, weekly_hours_target, monthly_hours_target, tracking_mode, score]
    relations: [has_many: themes, has_many: habits, has_many: time_blocks]

  - name: theme
    fields: [name, icon, progress]
    relations: [belongs_to: life_domain, has_many: annual_goals]

  - name: annual_goal
    fields: [year, title, progress]
    relations: [belongs_to: theme, has_many: okrs]

  - name: okr
    fields: [quarter, objective, progress]
    relations: [belongs_to: annual_goal, has_many: key_results]

  - name: key_result
    fields: [title, target_value, current_value, unit]
    relations: [belongs_to: okr, has_many: habits]

  - name: habit
    fields: [name, frequency, duration_minutes, app_link, streak]
    relations: [belongs_to: life_domain, belongs_to: key_result]

  - name: routine
    fields: [name, time_of_day]
    relations: [has_many: routine_steps]

  - name: routine_step
    fields: [title, duration_minutes, order_index, app_link]
    relations: [belongs_to: routine, belongs_to: habit]

  - name: time_block
    fields: [date, start_time, end_time, block_type, label, actual_duration, focus_score]
    relations: [belongs_to: life_domain, belongs_to: project, has_many: tasks]

  - name: task
    fields: [title, priority, scheduled_date, estimated_minutes, actual_minutes, completed]
    relations: [belongs_to: project, belongs_to: time_block]

  - name: project
    fields: [name, progress]
    relations: [belongs_to: okr, has_many: tasks]

  - name: domain_time_log
    fields: [date, source_type, source_id, minutes]
    relations: [belongs_to: life_domain]

integrations:
  deep_links: [spiritflow, ironflow, lingoflow, readflow]
  sync_time: true

monetization:
  model: freemium
  free_limits:
    habits: 5
    routines: 1
    tasks: 20
    domains: 3
  pro_price_monthly: 6.99
  pro_price_yearly: 49.99

personas:
  primary: "Thomas, 30 ans, entrepreneur, veut connecter ses valeurs à ses actions quotidiennes"
  pain: "Utilise 5 apps séparées, ne sait pas combien de temps il consacre à chaque domaine de vie"
```

### 6.3 Extraction automatique

L'étape 1 du pipeline est **BM → brief**. L'IA (Claude/GPT) lit le BM complet et génère ce YAML structuré. C'est un prompt simple et fiable car c'est de l'extraction/structuration, pas de la création.

```python
def extract_brief(bm_path: str) -> AppBrief:
    """Extrait un brief structuré depuis un Business Model."""
    bm_content = read_file(bm_path)
    
    prompt = f"""
    Analyse ce Business Model et génère un app-brief.yaml structuré.
    Suis exactement le format YAML défini dans le schema.
    
    Business Model:
    {bm_content}
    
    Schema attendu:
    {BRIEF_SCHEMA}
    """
    
    response = llm.generate(prompt, model="claude-sonnet")
    return parse_yaml(response)
```

---

## 7. Critères de Migration Local → VPS

### 7.1 Quand migrer

**Pas avant que le pipeline soit fiable à 90%+ en local.**

Critères concrets à valider :

| # | Critère | Seuil | Mesuré comment |
|---|---------|-------|----------------|
| 1 | Apps codées bout en bout | ≥ 3 apps | Compteur |
| 2 | Taux de succès des gates | > 80% auto-corrigé | Gate logs |
| 3 | Temps moyen par app | < 4h (sans supervision constante) | Timer |
| 4 | Interventions humaines par app | ≤ 3 (wireframes + 1-2 décisions) | Compteur |
| 5 | Build release réussi | 100% | Résultat build |

### 7.2 Ce qui change entre local et VPS

| Aspect | Local | VPS |
|--------|-------|-----|
| **LLM** | API Claude/GPT (identique) | API Claude/GPT (identique) |
| **Flutter SDK** | Installé localement | Installé sur VPS |
| **Émulateur** | AVD local (GPU) | KVM ou Genymotion Cloud |
| **Interface** | Terminal + VS Code | Telegram Bot |
| **Notifications** | Pas nécessaire | Telegram messages |
| **Stockage code** | Disque local | Disque VPS + Git push |
| **Monitoring** | Toi devant l'écran | Logs + Telegram alerts |

### 7.3 Ce qui reste identique

- Le pipeline `factory.py` (même code)
- Les gates (mêmes scripts)
- Les règles (wireframe-rules, decisions.md, constitution)
- Les templates VTT
- Les prompts SpecKit
- Le format app-brief.yaml

**Le VPS est juste un "autre PC" — le pipeline ne change pas.**

---

## 8. Décisions d'Architecture

### 8.1 Pourquoi pas le Copilot SDK dès maintenant

| Pour | Contre |
|------|--------|
| Intégration native MCP | Technical Preview (v0.1.32) — instable |
| Multi-LLM (Claude, GPT, Gemini) | API peut changer sans préavis |
| Gestion conversations built-in | Overhead pour un pipeline séquentiel |

**Décision :** API Claude directe (Anthropic SDK Python) pour Phase 1-2. Réévaluer le Copilot SDK quand il sort en stable (probablement fin 2026).

### 8.2 Pourquoi Python pour l'orchestrateur

| Alternative | Verdict |
|-------------|---------|
| **Python** ✅ | Anthropic SDK natif, subprocess pour CLI, rapide à écrire |
| Node.js | Possible mais le SDK Anthropic Python est plus mature |
| PowerShell | Trop limité pour la logique d'orchestration complexe |
| Go/.NET | Overkill pour un script de ~500 lignes |

### 8.3 Pourquoi pas Telegram dès la Phase 1

| Phase | Interface | Raison |
|-------|-----------|--------|
| 1 | Terminal | Tu es devant l'écran, pas besoin de notifications distantes |
| 2 | Terminal + résumé Markdown | Semi-auto, tu lances et tu reviens |
| 3 | Telegram | Tu n'es plus devant l'écran, tu supervises depuis le téléphone |

**Telegram est une couche d'UI, pas un composant du pipeline.** L'ajouter trop tôt complexifie sans bénéfice.

---

## Annexe : Relation avec les autres documents

| Document | Relation |
|----------|----------|
| [AI App Factory](ai-app-factory.md) | La vision complète (100+ apps, SaaS, toolchain). Ce document-ci est la **stratégie d'exécution**. |
| [Certified Gate Loop — Partie 1](certified-gate-loop.md) | Le système de gates qui certifie chaque tâche. Utilisé à l'étape 5 du pipeline. |
| [Certified Gate Loop — Partie 2](certified-gate-loop-part2.md) | Les wireframe rules et la validation visuelle. Utilisés aux étapes 2 et 7. |

```
AI App Factory (QUOI) ─────────── "Le système qui produit des apps en série"
         │
Pipeline Strategy (COMMENT) ──── "D'abord local, puis VPS, en 3 phases"  ← CE DOCUMENT
         │
Certified Gate Loop (QUALITÉ) ── "Comment garantir que chaque app est correcte"
```

---

*Créé le : 2026-03-16*  
*Dernière mise à jour : 2026-03-16*  
*Statut : Conception*
