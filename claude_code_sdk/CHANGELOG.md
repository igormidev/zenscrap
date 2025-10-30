# Changelog

## 5.0.6

### Dependencies
- **Updated `programming_cli_core_sdk` to 2.1.1**: Inherits critical bug fix that resolves "No pubspec.yaml file found" error during schema validation. The core SDK now automatically creates and cleans up a minimal pubspec.yaml when running schema tests, enabling successful validation in isolated/scoped directories.

## 5.0.5

### Improvements
- **Enhanced MCP Compatibility**: Expanded the isolated environment to include additional essential environment variables (USER, TMPDIR, TEMP, TMP, SHELL, NODE_PATH) when an API key is provided. This ensures MCP servers (which run as Node.js processes via npx) have sufficient context to function properly while maintaining security isolation.

### Technical Details
- Modified `_buildEnvironment()` in `claude_chat.dart` to conditionally include essential system environment variables that MCP servers need to operate
- Maintains security: still uses `includeParentEnvironment: false` and only includes whitelisted essential variables
- Backward compatible: when no API key is provided, behavior remains unchanged

### Context
This change fixes issues where Claude CLI with API key isolation couldn't access MCP servers because npm/node processes lacked necessary environment context. Now MCP tools (Playwright, ScrapingBee, etc.) work correctly even with API key isolation enabled.

## 5.0.4

### Security
- **Isolated API Key Environment**: When an API key is provided via the SDK, the chat process now runs in a completely isolated environment. Only essential variables (PATH, HOME, ANTHROPIC_API_KEY) are passed to the CLI, preventing any parent environment credentials from leaking through.
- **Enhanced Process Security**: All processes spawned with an API key now use `includeParentEnvironment: false` and `runInShell: false` for maximum security isolation.

### Technical Details
- Modified `_buildEnvironment()` to create minimal isolated environments when `apiKey` is provided
- Updated `_spawnClaudeProcess()` to explicitly disable parent environment inheritance when using API keys
- Backward compatible: when no API key is provided, the SDK continues to use the full parent environment

## 5.0.3

### Dependencies
- **Updated `programming_cli_core_sdk` to 2.1.0**: Inherits improvements including public `chatNanoId`, `updateOptions` method, and optimized directory-level cleanup.

### Improvements
- **File operation scoping**: Now properly scopes all CLI file operations to `ai_generated_files/$chatNanoId/` by updating the `cwd` option after chat creation. This prevents the Claude CLI from creating files at the root directory.

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
