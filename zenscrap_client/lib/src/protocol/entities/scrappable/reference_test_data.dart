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

abstract class ReferenceTestData implements _i1.SerializableModel {
  ReferenceTestData._({
    required this.referenceHtmlPage,
    required this.referenceLink,
    required this.referenceQueryParametersJson,
    required this.referenceSiteScreenshot,
    required this.extractedRulesUsed,
  });

  factory ReferenceTestData({
    required String referenceHtmlPage,
    required String referenceLink,
    required String referenceQueryParametersJson,
    required _i2.ByteData referenceSiteScreenshot,
    required String extractedRulesUsed,
  }) = _ReferenceTestDataImpl;

  factory ReferenceTestData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferenceTestData(
      referenceHtmlPage: jsonSerialization['referenceHtmlPage'] as String,
      referenceLink: jsonSerialization['referenceLink'] as String,
      referenceQueryParametersJson:
          jsonSerialization['referenceQueryParametersJson'] as String,
      referenceSiteScreenshot: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['referenceSiteScreenshot']),
      extractedRulesUsed: jsonSerialization['extractedRulesUsed'] as String,
    );
  }

  String referenceHtmlPage;

  String referenceLink;

  String referenceQueryParametersJson;

  _i2.ByteData referenceSiteScreenshot;

  String extractedRulesUsed;

  /// Returns a shallow copy of this [ReferenceTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferenceTestData copyWith({
    String? referenceHtmlPage,
    String? referenceLink,
    String? referenceQueryParametersJson,
    _i2.ByteData? referenceSiteScreenshot,
    String? extractedRulesUsed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'referenceHtmlPage': referenceHtmlPage,
      'referenceLink': referenceLink,
      'referenceQueryParametersJson': referenceQueryParametersJson,
      'referenceSiteScreenshot': referenceSiteScreenshot.toJson(),
      'extractedRulesUsed': extractedRulesUsed,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ReferenceTestDataImpl extends ReferenceTestData {
  _ReferenceTestDataImpl({
    required String referenceHtmlPage,
    required String referenceLink,
    required String referenceQueryParametersJson,
    required _i2.ByteData referenceSiteScreenshot,
    required String extractedRulesUsed,
  }) : super._(
          referenceHtmlPage: referenceHtmlPage,
          referenceLink: referenceLink,
          referenceQueryParametersJson: referenceQueryParametersJson,
          referenceSiteScreenshot: referenceSiteScreenshot,
          extractedRulesUsed: extractedRulesUsed,
        );

  /// Returns a shallow copy of this [ReferenceTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferenceTestData copyWith({
    String? referenceHtmlPage,
    String? referenceLink,
    String? referenceQueryParametersJson,
    _i2.ByteData? referenceSiteScreenshot,
    String? extractedRulesUsed,
  }) {
    return ReferenceTestData(
      referenceHtmlPage: referenceHtmlPage ?? this.referenceHtmlPage,
      referenceLink: referenceLink ?? this.referenceLink,
      referenceQueryParametersJson:
          referenceQueryParametersJson ?? this.referenceQueryParametersJson,
      referenceSiteScreenshot:
          referenceSiteScreenshot ?? this.referenceSiteScreenshot.clone(),
      extractedRulesUsed: extractedRulesUsed ?? this.extractedRulesUsed,
    );
  }
}
