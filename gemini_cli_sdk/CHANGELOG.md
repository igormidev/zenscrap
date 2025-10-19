## 4.0.1

### Bug Fixes
- **Fixed stream subscription error**: Changed `_decorateStream` to use `StreamController<String>.broadcast()` instead of `StreamController<String>()`. This fixes the "Stream has already been listened to" error when the stream is consumed by multiple listeners (e.g., when both forwarding chunks and collecting all messages).

## 4.0.0

### Breaking Changes
- **API Key Management Refactor**: `Gemini` class now manages its own `apiKey` field directly instead of inheriting from base class.
- **Method Renamed**: `exportApiKeyToEnvironment()` has been replaced with `addApiKeyToEnvironment(String apiKey)` to match the new abstract interface signature.

### Added
- **Implements new `addApiKeyToEnvironment(String apiKey)` method**: Sets the `GEMINI_API_KEY` environment variable to allow CLI authentication without login.
- **Explicit API Key Field**: The `apiKey` is now a final field in the `Gemini` class for better clarity.

### Migration Guide
- No changes needed for SDK instantiation: `Gemini(apiKey: 'your-key')` remains the same.
- Call `await gemini.addApiKeyToEnvironment(apiKey)` after creating the instance to ensure CLI authentication works.
- If you were using `exportApiKeyToEnvironment()`, rename it to `addApiKeyToEnvironment(apiKey)`.

## 3.0.0

### Breaking Changes
- Rebuilt the SDK on top of `programming_cli_core_sdk`, aligning the Gemini, Codex, and Claude packages.
- Replaced `GeminiSdkContent` with the shared `PromptContent` abstractions for text and file prompts.
- Removed package-specific exceptions in favour of the shared `CliException` hierarchy.
- Simplified the public API to mirror other CLI SDKs; previous MCP helper models have been replaced with shared types.

### Added
- New `Gemini`/`GeminiSDK` class implementing `CodingCliInterface` with consistent session management.
- Dedicated `GeminiChatOptions` that map directly to Gemini CLI flags and shared schema tooling.
- Enhanced MCP management using the shared `McpConfig`, including popular server templates and scope-aware helpers.

### Improved
- Streaming now normalises Gemini CLI output and strips metadata automatically.
- Environment handling ensures `GEMINI_API_KEY` is injected for every process and can export to the shell on demand.
- Package layout now mirrors the other CLI SDKs with a flat `lib/src` structure.

## 2.1.0

### Breaking Changes
- `GeminiSdkContent.bytes()` now requires a `fileName` parameter for proper file identification
- Files passed via `GeminiSdkContent.file()` are now cloned to the working directory to ensure CLI access
- Temporary files are automatically cleaned up in `dispose()` method

### Added
- **File Management Improvements**:
  - Automatic file cloning to working directory for CLI accessibility
  - Unique file naming using nanoid2 to prevent conflicts
  - Guaranteed cleanup of temporary files in dispose()
- **New Parameters**:
  - `fileName` parameter (required) for `GeminiSdkContent.bytes()`
  - `fileDescription` parameter (optional) for both `bytes()` and `file()` methods
- **CLI-specific formatting**: Added `toCliString()` method for proper file references

### Fixed
- CLI tools can now access files from any location by cloning them to the working directory
- Prevents file access errors when files are outside the CLI's scope
- Ensures consistent file handling across different operating systems

## 2.0.0

### Breaking
- `sendMessageWithSchema()` now returns a record `({String llmMessage, Map<String, dynamic> structuredSchemaData})`
- Schema responses are generated via a temporary JSON file with validation and retry logic

### Added
- `streamResponseWithSchema()` companion API that streams Gemini output while structured data is produced
- Strong schema validation with descriptive error messages when required fields are missing or types mismatch

### Improved
- File-system workflow now leverages the `write_file` tool and guarantees cleanup of temporary schema files
- Better diagnostics when JSON parsing fails

## 1.1.0

### New Features
- **Auto-Update Functionality**: Added `updateToNewestVersionIfNeeded()` method
  - Automatically checks for CLI updates
  - Compares installed version with latest npm version
  - Updates to newest version if available
  - Falls back to reinstall if update fails

### Improvements
- Better version management for Gemini CLI
- Automatic handling of outdated installations
- Improved error handling during updates
- Fixed README documentation to use correct method names (`isGeminiCLIInstalled()` and `installGeminiCLI()`)

## 1.0.0

### Initial Release

- **Core Features**
  - Simple API for creating chat sessions with Google Gemini
  - Support for multiple authentication methods (API Key, OAuth, Vertex AI)
  - Session management with conversation continuity
  - Resource cleanup and disposal management
  
- **Content Types**
  - Text content support
  - File attachment support
  - Bytes content support with automatic temporary file creation
  - Automatic cleanup of temporary files on disposal
  
- **Schema Support**
  - JSON schema-based structured responses
  - Type-safe schema builders with nullable control
  - Automatic required field detection
  - Support for nested objects and arrays
  
- **Streaming**
  - Real-time streaming response support
  - Chunk-by-chunk processing
  - Process management for streaming sessions
  
- **MCP (Model Context Protocol)**
  - Full MCP server management
  - Popular MCP server installation support (filesystem, GitHub, PostgreSQL, etc.)
  - Custom MCP server configuration
  - Environment variable management for MCP servers
  
- **CLI Management**
  - Built-in Gemini CLI installation checker
  - Automatic CLI installation support
  - SDK information retrieval
  - Cross-platform support (Windows, macOS, Linux)
  
- **Developer Experience**
  - Comprehensive error handling with custom exceptions
  - Type-safe API with Dart's strong typing
  - Extensive documentation and examples
  - Unit test coverage
  
- **Examples Included**
  - Basic usage and conversation management
  - File analysis
  - Schema-based structured extraction
  - Streaming responses
  - MCP server management
  - Bytes content handling
  - Installation checking
