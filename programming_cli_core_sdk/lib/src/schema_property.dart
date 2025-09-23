import 'dart:convert';

class RootSchema {
  final Map<String, SchemaProperty> properties;
  RootSchema({required this.properties});

  Map<String, dynamic> toJson() =>
      properties.map((key, value) => MapEntry(key, value.toJson()));

  @override
  String toString() => JsonEncoder.withIndent('  ').convert(toJson());
}

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
  bool validateIdJsonFollowsSchemaStructure(Map<String, dynamic> model) {
    return _validateValueForSchema(this, model);
  }

  static bool _validateValueForSchema(SchemaProperty schema, dynamic value) {
    if (value == null) {
      return schema.nullable;
    }

    switch (schema) {
      case SchemaPropertyString():
        return value is String;
      case SchemaPropertyInteger():
        return value is int;
      case SchemaPropertyDouble():
        return value is num;
      case SchemaPropertyBoolean():
        return value is bool;
      case SchemaPropertyEnum(:final enumValues):
        return value is String && enumValues.contains(value);
      case SchemaPropertyArray(:final items):
        if (value is! List) {
          return false;
        }
        for (final element in value) {
          if (!_validateValueForSchema(items, element)) {
            return false;
          }
        }
        return true;
      case SchemaPropertyObjectWithUndefinedProperties():
        return value is Map<String, dynamic>;
      case SchemaPropertyStructuredObjectWithDefinedProperties(
        :final properties,
      ):
        if (value is! Map<String, dynamic>) {
          return false;
        }

        for (final entry in properties.entries) {
          final key = entry.key;
          final propertySchema = entry.value;
          final hasKey = value.containsKey(key);

          if (!hasKey) {
            if (!propertySchema.nullable) {
              return false;
            }
            continue;
          }

          final propertyValue = value[key];
          if (!_validateValueForSchema(propertySchema, propertyValue)) {
            return false;
          }
        }
        return true;
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
