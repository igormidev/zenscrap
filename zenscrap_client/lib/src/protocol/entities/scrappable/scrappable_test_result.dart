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
import '../../entities/scrappable/reference_test_data.dart' as _i2;

abstract class ScrappableTestResult implements _i1.SerializableModel {
  ScrappableTestResult._({
    this.id,
    required this.testExtractRule,
    required this.extractJsonResult,
    required this.scrappableId,
    this.referenceTestDataId,
    this.referenceTestData,
  });

  factory ScrappableTestResult({
    int? id,
    required String testExtractRule,
    required String extractJsonResult,
    required int scrappableId,
    int? referenceTestDataId,
    _i2.ReferenceTestData? referenceTestData,
  }) = _ScrappableTestResultImpl;

  factory ScrappableTestResult.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ScrappableTestResult(
      id: jsonSerialization['id'] as int?,
      testExtractRule: jsonSerialization['testExtractRule'] as String,
      extractJsonResult: jsonSerialization['extractJsonResult'] as String,
      scrappableId: jsonSerialization['scrappableId'] as int,
      referenceTestDataId: jsonSerialization['referenceTestDataId'] as int?,
      referenceTestData: jsonSerialization['referenceTestData'] == null
          ? null
          : _i2.ReferenceTestData.fromJson(
              (jsonSerialization['referenceTestData'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String testExtractRule;

  String extractJsonResult;

  int scrappableId;

  int? referenceTestDataId;

  _i2.ReferenceTestData? referenceTestData;

  /// Returns a shallow copy of this [ScrappableTestResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableTestResult copyWith({
    int? id,
    String? testExtractRule,
    String? extractJsonResult,
    int? scrappableId,
    int? referenceTestDataId,
    _i2.ReferenceTestData? referenceTestData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'testExtractRule': testExtractRule,
      'extractJsonResult': extractJsonResult,
      'scrappableId': scrappableId,
      if (referenceTestDataId != null)
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

class _ScrappableTestResultImpl extends ScrappableTestResult {
  _ScrappableTestResultImpl({
    int? id,
    required String testExtractRule,
    required String extractJsonResult,
    required int scrappableId,
    int? referenceTestDataId,
    _i2.ReferenceTestData? referenceTestData,
  }) : super._(
          id: id,
          testExtractRule: testExtractRule,
          extractJsonResult: extractJsonResult,
          scrappableId: scrappableId,
          referenceTestDataId: referenceTestDataId,
          referenceTestData: referenceTestData,
        );

  /// Returns a shallow copy of this [ScrappableTestResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableTestResult copyWith({
    Object? id = _Undefined,
    String? testExtractRule,
    String? extractJsonResult,
    int? scrappableId,
    Object? referenceTestDataId = _Undefined,
    Object? referenceTestData = _Undefined,
  }) {
    return ScrappableTestResult(
      id: id is int? ? id : this.id,
      testExtractRule: testExtractRule ?? this.testExtractRule,
      extractJsonResult: extractJsonResult ?? this.extractJsonResult,
      scrappableId: scrappableId ?? this.scrappableId,
      referenceTestDataId: referenceTestDataId is int?
          ? referenceTestDataId
          : this.referenceTestDataId,
      referenceTestData: referenceTestData is _i2.ReferenceTestData?
          ? referenceTestData
          : this.referenceTestData?.copyWith(),
    );
  }
}
