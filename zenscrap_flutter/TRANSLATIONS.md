# ZenScrap Flutter - Translation System

This document explains how internationalization (i18n) works in the ZenScrap Flutter application.

## Overview

ZenScrap uses Flutter's official localization system with:
- **flutter_localizations** - Flutter's built-in localization support
- **flutter gen-l10n** - Code generation for type-safe translations
- **ARB files** - Application Resource Bundle format for storing translations

## Supported Languages

| Code | Language | Native Name |
|------|----------|-------------|
| `en` | English | English |
| `es` | Spanish | Espanol |
| `de` | German | Deutsch |
| `fr` | French | Francais |
| `pt_BR` | Portuguese (Brazil) | Portugues (Brasil) |
| `ja` | Japanese | Japanese |

## File Locations

```
zenscrap_flutter/
├── l10n.yaml                    # Localization configuration
└── lib/
    └── l10n/
        ├── app_en.arb           # English (template)
        ├── app_es.arb           # Spanish
        ├── app_de.arb           # German
        ├── app_fr.arb           # French
        ├── app_pt.arb           # Portuguese
        ├── app_pt_BR.arb        # Portuguese (Brazil)
        ├── app_ja.arb           # Japanese
        └── app_localizations.dart  # Generated file
```

## Configuration

The `l10n.yaml` file configures the localization system:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

---

## How to Add a New Translation Key

### Step 1: Add to English ARB file (Template)

Add your key to `lib/l10n/app_en.arb` with a description:

```json
{
  "feature_my_new_key": "My translated text",
  "@feature_my_new_key": {
    "description": "Description of what this text is used for"
  }
}
```

### Step 2: Add to All Other ARB Files

Add the same key (without the `@` metadata) to each language file:

**app_es.arb:**
```json
{
  "feature_my_new_key": "Mi texto traducido"
}
```

**app_de.arb:**
```json
{
  "feature_my_new_key": "Mein ubersetzter Text"
}
```

*(Repeat for all other language files)*

### Step 3: Generate Localization Code

Run the following command:

```bash
flutter gen-l10n
```

This regenerates `app_localizations.dart` with your new key.

### Step 4: Use in Your Code

```dart
import 'package:zenscrap_flutter/l10n/app_localizations.dart';

// Option 1: Direct access
Text(AppLocalizations.of(context)!.feature_my_new_key)

// Option 2: Store in variable (recommended for multiple uses)
final l10n = AppLocalizations.of(context)!;
Text(l10n.feature_my_new_key)
```

---

## Key Naming Conventions

Use prefixes based on the feature/page where the translation is used:

| Prefix | Usage |
|--------|-------|
| `landing_` | Landing page content |
| `account_` | Account/settings pages |
| `ai_usage_` | AI usage tracking pages |
| `scrap_session_` | Scrappable editing session |
| `dashboard_` | Dashboard views |
| `common_` | Shared across multiple features |
| `error_` | Error messages |
| `validation_` | Form validation messages |

**Examples:**
```json
"landing_hero_title": "Web Scrapers That Fix Themselves",
"account_email_label": "Email",
"ai_usage_credits_overview": "AI Credits Overview"
```

---

## Using Placeholders

For dynamic content, use placeholders in your translations.

### Step 1: Define in ARB File

```json
{
  "ai_usage_percentage_used": "{percentage}% used this month",
  "@ai_usage_percentage_used": {
    "description": "Usage percentage text",
    "placeholders": {
      "percentage": {
        "type": "String"
      }
    }
  }
}
```

Supported placeholder types:
- `String`
- `int`
- `double`
- `num`
- `DateTime`

### Step 2: Use in Code

```dart
final l10n = AppLocalizations.of(context)!;

// Single placeholder
Text(l10n.ai_usage_percentage_used('75'))

// Multiple placeholders
Text(l10n.ai_usage_plan_subtitle('Pro'))
```

---

## Language Provider System

ZenScrap uses a Riverpod-based language provider for managing language selection.

### Key Files

- **`lib/src/providers/language_provider.dart`** - Contains the language management logic

### Available Providers

```dart
// Current language selection (LanguageOption object)
final languageProvider = NotifierProvider<LanguageNotifier, LanguageOption>(...);

// Current Locale for MaterialApp
final appLocaleProvider = Provider<Locale>(...);

// SupportedLanguage enum for server API calls
final serverLanguageProvider = Provider<SupportedLanguage>(...);
```

