# Create a New Feature

Create a new feature module following the Stacked architecture pattern.

## Feature Details

- **Feature Name**: ${{input:Enter the feature name (e.g., profile, settings, orders)}}
- **Description**: ${{input:Briefly describe the feature}}
- **Requires Authentication**: ${{input:Does this feature require auth? (yes/no)}}

## Requirements

Generate the following structure under `lib/features/<feature_name>/`:

### 1. Views
Create the main view (`<feature>_view.dart`) following these patterns:
- Extend `StackedView<FeatureViewModel>`
- Include loading, error, and empty states
- Use design system tokens for styling
- Keep view dumb (no logic)

### 2. ViewModel
Create the ViewModel (`<feature>_viewmodel.dart`):
- Extend `BaseViewModel`
- Inject required services via constructor
- Use `runBusyFuture` for async operations
- Implement proper state management

### 3. Widgets (if needed)
Create feature-specific widgets in `widgets/` folder:
- Prefix with feature name if specific to this feature
- Use `App` prefix if reusable across app

### 4. Registration
Update `app.dart` to register:
- The route for the view
- Any new services or repositories

## Expected Output

```
lib/features/<feature_name>/
├── <feature>_view.dart
├── <feature>_viewmodel.dart
└── widgets/
    └── (feature-specific widgets)
```

## Guidelines

- Follow naming conventions from `dart.instructions.md`
- Use Either<Failure, T> for error handling
- Write documentation for public APIs
- Consider i18n for user-facing strings
