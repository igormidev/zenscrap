import 'dart:typed_data';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  // Create SDK instance with your API key
  final claude = Claude('sk-ant-api03-YOUR_API_KEY_HERE');

  // Create a new chat session
  final chat = claude.createNewChat(
    options: ClaudeChatOptions(
      systemPrompt: 'You are a helpful assistant that can analyze data',
      timeoutMs: 30000,
    ),
  );

  try {
    // Example 1: Send binary data as a file
    final binaryData = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, // PNG header
      0x0D, 0x0A, 0x1A, 0x0A,
      // ... more binary data
    ]);
    
    print('Sending binary data as PNG file...');
    final response1 = await chat.sendMessage([
      ClaudeSdkContent.text('What type of file format does this data represent?'),
      ClaudeSdkContent.bytes(
        data: binaryData,
        fileName: 'image',
        fileExtension: 'png',
      ),
    ]);
    print('Response: $response1');

    // Example 2: Send text data as bytes
    final textData = 'Hello, this is some text data!'.codeUnits;
    final textBytes = Uint8List.fromList(textData);
    
    print('\nSending text as bytes...');
    final response2 = await chat.sendMessage([
      ClaudeSdkContent.text('Can you read the content of this text file?'),
      ClaudeSdkContent.bytes(
        data: textBytes,
        fileName: 'data',
        fileExtension: 'txt',
      ),
    ]);
    print('Response: $response2');

    // Example 3: Send CSV data as bytes
    final csvData = '''name,age,city
John,30,New York
Jane,25,Los Angeles
Bob,35,Chicago''';
    final csvBytes = Uint8List.fromList(csvData.codeUnits);
    
    print('\nSending CSV data...');
    final response3 = await chat.sendMessage([
      ClaudeSdkContent.text('Please analyze this CSV data and tell me the average age'),
      ClaudeSdkContent.bytes(
        data: csvBytes,
        fileName: 'data',
        fileExtension: 'csv',
      ),
    ]);
    print('Response: $response3');

  } catch (e) {
    print('Error: $e');
  } finally {
    // Important: Dispose to clean up temporary files
    // Temporary files are created in the system temp directory
    await chat.dispose();
    await claude.dispose();
    print('\nCleanup complete - temporary files deleted from system temp directory');
  }
}