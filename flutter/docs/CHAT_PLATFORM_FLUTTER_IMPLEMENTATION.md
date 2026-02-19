# 📱 Chat Platform - Guide d'Implémentation Flutter

## Prompt pour Lancer l'Implémentation

Copiez ce prompt dans une nouvelle conversation pour démarrer l'implémentation de l'app mobile Flutter :

---

```
## Contexte du Projet

Je développe une **Chat Platform** - une infrastructure de messagerie avec widgets riches, similaire à WeChat/Telegram mais pour le B2B. L'architecture est la suivante :

- **Backend FastAPI** : Complètement implémenté et testé (310 tests passants)
- **Supabase** : Base de données PostgreSQL avec auth
- **App Mobile Flutter** : À implémenter (c'est ce que je te demande)

### Business Model

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  UNE SEULE APP mobile que les utilisateurs téléchargent                            │
│  Les entreprises (providers) s'inscrivent sur la plateforme                        │
│  Les users découvrent et s'abonnent aux providers depuis l'app                     │
│  Tu contrôles l'app, l'écosystème, et les données                                  │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### API Backend Disponible

**Base URL** : `https://api.chatplatform.com/api/v1/chat-platform`

#### Authentication (Supabase Auth)
- Email/Password
- Phone
- OAuth (Google, Apple)

#### App API Endpoints (pour l'app mobile - JWT auth)
```
GET    /app/providers              # Lister les providers (découverte)
GET    /app/providers/{id}         # Détails d'un provider
POST   /app/providers/{id}/subscribe   # S'abonner à un provider
DELETE /app/providers/{id}/subscribe   # Se désabonner

GET    /app/conversations          # Mes conversations
GET    /app/conversations/{id}     # Détail conversation
GET    /app/conversations/{id}/messages  # Messages d'une conversation
POST   /app/conversations/{id}/messages  # Envoyer un message

POST   /app/widgets/{id}/interact  # Interagir avec un widget
```

#### WebSocket (Real-time)
```
WS /chat-platform/ws?token={jwt_token}

Events reçus:
- message.new          # Nouveau message
- message.updated      # Message mis à jour
- typing.start         # Provider commence à écrire
- typing.stop          # Provider arrête d'écrire
- presence.online      # Provider en ligne
- presence.offline     # Provider hors ligne

Events envoyés:
- message.send         # Envoyer un message
- typing.start         # Je commence à écrire
- typing.stop          # J'arrête d'écrire
- message.read         # Marquer comme lu
```

### Système de Widgets

Le cœur de l'app est le **Widget Engine** qui render des widgets JSON envoyés par le backend.

#### Structure d'un Message
```json
{
  "id": "msg_xxx",
  "conversation_id": "conv_xxx",
  "direction": "provider_to_user",
  "content": [
    {
      "type": "text",
      "data": { "text": "Voici nos produits !" }
    },
    {
      "type": "widget",
      "widget_type": "product_carousel",
      "widget_id": "w_xxx",
      "data": {
        "products": [
          { "id": "p1", "name": "Pizza", "price": 12.99, "image": "..." }
        ]
      }
    }
  ],
  "created_at": "2026-01-30T10:00:00Z"
}
```

#### Catalogue des Widgets à Implémenter

**Priorité 1 - Essentiels** (10 widgets)
| Widget | Description | Actions |
|--------|-------------|---------|
| `text` | Texte simple/markdown | - |
| `image` | Image avec caption | tap to fullscreen |
| `buttons` | Boutons horizontaux/verticaux | click → action |
| `quick_replies` | Chips cliquables | click → send message |
| `carousel` | Carousel horizontal | swipe, click items |
| `list` | Liste verticale | click items |
| `product_card` | Carte produit | add_to_cart, view_details |
| `form` | Formulaire multi-champs | submit |
| `date_picker` | Sélecteur date | select date |
| `loading` | Indicateur chargement | - |

