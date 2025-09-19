import 'dart:io';
import 'dart:convert';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  // Get API key from environment
  final apiKey = Platform.environment['ANTHROPIC_API_KEY'] ?? 'YOUR_API_KEY';

  if (apiKey == 'YOUR_API_KEY') {
    print('Please set your ANTHROPIC_API_KEY environment variable');
    exit(1);
  }

  final claudeSDK = Claude(apiKey);
  final claudeChat = claudeSDK.createNewChat();

  try {
    // Create a sample HTML file with user data
    final profileFile = File('profile.html');
    await profileFile.writeAsString('''
<!DOCTYPE html>
<html>
<head>
    <title>Employee Profile</title>
</head>
<body>
    <div class="employee-card">
        <h1>Jane Smith</h1>
        <div class="details">
            <p><strong>Email:</strong> jane.smith@techcorp.com</p>
            <p><strong>Position:</strong> Senior Product Manager</p>
            <p><strong>Department:</strong> Product Development</p>
            <p><strong>Employee ID:</strong> EMP-2024-1234</p>
            <p><strong>Start Date:</strong> January 15, 2020</p>
            <p><strong>Office:</strong> New York, Building A, Floor 12</p>
            <p><strong>Phone:</strong> +1 (555) 123-4567</p>
            <p><strong>Reports To:</strong> Michael Johnson (VP of Product)</p>
            <p><strong>Skills:</strong> Product Strategy, Agile, Data Analysis, Team Leadership</p>
        </div>
    </div>
</body>
</html>
''');

    print('Extracting structured data from HTML file...');
    print('---\n');

    // Define a schema for employee information
    final schema = SchemaObject(
      properties: {
        'name': SchemaProperty.string(
          description: 'Full name of the employee',
        ),
        'email': SchemaProperty.string(
          description: 'Email address',
        ),
        'position': SchemaProperty.string(
          description: 'Job title or position',
        ),
        'department': SchemaProperty.string(
          description: 'Department name',
        ),
        'employeeId': SchemaProperty.string(
          description: 'Employee ID number',
        ),
        'startDate': SchemaProperty.string(
          description: 'Employment start date',
        ),
        'office': SchemaProperty.object(
          properties: {
            'city': SchemaProperty.string(
              description: 'Office city',
            ),
            'building': SchemaProperty.string(
              description: 'Building name or number',
            ),
            'floor': SchemaProperty.string(
              description: 'Floor number',
            ),
          },
          description: 'Office location details',
        ),
        'phone': SchemaProperty.string(
          description: 'Phone number',
        ),
        'reportsTo': SchemaProperty.object(
          properties: {
            'name': SchemaProperty.string(
              description: 'Manager name',
            ),
            'title': SchemaProperty.string(
              description: 'Manager title',
            ),
          },
          description: 'Reporting manager information',
        ),
        'skills': SchemaProperty.array(
          items: SchemaProperty.string(),
          description: 'List of skills',
        ),
      },
      required: ['name', 'email', 'position'],
      description: 'Employee information extracted from HTML',
    );

    // Send message with schema
    final result = await claudeChat.sendMessageWithSchema(
      messages: [
        ClaudeSdkContent.text(
            'Extract all employee information from this HTML file'),
        ClaudeSdkContent.file(profileFile),
      ],
      schema: schema,
    );

    print('Model Message:');
    print(result.llmMessage);
    print('\n---\n');

    print('Extracted Data (JSON):');
    print(const JsonEncoder.withIndent('  ').convert(result.structuredSchemaData));
    print('\n---\n');

    // Access specific fields
    print('Accessing specific fields:');
    print('Name: ${result.structuredSchemaData['name']}');
    print('Email: ${result.structuredSchemaData['email']}');
    print('Position: ${result.structuredSchemaData['position']}');

    if (result.structuredSchemaData['office'] != null) {
      final office = result.structuredSchemaData['office'] as Map<String, dynamic>;
      print(
          'Office: ${office['city']}, ${office['building']}, Floor ${office['floor']}');
    }

    if (result.structuredSchemaData['skills'] != null) {
      final skills = result.structuredSchemaData['skills'] as List;
      print('Skills: ${skills.join(', ')}');
    }

    // Clean up
    await profileFile.delete();
  } catch (e) {
    print('Error: $e');
    if (e is ClaudeSDKException) {
      print('SDK Error Details: ${e.message}');
    }
  } finally {
    await claudeChat.dispose();
    await claudeSDK.dispose();
  }
}