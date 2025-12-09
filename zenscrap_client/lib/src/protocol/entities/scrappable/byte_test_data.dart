/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;

abstract class ByteTestData implements _i1.SerializableModel {
  ByteTestData._({
    this.id,
    required this.referenceHtmlPage,
    required this.referenceSiteScreenshot,
  });

  factory ByteTestData({
    int? id,
    required _i2.ByteData referenceHtmlPage,
    required _i2.ByteData referenceSiteScreenshot,
  }) = _ByteTestDataImpl;

  factory ByteTestData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ByteTestData(
      id: jsonSerialization['id'] as int?,
      referenceHtmlPage: _i1.ByteDataJsonExtension.fromJson(
        jsonSerialization['referenceHtmlPage'],
      ),
      referenceSiteScreenshot: _i1.ByteDataJsonExtension.fromJson(
        jsonSerialization['referenceSiteScreenshot'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.ByteData referenceHtmlPage;

  _i2.ByteData referenceSiteScreenshot;

  /// Returns a shallow copy of this [ByteTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ByteTestData copyWith({
    int? id,
    _i2.ByteData? referenceHtmlPage,
    _i2.ByteData? referenceSiteScreenshot,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ByteTestData',
      if (id != null) 'id': id,
      'referenceHtmlPage': referenceHtmlPage.toJson(),
      'referenceSiteScreenshot': referenceSiteScreenshot.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ByteTestDataImpl extends ByteTestData {
  _ByteTestDataImpl({
    int? id,
    required _i2.ByteData referenceHtmlPage,
    required _i2.ByteData referenceSiteScreenshot,
  }) : super._(
         id: id,
         referenceHtmlPage: referenceHtmlPage,
         referenceSiteScreenshot: referenceSiteScreenshot,
       );

  /// Returns a shallow copy of this [ByteTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ByteTestData copyWith({
    Object? id = _Undefined,
    _i2.ByteData? referenceHtmlPage,
    _i2.ByteData? referenceSiteScreenshot,
  }) {
    return ByteTestData(
      id: id is int? ? id : this.id,
      referenceHtmlPage: referenceHtmlPage ?? this.referenceHtmlPage.clone(),
      referenceSiteScreenshot:
          referenceSiteScreenshot ?? this.referenceSiteScreenshot.clone(),
    );
  }
}
