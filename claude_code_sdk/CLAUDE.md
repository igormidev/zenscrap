# Claude Code SDK for Dart - Developer Documentation

> **Note:** Starting in v4.0.0 this package is built on top of
> `programming_cli_core_sdk`. Use `PromptContent` for message payloads,
> `SchemaDefinition`/`SchemaProperty` for schemas, and handle errors via
> `CliException`.

## Project Overview

This package provides a Dart SDK for interacting with Claude Code, enabling developers to integrate AI-powered coding assistance into their Dart and Flutter applications. The SDK wraps the Claude Code CLI tool and provides a clean, idiomatic Dart API.

## Architecture

### Core Components

1. **Claude Class** (`lib/src/claude.dart`)
   - Main entry point for the SDK
   - Manages API key
   - Creates and tracks chat sessions
   - Provides SDK installation and checking utilities

2. **ClaudeChat Class** (`lib/src/claude_chat.dart`)
   - Represents an individual chat session
   - Handles process spawning and management
   - Manages streaming and response collection
   - Implements schema-based messaging

3. **Models**
   - `PromptContent`: Abstract class for message content
   - `TextContent` & `FileContent`: Concrete content implementations
   - `SchemaDefinition` & `SchemaProperty`: JSON schema builders
   - `({String llmMessage, Map<String, dynamic> structuredSchemaData})`: Structured response record returned by `sendMessageWithSchema()`
   - `ClaudeChatOptions`: Configuration for chat sessions
   - `McpServer` & `McpConfig`: MCP server management models
   - `McpInstallationInfo`: MCP installation status information

4. **MCP (Model Context Protocol) Support** (`lib/src/models/mcp_models.dart`)
   - Manage MCP server configurations
   - Install and remove MCP servers
   - Query MCP installation status
   - Support for popular MCP servers (filesystem, GitHub, PostgreSQL, etc.)

5. **Exceptions**
   - Custom exception hierarchy for error handling
   - Specific exceptions for CLI issues, process errors, JSON parsing

### Communication Flow

```
Dart Application
       |
       v
   Claude SDK
       |
       v
  ClaudeChat
       |
       v
  Process.start()
       |
       v
  Claude CLI (npm package)
       |
       v
  Python SDK (optional)
       |
       v
  Claude API
```

## Key Implementation Details

### MCP (Model Context Protocol) Integration

The SDK provides comprehensive MCP support:

#### Checking MCP Installation
```dart
final mcpInfo = await claude.isMcpInstalled();
print('MCP support: ${mcpInfo.hasMcpSupport}');
print('Configured servers: ${mcpInfo.servers.length}');
```

#### Installing Popular MCP Servers
```dart
// Install filesystem MCP server
await claude.installPopularMcpServer('filesystem');

// Install GitHub MCP with environment variables
await claude.installPopularMcpServer('github', 
  environment: {'GITHUB_TOKEN': 'your-token'}
);
```

#### Managing Custom MCP Servers
```dart
// Add a custom MCP server
final customServer = McpServer(
  name: 'my-server',
  command: 'node',
  args: ['server.js'],
  env: {'API_KEY': 'key'},
);

await claude.addMcpServer('my-server', customServer: customServer);

// List all servers
final servers = await claude.listMcpServers();

// Get server details
final details = await claude.getMcpServerDetails('my-server');

// Remove a server
await claude.removeMcpServer('my-server');
```

#### Available Popular MCP Servers
- `filesystem` - File system access
- `github` - GitHub integration
- `postgres` - PostgreSQL database
- `git` - Git operations
- `puppeteer` - Web automation
- `sequential-thinking` - Problem solving
- `slack` - Slack integration
- `google-drive` - Google Drive access

### Process Management

The SDK spawns the Claude CLI as a subprocess:
- Uses `Process.start()` for non-blocking execution
- Handles stdout/stderr streams separately
- Implements proper cleanup on disposal

### Response Handling

Two modes of response collection:
1. **Standard Mode**: Collects complete response
2. **Streaming Mode**: Yields chunks as they arrive

JSON responses are parsed to extract:
- Result messages
- Assistant messages with content blocks
- Metadata (cost, duration, session ID)

### File Handling

Files are passed to Claude by:
1. Checking file existence
2. Including absolute path in prompt
3. Claude CLI's Read tool handles actual file reading

### Schema Implementation

Schema-based messaging:
1. Converts `SchemaDefinition` to JSON
2. Includes schema in prompt with instructions
3. Parses structured response from JSON output
4. Returns a record with `llmMessage` and `structuredSchemaData` once parsing succeeds

## Testing Guidelines

When testing the SDK:

### Unit Tests
- Mock `Process` class for subprocess testing
- Test schema serialization/deserialization
- Verify exception handling
- Test option building and CLI argument generation

