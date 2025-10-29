# Changelog

## 4.1.4

### Security
- **Isolated API Key Environment**: When an API key is provided via the SDK, the chat process now runs in a completely isolated environment. Only essential variables (PATH, HOME) plus the API key are passed to the CLI, preventing any parent environment credentials from leaking through.
- **Enhanced Process Security**: All processes spawned with an API key now use `includeParentEnvironment: false` and `runInShell: false` for maximum security isolation.

### Technical Details
- Modified `_buildEnvironment()` to create minimal isolated environments when `apiKey` is provided
- Updated `_loginViaStdin()` to use isolated environment during authentication
- Updated `Process.start()` calls to explicitly disable parent environment inheritance when using API keys
- Backward compatible: when no API key is provided, the SDK continues to use the full parent environment

## 4.1.3

### Fixed
- **MCP Support**: Fixed critical bug where MCP (Model Context Protocol) servers were not accessible in chat sessions. When `enableMcp: true`, the SDK now uses the global CODEX_HOME instead of creating an isolated one, allowing the chat to access globally configured MCP servers like Playwright and ScrapingBee.
- **API Key with MCP**: When MCP is enabled and an API key is provided, the SDK now sets `OPENAI_API_KEY` via environment variable instead of using isolated authentication, ensuring both MCP access and authentication work together.

## 4.1.2

### Dependencies
- **Updated `programming_cli_core_sdk` to 2.1.0**: Inherits improvements including public `chatNanoId`, `updateOptions` method, and optimized directory-level cleanup.

### Improvements
- **File operation scoping**: Now properly scopes all CLI file operations to `ai_generated_files/$chatNanoId/` by updating the `cwd` option after chat creation. This prevents the Codex CLI from creating files at the root directory.

## 4.1.1

### Dependencies
- **Updated `programming_cli_core_sdk` to 2.0.1**: Inherits critical file cleanup fix that guarantees temporary files and schema test files are always deleted, even when errors occur.

## 4.1.0

### Breaking Changes
- **Authentication Method Changed**: Codex CLI >= 0.36.0 no longer reads `OPENAI_API_KEY` from environment variables. The SDK now uses `codex login --with-api-key` with stdin authentication.

### Added
- **Stdin API Key Login**: When an API key is provided, the SDK automatically performs `codex login --with-api-key` and pipes the API key via stdin
- **Isolated CODEX_HOME**: Each chat session with an API key creates an isolated temporary `CODEX_HOME` directory to avoid polluting the global `~/.codex` configuration
- **Automatic Cleanup**: Temporary `CODEX_HOME` directories are automatically cleaned up on dispose
- **Real-time Streaming**: Uses `script` command to create a pseudo-terminal (PTY) for unbuffered output, enabling true real-time streaming of LLM responses

### Fixed
- **401 Unauthorized Errors**: Fixed authentication failures that occurred with Codex CLI >= 0.36.0 when trying to use environment variables
- **CLI Authentication**: SDK now properly authenticates with modern Codex CLI versions
- **Streaming Buffering**: Fixed issue where streaming responses would buffer and appear all at once at the end instead of incrementally

### Technical Details
- On macOS: Uses `script -q /dev/null codex [args...]` to force line-buffering
- On Linux: Uses `script -qec "codex [args...]" /dev/null` to force line-buffering
- On Windows: Runs `codex` directly (PTY support may be limited)

### Migration Guide
- **No code changes required** - API usage remains the same
- If you have Codex CLI >= 0.36.0, authentication will now work correctly with API keys
- Streaming now works in real-time without any code changes
- For older Codex CLI versions (<0.36.0), consider upgrading to benefit from improved authentication

## 4.0.0

### Breaking Changes
- **API Key Management Refactor**: `Codex` class now manages its own `apiKey` field directly instead of inheriting from base class.
- **Method Renamed**: `exportApiKeyToEnvironment()` has been replaced with `addApiKeyToEnvironment(String apiKey)` to match the new abstract interface signature.

### Added
- **Implements new `addApiKeyToEnvironment(String apiKey)` method**: Performs `codex login --with-api-key` to authenticate the CLI.
- **Explicit API Key Field**: The `apiKey` is now an optional field in the `Codex` class.

### Migration Guide
- No changes needed for SDK instantiation: `Codex(apiKey: 'your-key')` remains the same.
- API key is now optional - you can use `Codex()` if the CLI is already logged in.

## 3.0.0

