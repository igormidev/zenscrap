import 'dart:convert';

sealed class SchemaProperty {
  final String type;
  final bool nullable;
  final String? description;
  SchemaProperty({
    required this.type,
    required this.nullable,
    this.description,
  });

  factory SchemaProperty.text() = SchemaPropertyString;
  factory SchemaProperty.integer() = SchemaPropertyInteger;
  factory SchemaProperty.double() = SchemaPropertyDouble;
  factory SchemaProperty.boolean() = SchemaPropertyBoolean;
  factory SchemaProperty.enumeration(List<String> enumValues) =
      SchemaPropertyEnum;
  factory SchemaProperty.array(SchemaProperty items) = SchemaPropertyArray;
  factory SchemaProperty.object(Map<String, SchemaProperty> properties) =
      SchemaPropertyObject;

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
      case SchemaPropertyObject():
        json['properties'] = (this as SchemaPropertyObject).properties.map(
          (key, value) => MapEntry(key, value.toJson()),
        );
      default:
        // No additional fields for other types
        break;
    }
    return json;
  }

  @override
  String toString() => JsonEncoder.withIndent('  ').convert(toJson());

  String toDartClass() {
    final StringBuffer buffer = StringBuffer();

    buffer.writeln('class ${type[0].toUpperCase()}${type.substring(1)} {');
    switch (this) {
      case SchemaPropertyEnum():
        final enumValues = (this as SchemaPropertyEnum).enumValues;
        buffer.writeln('  // Enum values: ${enumValues.join(', ')}');
      case SchemaPropertyArray():
        final itemsType = (this as SchemaPropertyArray).items.type;
        buffer.writeln('  final List<$itemsType> items;');
        buffer.writeln(
          '  ${type[0].toUpperCase()}${type.substring(1)}(this.items);',
        );
      case SchemaPropertyObject():
        final properties = (this as SchemaPropertyObject).properties;
        properties.forEach((key, value) {
          buffer.writeln('  final ${value.type} $key;');
        });
        buffer.writeln('  ${type[0].toUpperCase()}${type.substring(1)}({');
        properties.forEach((key, value) {
          buffer.writeln('    required this.$key,');
        });
        buffer.writeln('  });');
      default:
        buffer.writeln('  // No additional fields for type $type');
    }
    buffer.writeln('}');

    return buffer.toString();
  }
}

class SchemaPropertyString extends SchemaProperty {
  SchemaPropertyString({super.nullable = false, super.description})
    : super(type: 'string');
}

class SchemaPropertyInteger extends SchemaProperty {
  SchemaPropertyInteger({super.nullable = false, super.description})
    : super(type: 'integer');
}

class SchemaPropertyDouble extends SchemaProperty {
  SchemaPropertyDouble({super.nullable = false, super.description})
    : super(type: 'double');
}

class SchemaPropertyBoolean extends SchemaProperty {
  SchemaPropertyBoolean({super.nullable = false, super.description})
    : super(type: 'boolean');
}

class SchemaPropertyEnum extends SchemaProperty {
  final List<String> enumValues;
  SchemaPropertyEnum(
    this.enumValues, {
    super.nullable = false,
    super.description,
  }) : super(type: 'enum');
}

class SchemaPropertyArray extends SchemaProperty {
  final SchemaProperty items;
  SchemaPropertyArray(this.items, {super.nullable = false, super.description})
    : super(type: 'array');
}

class SchemaPropertyObject extends SchemaProperty {
  final Map<String, SchemaProperty> properties;
  SchemaPropertyObject(
    this.properties, {
    super.nullable = false,
    super.description,
  }) : super(type: 'object');
}