**Priorité 2 - E-commerce** (5 widgets)
| Widget | Description |
|--------|-------------|
| `product_carousel` | Carousel de produits |
| `product_grid` | Grille de produits |
| `cart` | Panier avec total |
| `checkout` | Résumé + bouton payer |
| `order_status` | Statut de commande |

**Priorité 3 - Forms avancés** (5 widgets)
| Widget | Description |
|--------|-------------|
| `text_input` | Champ texte |
| `number_input` | Input numérique avec +/- |
| `select` | Dropdown |
| `multi_select` | Sélection multiple |
| `rating` | Étoiles/Score |

**Priorité 4 - Data & Feedback** (5 widgets)
| Widget | Description |
|--------|-------------|
| `alert` | Message d'alerte |
| `success` | Message de succès |
| `error` | Message d'erreur |
| `progress` | Barre de progression |
| `table` | Tableau de données |

### Architecture Flutter Recommandée

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router.dart                    # GoRouter
│   └── theme.dart
├── core/
│   ├── config/
│   │   └── environment.dart
│   ├── network/
│   │   ├── api_client.dart            # Dio + interceptors
│   │   └── websocket_client.dart      # WebSocket manager
│   └── storage/
│       └── secure_storage.dart        # Token storage
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── domain/
│   │   │   └── auth_service.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   ├── discover/
│   │   ├── data/
│   │   │   └── provider_repository.dart
│   │   ├── domain/
│   │   │   └── provider_model.dart
│   │   └── presentation/
│   │       ├── discover_screen.dart
│   │       └── provider_detail_screen.dart
│   ├── conversations/
│   │   ├── data/
│   │   │   └── conversation_repository.dart
│   │   ├── domain/
│   │   │   └── conversation_model.dart
│   │   └── presentation/
│   │       └── conversations_screen.dart
│   └── chat/
│       ├── data/
│       │   ├── message_repository.dart
│       │   └── websocket_service.dart
│       ├── domain/
│       │   └── message_model.dart
│       └── presentation/
│           ├── chat_screen.dart
│           ├── message_bubble.dart
│           └── chat_input.dart
├── widgets/                           # WIDGET ENGINE
│   ├── widget_registry.dart           # Map type → builder
│   ├── widget_renderer.dart           # Renders widget from JSON
│   ├── base/
│   │   └── chat_widget.dart           # Base class
│   ├── text/
│   │   ├── text_widget.dart
│   │   └── image_widget.dart
│   ├── actions/
│   │   ├── buttons_widget.dart
│   │   └── quick_replies_widget.dart
│   ├── lists/
│   │   ├── carousel_widget.dart
│   │   └── list_widget.dart
│   ├── forms/
│   │   ├── form_widget.dart
│   │   └── date_picker_widget.dart
│   ├── ecommerce/
│   │   ├── product_card_widget.dart
│   │   ├── cart_widget.dart
│   │   └── checkout_widget.dart
│   └── feedback/
│       ├── loading_widget.dart
│       └── alert_widget.dart
└── services/
    ├── notification_service.dart
    └── analytics_service.dart
```

### Packages Recommandés

```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  
  # Navigation
  go_router: ^13.0.0
  
  # Network
  dio: ^5.4.0
  web_socket_channel: ^2.4.0
  
  # Auth
  supabase_flutter: ^2.3.0
  
  # UI
  cached_network_image: ^3.3.0
  flutter_markdown: ^0.6.18
  shimmer: ^3.0.0
  
  # Forms
  flutter_form_builder: ^9.2.0
  
  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.0
  
  # Utils
  intl: ^0.18.0
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0

dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  riverpod_generator: ^2.3.0
```

### Widget Engine - Implémentation de Base

```dart
// widget_registry.dart
typedef WidgetBuilder = Widget Function(Map<String, dynamic> data, WidgetInteractionCallback onInteract);
typedef WidgetInteractionCallback = void Function(String action, Map<String, dynamic> payload);

