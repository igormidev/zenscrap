# Changelog

## 2.0.0 - 2025-09-15

### Breaking Changes
- **BREAKING**: Changed `sendMessageWithSchema` return type from `SchemaResult` to a record `({String llmMessage, Map<String, dynamic> structuredSchemaData})`
- **BREAKING**: Completely redesigned schema handling to use file-based approach for improved reliability

### Major Improvements
- Implemented file-based JSON schema approach to fix issues with Codex CLI returning extra text
- Added comprehensive schema validation with proper type checking
- Added automatic retry mechanism with error feedback (2 attempts for JSON parsing, 2 for schema validation)
- Temporary JSON files are now created for schema responses and cleaned up automatically

### New Features
- Added `_validateSchemaResponse` method for thorough schema validation
- Added `_validateFieldType` method for recursive type checking
- Added JSON parsing error recovery with detailed error messages
- Added schema validation error recovery with helpful prompts

### Bug Fixes
- Fixed critical issue where Codex CLI would prepend timestamps and other text to JSON responses
- Resolved "Invalid response: missing responseType field" errors
- Fixed problems with schema responses containing conversational text

### Internal Changes
- Added helper methods for file-based schema handling
- Improved error messages and debugging output
- Better alignment with gemini_cli_sdk and claude_code_sdk implementations

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