### LanguageOption Class

```dart
class LanguageOption {
  final String code;           // 'en', 'es', 'de', etc.
  final String name;           // 'English', 'Spanish', etc.
  final String nativeName;     // 'English', 'Espanol', etc.
  final String flagEmoji;      // Flag emoji
  final Locale locale;         // Flutter Locale object
  final SupportedLanguage serverLanguage;  // Server enum value
}
```

### Changing Language Programmatically

```dart
// By LanguageOption object
ref.read(languageProvider.notifier).setLanguage(languageOption);

// By language code
ref.read(languageProvider.notifier).setLanguageByCode('es');
```

---

## Language Persistence

Language selection is persisted using **SharedPreferences**.

- **Key:** `selected_language_code`
- **Value:** Language code string (e.g., `'en'`, `'es'`, `'pt_BR'`)

### How It Works

1. On app launch, `LanguageNotifier.build()` checks SharedPreferences
2. If a saved language exists, it uses that language
3. If no saved language, it detects the system locale
4. If system locale is supported, it uses that
5. Otherwise, defaults to English

---

## System Locale Detection

The app automatically detects the user's system locale on first launch:

```dart
Locale _getSystemLocale() {
  return PlatformDispatcher.instance.locale;
}

bool _isLocaleSupported(Locale locale) {
  return AppLocalizations.supportedLocales.any(
    (supported) =>
        supported.languageCode == locale.languageCode ||
        (supported.languageCode == locale.languageCode &&
            supported.countryCode == locale.countryCode),
  );
}
```

---

## Adding a New Language

### Step 1: Create ARB File

Create a new file in `lib/l10n/` following the pattern `app_XX.arb` where `XX` is the language code:

```bash
# Example: Adding Italian
touch lib/l10n/app_it.arb
```

### Step 2: Add Translations

Copy all keys from `app_en.arb` and translate them:

```json
{
  "@@locale": "it",
  "landing_nav_create_scrappable": "Crea Scrappable",
  "landing_nav_how_it_works": "Come Funziona"
  // ... all other keys
}
```

### Step 3: Update Server Enum

Add the new language to the server's `SupportedLanguage` enum in:
`zenscrap_server/lib/src/entities/supported_language.spy.yaml`

### Step 4: Update Language Provider

Add the new language to `supportedLanguages` list in `language_provider.dart`:

```dart
const List<LanguageOption> supportedLanguages = [
  // ... existing languages
  LanguageOption(
    code: 'it',
    name: 'Italian',
    nativeName: 'Italiano',
    flagEmoji: '\u{1F1EE}\u{1F1F9}', // Italy flag
    locale: Locale('it'),
    serverLanguage: SupportedLanguage.it,
  ),
];
```

### Step 5: Generate Code

```bash
flutter gen-l10n
```

### Step 6: Update Server Translations

Add the new language to server-side error translations in `zenscrap_server`. See the server TRANSLATIONS.md for details.

---

## MaterialApp Configuration

The app is configured in `lib/main.dart`:

```dart
MaterialApp.router(
  locale: locale,  // From appLocaleProvider
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
)
```

---

## Quick Reference

### Common Commands

```bash
# Generate localization files
flutter gen-l10n

# Verify ARB file syntax (JSON validation)
flutter analyze
```

### Code Snippets

```dart
// Import
import 'package:zenscrap_flutter/l10n/app_localizations.dart';

// Get translations
final l10n = AppLocalizations.of(context)!;

// Use translation
Text(l10n.landing_hero_title)

// With placeholder
Text(l10n.ai_usage_tokens_count('1500'))

// Get current language
final currentLang = ref.watch(languageProvider);

// Change language
ref.read(languageProvider.notifier).setLanguageByCode('fr');

// Get server language for API calls
final serverLang = ref.watch(serverLanguageProvider);
```

---

## Troubleshooting

### "Key not found" errors
- Ensure the key exists in ALL ARB files
- Run `flutter gen-l10n` after adding keys
- Check for typos in key names

### Translations not updating
- Run `flutter clean && flutter pub get`
- Run `flutter gen-l10n`
- Hot restart (not hot reload) the app

### Locale not being applied
- Verify `locale` is passed to `MaterialApp`
- Check that `localizationsDelegates` and `supportedLocales` are configured
- Ensure `appLocaleProvider` is being watched