class WidgetRegistry {
  static final Map<String, WidgetBuilder> _builders = {
    'text': (data, onInteract) => TextWidget(data: data),
    'image': (data, onInteract) => ImageWidget(data: data, onInteract: onInteract),
    'buttons': (data, onInteract) => ButtonsWidget(data: data, onInteract: onInteract),
    'quick_replies': (data, onInteract) => QuickRepliesWidget(data: data, onInteract: onInteract),
    'carousel': (data, onInteract) => CarouselWidget(data: data, onInteract: onInteract),
    'product_card': (data, onInteract) => ProductCardWidget(data: data, onInteract: onInteract),
    'form': (data, onInteract) => FormWidget(data: data, onInteract: onInteract),
    'date_picker': (data, onInteract) => DatePickerWidget(data: data, onInteract: onInteract),
    'loading': (data, onInteract) => const LoadingWidget(),
    // ... autres widgets
  };

  static Widget? build(String type, Map<String, dynamic> data, WidgetInteractionCallback onInteract) {
    final builder = _builders[type];
    if (builder == null) {
      return UnknownWidget(type: type);
    }
    return builder(data, onInteract);
  }
  
  static void register(String type, WidgetBuilder builder) {
    _builders[type] = builder;
  }
}
```

```dart
// widget_renderer.dart
class WidgetRenderer extends StatelessWidget {
  final Map<String, dynamic> message;
  final Function(String widgetId, String action, Map<String, dynamic> payload) onInteraction;

