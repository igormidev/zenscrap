# Changelog

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