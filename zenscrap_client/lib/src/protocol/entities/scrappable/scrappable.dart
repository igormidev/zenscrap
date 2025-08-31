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
import '../../entities/scrappable/scrappable_request.dart' as _i2;
import '../../entities/scrappable/scrappable_analytics.dart' as _i3;
import '../../entities/scrappable/reference_test_data.dart' as _i4;
import '../../entities/scrappable/scraper_category.dart' as _i5;

abstract class Scrappable implements _i1.SerializableModel {
  Scrappable._({
    _i1.UuidValue? id,
    this.accountId,
    required this.createdAt,
    required this.generalInfosUpdatedAt,
    required this.extractRulesUpdatedAt,
    required this.name,
    required this.description,
    this.testEndpointAvailableUntil,
    this.scrappingRules,
    required this.willHideFromMarketplace,
    required this.targetRequestId,
    this.targetRequest,
    required this.referenceTestDataId,
    this.scrappableAnalytics,
    this.referenceTestData,
    required this.category,
    required this.isDeleted,
  }) : id = id ?? _i1.Uuid().v4obj();

  factory Scrappable({
    _i1.UuidValue? id,
    int? accountId,
    required DateTime createdAt,
    required DateTime generalInfosUpdatedAt,
    required DateTime extractRulesUpdatedAt,
    required String name,
    required String description,
    DateTime? testEndpointAvailableUntil,
    String? scrappingRules,
    required bool willHideFromMarketplace,
    required int targetRequestId,
    _i2.ScrappableRequest? targetRequest,
    required int referenceTestDataId,
    List<_i3.ScrappableAnalytics>? scrappableAnalytics,
    _i4.ReferenceTestData? referenceTestData,
    required _i5.ScraperCategory category,
    required bool isDeleted,
  }) = _ScrappableImpl;

