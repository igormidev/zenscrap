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

abstract class ScrappableTestResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ScrappableTestResult._({
    required this.testExtractRule,
    required this.extractJsonResult,
  });

  factory ScrappableTestResult({
    required String testExtractRule,
    required String extractJsonResult,
  }) = _ScrappableTestResultImpl;

  factory ScrappableTestResult.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ScrappableTestResult(
      testExtractRule: jsonSerialization['testExtractRule'] as String,
      extractJsonResult: jsonSerialization['extractJsonResult'] as String,
    );
  }

  String testExtractRule;

  String extractJsonResult;

  /// Returns a shallow copy of this [ScrappableTestResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableTestResult copyWith({
    String? testExtractRule,
    String? extractJsonResult,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'testExtractRule': testExtractRule,
      'extractJsonResult': extractJsonResult,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'testExtractRule': testExtractRule,
      'extractJsonResult': extractJsonResult,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ScrappableTestResultImpl extends ScrappableTestResult {
  _ScrappableTestResultImpl({
    required String testExtractRule,
    required String extractJsonResult,
  }) : super._(
          testExtractRule: testExtractRule,
          extractJsonResult: extractJsonResult,
        );

  /// Returns a shallow copy of this [ScrappableTestResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableTestResult copyWith({
    String? testExtractRule,
    String? extractJsonResult,
  }) {
    return ScrappableTestResult(
      testExtractRule: testExtractRule ?? this.testExtractRule,
      extractJsonResult: extractJsonResult ?? this.extractJsonResult,
    );
  }
}
