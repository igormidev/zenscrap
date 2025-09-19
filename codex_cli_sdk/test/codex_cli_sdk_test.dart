import 'dart:io';
import 'dart:typed_data';
import 'package:codex_cli_sdk/codex_cli_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('Codex SDK', () {
    test('should throw exception for empty API key', () {
      expect(
        () => Codex(''),
        throwsA(isA<CodexSDKException>()),
      );
    });

    test('should create SDK instance with valid API key', () {
      final sdk = Codex('test-api-key');
      expect(sdk, isA<Codex>());
    });

    test('should check if CLI is installed', () async {
      final sdk = Codex('test-key');
      final isInstalled = await sdk.isCodexCLIInstalled();
      expect(isInstalled, isA<bool>());
    });
  });

  group('CodexChat', () {
    late Codex sdk;
    late CodexChat chat;

    setUp(() {
      sdk = Codex('test-api-key');
      chat = sdk.createNewChat();
    });

    tearDown(() async {
      await chat.dispose();
      await sdk.dispose();
    });

    test('should create chat session', () {
      expect(chat, isA<CodexChat>());
      expect(chat.sessionId, isNull); // Session ID is null until first message
    });

    test('should reset conversation', () {
      chat.resetConversation();
      expect(chat.sessionId, isNull);
    });

    test('should throw exception when sending empty message', () {
      expect(
        () => chat.sendMessage([]),
        throwsA(isA<CodexSDKException>()),
      );
    });

    test('should throw exception after disposal', () async {
      await chat.dispose();
      expect(
        () => chat.sendMessage([CodexSdkContent.text('test')]),
        throwsA(isA<CodexSDKException>()),
      );
    });
  });

  group('CodexChatOptions', () {
    test('should create options with default values', () {
      const options = CodexChatOptions();
      expect(options.timeoutMs, equals(60000));
      expect(options.systemPrompt, isNull);
      expect(options.model, isNull);
    });

    test('should create options with custom values', () {
      const options = CodexChatOptions(
        systemPrompt: 'Test prompt',
        model: 'codex-mini-latest',
        mode: 'suggest',
        maxTurns: 5,
        outputJson: true,
        quiet: true,
      );

      expect(options.systemPrompt, equals('Test prompt'));
      expect(options.model, equals('codex-mini-latest'));
      expect(options.mode, equals('suggest'));
      expect(options.maxTurns, equals(5));
      expect(options.outputJson, isTrue);
      expect(options.quiet, isTrue);
    });

    test('should convert to CLI arguments', () {
      const options = CodexChatOptions(
        model: 'gpt-5',
        sandboxMode: 'danger-full-access',
        approvalPolicy: 'never',
      );

      final args = options.toCliArgs();
      expect(args, contains('--model'));
      expect(args, contains('gpt-5'));
      expect(args, contains('--sandbox'));
      expect(args, contains('danger-full-access'));
      expect(args, contains('--ask-for-approval'));
      expect(args, contains('never'));
    });

    test('should handle operation modes', () {
      final suggestOptions = const CodexChatOptions(mode: 'suggest');
      expect(suggestOptions.toCliArgs(), isEmpty);

      final autoEditOptions = const CodexChatOptions(mode: 'auto-edit');
      expect(autoEditOptions.toCliArgs(), isEmpty);

      final fullAutoOptions = const CodexChatOptions(mode: 'full-auto');
      expect(fullAutoOptions.toCliArgs(), contains('--full-auto'));
    });

    test('should copy with new values', () {
      const original = CodexChatOptions(
        systemPrompt: 'Original',
        model: 'model-1',
      );

      final copied = original.copyWith(
        systemPrompt: 'Updated',
      );

      expect(copied.systemPrompt, equals('Updated'));
      expect(copied.model, equals('model-1')); // Should keep original value
    });
  });

  group('Content Types', () {
    test('should create text content', () {
      final content = CodexSdkContent.text('Hello, world!');
      expect(content, isA<TextContent>());
      expect((content as TextContent).text, equals('Hello, world!'));
      expect(content.toCliString(), equals('Hello, world!'));

      final json = content.toJson();
      expect(json['type'], equals('text'));
      expect(json['text'], equals('Hello, world!'));
    });

    test('should create file content', () {
      final file = File('/path/to/file.txt');
      final content = CodexSdkContent.file(file);
      expect(content, isA<FileContent>());

      final fileContent = content as FileContent;
      expect(fileContent.file, equals(file));
      expect(fileContent.fileName, equals('file.txt'));
      expect(fileContent.toCliString(), contains('File:'));

      final json = content.toJson();
      expect(json['type'], equals('file'));
      expect(json['path'], contains('file.txt'));
    });

    test('should create bytes content', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final content = CodexSdkContent.bytes(
        data: bytes,
        fileExtension: 'bin',
      );
      expect(content, isA<BytesContent>());

      final bytesContent = content as BytesContent;
      expect(bytesContent.data, equals(bytes));
      expect(bytesContent.fileExtension, equals('bin'));
      expect(bytesContent.tempFile, isNull); // Not yet written to file

      final json = content.toJson();
      expect(json['type'], equals('bytes'));
      expect(json['data_length'], equals(5));
      expect(json['extension'], equals('bin'));
    });
  });

  group('Schema Models', () {
    test('should create schema object', () {
      final schema = SchemaObject(
        properties: {
          'name': SchemaProperty.string(
            description: 'User name',
            nullable: false,
          ),
          'age': SchemaProperty.number(
            description: 'User age',
            nullable: true,
          ),
        },
        description: 'User info',
      );

      expect(schema.properties.length, equals(2));
      expect(schema.description, equals('User info'));

      final json = schema.toJson();
      expect(json['type'], equals('object'));
      expect(json['properties'], isA<Map>());
      expect(json['description'], equals('User info'));
      expect(json['required'], contains('name')); // name is not nullable
      expect(json['required'], isNot(contains('age'))); // age is nullable
    });

    test('should create different property types', () {
      final stringProp = SchemaProperty.string(
        description: 'A string',
        defaultValue: 'default',
        enumValues: ['a', 'b', 'c'],
        nullable: false,
      );
      expect(stringProp.type, equals('string'));
      expect(stringProp.defaultValue, equals('default'));
      expect(stringProp.enumValues, equals(['a', 'b', 'c']));
      expect(stringProp.nullable, isFalse);

      final numberProp = SchemaProperty.number(
        description: 'A number',
        defaultValue: 42,
      );
      expect(numberProp.type, equals('number'));
      expect(numberProp.defaultValue, equals(42));

      final boolProp = SchemaProperty.boolean(
        description: 'A boolean',
        defaultValue: true,
      );
      expect(boolProp.type, equals('boolean'));
      expect(boolProp.defaultValue, isTrue);

      final arrayProp = SchemaProperty.array(
        items: SchemaProperty.string(),
        description: 'An array',
      );
      expect(arrayProp.type, equals('array'));
      expect(arrayProp.items, isNotNull);

      final objectProp = SchemaProperty.object(
        properties: {
          'nested': SchemaProperty.string(),
        },
        description: 'An object',
      );
      expect(objectProp.type, equals('object'));
      expect(objectProp.properties, isNotNull);
    });

    test('should handle schema result', () {
      // ignore: deprecated_member_use_from_same_package
      final result = SchemaResult(
        modelMessage: 'Here is the data',
        data: {'key': 'value'},
      );

      expect(result.modelMessage, equals('Here is the data'));
      expect(result.data['key'], equals('value'));

      final json = result.toJson();
      expect(json['modelMessage'], equals('Here is the data'));
      expect(json['data'], equals({'key': 'value'}));

      // ignore: deprecated_member_use_from_same_package
      final fromJson = SchemaResult.fromJson(json);
      expect(fromJson.modelMessage, equals(result.modelMessage));
      expect(fromJson.data, equals(result.data));
    });
  });

  group('MCP Models', () {
    test('should create MCP server', () {
      final server = McpServer(
        name: 'test-server',
        command: 'node',
        args: ['server.js'],
        env: {'KEY': 'value'},
      );

      expect(server.name, equals('test-server'));
      expect(server.command, equals('node'));
      expect(server.args, equals(['server.js']));
      expect(server.env, equals({'KEY': 'value'}));
      expect(server.type, equals('stdio')); // Default value

      final json = server.toJson();
      expect(json['command'], equals('node'));
      expect(json['args'], equals(['server.js']));
      expect(json['type'], equals('stdio'));
      expect(json['env'], equals({'KEY': 'value'}));
    });

    test('should create MCP server from JSON', () {
      final json = {
        'command': 'python',
        'args': ['script.py', '--option'],
        'env': {'PATH': '/usr/bin'},
        'type': 'stdio',
      };

      final server = McpServer.fromJson('my-server', json);
      expect(server.name, equals('my-server'));
      expect(server.command, equals('python'));
      expect(server.args, equals(['script.py', '--option']));
      expect(server.env, equals({'PATH': '/usr/bin'}));
      expect(server.type, equals('stdio'));
    });

    test('should copy MCP server with updates', () {
      final original = McpServer(
        name: 'original',
        command: 'node',
        args: ['old.js'],
      );

      final copied = original.copyWith(
        name: 'updated',
        args: ['new.js'],
      );

      expect(copied.name, equals('updated'));
      expect(copied.command, equals('node')); // Unchanged
      expect(copied.args, equals(['new.js']));
    });

    test('should handle MCP config', () {
      final server1 = McpServer(
        name: 'server1',
        command: 'cmd1',
        args: [],
      );

      final server2 = McpServer(
        name: 'server2',
        command: 'cmd2',
        args: [],
      );

      final config = McpConfig(servers: {
        'server1': server1,
        'server2': server2,
      });

      expect(config.servers.length, equals(2));
      expect(config.servers['server1'], equals(server1));

      final added = config.addServer(McpServer(
        name: 'server3',
        command: 'cmd3',
        args: [],
      ));
      expect(added.servers.length, equals(3));

      final removed = added.removeServer('server2');
      expect(removed.servers.length, equals(2));
      expect(removed.servers.containsKey('server2'), isFalse);
    });

    test('should handle MCP installation info', () {
      final server = McpServer(
        name: 'test',
        command: 'test',
        args: [],
      );

      final info = McpInstallationInfo(
        hasMcpSupport: true,
        servers: [server],
        configPath: '/home/.codex/config.toml',
        mcpVersion: '1.0.0',
      );

      expect(info.hasMcpSupport, isTrue);
      expect(info.servers.length, equals(1));
      expect(info.configPath, equals('/home/.codex/config.toml'));
      expect(info.mcpVersion, equals('1.0.0'));

      final notInstalled = McpInstallationInfo.notInstalled();
      expect(notInstalled.hasMcpSupport, isFalse);
      expect(notInstalled.servers, isEmpty);
    });

    test('should handle MCP add options', () {
      const options = McpAddOptions(
        scope: McpScope.project,
        useNpx: true,
        environment: {'TEST': 'value'},
        force: true,
      );

      expect(options.scope, equals(McpScope.project));
      expect(options.useNpx, isTrue);
      expect(options.environment, equals({'TEST': 'value'}));
      expect(options.force, isTrue);
    });
  });

  group('Exception Types', () {
    test('should create base SDK exception', () {
      const exception = CodexSDKException('Test error');
      expect(exception.message, equals('Test error'));
      expect(exception.toString(), contains('CodexSDKException'));
      expect(exception.toString(), contains('Test error'));
    });

    test('should create CLI not found exception', () {
      const exception = CLINotFoundException();
      expect(exception, isA<CodexSDKException>());
      expect(exception.message, contains('Codex CLI not found'));
      expect(exception.message, contains('npm install'));
    });

    test('should create CLI connection exception', () {
      const exception = CLIConnectionException('Connection failed');
      expect(exception, isA<CodexSDKException>());
      expect(exception.message, equals('Connection failed'));
    });

    test('should create process exception', () {
      const exception = ProcessException(
        'Process failed',
        exitCode: 1,
        stderr: 'Error output',
      );
      expect(exception, isA<CodexSDKException>());
      expect(exception.message, equals('Process failed'));
      expect(exception.exitCode, equals(1));
      expect(exception.stderr, equals('Error output'));
      expect(exception.toString(), contains('exit code: 1'));
      expect(exception.toString(), contains('Stderr: Error output'));
    });

    test('should create JSON decode exception', () {
      const exception = JSONDecodeException(
        'Invalid JSON',
        '{"invalid": json}',
      );
      expect(exception, isA<CodexSDKException>());
      expect(exception.message, equals('Invalid JSON'));
      expect(exception.rawContent, equals('{"invalid": json}'));
      expect(exception.toString(), contains('JSONDecodeException'));
      expect(exception.toString(), contains('Raw content'));
    });

    test('should handle long content in JSON decode exception', () {
      final longContent = 'x' * 300;
      final exception = JSONDecodeException('Error', longContent);
      final str = exception.toString();
      expect(str, contains('x' * 200));
      expect(str, contains('...'));
    });
  });
}