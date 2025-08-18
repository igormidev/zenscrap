import 'dart:convert';

/// Result returned when using schema-based message sending
class SchemaResult {
  /// The message from the model explaining the result
  final String modelMessage;

  /// The structured data returned by the model
  final Map<String, dynamic> data;

  const SchemaResult({
    required this.modelMessage,
    required this.data,
  });

  /// Creates a SchemaResult from JSON
  factory SchemaResult.fromJson(Map<String, dynamic> json) {
    return SchemaResult(
      modelMessage: json['modelMessage'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Converts the result to JSON
  Map<String, dynamic> toJson() => {
        'modelMessage': modelMessage,
        'data': data,
      };

  @override
  String toString() {
    return 'SchemaResult(modelMessage: $modelMessage, data: ${jsonEncode(data)})';
  }
}

/// Represents a JSON schema object for structured responses
class SchemaObject {
  final String type;
  final Map<String, SchemaProperty> properties;
  final List<String>? required;
  final String? description;

  const SchemaObject({
    this.type = 'object',
    required this.properties,
    this.required,
    this.description,
  });

  /// Converts the schema to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type,
      'properties': properties.map((key, value) => MapEntry(key, value.toJson())),
    };

    if (required != null && required!.isNotEmpty) {
      json['required'] = required;
    }

    if (description != null) {
      json['description'] = description;
    }

    return json;
  }
}

/// Represents a property in a JSON schema
class SchemaProperty {
  final String type;
  final String? description;
  final dynamic defaultValue;
  final List<dynamic>? enumValues;
  final SchemaProperty? items; // For array types
  final Map<String, SchemaProperty>? properties; // For object types

  const SchemaProperty({
    required this.type,
    this.description,
    this.defaultValue,
    this.enumValues,
    this.items,
    this.properties,
  });

  /// Creates a string property
  factory SchemaProperty.string({
    String? description,
    String? defaultValue,
    List<String>? enumValues,
  }) {
    return SchemaProperty(
      type: 'string',
      description: description,
      defaultValue: defaultValue,
      enumValues: enumValues,
    );
  }

  /// Creates a number property
  factory SchemaProperty.number({
    String? description,
    num? defaultValue,
  }) {
    return SchemaProperty(
      type: 'number',
      description: description,
      defaultValue: defaultValue,
    );
  }

  /// Creates a boolean property
  factory SchemaProperty.boolean({
    String? description,
    bool? defaultValue,
  }) {
    return SchemaProperty(
      type: 'boolean',
      description: description,
      defaultValue: defaultValue,
    );
  }

  /// Creates an array property
  factory SchemaProperty.array({
    required SchemaProperty items,
    String? description,
  }) {
    return SchemaProperty(
      type: 'array',
      description: description,
      items: items,
    );
  }

  /// Creates an object property
  factory SchemaProperty.object({
    required Map<String, SchemaProperty> properties,
    String? description,
  }) {
    return SchemaProperty(
      type: 'object',
      description: description,
      properties: properties,
    );
  }

  /// Converts the property to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'type': type};

    if (description != null) {
      json['description'] = description;
    }

    if (defaultValue != null) {
      json['default'] = defaultValue;
    }

    if (enumValues != null && enumValues!.isNotEmpty) {
      json['enum'] = enumValues;
    }

    if (items != null) {
      json['items'] = items!.toJson();
    }

    if (properties != null && properties!.isNotEmpty) {
      json['properties'] =
          properties!.map((key, value) => MapEntry(key, value.toJson()));
    }

    return json;
  }
}