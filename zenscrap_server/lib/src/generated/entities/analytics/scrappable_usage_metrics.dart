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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ScrappableUsageMetrics
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ScrappableUsageMetrics._({
    required this.successCount,
    required this.errorCount,
    required this.totalCount,
  });

  factory ScrappableUsageMetrics({
    required int successCount,
    required int errorCount,
    required int totalCount,
  }) = _ScrappableUsageMetricsImpl;

  factory ScrappableUsageMetrics.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ScrappableUsageMetrics(
      successCount: jsonSerialization['successCount'] as int,
      errorCount: jsonSerialization['errorCount'] as int,
      totalCount: jsonSerialization['totalCount'] as int,
    );
  }

  int successCount;

  int errorCount;

  int totalCount;

  /// Returns a shallow copy of this [ScrappableUsageMetrics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableUsageMetrics copyWith({
    int? successCount,
    int? errorCount,
    int? totalCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScrappableUsageMetrics',
      'successCount': successCount,
      'errorCount': errorCount,
      'totalCount': totalCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScrappableUsageMetrics',
      'successCount': successCount,
      'errorCount': errorCount,
      'totalCount': totalCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ScrappableUsageMetricsImpl extends ScrappableUsageMetrics {
  _ScrappableUsageMetricsImpl({
    required int successCount,
    required int errorCount,
    required int totalCount,
  }) : super._(
         successCount: successCount,
         errorCount: errorCount,
         totalCount: totalCount,
       );

  /// Returns a shallow copy of this [ScrappableUsageMetrics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableUsageMetrics copyWith({
    int? successCount,
    int? errorCount,
    int? totalCount,
  }) {
    return ScrappableUsageMetrics(
      successCount: successCount ?? this.successCount,
      errorCount: errorCount ?? this.errorCount,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
