# Fix Bug or Error

Analyze and fix a bug or error in the codebase.

## Bug Details

- **Error Message**: ${{input:Paste the error message or describe the bug}}
- **File/Component**: ${{input:Where does the bug occur? (file path or component name)}}
- **Expected Behavior**: ${{input:What should happen?}}
- **Actual Behavior**: ${{input:What is happening instead?}}

## Investigation Steps

### 1. Analyze the Error

For **compile-time errors**:
- Check import statements
- Verify type mismatches
- Look for missing implementations
- Check for null safety issues

For **runtime errors**:
- Check null pointer exceptions
- Verify state management
- Check async/await usage
- Look for index out of bounds

For **logic errors**:
- Trace the data flow
- Check conditions and edge cases
- Verify business logic

### 2. Common Flutter/Stacked Issues

#### State Not Updating
```dart
// ❌ Wrong - direct assignment
_items = newItems;

// ✅ Correct - notify listeners
_items = newItems;
rebuildUi();
```

#### Async Issues
```dart
// ❌ Wrong - not awaiting
runBusyFuture(fetchData()); // Missing await

// ✅ Correct
await runBusyFuture(fetchData());
```

#### Null Safety
```dart
// ❌ Wrong - force unwrap
final name = user!.name; // Crashes if null

// ✅ Correct - null check
final name = user?.name ?? 'Unknown';
```

#### Either Handling
```dart
// ❌ Wrong - ignoring result
_repository.login(email, password);

// ✅ Correct - handle both cases
final result = await _repository.login(email, password);
result.fold(
  (failure) => setError(failure.message),
  (user) => _onLoginSuccess(user),
);
```

### 3. Debugging Tools

```dart
// Add debug print
debugPrint('State: $_state');

// Check widget tree
debugDumpApp();

// Check render tree
debugDumpRenderTree();

// Log with timestamps
log('Event occurred', name: 'MyComponent');
```

### 4. Fix Patterns

#### Missing Rebuild
```dart
// Before
void updateName(String name) {
  _name = name;
}

// After
void updateName(String name) {
  _name = name;
  rebuildUi(); // Notify UI
}
```

#### Incorrect Async Flow
```dart
// Before
Future<void> submit() async {
  final result = _repository.save(data);
  // result is Future, not Either!
}

// After
Future<void> submit() async {
  final result = await _repository.save(data);
  result.fold(handleError, handleSuccess);
}
```

#### Memory Leak
```dart
// Before
@override
void initState() {
  super.initState();
  _controller = TextEditingController();
  _subscription = stream.listen((_) {});
}

// After
@override
void dispose() {
  _controller.dispose();
  _subscription.cancel();
  super.dispose();
}
```

## Fix Checklist

- [ ] Identified root cause
- [ ] Fix addresses the actual issue (not symptoms)
- [ ] No new issues introduced
- [ ] Edge cases considered
- [ ] Error handling in place
- [ ] Tests pass (if applicable)

## After Fixing

1. **Verify the fix** works as expected
2. **Check for regressions** in related functionality
3. **Run tests** if they exist
4. **Consider adding tests** for this scenario

## Guidelines

- Understand the problem before fixing
- Don't just suppress errors
- Fix root cause, not symptoms
- Consider edge cases
- Document complex fixes with comments