  factory Scrappable.fromJson(Map<String, dynamic> jsonSerialization) {
    return Scrappable(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
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
      scrappingRules: jsonSerialization['scrappingRules'] as String?,
      willHideFromMarketplace:
          jsonSerialization['willHideFromMarketplace'] as bool,
      targetRequestId: jsonSerialization['targetRequestId'] as int,
      targetRequest: jsonSerialization['targetRequest'] == null
          ? null
          : _i2.ScrappableRequest.fromJson(
              (jsonSerialization['targetRequest'] as Map<String, dynamic>)),
      referenceTestDataId: jsonSerialization['referenceTestDataId'] as int,
      scrappableAnalytics: (jsonSerialization['scrappableAnalytics'] as List?)
          ?.map((e) =>
              _i3.ScrappableAnalytics.fromJson((e as Map<String, dynamic>)))
          .toList(),
      referenceTestData: jsonSerialization['referenceTestData'] == null
          ? null
          : _i4.ReferenceTestData.fromJson(
              (jsonSerialization['referenceTestData'] as Map<String, dynamic>)),
      category:
          _i5.ScraperCategory.fromJson((jsonSerialization['category'] as int)),
      isDeleted: jsonSerialization['isDeleted'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue id;

  int? accountId;

  DateTime createdAt;

  DateTime generalInfosUpdatedAt;

  DateTime extractRulesUpdatedAt;

  String name;

  String description;

  DateTime? testEndpointAvailableUntil;

  String? scrappingRules;

  bool willHideFromMarketplace;

  int targetRequestId;

  _i2.ScrappableRequest? targetRequest;

  int referenceTestDataId;

  List<_i3.ScrappableAnalytics>? scrappableAnalytics;

  _i4.ReferenceTestData? referenceTestData;

  _i5.ScraperCategory category;

  bool isDeleted;

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Scrappable copyWith({
    _i1.UuidValue? id,
    int? accountId,
    DateTime? createdAt,
    DateTime? generalInfosUpdatedAt,
    DateTime? extractRulesUpdatedAt,
    String? name,
    String? description,
    DateTime? testEndpointAvailableUntil,
    String? scrappingRules,
    bool? willHideFromMarketplace,
    int? targetRequestId,
    _i2.ScrappableRequest? targetRequest,
    int? referenceTestDataId,
    List<_i3.ScrappableAnalytics>? scrappableAnalytics,
    _i4.ReferenceTestData? referenceTestData,
    _i5.ScraperCategory? category,
    bool? isDeleted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      if (accountId != null) 'accountId': accountId,
      'createdAt': createdAt.toJson(),
      'generalInfosUpdatedAt': generalInfosUpdatedAt.toJson(),
      'extractRulesUpdatedAt': extractRulesUpdatedAt.toJson(),
      'name': name,
      'description': description,
      if (testEndpointAvailableUntil != null)
        'testEndpointAvailableUntil': testEndpointAvailableUntil?.toJson(),
      if (scrappingRules != null) 'scrappingRules': scrappingRules,
      'willHideFromMarketplace': willHideFromMarketplace,
      'targetRequestId': targetRequestId,
      if (targetRequest != null) 'targetRequest': targetRequest?.toJson(),
      'referenceTestDataId': referenceTestDataId,
      if (scrappableAnalytics != null)
        'scrappableAnalytics':
            scrappableAnalytics?.toJson(valueToJson: (v) => v.toJson()),
      if (referenceTestData != null)
        'referenceTestData': referenceTestData?.toJson(),
      'category': category.toJson(),
      'isDeleted': isDeleted,
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
    _i1.UuidValue? id,
    int? accountId,
    required DateTime createdAt,
    required DateTime generalInfosUpdatedAt,
    required DateTime extractRulesUpdatedAt,
    required String name,
    required String description,
    DateTime? testEndpointAvailableUntil,
    String? scrappingRules,
    required bool willHideFromMarketplace,
    required int targetRequestId,
    _i2.ScrappableRequest? targetRequest,
    required int referenceTestDataId,
    List<_i3.ScrappableAnalytics>? scrappableAnalytics,
    _i4.ReferenceTestData? referenceTestData,
    required _i5.ScraperCategory category,
    required bool isDeleted,
  }) : super._(
          id: id,
          accountId: accountId,
          createdAt: createdAt,
          generalInfosUpdatedAt: generalInfosUpdatedAt,
          extractRulesUpdatedAt: extractRulesUpdatedAt,
          name: name,
          description: description,
          testEndpointAvailableUntil: testEndpointAvailableUntil,
          scrappingRules: scrappingRules,
          willHideFromMarketplace: willHideFromMarketplace,
          targetRequestId: targetRequestId,
          targetRequest: targetRequest,
          referenceTestDataId: referenceTestDataId,
          scrappableAnalytics: scrappableAnalytics,
          referenceTestData: referenceTestData,
          category: category,
          isDeleted: isDeleted,
        );

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Scrappable copyWith({
    _i1.UuidValue? id,
    Object? accountId = _Undefined,
    DateTime? createdAt,
    DateTime? generalInfosUpdatedAt,
    DateTime? extractRulesUpdatedAt,
    String? name,
    String? description,
    Object? testEndpointAvailableUntil = _Undefined,
    Object? scrappingRules = _Undefined,
    bool? willHideFromMarketplace,
    int? targetRequestId,
    Object? targetRequest = _Undefined,
    int? referenceTestDataId,
    Object? scrappableAnalytics = _Undefined,
    Object? referenceTestData = _Undefined,
    _i5.ScraperCategory? category,
    bool? isDeleted,
  }) {
    return Scrappable(
      id: id ?? this.id,
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
      scrappingRules:
          scrappingRules is String? ? scrappingRules : this.scrappingRules,
      willHideFromMarketplace:
          willHideFromMarketplace ?? this.willHideFromMarketplace,
      targetRequestId: targetRequestId ?? this.targetRequestId,
      targetRequest: targetRequest is _i2.ScrappableRequest?
          ? targetRequest
          : this.targetRequest?.copyWith(),
      referenceTestDataId: referenceTestDataId ?? this.referenceTestDataId,
      scrappableAnalytics: scrappableAnalytics is List<_i3.ScrappableAnalytics>?
          ? scrappableAnalytics
          : this.scrappableAnalytics?.map((e0) => e0.copyWith()).toList(),
      referenceTestData: referenceTestData is _i4.ReferenceTestData?
          ? referenceTestData
          : this.referenceTestData?.copyWith(),
      category: category ?? this.category,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
