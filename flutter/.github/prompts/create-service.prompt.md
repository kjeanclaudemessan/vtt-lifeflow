# Create a New Service

Create a new service following the Stacked pattern.

## Service Details

- **Service Name**: ${{input:Enter the service name (e.g., analytics, notification, cache)}}
- **Service Type**: ${{input:Type: simple, reactive, or wrapper}}
- **Description**: ${{input:Briefly describe what this service does}}

## Service Types

### Simple Service
- Stateless utility class
- Methods return directly or use Either<Failure, T>
- No listeners or state

### Reactive Service
- Extends `ReactiveServiceMixin`
- Has observable properties
- ViewModels can listen to changes
- Good for shared state (user, cart, etc.)

### Wrapper Service
- Wraps third-party SDK (Firebase, Supabase, etc.)
- Provides app-specific interface
- Handles SDK initialization

## Requirements

Generate the following:

### 1. Service Class
Create `lib/services/<category>/<service_name>_service.dart`:
- Follow the appropriate pattern based on type
- Include comprehensive documentation
- Handle errors with Either<Failure, T>
- Make it testable (injectable dependencies)

### 2. Registration
Add to `app.dart` dependencies:
- Use `LazySingleton` for most services
- Use `Singleton` if needs early initialization
- Use `Factory` if new instance needed each time

### 3. Tests (optional)
Create `test/unit/services/<service_name>_service_test.dart`:
- Test main functionality
- Mock external dependencies

## Service Categories

Place the service in the appropriate folder:
- `services/api/` - HTTP client, interceptors
- `services/auth/` - Authentication related
- `services/storage/` - Local storage, cache
- `services/analytics/` - Analytics tracking
- `services/notification/` - Push notifications
- `services/device/` - Device info, permissions
- `services/supabase/` - Supabase wrappers

## Guidelines

- Follow patterns from `service.instructions.md`
- Use Either<Failure, T> for fallible operations
- Make services framework-agnostic when possible
- Document initialization requirements
