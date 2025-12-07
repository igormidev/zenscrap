/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../entities/scrappable/scrapping_bee_extract_logic.dart' as _i2;
import '../../entities/scrappable/scrappable_request.dart' as _i3;
import '../../entities/scrappable/reference_test_data.dart' as _i4;
import '../../entities/scrappable/scrappable_analytics.dart' as _i5;
import '../../entities/scrappable/scraper_category.dart' as _i6;
import '../../entities/scrappable/auto_fix/auto_fix_config.dart' as _i7;
import '../../entities/scrappable/auto_fix/auto_fix_session.dart' as _i8;

abstract class Scrappable
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Scrappable._({
    this.id,
    this.accountId,
    this.apiUsageOwnerNanoId,
    required this.createdAt,
    required this.generalInfosUpdatedAt,
    required this.extractRulesUpdatedAt,
    required this.name,
    required this.description,
    this.testEndpointAvailableUntil,
    this.scrappingBeeExtractRules,
    required this.willHideFromMarketplace,
    required this.targetRequestId,
    this.targetRequest,
    required this.referenceTestDataId,
    this.referenceTestData,
    this.scrappableAnalytics,
    required this.category,
    required this.isDeleted,
    this.autoFixConfig,
    this.autoFixSessions,
  });

  factory Scrappable({
    int? id,
    int? accountId,
    String? apiUsageOwnerNanoId,
    required DateTime createdAt,
    required DateTime generalInfosUpdatedAt,
    required DateTime extractRulesUpdatedAt,
    required String name,
    required String description,
    DateTime? testEndpointAvailableUntil,
    _i2.ScrappingBeeExtractLogic? scrappingBeeExtractRules,
    required bool willHideFromMarketplace,
    required int targetRequestId,
    _i3.ScrappableRequest? targetRequest,
    required int referenceTestDataId,
    _i4.ReferenceTestData? referenceTestData,
    List<_i5.ScrappableAnalytics>? scrappableAnalytics,
    required _i6.ScraperCategory category,
    required bool isDeleted,
    _i7.AutoFixConfig? autoFixConfig,
    List<_i8.AutoFixSession>? autoFixSessions,
  }) = _ScrappableImpl;

  factory Scrappable.fromJson(Map<String, dynamic> jsonSerialization) {
    return Scrappable(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int?,
      apiUsageOwnerNanoId: jsonSerialization['apiUsageOwnerNanoId'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      generalInfosUpdatedAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['generalInfosUpdatedAt']),
      extractRulesUpdatedAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['extractRulesUpdatedAt']),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      testEndpointAvailableUntil:
          jsonSerialization['testEndpointAvailableUntil'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['testEndpointAvailableUntil']),
      scrappingBeeExtractRules:
          jsonSerialization['scrappingBeeExtractRules'] == null
              ? null
              : _i2.ScrappingBeeExtractLogic.fromJson(
                  (jsonSerialization['scrappingBeeExtractRules']
                      as Map<String, dynamic>)),
      willHideFromMarketplace:
          jsonSerialization['willHideFromMarketplace'] as bool,
      targetRequestId: jsonSerialization['targetRequestId'] as int,
      targetRequest: jsonSerialization['targetRequest'] == null
          ? null
          : _i3.ScrappableRequest.fromJson(
              (jsonSerialization['targetRequest'] as Map<String, dynamic>)),
      referenceTestDataId: jsonSerialization['referenceTestDataId'] as int,
      referenceTestData: jsonSerialization['referenceTestData'] == null
          ? null
          : _i4.ReferenceTestData.fromJson(
              (jsonSerialization['referenceTestData'] as Map<String, dynamic>)),
      scrappableAnalytics: (jsonSerialization['scrappableAnalytics'] as List?)
          ?.map((e) =>
              _i5.ScrappableAnalytics.fromJson((e as Map<String, dynamic>)))
          .toList(),
      category:
          _i6.ScraperCategory.fromJson((jsonSerialization['category'] as int)),
      isDeleted: jsonSerialization['isDeleted'] as bool,
      autoFixConfig: jsonSerialization['autoFixConfig'] == null
          ? null
          : _i7.AutoFixConfig.fromJson(
              (jsonSerialization['autoFixConfig'] as Map<String, dynamic>)),
      autoFixSessions: (jsonSerialization['autoFixSessions'] as List?)
          ?.map((e) => _i8.AutoFixSession.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = ScrappableTable();

  static const db = ScrappableRepository._();

  @override
  int? id;

  int? accountId;

  String? apiUsageOwnerNanoId;

  DateTime createdAt;

  DateTime generalInfosUpdatedAt;

  DateTime extractRulesUpdatedAt;

  String name;

  String description;

  DateTime? testEndpointAvailableUntil;

  _i2.ScrappingBeeExtractLogic? scrappingBeeExtractRules;

  bool willHideFromMarketplace;

  int targetRequestId;

  _i3.ScrappableRequest? targetRequest;

  int referenceTestDataId;

  _i4.ReferenceTestData? referenceTestData;

  List<_i5.ScrappableAnalytics>? scrappableAnalytics;

  _i6.ScraperCategory category;

  bool isDeleted;

  _i7.AutoFixConfig? autoFixConfig;

  List<_i8.AutoFixSession>? autoFixSessions;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Scrappable copyWith({
    int? id,
    int? accountId,
    String? apiUsageOwnerNanoId,
    DateTime? createdAt,
    DateTime? generalInfosUpdatedAt,
    DateTime? extractRulesUpdatedAt,
    String? name,
    String? description,
    DateTime? testEndpointAvailableUntil,
    _i2.ScrappingBeeExtractLogic? scrappingBeeExtractRules,
    bool? willHideFromMarketplace,
    int? targetRequestId,
    _i3.ScrappableRequest? targetRequest,
    int? referenceTestDataId,
    _i4.ReferenceTestData? referenceTestData,
    List<_i5.ScrappableAnalytics>? scrappableAnalytics,
    _i6.ScraperCategory? category,
    bool? isDeleted,
    _i7.AutoFixConfig? autoFixConfig,
    List<_i8.AutoFixSession>? autoFixSessions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (accountId != null) 'accountId': accountId,
      if (apiUsageOwnerNanoId != null)
        'apiUsageOwnerNanoId': apiUsageOwnerNanoId,
      'createdAt': createdAt.toJson(),
      'generalInfosUpdatedAt': generalInfosUpdatedAt.toJson(),
      'extractRulesUpdatedAt': extractRulesUpdatedAt.toJson(),
      'name': name,
      'description': description,
      if (testEndpointAvailableUntil != null)
        'testEndpointAvailableUntil': testEndpointAvailableUntil?.toJson(),
      if (scrappingBeeExtractRules != null)
        'scrappingBeeExtractRules': scrappingBeeExtractRules?.toJson(),
      'willHideFromMarketplace': willHideFromMarketplace,
      'targetRequestId': targetRequestId,
      if (targetRequest != null) 'targetRequest': targetRequest?.toJson(),
      'referenceTestDataId': referenceTestDataId,
      if (referenceTestData != null)
        'referenceTestData': referenceTestData?.toJson(),
      if (scrappableAnalytics != null)
        'scrappableAnalytics':
            scrappableAnalytics?.toJson(valueToJson: (v) => v.toJson()),
      'category': category.toJson(),
      'isDeleted': isDeleted,
      if (autoFixConfig != null) 'autoFixConfig': autoFixConfig?.toJson(),
      if (autoFixSessions != null)
        'autoFixSessions':
            autoFixSessions?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (accountId != null) 'accountId': accountId,
      'createdAt': createdAt.toJson(),
      'generalInfosUpdatedAt': generalInfosUpdatedAt.toJson(),
      'extractRulesUpdatedAt': extractRulesUpdatedAt.toJson(),
      'name': name,
      'description': description,
      if (testEndpointAvailableUntil != null)
        'testEndpointAvailableUntil': testEndpointAvailableUntil?.toJson(),
      if (scrappingBeeExtractRules != null)
        'scrappingBeeExtractRules':
            scrappingBeeExtractRules?.toJsonForProtocol(),
      'willHideFromMarketplace': willHideFromMarketplace,
      'targetRequestId': targetRequestId,
      if (targetRequest != null)
        'targetRequest': targetRequest?.toJsonForProtocol(),
      'referenceTestDataId': referenceTestDataId,
      if (referenceTestData != null)
        'referenceTestData': referenceTestData?.toJsonForProtocol(),
      if (scrappableAnalytics != null)
        'scrappableAnalytics': scrappableAnalytics?.toJson(
            valueToJson: (v) => v.toJsonForProtocol()),
      'category': category.toJson(),
      'isDeleted': isDeleted,
      if (autoFixConfig != null)
        'autoFixConfig': autoFixConfig?.toJsonForProtocol(),
      if (autoFixSessions != null)
        'autoFixSessions':
            autoFixSessions?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static ScrappableInclude include({
    _i2.ScrappingBeeExtractLogicInclude? scrappingBeeExtractRules,
    _i3.ScrappableRequestInclude? targetRequest,
    _i4.ReferenceTestDataInclude? referenceTestData,
    _i5.ScrappableAnalyticsIncludeList? scrappableAnalytics,
    _i7.AutoFixConfigInclude? autoFixConfig,
    _i8.AutoFixSessionIncludeList? autoFixSessions,
  }) {
    return ScrappableInclude._(
      scrappingBeeExtractRules: scrappingBeeExtractRules,
      targetRequest: targetRequest,
      referenceTestData: referenceTestData,
      scrappableAnalytics: scrappableAnalytics,
      autoFixConfig: autoFixConfig,
      autoFixSessions: autoFixSessions,
    );
  }

  static ScrappableIncludeList includeList({
    _i1.WhereExpressionBuilder<ScrappableTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTable>? orderByList,
    ScrappableInclude? include,
  }) {
    return ScrappableIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Scrappable.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Scrappable.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableImpl extends Scrappable {
  _ScrappableImpl({
    int? id,
    int? accountId,
    String? apiUsageOwnerNanoId,
    required DateTime createdAt,
    required DateTime generalInfosUpdatedAt,
    required DateTime extractRulesUpdatedAt,
    required String name,
    required String description,
    DateTime? testEndpointAvailableUntil,
    _i2.ScrappingBeeExtractLogic? scrappingBeeExtractRules,
    required bool willHideFromMarketplace,
    required int targetRequestId,
    _i3.ScrappableRequest? targetRequest,
    required int referenceTestDataId,
    _i4.ReferenceTestData? referenceTestData,
    List<_i5.ScrappableAnalytics>? scrappableAnalytics,
    required _i6.ScraperCategory category,
    required bool isDeleted,
    _i7.AutoFixConfig? autoFixConfig,
    List<_i8.AutoFixSession>? autoFixSessions,
  }) : super._(
          id: id,
          accountId: accountId,
          apiUsageOwnerNanoId: apiUsageOwnerNanoId,
          createdAt: createdAt,
          generalInfosUpdatedAt: generalInfosUpdatedAt,
          extractRulesUpdatedAt: extractRulesUpdatedAt,
          name: name,
          description: description,
          testEndpointAvailableUntil: testEndpointAvailableUntil,
          scrappingBeeExtractRules: scrappingBeeExtractRules,
          willHideFromMarketplace: willHideFromMarketplace,
          targetRequestId: targetRequestId,
          targetRequest: targetRequest,
          referenceTestDataId: referenceTestDataId,
          referenceTestData: referenceTestData,
          scrappableAnalytics: scrappableAnalytics,
          category: category,
          isDeleted: isDeleted,
          autoFixConfig: autoFixConfig,
          autoFixSessions: autoFixSessions,
        );

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Scrappable copyWith({
    Object? id = _Undefined,
    Object? accountId = _Undefined,
    Object? apiUsageOwnerNanoId = _Undefined,
    DateTime? createdAt,
    DateTime? generalInfosUpdatedAt,
    DateTime? extractRulesUpdatedAt,
    String? name,
    String? description,
    Object? testEndpointAvailableUntil = _Undefined,
    Object? scrappingBeeExtractRules = _Undefined,
    bool? willHideFromMarketplace,
    int? targetRequestId,
    Object? targetRequest = _Undefined,
    int? referenceTestDataId,
    Object? referenceTestData = _Undefined,
    Object? scrappableAnalytics = _Undefined,
    _i6.ScraperCategory? category,
    bool? isDeleted,
    Object? autoFixConfig = _Undefined,
    Object? autoFixSessions = _Undefined,
  }) {
    return Scrappable(
      id: id is int? ? id : this.id,
      accountId: accountId is int? ? accountId : this.accountId,
      apiUsageOwnerNanoId: apiUsageOwnerNanoId is String?
          ? apiUsageOwnerNanoId
          : this.apiUsageOwnerNanoId,
      createdAt: createdAt ?? this.createdAt,
      generalInfosUpdatedAt:
          generalInfosUpdatedAt ?? this.generalInfosUpdatedAt,
      extractRulesUpdatedAt:
          extractRulesUpdatedAt ?? this.extractRulesUpdatedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      testEndpointAvailableUntil: testEndpointAvailableUntil is DateTime?
          ? testEndpointAvailableUntil
          : this.testEndpointAvailableUntil,
      scrappingBeeExtractRules:
          scrappingBeeExtractRules is _i2.ScrappingBeeExtractLogic?
              ? scrappingBeeExtractRules
              : this.scrappingBeeExtractRules?.copyWith(),
      willHideFromMarketplace:
          willHideFromMarketplace ?? this.willHideFromMarketplace,
      targetRequestId: targetRequestId ?? this.targetRequestId,
      targetRequest: targetRequest is _i3.ScrappableRequest?
          ? targetRequest
          : this.targetRequest?.copyWith(),
      referenceTestDataId: referenceTestDataId ?? this.referenceTestDataId,
      referenceTestData: referenceTestData is _i4.ReferenceTestData?
          ? referenceTestData
          : this.referenceTestData?.copyWith(),
      scrappableAnalytics: scrappableAnalytics is List<_i5.ScrappableAnalytics>?
          ? scrappableAnalytics
          : this.scrappableAnalytics?.map((e0) => e0.copyWith()).toList(),
      category: category ?? this.category,
      isDeleted: isDeleted ?? this.isDeleted,
      autoFixConfig: autoFixConfig is _i7.AutoFixConfig?
          ? autoFixConfig
          : this.autoFixConfig?.copyWith(),
      autoFixSessions: autoFixSessions is List<_i8.AutoFixSession>?
          ? autoFixSessions
          : this.autoFixSessions?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ScrappableTable extends _i1.Table<int?> {
  ScrappableTable({super.tableRelation}) : super(tableName: 'scrappable') {
    accountId = _i1.ColumnInt(
      'accountId',
      this,
    );
    apiUsageOwnerNanoId = _i1.ColumnString(
      'apiUsageOwnerNanoId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    generalInfosUpdatedAt = _i1.ColumnDateTime(
      'generalInfosUpdatedAt',
      this,
    );
    extractRulesUpdatedAt = _i1.ColumnDateTime(
      'extractRulesUpdatedAt',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    testEndpointAvailableUntil = _i1.ColumnDateTime(
      'testEndpointAvailableUntil',
      this,
    );
    willHideFromMarketplace = _i1.ColumnBool(
      'willHideFromMarketplace',
      this,
    );
    targetRequestId = _i1.ColumnInt(
      'targetRequestId',
      this,
    );
    referenceTestDataId = _i1.ColumnInt(
      'referenceTestDataId',
      this,
    );
    category = _i1.ColumnEnum(
      'category',
      this,
      _i1.EnumSerialization.byIndex,
    );
    isDeleted = _i1.ColumnBool(
      'isDeleted',
      this,
    );
  }

  late final _i1.ColumnInt accountId;

  late final _i1.ColumnString apiUsageOwnerNanoId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime generalInfosUpdatedAt;

  late final _i1.ColumnDateTime extractRulesUpdatedAt;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnDateTime testEndpointAvailableUntil;

  _i2.ScrappingBeeExtractLogicTable? _scrappingBeeExtractRules;

  late final _i1.ColumnBool willHideFromMarketplace;

  late final _i1.ColumnInt targetRequestId;

  _i3.ScrappableRequestTable? _targetRequest;

  late final _i1.ColumnInt referenceTestDataId;

  _i4.ReferenceTestDataTable? _referenceTestData;

  _i5.ScrappableAnalyticsTable? ___scrappableAnalytics;

  _i1.ManyRelation<_i5.ScrappableAnalyticsTable>? _scrappableAnalytics;

  late final _i1.ColumnEnum<_i6.ScraperCategory> category;

  late final _i1.ColumnBool isDeleted;

  _i7.AutoFixConfigTable? _autoFixConfig;

  _i8.AutoFixSessionTable? ___autoFixSessions;

  _i1.ManyRelation<_i8.AutoFixSessionTable>? _autoFixSessions;

  _i2.ScrappingBeeExtractLogicTable get scrappingBeeExtractRules {
    if (_scrappingBeeExtractRules != null) return _scrappingBeeExtractRules!;
    _scrappingBeeExtractRules = _i1.createRelationTable(
      relationFieldName: 'scrappingBeeExtractRules',
      field: Scrappable.t.id,
      foreignField: _i2.ScrappingBeeExtractLogic.t.scrappableId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i2.ScrappingBeeExtractLogicTable(
          tableRelation: foreignTableRelation),
    );
    return _scrappingBeeExtractRules!;
  }

  _i3.ScrappableRequestTable get targetRequest {
    if (_targetRequest != null) return _targetRequest!;
    _targetRequest = _i1.createRelationTable(
      relationFieldName: 'targetRequest',
      field: Scrappable.t.targetRequestId,
      foreignField: _i3.ScrappableRequest.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ScrappableRequestTable(tableRelation: foreignTableRelation),
    );
    return _targetRequest!;
  }

  _i4.ReferenceTestDataTable get referenceTestData {
    if (_referenceTestData != null) return _referenceTestData!;
    _referenceTestData = _i1.createRelationTable(
      relationFieldName: 'referenceTestData',
      field: Scrappable.t.referenceTestDataId,
      foreignField: _i4.ReferenceTestData.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.ReferenceTestDataTable(tableRelation: foreignTableRelation),
    );
    return _referenceTestData!;
  }

  _i5.ScrappableAnalyticsTable get __scrappableAnalytics {
    if (___scrappableAnalytics != null) return ___scrappableAnalytics!;
    ___scrappableAnalytics = _i1.createRelationTable(
      relationFieldName: '__scrappableAnalytics',
      field: Scrappable.t.id,
      foreignField: _i5.ScrappableAnalytics.t.scrappableId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.ScrappableAnalyticsTable(tableRelation: foreignTableRelation),
    );
    return ___scrappableAnalytics!;
  }

  _i7.AutoFixConfigTable get autoFixConfig {
    if (_autoFixConfig != null) return _autoFixConfig!;
    _autoFixConfig = _i1.createRelationTable(
      relationFieldName: 'autoFixConfig',
      field: Scrappable.t.id,
      foreignField: _i7.AutoFixConfig.t.scrappableId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7.AutoFixConfigTable(tableRelation: foreignTableRelation),
    );
    return _autoFixConfig!;
  }

  _i8.AutoFixSessionTable get __autoFixSessions {
    if (___autoFixSessions != null) return ___autoFixSessions!;
    ___autoFixSessions = _i1.createRelationTable(
      relationFieldName: '__autoFixSessions',
      field: Scrappable.t.id,
      foreignField: _i8.AutoFixSession.t.scrappableId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i8.AutoFixSessionTable(tableRelation: foreignTableRelation),
    );
    return ___autoFixSessions!;
  }

  _i1.ManyRelation<_i5.ScrappableAnalyticsTable> get scrappableAnalytics {
    if (_scrappableAnalytics != null) return _scrappableAnalytics!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'scrappableAnalytics',
      field: Scrappable.t.id,
      foreignField: _i5.ScrappableAnalytics.t.scrappableId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.ScrappableAnalyticsTable(tableRelation: foreignTableRelation),
    );
    _scrappableAnalytics = _i1.ManyRelation<_i5.ScrappableAnalyticsTable>(
      tableWithRelations: relationTable,
      table: _i5.ScrappableAnalyticsTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _scrappableAnalytics!;
  }

  _i1.ManyRelation<_i8.AutoFixSessionTable> get autoFixSessions {
    if (_autoFixSessions != null) return _autoFixSessions!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'autoFixSessions',
      field: Scrappable.t.id,
      foreignField: _i8.AutoFixSession.t.scrappableId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i8.AutoFixSessionTable(tableRelation: foreignTableRelation),
    );
    _autoFixSessions = _i1.ManyRelation<_i8.AutoFixSessionTable>(
      tableWithRelations: relationTable,
      table: _i8.AutoFixSessionTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _autoFixSessions!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        accountId,
        apiUsageOwnerNanoId,
        createdAt,
        generalInfosUpdatedAt,
        extractRulesUpdatedAt,
        name,
        description,
        testEndpointAvailableUntil,
        willHideFromMarketplace,
        targetRequestId,
        referenceTestDataId,
        category,
        isDeleted,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'scrappingBeeExtractRules') {
      return scrappingBeeExtractRules;
    }
    if (relationField == 'targetRequest') {
      return targetRequest;
    }
    if (relationField == 'referenceTestData') {
      return referenceTestData;
    }
    if (relationField == 'scrappableAnalytics') {
      return __scrappableAnalytics;
    }
    if (relationField == 'autoFixConfig') {
      return autoFixConfig;
    }
    if (relationField == 'autoFixSessions') {
      return __autoFixSessions;
    }
    return null;
  }
}

class ScrappableInclude extends _i1.IncludeObject {
  ScrappableInclude._({
    _i2.ScrappingBeeExtractLogicInclude? scrappingBeeExtractRules,
    _i3.ScrappableRequestInclude? targetRequest,
    _i4.ReferenceTestDataInclude? referenceTestData,
    _i5.ScrappableAnalyticsIncludeList? scrappableAnalytics,
    _i7.AutoFixConfigInclude? autoFixConfig,
    _i8.AutoFixSessionIncludeList? autoFixSessions,
  }) {
    _scrappingBeeExtractRules = scrappingBeeExtractRules;
    _targetRequest = targetRequest;
    _referenceTestData = referenceTestData;
    _scrappableAnalytics = scrappableAnalytics;
    _autoFixConfig = autoFixConfig;
    _autoFixSessions = autoFixSessions;
  }

  _i2.ScrappingBeeExtractLogicInclude? _scrappingBeeExtractRules;

  _i3.ScrappableRequestInclude? _targetRequest;

  _i4.ReferenceTestDataInclude? _referenceTestData;

  _i5.ScrappableAnalyticsIncludeList? _scrappableAnalytics;

  _i7.AutoFixConfigInclude? _autoFixConfig;

  _i8.AutoFixSessionIncludeList? _autoFixSessions;

  @override
  Map<String, _i1.Include?> get includes => {
        'scrappingBeeExtractRules': _scrappingBeeExtractRules,
        'targetRequest': _targetRequest,
        'referenceTestData': _referenceTestData,
        'scrappableAnalytics': _scrappableAnalytics,
        'autoFixConfig': _autoFixConfig,
        'autoFixSessions': _autoFixSessions,
      };

  @override
  _i1.Table<int?> get table => Scrappable.t;
}

class ScrappableIncludeList extends _i1.IncludeList {
  ScrappableIncludeList._({
    _i1.WhereExpressionBuilder<ScrappableTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Scrappable.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Scrappable.t;
}

class ScrappableRepository {
  const ScrappableRepository._();

  final attach = const ScrappableAttachRepository._();

  final attachRow = const ScrappableAttachRowRepository._();

  final detach = const ScrappableDetachRepository._();

  final detachRow = const ScrappableDetachRowRepository._();

  /// Returns a list of [Scrappable]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Scrappable>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableInclude? include,
  }) async {
    return session.db.find<Scrappable>(
      where: where?.call(Scrappable.t),
      orderBy: orderBy?.call(Scrappable.t),
      orderByList: orderByList?.call(Scrappable.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Scrappable] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Scrappable?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScrappableTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableInclude? include,
  }) async {
    return session.db.findFirstRow<Scrappable>(
      where: where?.call(Scrappable.t),
      orderBy: orderBy?.call(Scrappable.t),
      orderByList: orderByList?.call(Scrappable.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Scrappable] by its [id] or null if no such row exists.
  Future<Scrappable?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ScrappableInclude? include,
  }) async {
    return session.db.findById<Scrappable>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Scrappable]s in the list and returns the inserted rows.
  ///
  /// The returned [Scrappable]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Scrappable>> insert(
    _i1.Session session,
    List<Scrappable> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Scrappable>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Scrappable] and returns the inserted row.
  ///
  /// The returned [Scrappable] will have its `id` field set.
  Future<Scrappable> insertRow(
    _i1.Session session,
    Scrappable row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Scrappable>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Scrappable]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Scrappable>> update(
    _i1.Session session,
    List<Scrappable> rows, {
    _i1.ColumnSelections<ScrappableTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Scrappable>(
      rows,
      columns: columns?.call(Scrappable.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Scrappable]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Scrappable> updateRow(
    _i1.Session session,
    Scrappable row, {
    _i1.ColumnSelections<ScrappableTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Scrappable>(
      row,
      columns: columns?.call(Scrappable.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Scrappable]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Scrappable>> delete(
    _i1.Session session,
    List<Scrappable> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Scrappable>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Scrappable].
  Future<Scrappable> deleteRow(
    _i1.Session session,
    Scrappable row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Scrappable>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Scrappable>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScrappableTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Scrappable>(
      where: where(Scrappable.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Scrappable>(
      where: where?.call(Scrappable.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ScrappableAttachRepository {
  const ScrappableAttachRepository._();

  /// Creates a relation between this [Scrappable] and the given [ScrappableAnalytics]s
  /// by setting each [ScrappableAnalytics]'s foreign key `scrappableId` to refer to this [Scrappable].
  Future<void> scrappableAnalytics(
    _i1.Session session,
    Scrappable scrappable,
    List<_i5.ScrappableAnalytics> scrappableAnalytics, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappableAnalytics.any((e) => e.id == null)) {
      throw ArgumentError.notNull('scrappableAnalytics.id');
    }
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $scrappableAnalytics = scrappableAnalytics
        .map((e) => e.copyWith(scrappableId: scrappable.id))
        .toList();
    await session.db.update<_i5.ScrappableAnalytics>(
      $scrappableAnalytics,
      columns: [_i5.ScrappableAnalytics.t.scrappableId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Scrappable] and the given [AutoFixSession]s
  /// by setting each [AutoFixSession]'s foreign key `scrappableId` to refer to this [Scrappable].
  Future<void> autoFixSessions(
    _i1.Session session,
    Scrappable scrappable,
    List<_i8.AutoFixSession> autoFixSession, {
    _i1.Transaction? transaction,
  }) async {
    if (autoFixSession.any((e) => e.id == null)) {
      throw ArgumentError.notNull('autoFixSession.id');
    }
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $autoFixSession = autoFixSession
        .map((e) => e.copyWith(scrappableId: scrappable.id))
        .toList();
    await session.db.update<_i8.AutoFixSession>(
      $autoFixSession,
      columns: [_i8.AutoFixSession.t.scrappableId],
      transaction: transaction,
    );
  }
}

class ScrappableAttachRowRepository {
  const ScrappableAttachRowRepository._();

  /// Creates a relation between the given [Scrappable] and [ScrappingBeeExtractLogic]
  /// by setting the [Scrappable]'s foreign key `id` to refer to the [ScrappingBeeExtractLogic].
  Future<void> scrappingBeeExtractRules(
    _i1.Session session,
    Scrappable scrappable,
    _i2.ScrappingBeeExtractLogic scrappingBeeExtractRules, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappingBeeExtractRules.id == null) {
      throw ArgumentError.notNull('scrappingBeeExtractRules.id');
    }
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $scrappingBeeExtractRules =
        scrappingBeeExtractRules.copyWith(scrappableId: scrappable.id);
    await session.db.updateRow<_i2.ScrappingBeeExtractLogic>(
      $scrappingBeeExtractRules,
      columns: [_i2.ScrappingBeeExtractLogic.t.scrappableId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Scrappable] and [ScrappableRequest]
  /// by setting the [Scrappable]'s foreign key `targetRequestId` to refer to the [ScrappableRequest].
  Future<void> targetRequest(
    _i1.Session session,
    Scrappable scrappable,
    _i3.ScrappableRequest targetRequest, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }
    if (targetRequest.id == null) {
      throw ArgumentError.notNull('targetRequest.id');
    }

    var $scrappable = scrappable.copyWith(targetRequestId: targetRequest.id);
    await session.db.updateRow<Scrappable>(
      $scrappable,
      columns: [Scrappable.t.targetRequestId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Scrappable] and [ReferenceTestData]
  /// by setting the [Scrappable]'s foreign key `referenceTestDataId` to refer to the [ReferenceTestData].
  Future<void> referenceTestData(
    _i1.Session session,
    Scrappable scrappable,
    _i4.ReferenceTestData referenceTestData, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }
    if (referenceTestData.id == null) {
      throw ArgumentError.notNull('referenceTestData.id');
    }

    var $scrappable =
        scrappable.copyWith(referenceTestDataId: referenceTestData.id);
    await session.db.updateRow<Scrappable>(
      $scrappable,
      columns: [Scrappable.t.referenceTestDataId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Scrappable] and [AutoFixConfig]
  /// by setting the [Scrappable]'s foreign key `id` to refer to the [AutoFixConfig].
  Future<void> autoFixConfig(
    _i1.Session session,
    Scrappable scrappable,
    _i7.AutoFixConfig autoFixConfig, {
    _i1.Transaction? transaction,
  }) async {
    if (autoFixConfig.id == null) {
      throw ArgumentError.notNull('autoFixConfig.id');
    }
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $autoFixConfig = autoFixConfig.copyWith(scrappableId: scrappable.id);
    await session.db.updateRow<_i7.AutoFixConfig>(
      $autoFixConfig,
      columns: [_i7.AutoFixConfig.t.scrappableId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Scrappable] and the given [ScrappableAnalytics]
  /// by setting the [ScrappableAnalytics]'s foreign key `scrappableId` to refer to this [Scrappable].
  Future<void> scrappableAnalytics(
    _i1.Session session,
    Scrappable scrappable,
    _i5.ScrappableAnalytics scrappableAnalytics, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappableAnalytics.id == null) {
      throw ArgumentError.notNull('scrappableAnalytics.id');
    }
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $scrappableAnalytics =
        scrappableAnalytics.copyWith(scrappableId: scrappable.id);
    await session.db.updateRow<_i5.ScrappableAnalytics>(
      $scrappableAnalytics,
      columns: [_i5.ScrappableAnalytics.t.scrappableId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Scrappable] and the given [AutoFixSession]
  /// by setting the [AutoFixSession]'s foreign key `scrappableId` to refer to this [Scrappable].
  Future<void> autoFixSessions(
    _i1.Session session,
    Scrappable scrappable,
    _i8.AutoFixSession autoFixSession, {
    _i1.Transaction? transaction,
  }) async {
    if (autoFixSession.id == null) {
      throw ArgumentError.notNull('autoFixSession.id');
    }
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $autoFixSession = autoFixSession.copyWith(scrappableId: scrappable.id);
    await session.db.updateRow<_i8.AutoFixSession>(
      $autoFixSession,
      columns: [_i8.AutoFixSession.t.scrappableId],
      transaction: transaction,
    );
  }
}

class ScrappableDetachRepository {
  const ScrappableDetachRepository._();

  /// Detaches the relation between this [Scrappable] and the given [ScrappableAnalytics]
  /// by setting the [ScrappableAnalytics]'s foreign key `scrappableId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> scrappableAnalytics(
    _i1.Session session,
    List<_i5.ScrappableAnalytics> scrappableAnalytics, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappableAnalytics.any((e) => e.id == null)) {
      throw ArgumentError.notNull('scrappableAnalytics.id');
    }

    var $scrappableAnalytics =
        scrappableAnalytics.map((e) => e.copyWith(scrappableId: null)).toList();
    await session.db.update<_i5.ScrappableAnalytics>(
      $scrappableAnalytics,
      columns: [_i5.ScrappableAnalytics.t.scrappableId],
      transaction: transaction,
    );
  }
}

class ScrappableDetachRowRepository {
  const ScrappableDetachRowRepository._();

  /// Detaches the relation between this [Scrappable] and the [ScrappingBeeExtractLogic] set in `scrappingBeeExtractRules`
  /// by setting the [Scrappable]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> scrappingBeeExtractRules(
    _i1.Session session,
    Scrappable scrappable, {
    _i1.Transaction? transaction,
  }) async {
    var $scrappingBeeExtractRules = scrappable.scrappingBeeExtractRules;

    if ($scrappingBeeExtractRules == null) {
      throw ArgumentError.notNull('scrappable.scrappingBeeExtractRules');
    }
    if ($scrappingBeeExtractRules.id == null) {
      throw ArgumentError.notNull('scrappable.scrappingBeeExtractRules.id');
    }
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $$scrappingBeeExtractRules =
        $scrappingBeeExtractRules.copyWith(scrappableId: null);
    await session.db.updateRow<_i2.ScrappingBeeExtractLogic>(
      $$scrappingBeeExtractRules,
      columns: [_i2.ScrappingBeeExtractLogic.t.scrappableId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Scrappable] and the given [ScrappableAnalytics]
  /// by setting the [ScrappableAnalytics]'s foreign key `scrappableId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> scrappableAnalytics(
    _i1.Session session,
    _i5.ScrappableAnalytics scrappableAnalytics, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappableAnalytics.id == null) {
      throw ArgumentError.notNull('scrappableAnalytics.id');
    }

    var $scrappableAnalytics = scrappableAnalytics.copyWith(scrappableId: null);
    await session.db.updateRow<_i5.ScrappableAnalytics>(
      $scrappableAnalytics,
      columns: [_i5.ScrappableAnalytics.t.scrappableId],
      transaction: transaction,
    );
  }
}
