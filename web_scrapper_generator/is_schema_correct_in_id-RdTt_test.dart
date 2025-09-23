import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  test('Is correct schema', () async {
    final currDir = Directory.current;
    final schemaFile = File('/Users/igormidev/personalprojects/zenscrap/web_scrapper_generator/schema_response_id-RdTt.json');
    final schemaContent = await schemaFile.readAsString();
    final Map<String, dynamic> schemaJson = jsonDecode(schemaContent);
    final bool isValidSchema = schema.validateIdJsonFollowsSchemaStructure(
      schemaJson,
    );
    expect(isValidSchema, true);
  });
}

final SchemaPropertyStructuredObjectWithDefinedProperties schema = SchemaProperty.structuredObject(
  properties: {
    'responseType': SchemaProperty.enumeration(
      enumValues: ['message', 'error', 'data'],
      description: 'The type of response: "message", "error", or "data"',
      nullable: false,
    ),
    'message': SchemaProperty.text(
      description: 'A message from the AI (used for responseType "message")',
      nullable: true,
    ),
    'errorMessage': SchemaProperty.text(
      description: 'An error message (used for responseType "error")',
      nullable: true,
    ),
    'resumeActionMessage': SchemaProperty.text(
      description: 'A summary of what the AI did (used for responseType "data")',
      nullable: true,
    ),
    'request': SchemaProperty.structuredObject(
      properties: {
        'url': SchemaProperty.text(
          description: 'URL pattern with {paramName} placeholders for dynamic segments',
          nullable: false,
        ),
        'queryParam': SchemaProperty.structuredObject(
          properties: {
            '__dynamic__': SchemaProperty.text(
              description: 'Dynamic key-value pairs for query parameters',
              nullable: true,
            ),
          },
          description: 'Query parameters with optional default values',
          nullable: false,
        ),
        'pathParams': SchemaProperty.array(
          items: SchemaProperty.text(
            nullable: false,
          ),
          description: 'List of path parameter names',
          nullable: false,
        ),
      },
      description: 'Modified WebScrapperRequest if changes were made, null if no changes needed',
      nullable: true,
    ),
    'fetchSettings': SchemaProperty.structuredObject(
      properties: {
        'url': SchemaProperty.text(
          description: 'The target URL for scraping',
          nullable: false,
        ),
        'extract_rules': SchemaProperty.text(
          description: 'JSON-encoded extraction rules',
          nullable: false,
        ),
        'js_scenario': SchemaProperty.text(
          description: 'JSON-encoded JavaScript scenario for interactions',
          nullable: true,
        ),
        'render_js': SchemaProperty.boolean(
          description: 'Whether to render JavaScript',
          nullable: false,
        ),
        'wait': SchemaProperty.double(
          description: 'Fixed delay in milliseconds',
          nullable: true,
        ),
        'wait_for': SchemaProperty.text(
          description: 'CSS/XPath selector to wait for',
          nullable: true,
        ),
        'wait_browser': SchemaProperty.text(
          description: 'Browser event to wait for',
          nullable: true,
        ),
        'premium_proxy': SchemaProperty.boolean(
          description: 'Whether to use premium residential proxy',
          nullable: false,
        ),
        'country_code': SchemaProperty.text(
          description: 'Proxy geolocation code (2-letter country code)',
          nullable: true,
        ),
        'session_id': SchemaProperty.text(
          description: 'Session ID for sticky sessions',
          nullable: true,
        ),
        'custom_google': SchemaProperty.boolean(
          description: 'Whether to use Google-specific handling',
          nullable: true,
        ),
      },
      description: 'ScrapingBee fetch settings (used for responseType "data")',
      nullable: true,
    ),
  },
  nullable: false,
) as SchemaPropertyStructuredObjectWithDefinedProperties;