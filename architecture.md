# Dubai Hikers App Architecture (`architecture.md`)

## 📐 Architectural Overview

`dubaihikers_app` strictly follows **Vertical Slice Architecture** paired with **Feature-First Clean Architecture** principles:

### 1. Feature Co-location
All UI screens, custom widgets, Riverpod state providers, repositories, data sources, and domain models for a feature reside co-located inside a single feature folder under `lib/features/<feature_name>/`.

### 2. Separation of Concerns
- **Presentation Layer**: Flutter UI Widgets, Screens, and Riverpod Notifiers/Providers (`package:flutter_riverpod`).
- **Domain Layer**: Abstract Repository interfaces and Core Entities.
- **Data Layer**: Concrete Repository implementations, Remote Data Sources (`supabase_flutter`), and Data Models.

### 3. Core Encapsulation
Non-domain infrastructure, including networking wrappers, database clients, themes, global constants, and reusable atomic design system widgets, lives inside `lib/core/`.

---

## 🏗️ Folder Hierarchy

```
lib/
├── core/
│   ├── constants/
│   │   └── supabase_constants.dart        # Supabase URL & keys
│   ├── network/
│   │   └── supabase_client_provider.dart  # Supabase client Riverpod provider wrapper
│   ├── theme/
│   │   └── app_theme.dart                 # Color schemes & Material 3 styles
│   └── widgets/
│       └── loading_indicator.dart         # Shared atomic widgets
│
└── features/
    ├── navigation/
    │   └── presentation/
    │       ├── providers/
    │       │   └── navigation_provider.dart# Bottom Navigation index provider
    │       └── screens/
    │           └── main_navigation_screen.dart # 3-tab Bottom Navigation (Lead, Event, Profile)
    │
    ├── leads/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── leads_remote_datasource.dart # Supabase API queries
    │   │   ├── models/
    │   │   │   ├── lead_model.dart            # Registration DTO
    │   │   │   └── event_model.dart           # Event DTO
    │   │   └── repositories/
    │   │       └── leads_repository_impl.dart  # Concrete repository implementation
    │   ├── domain/
    │   │   └── repositories/
    │   │       └── leads_repository.dart       # Abstract repository contract
    │   └── presentation/
    │       ├── providers/
    │       │   └── leads_provider.dart        # Riverpod Notifier / AsyncNotifier for Leads
    │       ├── screens/
    │       │   ├── leads_screen.dart          # Event-wise leads list UI
    │       │   └── lead_detail_screen.dart    # Individual lead detail view
    │       └── widgets/
    │           ├── event_lead_group_card.dart # Grouped lead accordion/card
    │           └── lead_list_tile.dart        # User item tile (Name, Email, Contact)
    │
    ├── events/
    │   └── presentation/
    │       └── screens/
    │           └── events_screen.dart         # Empty placeholder screen
    │
    └── profile/
        └── presentation/
            └── screens/
                └── profile_screen.dart        # Empty placeholder screen
```

---

## 🔄 Data Flow & State Management (Riverpod)

1. **User Action**: Triggered in `leads_screen.dart` (e.g., Pull-to-refresh or typing in Search bar).
2. **Riverpod Layer**: `leadsProvider` (a `StateNotifier` / `AsyncNotifier` or `FutureProvider`) is read or listened to by a `ConsumerWidget`.
3. **Repository Provider**: `leadsRepositoryProvider` supplies the `LeadsRepository` implementation.
4. **Data Source**: `LeadsRemoteDataSource` executes Supabase client query:
   - Queries `event_registrations` table joined with `events` table.
5. **State Emission**: `leadsProvider` updates its `AsyncValue<LeadsState>` state (loading -> data/error).
6. **UI Rendering**: `LeadsScreen` reacts to state changes using `ref.watch(leadsProvider)` and `AsyncValue.when(...)` rendering list of events & leads. Tap on user item navigates to `LeadDetailScreen`.

---

## 🧪 Testing Strategy

Every feature is designed to be fully unit testable and integration testable with Riverpod:
- **Unit Tests**:
  - `leads_remote_datasource_test.dart`: Mocks Supabase client using `mocktail`.
  - `leads_repository_test.dart`: Verifies mapping between data source models and repository outputs.
  - `leads_provider_test.dart`: Tests Riverpod providers using a custom `ProviderContainer` and overrides.
- **Widget & Integration Tests**:
  - `main_navigation_screen_test.dart`: Verifies tab switching using `ProviderScope` and widget testing.
  - `lead_detail_screen_test.dart`: Verifies detail screen displays Name, Email, Contact, and enquiry notes correctly.
