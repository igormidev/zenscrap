# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ZenScrap Flutter is the frontend application for ZenScrap - an AI-powered web scraping rules generator. It's a multi-platform Flutter app (Web, iOS, Android, macOS) that uses Serverpod for backend communication.

## Build & Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app (defaults to localhost:8080 for Serverpod server)
flutter run -d chrome                    # Web
flutter run -d ios                       # iOS
flutter run -d android                   # Android
flutter run -d macos                     # macOS

# Run with custom server URL
flutter run --dart-define=SERVER_URL=https://api.example.com/

# Code generation (required after modifying freezed classes or Serverpod models)
dart run build_runner build --delete-conflicting-outputs

# Generate localization files (after modifying .arb files)
flutter gen-l10n

# Run all tests
flutter test

# Run a single test file
flutter test test/ui/auth/auth_layout_test.dart

# Static analysis
flutter analyze --fatal-infos

# Run structure linter (enforces widget patterns)
dart run tool/check_structure.dart
```

## Architecture

### State Management
- **Riverpod 3.0** with the Notifier pattern (not StateProvider)
- States in `lib/src/states/` with `*_state.dart` (freezed) and `*_provider.dart` pairs
- Providers in `lib/src/providers/` for app-wide services

### Routing
- **go_router** with shell routes for dashboard navigation
- Router configuration in `lib/src/providers/go_router_providers.dart`
- `RouterNotifier` rebuilds on session state changes for auth redirects

### API Communication
- **Serverpod client** accessed via global `client` variable (initialized in main.dart)
- Always use `.toResult` extension for API calls (wraps in Result type):
```dart
final result = await client.scraper.generateRules(request).toResult;
result.fold(
  (success) => handleSuccess(success),
  (error) => handleBabelException(context, error),
);
```
- For streams, use `stream.toResult(onItem, onError)`

### Theming
- Access colors via `context.c` (ColorScheme) and text styles via `context.t` (TextTheme)
- Use `color.withAlpha(128)` instead of deprecated `withOpacity(0.5)`

## Project Structure Conventions

### UI Folder Naming (Enforced by `tool/check_structure.dart`)
- `views/` - files end with `_view.dart`, classes end with `View`
- `pages/` - files end with `_page.dart`, classes end with `Page`
- `dialogs/` - files end with `_dialog.dart`, classes end with `Dialog`
- `sections/` - files end with `_section.dart`, classes end with `Section`
- `templates/` - files end with `_template.dart`, classes end with `Template`
- `widgets/` - flexible naming, no suffix requirement

### Widget Rules
- **One public widget class per file** (private widgets allowed)
- **No functions returning Widget** - always use widget classes:
```dart
// Correct: Widget class
class _CompactLayout extends StatelessWidget { ... }

// Wrong: Function returning widget
Widget _buildCompactLayout() { ... }
```

## Localization

- ARB files in `lib/l10n/` (English is template: `app_en.arb`)
- Supported: en, es, de, fr, pt_BR, ja
- Key naming: `{feature}_{description}` (e.g., `landing_hero_title`, `account_email_label`)
- Access: `AppLocalizations.of(context)!.keyName` or via `ref.watch(languageProvider)`

## Key Dependencies

- `zenscrap_client` - Serverpod-generated client (sibling package at `../zenscrap_client`)
- `result_dart` - Result type for error handling
- `freezed` - Immutable state classes (run build_runner after changes)
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `serverpod_flutter` / `serverpod_auth_idp_flutter` - Backend communication and auth

## CI Pipeline

GitHub Actions runs on push/PR to main/develop:
1. `flutter analyze --fatal-infos`
2. `dart run tool/check_structure.dart`
3. `flutter test`
