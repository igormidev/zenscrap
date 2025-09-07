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
