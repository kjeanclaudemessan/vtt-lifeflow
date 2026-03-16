# 🏭 AI App Factory — Système Autonome de Développement d'Apps Mobiles

> **"Décris une app. L'IA la code, la teste, la corrige et la publie."**

**Version :** 1.0  
**Date :** 15 Mars 2026  
**Statut :** 🔄 En cours — Phase Architecture  
**Auteur :** Personnel  

---

## 📋 Table des Matières

1. [Le Concept](#1-le-concept)
2. [Le Problème Résolu](#2-le-problème-résolu)
3. [Architecture du Système](#3-architecture-du-système)
4. [Toolchain Complète](#4-toolchain-complète)
5. [Configuration MCP](#5-configuration-mcp)
6. [Pipeline de Développement](#6-pipeline-de-développement)
7. [Stratégie Templates](#7-stratégie-templates)
8. [Portfolio d'Apps (100+)](#8-portfolio-dapps-100)
9. [Analyse Concurrentielle](#9-analyse-concurrentielle)
10. [Business Model & SaaS](#10-business-model--saas)
11. [Roadmap d'Implémentation](#11-roadmap-dimplémentation)
12. [Risques & Mitigations](#12-risques--mitigations)
13. [Stack Technique Détaillé](#13-stack-technique-détaillé)
14. [Références & Liens](#14-références--liens)

---

## 1. Le Concept

### 1.1 Vision

Un **système IA autonome** capable de transformer une description textuelle d'application mobile en une app Flutter complète, testée et publiée sur le Google Play Store. Le tout pilotable **depuis n'importe où via Telegram**.

### 1.2 Principe Fondamental

```
Description textuelle → IA génère le code Flutter + Supabase
                      → Build automatique
                      → Test sur émulateur Android
                      → Correction automatique des bugs
                      → Déploiement sur Google Play Store
```

### 1.3 Cas d'Usage Principal

J'ai **100+ applications mobiles** à développer (voir `PROJECTS_CATALOG.md`). Plutôt que de coder chacune manuellement pendant des mois, le système les produit en série :

- **Input** : Description de l'app + business model + catégorie
- **Process** : L'IA code, build, test, corrige en boucle autonome
- **Output** : APK/AAB signé + listing Play Store + app déployée

### 1.4 Accès à Distance

Via un **bot Telegram**, je peux depuis mon téléphone :
- Lancer la création d'une nouvelle app
- Suivre le progrès en temps réel
- Recevoir des screenshots de l'émulateur
- Valider ou demander des modifications
- Déclencher le déploiement

---

## 2. Le Problème Résolu

### 2.1 Le Coût Actuel

| Méthode | Coût/App | Temps/App | Pour 100 apps |
|---------|----------|-----------|---------------|
| Développeur freelance | $5 000 - $50 000 | 1-6 mois | $500K - $5M + 8-50 ans |
| Agence de dev | $20 000 - $200 000 | 3-12 mois | $2M - $20M + 25-100 ans |
| Solo (moi-même) | $0 (temps) | 2-6 mois | 16-50 ans |
| **AI App Factory** | **$5 - $20** (API) | **2-8 heures** | **$500 - $2000 + 1-3 mois** |

### 2.2 Ce Qui N'Existe Pas Encore

Aucun outil actuel ne fait le pipeline complet **pour les apps mobiles natives** :
- **Bolt.new** (16.3K ⭐) → Web uniquement, pas de mobile natif
- **Lovable / v0.dev** → Web uniquement (React)
- **Cursor / Windsurf** → IDE assisté, pas autonome
- **OpenHands** (69.2K ⭐) → Code autonome mais pas de test emulateur ni déploiement mobile
- **FlutterFlow** → No-code Flutter, pas IA autonome
- **Replit Agent** → Web apps principalement

**→ Le gap : personne ne fait "description → app mobile native → test → Play Store" de bout en bout.**

---

## 3. Architecture du Système

### 3.1 Vue d'Ensemble

```
┌─────────────┐     ┌──────────────────────┐     ┌─────────────────┐
│  TELEGRAM   │────▶│   ORCHESTRATEUR      │────▶│  MCP SERVERS    │
│  Bot API    │◀────│   (Copilot SDK +     │◀────│                 │
│             │     │    Claude/GPT)        │     │  ┌────────────┐ │
└─────────────┘     │                      │     │  │ Mobile MCP │ │
                    │  • Planification     │     │  │ (émulateur)│ │
                    │  • Génération code   │     │  ├────────────┤ │
                    │  • Orchestration     │     │  │ Playwright │ │
                    │  • Correction bugs   │     │  │ (browser)  │ │
                    │  • Déploiement       │     │  ├────────────┤ │
                    └──────────────────────┘     │  │ Supabase   │ │
                              │                  │  │ MCP        │ │
                              ▼                  │  ├────────────┤ │
                    ┌──────────────────┐         │  │ Sequential │ │
                    │  SYSTÈME LOCAL   │         │  │ Thinking   │ │
                    │                  │         │  ├────────────┤ │
                    │  • Flutter SDK   │         │  │ Filesystem │ │
                    │  • Android SDK   │         │  │ MCP        │ │
                    │  • Émulateur AVD │         │  ├────────────┤ │
                    │  • ADB           │         │  │ Computer   │ │
                    │  • Fastlane      │         │  │ Control    │ │
                    │  • Firebase CLI  │         │  └────────────┘ │
                    └──────────────────┘         └─────────────────┘
```

### 3.2 Flux de Données Détaillé

```
1. RÉCEPTION
   Telegram Bot → reçoit message utilisateur
   → Parse la demande (nouvelle app / modification / statut)

2. PLANIFICATION (Sequential Thinking MCP)
   → Décompose l'app en modules/pages/features
   → Identifie le template le plus adapté
   → Génère le plan de développement

3. GÉNÉRATION CODE (Copilot SDK + LLM)
   → Applique le template Flutter sélectionné
   → Génère le code Dart (UI + logique)
   → Génère les schémas Supabase (tables, RLS, Edge Functions)
   → Écrit les fichiers via Filesystem MCP

4. SETUP BASE DE DONNÉES (Supabase MCP)
   → Crée le projet Supabase (ou utilise un existant)
   → Applique les migrations SQL
   → Configure les Row Level Security policies
   → Crée les Edge Functions si nécessaire

5. BUILD & TEST (Mobile MCP + ADB)
   → flutter build apk --debug
   → Installe sur émulateur Android
   → Mobile MCP prend des screenshots
   → Mobile MCP navigue dans l'app (click, type, scroll)
   → Vérifie que chaque écran fonctionne

6. CORRECTION (Boucle autonome)
   → Si erreur de build → analyse les logs, corrige le code
   → Si crash → analyse le stack trace, corrige
   → Si UI cassée → screenshot + analyse visuelle, corrige
   → Reboucle jusqu'à 0 erreurs (max 10 itérations)

7. NAVIGATION WEB (Playwright MCP)
   → Se connecte à Google Play Console
   → Crée la fiche de l'app (titre, description, screenshots)
   → Configure Firebase (si nécessaire)
   → Upload le listing sur le Store

8. DÉPLOIEMENT (Fastlane + ADB)
   → flutter build appbundle --release
   → Signe l'APK/AAB avec la keystore
   → Upload via Fastlane ou Playwright MCP
   → Vérifie le statut de publication

9. NOTIFICATION
   → Envoie les résultats via Telegram
   → Screenshots finaux de l'app
   → Lien Play Store (quand approuvé)
```

---

## 4. Toolchain Complète

### 4.1 Les 8 Couches du Système

| # | Couche | Outil | Rôle | Lien |
|---|--------|-------|------|------|
| 1 | **Interface** | Telegram Bot API | Point d'entrée utilisateur, contrôle à distance | https://core.telegram.org/bots/api |
| 2 | **Orchestrateur** | GitHub Copilot SDK | Cerveau central, coordination des agents et MCP | https://github.com/nicepkg/copilot-sdk (ou SDK officiel) |
| 3 | **Raisonnement** | Sequential Thinking MCP | Planification multi-étapes, décomposition de tâches | `@modelcontextprotocol/server-sequential-thinking` |
| 4 | **Coding** | LLM (Claude/GPT) via Copilot SDK | Génération du code Flutter + Dart | Via le SDK |
| 5 | **Base de Données** | Supabase MCP | Gestion tables, migrations, RLS, Edge Functions | MCP Supabase officiel |
| 6 | **Test Émulateur** | Mobile MCP | Automatisation de l'émulateur Android, screenshots, interaction UI | `@mobilenext/mobile-mcp` |
| 7 | **Navigation Web** | Playwright MCP | Google Play Console, Firebase Console, Google Cloud Console | `@playwright/mcp` |
| 8 | **Build & Deploy** | Flutter SDK + Fastlane + ADB | Compilation, signature, upload Play Store | CLI tools |
| 9 | **Contrôle PC** | computer-control-mcp | Contrôle souris/clavier/écran du PC si besoin | `AB498/computer-control-mcp` |
| 10 | **Fichiers** | Filesystem MCP | Lecture/écriture de fichiers sur le disque | `@modelcontextprotocol/server-filesystem` |

### 4.2 Détail de Chaque Outil Clé

#### 🔧 GitHub Copilot SDK
- **Version** : v0.1.32 (Technical Preview)
- **Langages** : Python, Node.js, Go, .NET
- **Fonctionnalités** :
  - BYOK (Bring Your Own Key) — utiliser Claude, GPT, Gemini, etc.
  - Intégration native des MCP Servers
  - Custom tools, agents, skills
  - Gestion des conversations multi-turn
- **Rôle dans le système** : Le chef d'orchestre. Il reçoit les commandes de Telegram, planifie les étapes, appelle les MCP, génère le code, et coordonne le tout.

#### 📱 Mobile MCP (`@mobilenext/mobile-mcp`)
- **Version** : v0.0.47
- **Stars** : 3 900+
- **Licence** : Apache-2.0
- **Plateformes** : iOS Simulator + Android Emulator
- **Modes** :
  - **Accessibility Tree** (par défaut) : Parse l'arbre d'accessibilité en JSON structuré → déterministe, rapide, fiable
  - **Screenshot** (fallback) : Capture d'écran + analyse visuelle par le LLM → quand l'arbre d'accessibilité ne suffit pas
- **Transport** : SSE (Server-Sent Events) pour accès distant
  - `npx @anthropic-ai/mobile-mcp@latest --port 10000` → accessible sur réseau
- **10 Outils disponibles** :
  | Outil | Description |
  |-------|-------------|
  | `mobile_screenshot` | Capture d'écran de l'émulateur |
  | `mobile_list_elements` | Liste tous les éléments UI (arbre d'accessibilité) |
  | `mobile_click` | Tap sur un élément (par texte, ID, ou coordonnées) |
  | `mobile_type` | Saisit du texte dans un champ |
  | `mobile_swipe` | Swipe dans une direction |
  | `mobile_scroll` | Scroll dans une direction |
  | `mobile_double_tap` | Double tap |
  | `mobile_press_key` | Appui sur une touche (home, back, enter...) |
  | `mobile_launch_app` | Lance une app par package name |
  | `mobile_screen_recording` | Enregistre une vidéo de l'écran |
- **Pré-requis** :
  - Android SDK + émulateur AVD configuré
  - ADB fonctionnel
  - Node.js 18+

#### 🌐 Playwright MCP (`@playwright/mcp`)
- **Version** : v0.0.68
- **Stars** : 28 900+
- **Éditeur** : Microsoft
- **Licence** : Apache-2.0
- **Modes** :
  - **Accessibility Tree** : Navigation par structure sémantique (robuste)
  - **Screenshot** : Navigation visuelle (fallback)
- **Transport** : SSE via `--port 8931`
- **Fonctionnalités clés** :
  - **Profil utilisateur persistant** : Reste connecté aux comptes Google entre sessions (`--user-data-dir`)
  - Mode headless pour exécution serveur
  - Gestion multi-onglets
  - Capture réseau, console, stockage
- **Cas d'usage dans le système** :
  - Connexion à Google Play Console → créer app, remplir listing, upload screenshots/AAB
  - Connexion à Firebase Console → configurer projet, obtenir clés
  - Connexion à Google Cloud Console → activer APIs, créer credentials
  - Upload d'assets, configuration des politiques de confidentialité, etc.
- **Configuration** :
  ```json
  {
    "command": "npx",
    "args": ["@playwright/mcp@latest", "--user-data-dir", "./playwright-profile"],
    "env": {}
  }
  ```

#### 🧠 Sequential Thinking MCP
- **Package** : `@modelcontextprotocol/server-sequential-thinking`
- **Rôle** : Permet au LLM de résoudre des problèmes complexes étape par étape
- **Usage** : Planification de l'architecture de chaque app, décomposition en tâches, raisonnement sur les erreurs
- **Capacités** :
  - Enchaînement de pensées structurées
  - Possibilité de réviser et corriger le raisonnement
  - Création de branches alternatives

#### 🗃 Supabase MCP
- **Rôle** : Gestion complète de la couche backend
- **Capacités** :
  - Création de tables et relations
  - Application de migrations SQL
  - Configuration des Row Level Security (RLS) policies
  - Gestion des Edge Functions (Deno)
  - Gestion du Storage (fichiers, images)
  - Configuration de l'authentification

---

## 5. Configuration MCP

### 5.1 Configuration Complète (mcp.json)

```json
{
  "mcpServers": {
    "mobile-mcp": {
      "command": "npx",
      "args": [
        "@anthropic-ai/mobile-mcp@latest",
        "--avd-name", "Pixel_7_API_34",
        "--port", "10000"
      ],
      "env": {
        "ANDROID_HOME": "C:\\Users\\LENOVO\\AppData\\Local\\Android\\Sdk"
      }
    },
    "playwright": {
      "command": "npx",
      "args": [
        "@playwright/mcp@latest",
        "--user-data-dir", "./playwright-profile"
      ],
      "env": {}
    },
    "supabase": {
      "command": "npx",
      "args": ["supabase-mcp-server"],
      "env": {
        "SUPABASE_ACCESS_TOKEN": "<SUPABASE_TOKEN>",
        "SUPABASE_PROJECT_REF": "<PROJECT_REF>"
      }
    },
    "sequential-thinking": {
      "command": "npx",
      "args": [
        "@modelcontextprotocol/server-sequential-thinking"
      ]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "@modelcontextprotocol/server-filesystem",
        "F:\\programmation\\perso"
      ]
    },
    "computer-control": {
      "command": "python",
      "args": [
        "computer-control-mcp/server.py"
      ],
      "env": {}
    }
  }
}
```

### 5.2 Pré-requis Système

| Composant | Version Minimum | Installation |
|-----------|----------------|--------------|
| **Node.js** | 18+ | `winget install OpenJS.NodeJS.LTS` |
| **Python** | 3.10+ | `winget install Python.Python.3.12` |
| **Flutter SDK** | 3.x | https://flutter.dev/docs/get-started/install |
| **Android SDK** | API 34+ | Via Android Studio |
| **Android Emulator** | AVD Pixel 7 | Via Android Studio AVD Manager |
| **ADB** | Inclus Android SDK | `$env:ANDROID_HOME\platform-tools\adb` |
| **Fastlane** | 2.x | `gem install fastlane` (Ruby requis) |
| **Supabase CLI** | Latest | `npm install -g supabase` |
| **Firebase CLI** | Latest | `npm install -g firebase-tools` |

### 5.3 Variables d'Environnement Requises

```env
# API Keys LLM
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...

# Telegram Bot
TELEGRAM_BOT_TOKEN=123456:ABC-DEF...
TELEGRAM_CHAT_ID=123456789

# Supabase
SUPABASE_ACCESS_TOKEN=sbp_...
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# Android
ANDROID_HOME=C:\Users\LENOVO\AppData\Local\Android\Sdk

# Google Play
GOOGLE_PLAY_JSON_KEY=path/to/service-account.json

# Signing
KEYSTORE_PATH=path/to/upload-keystore.jks
KEYSTORE_PASSWORD=...
KEY_ALIAS=upload
KEY_PASSWORD=...
```

---

## 6. Pipeline de Développement

### 6.1 Les 9 Étapes Automatisées

```
┌─────────────────────────────────────────────────────────────────┐
│                    PIPELINE AI APP FACTORY                       │
├─────┬───────────────────┬───────────────────────────────────────┤
│  #  │ Étape             │ Outils Utilisés                      │
├─────┼───────────────────┼───────────────────────────────────────┤
│  1  │ Réception         │ Telegram Bot API                     │
│  2  │ Planification     │ Sequential Thinking MCP + LLM        │
│  3  │ Sélection Template│ Filesystem MCP + catalogue templates │
│  4  │ Génération Code   │ LLM (Claude/GPT) + Filesystem MCP   │
│  5  │ Setup Backend     │ Supabase MCP                         │
│  6  │ Build             │ Flutter CLI (via terminal)           │
│  7  │ Test Émulateur    │ Mobile MCP + ADB                     │
│  8  │ Correction        │ LLM + Logs analyse (boucle max 10x) │
│  9  │ Déploiement       │ Fastlane + Playwright MCP            │
└─────┴───────────────────┴───────────────────────────────────────┘
```

### 6.2 Boucle de Correction Autonome

```
WHILE erreurs > 0 AND itérations < 10:
  1. flutter build apk --debug 2>&1
  2. IF build_error:
       → LLM analyse l'erreur Dart/Flutter
       → Corrige le fichier source
       → CONTINUE
  3. adb install -r app-debug.apk
  4. Mobile MCP → lance l'app
  5. Mobile MCP → screenshot + list_elements
  6. IF crash_detected:
       → ADB logcat → récupère stack trace
       → LLM analyse et corrige
       → CONTINUE
  7. FOR each screen in app_screens:
       → Mobile MCP → navigate to screen
       → Mobile MCP → screenshot
       → LLM → analyse visuelle (UI correcte ?)
       → IF UI_problem → corrige et CONTINUE
  8. IF all_ok → BREAK

RESULT: App fonctionnelle ou rapport d'erreur après 10 tentatives
```

### 6.3 Déploiement Google Play Store

```
1. BUILD RELEASE
   flutter build appbundle --release

2. SIGN
   jarsigner -keystore upload-keystore.jks app-release.aab upload

3. GOOGLE PLAY CONSOLE (via Playwright MCP)
   → Naviguer vers play.google.com/console
   → Utiliser le profil persistant (déjà connecté)
   → Créer l'app OU mettre à jour l'existante
   → Remplir le listing :
     - Titre, description courte/longue
     - Catégorie, tags
     - Upload screenshots (générés depuis l'émulateur)
     - Upload de l'AAB
     - Politique de confidentialité
   → Soumettre pour review

4. ALTERNATIVE : Fastlane
   fastlane supply \
     --aab app-release.aab \
     --json_key service-account.json \
     --package_name com.mondomaine.appname \
     --track production
```

---

## 7. Stratégie Templates

### 7.1 Pourquoi des Templates ?

Les templates sont le **moat compétitif** du système. Plutôt que de générer chaque app from scratch, on utilise des architectures pré-validées qui :
- Réduisent le temps de génération de 80%
- Garantissent une qualité de code constante
- Incluent les bonnes pratiques (state management, routing, auth)
- Sont déjà testés et fonctionnels

### 7.2 Les 6 Catégories de Templates

#### 📦 Template 1 : E-Commerce / Marketplace
- **Apps concernées** : LivraisonPro, CommandeBot, ServicesPro, ReceiptSnap
- **Modules** : Catalogue produits, panier, paiement (Mobile Money/Stripe), profils vendeur/acheteur, suivi commandes, notifications push
- **Supabase** : Tables `products`, `orders`, `users`, `payments`, `reviews`
- **Pages** : Home feed, détail produit, panier, checkout, profil, historique

#### 🏢 Template 2 : Gestion / Service
- **Apps concernées** : PressingSync, RentMaster, StockManager, EventPro, ChantierPro, AutoPaie, LouerFacile, FleetMaster
- **Modules** : CRUD entities, tableau de bord, rapports, gestion clients, facturation, calendrier, notifications
- **Supabase** : Tables dynamiques selon le domaine, `clients`, `invoices`, `transactions`
- **Pages** : Dashboard, liste, détail, formulaire CRUD, rapports/stats, paramètres

#### 👥 Template 3 : Communauté / Social
- **Apps concernées** : ChurchFlow, ChurchLib, SocialFlow, CoupleFlow, ParentFlow, FamilyFlow
- **Modules** : Fil d'actualité, groupes, événements, messagerie, partage contenu, profils
- **Supabase** : Tables `posts`, `groups`, `events`, `messages`, `members`
- **Pages** : Feed, groupes, événements, chat, profil, paramètres

#### 💰 Template 4 : Finance / Tontine
- **Apps concernées** : WealthFlow, TontineFlow, MomoTracker, CréditScore, TenantPay
- **Modules** : Suivi transactions, budgets, objectifs, rapports financiers, alertes, graphiques
- **Supabase** : Tables `transactions`, `budgets`, `goals`, `categories`, `recurring`
- **Pages** : Dashboard (graphiques), liste transactions, budget, objectifs, rapports

#### 🎓 Template 5 : Éducation / Formation
- **Apps concernées** : PrepExam, LingoFlow, SalesTrainer, SkillUp, TutorMatch, QuizMaster, FlashcardPro
- **Modules** : Leçons, quiz, flashcards, progression, spaced repetition, gamification, classements
- **Supabase** : Tables `lessons`, `quizzes`, `progress`, `scores`, `badges`
- **Pages** : Home (progression), leçon, quiz, résultats, classement, profil

#### 🏥 Template 6 : Santé / Bien-être
- **Apps concernées** : IronFlow, MedReminder, Meditation, DoctorFlow, PregnancyFlow, BabyTracker, MentalHealth
- **Modules** : Suivi quotidien, rappels, journal, graphiques de progression, objectifs, exercices guidés
- **Supabase** : Tables `entries`, `reminders`, `goals`, `exercises`, `metrics`
- **Pages** : Dashboard (progression), journal, rappels, exercices, stats, profil

### 7.3 Architecture Flutter Standard (tous templates)

```
lib/
├── main.dart
├── app.dart
├── config/
│   ├── theme.dart          # Design system (couleurs, typo, spacing)
│   ├── router.dart         # GoRouter configuration
│   ├── constants.dart      # Constantes app
│   └── env.dart            # Variables d'environnement
├── core/
│   ├── services/
│   │   ├── supabase_service.dart
│   │   ├── auth_service.dart
│   │   ├── notification_service.dart
│   │   └── storage_service.dart
│   ├── models/             # Data models (Freezed)
│   ├── providers/          # Riverpod providers
│   └── utils/              # Helpers, extensions
├── features/
│   ├── auth/
│   │   ├── screens/        # Login, Register, Forgot Password
│   │   ├── widgets/        # Auth-specific widgets
│   │   └── providers/      # Auth state
│   ├── home/
│   ├── profile/
│   └── [feature_specific]/
├── shared/
│   ├── widgets/            # Boutons, cards, inputs réutilisables
│   ├── layouts/            # Scaffold, navigation
│   └── extensions/
└── l10n/                   # Internationalisation (fr, en)
```

### 7.4 Stack Flutter Standard

| Dépendance | Rôle |
|------------|------|
| `flutter_riverpod` | State management |
| `go_router` | Navigation/routing |
| `supabase_flutter` | Backend Supabase |
| `freezed` + `json_serializable` | Data models immuables |
| `flutter_hooks` | Lifecycle hooks |
| `cached_network_image` | Images avec cache |
| `fl_chart` | Graphiques |
| `intl` | Internationalisation & formatting |
| `flutter_local_notifications` | Notifications locales |
| `firebase_messaging` | Push notifications |
| `image_picker` | Sélection photos |
| `shared_preferences` | Stockage local léger |
| `connectivity_plus` | Détection réseau |
| `flutter_animate` | Animations |

---

## 8. Portfolio d'Apps (100+)

### 8.1 Apps Existantes (22 documentées)

| Série | Apps | Business Models |
|-------|------|-----------------|
| 🌊 **Flow** (9) | IronFlow, LifeFlow, WealthFlow, ReadFlow, SpiritFlow, StyleFlow, MindFlow, VictoryFlow, PresenceFlow | ✅ Tous documentés |
| 🏪 **Business Afrique** (6) | ForgePro, BizPlan Africa, PressingSync, RentMaster, StockManager, EventPro | ✅ Tous documentés |
| 🎓 **EdTech** (3) | PrepExam, LingoFlow, SalesTrainer | ✅ Tous documentés |
| 📱 **Autres** (3) | Meditation, LiveCapture, ImportTrack | ✅ Tous documentés |
| ⛪ **Église** (1) | ChurchFlow | ✅ Documenté |

### 8.2 Apps à Créer (78+)

Voir `PROJECTS_CATALOG.md` pour la liste complète.

**Séries planifiées** : Santé (6), Famille (5), Transport (4), Immobilier (4), Création (4), IA/Innovation (3), + extensions des séries existantes.

### 8.3 Ordre de Production (Stratégie)

**Phase 1 — Les apps internes (apps pour moi)** : 5-10 apps Flow pour valider le système
**Phase 2 — Les apps à forte demande** : Business Afrique (problèmes réels, clients existants)
**Phase 3 — Volume** : Toutes les autres séries, 5-10 apps/semaine

---

## 9. Analyse Concurrentielle

### 9.1 Comparaison Détaillée

| Critère | AI App Factory | Bolt.new | Lovable | Cursor | OpenHands | FlutterFlow |
|---------|---------------|----------|---------|--------|-----------|-------------|
| **Mobile natif** | ✅ Flutter | ❌ Web | ❌ Web | ⚠️ Manuel | ⚠️ Manuel | ✅ Flutter |
| **Autonome** | ✅ Complet | ✅ Web | ✅ Web | ❌ Assisté | ✅ | ❌ No-code |
| **Test émulateur** | ✅ Auto | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Deploy Play Store** | ✅ Auto | ❌ | ❌ | ❌ | ❌ | ✅ Manuel |
| **Backend** | ✅ Supabase auto | ✅ Intégré | ✅ Supabase | ❌ Manuel | ⚠️ | ✅ Firebase |
| **Templates métier** | ✅ 6 catégories | ❌ | ❌ | ❌ | ❌ | ✅ Marketplace |
| **Accès distant** | ✅ Telegram | ✅ Browser | ✅ Browser | ❌ Desktop | ✅ Browser | ✅ Browser |
| **Correction auto** | ✅ Boucle 10x | ⚠️ Limitée | ⚠️ Limitée | ❌ | ✅ | ❌ |
| **Prix/app** | ~$5-20 | $20+/mois | $20+/mois | $20+/mois | Open source | $30+/mois |
| **Stars GitHub** | N/A (perso) | 16.3K | N/A | N/A | 69.2K | N/A |

### 9.2 Avantage Concurrentiel Unique

**Personne ne fait le pipeline complet pour le mobile natif :**

```
Description → Code Flutter → Build → Test Émulateur → Correction → Sign → Deploy Play Store
       ↑                                                                           ↓
       └── Feedback Telegram ←──── Screenshots ←──── Validation ←─────────────────┘
```

C'est la différence entre :
- Un outil qui **t'aide** à coder (Cursor, Copilot)
- Un outil qui **code pour toi** sur le web (Bolt.new)
- Un système qui **produit des apps mobiles finies et publiées** (AI App Factory)

---

## 10. Business Model & SaaS

### 10.1 Phase 1 — Usage Interne (Mois 1-6)

**Objectif** : Produire mes propres 100+ apps

| Métrique | Valeur |
|----------|--------|
| Coût API / app | $5 - $20 (tokens LLM) |
| Temps / app | 2-8 heures |
| Coût total 100 apps | $500 - $2 000 |
| Revenus potentiels (freemium) | $5 - $50/mois/app × 100 apps |
| **Revenu cible mensuel** | **$500 - $5 000/mois** (après traction) |

### 10.2 Phase 2 — SaaS B2D (Mois 6-18)

**Transformer en service pour développeurs** :

| Offre | Prix | Cible |
|-------|------|-------|
| **Starter** | $99/mois | Développeurs solo, 5 apps/mois |
| **Pro** | $299/mois | Agences, 20 apps/mois |
| **Enterprise** | $999/mois | Organisations, illimité |

**Proposition de valeur SaaS** :
- "Décrivez votre app → recevez l'APK en 4h"
- Templates adaptés au marché africain
- Backend Supabase inclus et pré-configuré
- Play Store listing pré-rempli
- Support des langues locales

### 10.3 Phase 3 — Marketplace B2B (Mois 18+)

- Marketplace de templates contribués par la communauté
- API publique pour intégrer le pipeline dans d'autres outils
- Partenariats avec des accélérateurs/incubateurs africains
- White-label pour agences de dev

### 10.4 Économie par App

```
Revenus potentiels / app publiée :
  - Freemium : 100-1000 utilisateurs × 5-10% conversion × $3-10/mois
  - Publicité : $0.50-2 CPM × trafic
  - B2B : $50-500/mois/entreprise

Coût de production / app :
  - API LLM : $5-20
  - Supabase (free tier) : $0
  - Play Store fee : $25 (une fois)
  - Temps humain : ~30 min de supervision

Marge brute : ~85-90%
```

---

## 11. Roadmap d'Implémentation

### 11.1 Sprint 1 — Fondations (Semaine 1-2)

- [ ] Installer et configurer tous les pré-requis (Flutter, Android SDK, émulateur, Node.js)
- [ ] Installer les MCP Servers (Mobile MCP, Playwright MCP, Sequential Thinking, Filesystem)
- [ ] Créer le projet orchestrateur (Node.js ou Python)
- [ ] Intégrer le Copilot SDK / ou API Claude directe
- [ ] Tester chaque MCP individuellement
- [ ] Créer le bot Telegram de base (recevoir/envoyer messages)

### 11.2 Sprint 2 — Templates (Semaine 3-4)

- [ ] Créer le Template 1 (E-Commerce) - Flutter + Supabase
- [ ] Créer le Template 2 (Gestion/Service) - Flutter + Supabase
- [ ] Créer le Template 3 (Communauté) - Flutter + Supabase
- [ ] Tester chaque template : build, install sur émulateur, validation
- [ ] Créer le design system commun (couleurs, typo, composants)
- [ ] Documenter les points de personnalisation de chaque template

### 11.3 Sprint 3 — Pipeline Génération (Semaine 5-6)

- [ ] Implémenter la phase Planification (Sequential Thinking → plan de dev)
- [ ] Implémenter la phase Génération (LLM → code Flutter à partir du template)
- [ ] Implémenter la phase Build (flutter build via terminal)
- [ ] Implémenter la boucle de correction (parse erreurs → corrige → rebuild)
- [ ] Intégrer Supabase MCP (création automatique tables + RLS)
- [ ] Premier test end-to-end : description → app fonctionnelle

### 11.4 Sprint 4 — Test & Validation (Semaine 7-8)

- [ ] Implémenter le test émulateur (Mobile MCP → navigation automatique)
- [ ] Implémenter l'analyse visuelle des screenshots
- [ ] Boucle complète : build → install → test → correction → rebuild
- [ ] Tester avec 5 apps différentes de catégories différentes
- [ ] Mesurer les métriques : temps, taux de succès, nombre d'itérations

### 11.5 Sprint 5 — Déploiement (Semaine 9-10)

- [ ] Implémenter la signature APK/AAB
- [ ] Configurer Fastlane pour upload Play Store
- [ ] Implémenter la navigation Play Console via Playwright MCP
- [ ] Premier déploiement complet (description → Play Store)
- [ ] Automatiser les screenshots pour le listing Store

### 11.6 Sprint 6 — Production (Semaine 11-12)

- [ ] Intégrer le bot Telegram complet (suivi, validation, notifications)
- [ ] Stabiliser le pipeline (gestion d'erreurs, retry, logging)
- [ ] Produire les 10 premières apps de la série Flow
- [ ] Documenter les leçons apprises
- [ ] Planifier la phase SaaS (si résultats convaincants)

---

## 12. Risques & Mitigations

| # | Risque | Probabilité | Impact | Mitigation |
|---|--------|-------------|--------|------------|
| 1 | **LLM génère du code non-fonctionnel** | Haute | Fort | Templates pré-validés + boucle de correction (10 itérations max) + tests automatisés |
| 2 | **APIs LLM changent ou augmentent les prix** | Moyenne | Moyen | Multi-provider (Claude, GPT, Gemini) via BYOK du Copilot SDK. Pas de vendor lock-in |
| 3 | **Google Play rejette les apps** | Moyenne | Fort | Templates conformes aux policies, metadata de qualité, privacy policy auto-générée |
| 4 | **Mobile MCP instable** | Faible | Moyen | Fallback sur ADB directement + vision screenshots. Le projet est actif (3.9K ⭐) |
| 5 | **Copilot SDK en Preview** | Moyenne | Moyen | Alternative : utiliser l'API Claude/OpenAI directement + appels MCP manuels |
| 6 | **Google détecte génération IA et pénalise** | Faible | Fort | Personnalisation suffisante par template, contenu unique par app, reviews manuelles sur les premières |
| 7 | **Complexité d'intégration trop élevée** | Moyenne | Fort | Approche incrémentale : chaque sprint livre une brique fonctionnelle indépendante |
| 8 | **Qualité UI générée insuffisante** | Moyenne | Moyen | Design system strict + templates UI pré-validés + Figma/Pen export si besoin |

---

## 13. Stack Technique Détaillé

### 13.1 Langage de l'Orchestrateur

**Recommandation : TypeScript (Node.js)**

| Critère | TypeScript | Python |
|---------|-----------|--------|
| Copilot SDK | ✅ Support natif | ✅ Support natif |
| MCP SDK | ✅ `@modelcontextprotocol/sdk` | ✅ `mcp` |
| Telegram Bot | ✅ `telegraf` / `grammy` | ✅ `python-telegram-bot` |
| Async/Concurrency | ✅ Event loop natif | ✅ asyncio |
| Flutter CLI | ✅ child_process | ✅ subprocess |
| Cohérence (Flutter = Dart ≈ TS) | ✅ Syntaxe proche | ⚠️ Syntaxe différente |

### 13.2 Structure du Projet Orchestrateur

```
ai-app-factory/
├── src/
│   ├── index.ts              # Entry point
│   ├── bot/
│   │   ├── telegram.ts       # Telegram bot handler
│   │   └── commands.ts       # Bot commands (create, status, deploy...)
│   ├── orchestrator/
│   │   ├── pipeline.ts       # Pipeline principal
│   │   ├── planner.ts        # Phase planification
│   │   ├── generator.ts      # Phase génération code
│   │   ├── builder.ts        # Phase build Flutter
│   │   ├── tester.ts         # Phase test émulateur
│   │   ├── corrector.ts      # Phase correction boucle
│   │   └── deployer.ts       # Phase déploiement
│   ├── mcp/
│   │   ├── client.ts         # MCP client manager
│   │   ├── mobile.ts         # Mobile MCP wrapper
│   │   ├── playwright.ts     # Playwright MCP wrapper
│   │   ├── supabase.ts       # Supabase MCP wrapper
│   │   └── thinking.ts       # Sequential Thinking wrapper
│   ├── templates/
│   │   ├── ecommerce/        # Template E-Commerce
│   │   ├── management/       # Template Gestion
│   │   ├── community/        # Template Communauté
│   │   ├── finance/          # Template Finance
│   │   ├── education/        # Template Éducation
│   │   └── health/           # Template Santé
│   ├── config/
│   │   ├── mcp.json          # Configuration MCP
│   │   ├── templates.json    # Catalogue templates
│   │   └── env.ts            # Environment variables
│   └── utils/
│       ├── logger.ts         # Logging structuré
│       ├── flutter-cli.ts    # Wrapper Flutter commands
│       ├── adb.ts            # Wrapper ADB commands
│       └── fastlane.ts       # Wrapper Fastlane
├── templates/                 # Flutter templates source
│   ├── base/                  # Architecture de base commune
│   ├── ecommerce/
│   ├── management/
│   ├── community/
│   ├── finance/
│   ├── education/
│   └── health/
├── playwright-profile/        # Profil browser persistant
├── .env                       # Variables d'environnement
├── package.json
├── tsconfig.json
└── README.md
```

### 13.3 Dépendances Node.js de l'Orchestrateur

```json
{
  "dependencies": {
    "@anthropic-ai/sdk": "latest",
    "@modelcontextprotocol/sdk": "latest",
    "grammy": "latest",
    "zod": "latest",
    "winston": "latest",
    "dotenv": "latest",
    "execa": "latest"
  },
  "devDependencies": {
    "typescript": "latest",
    "tsx": "latest",
    "@types/node": "latest"
  }
}
```

---

## 14. Références & Liens

### 14.1 Outils & MCP Servers

| Outil | GitHub | Stars |
|-------|--------|-------|
| Mobile MCP | https://github.com/anthropics/mobile-mcp | 3 900+ |
| Playwright MCP | https://github.com/microsoft/playwright-mcp | 28 900+ |
| Sequential Thinking MCP | https://github.com/modelcontextprotocol/servers | Officiel |
| Computer Control MCP | https://github.com/AB498/computer-control-mcp | 122 |
| Computer Use MCP | https://github.com/domdomegg/computer-use-mcp | 149 |
| Copilot SDK | https://github.com/nicepkg/copilot-sdk | Preview |
| OpenHands | https://github.com/All-Hands-AI/OpenHands | 69 200+ |

### 14.2 Concurrents Étudiés

| Concurrent | Type | Mobile | Lien |
|-----------|------|--------|------|
| Bolt.new | Web dev IA | ❌ | https://bolt.new |
| Lovable | Web dev IA | ❌ | https://lovable.dev |
| v0.dev | UI generation | ❌ | https://v0.dev |
| Cursor | IDE assisté | ⚠️ | https://cursor.com |
| FlutterFlow | No-code Flutter | ✅ | https://flutterflow.io |
| Replit Agent | Web dev IA | ❌ | https://replit.com |
| OpenClaw | Assistant IA perso | ❌ | https://github.com/openclaw/openclaw |

### 14.3 Documentation Stack

| Doc | Lien |
|-----|------|
| Flutter | https://flutter.dev/docs |
| Dart | https://dart.dev/guides |
| Supabase | https://supabase.com/docs |
| Riverpod | https://riverpod.dev |
| GoRouter | https://pub.dev/packages/go_router |
| Fastlane | https://docs.fastlane.tools |
| Telegram Bot API | https://core.telegram.org/bots/api |
| MCP Specification | https://modelcontextprotocol.io |

### 14.4 Documents Internes Liés

| Document | Chemin |
|----------|--------|
| Catalogue des Projets | `app_docs/PROJECTS_CATALOG.md` |
| Architecture Écosystème | `app_docs/apps_ecosystem_architecture.md` |
| Vision Nexus | `app_docs/NEXUS_PLATFORM_VISION.md` |
| Critères de Sélection | `app_docs/PROJECT_CRITERIA.md` |
| Plan 1 Milliard | `app_docs/ONE_BILLION_PLAN.md` |
| Business Models (par app) | `app_docs/business_model_*.md` |

---

## 15. Commandes de Référence Rapide

### Émulateur Android
```bash
# Lister les AVDs
emulator -list-avds

# Lancer l'émulateur
emulator -avd Pixel_7_API_34 -no-snapshot

# Vérifier la connexion ADB
adb devices

# Installer une app
adb install -r build/app/outputs/flutter-apk/app-debug.apk

# Récupérer les logs
adb logcat -d | grep -i "flutter\|dart\|error"

# Screenshot
adb exec-out screencap -p > screenshot.png
```

### Flutter
```bash
# Créer un projet
flutter create --org com.mondomaine mon_app

# Build debug
flutter build apk --debug

# Build release
flutter build appbundle --release

# Analyser le code
flutter analyze

# Lancer les tests
flutter test
```

### MCP Servers
```bash
# Mobile MCP
npx @anthropic-ai/mobile-mcp@latest --avd-name Pixel_7_API_34

# Playwright MCP
npx @playwright/mcp@latest --user-data-dir ./playwright-profile

# Sequential Thinking
npx @modelcontextprotocol/server-sequential-thinking
```

### Fastlane
```bash
# Initialiser
fastlane init

# Déployer sur Play Store
fastlane supply --aab app-release.aab --json_key key.json --track production
```

---

*Créé le : 2026-03-15*  
*Dernière mise à jour : 2026-03-15*  
*Statut : 🔄 En cours — Phase Architecture & Planification*
