# AGENTS.md — AI Agent Guidelines & Coding Standards for Dubai Hikers App

> **Instructions, architecture rules, and conventions for AI Coding Assistants working on the `dubaihikers_app` codebase.**

---

## 1. Project Context & Product Overview

* **App Name**: Dubai Hikers Admin & Lead Management App (`dubaihikers_app`) 🏔️
* **Product Goal**: Manage outdoor event lead registrations, track registered user details (Name, Email, Contact, Enquiry Notes), monitor payment statuses, and view/edit/delete published hiking events.
* **Backend Database**: [Supabase](https://supabase.com) (`supabase_flutter`) connecting to tables:
  * `events` (Event details, difficulty, price, location, start dates, image URLs, capacity)
  * `event_registrations` (User registration leads, contact name/email/phone, hiker count, customer enquiry notes, reference number, payment status)
* **Framework**: Flutter (SDK `^3.11.0`) & Dart
* **State Management**: Riverpod (`package:flutter_riverpod`) using `StateNotifier` and `ConsumerWidget`
* **Design System**: Custom Material 3 theme (`AppTheme`) with outdoor hiking color palette (Emerald Green `#0F5132`, Desert Amber `#D97706`)

---

## 2. Architecture Principles & Folder Structure

`dubaihikers_app` strictly follows **Vertical Slice Architecture** paired with **Feature-First Clean Architecture**:

### 2.1 Core Rules
1. **Feature Co-location**: All UI screens, widgets, Riverpod providers, domain models, data sources, and repositories for a feature live co-located under `lib/features/<feature_name>/`.
2. **Core Encapsulation**: Non-domain infrastructure (networking wrappers, Supabase constants, theme system, atomic UI components) lives under `lib/core/`.
3. **Decoupled Business Logic**: UI components must never query database data sources directly. UI widgets consume state via Riverpod providers (`ref.watch(notifierProvider)`).

### 2.2 Directory Layout
```
lib/
├── main.dart                          # App entry point, Supabase & ProviderScope setup
├── core/                              # Infrastructure & shared utilities
│   ├── constants/
│   │   └── supabase_constants.dart    # Supabase URL, anon key, table constants
│   ├── network/
│   │   └── supabase_client_provider.dart # Riverpod provider wrapper for SupabaseClient
│   └── theme/
│       └── app_theme.dart             # Material 3 colors, typography, component styles
│
└── features/                          # Feature Vertical Slices
    ├── navigation/                    # 3-Tab Bottom Navigation (Lead, Event, Profile)
    │   └── presentation/
    │       ├── providers/             # Navigation tab index StateProvider
    │       └── screens/               # MainNavigationScreen (IndexedStack)
    │
    ├── leads/                         # Lead Management Feature Module
    │   ├── data/
    │   │   ├── datasources/           # LeadsRemoteDataSource (Supabase relational joins)
    │   │   ├── models/                # LeadModel & EventModel DTOs
    │   │   └── repositories/          # LeadsRepositoryImpl
    │   ├── domain/
    │   │   └── repositories/          # LeadsRepository abstract interface
    │   └── presentation/
    │       ├── providers/             # LeadsNotifier & leadsNotifierProvider
    │       └── screens/               # LeadsScreen (grouped list, search) & LeadDetailScreen
    │
    ├── events/                        # Event Management Feature Module
    │   ├── data/
    │   │   ├── datasources/           # EventsRemoteDataSource (fetch, update, delete)
    │   │   └── repositories/          # EventsRepositoryImpl
    │   ├── domain/
    │   │   └── repositories/          # EventsRepository abstract interface
    │   └── presentation/
    │       ├── providers/             # EventsNotifier (search, difficulty filter, update, delete)
    │       └── screens/               # EventsScreen & EventDetailScreen (with Calendar picker)
    │
    └── profile/                       # Admin Profile Feature Module
        └── presentation/
            └── screens/               # ProfileScreen (Admin settings placeholder)
```

---

## 3. Database & Supabase Integration Standards

* **Relational Queries**: Query `event_registrations` with foreign key join on `events`:
  `supabase.from('event_registrations').select('*, events(*)').order('created_at', ascending: false)`
* **Data Sources**: All database communication must be placed in `data/datasources/` and expose abstract interface contracts in `domain/repositories/`.
* **State Immutability**: Domain and Data DTOs (`LeadModel`, `EventModel`) must be immutable with proper `copyWith`, `fromJson`, `toJson`, and value equality (`==` and `hashCode`).

---

## 4. UI & Feature Guardrails

### 4.1 Bottom Navigation (3 Tabs)
- **Tab 1: Lead**: Event-grouped lead list showing registered users (Name, Email, Contact Phone, Enquiry indicator `💬 Enquiry`). Tap item to view full [LeadDetailScreen](file:///Users/rathish/Documents/Work/dubaihikers_app/lib/features/leads/presentation/screens/lead_detail_screen.dart) with customer enquiry notes and quick Call/Email action buttons.
- **Tab 2: Event**: Published events list with search, difficulty filter chips (**All Difficulties**, **Beginner**, **Moderate**, **Advanced**, **Expert**), event hero images, distance/elevation stats, and vertical options menu (`PopupMenuButton`, `Icons.more_vert`) for **Edit Event** (with interactive Calendar Date/Time picker) and **Delete Event** (with confirmation dialog).
- **Tab 3: Profile**: Admin profile & configuration settings screen.

### 4.2 Difficulty Standard Hierarchy
- `Beginner` (Green) — Replaces old "Easy" term
- `Moderate` (Orange)
- `Advanced` (Blue)
- `Expert` (Red)

---

## 5. Code Quality & Testing Requirements

* **Static Analysis**: Maintain zero warnings in `flutter analyze`.
* **Testing Protocol**:
  * Unit test models (`fromJson`/`toJson`) under `test/features/<feature>/data/models/`.
  * Unit test Riverpod state notifiers using `ProviderContainer` under `test/features/<feature>/presentation/providers/`.
  * Widget test screens using `WidgetTester` and `ProviderScope` overrides under `test/features/<feature>/presentation/screens/`.
  * Always verify that all tests pass cleanly before completing a task:
    ```bash
    flutter test
    ```
* **Git Commit Hygiene**: Write descriptive commit messages starting with conventional prefixes (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`).
