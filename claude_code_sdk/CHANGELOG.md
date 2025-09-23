# Changelog

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
