// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  test('Is correct schema', () async {
    final schemaFile = File('/Users/igor/PersonalProjects/zenscrap/zenscrap_server/ai_generated_files/yKfY/schema_response_id-yKfY.json');
    if (!await schemaFile.exists()) {
      throw Exception('Schema file does not exist at " /Users/igor/PersonalProjects/zenscrap/zenscrap_server/ai_generated_files/yKfY/schema_response_id-yKfY.json " - AI did not write any JSON output to the file');
    }
    final schemaContent = await schemaFile.readAsString();
    if (schemaContent.trim().isEmpty) {
      throw Exception('Schema file is empty at " /Users/igor/PersonalProjects/zenscrap/zenscrap_server/ai_generated_files/yKfY/schema_response_id-yKfY.json " - AI did not write any JSON output to the file');
    }
    final Map<String, dynamic> schemaJson = jsonDecode(schemaContent);
    final String? validationError = schema.validateIdJsonFollowsSchemaStructure(
      schemaJson,
    );
    if (validationError != null) {
      throw Exception('Schema validation failed: $validationError');
    }
  }, timeout: Timeout(Duration(minutes: 2)));
}

final SchemaPropertyStructuredObjectWithDefinedProperties schema = SchemaProperty.structuredObject(
  properties: {
    'responseType': SchemaProperty.enumeration(
      enumValues: ['message', 'error', 'data'],
      description: '''The type of response: "message", "error", or "data"''',
      nullable: false,
    ),
    'message': SchemaProperty.text(
      description: '''A message from the AI (used for responseType "message")''',
      nullable: true,
    ),
    'errorMessage': SchemaProperty.text(
      description: '''An error message (used for responseType "error")''',
      nullable: true,
    ),
    'resumeActionMessage': SchemaProperty.text(
      description: '''A summary of what the AI did (used for responseType "data")''',
      nullable: true,
    ),
    'scrappableRequest': SchemaProperty.structuredObject(
      properties: {
        'url': SchemaProperty.text(
          description: '''URL pattern with {paramName} placeholders for dynamic segments''',
          nullable: false,
        ),
        'queryParam': SchemaProperty.objectWithUndefinedProperties(
          description: '''Query parameters that will be added to the URL. Map values are default values if not in user payload. Example: {"sort": "asc", "filter": null}''',
          nullable: false,
        ),
        'queryParamsNotRelatedToUrl': SchemaProperty.objectWithUndefinedProperties(
          description: '''Dynamic parameters used ONLY in extract_rules/js_scenario placeholders, NOT added to URL. For client-side interactions like search boxes, pagination buttons, filters. Example: {"searchQuery": null, "currentPage": null}''',
          nullable: false,
        ),
        'pathParams': SchemaProperty.array(
          items: SchemaProperty.text(
            nullable: false,
          ),
          description: '''List of path parameter names that appear as {paramName} in the URL''',
          nullable: false,
        ),
      },
      description: '''Modified ScrappableRequest structure if the AI needs to add/modify dynamic parameters. Include this when adding queryParams or queryParamsNotRelatedToUrl fields. Optional - only include if request structure needs modification.''',
      nullable: true,
    ),
    'scrappingBeeFetchSettings': SchemaProperty.structuredObject(
      properties: {
        'url': SchemaProperty.text(
          description: '''The target URL for scraping''',
          nullable: false,
        ),
        'extract_rules': SchemaProperty.text(
          description: '''JSON-encoded extraction rules. CRITICAL FORMAT REQUIREMENTS:
        
        ✅ CORRECT for single fields: {"field_name": "css_selector"} or {"field_name": "selector@attribute"}
        
        ❌ WRONG: {"field_name": {"selector": "...", "type": "text"}} - DO NOT USE THIS FORMAT FOR SINGLE FIELDS!
        
        ✅ ONLY use nested format for lists: {"items": {"selector": ".item", "type": "list", "output": {...}}}
        
        Examples:
        
          Single text: {"title": "h1"}
        
          Attribute: {"image": "img@src"}
        
          List: {"products": {"selector": ".product", "type": "list", "output": {"name": ".name", "price": ".price@data-price"}}}''',
          nullable: false,
        ),
        'js_scenario': SchemaProperty.text(
          description: '''JSON-encoded JavaScript scenario for interactions''',
          nullable: true,
        ),
        'render_js': SchemaProperty.boolean(
          description: '''Whether to render JavaScript''',
          nullable: false,
        ),
        'wait': SchemaProperty.integer(
          description: '''Fixed delay in milliseconds (int with max value as 35000), but try to avoid if possible so the request is faster - if really needed try to start with low values like 3000 or 5000''',
          nullable: true,
        ),
        'wait_for': SchemaProperty.text(
          description: '''CSS/XPath selector to wait for''',
          nullable: true,
        ),
        'wait_browser': SchemaProperty.text(
          description: '''Browser event to wait for''',
          nullable: true,
        ),
        'premium_proxy': SchemaProperty.boolean(
          description: '''Whether to use premium residential proxy''',
          nullable: false,
        ),
        'stealth_proxy': SchemaProperty.boolean(
          description: '''Whether to use stealth proxy for hardest-to-scrape sites (most expensive)''',
          nullable: false,
        ),
        'country_code': SchemaProperty.text(
          description: '''Proxy geolocation code (2-letter country code)''',
          nullable: true,
        ),
        'session_id': SchemaProperty.text(
          description: '''Session ID for sticky sessions''',
          nullable: true,
        ),
        'custom_google': SchemaProperty.boolean(
          description: '''Whether to use Google-specific handling''',
          nullable: true,
        ),
      },
      description: '''ScrapingBee fetch settings with extraction rules. Required for responseType "data".''',
      nullable: true,
    ),
  },
  nullable: false,
) as SchemaPropertyStructuredObjectWithDefinedProperties;

