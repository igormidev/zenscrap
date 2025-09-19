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
