# Changelog

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