sealed class SchemaProperty {
  final String type;
  final bool nullable;
  final String? description;
  SchemaProperty({required this.type, this.nullable = false, this.description});

  factory SchemaProperty.text({required bool nullable, String? description}) =
      SchemaPropertyString;
  factory SchemaProperty.integer({
    required bool nullable,
    String? description,
  }) = SchemaPropertyInteger;
  factory SchemaProperty.double({required bool nullable, String? description}) =
      SchemaPropertyDouble;
  factory SchemaProperty.boolean({
    required bool nullable,
    String? description,
  }) = SchemaPropertyBoolean;
  factory SchemaProperty.enumeration({
    required List<String> enumValues,
    required bool nullable,
    String? description,
  }) = SchemaPropertyEnum;
  factory SchemaProperty.array({
    required SchemaProperty items,
    required bool nullable,
    String? description,
  }) = SchemaPropertyArray;
  factory SchemaProperty.structuredObject({
    required Map<String, SchemaProperty> properties,
    required bool nullable,
    String? description,
  }) = SchemaPropertyStructuredObjectWithDefinedProperties;
  factory SchemaProperty.objectWithUndefinedProperties({
    required bool nullable,
    String? description,
  }) = SchemaPropertyObjectWithUndefinedProperties;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'type': type,
      'nullable': nullable,
      if (description != null) 'description': description,
    };

    switch (this) {
      case SchemaPropertyEnum():
        json['possibleEnumValues'] = (this as SchemaPropertyEnum).enumValues;
      case SchemaPropertyArray():
        json['items'] = (this as SchemaPropertyArray).items.toJson();
      case SchemaPropertyStructuredObjectWithDefinedProperties():
        json['properties'] =
            (this as SchemaPropertyStructuredObjectWithDefinedProperties)
                .properties
                .map((key, value) => MapEntry(key, value.toJson()));
      default:
        // No additional fields for other types
        break;
    }
    return json;
  }

  @override
  String toString() => JsonEncoder.withIndent('  ').convert(toJson());
}

