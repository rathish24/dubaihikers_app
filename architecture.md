# ARCHITECTURE.md

## Purpose

This document defines the project structure, dependency rules, Riverpod conventions, and file-placement decisions.

Do not duplicate these rules in other files.

## Architecture

This project uses feature-first architecture with lightweight clean-architecture boundaries.

Feature-owned code stays inside its feature.

Create only the layers and folders currently required. Do not create empty folders for possible future use.

## Project Structure

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── colors.dart
│   │   └── strings.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── text_styles.dart
│   ├── utils/
│   │   ├── extensions.dart
│   │   └── validators.dart
│   └── errors/
│       └── failures.dart
├── features/
│   └── feature_name/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       ├── presentation/
│       │   ├── screens/
│       │   └── widgets/
│       └── providers/
├── shared/
│   ├── widgets/
│   │   ├── buttons/
│   │   ├── inputs/
│   │   └── cards/
│   ├── services/
│   │   ├── api_service.dart
│   │   └── storage_service.dart
│   └── models/
└── routes/
    └── app_router.dart
```

Tests should mirror the `lib/` structure under `test/`.

## Top-Level Responsibilities

### `main.dart`

Contains:

- Flutter initialization
- SDK initialization
- Root `ProviderScope`
- `runApp`

Keep it small.

### `app.dart`

Contains:

- `MaterialApp` or `MaterialApp.router`
- Theme
- Router
- Localization
- Root application configuration

### `core/`

Contains application-wide foundations.

Examples:

- Theme
- Constants
- Shared failures
- Stateless utilities

Do not place feature-specific code in `core/`.

### `features/`

Contains business features.

Each feature owns its:

- Data access
- Business rules
- Riverpod state
- Screens
- Feature-specific widgets

### `shared/`

Contains code genuinely reused by multiple independent features.

Do not move code to `shared/` based only on possible future reuse.

### `routes/`

Contains global routing, redirects, guards, and deep-link configuration.

## Feature Layers

### Data

Location:

```text
features/<feature>/data/
```

Contains:

- DTOs and API models
- Remote and local data sources
- Repository implementations
- Mapping and caching

Must not depend on widgets, screens, providers, or `BuildContext`.

### Domain

Location:

```text
features/<feature>/domain/
```

Contains:

- Entities
- Repository contracts
- Use cases
- Business rules

Must not depend on:

- Flutter
- Riverpod
- API clients
- Storage packages
- Concrete repositories

### Presentation

Location:

```text
features/<feature>/presentation/
```

Contains:

- Screens
- Feature-specific widgets
- UI-only helpers

Presentation observes providers and renders state.

It must not call data sources, repositories, or HTTP clients directly.

### Providers

Location:

```text
features/<feature>/providers/
```

Contains Riverpod provider declarations, notifiers, and presentation state.

Example:

```text
providers/
├── auth_providers.dart
├── auth_controller.dart
└── auth_state.dart
```

Use fewer files when the feature is simple.

## Dependency Direction

Use this direction:

```text
Screen or widget
        ↓
Riverpod provider or notifier
        ↓
Use case
        ↓
Repository contract
        ↓
Repository implementation
        ↓
Data source
        ↓
