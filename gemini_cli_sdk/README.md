# Gemini CLI SDK for Dart

A powerful Dart SDK for interacting with Google Gemini CLI, providing seamless integration with AI-powered coding assistance through the Gemini CLI.

## Features

- 🚀 **Easy Integration**: Simple API for creating chat sessions with Gemini
- 📁 **File Support**: Send files along with text prompts for context-aware responses
- 💾 **Bytes Support**: Send in-memory data as temporary files (auto-cleanup on dispose)
- 📋 **Schema Support**: Get structured responses using JSON schemas
- 🔄 **Session Management**: Automatic conversation continuity
- 🛠️ **Auto-Installation**: Built-in methods to check and install Gemini CLI
- 🔌 **MCP Support**: Full Model Context Protocol integration for connecting to external tools
- 🧹 **Resource Management**: Proper cleanup and disposal of chat sessions and temp files
- 🔐 **Secure**: API key management with environment variable support
- ⚡ **Reliable**: Simple Process.run based implementation (no streaming complexity)
- 🌊 **Streaming**: Support for streaming responses in real-time

## Prerequisites

Before using this SDK, you need:

1. **Node.js and npm** (for Gemini CLI)
   - Download from [nodejs.org](https://nodejs.org/)
   
2. **Gemini CLI**
   - Install globally: `npm install -g @google/gemini-cli`
   - Or via Homebrew: `brew install gemini-cli`
   - Or use the SDK's built-in installer (see below)

3. **Gemini API Key**
   - Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Free tier: 60 requests/min, 1,000 requests/day (with OAuth)
   - Or use API key tier: 100 requests/day

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  gemini_cli_sdk: ^1.1.0
```

Then run:

```bash
dart pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  // Initialize the SDK with your API key
  final geminiSDK = GeminiSDK('YOUR_API_KEY');
  
  // Create a new chat session
  final geminiChat = geminiSDK.createNewChat();
  
  try {
    // Send a simple text message
    final result = await geminiChat.sendMessage([
      GeminiSdkContent.text('What is the capital of France?'),
    ]);
    
    print('Gemini says: $result');
  } finally {
    // Always dispose of the chat when done
    await geminiChat.dispose();
  }
}
```

### Sending Files with Messages

```dart
import 'dart:io';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  final geminiSDK = GeminiSDK('YOUR_API_KEY');
  final geminiChat = geminiSDK.createNewChat();
  
  try {
    // Send a message with a file
    final result = await geminiChat.sendMessage([
      GeminiSdkContent.text('Please analyze this HTML file and extract the user name'),
      GeminiSdkContent.file(File('example.html')),
    ]);
    
    print('Analysis result: $result');
  } finally {
    await geminiChat.dispose();
  }
}
```

### Using Schemas for Structured Responses

```dart
import 'dart:io';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  final geminiSDK = GeminiSDK('YOUR_API_KEY');
  final geminiChat = geminiSDK.createNewChat();
  
  try {
    // Define a schema with nullable properties
    final schema = SchemaObject(
      properties: {
        'userName': SchemaProperty.string(
          description: 'The name of the user found in the HTML',
          nullable: false, // Required field
        ),
        'userEmail': SchemaProperty.string(
          description: 'The email of the user if found',
          nullable: true, // Optional field
        ),
        'userRole': SchemaProperty.string(
          description: 'The role or title of the user',
          nullable: true, // Optional field
        ),
      },
    );
    
    // Send message with schema - returns a record with llmMessage and structuredSchemaData
    final (:llmMessage, :structuredSchemaData) = await geminiChat.sendMessageWithSchema(
      messages: [
        GeminiSdkContent.text('Extract user information from this HTML file'),
        GeminiSdkContent.file(File('profile.html')),
      ],
      schema: schema,
    );

    print('Model message: $llmMessage');
    print('Extracted data: $structuredSchemaData');

    // Access specific fields
    final userName = structuredSchemaData['userName'];
    print('User name: $userName');
  } finally {
    await geminiChat.dispose();
  }
}
```

### Streaming Responses

```dart
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  final geminiSDK = GeminiSDK('YOUR_API_KEY');
  final geminiChat = geminiSDK.createNewChat();
  
  try {
    // Stream the response
    await for (final chunk in geminiChat.streamResponse([
      GeminiSdkContent.text('Write a detailed explanation of quantum computing'),
    ])) {
      print(chunk); // Print each chunk as it arrives
    }
  } finally {
    await geminiChat.dispose();
  }
}
```

## Advanced Configuration

### System Prompts

The SDK supports custom system prompts that **complement** (not override) Gemini's default system prompt. This allows you to add additional context or instructions to guide the model's behavior:

```dart
final geminiChat = geminiSDK.createNewChat(
  options: GeminiChatOptions(
    systemPrompt: '''You are a senior software engineer with expertise in Dart.
Always consider best practices and performance implications.
Provide code examples when relevant.''',
    repeatSystemPrompt: false, // Only include in first message (default)
  ),
);
```

**System Prompt Options:**
- `systemPrompt`: Additional context/instructions to complement Gemini's default behavior
- `repeatSystemPrompt`: Whether to include the prompt in every message (default: `false`)
  - `false`: Include only in the first message (maintains context through conversation)
  - `true`: Include in every message (useful for strict formatting requirements)

**Example with repeated system prompt:**
```dart
final chat = geminiSDK.createNewChat(
  options: GeminiChatOptions(
    systemPrompt: 'Always respond with exactly 3 bullet points.',
    repeatSystemPrompt: true, // Ensures format consistency across all messages
  ),
);
```

### Chat Options

```dart
final geminiChat = geminiSDK.createNewChat(
  options: GeminiChatOptions(
    model: 'gemini-2.5-flash', // or 'gemini-2.5-pro'
    systemPrompt: 'You are a helpful coding assistant',
    repeatSystemPrompt: false, // Only in first message
    maxTurns: 5,
    allowedTools: ['Read', 'Write', 'Bash'],
    permissionMode: 'acceptEdits',
    cwd: '/path/to/project',
    outputJson: true,
    timeoutMs: 30000,
    includeDirectories: true,
    directories: ['/src', '/lib'],
    nonInteractive: true,
  ),
);
```

### Checking and Installing Gemini SDK

```dart
void main() async {
  final geminiSDK = GeminiSDK('YOUR_API_KEY');

  // Check if Gemini CLI is installed
  final isInstalled = await geminiSDK.isGeminiCLIInstalled();

  if (!isInstalled) {
    print('Gemini CLI is not installed. Installing...');

    try {
      // Install the CLI globally
      await geminiSDK.installGeminiCLI(global: true);
      print('Installation complete!');
    } catch (e) {
      print('Installation failed: $e');
    }
  }

  // Get SDK information
  final info = await geminiSDK.getSDKInfo();
  print('SDK Info: $info');
}
```

### Auto-Update SDK

The SDK provides a convenient method to automatically check for and install updates:

```dart
void main() async {
  final geminiSDK = GeminiSDK('YOUR_API_KEY');

  // Automatically check for updates and install if needed
  await geminiSDK.updateToNewestVersionIfNeeded(global: true);

  // The function will:
  // 1. Check if CLI is installed (installs if not)
  // 2. Compare current version with latest npm version
  // 3. Update if a newer version is available
}
```

## MCP (Model Context Protocol) Support

The SDK provides comprehensive support for MCP, allowing Gemini to connect to external tools and services.

### Checking MCP Installation

```dart
final mcpInfo = await geminiSDK.isMcpInstalled();
print('MCP enabled: ${mcpInfo.hasMcpSupport}');
print('Configured servers: ${mcpInfo.servers.length}');

