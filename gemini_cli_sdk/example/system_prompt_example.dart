import 'dart:io';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  // Get API key from environment
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? 'YOUR_API_KEY';
  
  if (apiKey == 'YOUR_API_KEY') {
    print('Please set your GEMINI_API_KEY environment variable');
    print('You can get your API key from: https://makersuite.google.com/app/apikey');
    return;
  }

  final geminiSDK = GeminiSDK(apiKey);
  
  print('🎯 System Prompt Example\n');
  print('=' * 50);
  
  // Example 1: Chat with custom system prompt (included only in first message)
  print('\n📝 Example 1: System prompt in first message only\n');
  
  final chatWithSystemPrompt = geminiSDK.createNewChat(
    options: GeminiChatOptions(
      systemPrompt: '''You are a pirate captain who loves to tell stories.
Always respond in a pirate dialect and include nautical terms.
Be enthusiastic and add "Arrr!" occasionally in your responses.
This is additional context that complements your default behavior.''',
      repeatSystemPrompt: false, // Default: only include in first message
    ),
  );
  
  try {
    // First message - system prompt will be included
    final response1 = await chatWithSystemPrompt.sendMessage([
      GeminiSdkContent.text('Tell me about programming'),
    ]);
    
    print('First response (with system prompt):');
    print(response1);
    print("\n${'-' * 40}\n");
    
    // Second message - system prompt won't be included (conversation continues)
    final response2 = await chatWithSystemPrompt.sendMessage([
      GeminiSdkContent.text('What about databases?'),
    ]);
    
    print('Second response (system prompt not repeated):');
    print(response2);
    
  } finally {
    await chatWithSystemPrompt.dispose();
  }
  
  // Example 2: Chat with system prompt repeated in every message
  print("\n${'=' * 50}");
  print('\n📝 Example 2: System prompt repeated in every message\n');
  
  final chatWithRepeatedPrompt = geminiSDK.createNewChat(
    options: GeminiChatOptions(
      systemPrompt: '''You are a helpful assistant who always provides exactly 3 bullet points in your response.
Format your answers as a numbered list.
Be concise and clear.''',
      repeatSystemPrompt: true, // Include system prompt in every message
    ),
  );
  
  try {
    // First message
    final response1 = await chatWithRepeatedPrompt.sendMessage([
      GeminiSdkContent.text('What are the benefits of exercise?'),
    ]);
    
    print('First response:');
    print(response1);
    print("\n${'-' * 40}\n");
    
    // Second message - system prompt will be included again
    final response2 = await chatWithRepeatedPrompt.sendMessage([
      GeminiSdkContent.text('What about healthy eating?'),
    ]);
    
    print('Second response (system prompt repeated):');
    print(response2);
    
  } finally {
    await chatWithRepeatedPrompt.dispose();
  }
  
  // Example 3: Technical assistant with system prompt
  print("\n${'=' * 50}");
  print('\n📝 Example 3: Technical assistant with detailed system prompt\n');
  
  final technicalChat = geminiSDK.createNewChat(
    options: GeminiChatOptions(
      systemPrompt: '''You are a senior software engineer with expertise in Dart and Flutter.
When answering questions:
- Provide code examples when relevant
- Mention best practices
- Consider performance implications
- Be precise and technically accurate
Remember: This complements your existing knowledge, not replaces it.''',
      model: 'gemini-2.5-flash',
    ),
  );
  
  try {
    final response = await technicalChat.sendMessage([
      GeminiSdkContent.text('How should I handle state management in Flutter?'),
    ]);
    
    print('Technical response with system prompt:');
    print(response);
    
  } finally {
    await technicalChat.dispose();
  }
  
  // Example 4: Comparing with and without system prompt
  print("\n${'=' * 50}");
  print('\n📝 Example 4: Comparing responses with and without system prompt\n');
  
  const question = 'Write a haiku about coding';
  
  // Without system prompt
  final normalChat = geminiSDK.createNewChat();
  
  try {
    final normalResponse = await normalChat.sendMessage([
      GeminiSdkContent.text(question),
    ]);
    
    print('Response WITHOUT system prompt:');
    print(normalResponse);
  } finally {
    await normalChat.dispose();
  }
  
  print("\n${'-' * 40}\n");
  
  // With system prompt
  final poeticChat = geminiSDK.createNewChat(
    options: GeminiChatOptions(
      systemPrompt: '''You are a master poet who specializes in Japanese poetry.
When writing haikus, always include a nature metaphor.
Add a brief explanation of the deeper meaning after each haiku.''',
    ),
  );
  
  try {
    final poeticResponse = await poeticChat.sendMessage([
      GeminiSdkContent.text(question),
    ]);
    
    print('Response WITH system prompt:');
    print(poeticResponse);
  } finally {
    await poeticChat.dispose();
  }
  
  await geminiSDK.dispose();
  print('\n✅ System prompt examples complete!');
}