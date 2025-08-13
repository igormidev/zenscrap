/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'entities/account/account.dart' as _i4;
import 'entities/account/account_api_key.dart' as _i5;
import 'entities/redraft_scrappable_session/prompt_role_enum.dart' as _i6;
import 'entities/redraft_scrappable_session/zen_scrap_redraft_state.dart'
    as _i7;
import 'entities/scrappable/reference_test_data.dart' as _i8;
import 'entities/scrappable/scrappable.dart' as _i9;
import 'entities/scrappable/scrappable_target_request.dart' as _i10;
import 'entities/zenscrap_exception.dart' as _i11;
export 'entities/account/account.dart';
export 'entities/account/account_api_key.dart';
export 'entities/redraft_scrappable_session/prompt_role_enum.dart';
export 'entities/redraft_scrappable_session/zen_scrap_redraft_state.dart';
export 'entities/scrappable/reference_test_data.dart';
export 'entities/scrappable/scrappable.dart';
export 'entities/scrappable/scrappable_target_request.dart';
export 'entities/zenscrap_exception.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'account_api_key',
      dartName: 'AccountApiKey',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'account_api_key_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'apiKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'account_api_key_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'account_info',
      dartName: 'AccountInfo',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'account_info_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'accountApiKeyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'account_info_fk_0',
          columns: ['userInfoId'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'account_info_fk_1',
          columns: ['accountApiKeyId'],
          referenceTable: 'account_api_key',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'account_info_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_info_id_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'scrappable',
      dartName: 'Scrappable',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'scrappable_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'scrappingRules',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'targetRequestId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'testData',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:ReferenceTestData',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'scrappable_fk_0',
          columns: ['targetRequestId'],
          referenceTable: 'scrappable_target_request',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrappable_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'scrappable_target_request_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'targetRequestId',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'scrappable_target_request',
      dartName: 'ScrappableTargetRequestStructure',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'scrappable_target_request_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'url',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'queryParams',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Map<String,String?>',
        ),
        _i2.ColumnDefinition(
          name: 'pathParams',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrappable_target_request_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.AccountInfo) {
      return _i4.AccountInfo.fromJson(data) as T;
    }
    if (t == _i5.AccountApiKey) {
      return _i5.AccountApiKey.fromJson(data) as T;
    }
    if (t == _i6.PromptRole) {
      return _i6.PromptRole.fromJson(data) as T;
    }
    if (t == _i7.ErrorTextResponse) {
      return _i7.ErrorTextResponse.fromJson(data) as T;
    }
    if (t == _i7.MessageTextAndNewExtractRulesResponse) {
      return _i7.MessageTextAndNewExtractRulesResponse.fromJson(data) as T;
    }
    if (t == _i7.MessageTextResponse) {
      return _i7.MessageTextResponse.fromJson(data) as T;
    }
    if (t == _i8.ReferenceTestData) {
      return _i8.ReferenceTestData.fromJson(data) as T;
    }
    if (t == _i9.Scrappable) {
      return _i9.Scrappable.fromJson(data) as T;
    }
    if (t == _i10.ScrappableTargetRequestStructure) {
      return _i10.ScrappableTargetRequestStructure.fromJson(data) as T;
    }
    if (t == _i11.ZenScrapException) {
      return _i11.ZenScrapException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.AccountInfo?>()) {
      return (data != null ? _i4.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AccountApiKey?>()) {
      return (data != null ? _i5.AccountApiKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.PromptRole?>()) {
      return (data != null ? _i6.PromptRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ErrorTextResponse?>()) {
      return (data != null ? _i7.ErrorTextResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.MessageTextAndNewExtractRulesResponse?>()) {
      return (data != null
          ? _i7.MessageTextAndNewExtractRulesResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.MessageTextResponse?>()) {
      return (data != null ? _i7.MessageTextResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ReferenceTestData?>()) {
      return (data != null ? _i8.ReferenceTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Scrappable?>()) {
      return (data != null ? _i9.Scrappable.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ScrappableTargetRequestStructure?>()) {
      return (data != null
          ? _i10.ScrappableTargetRequestStructure.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.ZenScrapException?>()) {
      return (data != null ? _i11.ZenScrapException.fromJson(data) : null) as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<dynamic>(v))) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i4.AccountInfo) {
      return 'AccountInfo';
    }
    if (data is _i5.AccountApiKey) {
      return 'AccountApiKey';
    }
    if (data is _i6.PromptRole) {
      return 'PromptRole';
    }
    if (data is _i7.ErrorTextResponse) {
      return 'ErrorTextResponse';
    }
    if (data is _i7.MessageTextAndNewExtractRulesResponse) {
      return 'MessageTextAndNewExtractRulesResponse';
    }
    if (data is _i7.MessageTextResponse) {
      return 'MessageTextResponse';
    }
    if (data is _i8.ReferenceTestData) {
      return 'ReferenceTestData';
    }
    if (data is _i9.Scrappable) {
      return 'Scrappable';
    }
    if (data is _i10.ScrappableTargetRequestStructure) {
      return 'ScrappableTargetRequestStructure';
    }
    if (data is _i11.ZenScrapException) {
      return 'ZenScrapException';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccountInfo') {
      return deserialize<_i4.AccountInfo>(data['data']);
    }
    if (dataClassName == 'AccountApiKey') {
      return deserialize<_i5.AccountApiKey>(data['data']);
    }
    if (dataClassName == 'PromptRole') {
      return deserialize<_i6.PromptRole>(data['data']);
    }
    if (dataClassName == 'ErrorTextResponse') {
      return deserialize<_i7.ErrorTextResponse>(data['data']);
    }
    if (dataClassName == 'MessageTextAndNewExtractRulesResponse') {
      return deserialize<_i7.MessageTextAndNewExtractRulesResponse>(
          data['data']);
    }
    if (dataClassName == 'MessageTextResponse') {
      return deserialize<_i7.MessageTextResponse>(data['data']);
    }
    if (dataClassName == 'ReferenceTestData') {
      return deserialize<_i8.ReferenceTestData>(data['data']);
    }
    if (dataClassName == 'Scrappable') {
      return deserialize<_i9.Scrappable>(data['data']);
    }
    if (dataClassName == 'ScrappableTargetRequestStructure') {
      return deserialize<_i10.ScrappableTargetRequestStructure>(data['data']);
    }
    if (dataClassName == 'ZenScrapException') {
      return deserialize<_i11.ZenScrapException>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i4.AccountInfo:
        return _i4.AccountInfo.t;
      case _i5.AccountApiKey:
        return _i5.AccountApiKey.t;
      case _i9.Scrappable:
        return _i9.Scrappable.t;
      case _i10.ScrappableTargetRequestStructure:
        return _i10.ScrappableTargetRequestStructure.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'zenscrap';
}
