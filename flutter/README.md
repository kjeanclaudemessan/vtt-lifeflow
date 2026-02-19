# VTT Flutter Template

A comprehensive Flutter template using **Stacked (MVVM)** architecture with **Clean Architecture** principles.

---

## 📋 Table of Contents

- [Features](#-features)
- [Requirements](#-requirements)
- [Quick Start (New Project)](#-quick-start-new-project)
- [Project Structure](#-project-structure)
- [Commands](#-commands)
- [Documentation](#-documentation)

---

## ✨ Features

- 🏗️ **Stacked Architecture** (MVVM + Clean Architecture)
- 🎨 **Design System** with tokens (colors, typography, spacing)
- 🌐 **Internationalization** (i18n) ready
- 🔐 **Authentication** module (configurable)
- 🌍 **Multi-environment** support (dev, staging, prod)
- 🤖 **GitHub Copilot** configuration (instructions, prompts, agents)
- ✅ **Testing** setup (unit, widget, golden tests)
- 📱 **Responsive** design utilities

### 🔌 Built-in Services

| Service                   | Package              | Description                      |
| ------------------------- | -------------------- | -------------------------------- |
| 🔐 **Biometric Auth**     | `local_auth`         | Fingerprint & Face ID            |
| 📱 **Push Notifications** | `firebase_messaging` | FCM push notifications           |
| 📊 **Analytics**          | `firebase_analytics` | Event tracking & user properties |
| 🐛 **Error Reporting**    | `sentry_flutter`     | Crash reporting & monitoring     |
| 🔗 **Deep Links**         | `app_links`          | Universal links & app links      |
| 📤 **Share**              | `share_plus`         | Share content to other apps      |
| 🔒 **Permissions**        | `permission_handler` | Runtime permissions              |
| 💾 **Offline Sync**       | `hive`               | Local data persistence           |
| ☁️ **Storage**            | `supabase`           | File upload/download             |

---

## 📦 Requirements

- [Flutter](https://flutter.dev/docs/get-started/install) 3.x
- [FVM](https://fvm.app/) (recommended for Flutter version management)
- [Dart](https://dart.dev/get-dart) 3.x

---

## 🚀 Quick Start (New Project)

### 1. Clone the Template

```bash
git clone https://github.com/your-org/vtt_flutter_template.git my_new_app
cd my_new_app
```

### 2. Remove Git History (Start Fresh)

```bash
rm -rf .git
git init
git add .
git commit -m "chore: initial commit from template"
```

### 3. Rename the Project

#### Option A: Using a Script (Recommended)

```bash
# On macOS/Linux
./scripts/rename_project.sh my_new_app com.mycompany.mynewapp

# On Windows (PowerShell)
.\scripts\rename_project.ps1 -Name "my_new_app" -BundleId "com.mycompany.mynewapp"
```

#### Option B: Manual Renaming

1. **pubspec.yaml** - Change `name`:

   ```yaml
   name: my_new_app
   description: My awesome Flutter app
   ```

2. **Android** - Update package name:
   - `android/app/build.gradle.kts`: Change `namespace` and `applicationId`
   - Rename folder structure: `android/app/src/main/kotlin/com/example/...`
   - Update `AndroidManifest.xml` if needed

3. **iOS** - Update bundle identifier:
   - Open `ios/Runner.xcodeproj` in Xcode
   - Select Runner > General > Bundle Identifier
   - Or edit `ios/Runner.xcodeproj/project.pbxproj`

4. **Web** - Update `web/index.html`:

   ```html
   <title>My New App</title>
   ```

5. **Run** to regenerate:

   ```bash
   flutter clean
   flutter pub get
   ```

### 4. Setup Flutter Version (FVM)

```bash
# Install FVM if not already
dart pub global activate fvm

# Use the project's Flutter version
fvm install
fvm use
```

### 5. Install Dependencies

```bash
flutter pub get
```

### 6. Generate Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 7. Configure Environment

#### Using .env files (Recommended)

```bash
# Copy the example
cp .env.example .env.dev

# Edit with your values
code .env.dev
```

Required variables:

Required variables:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SENTRY_DSN=https://key@sentry.io/id  # Optional
```

#### Setup Firebase (for Analytics & Push Notifications)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure (generates firebase_options.dart)
flutterfire configure
```

See [docs/SETUP.md](docs/SETUP.md) for detailed configuration.

### 8. Run the App

```bash
# Development with env file
flutter run --dart-define-from-file=.env.dev

# Or simply (uses defaults)
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart                    # Production entry point
├── main_dev.dart                # Development entry point
├── main_staging.dart            # Staging entry point
│
├── app/                         # Stacked configuration
│   ├── app.dart                 # @StackedApp annotation
│   ├── app.locator.dart         # Service Locator (generated)
│   └── app.router.dart          # Router (generated)
│
├── core/                        # Shared foundations
│   ├── config/                  # App configuration
│   ├── constants/               # Global constants
│   ├── errors/                  # Failures & exceptions
│   ├── extensions/              # Dart extensions
│   └── utils/                   # Utility functions
│
├── data/                        # Data layer
│   ├── models/                  # JSON serializable models
│   ├── repositories/            # Repository implementations
│   └── datasources/             # Data sources
│
├── domain/                      # Domain layer (pure)
│   ├── entities/                # Business entities
│   ├── repositories/            # Repository contracts
│   └── usecases/                # Business use cases
│
├── services/                    # Technical services
│   ├── api/                     # HTTP client
│   ├── auth/                    # Authentication
│   └── storage/                 # Local storage
│
├── features/                    # Feature modules
│   ├── auth/                    # Authentication feature
│   ├── home/                    # Home feature
│   └── settings/                # Settings feature
│
├── ui/                          # Shared UI
│   ├── views/                   # System views
│   ├── widgets/                 # Reusable widgets
│   └── dialogs/                 # Dialogs
│
├── design_system/               # Design System
│   ├── theme/                   # Themes
│   ├── colors/                  # Color palette
│   ├── typography/              # Text styles
│   └── spacing/                 # Spacing tokens
│
└── l10n/                        # Internationalization
    └── arb/                     # Translation files
```

---

## 🛠️ Commands

### Development

```bash
# Run in development
flutter run --target lib/main_dev.dart

# Run in staging
flutter run --target lib/main_staging.dart

# Run in production
flutter run --target lib/main.dart --release

# Run on specific device
flutter run -d chrome
flutter run -d windows
flutter run -d <device_id>
```

### Code Generation

```bash
# Generate Stacked files (locator, router, etc.)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes)
dart run build_runner watch --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Update golden files
flutter test --update-goldens

# Run specific test
flutter test test/viewmodels/home_viewmodel_test.dart
```

### Localization

```bash
# Generate localization files
flutter gen-l10n
```

### Stacked CLI

```bash
# Create a new view
stacked create view login

# Create a new service
stacked create service analytics

# Create a new bottom sheet
stacked create bottom_sheet confirmation

# Create a new dialog
stacked create dialog alert
```

### Build

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Build Web
flutter build web --release
```

---

## 📚 Documentation

| Document                                                  | Description                         |
| --------------------------------------------------------- | ----------------------------------- |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md)                   | Detailed architecture documentation |
| [COPILOT_CONFIGURATION.md](docs/COPILOT_CONFIGURATION.md) | GitHub Copilot setup                |

### Copilot Instructions

This template includes GitHub Copilot configuration:

- **12 instruction files** for different component types
- **11 reusable prompts** for common tasks
- **4 specialized agents** for architecture, testing, docs, and review

See `.github/` folder for all configurations.

---

## 🔧 Customization Checklist

After cloning, complete this checklist:

- [ ] Rename project (pubspec.yaml, Android, iOS, Web)
- [ ] Update app icons (`flutter_launcher_icons`)
- [ ] Configure splash screen (`flutter_native_splash`)
- [ ] Set up environments (API URLs, keys)
- [ ] Customize design system (colors, typography)
- [ ] Add project-specific Copilot instructions (`.github/instructions/project.instructions.md`)
- [ ] Update this README for your project
- [ ] Configure CI/CD (GitHub Actions, etc.)
- [ ] Set up Firebase/Supabase if needed

---

## 📄 License

This template is provided as-is for internal use.

---

## Golden Tests

Golden tests are already setup for this project. To run the tests and update the golden files, run:

```bash
flutter test --update-goldens
```

The golden test screenshots will be stored under `test/golden/`.
