# ZenScrap Server - Translation System

This document explains how server-side translations work in the ZenScrap backend.

## Overview

The server uses a centralized translation system for error messages and API responses. This ensures users receive error messages in their preferred language when API calls fail.

## Key Components

| File | Purpose |
|------|---------|
| `lib/src/entities/supported_language.spy.yaml` | Serverpod entity defining the `SupportedLanguage` enum |
| `lib/src/generated/entities/supported_language.dart` | Generated enum file |
| `lib/src/core/translations/error_translations.dart` | Translation strings and helper functions |

## SupportedLanguage Enum

The `SupportedLanguage` enum defines all supported languages:

```dart
enum SupportedLanguage {
  en,    // English
  es,    // Spanish
  de,    // German
  fr,    // French
  ptBR,  // Portuguese (Brazil)
  ja,    // Japanese
}
```

---

## Error Translations File

**Location:** `lib/src/core/translations/error_translations.dart`

This file contains two main maps and helper functions:

### Structure

```dart
// Error titles (short)
const Map<String, Map<SupportedLanguage, String>> _errorTitles = { ... };

// Error descriptions (detailed)
const Map<String, Map<SupportedLanguage, String>> _errorDescriptions = { ... };
```

### Helper Functions

```dart
// Get translated title
String getErrorTitle(String key, SupportedLanguage lang);

// Get translated description
String getErrorDescription(String key, SupportedLanguage lang);

// Get description with parameter substitution
String getErrorDescriptionWithParams(
  String key,
  SupportedLanguage lang,
  Map<String, String> params,
);

// Create a complete ZenScrapException
ZenScrapException createTranslatedException(
  String key,
  SupportedLanguage lang, {
  Map<String, String>? params,
});
```

---

## How to Add a New Error Translation

### Step 1: Add to Error Titles Map

Add your error key with translations for all languages:

```dart
const Map<String, Map<SupportedLanguage, String>> _errorTitles = {
  // ... existing entries

  'my_new_error': {
    SupportedLanguage.en: 'My New Error',
    SupportedLanguage.es: 'Mi Nuevo Error',
    SupportedLanguage.de: 'Mein Neuer Fehler',
    SupportedLanguage.fr: 'Ma Nouvelle Erreur',
    SupportedLanguage.ptBR: 'Meu Novo Erro',
    SupportedLanguage.ja: '新しいエラー',
  },
};
```

### Step 2: Add to Error Descriptions Map

Add the corresponding description:

```dart
const Map<String, Map<SupportedLanguage, String>> _errorDescriptions = {
  // ... existing entries

  'my_new_error': {
    SupportedLanguage.en: 'A detailed explanation of what went wrong.',
    SupportedLanguage.es: 'Una explicacion detallada de lo que salio mal.',
    SupportedLanguage.de: 'Eine detaillierte Erklarung, was schief gelaufen ist.',
    SupportedLanguage.fr: 'Une explication detaillee de ce qui s\'est mal passe.',
    SupportedLanguage.ptBR: 'Uma explicacao detalhada do que deu errado.',
    SupportedLanguage.ja: '何が問題だったかの詳細な説明。',
  },
};
```

### Step 3: Use in Your Endpoint

```dart
throw createTranslatedException('my_new_error', language);
```

---

## Using Placeholders in Descriptions

For dynamic error messages, use `{paramName}` placeholders.

### Define with Placeholders

```dart
'endpoint_limit_reached': {
  SupportedLanguage.en: 'You have reached the maximum number of endpoints ({maxAllowed}) for your {planName} plan.',
  SupportedLanguage.es: 'Has alcanzado el numero maximo de endpoints ({maxAllowed}) para tu plan {planName}.',
  // ... other languages
},
```

### Use with Parameters

```dart
throw createTranslatedException(
  'endpoint_limit_reached',
  language,
  params: {
    'maxAllowed': '10',
    'planName': 'Pro',
  },
);
```

Or use the helper function directly:

```dart
final description = getErrorDescriptionWithParams(
  'endpoint_limit_reached',
  language,
  {'maxAllowed': '10', 'planName': 'Pro'},
);
```

---

## How Endpoints Receive Language Parameter

Most endpoints accept a `SupportedLanguage` parameter to determine the response language.

### Example Endpoint Signature

```dart
Future<MyResponse> myEndpoint(
  Session session,
  SupportedLanguage language,
  // ... other parameters
) async {
  // Use language for error translations
  if (someConditionFails) {
    throw createTranslatedException('some_error', language);
  }
  // ...
}
```

### Client-Side Language Passing

The Flutter client uses `serverLanguageProvider` to get the current language:

```dart
// In Flutter client
final serverLang = ref.read(serverLanguageProvider);
await client.myEndpoint.myEndpoint(serverLang, otherParams);
```

---

## Error Key Categories

The translation system organizes errors by category:

### Authentication Errors
- `authentication_failed`
- `user_not_authenticated`
- `authentication_required_delete`
- `authentication_required_edit`
- `authentication_required_marketplace`
- `authentication_required_api_key`
- `authentication_required_session`
- `authentication_required_ai_model`

### Account Errors
- `account_not_found`
- `account_not_found_for_user`
- `account_creation_failed`
- `account_creation_internal_error`
- `database_error`

### Scrappable Errors
- `scrappable_not_found`
- `scrappable_not_found_attach`
- `scrappable_not_found_clone`
- `scrappable_not_found_or_no_access`
- `scrappable_already_attached`
- `scrappable_not_available`
- `scrappable_not_found_by_id`
- `scrappable_private_cannot_clone`