Shared service or external SDK
```

Forbidden:

```text
domain → Riverpod
domain → Flutter
widget → API service
widget → data source
presentation → repository implementation
provider → raw HTTP client
feature A → feature B internal data layer
```

## Riverpod

The application root must use `ProviderScope`:

```dart
void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
```

Use manual Riverpod declarations unless the project explicitly adopts Riverpod code generation.

### Provider Selection

Use:

- `Provider` for services, repositories, use cases, configuration, and derived values
- `FutureProvider` for simple read-only asynchronous data
- `StreamProvider` for continuous streams
- `NotifierProvider` for synchronous mutable state
- `AsyncNotifierProvider` for asynchronous mutable state

Prefer the simplest provider that satisfies the requirement.

### Async State

Use `AsyncValue<T>` for asynchronous loading, data, and errors.

Do not duplicate it with unrelated flags such as:

```dart
bool isLoading;
bool hasError;
Object? error;
```

unless additional state is genuinely required.

### Reading Providers

Use:

```text
ref.watch
```

when the consumer must react to changes.

Use:

```text
ref.read
```

for commands and callbacks.

Use:

```text
ref.listen
```

for UI reactions such as:

- Navigation
- Snackbars
- Dialogs
- Analytics reactions

Providers must not contain `BuildContext` or directly perform UI navigation.

### Provider Lifetime

Use automatic disposal for short-lived state such as:

- Search results
- Detail screens
- Forms
- Route-specific filters

Retain providers only for intentionally long-lived state such as:

- Authentication
- App configuration
- Session state
- Shared services

### Dependency Injection

Expose app-wide dependencies through providers.

Example:

```dart
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(
      apiService: ref.watch(apiServiceProvider),
    ),
  );
});
```

Do not instantiate repositories or services inside widgets.

### Provider Naming

Provider variables end with `Provider`.

Examples:

```dart
apiServiceProvider
authRepositoryProvider
currentUserProvider
authControllerProvider
```

Use clear controller names such as:

```dart
AuthController
EventListController
ProfileEditor
```

Avoid vague names such as `Manager`, `Helper`, or `Handler`.

## State Ownership

Keep temporary widget-only state inside the widget.

Examples:

- `TextEditingController`
- `FocusNode`
- `AnimationController`
- Temporary expansion state

Use Riverpod when state:

- Is shared
- Survives widget rebuilds
- Coordinates business operations
- Requires dependency injection
- Needs testing outside the widget
- Represents asynchronous application state

Do not move every local UI value into Riverpod.

## File Placement

Use these rules:

| Responsibility            | Location                                   |
| ------------------------- | ------------------------------------------ |
| Feature business concept  | `features/<feature>/domain/`               |
| API or database model     | `features/<feature>/data/models/`          |
| External communication    | `features/<feature>/data/datasources/`     |
| Repository implementation | `features/<feature>/data/repositories/`    |
| Screen                    | `features/<feature>/presentation/screens/` |
| Feature widget            | `features/<feature>/presentation/widgets/` |
| Riverpod state            | `features/<feature>/providers/`            |
| Reusable widget           | `shared/widgets/`                          |
| App-wide service          | `shared/services/`                         |
| Theme                     | `core/theme/`                              |
| Shared failure            | `core/errors/`                             |
| Global router             | `routes/`                                  |

## Shared Code Rule

Start code inside the owning feature.

Move it to `shared/` only when:

1. Multiple independent features use it.
2. It no longer contains feature-specific behaviour.
3. Its API and name are genuinely reusable.

A user entity should normally stay inside the feature that owns it unless it becomes a true application-wide model.

## Naming

Use:

- `snake_case.dart` for files
- `PascalCase` for classes
- `camelCase` for variables and functions
- `_screen.dart` for screens
- `_provider.dart` or `_providers.dart` for provider files
- `_repository.dart` for contracts
- `_repository_impl.dart` for implementations
- `_use_case.dart` for use cases

Do not prefix interfaces with `I`.

## Testing

Mirror production paths under `test/`.

Riverpod unit tests should use `ProviderContainer`:

```dart
final container = ProviderContainer(
  overrides: [
    authRepositoryProvider.overrideWithValue(
      FakeAuthRepository(),
    ),
  ],
);

addTearDown(container.dispose);
```

Widget tests should wrap widgets in `ProviderScope`.

Do not make real network requests in tests.

## Architecture Changes

The following require updating this document:

- New top-level folder
- New architectural layer
- New state-management framework
- Changed dependency direction
- Riverpod code-generation adoption
- Movement of shared services
- Modular package introduction

Do not make architecture changes silently.

## Core Rule

Feature code stays inside the feature.

Domain contains business rules.

Data handles external systems.

Presentation renders UI.

Riverpod coordinates state and dependencies.

Shared contains proven reusable code.
