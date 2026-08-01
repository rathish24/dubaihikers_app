# Dubai Hikers Lead Management App (`dubaihikers_app`)

A Flutter application designed for Dubai Hikers administrators to manage leads, view user registrations for events, and monitor event activity.

## 🚀 Features

1. **Leads Tab**
   - View event-wise grouped lists of registered users (leads).
   - Display key lead information: **Name**, **Email**, and **Contact Number**.
   - Filter and search leads by event name or user details.
   - Lead Details Screen: Full contact details, customer enquiry notes, number of hikers, payment status, reference number, and registration timestamp.

2. **Events Tab**
   - Dedicated placeholder screen for event publishing and management features.

3. **Profile Tab**
   - Dedicated placeholder screen for admin profile and settings.

4. **Bottom Navigation**
   - Clean 3-tab navigation bar (Lead, Event, Profile) with smooth switching.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `^3.11.0`)
- **Backend / Database**: [Supabase](https://supabase.com) via `supabase_flutter`
- **Architecture**: **Vertical Slice Architecture** paired with **Feature-First Clean Architecture**
- **State Management**: `flutter_riverpod` (Riverpod 2.x / 3.x)
- **Testing**: `flutter_test` and `mocktail` for unit & integration testing

---

## 📂 Project Structure

```
lib/
├── main.dart                       # App entry point & Supabase initialization
├── core/                           # Core utilities, theme, networking, & constants
│   ├── constants/                  # App secrets, keys, and constants
│   ├── theme/                      # App theme & typography
│   └── network/                    # Supabase client wrapper
└── features/                       # Vertical Slice Feature Modules
    ├── navigation/                 # Main bottom navigation container
    ├── leads/                      # Leads feature module
    │   ├── data/                   # Data sources, models, and repository implementations
    │   ├── domain/                 # Repository interfaces and entities
    │   └── presentation/           # Bloc/Cubit, screens, and custom widgets
    ├── events/                     # Events feature module (Placeholder UI)
    └── profile/                    # Profile feature module (Placeholder UI)
```

---

## 🔒 Configuration & Supabase Setup

Supabase connection details are configured in `lib/core/constants/supabase_constants.dart`:
- **Supabase URL**: `https://owmxulixssmwiolpcoug.supabase.co`
- **Anon / Publishable Key**: `sb_publishable_CKxexGgdXsxTT0fna6CUyw_N3EYY7A0`

---

## 🧪 Running Tests

Run unit and bloc tests:
```bash
flutter test
```