for (final server in mcpInfo.servers) {
  print('  - ${server.name}: ${server.status}');
}
```

### Listing MCP Servers

```dart
// List all configured MCP servers
final servers = await geminiSDK.listMcpServers();

for (final server in servers) {
  print('Server: ${server.name}');
  print('  Command: ${server.command}');
  print('  Args: ${server.args.join(' ')}');
  if (server.env != null && server.env!.isNotEmpty) {
    print('  Environment: ${server.env!.keys.join(', ')}');
  }
}
```

### Installing Popular MCP Servers

```dart
// Install filesystem MCP server
await geminiSDK.installPopularMcpServer('filesystem');

// Install GitHub MCP with environment variables
await geminiSDK.installPopularMcpServer('github', 
  environment: {'GITHUB_TOKEN': 'your-github-token'}
);

// Available popular servers:
// - filesystem: File system access
// - github: GitHub integration
// - postgres: PostgreSQL database
// - git: Git operations
// - puppeteer: Web automation
// - sequential-thinking: Problem solving
// - slack: Slack integration
// - google-drive: Google Drive access
```

### Adding Custom MCP Servers

```dart
// Add a custom MCP server
final customServer = McpServer(
  name: 'my-custom-server',
  command: 'node',
  args: ['path/to/server.js'],
  env: {'API_KEY': 'your-api-key'},
);

