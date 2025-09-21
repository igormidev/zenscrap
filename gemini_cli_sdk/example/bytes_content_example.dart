import 'dart:io';
import 'dart:typed_data';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  // Get API key from environment
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? 'YOUR_API_KEY';
  
  if (apiKey == 'YOUR_API_KEY') {
    print('Please set your GEMINI_API_KEY environment variable');
    return;
  }

  final geminiSDK = GeminiSDK(apiKey);
  final geminiChat = geminiSDK.createNewChat();
  
  try {
    print('📝 Bytes Content Example\n');
    print('=' * 50);
    
    // Example 1: Send text content as bytes
    print('\n1️⃣ Sending text as bytes:\n');
    
    final textContent = '''
    # Sample Markdown Document
    
    ## Introduction
    This is a sample document created in memory and sent as bytes.
    
    ## Features
    - Created dynamically
    - No file system access needed
    - Automatically cleaned up
    
    ## Code Example
    ```dart
    void main() {
      print('Hello from bytes!');
    }
    ```
    
    ## Conclusion
    This demonstrates sending in-memory content to Gemini.
    ''';
    
    final textBytes = Uint8List.fromList(textContent.codeUnits);
    
    final textResult = await geminiChat.sendMessage([
      GeminiSdkContent.text('Please analyze this markdown document and summarize its main points:'),
      GeminiSdkContent.bytes(
        data: textBytes,
        fileName: 'document',
        fileExtension: 'md',
      ),
    ]);
    
    print('Analysis of text bytes:');
    print(textResult);
    
    // Example 2: Send JSON data as bytes
    print('\n${'=' * 50}');
    print('\n2️⃣ Sending JSON data as bytes:\n');
    
    final jsonData = '''
    {
      "users": [
        {
          "id": 1,
          "name": "Alice Johnson",
          "email": "alice@example.com",
          "role": "Admin",
          "active": true
        },
        {
          "id": 2,
          "name": "Bob Smith",
          "email": "bob@example.com",
          "role": "User",
          "active": true
        },
        {
          "id": 3,
          "name": "Charlie Brown",
          "email": "charlie@example.com",
          "role": "Moderator",
          "active": false
        }
      ],
      "total": 3,
      "timestamp": "2024-01-15T10:30:00Z"
    }
    ''';
    
    final jsonBytes = Uint8List.fromList(jsonData.codeUnits);
    
    final jsonResult = await geminiChat.sendMessage([
      GeminiSdkContent.text('Analyze this JSON data and tell me: How many active users are there? What are their roles?'),
      GeminiSdkContent.bytes(
        data: jsonBytes,
        fileName: 'data',
        fileExtension: 'json',
      ),
    ]);
    
    print('Analysis of JSON bytes:');
    print(jsonResult);
    
    // Example 3: Send CSV data as bytes
    print('\n${'=' * 50}');
    print('\n3️⃣ Sending CSV data as bytes:\n');
    
    final csvData = '''Product,Category,Price,Stock
MacBook Pro,Electronics,2499.99,15
iPhone 15,Electronics,999.99,50
Coffee Maker,Appliances,79.99,30
Running Shoes,Sports,129.99,25
Yoga Mat,Sports,29.99,100
Office Chair,Furniture,399.99,10
Desk Lamp,Furniture,49.99,40
''';
    
    final csvBytes = Uint8List.fromList(csvData.codeUnits);
    
    final csvResult = await geminiChat.sendMessage([
      GeminiSdkContent.text('Analyze this CSV data and tell me: What is the most expensive product? What category has the most items?'),
      GeminiSdkContent.bytes(
        data: csvBytes,
        fileName: 'products',
        fileExtension: 'csv',
      ),
    ]);
    
    print('Analysis of CSV bytes:');
    print(csvResult);
    
    // Example 4: If you had image bytes (from network, camera, etc.)
    print('\n${'=' * 50}');
    print('\n4️⃣ Example code for image bytes:\n');
    
    print('''
// Example: If you had image bytes from a network request or camera
// final imageResponse = await http.get(Uri.parse('https://example.com/image.jpg'));
// final imageBytes = imageResponse.bodyBytes;
//
// final imageResult = await geminiChat.sendMessage([
//   GeminiSdkContent.text('What is in this image?'),
//   GeminiSdkContent.bytes(
//     data: imageBytes,
//     fileName: 'image',
//     fileExtension: 'jpg',
//   ),
// ]);
''');
    
    print('\n✅ Bytes content example complete!');
    print('\nNote: All temporary files created from bytes were automatically cleaned up when the chat was disposed.');
    
  } catch (e) {
    print('Error: $e');
  } finally {
    // This automatically cleans up all temporary files created from bytes
    await geminiChat.dispose();
    print('\n🧹 Chat disposed and temporary files cleaned up.');
  }
}