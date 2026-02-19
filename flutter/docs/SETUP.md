# 🚀 Project Setup Guide

Complete guide for setting up a new project from this template.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Clone the Template](#2-clone-the-template)
3. [Rename the Project](#3-rename-the-project)
4. [Configure Environments](#4-configure-environments)
5. [Customize Design System](#5-customize-design-system)
6. [Setup Backend](#6-setup-backend)
7. [Configure CI/CD](#7-configure-cicd)
8. [Final Checklist](#8-final-checklist)

---

## 1. Prerequisites

### Required Tools

| Tool    | Version | Installation                                                |
| ------- | ------- | ----------------------------------------------------------- |
| Flutter | 3.x     | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart    | 3.x     | Included with Flutter                                       |
| FVM     | Latest  | `dart pub global activate fvm`                              |
| Git     | Latest  | [git-scm.com](https://git-scm.com/)                         |

### Verify Installation

```bash
flutter --version
dart --version
fvm --version
git --version
```

---

## 2. Clone the Template

### Option A: GitHub Template (Recommended)

1. Go to the template repository on GitHub
2. Click "Use this template" → "Create a new repository"
3. Clone your new repository:
   ```bash
   git clone https://github.com/your-org/your-new-app.git
   cd your-new-app
   ```

### Option B: Manual Clone

```bash
# Clone the template
git clone https://github.com/your-org/vtt_flutter_template.git my_new_app
cd my_new_app

# Remove template git history
rm -rf .git

# Initialize fresh git
git init
git add .
git commit -m "chore: initial commit from template"

# Add your remote
git remote add origin https://github.com/your-org/your-new-app.git
git push -u origin main
```

---

## 3. Rename the Project

### Automatic Renaming (Recommended)

```bash
# Windows (PowerShell)
.\scripts\rename_project.ps1 -Name "my_app" -BundleId "com.mycompany.myapp"

# macOS/Linux
chmod +x scripts/rename_project.sh
./scripts/rename_project.sh my_app com.mycompany.myapp
```

### Manual Renaming

If scripts don't work, follow these steps:

#### 3.1 pubspec.yaml

```yaml
name: my_app # Change this
description: My awesome Flutter application # Change this
version: 1.0.0+1
```

#### 3.2 Android Configuration

**android/app/build.gradle.kts:**

```kotlin
android {
    namespace = "com.mycompany.myapp"  // Change this

    defaultConfig {
        applicationId = "com.mycompany.myapp"  // Change this
        // ...
    }
}
```

**Rename Kotlin package:**

1. Navigate to `android/app/src/main/kotlin/`
2. Rename folder structure from `com/example/vtt_flutter_template/` to match your bundle ID
3. Update `MainActivity.kt` package declaration:
   ```kotlin
   package com.mycompany.myapp  // Change this
   ```

#### 3.3 iOS Configuration

**Option A: Xcode (Recommended)**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner in the project navigator
3. Under "General" → "Identity", change Bundle Identifier
4. Under "Signing & Capabilities", update Team

**Option B: Manual**
Edit `ios/Runner.xcodeproj/project.pbxproj`:

- Search and replace `com.example.vtt_flutter_template` with your bundle ID

#### 3.4 Web Configuration

**web/index.html:**

```html
<title>My App</title>
```

**web/manifest.json:**

```json
{
  "name": "My App",
  "short_name": "MyApp"
  // ...
}
```

#### 3.5 Desktop Configuration

**linux/CMakeLists.txt:**

```cmake
set(BINARY_NAME "my_app")
```

**windows/CMakeLists.txt:**

```cmake
set(BINARY_NAME "my_app")
```

**macos:** Update bundle identifier in Xcode

#### 3.6 Update Dart Imports

Search and replace in all `.dart` files:

- From: `package:vtt_flutter_template/`
- To: `package:my_app/`

#### 3.7 Regenerate

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

## 4. Configure Environments

### 4.1 Environment Files

Edit the configuration files in `lib/core/config/env/`:

**dev_config.dart** (Development):

```dart
class DevConfig implements EnvConfig {
  @override
  String get apiBaseUrl => 'https://api-dev.yourcompany.com/v1';

  @override
  String get supabaseUrl => 'https://xxx.supabase.co';

  @override
  String get supabaseAnonKey => 'your-dev-anon-key';

  // ... other settings
}
```

**staging_config.dart** (Staging):

```dart
class StagingConfig implements EnvConfig {
  @override
  String get apiBaseUrl => 'https://api-staging.yourcompany.com/v1';
  // ...
}
```

**prod_config.dart** (Production):

```dart
class ProdConfig implements EnvConfig {
  @override
  String get apiBaseUrl => 'https://api.yourcompany.com/v1';
  // ...
}
```

### 4.2 Secrets Management

**Never commit secrets to git!**

#### Option A: Using .env files (Recommended)

1. Copy the example file:

   ```bash
   cp .env.example .env.dev
   cp .env.example .env.staging
   cp .env.example .env.prod
   ```

2. Edit each file with your values:

   ```env
   # .env.dev
   API_BASE_URL=https://api-dev.yourcompany.com/v1
   SUPABASE_URL=http://127.0.0.1:54321
   SUPABASE_ANON_KEY=your-local-anon-key
   SENTRY_DSN=
   ```

3. Run with the env file:

   ```bash
   # Development
   flutter run --dart-define-from-file=.env.dev

   # Production build
   flutter build apk --dart-define-from-file=.env.prod
   ```

#### Option B: Using --dart-define

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-key \
  --dart-define=SENTRY_DSN=https://key@sentry.io/id
```

Access in code:

```dart
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
```

### 4.3 Required API Keys

| Service      | Variable            | Required    | Get From                                                                               |
| ------------ | ------------------- | ----------- | -------------------------------------------------------------------------------------- |
| **Supabase** | `SUPABASE_URL`      | ✅ Yes      | [Supabase Dashboard](https://supabase.com/dashboard/project/YOUR_PROJECT/settings/api) |
| **Supabase** | `SUPABASE_ANON_KEY` | ✅ Yes      | Same as above                                                                          |
| **Sentry**   | `SENTRY_DSN`        | ⚪ Optional | [Sentry Settings](https://sentry.io/settings/)                                         |
| **API**      | `API_BASE_URL`      | ⚪ Optional | Your backend URL                                                                       |

### 4.4 Firebase Setup

Firebase requires a separate configuration file for Analytics and Push Notifications.

#### Step 1: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

#### Step 2: Configure Firebase

```bash
# Login to Firebase
firebase login

# Configure your project (generates firebase_options.dart)
flutterfire configure
```

This will:

- Create `lib/firebase_options.dart`
- Add `google-services.json` to `android/app/`
- Add `GoogleService-Info.plist` to `ios/Runner/`

#### Step 3: Initialize Firebase

In `lib/bootstrap.dart`, Firebase is already configured to initialize:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

> ⚠️ **Note**: The `firebase_options.dart` file is gitignored. Each developer must run `flutterfire configure` locally.

### 4.5 Sentry Setup (Error Reporting)

1. Create a project at [sentry.io](https://sentry.io)
2. Get your DSN from Project Settings → Client Keys (DSN)
3. Add to your `.env` file:
   ```env
   SENTRY_DSN=https://your-key@sentry.io/your-project-id
   ```

> 💡 **Tip**: Leave `SENTRY_DSN` empty in development to disable error reporting locally.

### 4.6 Feature Flags

Edit `lib/core/config/feature_flags.dart` to enable/disable features:

```dart
class FeatureFlags {
  static bool get biometricAuth => true;
  static bool get darkMode => true;
  static bool get offlineMode => AppConfig.isDevelopment;
}
```

---

## 5. Customize Design System

### 5.1 Colors

Edit `lib/design_system/colors/app_colors.dart`:

```dart
class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF6200EE);
  static const Color secondary = Color(0xFF03DAC6);

  // Customize your palette
  // ...
}
```

### 5.2 Typography

Edit `lib/design_system/typography/app_typography.dart`:

```dart
class AppTypography {
  static const String fontFamily = 'Roboto';  // Or your custom font

  // Customize text styles
  // ...
}
```

### 5.3 Custom Fonts

1. Add fonts to `assets/fonts/`
2. Register in `pubspec.yaml`:
   ```yaml
   flutter:
     fonts:
       - family: YourFont
         fonts:
           - asset: assets/fonts/YourFont-Regular.ttf
           - asset: assets/fonts/YourFont-Bold.ttf
             weight: 700
   ```

### 5.4 App Icons

1. Add your icon to `assets/icons/app_icon.png` (1024x1024)
2. Run:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

### 5.5 Splash Screen

1. Configure `flutter_native_splash.yaml`
2. Run:
   ```bash
   flutter pub run flutter_native_splash:create
   ```

---

## 6. Setup Backend

### Option A: Supabase

1. Create project at [supabase.com](https://supabase.com)
2. Get URL and anon key from Settings → API
3. Update environment configs
4. Run database migrations if needed

### Option B: Custom API

1. Update `lib/services/api/api_service.dart` with your endpoints
2. Configure authentication headers
3. Update models to match your API responses

### Option C: Firebase

1. Create project at [firebase.google.com](https://firebase.google.com)
2. Add FlutterFire CLI: `dart pub global activate flutterfire_cli`
3. Run: `flutterfire configure`
4. Update services to use Firebase

---

## 7. Configure CI/CD

### GitHub Actions

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.x"

      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter analyze
      - run: flutter test
```

---

## 8. Final Checklist

### Before First Commit

- [ ] Project renamed correctly
- [ ] All bundle IDs updated (Android, iOS, etc.)
- [ ] `flutter pub get` runs without errors
- [ ] `dart run build_runner build` succeeds
- [ ] App runs on at least one platform
- [ ] Git history is clean (template history removed)

### Configuration

- [ ] Environment configs updated
- [ ] API URLs configured
- [ ] Secrets not committed to git
- [ ] Feature flags reviewed

### Customization

- [ ] Design system colors updated
- [ ] Typography configured
- [ ] App icons generated
- [ ] Splash screen configured

### Documentation

- [ ] README.md updated for your project
- [ ] CHANGELOG.md started
- [ ] Project-specific Copilot instructions added (optional)

### Final Test

```bash
# Clean build
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Run all tests
flutter test

# Run the app
flutter run
```

---

## Troubleshooting

### Common Issues

**"Package not found" error:**

```bash
flutter clean
flutter pub get
```

**Generated files missing:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**iOS build fails:**

```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

**Android build fails:**

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

### Getting Help

- Check [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for architecture questions
- Use Copilot prompts for code generation
- Refer to [Flutter docs](https://docs.flutter.dev/)
- Refer to [Stacked docs](https://stacked.filledstacks.com/)