await geminiSDK.addMcpServer(
  'my-custom-server',
  customServer: customServer,
);

// Or add an npm package as MCP server
await geminiSDK.addMcpServer(
  'my-npm-server',
  packageName: '@company/mcp-server',
  options: McpAddOptions(
    scope: McpScope.user,
    useNpx: true,
    environment: {'CONFIG': 'value'},
  ),
);
```

### Removing MCP Servers

```dart
// Remove an MCP server
await geminiSDK.removeMcpServer('my-custom-server');
```

### Getting MCP Server Details

```dart
// Get details about a specific MCP server
final details = await geminiSDK.getMcpServerDetails('filesystem');

if (details != null) {
  print('Server: ${details.name}');
  print('Command: ${details.command}');
  print('Args: ${details.args}');
}
```

### Using MCP in Chat Sessions

Once MCP servers are configured, they're automatically available in chat sessions:

```dart
final chat = geminiSDK.createNewChat();

// Gemini can now use the configured MCP tools
final result = await chat.sendMessage([
  GeminiSdkContent.text(
    'List all files in my Documents folder' // Works if filesystem MCP is installed
  ),
]);
```

## Schema Building

The SDK provides convenient factory methods for building schemas with nullable control:

```dart
final schema = SchemaObject(
  properties: {
    'name': SchemaProperty.string(
      description: 'User name',
      defaultValue: 'Anonymous',
      nullable: false, // Required field
    ),
    'age': SchemaProperty.number(
      description: 'User age',
      nullable: false, // Required field
    ),
    'email': SchemaProperty.string(
      description: 'User email',
      nullable: true, // Optional field (default)
    ),
    'isActive': SchemaProperty.boolean(
      description: 'Whether the user is active',
      defaultValue: true,
      nullable: false, // Required with default value
    ),
    'tags': SchemaProperty.array(
      items: SchemaProperty.string(),
      description: 'List of tags',
      nullable: true, // Optional array
    ),
    'metadata': SchemaProperty.object(
      properties: {
        'created': SchemaProperty.string(nullable: false),
        'updated': SchemaProperty.string(nullable: true),
      },
      description: 'Metadata object',
      nullable: true, // Optional nested object
    ),
  },
  // The 'required' array is automatically generated from nullable: false properties
  description: 'User information schema',
);
```

### Nullable Property Behavior

- `nullable: false` - The property is required and must be present in the response
- `nullable: true` (default) - The property is optional and may be omitted or null
- Properties with `nullable: false` are automatically added to the JSON schema's `required` array
- You can still use the legacy `required` parameter on SchemaObject for backward compatibility

## Error Handling

The SDK provides specific exception types for different error scenarios:

```dart
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  final geminiSDK = GeminiSDK('YOUR_API_KEY');
  final geminiChat = geminiSDK.createNewChat();
  
  try {
    final result = await geminiChat.sendMessage([
      GeminiSdkContent.text('Hello, Gemini!'),
    ]);
    print(result);
  } on CLINotFoundException {
    print('Gemini CLI is not installed. Please install it first.');
  } on ProcessException catch (e) {
    print('Process error: ${e.message}');
    if (e.exitCode != null) {
      print('Exit code: ${e.exitCode}');
    }
  } on JSONDecodeException catch (e) {
    print('Failed to parse response: ${e.message}');
  } on GeminiSDKException catch (e) {
    print('SDK error: ${e.message}');
  } finally {
    await geminiChat.dispose();
  }
}
```

## Authentication Methods

The SDK supports multiple authentication methods:

### 1. Direct API Key

```dart
final geminiSDK = GeminiSDK('YOUR_API_KEY');
```

### 2. Environment Variable

```bash
export GEMINI_API_KEY="your-api-key-here"
```

```dart
final apiKey = Platform.environment['GEMINI_API_KEY'] ?? '';
final geminiSDK = GeminiSDK(apiKey);
```

### 3. OAuth (Via CLI)

The Gemini CLI also supports OAuth authentication with your Google account for higher rate limits.

### 4. Vertex AI

For enterprise features, you can use Vertex AI authentication:

```bash
export GOOGLE_API_KEY="your-vertex-api-key"
export GOOGLE_GENAI_USE_VERTEXAI=true
```

## Model Selection

The SDK supports different Gemini models:

- **gemini-2.5-pro** - Most capable model with 1M token context window
- **gemini-2.5-flash** - Faster, lighter model for quick responses

```dart
final chat = geminiSDK.createNewChat(
  options: GeminiChatOptions(
    model: 'gemini-2.5-flash', // or 'gemini-2.5-pro'
  ),
);
```

## Resource Management

### Important: Always Dispose Chat Sessions

Always dispose of chat sessions when done to ensure proper cleanup:

```dart
// Method 1: Using try-finally
final chat = geminiSDK.createNewChat();
try {
  // Use the chat
  await chat.sendMessage([...]);
} finally {
  await chat.dispose();
}

