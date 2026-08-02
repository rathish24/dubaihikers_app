# AGENTS.md

## Purpose

Instructions for AI coding agents working in this Flutter repository.

Keep changes focused, follow the documented architecture, inspect relevant skills, and validate the result.

## Instruction Priority

Follow instructions in this order:

1. Current user request
2. `AGENTS.md`
3. `ARCHITECTURE.md`
4. Relevant files under `.agents/skills/`
5. Existing project conventions
6. Official Flutter and Dart guidance

Report material conflicts instead of silently ignoring them.

## Project Stack

This project uses:

- Flutter
- Dart
- `flutter_riverpod`
- Feature-first architecture
- Official Flutter and Dart agent skills under `.agents/skills/`

The versions in `pubspec.yaml` are the source of truth.

Do not introduce another state-management framework without an explicit architecture change.

# Mandatory Preflight

Before creating, modifying, moving, renaming, or deleting files:

1. Read `ARCHITECTURE.md`.
2. Run `git status`.
3. Inspect relevant existing code and tests.
4. Inspect available skills:

```bash
find .agents/skills -name "SKILL.md" -print
```

5. Read only the relevant `SKILL.md` files completely.
6. Identify the files expected to change.
7. Plan the required validation.

Do not claim a skill was used unless its `SKILL.md` was read.

If no skill applies, state:

```text
No relevant project skill was found.
```

For non-trivial tasks, provide only this concise preflight:

```text
## Preflight

Skills:
- <skill name or None>

Architecture:
- ARCHITECTURE.md inspected

Files:
- <expected files>

Validation:
- <commands>
```

Do not repeat the contents of `AGENTS.md`, `ARCHITECTURE.md`, or skill files in the response.

For small and obvious changes, the preflight may be performed silently. Report the skills and validation in the final response.

## Change Rules

- Make the smallest complete change.
- Preserve behaviour outside the requested scope.
- Follow existing patterns before introducing new ones.
- Do not create speculative abstractions or empty folders.
- Do not refactor unrelated code.
- Do not overwrite unrelated uncommitted changes.
- Do not edit generated files manually.
- Do not add dependencies when existing code or the SDK is sufficient.
- Do not leave fake implementations, disabled tests, silent catches, or unexplained TODOs.

## Flutter and Dart Rules

Use:

- Sound null safety
- Strong typing
- `final` where values are not reassigned
- `const` where appropriate
- Constructor injection
- Immutable state where practical
- Clear error handling
- Focused widgets and functions

Avoid:

- Unnecessary `dynamic`
- Unnecessary `late`
- Unsafe `!`
- Business logic inside widgets
- Network calls inside widgets
- Global mutable state
- Hidden static dependencies
- Expensive work inside `build`
- `BuildContext` inside business or provider logic

Dispose owned controllers, subscriptions, focus nodes, timers, and animation resources.

## Riverpod Rules

This project uses `flutter_riverpod`.

Before changing Riverpod code, follow the Riverpod section in `ARCHITECTURE.md`.

Use:

- `Provider` for dependencies and derived synchronous values
- `FutureProvider` for simple read-only asynchronous values
- `StreamProvider` for continuous streams
- `NotifierProvider` for synchronous mutable state
- `AsyncNotifierProvider` for asynchronous mutable state
- `AsyncValue` for loading, data, and error states

Use:

- `ref.watch` for reactive dependencies
- `ref.read` for commands and callbacks
- `ref.listen` for UI reactions such as navigation or snackbars

Do not:

- Use `package:provider`
- Use `ChangeNotifier` for new state
- Call APIs directly from widgets
- Call raw HTTP clients directly from providers
- Put `BuildContext`, navigation, dialogs, or widget rendering inside providers
- Import Riverpod into the domain layer

## Testing

Add or update tests for meaningful behaviour changes.

Use:

- Unit tests for use cases, repositories, mapping, validation, and providers
- Widget tests for rendering and interaction
- Integration tests for critical user journeys

Riverpod tests should use `ProviderContainer` and provider overrides.

Always dispose test containers.

Do not use real network calls or arbitrary delays in tests.

## Security

Never commit or log:

- Passwords
- API keys
- Tokens
- Certificates
- Production credentials
- Sensitive personal data

Client-side route hiding is not authorization. Protected operations must be enforced by backend rules or APIs.

## Git Safety

Do not run destructive commands without explicit approval:

```bash
git reset --hard
git clean -fd
git restore .
git checkout -- .
git push --force
```

Do not commit, push, merge, delete branches, or rewrite history unless requested.

After implementation, inspect:

```bash
git diff
git status
```

## Validation

For normal Flutter changes, run:

```bash
dart format .
flutter analyze
flutter test
```

When dependencies change:

```bash
flutter pub get
```

When generated code is used:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run targeted tests first when appropriate.

Do not claim a command passed unless it was executed successfully.

## Final Response

Use this concise format:

```text
## Changes
- <summary>

## Files
- <file>: <change>

## Skills
- <skill name or None>

## Validation
- `<command>`: Passed, failed, or not run

## Risks
- None or remaining risk
```

## Core Rule

Inspect first.

Read the relevant skills.

Follow `ARCHITECTURE.md`.

Make the smallest correct change.

Validate honestly.
