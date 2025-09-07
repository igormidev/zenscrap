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
    // Create a sample file to analyze
    final sampleFile = File('sample.html');
    await sampleFile.writeAsString('''
<!DOCTYPE html>
<html>
<head>
  <title>User Profile</title>
</head>
<body>
  <div class="user-info">
    <h1>John Doe</h1>
    <p>Email: john.doe@example.com</p>
    <p>Role: Senior Developer</p>
    <p>Department: Engineering</p>
    <p>Location: San Francisco, CA</p>
  </div>
  <div class="bio">
    <h2>About</h2>
    <p>Experienced software developer with 10+ years in web development.</p>
  </div>
</body>
</html>
''');

    print('Analyzing HTML file...\n');

    // Send a message with a file
    final result = await geminiChat.sendMessage([
      GeminiSdkContent.text('Please analyze this HTML file and extract all the user information you can find. Format it as a summary.'),
      GeminiSdkContent.file(sampleFile),
    ]);
    
    print('Analysis result:');
    print(result);
    
    // Clean up the sample file
    await sampleFile.delete();
    
  } catch (e) {
    print('Error: $e');
  } finally {
    await geminiChat.dispose();
  }
}