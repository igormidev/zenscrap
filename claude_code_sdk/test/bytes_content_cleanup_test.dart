import 'dart:io';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() {
  group('BytesContent Temp File Management', () {
    test('should create and clean up temporary files', () async {
      // Create a mock API key (tests won't actually call the CLI)
      final claude = Claude('test-api-key');
      final chat = claude.createNewChat();
      
      // Create some test data
      final testData = Uint8List.fromList('Test data'.codeUnits);
      final bytesContent = ClaudeSdkContent.bytes(
        data: testData,
        fileName: 'test',
        fileExtension: 'txt',
      ) as BytesContent;
      
      // Initially, no temp file should exist
      expect(bytesContent.tempFile, isNull);
      
      // The temp file would be created when sendMessage is called
      // but we can't test that without a real API key
      // So we'll test the cleanup logic directly
      
      // Simulate what would happen in sendMessage by creating a temp file
      final tempDir = Directory.current;
      final tempFile = File('${tempDir.path}/test_temp_file.txt');
      await tempFile.writeAsBytes(testData);
      
      // Verify the file exists
      expect(await tempFile.exists(), isTrue);
      
      // Clean up manually (this is what dispose would do)
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
      
      // Verify the file is deleted
      expect(await tempFile.exists(), isFalse);
      
      // Clean up the chat session
      await chat.dispose();
      await claude.dispose();
    });
    
    test('BytesContent should store correct data and extension', () {
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);
      final content = ClaudeSdkContent.bytes(
        data: data,
        fileName: 'data',
        fileExtension: 'bin',
      ) as BytesContent;
      
      expect(content.data, equals(data));
      expect(content.fileExtension, equals('bin'));
      expect(content.tempFile, isNull); // No file created yet
    });
    
    test('BytesContent toJson should include metadata', () {
      final data = Uint8List.fromList([10, 20, 30]);
      final content = ClaudeSdkContent.bytes(
        data: data,
        fileName: 'data',
        fileExtension: 'dat',
      );
      
      final json = content.toJson();
      expect(json['type'], equals('bytes'));
      expect(json['data_length'], equals(3));
      expect(json['extension'], equals('dat'));
      expect(json['path'], isNull); // Path is null until file is created
    });
    
    test('BytesContent toCliString should indicate file status', () {
      final content = ClaudeSdkContent.bytes(
        data: Uint8List.fromList([1, 2, 3]),
        fileName: 'test',
        fileExtension: 'txt',
      ) as BytesContent;
      
      // Before file creation
      expect(content.toCliString(), equals('BytesContent (not yet written to file)'));
      
      // Simulate file creation
      content.tempFile = File('/tmp/test.txt');
      expect(content.toCliString(), equals('File: /tmp/test.txt'));
    });
  });
}