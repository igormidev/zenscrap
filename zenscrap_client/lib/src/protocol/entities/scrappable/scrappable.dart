/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../entities/scrappable/scrapping_bee_extract_logic.dart' as _i2;
import '../../entities/scrappable/scrappable_request.dart' as _i3;
import '../../entities/scrappable/reference_test_data.dart' as _i4;
import '../../entities/scrappable/scrappable_analytics.dart' as _i5;
import '../../entities/scrappable/scraper_category.dart' as _i6;
import '../../entities/scrappable/auto_fix/auto_fix_config.dart' as _i7;

abstract class Scrappable implements _i1.SerializableModel {
  Scrappable._({
    this.id,
    this.accountId,
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
  });

  factory Scrappable({
    int? id,
    int? accountId,
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
  }) = _ScrappableImpl;

  factory Scrappable.fromJson(Map<String, dynamic> jsonSerialization) {
    return Scrappable(
      id: jsonSerialization['id'] as int?,
      accountId: jsonSerialization['accountId'] as int?,
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
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? accountId;

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

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Scrappable copyWith({
    int? id,
    int? accountId,
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
  });
  @override
  Map<String, dynamic> toJson() {
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
    };
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
  }) : super._(
          id: id,
          accountId: accountId,
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
        );

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Scrappable copyWith({
    Object? id = _Undefined,
    Object? accountId = _Undefined,
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
  }) {
    return Scrappable(
      id: id is int? ? id : this.id,
      accountId: accountId is int? ? accountId : this.accountId,
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
    );
  }
}
