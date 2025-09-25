import 'package:programming_cli_core_sdk/src/schema_property.dart';
import 'package:test/test.dart';

void main() {
  final schema =
      SchemaProperty.structuredObject(
            properties: {
              'id': SchemaProperty.integer(
                description: 'Unique identifier for the entity',
                nullable: false,
              ),
              'name': SchemaProperty.text(
                description: 'Display name',
                nullable: false,
              ),
              'status': SchemaProperty.enumeration(
                enumValues: ['draft', 'active', 'archived'],
                description: 'Lifecycle status',
                nullable: false,
              ),
              'tags': SchemaProperty.array(
                items: SchemaProperty.text(nullable: false),
                description: 'List of tags',
                nullable: false,
              ),
              'metadata': SchemaProperty.structuredObject(
                properties: {
                  'owner': SchemaProperty.text(
                    description: 'Owner responsible for the entity',
                    nullable: false,
                  ),
                  'notes': SchemaProperty.text(
                    description: 'Optional notes',
                    nullable: true,
                  ),
                  'flags': SchemaProperty.array(
                    items: SchemaProperty.boolean(nullable: false),
                    description: 'Optional list of flags for the entity',
                    nullable: true,
                  ),
                  'preferences': SchemaProperty.structuredObject(
                    properties: {
                      'notifications': SchemaProperty.boolean(
                        description: 'If true, notifications are enabled',
                        nullable: false,
                      ),
                      'theme': SchemaProperty.enumeration(
                        enumValues: ['light', 'dark'],
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
                items: SchemaProperty.structuredObject(
                  properties: {
                    'sessionId': SchemaProperty.text(
                      description: 'Session identifier',
                      nullable: false,
                    ),
                    'active': SchemaProperty.boolean(
                      description: 'Whether the session is active',
                      nullable: false,
                    ),
                    'metrics': SchemaProperty.structuredObject(
                      properties: {
                        'attempts': SchemaProperty.integer(
                          description: 'Number of attempts',
                          nullable: false,
                        ),
                        'duration': SchemaProperty.double(
                          description: 'Session duration in seconds',
                          nullable: true,
                        ),
                        'history': SchemaProperty.array(
                          items: SchemaProperty.structuredObject(
                            properties: {
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
                properties: {
                  'payloadType': SchemaProperty.enumeration(
                    enumValues: ['basic', 'advanced'],
                    description: 'Payload type flag',
                    nullable: false,
                  ),
                  'details': SchemaProperty.structuredObject(
                    properties: {
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
          )
          as SchemaPropertyStructuredObjectWithDefinedProperties;

  test('Should have expected to string root mapping', () {
    print(SchemaDefinition(properties: schema.properties).toString());
    // expect(dartClass, expectedClassDeclaration);
  });
  test('Should cast to exact Dart class declaration', () {
    final dartClass = schema.toDartClassDeclaration;
    expect(dartClass, expectedClassDeclaration);
  });
  group('validateIdJsonFollowsSchemaStructure', () {
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
          'preferences': {'notifications': true, 'theme': 'dark'},
        },
        'sessions': [
          {
            'sessionId': 'session-1',
            'active': true,
            'metrics': {
              'attempts': 3,
              'duration': 12.75,
              'history': [
                {'timestamp': '2024-06-01T12:00:00Z', 'success': true},
                {'timestamp': '2024-06-01T12:05:00Z', 'success': false},
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
                {'timestamp': '2024-06-01T14:00:00Z', 'success': true},
              ],
            },
          },
        ],
        'optionalPayload': {
          'payloadType': 'basic',
          'details': {'description': 'Payload data', 'score': 98.5},
        },
      };
    }

    test('accepts a fully valid payload', () {
      final model = buildValidModel();
      expect(schema.validateIdJsonFollowsSchemaStructure(model), isNull);
    });

    test('rejects payload missing required top-level field', () {
      final model = buildValidModel();
      model.remove('name');
      expect(schema.validateIdJsonFollowsSchemaStructure(model), isNotNull);
    });

    test('accepts when nullable object is null or absent', () {
      final modelWithNull = buildValidModel();
      modelWithNull['optionalPayload'] = null;
      expect(
        schema.validateIdJsonFollowsSchemaStructure(modelWithNull),
        isNull,
      );

      final modelWithoutKey = buildValidModel();
      modelWithoutKey.remove('optionalPayload');
      expect(
        schema.validateIdJsonFollowsSchemaStructure(modelWithoutKey),
        isNull,
      );
    });

    test('rejects incorrect primitive types deep in the tree', () {
      final model = buildValidModel();
      (model['metadata'] as Map<String, dynamic>)['owner'] = 1234;
      final error = schema.validateIdJsonFollowsSchemaStructure(model);
      expect(error, isNotNull);
      expect(error, contains('Expected String at root.metadata.owner'));
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

      final error = schema.validateIdJsonFollowsSchemaStructure(model);
      expect(error, isNotNull);
      expect(error, contains('Expected bool at root.sessions[0].metrics.history[0].success'));
    });

    test('allows unspecified additional keys while matching known schema', () {
      final model = buildValidModel();
      (model['metadata'] as Map<String, dynamic>)['extraData'] = {'foo': 'bar'};
      model['unexpectedRootKey'] = 'ignored';
      expect(schema.validateIdJsonFollowsSchemaStructure(model), isNull);
    });

    test('accepts nullable fields when omitted from nested structures', () {
      final model = buildValidModel();
      final metadata = model['metadata'] as Map<String, dynamic>;
      metadata.remove('notes');
      metadata.remove('flags');
      final Map<String, dynamic> preferences =
          metadata['preferences'] as Map<String, dynamic>;
      preferences.remove('theme');

      expect(schema.validateIdJsonFollowsSchemaStructure(model), isNull);
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

      final error = schema.validateIdJsonFollowsSchemaStructure(model);
      expect(error, isNotNull);
      expect(error, contains('Missing required field "success"'));
    });
  });
}

const expectedClassDeclaration = """SchemaProperty.structuredObject(
  properties: {
    'id': SchemaProperty.integer(
      description: 'Unique identifier for the entity',
      nullable: false,
    ),
    'name': SchemaProperty.text(
      description: 'Display name',
      nullable: false,
    ),
    'status': SchemaProperty.enumeration(
      enumValues: ['draft', 'active', 'archived'],
      description: 'Lifecycle status',
      nullable: false,
    ),
    'tags': SchemaProperty.array(
      items: SchemaProperty.text(
        nullable: false,
      ),
      description: 'List of tags',
      nullable: false,
    ),
    'metadata': SchemaProperty.structuredObject(
      properties: {
        'owner': SchemaProperty.text(
          description: 'Owner responsible for the entity',
          nullable: false,
        ),
        'notes': SchemaProperty.text(
          description: 'Optional notes',
          nullable: true,
        ),
        'flags': SchemaProperty.array(
          items: SchemaProperty.boolean(
            nullable: false,
          ),
          description: 'Optional list of flags for the entity',
          nullable: true,
        ),
        'preferences': SchemaProperty.structuredObject(
          properties: {
            'notifications': SchemaProperty.boolean(
              description: 'If true, notifications are enabled',
              nullable: false,
            ),
            'theme': SchemaProperty.enumeration(
              enumValues: ['light', 'dark'],
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
      items: SchemaProperty.structuredObject(
        properties: {
          'sessionId': SchemaProperty.text(
            description: 'Session identifier',
            nullable: false,
          ),
          'active': SchemaProperty.boolean(
            description: 'Whether the session is active',
            nullable: false,
          ),
          'metrics': SchemaProperty.structuredObject(
            properties: {
              'attempts': SchemaProperty.integer(
                description: 'Number of attempts',
                nullable: false,
              ),
              'duration': SchemaProperty.double(
                description: 'Session duration in seconds',
                nullable: true,
              ),
              'history': SchemaProperty.array(
                items: SchemaProperty.structuredObject(
                  properties: {
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
      properties: {
        'payloadType': SchemaProperty.enumeration(
          enumValues: ['basic', 'advanced'],
          description: 'Payload type flag',
          nullable: false,
        ),
        'details': SchemaProperty.structuredObject(
          properties: {
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
)""";
