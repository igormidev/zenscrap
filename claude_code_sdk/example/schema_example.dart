import 'dart:convert';
import 'dart:io';

import 'package:claude_code_sdk/claude_code_sdk.dart';

Future<void> main() async {
  final apiKey = Platform.environment['ANTHROPIC_API_KEY'] ?? 'YOUR_API_KEY';

  if (apiKey == 'YOUR_API_KEY') {
    print('Please set your ANTHROPIC_API_KEY environment variable.');
    exit(1);
  }

  final claudeSDK = Claude(apiKey: apiKey);
  final claudeChat = claudeSDK.createNewChat();

  try {
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

    final schema = SchemaDefinition(
      properties: {
        'name': SchemaProperty.text(
          nullable: false,
          description: 'Full name of the employee',
        ),
        'email': SchemaProperty.text(
          nullable: false,
          description: 'Email address',
        ),
        'position': SchemaProperty.text(
          nullable: false,
          description: 'Job title or position',
        ),
        'department': SchemaProperty.text(
          nullable: true,
          description: 'Department name',
        ),
        'employeeId': SchemaProperty.text(
          nullable: true,
          description: 'Employee ID number',
        ),
        'startDate': SchemaProperty.text(
          nullable: true,
          description: 'Employment start date',
        ),
        'office': SchemaProperty.structuredObject(
          nullable: true,
          description: 'Office location details',
          properties: {
            'city': SchemaProperty.text(
                nullable: false, description: 'Office city'),
            'building': SchemaProperty.text(
              nullable: false,
              description: 'Building name or number',
            ),
            'floor': SchemaProperty.text(
              nullable: false,
              description: 'Floor number',
            ),
          },
        ),
        'phone': SchemaProperty.text(
          nullable: true,
          description: 'Phone number',
        ),
        'reportsTo': SchemaProperty.structuredObject(
          nullable: true,
          description: 'Reporting manager information',
          properties: {
            'name': SchemaProperty.text(
                nullable: false, description: 'Manager name'),
            'title': SchemaProperty.text(
                nullable: false, description: 'Manager title'),
          },
        ),
        'skills': SchemaProperty.array(
          nullable: true,
          description: 'List of skills',
          items: SchemaProperty.text(nullable: false),
        ),
      },
    );

    final result = await claudeChat.sendMessageWithSchema(
      messages: [
        PromptContent.text(
            'Extract all employee information from this HTML file'),
        PromptContent.file(profileFile),
      ],
      schema: schema,
    );

    print('Model Message:');
    print(result.llmMessage);
    print('\n---\n');

    print('Extracted Data (JSON):');
    print(const JsonEncoder.withIndent('  ')
        .convert(result.structuredSchemaData));
    print('\n---\n');
  } on CliException catch (e) {
    print('SDK Error: ${e.message}');
  } finally {
    await claudeChat.dispose();
    await claudeSDK.dispose();
  }
}
