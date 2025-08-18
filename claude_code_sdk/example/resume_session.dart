import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  final claude = Claude('sk-ant-api03-YOUR_API_KEY_HERE');

  // Start a new chat session
  print('Starting initial chat session...');
  final chat1 = claude.createNewChat(
    options: ClaudeChatOptions(
      systemPrompt: 'You are a helpful math tutor',
    ),
  );

  // Send first message and get session ID
  final response1 = await chat1.sendMessage([
    ClaudeSdkContent.text('Remember this number: 42. I will ask about it later.'),
  ]);
  print('Initial response: $response1');
  
  final sessionId = chat1.sessionId;
  print('Session ID: $sessionId');
  
  // Dispose the first chat
  await chat1.dispose();
  
  // Later... resume the same conversation
  print('\nResuming conversation with session ID: $sessionId');
  final chat2 = claude.createNewChat(
    options: ClaudeChatOptions(
      resumeSessionId: sessionId,
    ),
  );

  // The conversation continues where it left off
  final response2 = await chat2.sendMessage([
    ClaudeSdkContent.text('What was the number I asked you to remember?'),
  ]);
  print('Resumed response: $response2');
  
  // Clean up
  await chat2.dispose();
  await claude.dispose();
}