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
    // Create a sample HTML file
    final profileFile = File('profile.html');
    await profileFile.writeAsString('''
<!DOCTYPE html>
<html>
<head>
  <title>Employee Profile</title>
</head>
<body>
  <div class="profile">
    <h1>Sarah Johnson</h1>
    <div class="contact">
      <p>Email: sarah.johnson@techcorp.com</p>
      <p>Phone: +1-555-0123</p>
    </div>
    <div class="job">
      <p>Title: Principal Software Engineer</p>
      <p>Department: Research & Development</p>
      <p>Years of Experience: 15</p>
    </div>
    <div class="skills">
      <h3>Technical Skills</h3>
      <ul>
        <li>Python</li>
        <li>Machine Learning</li>
        <li>Cloud Architecture</li>
        <li>Distributed Systems</li>
      </ul>
    </div>
  </div>
</body>
</html>
''');

    // Define a schema for structured extraction
    final schema = SchemaObject(
      properties: {
        'name': SchemaProperty.string(
          description: 'Full name of the person',
          nullable: false, // Required field
        ),
        'email': SchemaProperty.string(
          description: 'Email address',
          nullable: false, // Required field
        ),
        'phone': SchemaProperty.string(
          description: 'Phone number',
          nullable: true, // Optional field
        ),
        'jobTitle': SchemaProperty.string(
          description: 'Job title or position',
          nullable: false, // Required field
        ),
        'department': SchemaProperty.string(
          description: 'Department or team',
          nullable: true, // Optional field
        ),
        'yearsOfExperience': SchemaProperty.number(
          description: 'Years of experience',
          nullable: true, // Optional field
        ),
        'skills': SchemaProperty.array(
          items: SchemaProperty.string(),
          description: 'List of technical skills',
          nullable: true, // Optional field
        ),
      },
      description: 'Employee profile information',
    );
    
    print('Extracting structured data from HTML...\n');
    
    // Send message with schema
    final result = await geminiChat.sendMessageWithSchema(
      messages: [
        GeminiSdkContent.text('Extract the employee information from this HTML file'),
        GeminiSdkContent.file(profileFile),
      ],
      schema: schema,
    );
    
    print('Model message: ${result.llmMessage}\n');
    print('Extracted data:');
    print('  Name: ${result.structuredSchemaData['name']}');
    print('  Email: ${result.structuredSchemaData['email']}');
    print('  Phone: ${result.structuredSchemaData['phone'] ?? 'Not provided'}');
    print('  Job Title: ${result.structuredSchemaData['jobTitle']}');
    print('  Department: ${result.structuredSchemaData['department'] ?? 'Not provided'}');
    print('  Years of Experience: ${result.structuredSchemaData['yearsOfExperience'] ?? 'Not provided'}');
    
    if (result.structuredSchemaData['skills'] != null) {
      print('  Skills:');
      for (final skill in result.structuredSchemaData['skills']) {
        print('    - $skill');
      }
    }
    
    // Clean up
    await profileFile.delete();
    
  } catch (e) {
    print('Error: $e');
  } finally {
    await geminiChat.dispose();
  }
}