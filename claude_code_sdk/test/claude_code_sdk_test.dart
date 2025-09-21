import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() {
  group('Claude SDK', () {
    test('should test function', () async {
      final sdk = Claude(
          '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');
      final chat = sdk.createNewChat();
      final message = await chat.sendMessage(
          [ClaudeSdkContent.text('What is the capital of France?')]);
      print(message);
      final message2 = await chat.sendMessage(
          [ClaudeSdkContent.text('What is the population of that country?')]);
      print(message2);
    });
    test('should initialize with API key', () {
      final sdk = Claude('test-api-key');
      expect(sdk, isNotNull);
    });

    test('should throw on empty API key', () {
      expect(
        () => Claude(''),
        throwsA(isA<ClaudeSDKException>()),
      );
    });

    test('should create chat session', () {
      final sdk = Claude('test-api-key');
      final chat = sdk.createNewChat();
      expect(chat, isNotNull);
      expect(chat.sessionId, isNull); // Session ID is set after first message
    });

    test('should create chat with options', () {
      final sdk = Claude('test-api-key');
      final chat = sdk.createNewChat(
        options: ClaudeChatOptions(
          systemPrompt: 'Test prompt',
          maxTurns: 5,
        ),
      );
      expect(chat, isNotNull);
      expect(chat.options.systemPrompt, equals('Test prompt'));
      expect(chat.options.maxTurns, equals(5));
    });
  });

  group('ClaudeChatOptions', () {
    test('should convert to CLI arguments', () {
      final options = ClaudeChatOptions(
        systemPrompt: 'Test prompt',
        maxTurns: 3,
        allowedTools: ['Read', 'Write'],
        cwd: '/test/dir',
      );

      final args = options.toCliArgs();

      expect(args, contains('--append-system-prompt'));
      expect(args, contains('Test prompt'));
      expect(args, contains('--max-turns'));
      expect(args, contains('3'));
      expect(args, contains('--allowedTools'));
      expect(args, contains('Read,Write'));
      expect(args, contains('--cwd'));
      expect(args, contains('/test/dir'));
    });

    test('should handle resume session ID', () {
      final options = ClaudeChatOptions(
        resumeSessionId: 'test-session-123',
      );
      // Note: resumeSessionId is handled separately in ClaudeChat,
      // not in toCliArgs()
      expect(options.resumeSessionId, equals('test-session-123'));
    });

    test('should handle timeout option', () {
      final options = ClaudeChatOptions(timeoutMs: 30000);
      expect(options.timeoutMs, equals(30000));
    });
  });

  group('ClaudeSdkContent', () {
    test('should create text content', () {
      final content = ClaudeSdkContent.text('Hello, world!');
      expect(content, isA<TextContent>());
      expect((content as TextContent).text, equals('Hello, world!'));
      expect(content.toCliString(), equals('Hello, world!'));
    });

    test('should convert text content to JSON', () {
      final content = ClaudeSdkContent.text('Test message');
      final json = content.toJson();

      expect(json['type'], equals('text'));
      expect(json['text'], equals('Test message'));
    });

    test('should create bytes content', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final content = ClaudeSdkContent.bytes(
        data: bytes,
        fileName: 'test',
        fileExtension: 'bin',
      );

      expect(content, isA<BytesContent>());
      expect((content as BytesContent).data, equals(bytes));
      expect(content.fileExtension, equals('bin'));
    });

    test('should convert bytes content to JSON', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final content = ClaudeSdkContent.bytes(
        data: bytes,
        fileName: 'test',
        fileExtension: 'txt',
      );
      final json = content.toJson();

      expect(json['type'], equals('bytes'));
      expect(json['data_length'], equals(3));
      expect(json['extension'], equals('txt'));
      expect(json['path'], isNull); // Path is null until file is created
    });
  });

  group('SchemaObject', () {
    test('should create schema with properties using nullable', () {
      final schema = SchemaObject(
        properties: {
          'name': SchemaProperty.string(
            description: 'User name',
            nullable: false, // Required field
          ),
          'age': SchemaProperty.number(
            description: 'User age',
            nullable: true, // Optional field
          ),
          'email': SchemaProperty.string(
            description: 'User email',
            nullable: false, // Required field
          ),
        },
      );

      final json = schema.toJson();

      expect(json['type'], equals('object'));
      expect(json['properties'], isA<Map>());
      expect(json['properties']['name']['type'], equals('string'));
      expect(json['properties']['age']['type'], equals('number'));
      expect(json['properties']['email']['type'], equals('string'));
      // Required array should be automatically generated from nullable: false properties
      expect(json['required'], unorderedEquals(['name', 'email']));
    });

    test('should support legacy required parameter', () {
      final schema = SchemaObject(
        properties: {
          'name': SchemaProperty.string(description: 'User name'),
          'age': SchemaProperty.number(description: 'User age'),
        },
        required: ['name'], // Legacy way still works
      );

      final json = schema.toJson();
      expect(json['required'], equals(['name']));
    });

    test('should create nested schema with nullable', () {
      final schema = SchemaObject(
        properties: {
          'user': SchemaProperty.object(
            properties: {
              'name': SchemaProperty.string(nullable: false),
              'email': SchemaProperty.string(nullable: true),
            },
            nullable: false, // user object itself is required
          ),
          'tags': SchemaProperty.array(
            items: SchemaProperty.string(),
            nullable: true, // tags array is optional
          ),
        },
      );

      final json = schema.toJson();

      expect(json['properties']['user']['type'], equals('object'));
      expect(json['properties']['user']['properties'], isA<Map>());
      expect(json['properties']['tags']['type'], equals('array'));
      expect(json['properties']['tags']['items']['type'], equals('string'));
    });
  });

  group('SchemaProperty', () {
    test('should create string property with enum and nullable', () {
      final prop = SchemaProperty.string(
        description: 'Status',
        enumValues: ['active', 'inactive', 'pending'],
        defaultValue: 'pending',
        nullable: false,
      );

      final json = prop.toJson();

      expect(json['type'], equals('string'));
      expect(json['description'], equals('Status'));
      expect(json['enum'], equals(['active', 'inactive', 'pending']));
      expect(json['default'], equals('pending'));
    });

    test('should create boolean property with nullable', () {
      final prop = SchemaProperty.boolean(
        description: 'Is active',
        defaultValue: true,
        nullable: false,
      );

      final json = prop.toJson();

      expect(json['type'], equals('boolean'));
      expect(json['description'], equals('Is active'));
      expect(json['default'], equals(true));
    });
  });

  group('SchemaResult', () {
    test('should create from JSON', () {
      final json = {
        'modelMessage': 'Here is the extracted data',
        'data': {
          'name': 'John Doe',
          'age': 30,
        },
      };

      final result = SchemaResult.fromJson(json);

      expect(result.modelMessage, equals('Here is the extracted data'));
      expect(result.data['name'], equals('John Doe'));
      expect(result.data['age'], equals(30));
    });

    test('should handle missing fields in JSON', () {
      final json = <String, dynamic>{};
      final result = SchemaResult.fromJson(json);

      expect(result.modelMessage, equals(''));
      expect(result.data, isEmpty);
    });
  });

  group('Exceptions', () {
    test('should create CLINotFoundException', () {
      const exception = CLINotFoundException();
      expect(
        exception.toString(),
        contains('Claude Code CLI not found'),
      );
    });

    test('should create ProcessException with exit code', () {
      const exception = ProcessException(
        'Process failed',
        exitCode: 1,
        stderr: 'Error output',
      );

      expect(exception.toString(), contains('Process failed'));
      expect(exception.toString(), contains('exit code: 1'));
      expect(exception.toString(), contains('Error output'));
    });
  });
}
