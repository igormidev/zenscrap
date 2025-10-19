# Changelog

## 5.0.2

### Dependencies
- **Updated `programming_cli_core_sdk` to 2.0.1**: Inherits critical file cleanup fix that guarantees temporary files and schema test files are always deleted, even when errors occur.

## 5.0.1

### Bug Fixes
- **Fixed stream subscription error**: Changed `_transformClaudeStream` to use `StreamController<String>.broadcast()` instead of `StreamController<String>()`. This fixes the "Stream has already been listened to" error when the stream is consumed by multiple listeners (e.g., when both forwarding chunks and collecting all messages).

## 5.0.0

### Breaking Changes
- **API Key Management Refactor**: `Claude` class now manages its own `apiKey` field directly instead of inheriting from base class.
- **Method Renamed**: `exportApiKeyToEnvironment()` has been replaced with `addApiKeyToEnvironment(String apiKey)` to match the new abstract interface signature.

### Added
- **Implements new `addApiKeyToEnvironment(String apiKey)` method**: Sets the `ANTHROPIC_API_KEY` environment variable to allow CLI authentication without login.
- **Explicit API Key Field**: The `apiKey` is now a final field in the `Claude` class for better clarity.

### Migration Guide
- No changes needed for SDK instantiation: `Claude(apiKey: 'your-key')` remains the same.
- Call `await claude.addApiKeyToEnvironment(apiKey)` after creating the instance to ensure CLI authentication works.
- If you were using `exportApiKeyToEnvironment()`, rename it to `addApiKeyToEnvironment(apiKey)`.

## 4.0.0

### Breaking Changes
- Migrated the SDK onto the shared `programming_cli_core_sdk` abstractions.
- Replaced `ClaudeSdkContent`, schema, and exception classes with the shared `PromptContent`, `SchemaDefinition`, and `CliException` types.
- `ClaudeChat` now extends `CliChatInterface`; structured-schema flows and temporary file management are handled by the core package.
- Restructured the library exports and file layout under `lib/src/`.

### Added
- Streaming support now routes through the shared core infrastructure while decoding Claude's JSON stream events.
- `Claude.exportApiKeyToEnvironment()` helper to surface the API key to `ANTHROPIC_API_KEY` via shell command.

### Removed
- Custom content and exception classes in favour of the shared implementations.
- Legacy tests that depended on the previous bespoke abstractions.

## 3.1.0

- Historical release notes retained for reference.
