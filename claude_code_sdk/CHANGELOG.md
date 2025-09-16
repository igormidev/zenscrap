## 3.0.0 - 2025-09-15

### Breaking Changes
- **BREAKING**: Changed `sendMessageWithSchema` return type from `SchemaResult` to a record `({String llmMessage, Map<String, dynamic> structuredSchemaData})`
- **BREAKING**: Completely redesigned schema handling to use file-based approach for improved reliability

### Major Improvements
- Implemented file-based JSON schema approach for better compatibility with Claude Code CLI
- Added comprehensive schema validation with proper type checking
- Added automatic retry mechanism with error feedback (2 attempts for JSON parsing, 2 for schema validation)
- Temporary JSON files are now created for schema responses and cleaned up automatically

### New Features
- Added `_validateSchemaResponse` method for thorough schema validation
- Added `_validateFieldType` method for recursive type checking
- Added JSON parsing error recovery with detailed error messages
- Added schema validation error recovery with helpful prompts
- Uses Claude Code's `@filename/` syntax for file references

### Bug Fixes
- Fixed issues with Claude Code returning non-JSON text alongside structured data
- Resolved problems with schema responses containing markdown formatting
- Fixed JSON parsing failures in various edge cases

### Internal Changes
- Removed deprecated `_parseSchemaResponse`, `_buildSchemaPrompt`, and `_buildRetrySchemaPrompt` methods
- Added new helper methods for file-based schema handling
- Improved error messages and debugging output

## 2.1.0

### New Features
- **Auto-Update Functionality**: Added `updateToNewestVersionIfNeeded()` method
  - Automatically checks for CLI updates
  - Compares installed version with latest npm version
  - Updates to newest version if available
  - Also updates Python SDK if installed
  - Falls back to reinstall if update fails

### Improvements
- Better version management for Claude Code CLI
- Automatic handling of outdated installations
- Improved error handling during updates

## 2.0.0

### Breaking Changes
- **Default Model Changed**: Claude Sonnet 4 (`claude-sonnet-4-20250514`) is now the default model
  - Previous default was Claude 3.5 Sonnet
  - Sonnet 4 offers significantly better performance and capabilities
  - To use the old default, explicitly specify `model: 'claude-3-5-sonnet-20241022'`

### New Features
- **Claude 4 Models Support**: Added support for the latest Claude 4 family
  - Claude Sonnet 4 (`claude-sonnet-4-20250514`) - Balanced performance, now the default
  - Claude Opus 4 (`claude-opus-4-20250514`) - Most powerful for complex tasks
  - Claude Opus 4.1 (`claude-opus-4-1-20250805`) - Latest incremental update

- **Claude 3.7 Support**: Added Claude 3.7 Sonnet
  - `claude-3-7-sonnet-20250219` - Hybrid reasoning model with step-by-step thinking

### Model Updates
- All latest model IDs verified from official Anthropic documentation
- Models use exact API identifiers (e.g., `claude-opus-4-1-20250805`)
- Added comprehensive model documentation in README
- Legacy Claude 3 models marked as deprecated but still available

### Improvements
- Better error messages when model is not found
- Improved model validation and error handling
- Updated documentation with model selection guide
- Performance improvements with newer models

### Migration Guide
- If you were using the default model, your code will automatically use Claude Sonnet 4
- For specific model requirements, update your model strings:
  - `claude-3.5-sonnet` → `claude-3-5-sonnet-20241022`
  - `claude-3.5-haiku` → `claude-3-5-haiku-20241022`
- Consider upgrading to Claude 4 models for better performance

## 1.3.0

### New Features
- **Smart Schema Retry Mechanism**: Automatically retries schema parsing with error context when initial parsing fails
  - First attempt uses normal schema parsing
  - On failure, sends detailed error feedback to Claude for correction
  - Provides clear instructions about what went wrong (markdown blocks, mixed content, syntax errors)
  - Includes the original error and response for context
  - Significantly improves reliability of schema-based responses

### Improvements
- **Enhanced JSON Parsing**: Improved `_parseSchemaResponse` method with multiple strategies
  - Automatically removes markdown code blocks (```)
  - Tries to parse entire response as JSON first
  - Falls back to regex extraction for mixed content
  - Multiple regex patterns for better JSON detection
  - Handles common formatting issues automatically

- **Better Error Handling**: Enhanced `JSONDecodeException` class
  - Now includes `rawContent` field for debugging
  - Truncates long content to prevent token overflow
  - Provides more detailed error messages
  - Better toString() implementation with context

### Technical Details
- Added `_buildRetrySchemaPrompt()` method for intelligent retry prompts
- Modified `sendMessageWithSchema()` to implement two-attempt strategy
- Updated exception handling to support new error information
- Maintains backward compatibility with existing code

## 1.2.0

### New Features
- **Smart Schema Retry Mechanism**: Automatically retries schema parsing with error context when initial parsing fails
  - First attempt uses normal schema parsing
  - On failure, sends detailed error feedback to Claude for correction
  - Provides clear instructions about what went wrong (markdown blocks, mixed content, syntax errors)
  - Includes the original error and response for context
  - Significantly improves reliability of schema-based responses

### Improvements
- **Enhanced JSON Parsing**: Improved `_parseSchemaResponse` method with multiple strategies
  - Automatically removes markdown code blocks (```)
  - Tries to parse entire response as JSON first
  - Falls back to regex extraction for mixed content
  - Multiple regex patterns for better JSON detection
  - Handles common formatting issues automatically

- **Better Error Handling**: Enhanced `JSONDecodeException` class
  - Now includes `rawContent` field for debugging
  - Truncates long content to prevent token overflow
  - Provides more detailed error messages
  - Better toString() implementation with context

### Technical Details
- Added `_buildRetrySchemaPrompt()` method for intelligent retry prompts
- Modified `sendMessageWithSchema()` to implement two-attempt strategy
- Updated exception handling to support new error information
- Maintains backward compatibility with existing code

## 1.1.0

- Added comprehensive MCP (Model Context Protocol) support:
  - New `isMcpInstalled()` method to check MCP installation and list configured servers
  - `listMcpServers()` to get all configured MCP servers
  - `addMcpServer()` to add custom or npm-based MCP servers
  - `removeMcpServer()` to remove MCP servers
  - `getMcpServerDetails()` to get details about specific servers
  - `installPopularMcpServer()` for easy installation of popular servers
  - `getPopularMcpServers()` to list available popular servers
- New MCP models and types:
  - `McpServer` - MCP server configuration model
  - `McpConfig` - MCP configuration management
  - `McpInstallationInfo` - Installation status information
  - `McpScope` - Server scope enum (project/user/system)
  - `McpServerStatus` - Server status enum
  - `McpAddOptions` - Options for adding servers
  - `PopularMcpServers` - Pre-configured popular servers
- Pre-configured popular MCP servers:
  - filesystem - File system access
  - github - GitHub integration
  - postgres - PostgreSQL database
  - git - Git operations
  - puppeteer - Web automation
  - sequential-thinking - Problem solving
  - slack - Slack integration
  - google-drive - Google Drive access
- Added MCP management example in `example/mcp_management.dart`
- Updated SDK info to include MCP status
- Full Windows support with cmd wrapper option

## 1.0.0

- Initial release of Claude Code SDK for Dart
- Core features:
  - Create and manage chat sessions with Claude
  - Send text messages and file references
  - Schema-based structured responses
  - Real-time streaming of responses
  - Automatic SDK installation checking
  - Cross-platform support (Windows, macOS, Linux)
- Comprehensive error handling with custom exceptions
- Resource management with proper disposal
- Full test coverage
- Complete documentation and examples
