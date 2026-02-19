# Refactor Code

Refactor code for better maintainability, performance, or architecture compliance.

## Refactor Details

- **Target**: ${{input:What to refactor? (file path, class name, or pattern)}}
- **Refactor Type**: ${{input:Type: extract, rename, move, simplify, optimize, architecture}}
- **Reason**: ${{input:Why is this refactor needed?}}

## Refactor Types

### Extract

#### Extract Method
```dart
// Before
void processOrder() {
  // Validate
  if (order.items.isEmpty) throw Exception('Empty cart');
  if (order.total < 0) throw Exception('Invalid total');
  
  // Calculate
  final subtotal = order.items.fold(0.0, (s, i) => s + i.price);
  final tax = subtotal * 0.1;
  final total = subtotal + tax;
  
  // Save
  _repository.save(order);
}

// After
void processOrder() {
  _validateOrder(order);
  final total = _calculateTotal(order);
  _saveOrder(order, total);
}

void _validateOrder(Order order) { ... }
double _calculateTotal(Order order) { ... }
void _saveOrder(Order order, double total) { ... }
```

#### Extract Widget
```dart
// Before - in build method
Column(
  children: [
    Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: AppTypography.titleMedium),
              Text(user.email, style: AppTypography.bodySmall),
            ],
          ),
        ],
      ),
    ),
    // More widgets...
  ],
)

// After - extracted
Column(
  children: [
    UserHeader(user: user),
    // More widgets...
  ],
)

class UserHeader extends StatelessWidget { ... }
```

#### Extract Class/Service
Split a large class into focused, single-responsibility classes.

### Rename

Follow naming conventions:
- Classes: `PascalCase`
- Files: `snake_case`
- Methods/Variables: `camelCase`
- Private: `_prefixed`

```dart
// Before
class Mgr { } // Unclear
void calc() { } // Abbreviated

// After
class OrderManager { } // Descriptive
void calculateTotal() { } // Clear
```

### Move

Move code to appropriate layers:
- Business logic → Domain/ViewModel
- JSON serialization → Data/Models
- UI composition → UI/Widgets
- Shared utilities → Core/Utils

### Simplify

#### Reduce Complexity
```dart
// Before - nested conditions
if (user != null) {
  if (user.isActive) {
    if (user.hasPermission) {
      doSomething();
    }
  }
}

// After - early returns
if (user == null) return;
if (!user.isActive) return;
if (!user.hasPermission) return;
doSomething();
```

#### Use Dart Features
```dart
// Before
String getLabel() {
  if (status == Status.pending) {
    return 'Pending';
  } else if (status == Status.completed) {
    return 'Completed';
  } else {
    return 'Unknown';
  }
}

// After - switch expression
String getLabel() => switch (status) {
  Status.pending => 'Pending',
  Status.completed => 'Completed',
  _ => 'Unknown',
};
```

### Optimize

#### Performance
```dart
// Before - rebuilds entire list
ListView.builder(
  itemBuilder: (context, index) {
    return ExpensiveWidget(items[index]);
  },
)

// After - const constructors, keys
ListView.builder(
  itemBuilder: (context, index) {
    return ExpensiveWidget(
      key: ValueKey(items[index].id),
      item: items[index],
    );
  },
)
```

### Architecture

Ensure code follows Stacked + Clean Architecture:

```dart
// Before - logic in View
class MyView extends StackedView<MyViewModel> {
  @override
  Widget builder(context, viewModel, child) {
    final total = viewModel.items.fold(0, (s, i) => s + i.price);
    // ❌ Logic in View
  }
}

// After - logic in ViewModel
class MyViewModel extends BaseViewModel {
  double get total => _items.fold(0, (s, i) => s + i.price);
  // ✅ Logic in ViewModel
}
```

## Refactor Checklist

- [ ] Existing functionality preserved
- [ ] Tests still pass (if any)
- [ ] No new dependencies introduced unnecessarily
- [ ] Follows project conventions
- [ ] Code is more readable/maintainable
- [ ] Proper documentation added

## After Refactoring

1. **Run tests** to verify nothing broke
2. **Review changes** for unintended modifications
3. **Update imports** if files were moved
4. **Regenerate** if build_runner files affected

## Guidelines

- Make small, incremental changes
- One refactor at a time
- Test after each change
- Keep git history clean (atomic commits)
- Document reasoning for complex refactors
