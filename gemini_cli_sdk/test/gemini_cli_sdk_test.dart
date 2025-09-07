import 'dart:io';
import 'dart:typed_data';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('Gemini SDK Tests', () {
    test('should throw exception for empty API key', () {
      expect(
        () => GeminiSDK(''),
        throwsA(isA<GeminiSDKException>()),
      );
    });

    test('should create SDK instance with valid API key', () {
      final sdk = GeminiSDK('test-api-key');
      expect(sdk, isNotNull);
      expect(sdk, isA<GeminiSDK>());
    });

    test('should create chat session', () {
      final sdk = GeminiSDK('test-api-key');
      final chat = sdk.createNewChat();
      expect(chat, isNotNull);
      expect(chat, isA<GeminiChat>());
    });

    test('should create chat with options', () {
      final sdk = GeminiSDK('test-api-key');
      final chat = sdk.createNewChat(
        options: GeminiChatOptions(
          model: 'gemini-2.5-flash',
          nonInteractive: true,
        ),
      );
      expect(chat, isNotNull);
      expect(chat.options.model, equals('gemini-2.5-flash'));
      expect(chat.options.nonInteractive, isTrue);
    });
  });

  group('Schema Tests', () {
    test('should create schema with required and optional fields', () {
      final schema = SchemaObject(
        properties: {
          'name': SchemaProperty.string(
            description: 'User name',
            nullable: false, // Required
          ),
          'email': SchemaProperty.string(
            description: 'User email',
            nullable: true, // Optional
          ),
        },
      );

      final json = schema.toJson();
      expect(json['type'], equals('object'));
      expect(json['properties'], isA<Map>());
      expect(json['required'], contains('name'));
      expect(json['required'], isNot(contains('email')));
    });

    test('should serialize schema property correctly', () {
      final prop = SchemaProperty.string(
        description: 'Test property',
        defaultValue: 'default',
      );

      final json = prop.toJson();
      expect(json['type'], equals('string'));
      expect(json['description'], equals('Test property'));
      expect(json['default'], equals('default'));
    });

    test('should create array schema property', () {
      final prop = SchemaProperty.array(
        items: SchemaProperty.string(),
        description: 'List of strings',
      );

      final json = prop.toJson();
      expect(json['type'], equals('array'));
      expect(json['items'], isA<Map>());
      expect(json['items']['type'], equals('string'));
    });

    test('should create nested object schema', () {
      final prop = SchemaProperty.object(
        properties: {
          'nested': SchemaProperty.boolean(),
        },
        description: 'Nested object',
      );

      final json = prop.toJson();
      expect(json['type'], equals('object'));
      expect(json['properties'], isA<Map>());
      expect(json['properties']['nested'], isA<Map>());
    });
  });

  group('Content Tests', () {
    test('should create text content', () {
      final content = GeminiSdkContent.text('Hello, world!');
      expect(content, isA<TextContent>());
      expect((content as TextContent).text, equals('Hello, world!'));
    });

    test('should create file content', () {
      // Note: Using non-existent file for testing
      final content = GeminiSdkContent.file(File('test.txt'));
      expect(content, isA<FileContent>());
      expect((content as FileContent).file.path, equals('test.txt'));
    });

    test('should create bytes content', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      final content = GeminiSdkContent.bytes(
        data: bytes,
        fileExtension: 'bin',
      );
      expect(content, isA<BytesContent>());
      expect((content as BytesContent).data, equals(bytes));
      expect(content.fileExtension, equals('bin'));
    });
  });

  group('Chat Options Tests', () {
    test('should build args correctly', () {
      final options = GeminiChatOptions(
        model: 'gemini-2.5-flash',
        nonInteractive: true,
        includeDirectories: true,
        directories: ['/src', '/lib'],
      );

      final args = options.buildArgs();
      expect(args, contains('-m'));
      expect(args, contains('gemini-2.5-flash'));
      expect(args, contains('-p'));
      expect(args, contains('--include-directories'));
      expect(args, contains('/src'));
      expect(args, contains('/lib'));
    });

    test('should handle copyWith correctly', () {
      final options = GeminiChatOptions(
        model: 'gemini-2.5-flash',
        nonInteractive: true,
      );

      final newOptions = options.copyWith(
        model: 'gemini-2.5-pro',
        outputJson: true,
      );

      expect(newOptions.model, equals('gemini-2.5-pro'));
      expect(newOptions.outputJson, isTrue);
      expect(newOptions.nonInteractive, isTrue); // Unchanged
    });
  });

  group('MCP Tests', () {
    test('should list popular MCP servers', () {
      final servers = PopularMcpServers.list();
      expect(servers, contains('filesystem'));
      expect(servers, contains('github'));
      expect(servers, contains('postgres'));
    });

    test('should check if server is popular', () {
      expect(PopularMcpServers.isPopular('filesystem'), isTrue);
      expect(PopularMcpServers.isPopular('unknown-server'), isFalse);
    });

    test('should get server configuration', () {
      final config = PopularMcpServers.getServer('filesystem');
      expect(config, isNotNull);
      expect(config!['package'], equals('@modelcontextprotocol/server-filesystem'));
      expect(config['description'], equals('File system access'));
    });

    test('should create MCP server object', () {
      final server = McpServer(
        name: 'test-server',
        command: 'node',
        args: ['server.js'],
        env: {'KEY': 'value'},
      );

      final json = server.toJson();
      expect(json['command'], equals('node'));
      expect(json['args'], equals(['server.js']));
      expect(json['env'], equals({'KEY': 'value'}));
    });
  });

  group('Exception Tests', () {
    test('should create CLINotFoundException with default message', () {
      final exception = CLINotFoundException();
      expect(exception.message, contains('npm install -g @google/gemini-cli'));
    });

    test('should create ProcessException with details', () {
      final exception = ProcessException(
        'Command failed',
        exitCode: 1,
        stderr: 'Error output',
      );
      expect(exception.message, equals('Command failed'));
      expect(exception.exitCode, equals(1));
      expect(exception.stderr, equals('Error output'));
    });

    test('should create JSONDecodeException', () {
      final exception = JSONDecodeException(
        'Invalid JSON',
        '{"broken": ',
      );
      expect(exception.message, equals('Invalid JSON'));
      expect(exception.rawContent, equals('{"broken": '));
    });
  });
}