  const WidgetRenderer({
    required this.message,
    required this.onInteraction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final content = message['content'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content.map((item) {
        if (item['type'] == 'text') {
          return TextWidget(data: item['data']);
        }

        if (item['type'] == 'widget') {
          final widgetId = item['widget_id'] as String;
          final widgetType = item['widget_type'] as String;
          final widgetData = item['data'] as Map<String, dynamic>;

          return WidgetRegistry.build(
            widgetType,
            widgetData,
            (action, payload) => onInteraction(widgetId, action, payload),
          ) ?? const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      }).toList(),
    );
  }
}
```

### Écrans Principaux

#### 1. Discover Screen
- Barre de recherche
- Catégories horizontales (chips)
- Liste des providers (cards avec logo, nom, description, rating)
- Pull to refresh

#### 2. Conversations Screen  
- Liste des conversations actives
- Avatar provider, dernier message, timestamp
- Badge unread count
- Swipe actions (mute, delete)

#### 3. Chat Screen
- Header avec info provider
- Liste de messages (LazyLoad)
- Rendering des widgets
- Input avec attachments
- Typing indicator
- Real-time via WebSocket

### Interactions Widget → API

Quand l'utilisateur interagit avec un widget :

```dart
// Dans le ChatScreen
void _handleWidgetInteraction(String widgetId, String action, Map<String, dynamic> payload) async {
  // 1. Envoyer l'interaction au backend
  await _messageRepository.sendWidgetInteraction(
    conversationId: widget.conversationId,
    widgetId: widgetId,
    action: action,
    payload: payload,
  );
  
  // 2. Le backend notifiera le provider via webhook
  // 3. Le provider répondra avec un nouveau message
  // 4. On recevra le message via WebSocket
}
```

### État Initial du Projet

Le projet Flutter template existe déjà avec :
- Configuration de base (pubspec.yaml, analysis_options.yaml)
- Structure Stacked (mais tu peux migrer vers Riverpod)
- Supabase configuré

### Tâches à Réaliser

1. **Phase 1 - Setup** (1-2 jours)
   - [ ] Configurer l'architecture (Riverpod, GoRouter)
   - [ ] Configurer Dio avec interceptors
   - [ ] Configurer WebSocket client
   - [ ] Configurer Supabase Auth

2. **Phase 2 - Auth** (1 jour)
   - [ ] Login screen
   - [ ] Register screen  
   - [ ] Forgot password
   - [ ] Auth state management

3. **Phase 3 - Discover** (1-2 jours)
   - [ ] Provider list
   - [ ] Provider detail
   - [ ] Subscribe/Unsubscribe
   - [ ] Search & filters

4. **Phase 4 - Conversations** (1 jour)
   - [ ] Conversation list
   - [ ] Conversation model
   - [ ] Real-time updates

5. **Phase 5 - Chat** (2-3 jours)
   - [ ] Chat screen layout
   - [ ] Message bubbles
   - [ ] WebSocket integration
   - [ ] Typing indicators
   - [ ] Input with send

6. **Phase 6 - Widget Engine** (3-5 jours)
   - [ ] Widget Registry
   - [ ] Widget Renderer
   - [ ] 10 widgets Priorité 1
   - [ ] Widget interactions
   - [ ] Tests widgets

7. **Phase 7 - Polish** (1-2 jours)
   - [ ] Error handling
   - [ ] Loading states
   - [ ] Offline support basique
   - [ ] Push notifications setup

### Commencer

Commence par la **Phase 1 - Setup** en créant l'architecture de base. Assure-toi que :
1. Le client API (Dio) fonctionne avec le backend
2. Le WebSocket se connecte et reçoit des messages
3. L'auth Supabase fonctionne

Une fois le setup validé, on passera aux écrans.

```

---

## Informations Complémentaires

### Backend API Reference

Le backend FastAPI expose sa documentation OpenAPI à :
- **Swagger UI** : `http://localhost:8000/docs`
- **ReDoc** : `http://localhost:8000/redoc`

### Variables d'Environnement Flutter

```dart
// lib/core/config/environment.dart
class Environment {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8000/api/v1');
  static const String wsBaseUrl = String.fromEnvironment('WS_BASE_URL', defaultValue: 'ws://localhost:8000');
}
```

### Modèles de Données Principaux

```dart
// Provider
@freezed
class Provider with _$Provider {
  const factory Provider({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? logoUrl,
    String? category,
    double? rating,
    int? subscribersCount,
    bool? isSubscribed,
  }) = _Provider;
}

// Conversation
@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String providerId,
    required String providerName,
    String? providerLogo,
    String? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
    required String status,
  }) = _Conversation;
}

// Message
@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required String direction,
    required List<dynamic> content,
    required DateTime createdAt,
    String? status,
  }) = _Message;
}
```

### Tests Recommandés

```dart
// test/widgets/text_widget_test.dart
void main() {
  testWidgets('TextWidget renders markdown', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TextWidget(data: {'text': '**Bold** text'}),
      ),
    );
    
    expect(find.text('Bold'), findsOneWidget);
  });
}

// test/widgets/buttons_widget_test.dart
void main() {
  testWidgets('ButtonsWidget triggers callback on tap', (tester) async {
    String? tappedAction;
    
    await tester.pumpWidget(
      MaterialApp(
        home: ButtonsWidget(
          data: {
            'buttons': [
              {'label': 'Click me', 'action': 'test_action'}
            ]
          },
          onInteract: (action, payload) => tappedAction = action,
        ),
      ),
    );
    
    await tester.tap(find.text('Click me'));
    expect(tappedAction, equals('test_action'));
  });
}
```

---

## État du Backend

| Composant | Status | Tests |
|-----------|--------|-------|
| Core API | ✅ Complet | 310 tests |
| Widget System | ✅ 50+ widgets | 32 tests |
| Widget Templates | ✅ Complet | 42 tests |
| Message Scheduling | ✅ Complet | 34 tests |
| WebSocket | ✅ Complet | 30 tests |
| Analytics | ✅ Complet | - |
| Webhooks | ✅ Complet | 23 tests |

Le backend est **production-ready** et attend l'app mobile ! 🚀
