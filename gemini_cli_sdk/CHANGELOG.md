## 2.0.0 - 2025-09-15

### Breaking Changes
- **BREAKING**: Changed `sendMessageWithSchema` return type from `SchemaResult` to a record `({String llmMessage, Map<String, dynamic> structuredSchemaData})`
- **BREAKING**: Completely redesigned schema handling to use file-based approach for improved reliability

### Major Improvements
- Implemented file-based JSON schema approach to resolve issues with Gemini CLI's schema parsing
- Added comprehensive schema validation with proper type checking
- Added automatic retry mechanism with error feedback (2 attempts for JSON parsing, 2 for schema validation)
- Temporary JSON files are now created for schema responses and cleaned up automatically

### New Features
- Added `_validateSchemaResponse` method for thorough schema validation
- Added `_validateFieldType` method for recursive type checking
- Added JSON parsing error recovery with detailed error messages
- Added schema validation error recovery with helpful prompts

### Bug Fixes
- Fixed issue where Gemini CLI would not return properly formatted JSON responses
- Resolved problems with schema responses containing additional text
- Fixed JSON parsing failures due to markdown code blocks in responses

### Internal Changes
- Removed deprecated `_parseSchemaResponse`, `_buildSchemaPrompt`, and `_buildRetrySchemaPrompt` methods
- Added new helper methods for file-based schema handling
- Improved error messages and debugging output

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
