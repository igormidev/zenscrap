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
import '../../entities/scrappable/reference_test_data.dart' as _i3;

abstract class Scrappable implements _i1.SerializableModel {
  Scrappable._({
    _i1.UuidValue? id,
    this.account,
    required this.createdAt,
    required this.name,
    required this.description,
    this.scrappingRules,
    required this.isActive,
    required this.targetRequestId,
    this.targetRequest,
    required this.referenceTestDataId,
    this.referenceTestData,
  }) : id = id ?? _i1.Uuid().v4obj();

  factory Scrappable({
    _i1.UuidValue? id,
    int? account,
    required DateTime createdAt,
    required String name,
    required String description,
    String? scrappingRules,
    required bool isActive,
    required int targetRequestId,
    _i2.ScrappableRequest? targetRequest,
    required int referenceTestDataId,
    _i3.ReferenceTestData? referenceTestData,
  }) = _ScrappableImpl;

  factory Scrappable.fromJson(Map<String, dynamic> jsonSerialization) {
    return Scrappable(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      account: jsonSerialization['account'] as int?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      scrappingRules: jsonSerialization['scrappingRules'] as String?,
      isActive: jsonSerialization['isActive'] as bool,
      targetRequestId: jsonSerialization['targetRequestId'] as int,
      targetRequest: jsonSerialization['targetRequest'] == null
          ? null
          : _i2.ScrappableRequest.fromJson(
              (jsonSerialization['targetRequest'] as Map<String, dynamic>)),
      referenceTestDataId: jsonSerialization['referenceTestDataId'] as int,
      referenceTestData: jsonSerialization['referenceTestData'] == null
          ? null
          : _i3.ReferenceTestData.fromJson(
              (jsonSerialization['referenceTestData'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue id;

  int? account;

  DateTime createdAt;

  String name;

  String description;

  String? scrappingRules;

  bool isActive;

  int targetRequestId;

  _i2.ScrappableRequest? targetRequest;

  int referenceTestDataId;

  _i3.ReferenceTestData? referenceTestData;

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Scrappable copyWith({
    _i1.UuidValue? id,
    int? account,
    DateTime? createdAt,
    String? name,
    String? description,
    String? scrappingRules,
    bool? isActive,
    int? targetRequestId,
    _i2.ScrappableRequest? targetRequest,
    int? referenceTestDataId,
    _i3.ReferenceTestData? referenceTestData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      if (account != null) 'account': account,
      'createdAt': createdAt.toJson(),
      'name': name,
      'description': description,
      if (scrappingRules != null) 'scrappingRules': scrappingRules,
      'isActive': isActive,
      'targetRequestId': targetRequestId,
      if (targetRequest != null) 'targetRequest': targetRequest?.toJson(),
      'referenceTestDataId': referenceTestDataId,
      if (referenceTestData != null)
        'referenceTestData': referenceTestData?.toJson(),
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
    int? account,
    required DateTime createdAt,
    required String name,
    required String description,
    String? scrappingRules,
    required bool isActive,
    required int targetRequestId,
    _i2.ScrappableRequest? targetRequest,
    required int referenceTestDataId,
    _i3.ReferenceTestData? referenceTestData,
  }) : super._(
          id: id,
          account: account,
          createdAt: createdAt,
          name: name,
          description: description,
          scrappingRules: scrappingRules,
          isActive: isActive,
          targetRequestId: targetRequestId,
          targetRequest: targetRequest,
          referenceTestDataId: referenceTestDataId,
          referenceTestData: referenceTestData,
        );

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Scrappable copyWith({
    _i1.UuidValue? id,
    Object? account = _Undefined,
    DateTime? createdAt,
    String? name,
    String? description,
    Object? scrappingRules = _Undefined,
    bool? isActive,
    int? targetRequestId,
    Object? targetRequest = _Undefined,
    int? referenceTestDataId,
    Object? referenceTestData = _Undefined,
  }) {
    return Scrappable(
      id: id ?? this.id,
      account: account is int? ? account : this.account,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      description: description ?? this.description,
      scrappingRules:
          scrappingRules is String? ? scrappingRules : this.scrappingRules,
      isActive: isActive ?? this.isActive,
      targetRequestId: targetRequestId ?? this.targetRequestId,
      targetRequest: targetRequest is _i2.ScrappableRequest?
          ? targetRequest
          : this.targetRequest?.copyWith(),
      referenceTestDataId: referenceTestDataId ?? this.referenceTestDataId,
      referenceTestData: referenceTestData is _i3.ReferenceTestData?
          ? referenceTestData
          : this.referenceTestData?.copyWith(),
    );
  }
}