class SchemaPropertyString extends SchemaProperty {
  SchemaPropertyString({required super.nullable, super.description})
    : super(type: 'string');
}

class SchemaPropertyInteger extends SchemaProperty {
  SchemaPropertyInteger({required super.nullable, super.description})
    : super(type: 'integer');
}

class SchemaPropertyDouble extends SchemaProperty {
  SchemaPropertyDouble({required super.nullable, super.description})
    : super(type: 'double');
}

class SchemaPropertyBoolean extends SchemaProperty {
  SchemaPropertyBoolean({required super.nullable, super.description})
    : super(type: 'boolean');
}

class SchemaPropertyEnum extends SchemaProperty {
  final List<String> enumValues;
  SchemaPropertyEnum({
    required this.enumValues,
    required super.nullable,
    super.description,
  }) : super(type: 'enum');
}

class SchemaPropertyArray extends SchemaProperty {
  final SchemaProperty items;
  SchemaPropertyArray({
    required this.items,
    required super.nullable,
    super.description,
  }) : super(type: 'array');
}

class SchemaPropertyObjectWithUndefinedProperties extends SchemaProperty {
  SchemaPropertyObjectWithUndefinedProperties({
    required super.nullable,
    super.description,
  }) : super(type: 'dynamic_object_with_undefined_properties');
}