// Method 2: Dispose all sessions at once
await geminiSDK.dispose(); // Disposes all active sessions
```

## API Reference

### GeminiSDK Class

- `GeminiSDK(String apiKey)` - Creates a new SDK instance
- `createNewChat({GeminiChatOptions? options})` - Creates a new chat session
- `isGeminiCLIInstalled()` - Checks if Gemini CLI is installed
- `installGeminiCLI({bool global = true})` - Installs the Gemini CLI
- `updateToNewestVersionIfNeeded({bool global = true})` - Updates SDK to newest version if available
- `getSDKInfo()` - Gets information about installed SDKs
- `isMcpInstalled()` - Checks MCP installation status
- `listMcpServers()` - Lists all configured MCP servers
- `installPopularMcpServer(name, {environment})` - Installs a popular MCP server
- `addMcpServer(name, {packageName, customServer, options})` - Adds an MCP server
- `getMcpServerDetails(name)` - Gets details about a specific server
- `removeMcpServer(name)` - Removes an MCP server
- `dispose()` - Disposes all active chat sessions

### GeminiChat Class

- `sendMessage(List<GeminiSdkContent> contents)` - Sends a message and returns the response
- `sendMessageWithSchema({messages, schema})` - Sends a message with a schema and returns `({String llmMessage, Map<String, dynamic> structuredSchemaData})`
- `streamResponse(List<GeminiSdkContent> contents)` - Streams the response
- `get sessionId` - Gets the current session ID (null until first message)
- `resetConversation()` - Resets the conversation, starting a new session
- `dispose()` - Disposes the chat session and cleans up resources (including temp files)

### GeminiSdkContent

- `GeminiSdkContent.text(String text)` - Creates text content
- `GeminiSdkContent.file(File file)` - Creates file content
- `GeminiSdkContent.bytes({data, fileExtension})` - Creates content from bytes (temporary file)

## Troubleshooting

### Gemini CLI not found

If you get a `CLINotFoundException`, make sure Gemini CLI is installed:

```bash
npm install -g @google/gemini-cli
```

Or use the SDK's built-in installer:

```dart
await geminiSDK.installGeminiSDK();
```

### Permission Errors

On Unix-like systems, you might need to use `sudo` for global npm installations:

```bash
sudo npm install -g @google/gemini-cli
```

### Process Cleanup

Always dispose of chat sessions to prevent resource leaks:

```dart
await geminiChat.dispose();
// or
await geminiSDK.dispose(); // Disposes all sessions
```

### Rate Limits

Be aware of the rate limits for your authentication method:
- OAuth (free): 60 requests/min, 1,000 requests/day
- API Key (free): 100 requests/day
- Vertex AI: Higher limits based on your plan

## Examples

Check the `example/` directory for more comprehensive examples:

- `example/basic_usage.dart` - Simple text messaging
- `example/file_analysis.dart` - Analyzing files with Gemini
- `example/schema_example.dart` - Using schemas for structured responses
- `example/system_prompt_example.dart` - Using custom system prompts
- `example/streaming_example.dart` - Streaming responses
- `example/installation_check.dart` - Checking and installing dependencies
- `example/mcp_management.dart` - Managing MCP servers
- `example/bytes_content_example.dart` - Working with in-memory data

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Open an issue on [GitHub](https://github.com/yourusername/gemini_cli_sdk)
- Check the [Google AI documentation](https://ai.google.dev/)
- Visit the [Gemini CLI repository](https://github.com/google-gemini/gemini-cli)

## Acknowledgments

- Built on top of the official Gemini CLI by Google
- Inspired by the Claude Code SDK architecture
- Supports Model Context Protocol (MCP) for extensibility