### Integration Tests
- Require actual Claude Code CLI installation
- Use test API key or mock server
- Test real file operations
- Verify streaming functionality

### Example Test

```dart
import 'package:test/test.dart';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() {
  group('Claude SDK', () {
    test('should check if CLI is installed', () async {
      final sdk = Claude('test-key');
      final isInstalled = await sdk.isClaudeCodeSDKInstalled();
      expect(isInstalled, isA<bool>());
    });

    test('should build correct schema JSON', () {
      final schema = SchemaDefinition(
        properties: {
          'name': SchemaProperty.string(),
        },
      );
      
      final json = schema.toJson();
      expect(json['type'], equals('object'));
      expect(json['properties'], isA<Map>());
    });
  });
}
```

## Common Issues and Solutions

### Issue: CliException
**Solution**: Ensure Claude Code CLI is installed:
```bash
npm install -g @anthropic-ai/claude-code
```

### Issue: Process hangs
**Solution**: Always dispose chat sessions:
```dart
final chat = sdk.createNewChat();
try {
  // use chat
} finally {
  await chat.dispose();
}
```

### Issue: JSON parsing errors
**Solution**: Use `outputJson: true` or `streamJson: true` in options:
```dart
final chat = sdk.createNewChat(
  options: ClaudeChatOptions(outputJson: true),
);
```

## Development Workflow

### Setting Up Development Environment

1. Clone the repository
2. Install dependencies:
   ```bash
   dart pub get
   npm install -g @anthropic-ai/claude-code
   pip install claude-code-sdk  # Optional
   ```

3. Set environment variable:
   ```bash
   export ANTHROPIC_API_KEY="your-key"
   ```

### Running Examples

```bash
# Basic example
dart run example/basic_usage.dart

# File analysis
dart run example/file_analysis.dart

# Schema example
dart run example/schema_example.dart

# MCP management
dart run example/mcp_management.dart
```

### Publishing Updates

1. Update version in `pubspec.yaml`
2. Update CHANGELOG.md
3. Run tests: `dart test`
4. Dry run: `dart pub publish --dry-run`
5. Publish: `dart pub publish`

## API Design Principles

1. **Simplicity**: Easy-to-use API for common use cases
2. **Flexibility**: Advanced options for power users
3. **Safety**: Proper resource management and error handling
4. **Compatibility**: Works across platforms (Windows, macOS, Linux)
5. **Type Safety**: Leverages Dart's type system

## Future Enhancements

- [ ] Add retry logic for transient failures
- [ ] Implement connection pooling for multiple chats
- [ ] Add caching for repeated queries
- [x] Support for custom MCP tools
- [ ] Better progress indicators for long operations
- [ ] Add metrics and telemetry support
- [ ] Desktop Extension (.dxt) support for one-click MCP installation
- [ ] Auto-discovery of available MCP servers from npm registry

## Dependencies

### Runtime Dependencies
- `path`: For cross-platform path handling
- `uuid`: For generating session IDs

### External Requirements
- Node.js and npm (for Claude CLI)
- Python and pip (optional, for Python SDK features)
- Anthropic API key

## Security Considerations

1. **API Key Safety**: Never hardcode API keys
2. **Process Isolation**: Each chat runs in separate process
3. **File Access**: Validate file paths before sending
4. **Input Sanitization**: Clean user input before passing to CLI
5. **Resource Limits**: Implement timeouts to prevent hanging

## Performance Tips

1. **Reuse Chat Sessions**: Don't create new sessions for each message
2. **Batch Operations**: Send multiple contents in single message
3. **Use Streaming**: For long responses, use streaming mode
4. **Dispose Properly**: Always clean up resources
5. **Set Timeouts**: Configure reasonable timeouts

## Debugging

### Enable Verbose Logging

```dart
final chat = sdk.createNewChat(
  options: ClaudeChatOptions(
    // Add verbose flag when available
  ),
);
```

### Monitor Process Output

The SDK prints stderr to console for debugging:
```dart
// In claude_chat.dart
print('Claude stderr: $line');
```

### Check Installation Status

```dart
final info = await sdk.getSDKInfo();
print('SDK Status: $info');
```

## Contributing

When contributing:

1. Follow Dart style guide
2. Add tests for new features
3. Update documentation
4. Ensure backward compatibility
5. Run `dart format` and `dart analyze`

## Support Matrix

| Platform | Status | Notes |
|----------|--------|-------|
| macOS    | ✅ Supported | Fully tested |
| Linux    | ✅ Supported | Fully tested |
| Windows  | ✅ Supported | Uses cmd.exe |
| Web      | ❌ Not Supported | Requires subprocess |

## License

MIT License - See LICENSE file for details

## Contact

For SDK-specific issues, open an issue on GitHub.
For Claude Code issues, refer to [Anthropic documentation](https://docs.anthropic.com/en/docs/claude-code).
