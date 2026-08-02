# Dubai Hikers Admin & Lead Management App (`dubaihikers_app`)

A Flutter application designed for Dubai Hikers administrators to manage event leads, track user registrations across hiking events, view and manage published outdoor events, and process customer enquiries.

## Product Overview

- **Target users**: Dubai Hikers administrators, community managers, and event organizers.
- **Main problem solved**: Simplifies lead management by grouping user registrations per event, enabling quick contact actions, monitoring payment statuses, and managing published hiking events with calendar scheduling.
- **Main features**:
  - Event-grouped lead registrations list with search and enquiry indicators (`💬 Enquiry`).
  - Lead Details screen with contact details (Name, Email, Phone), quick Call/Email actions, hiker count, and enquiry notes.
  - Published Events list with search, difficulty filter chips (**Beginner**, **Moderate**, **Advanced**, **Expert**), distance, and elevation stats.
  - Options menu (`PopupMenuButton`) to **Edit Event** (with interactive Calendar Date & Time picker) and **Delete Event** (with confirmation dialog).
  - 3-Tab Bottom Navigation (**Lead**, **Event**, **Profile**).
- **Supported platforms**: Android, iOS, and Web

## Technology Stack

- **Flutter**: Flutter SDK `^3.11.0`
- **Dart**: Dart SDK `^3.11.0`
- **Riverpod**: `flutter_riverpod` (`^2.6.1`) using `StateNotifier` & `ConsumerWidget`
- **Routing package**: `go_router` (`^14.8.0`) with `AppNavigator` facade pattern, `StatefulShellRoute`, and `flutter_web_plugins` path URL strategy
- **Networking package**: `supabase_flutter` (`^2.8.0`)
- **Local storage**: Direct Supabase database sync
- **Backend**: [Supabase](https://supabase.com) (PostgreSQL tables `events` and `event_registrations`)
- **Analytics**: N/A
- **Crash reporting**: N/A

Package versions are maintained in `pubspec.yaml`.

## Requirements

- **Flutter version**: `>= 3.11.0`
- **Dart version**: `>= 3.11.0`
- **Android Studio or Xcode requirements**: Android Studio Ladybug/Jellyfish (for Android) and Xcode 15+ (for iOS)
- **Minimum Android version**: Android 5.0 (API level 21)
- **Minimum iOS version**: iOS 12.0

## Project Setup

```bash
git clone https://github.com/rathish24/dubaihikers_app.git
cd dubaihikers_app
flutter pub get
flutter run
```
