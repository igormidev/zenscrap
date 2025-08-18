import 'dart:io';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  // Get API key from environment
  final apiKey = Platform.environment['ANTHROPIC_API_KEY'] ?? 'YOUR_API_KEY';

  if (apiKey == 'YOUR_API_KEY') {
    print('Please set your ANTHROPIC_API_KEY environment variable');
    exit(1);
  }

  final claudeSDK = Claude(apiKey);
  final claudeChat = claudeSDK.createNewChat(
    options: ClaudeChatOptions(
      systemPrompt: 'You are a code analyzer. Provide detailed analysis.',
      allowedTools: ['Read', 'Grep'],
    ),
  );

  try {
    // Create a sample HTML file for analysis
    final htmlFile = File('example.html');
    await htmlFile.writeAsString('''
<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
</head>
<body>
    <div class="user-info">
        <h1>John Doe</h1>
        <p>Email: john.doe@example.com</p>
        <p>Role: Software Engineer</p>
        <p>Department: Engineering</p>
        <p>Location: San Francisco, CA</p>
    </div>
</body>
</html>
''');

    print('Analyzing HTML file...');
    print('---\n');

    // Send file for analysis
    final result = await claudeChat.sendMessage([
      ClaudeSdkContent.text(
          'Please analyze this HTML file and extract all user information'),
      ClaudeSdkContent.file(htmlFile),
    ]);

    print('Analysis Result:');
    print(result);
    print('\n---');

    // Ask for specific information
    print('\nAsking for specific data...');
    print('---\n');

    final specificResult = await claudeChat.sendMessage([
      ClaudeSdkContent.text(
          'What is the email address in the file we just analyzed?'),
    ]);

    print('Specific Result:');
    print(specificResult);

    // Clean up
    await htmlFile.delete();
  } catch (e) {
    print('Error: $e');
  } finally {
    await claudeChat.dispose();
    await claudeSDK.dispose();
  }
}