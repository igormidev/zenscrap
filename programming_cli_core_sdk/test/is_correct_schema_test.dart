import 'dart:io';

import 'package:programming_cli_core_sdk/src/schema_property.dart';
import 'package:test/test.dart';

void main() {
  test('Is correct schema', () async {
    final currDir = Directory.current;
    final schemaFile = File('${currDir.path}/test/schemas/test_schema.json');
    final schemaContent = await schemaFile.readAsString();
    final schemaJson = schemaContent;
    final schema = getTestSchema();

    // Will check if each parameter is here
  });
}

SchemaPropertyObject getTestSchema() {
  throw UnimplementedError();
}