class SchemaPropertyStructuredObjectWithDefinedProperties
    extends SchemaProperty {
  final Map<String, SchemaProperty> properties;
  SchemaPropertyStructuredObjectWithDefinedProperties({
    required this.properties,
    required super.nullable,
    super.description,
  }) : super(type: 'structured_object_with_defined_properties');

  // Will see if a given JSON object follows this schema structure
  // If a field is required (not nullable) it must be present
  // If a field is nullable it can be absent or null, but if it is present it must follow the schema
  // Returns null if valid, error message if invalid
  String? validateIdJsonFollowsSchemaStructure(Map<String, dynamic> model) {
    return _validateValueForSchema(this, model, 'root');
  }

  static String? _validateValueForSchema(SchemaProperty schema, dynamic value, String path) {
    if (value == null) {
      if (!schema.nullable) {
        return 'Expected non-null value at $path but got null (field is not nullable)';
      }
      return null;
    }

    switch (schema) {
      case SchemaPropertyString():
        if (value is! String) {
          return 'Expected String at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyInteger():
        if (value is! int) {
          return 'Expected int at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyDouble():
        if (value is! num) {
          return 'Expected num (double) at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyBoolean():
        if (value is! bool) {
          return 'Expected bool at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyEnum(:final enumValues):
        if (value is! String) {
          return 'Expected String (enum) at $path but got ${value.runtimeType}';
        }
        if (!enumValues.contains(value)) {
          return 'Invalid enum value at $path: "$value" is not one of [${enumValues.join(', ')}]';
        }
        return null;
      case SchemaPropertyArray(:final items):
        if (value is! List) {
          return 'Expected List at $path but got ${value.runtimeType}';
        }
        for (var i = 0; i < value.length; i++) {
          final error = _validateValueForSchema(items, value[i], '$path[$i]');
          if (error != null) {
            return error;
          }
        }
        return null;
      case SchemaPropertyObjectWithUndefinedProperties():
        if (value is! Map<String, dynamic>) {
          return 'Expected Map<String, dynamic> at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyStructuredObjectWithDefinedProperties(
        :final properties,
      ):
        if (value is! Map<String, dynamic>) {
          return 'Expected Map<String, dynamic> at $path but got ${value.runtimeType}';
        }

        for (final entry in properties.entries) {
          final key = entry.key;
          final propertySchema = entry.value;
          final hasKey = value.containsKey(key);

          if (!hasKey) {
            if (!propertySchema.nullable) {
              return 'Missing required field "$key" at $path (field is not nullable)';
            }
            continue;
          }

          final propertyValue = value[key];
          final error = _validateValueForSchema(propertySchema, propertyValue, '$path.$key');
          if (error != null) {
            return error;
          }
        }
        return null;
    }
  }

  // This will be a Dart class declaration. This will be a extremely basic and naive implementation.
  String get toDartClassDeclaration {
    return _toCode(this, 0);
  }

  static String _escape(String value) => value.replaceAll("'", r"\'");

  static String _toCode(SchemaProperty schema, int indentLevel) {
    final buffer = StringBuffer();
    final indent = '  ' * indentLevel;
    final childIndent = '  ' * (indentLevel + 1);

    void writeDescriptionLine() {
      if (schema.description != null) {
        buffer.writeln(
          "${childIndent}description: '${_escape(schema.description!)}',",
        );
      }
    }

    switch (schema) {
      case SchemaPropertyString():
        buffer.writeln('${indent}SchemaProperty.text(');
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyInteger():
        buffer.writeln('${indent}SchemaProperty.integer(');
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyDouble():
        buffer.writeln('${indent}SchemaProperty.double(');
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyBoolean():
        buffer.writeln('${indent}SchemaProperty.boolean(');
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyEnum():
        final enumValues = schema.enumValues
            .map((value) => "'${_escape(value)}'")
            .join(', ');
        buffer.writeln('${indent}SchemaProperty.enumeration(');
        buffer.writeln('${childIndent}enumValues: [$enumValues],');
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyArray():
        buffer.writeln('${indent}SchemaProperty.array(');
        final itemCode = _toCode(schema.items, indentLevel + 1);
        final itemLines = itemCode.split('\n');
        final trimPrefix = '  ' * (indentLevel + 1);
        for (var i = 0; i < itemLines.length; i++) {
          final line = itemLines[i];
          final trimmed = line.startsWith(trimPrefix)
              ? line.substring(trimPrefix.length)
              : line;
          final isLastLine = i == itemLines.length - 1;
          String prefix;
          if (i == 0) {
            prefix = '${childIndent}items: ';
          } else if (isLastLine) {
            prefix = childIndent;
          } else {
            prefix = '$childIndent  ';
          }
          final content = (i > 0 && trimmed.startsWith('  '))
              ? trimmed.substring(2)
              : trimmed;
          final suffix = i == itemLines.length - 1 ? ',' : '';
          buffer.writeln('$prefix$content$suffix');
        }
        if (schema.description != null) {
          buffer.writeln(
            "${childIndent}description: '${_escape(schema.description!)}',",
          );
        }
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyObjectWithUndefinedProperties():
        buffer.writeln(
          '${indent}SchemaProperty.objectWithUndefinedProperties(',
        );
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyStructuredObjectWithDefinedProperties():
        final objectSchema = schema;
        buffer.writeln('${indent}SchemaProperty.structuredObject(');
        buffer.writeln('${childIndent}properties: {');
        objectSchema.properties.forEach((key, value) {
          final valueCode = _toCode(value, indentLevel + 2);
          final valueLines = valueCode.split('\n');
          final valueTrimPrefix = '  ' * (indentLevel + 2);
          for (var i = 0; i < valueLines.length; i++) {
            final line = valueLines[i];
            final trimmed = line.startsWith(valueTrimPrefix)
                ? line.substring(valueTrimPrefix.length)
                : line;
            final prefix = i == 0
                ? "$childIndent  '${_escape(key)}': "
                : '$childIndent  ';
            final suffix = i == valueLines.length - 1 ? ',' : '';
            buffer.writeln('$prefix$trimmed$suffix');
          }
        });
        buffer.writeln('$childIndent},');
        if (schema.description != null) {
          buffer.writeln(
            "${childIndent}description: '${_escape(schema.description!)}',",
          );
        }
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
    }

    return buffer.toString();
  }
}
