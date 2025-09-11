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
import '../../entities/scrappable/byte_test_data.dart' as _i2;
import '../../entities/scrappable/scrappable.dart' as _i3;

abstract class ReferenceTestData implements _i1.SerializableModel {
  ReferenceTestData._({
    this.id,
    required this.referenceLinkUsed,
    required this.referenceQueryParametersJson,
    this.byteDataId,
    this.byteData,
    this.scrappable,
  });

  factory ReferenceTestData({
    int? id,
    required String referenceLinkUsed,
    required String referenceQueryParametersJson,
    int? byteDataId,
    _i2.ByteTestData? byteData,
    _i3.Scrappable? scrappable,
  }) = _ReferenceTestDataImpl;

  factory ReferenceTestData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferenceTestData(
      id: jsonSerialization['id'] as int?,
      referenceLinkUsed: jsonSerialization['referenceLinkUsed'] as String,
      referenceQueryParametersJson:
          jsonSerialization['referenceQueryParametersJson'] as String,
      byteDataId: jsonSerialization['byteDataId'] as int?,
      byteData: jsonSerialization['byteData'] == null
          ? null
          : _i2.ByteTestData.fromJson(
              (jsonSerialization['byteData'] as Map<String, dynamic>)),
      scrappable: jsonSerialization['scrappable'] == null
          ? null
          : _i3.Scrappable.fromJson(
              (jsonSerialization['scrappable'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String referenceLinkUsed;

  String referenceQueryParametersJson;

  int? byteDataId;

  _i2.ByteTestData? byteData;

  _i3.Scrappable? scrappable;

  /// Returns a shallow copy of this [ReferenceTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferenceTestData copyWith({
    int? id,
    String? referenceLinkUsed,
    String? referenceQueryParametersJson,
    int? byteDataId,
    _i2.ByteTestData? byteData,
    _i3.Scrappable? scrappable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'referenceLinkUsed': referenceLinkUsed,
      'referenceQueryParametersJson': referenceQueryParametersJson,
      if (byteDataId != null) 'byteDataId': byteDataId,
      if (byteData != null) 'byteData': byteData?.toJson(),
      if (scrappable != null) 'scrappable': scrappable?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReferenceTestDataImpl extends ReferenceTestData {
  _ReferenceTestDataImpl({
    int? id,
    required String referenceLinkUsed,
    required String referenceQueryParametersJson,
    int? byteDataId,
    _i2.ByteTestData? byteData,
    _i3.Scrappable? scrappable,
  }) : super._(
          id: id,
          referenceLinkUsed: referenceLinkUsed,
          referenceQueryParametersJson: referenceQueryParametersJson,
          byteDataId: byteDataId,
          byteData: byteData,
          scrappable: scrappable,
        );

  /// Returns a shallow copy of this [ReferenceTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferenceTestData copyWith({
    Object? id = _Undefined,
    String? referenceLinkUsed,
    String? referenceQueryParametersJson,
    Object? byteDataId = _Undefined,
    Object? byteData = _Undefined,
    Object? scrappable = _Undefined,
  }) {
    return ReferenceTestData(
      id: id is int? ? id : this.id,
      referenceLinkUsed: referenceLinkUsed ?? this.referenceLinkUsed,
      referenceQueryParametersJson:
          referenceQueryParametersJson ?? this.referenceQueryParametersJson,
      byteDataId: byteDataId is int? ? byteDataId : this.byteDataId,
      byteData:
          byteData is _i2.ByteTestData? ? byteData : this.byteData?.copyWith(),
      scrappable: scrappable is _i3.Scrappable?
          ? scrappable
          : this.scrappable?.copyWith(),
    );
  }
}
