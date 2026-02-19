# Create a New Widget

Create a reusable widget following the design system guidelines.

## Widget Details

- **Widget Name**: ${{input:Enter the widget name (e.g., ProductCard, OrderItem, UserAvatar)}}
- **Widget Type**: ${{input:Type: stateless, stateful, or animated}}
- **Location**: ${{input:Location: ui/widgets (global) or features/<feature>/widgets (local)}}
- **Description**: ${{input:Briefly describe what this widget displays}}

## Requirements

Generate the following:

### 1. Widget Class

Create the widget file:
- Use `App` prefix for global widgets
- Use feature prefix for feature-specific widgets
- Include comprehensive documentation
- Add example usage in doc comments

### 2. Widget Structure

#### For Stateless Widgets
```dart
class AppWidgetName extends StatelessWidget {
  // Required parameters first
  final String title;
  
  // Optional parameters with defaults
  final VoidCallback? onTap;
  final bool isEnabled;
  
  const AppWidgetName({
    super.key,
    required this.title,
    this.onTap,
    this.isEnabled = true,
  });
  
  // Named constructors for variants
  const AppWidgetName.compact({...}) : ...;
  
  @override
  Widget build(BuildContext context) { }
}
```

#### For Stateful Widgets
```dart
class AppWidgetName extends StatefulWidget {
  // ... parameters
  
  @override
  State<AppWidgetName> createState() => _AppWidgetNameState();
}

class _AppWidgetNameState extends State<AppWidgetName> {
  // Local state
  
  @override
  void initState() {
    super.initState();
    // Initialize
  }
  
  @override
  void dispose() {
    // Clean up
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) { }
}
```

### 3. Design System Integration

- Use `AppColors` for colors
- Use `AppTypography` for text styles
- Use `AppSpacing` for padding/margins
- Use `AppRadius` for border radius
- Use `AppShadows` for elevation

### 4. Accessibility

- Add `Semantics` where needed
- Support `ExcludeSemantics` for decorative elements
- Ensure proper contrast ratios

## Widget Variants

Consider providing multiple variants via:
- Named constructors: `AppButton.secondary()`
- Enum parameters: `variant: ButtonVariant.outlined`
- Factory constructors: `AppCard.elevated()`

## Guidelines

- Follow patterns from `widget.instructions.md`
- Keep widgets pure (no service calls)
- Use callbacks for actions
- Document all public parameters
- Add usage examples in comments