### Breaking Changes
- Migrated to the shared `programming_cli_core_sdk` foundation for chat orchestration.
- Replaced `CodexSdkContent` with `PromptContent` from the core package.
- Removed package-specific exceptions in favour of the shared `CliException` hierarchy.
- Refactored `CodexChatOptions` to extend `CliChatOptions`; the `timeoutMs` field has been removed.
- Deleted schema helper types in favour of `SchemaProperty` from the core SDK.
- Package structure flattened under `lib/src` (no nested folders).

### Added
- `Codex` now implements `CodingCliInterface`, enabling consistent behaviour across CLI SDKs.
- `CodexChat` extends `CliChatInterface` to inherit shared schema testing, temporary file management, and streaming utilities.
- Re-exported the entire core SDK for convenient access to shared abstractions.

### Improved
- Simplified command construction pipeline—Codex packages now focus on describing CLI invocations only.
- Session tracking is handled consistently, including support for schema workflows through the shared engine.
- Documentation and examples rewritten to use the new shared primitives.

## 2.1.0

### Breaking Changes
- `CodexSdkContent.bytes()` now requires a `fileName` parameter for proper file identification
- Files passed via `CodexSdkContent.file()` are now cloned to the working directory to ensure CLI access
- Temporary files are automatically cleaned up in `dispose()` method

### Added
- **File Management Improvements**:
  - Automatic file cloning to working directory for CLI accessibility
  - Unique file naming using nanoid2 to prevent conflicts
  - Guaranteed cleanup of temporary files in dispose()
- **New Parameters**:
  - `fileName` parameter (required) for `CodexSdkContent.bytes()`
  - `fileDescription` parameter (optional) for both `bytes()` and `file()` methods
- **CLI-specific formatting**: Added `toCliString()` method for proper file references

### Fixed
- CLI tools can now access files from any location by cloning them to the working directory
- Prevents file access errors when files are outside the CLI's scope
- Ensures consistent file handling across different operating systems

## 2.0.0

### Breaking
- `sendMessageWithSchema()` now returns a record `({String llmMessage, Map<String, dynamic> structuredSchemaData})` instead of `SchemaResult`
- Schema generation uses a temporary JSON file with automatic validation and retry logic

### Added
- `streamResponseWithSchema()` for streaming LLM output while structured data is generated
- Strong schema validation with detailed error feedback when required fields or types mismatch
- `CodexChatOptions` now supports `sandboxMode`, `approvalPolicy`, and additional CLI arguments for full-autonomy workflows

### Improved
- CLI interactions now clean up generated schema files even on failure
- Better safety and diagnostics when JSON parsing fails

## 1.2.0

### Added
- **Auto-Update Functionality**: Added `updateToNewestVersionIfNeeded()` method
  - Automatically checks for CLI updates
  - Compares installed version with latest npm version
  - Updates to newest version if available
  - Falls back to reinstall if update fails

### Improvements
- Better version management for Codex CLI
- Automatic handling of outdated installations
- Improved error handling during updates

## 1.1.0

### Added
- **Reasoning Effort Support**
  - Added `reasoningEffort` field to `CodexChatOptions` for controlling model reasoning depth
  - Support for 'minimal', 'medium', and 'high' reasoning effort levels
  - Added `changeModelWithEffort()` method to change both model and reasoning effort
  - Automatically passes `--reasoning-effort` flag to Codex CLI when specified

### Enhanced
- Better support for GPT-5 and GPT-OSS-120B models with configurable reasoning effort
- Improved model switching capabilities with reasoning effort control

## 1.0.0

### Initial Release

- **Core Features**
  - Complete SDK for interacting with OpenAI Codex CLI
  - Full support for text, file, and bytes content types
  - Session management with resume and continue capabilities
  - Structured responses with JSON schema support

- **Chat Functionality**
  - Multiple operation modes: suggest, auto-edit, full-auto
  - Streaming response support
  - Session persistence and conversation continuity
  - Custom system prompts and model selection

- **MCP (Model Context Protocol) Support**
  - Install and manage MCP servers
  - Support for popular MCP servers (filesystem, GitHub, PostgreSQL, etc.)
  - Custom MCP server configuration
  - TOML configuration file management

- **Installation & Setup**
  - Auto-detection of Codex CLI installation
  - Built-in installer for Codex CLI via npm
  - API key management with environment variable support

- **Developer Experience**
  - Comprehensive error handling with specific exception types
  - Extensive unit test coverage
  - Rich examples for all major features
  - Type-safe schema building with nullable control
  - Automatic resource cleanup and disposal

- **Documentation**
  - Complete API documentation
  - Usage examples for all features
  - Troubleshooting guide
  - pub.dev compliant package structure
