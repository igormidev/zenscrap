import 'dart:io';
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
    print('Requesting a streamed response from Gemini...');
    print('(This will print the response as it arrives)\n');
    print('=' * 50);
    
    // Stream the response
    await for (final chunk in geminiChat.streamResponse([
      GeminiSdkContent.text('''
Write a short story about a robot learning to paint. 
Make it creative and engaging, about 3-4 paragraphs long.
'''),
    ])) {
      // Print each chunk as it arrives without newline
      stdout.write(chunk);
    }
    
    print('\n${'=' * 50}');
    print('\nStreaming complete!');
    
  } catch (e) {
    print('Error: $e');
  } finally {
    await geminiChat.dispose();
  }
}