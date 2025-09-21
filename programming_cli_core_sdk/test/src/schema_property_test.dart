import 'package:programming_cli_core_sdk/src/schema_property.dart';
import 'package:test/test.dart';

void main() {
  group('validateIdJsonFollowsSchemaStructure', () {
    final schema = SchemaProperty.structuredObject(
      {
        'id': SchemaProperty.integer(
          description: 'Unique identifier for the entity',
          nullable: false,
        ),
        'name': SchemaProperty.text(
          description: 'Display name',
          nullable: false,
        ),
        'status': SchemaProperty.enumeration(
          ['draft', 'active', 'archived'],
          description: 'Lifecycle status',
          nullable: false,
        ),
        'tags': SchemaProperty.array(
          SchemaProperty.text(nullable: false),
          description: 'List of tags',
          nullable: false,
        ),
        'metadata': SchemaProperty.structuredObject(
          {
            'owner': SchemaProperty.text(
              description: 'Owner responsible for the entity',
              nullable: false,
            ),
            'notes': SchemaProperty.text(
              description: 'Optional notes',
              nullable: true,
            ),
            'flags': SchemaProperty.array(
              SchemaProperty.boolean(nullable: false),
              description: 'Optional list of flags for the entity',
              nullable: true,
            ),
            'preferences': SchemaProperty.structuredObject(
              {
                'notifications': SchemaProperty.boolean(
                  description: 'If true, notifications are enabled',
                  nullable: false,
                ),
                'theme': SchemaProperty.enumeration(
                  ['light', 'dark'],
                  description: 'Preferred theme',
                  nullable: true,
                ),
              },
              description: 'User preferences',
              nullable: false,
            ),
          },
          description: 'Owner metadata information',
          nullable: false,
        ),
        'sessions': SchemaProperty.array(
          SchemaProperty.structuredObject(
            {
              'sessionId': SchemaProperty.text(
                description: 'Session identifier',
                nullable: false,
              ),
              'active': SchemaProperty.boolean(
                description: 'Whether the session is active',
                nullable: false,
              ),
              'metrics': SchemaProperty.structuredObject(
                {
                  'attempts': SchemaProperty.integer(
                    description: 'Number of attempts',
                    nullable: false,
                  ),
                  'duration': SchemaProperty.double(
                    description: 'Session duration in seconds',
                    nullable: true,
                  ),
                  'history': SchemaProperty.array(
                    SchemaProperty.structuredObject(
                      {
                        'timestamp': SchemaProperty.text(
                          description: 'History timestamp in ISO8601',
                          nullable: false,
                        ),
                        'success': SchemaProperty.boolean(
                          description: 'Whether the attempt succeeded',
                          nullable: false,
                        ),
                      },
                      description: 'Single history entry',
                      nullable: false,
                    ),
                    description: 'Chronological history entries',
                    nullable: false,
                  ),
                },
                description: 'Aggregated session metrics',
                nullable: false,
              ),
            },
            description: 'Session details',
            nullable: false,
          ),
          description: 'Collection of sessions',
          nullable: false,
        ),
        'optionalPayload': SchemaProperty.structuredObject(
          {
            'payloadType': SchemaProperty.enumeration(
              ['basic', 'advanced'],
              description: 'Payload type flag',
              nullable: false,
            ),
            'details': SchemaProperty.structuredObject(
              {
                'description': SchemaProperty.text(
                  description: 'Detailed description',
                  nullable: false,
                ),
                'score': SchemaProperty.double(
                  description: 'Optional score',
                  nullable: true,
                ),
              },
              description: 'Payload details',
              nullable: true,
            ),
          },
          description: 'Optional payload data',
          nullable: true,
        ),
      },
      description: 'Complex schema for validation testing',
      nullable: false,
    ) as SchemaPropertyStructuredObjectWithDefinedProperties;

    Map<String, dynamic> buildValidModel() {
      return {
        'id': 42,
        'name': 'Zenscrap Session',
        'status': 'active',
        'tags': ['alpha', 'beta'],
        'metadata': {
          'owner': 'owner-id',
          'notes': 'Important context',
          'flags': [true, false, true],
          'preferences': {
            'notifications': true,
            'theme': 'dark',
          },
        },
        'sessions': [
          {
            'sessionId': 'session-1',
            'active': true,
            'metrics': {
              'attempts': 3,
              'duration': 12.75,
              'history': [
                {
                  'timestamp': '2024-06-01T12:00:00Z',
                  'success': true,
                },
                {
                  'timestamp': '2024-06-01T12:05:00Z',
                  'success': false,
                },
              ],
            },
          },
          {
            'sessionId': 'session-2',
            'active': false,
            'metrics': {
              'attempts': 1,
              'duration': null,
              'history': [
                {
                  'timestamp': '2024-06-01T14:00:00Z',
                  'success': true,
                },
              ],
            },
          },
        ],
        'optionalPayload': {
          'payloadType': 'basic',
          'details': {
            'description': 'Payload data',
            'score': 98.5,
          },
        },
      };
    }

    test('accepts a fully valid payload', () {
      final model = buildValidModel();
      expect(schema.validateIdJsonFollowsSchemaStructure(model), isTrue);
    });

    test('rejects payload missing required top-level field', () {
      final model = buildValidModel();
      model.remove('name');
      expect(schema.validateIdJsonFollowsSchemaStructure(model), isFalse);
    });

    test('accepts when nullable object is null or absent', () {
      final modelWithNull = buildValidModel();
      modelWithNull['optionalPayload'] = null;
      expect(schema.validateIdJsonFollowsSchemaStructure(modelWithNull), isTrue);

      final modelWithoutKey = buildValidModel();
      modelWithoutKey.remove('optionalPayload');
      expect(schema.validateIdJsonFollowsSchemaStructure(modelWithoutKey), isTrue);
    });

    test('rejects incorrect primitive types deep in the tree', () {
      final model = buildValidModel();
      (model['metadata'] as Map<String, dynamic>)['owner'] = 1234;
      expect(schema.validateIdJsonFollowsSchemaStructure(model), isFalse);
    });

    test('rejects invalid array element structures', () {
      final model = buildValidModel();
      final List<dynamic> sessions = model['sessions'] as List<dynamic>;
      final Map<String, dynamic> firstSession =
          sessions.first as Map<String, dynamic>;
      final Map<String, dynamic> metrics =
          firstSession['metrics'] as Map<String, dynamic>;
      final List<dynamic> history = metrics['history'] as List<dynamic>;
      (history.first as Map<String, dynamic>)['success'] = 'yes';

      expect(schema.validateIdJsonFollowsSchemaStructure(model), isFalse);
    });

    test('allows unspecified additional keys while matching known schema', () {
      final model = buildValidModel();
      (model['metadata'] as Map<String, dynamic>)['extraData'] = {'foo': 'bar'};
      model['unexpectedRootKey'] = 'ignored';
      expect(schema.validateIdJsonFollowsSchemaStructure(model), isTrue);
    });

    test('accepts nullable fields when omitted from nested structures', () {
      final model = buildValidModel();
      final metadata = model['metadata'] as Map<String, dynamic>;
      metadata.remove('notes');
      metadata.remove('flags');
      final Map<String, dynamic> preferences =
          metadata['preferences'] as Map<String, dynamic>;
      preferences.remove('theme');

      expect(schema.validateIdJsonFollowsSchemaStructure(model), isTrue);
    });

    test('rejects missing required properties in nested objects', () {
      final model = buildValidModel();
      final sessions = model['sessions'] as List<dynamic>;
      final firstSession = sessions.first as Map<String, dynamic>;
      final metrics = firstSession['metrics'] as Map<String, dynamic>;
      (metrics['history'] as List<dynamic>).removeAt(0);
      (metrics['history'] as List<dynamic>).add({
        'timestamp': '2024-06-01T15:00:00Z',
        // Missing required "success" field
      });

      expect(schema.validateIdJsonFollowsSchemaStructure(model), isFalse);
    });
  });
}