### API Key Errors
- `api_key_not_found`
- `api_key_not_found_active`
- `api_key_database_not_found`
- `cannot_deactivate_api_key`
- `invalid_api_key`
- `invalid_api_key_account`
- `invalid_api_key_format`
- `failed_to_save_api_key`

### Subscription/Plan Errors
- `ultra_plan_required`
- `ultra_plan_required_marketplace`
- `upgrade_required`
- `upgrade_required_clone`
- `upgrade_required_ai_model`
- `checkout_creation_failed`
- `no_active_subscription`
- `already_subscribed`
- `subscription_error`
- `subscription_cancel_failed`
- `subscription_checkout_failed`
- `customer_portal_failed`
- `no_stripe_customer`
- `user_email_not_found`

### Access/Permission Errors
- `access_denied`
- `access_denied_permission`
- `permission_denied`
- `permission_denied_delete`
- `permission_denied_edit`

### Usage Limit Errors
- `usage_limit_reached`
- `ai_credits_exhausted`
- `endpoint_limit_reached`
- `insufficient_credits`
- `concurrency_limit_exceeded`

### Validation Errors
- `invalid_name`
- `name_too_long`
- `invalid_description`
- `description_too_long`
- `missing_extract_rules`
- `missing_path_parameter`

### Session Errors
- `session_not_found`
- `session_already_opened`
- `ai_usage_record_not_found`
- `no_active_test_session`
- `test_period_expired`
- `test_data_not_found`

### Operation Errors
- `already_deleted`
- `delete_failed`
- `update_failed`
- `ai_generation_failed`
- `unexpected_error`

### Deploy Errors
- `no_byte_data_to_deploy`
- `authentication_or_reference_data`

---

## Adding a New Language to Server

### Step 1: Update Serverpod Entity

Edit `lib/src/entities/supported_language.spy.yaml`:

```yaml
enum: SupportedLanguage
values:
  - en
  - es
  - de
  - fr
  - ptBR
  - ja
  - it  # New language
```

### Step 2: Regenerate Code

```bash
serverpod generate --experimental-features=all
```

### Step 3: Add Translations

Add the new language to EVERY entry in `_errorTitles` and `_errorDescriptions`:

```dart
'authentication_failed': {
  SupportedLanguage.en: 'Authentication Failed',
  SupportedLanguage.es: 'Autenticacion Fallida',
  SupportedLanguage.de: 'Authentifizierung fehlgeschlagen',
  SupportedLanguage.fr: 'Echec de l\'authentification',
  SupportedLanguage.ptBR: 'Falha na Autenticacao',
  SupportedLanguage.ja: '認証に失敗しました',
  SupportedLanguage.it: 'Autenticazione Fallita',  // New
},
```

### Step 4: Update Flutter Client

After regenerating, the Flutter client will need to be regenerated as well:

```bash
cd zenscrap_client
serverpod generate --experimental-features=all
```

Then update `language_provider.dart` in the Flutter app (see Flutter TRANSLATIONS.md).

---

## Usage Examples

### Simple Error

```dart
// In an endpoint
Future<void> deleteAccount(Session session, SupportedLanguage language) async {
  final account = await findAccount(session);

  if (account == null) {
    throw createTranslatedException('account_not_found', language);
  }

  // ... delete logic
}
```

### Error with Parameters

```dart
Future<void> attachEndpoint(
  Session session,
  SupportedLanguage language,
  int scrappableId,
) async {
  final account = await getAccount(session);
  final currentCount = await countEndpoints(account);
  final maxAllowed = account.plan.maxEndpoints;

  if (currentCount >= maxAllowed) {
    throw createTranslatedException(
      'endpoint_limit_reached',
      language,
      params: {
        'maxAllowed': maxAllowed.toString(),
        'planName': account.plan.name,
      },
    );
  }

  // ... attach logic
}
```

### Using Individual Getters

```dart
// When you need just the title or description separately
final title = getErrorTitle('api_key_not_found', language);
final description = getErrorDescription('api_key_not_found', language);

// Log or use separately
session.log('Error: $title - $description');
```

---

## Fallback Behavior

The translation system includes fallback logic:

1. If a translation exists for the requested language, it's used
2. If not found, falls back to English (`SupportedLanguage.en`)
3. If English is also missing, returns the key itself

```dart
String getErrorTitle(String key, SupportedLanguage lang) {
  return _errorTitles[key]?[lang]
      ?? _errorTitles[key]?[SupportedLanguage.en]
      ?? key;
}
```

---

## Quick Reference

### Create Translated Exception

```dart
throw createTranslatedException('error_key', language);

// With parameters
throw createTranslatedException(
  'error_key',
  language,
  params: {'param1': 'value1'},
);
```

### Get Individual Strings

```dart
final title = getErrorTitle('key', language);
final desc = getErrorDescription('key', language);
final descWithParams = getErrorDescriptionWithParams(
  'key',
  language,
  {'param': 'value'},
);
```

### Common Commands

```bash
# Regenerate Serverpod code after enum changes
serverpod generate --experimental-features=all

# Run server
dart bin/main.dart

# Run tests
dart test
```

---

## Best Practices

1. **Always add all languages** - When adding a new error key, add translations for ALL supported languages
2. **Use meaningful keys** - Error keys should be descriptive: `authentication_required_delete` not `auth_error_1`
3. **Keep descriptions helpful** - Include actionable information when possible
4. **Test with different languages** - Verify translations display correctly
5. **Keep titles short** - Titles should be concise; use descriptions for details
6. **Use parameters for dynamic content** - Don't concatenate strings; use placeholders
