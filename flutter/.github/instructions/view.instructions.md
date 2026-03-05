---
applyTo: "**/*_view.dart"
---
# View Instructions

> These instructions apply to all View files (`*_view.dart`).
> Inherits from: `dart.instructions.md`

---

## View Principles

### Views are DUMB

- **NO business logic** in Views
- **NO state management** (no `setState`)
- **NO direct service calls**
- Views only:
  - Display UI based on ViewModel state
  - Forward user interactions to ViewModel
  - Apply design system styling

---

## View Structure

### Standard View Template

```dart
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildContent(context, viewModel),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LoginViewModel viewModel) {
    if (viewModel.isBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // UI content
      ],
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();

  @override
  void onViewModelReady(LoginViewModel viewModel) {
    viewModel.init();
  }
}
```

---

## View Types

### StackedView (Standard)

For most views with a dedicated ViewModel:

```dart
class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(context, viewModel, child) => ...;

  @override
  HomeViewModel viewModelBuilder(context) => HomeViewModel();
}
```

### ViewModelWidget (Reusable)

For reusable widgets that need ViewModel access:

```dart
class UserCard extends ViewModelWidget<ProfileViewModel> {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context, ProfileViewModel viewModel) {
    return Card(
      child: Text(viewModel.user.name),
    );
  }
}
```

### NonReactiveStackedView

For views that don't need to rebuild on state changes:

```dart
class StaticInfoView extends StackedView<StaticInfoViewModel> {
  const StaticInfoView({super.key});

  @override
  bool get reactive => false;

  @override
  Widget builder(context, viewModel, child) => ...;

  @override
  StaticInfoViewModel viewModelBuilder(context) => StaticInfoViewModel();
}
```

---

## Handling States

### Loading State

```dart
@override
Widget builder(context, viewModel, child) {
  if (viewModel.isBusy) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  return _buildContent(context, viewModel);
}
```

### Error State

```dart
@override
Widget builder(context, viewModel, child) {
  if (viewModel.hasError) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(viewModel.modelError.toString()),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: viewModel.retry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  return _buildContent(context, viewModel);
}
```

### Empty State

```dart
@override
Widget builder(context, viewModel, child) {
  if (viewModel.items.isEmpty) {
    return const Center(
      child: Text('No items found'),
    );
  }
  
  return ListView.builder(
    itemCount: viewModel.items.length,
    itemBuilder: (context, index) => ItemTile(item: viewModel.items[index]),
  );
}
```

### Multiple Busy States

```dart
@override
Widget builder(context, viewModel, child) {
  return Column(
    children: [
      // Button with specific busy state
      ElevatedButton(
        onPressed: viewModel.busy(LoginViewModel.loginBusyKey) 
            ? null 
            : viewModel.login,
        child: viewModel.busy(LoginViewModel.loginBusyKey)
            ? const CircularProgressIndicator()
            : const Text('Login'),
      ),
      
      // Another button with different busy state
      ElevatedButton(
        onPressed: viewModel.busy(LoginViewModel.forgotPasswordBusyKey) 
            ? null 
            : viewModel.forgotPassword,
        child: const Text('Forgot Password'),
      ),
    ],
  );
}
```

---

## UI Best Practices

### Extract Methods for Readability

```dart
class LoginView extends StackedView<LoginViewModel> {
  @override
  Widget builder(context, viewModel, child) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          _buildForm(context, viewModel),
          _buildActions(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const Text('Welcome Back');
  }

  Widget _buildForm(BuildContext context, LoginViewModel viewModel) {
    return Column(
      children: [
        TextField(onChanged: viewModel.setEmail),
        TextField(onChanged: viewModel.setPassword),
      ],
    );
  }

  Widget _buildActions(BuildContext context, LoginViewModel viewModel) {
    return ElevatedButton(
      onPressed: viewModel.canSubmit ? viewModel.login : null,
      child: const Text('Login'),
    );
  }
}
```

### Use Design System

```dart
// ✅ Good - use design system
return Container(
  padding: AppInsets.md,
  decoration: BoxDecoration(
    color: context.colors.surface,
    borderRadius: AppRadius.md,
    boxShadow: AppShadows.sm,
  ),
  child: Text(
    'Title',
    style: context.textStyles.headlineMedium,
  ),
);

// ❌ Bad - hardcoded values
return Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
    'Title',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),
);
```

### Use AppWidgets

```dart
// ✅ Good - use app widgets
return Column(
  children: [
    AppTextField(
      label: 'Email',
      onChanged: viewModel.setEmail,
      errorText: viewModel.emailError,
    ),
    AppGaps.h16,
    AppButton(
      label: 'Login',
      onPressed: viewModel.login,
      isLoading: viewModel.isBusy,
    ),
  ],
);

// ❌ Bad - raw Flutter widgets
return Column(
  children: [
    TextField(onChanged: viewModel.setEmail),
    const SizedBox(height: 16),
    ElevatedButton(
      onPressed: viewModel.login,
      child: const Text('Login'),
    ),
  ],
);
```

---

## Navigation

### Navigate from ViewModel

```dart
// In ViewModel
void goToHome() {
  _navigationService.navigateTo(Routes.home);
}

// In View
ElevatedButton(
  onPressed: viewModel.goToHome,
  child: const Text('Go to Home'),
)
```

