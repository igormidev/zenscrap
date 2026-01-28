# Zenscrap Flutter

Flutter web and mobile application for Zenscrap - the AI-powered web scraping rules generator. This package provides the user interface for creating, testing, and managing web scraping configurations.

## 🎨 Overview

Zenscrap Flutter is a modern, responsive Flutter application that provides:
- User-friendly interface for creating scraping rules
- Real-time chat with AI for rule generation
- Visual feedback during rule creation
- Scraping history and management
- Multi-platform support (Web, iOS, Android)

## 📦 Shared Core Package

Logic that needs to be consistent between the Flutter client and server is placed in the **`zenscrap_core`** package (located at `../zenscrap_core`).

When adding new functionality that must work identically on both client and server (e.g., validation rules, constants, utilities), add it to `zenscrap_core` instead of duplicating code.

See [`zenscrap_core/README.md`](../zenscrap_core/README.md) for more details.

## 🏗️ Architecture

The application follows clean architecture principles with:
- **Presentation Layer**: Flutter widgets and screens
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Serverpod client integration

```
zenscrap_flutter/
├── lib/
│   ├── src/
│   │   ├── core/              # Core utilities and extensions
│   │   │   ├── extensions/    # Dart/Flutter extensions
│   │   │   ├── utils/         # Helper functions
│   │   │   └── constants/     # App constants
│   │   ├── design_system/     # UI components and theming
│   │   │   ├── theme/         # App theme configuration
│   │   │   ├── widgets/       # Reusable widgets
│   │   │   └── default_error_snackbar.dart
│   │   ├── features/          # Feature modules
│   │   │   ├── scraper_chat/  # AI chat interface
│   │   │   ├── scraper_history/ # Scraping history
│   │   │   ├── auth/          # Authentication
│   │   │   └── settings/      # App settings
│   │   └── routing/           # App navigation
│   └── main.dart             # App entry point
├── assets/                    # Images, fonts, etc.
├── web/                      # Web-specific files
├── ios/                      # iOS-specific files
├── android/                  # Android-specific files
└── pubspec.yaml
```

## 🚀 Installation

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+
- A running Zenscrap server instance

### Setup

1. **Install dependencies**
```bash
flutter pub get
```

2. **Configure Serverpod connection**
Edit `lib/src/core/constants/api_constants.dart`:
```dart
class ApiConstants {
  static const String serverUrl = 'http://localhost:8080';
  // Update with your server URL
}
```

3. **Generate Serverpod client code**
```bash
serverpod generate --experimental-features=all
```

4. **Run the application**
```bash
# For web
flutter run -d chrome

# For iOS
flutter run -d ios

# For Android
flutter run -d android
```

## 🎯 Features

### Scraper Chat Interface
Interactive chat interface for generating scraping rules:
- Real-time AI responses
- Code highlighting for extraction rules
- Visual progress indicators
- Error handling with friendly messages

### Rule Testing & Validation
- Live preview of extraction results
- Visual feedback during testing
- Cost estimation display
- Success/failure indicators

### History Management
- View past scraping configurations
- Clone and modify existing rules
- Search and filter history
- Export configurations

### Authentication
- Secure user authentication via Serverpod
- Session management
- Protected routes

## 📱 UI/UX Guidelines

### Theme Access
The app uses custom extensions for theme access:
```dart
// Access text theme
Text('Hello', style: context.t.headlineMedium)

// Access color scheme
Container(color: context.c.primary)

// Use withAlpha for opacity (never withOpacity)
Container(color: context.c.primary.withAlpha(128))
```

### Widget Best Practices
**Always use widget classes, never functions:**
```dart
// ✅ GOOD - Widget class
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// ❌ BAD - Function returning widget
Widget _buildButton(String label, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(label),
  );
}
```

## 🔌 API Integration

### Using toResult Extension
Always use the `toResult` extension for API calls:
```dart
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';

// Make API call with proper error handling
final result = await client.scraper.generateRules(request).toResult;

result.fold(
  (success) => _handleSuccess(success),
  (error) => handleBabelException(context, error),
);
```

### Error Handling in Dialogs
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Generate Rules'),
    content: const CircularProgressIndicator(),
  ),
);

final result = await client.scraper.generateRules(request).toResult;

result.fold(
  (success) {
    Navigator.of(context).pop();
    // Handle success
  },
  (error) {
    Navigator.of(context).pop();
    handleBabelException(context, error);
  },
);
```

## 📊 State Management

The app uses Riverpod for state management:
```dart
// Define a provider
final scraperChatProvider = StateNotifierProvider<ScraperChatNotifier, ScraperChatState>(
  (ref) => ScraperChatNotifier(ref),
);

// Use in widgets
class ScraperChatScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scraperChatProvider);

    return // Your widget tree
  }
}
```

## 🎨 Design System

### Typography
```dart
// Headline styles
context.t.headlineLarge
context.t.headlineMedium
context.t.headlineSmall

// Body styles
context.t.bodyLarge
context.t.bodyMedium
context.t.bodySmall
```

### Colors
```dart
// Primary colors
context.c.primary
context.c.primaryContainer
context.c.onPrimary

// Surface colors
context.c.surface
context.c.surfaceVariant
context.c.onSurface

// Semantic colors
context.c.error
context.c.success  // Custom extension
```

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test

# Widget tests
flutter test test/widgets
```

### Test Structure
```dart
void main() {
  group('ScraperChat', () {
    testWidgets('displays loading state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScraperChatScreen(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

## 🚢 Deployment

### Web Deployment
```bash
# Build for web
flutter build web --release

# Deploy to hosting service
# Files will be in build/web/
```

### Mobile Deployment
```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
flutter build appbundle --release
```

## 🔍 Debugging Tips

### Enable Debug Mode
```dart
// In main.dart
void main() {
  debugPaintSizeEnabled = true; // Show widget boundaries
  runApp(MyApp());
}
```

### Serverpod Connection Issues
```dart
// Check server connection
print('Server URL: ${client.serverUrl}');
print('Connection status: ${client.isConnected}');
```

### Performance Profiling
```bash
# Run with performance overlay
flutter run --profile
```

## ⚠️ Important Notes

1. **Always check static analysis**: No red/yellow squiggly lines
2. **Use const constructors**: Wherever possible for performance
3. **Follow CLAUDE.md**: Project-specific guidelines
4. **Test on all platforms**: Web, iOS, and Android
5. **Handle errors gracefully**: Use handleBabelException

## 🤝 Contributing

1. Follow the widget class pattern (no function widgets)
2. Use the design system for consistent UI
3. Add tests for new features
4. Ensure static analysis passes
5. Update documentation

## 📄 License

This package is part of the Zenscrap project. See main project license.

## 🐛 Common Issues

### "withOpacity is deprecated" Error
Always use `withAlpha()` instead:
```dart
// ✅ Correct
color.withAlpha(128)

// ❌ Wrong
color.withOpacity(0.5)
```

### Serverpod Generation Errors
Always include experimental features:
```bash
serverpod generate --experimental-features=all
```

### Widget Rebuild Performance
- Use `const` constructors
- Break down large widgets
- Use widget classes, not functions

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Serverpod Documentation](https://docs.serverpod.dev)
- [Riverpod Documentation](https://riverpod.dev)
- [Material Design 3](https://m3.material.io)