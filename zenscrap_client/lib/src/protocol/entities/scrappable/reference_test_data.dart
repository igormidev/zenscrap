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
import 'dart:typed_data' as _i2;
import '../../entities/scrappable/scrappable_test_result.dart' as _i3;
import '../../entities/scrappable/scrappable.dart' as _i4;

abstract class ReferenceTestData implements _i1.SerializableModel {
  ReferenceTestData._({
    this.id,
    required this.referenceLinkUsed,
    required this.referenceQueryParametersJson,
    required this.referenceHtmlPage,
    required this.referenceSiteScreenshot,
    this.scrappableTestResult,
    this.scrappable,
  });

  factory ReferenceTestData({
    int? id,
    required String referenceLinkUsed,
    required String referenceQueryParametersJson,
    required _i2.ByteData referenceHtmlPage,
    required _i2.ByteData referenceSiteScreenshot,
    _i3.ScrappableTestResult? scrappableTestResult,
    _i4.Scrappable? scrappable,
  }) = _ReferenceTestDataImpl;

  factory ReferenceTestData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferenceTestData(
      id: jsonSerialization['id'] as int?,
      referenceLinkUsed: jsonSerialization['referenceLinkUsed'] as String,
      referenceQueryParametersJson:
          jsonSerialization['referenceQueryParametersJson'] as String,
      referenceHtmlPage: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['referenceHtmlPage']),
      referenceSiteScreenshot: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['referenceSiteScreenshot']),
      scrappableTestResult: jsonSerialization['scrappableTestResult'] == null
          ? null
          : _i3.ScrappableTestResult.fromJson(
              (jsonSerialization['scrappableTestResult']
                  as Map<String, dynamic>)),
      scrappable: jsonSerialization['scrappable'] == null
          ? null
          : _i4.Scrappable.fromJson(
              (jsonSerialization['scrappable'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String referenceLinkUsed;

  String referenceQueryParametersJson;

  _i2.ByteData referenceHtmlPage;

  _i2.ByteData referenceSiteScreenshot;

  _i3.ScrappableTestResult? scrappableTestResult;

  _i4.Scrappable? scrappable;

  /// Returns a shallow copy of this [ReferenceTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferenceTestData copyWith({
    int? id,
    String? referenceLinkUsed,
    String? referenceQueryParametersJson,
    _i2.ByteData? referenceHtmlPage,
    _i2.ByteData? referenceSiteScreenshot,
    _i3.ScrappableTestResult? scrappableTestResult,
    _i4.Scrappable? scrappable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'referenceLinkUsed': referenceLinkUsed,
      'referenceQueryParametersJson': referenceQueryParametersJson,
      'referenceHtmlPage': referenceHtmlPage.toJson(),
      'referenceSiteScreenshot': referenceSiteScreenshot.toJson(),
      if (scrappableTestResult != null)
        'scrappableTestResult': scrappableTestResult?.toJson(),
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
    required _i2.ByteData referenceHtmlPage,
    required _i2.ByteData referenceSiteScreenshot,
    _i3.ScrappableTestResult? scrappableTestResult,
    _i4.Scrappable? scrappable,
  }) : super._(
          id: id,
          referenceLinkUsed: referenceLinkUsed,
          referenceQueryParametersJson: referenceQueryParametersJson,
          referenceHtmlPage: referenceHtmlPage,
          referenceSiteScreenshot: referenceSiteScreenshot,
          scrappableTestResult: scrappableTestResult,
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
    _i2.ByteData? referenceHtmlPage,
    _i2.ByteData? referenceSiteScreenshot,
    Object? scrappableTestResult = _Undefined,
    Object? scrappable = _Undefined,
  }) {
    return ReferenceTestData(
      id: id is int? ? id : this.id,
      referenceLinkUsed: referenceLinkUsed ?? this.referenceLinkUsed,
      referenceQueryParametersJson:
          referenceQueryParametersJson ?? this.referenceQueryParametersJson,
      referenceHtmlPage: referenceHtmlPage ?? this.referenceHtmlPage.clone(),
      referenceSiteScreenshot:
          referenceSiteScreenshot ?? this.referenceSiteScreenshot.clone(),
      scrappableTestResult: scrappableTestResult is _i3.ScrappableTestResult?
          ? scrappableTestResult
          : this.scrappableTestResult?.copyWith(),
      scrappable: scrappable is _i4.Scrappable?
          ? scrappable
          : this.scrappable?.copyWith(),
    );
  }
}