### Pass Arguments

```dart
// In ViewModel
void goToProfile(String userId) {
  _navigationService.navigateTo(
    Routes.profile,
    arguments: ProfileViewArguments(userId: userId),
  );
}
```

---

## Dialogs & BottomSheets

### Show from ViewModel

```dart
// In ViewModel
Future<void> showConfirmDelete() async {
  final result = await _dialogService.showCustomDialog(
    variant: DialogType.confirm,
    title: 'Delete Item',
    description: 'Are you sure you want to delete this item?',
  );
  
  if (result?.confirmed == true) {
    await deleteItem();
  }
}

// In View
IconButton(
  onPressed: viewModel.showConfirmDelete,
  icon: const Icon(Icons.delete),
)
```

---

## Lifecycle

### Available Overrides

```dart
class MyView extends StackedView<MyViewModel> {
  @override
  Widget builder(context, viewModel, child) => ...;

  @override
  MyViewModel viewModelBuilder(context) => MyViewModel();

  /// Called once when ViewModel is ready
  @override
  void onViewModelReady(MyViewModel viewModel) {
    viewModel.init();
  }

  /// Called when dependencies change
  @override
  void onDispose(MyViewModel viewModel) {
    // Cleanup if needed
  }
  
  /// Static child widget (not rebuilt)
  @override
  Widget? staticChildBuilder(context) {
    return const ExpensiveWidget();
  }
}
```

---

## Don'ts

```dart
// ❌ Don't use setState
setState(() {
  _isLoading = true;
});

// ❌ Don't call services directly
final user = await locator<AuthService>().login();

// ❌ Don't have business logic
if (email.contains('@') && password.length > 8) {
  // validation logic
}

// ❌ Don't store state in View
String _email = '';

// ❌ Don't use StatefulWidget
class MyView extends StatefulWidget { }
```

---

## Animation Requirements

> Ref: `animation.instructions.md`

Every visible state change in a view MUST be animated.

### Content Switching

When the view displays different content based on state:

```dart
// ✅ REQUIRED
AnimatedSwitcher(
  duration: AppAnimations.normal,
  switchInCurve: AppAnimations.emphasizedDecelerate,
  switchOutCurve: AppAnimations.emphasizedAccelerate,
  transitionBuilder: AppAnimations.fadeScale,
  child: KeyedSubtree(
    key: ValueKey(viewModel.currentState),
    child: _buildForState(viewModel.currentState),
  ),
)

// ❌ FORBIDDEN
viewModel.isLoading
    ? const CircularProgressIndicator()
    : _buildContent(viewModel)
```

### Loading → Content Transition

```dart
// ✅ REQUIRED
AnimatedSwitcher(
  duration: AppAnimations.normal,
  child: viewModel.isBusy
      ? const Center(key: ValueKey('loading'), child: CircularProgressIndicator())
      : KeyedSubtree(key: ValueKey('content'), child: _buildContent(context, viewModel)),
)
```

### Progress Values

```dart
// ✅ REQUIRED — animate changing values
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: viewModel.progress),
  duration: AppAnimations.normal,
  curve: AppAnimations.emphasizedDecelerate,
  builder: (context, value, child) {
    return LinearProgressIndicator(value: value);
  },
)
```

---

## Accessibility Requirements

> Ref: `accessibility.instructions.md`

### Icons Must Have Labels

```dart
// ✅ REQUIRED
Icon(Icons.check, semanticLabel: context.l10n.completed)
Icon(Icons.settings, semanticLabel: context.l10n.settings)

// ❌ FORBIDDEN
Icon(Icons.check)
```

### Interactive Elements Must Have Semantics

```dart
// ✅ REQUIRED
Semantics(
  button: true,
  label: context.l10n.editProfile,
  child: InkWell(onTap: viewModel.editProfile, child: ...),
)
```

---

## Gesture Requirements

> Ref: `gestures.instructions.md`

### Data Lists Must Have Pull-to-Refresh

```dart
// ✅ REQUIRED
RefreshIndicator(
  onRefresh: viewModel.refreshData,
  color: AppColors.primary,
  child: ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: viewModel.items.length,
    itemBuilder: (context, index) => _buildItem(viewModel.items[index]),
  ),
)
```

### List Items Should Support Contextual Gestures

```dart
// ✅ RECOMMENDED — swipe actions via flutter_slidable
Slidable(
  key: ValueKey(item.id),
  endActionPane: ActionPane(
    motion: const BehindMotion(),
    children: [
      SlidableAction(
        onPressed: (_) => viewModel.archiveItem(item.id),
        backgroundColor: AppColors.warning,
        foregroundColor: AppColors.white,
        icon: Icons.archive,
        label: context.l10n.archive,
      ),
    ],
  ),
  child: _buildItemTile(item),
)
```

---

## Dark Mode Requirements

> Ref: `dark-mode.instructions.md`

### Extract Brightness

```dart
@override
Widget builder(BuildContext context, MyViewModel viewModel, Widget? child) {
  final brightness = Theme.of(context).brightness;
  // Use brightness in all color references
}
```

### Never Use Light/Dark Directly

```dart
// ✅ CORRECT
color: AppColors.textSecondary(brightness)

// ❌ FORBIDDEN
color: AppColors.textSecondaryLight
```
