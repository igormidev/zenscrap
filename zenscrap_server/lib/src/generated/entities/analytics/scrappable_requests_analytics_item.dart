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
import '../../entities/scrappable/scrappable.dart' as _i2;
import '../../entities/analytics/scrappable_request_per_time_scope.dart' as _i3;

abstract class ScrappableRequestsAnalyticsItem
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ScrappableRequestsAnalyticsItem._({
    required this.scrappable,
    required this.successTotalCount,
    required this.clientErrorTotalCount,
    required this.serverErrorTotalCount,
    required this.insufficientCreditsTotalCount,
    required this.maxConcurrencyExceededTotalCount,
    required this.data,
  });

  factory ScrappableRequestsAnalyticsItem({
    required _i2.Scrappable scrappable,
    required int successTotalCount,
    required int clientErrorTotalCount,
    required int serverErrorTotalCount,
    required int insufficientCreditsTotalCount,
    required int maxConcurrencyExceededTotalCount,
    required List<_i3.ScrappableRequestPerTimeScope> data,
  }) = _ScrappableRequestsAnalyticsItemImpl;

  factory ScrappableRequestsAnalyticsItem.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ScrappableRequestsAnalyticsItem(
      scrappable: _i2.Scrappable.fromJson(
          (jsonSerialization['scrappable'] as Map<String, dynamic>)),
      successTotalCount: jsonSerialization['successTotalCount'] as int,
      clientErrorTotalCount: jsonSerialization['clientErrorTotalCount'] as int,
      serverErrorTotalCount: jsonSerialization['serverErrorTotalCount'] as int,
      insufficientCreditsTotalCount:
          jsonSerialization['insufficientCreditsTotalCount'] as int,
      maxConcurrencyExceededTotalCount:
          jsonSerialization['maxConcurrencyExceededTotalCount'] as int,
      data: (jsonSerialization['data'] as List)
          .map((e) => _i3.ScrappableRequestPerTimeScope.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
    );
  }

  _i2.Scrappable scrappable;

  int successTotalCount;

  int clientErrorTotalCount;

  int serverErrorTotalCount;

  int insufficientCreditsTotalCount;

  int maxConcurrencyExceededTotalCount;

  List<_i3.ScrappableRequestPerTimeScope> data;

  /// Returns a shallow copy of this [ScrappableRequestsAnalyticsItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableRequestsAnalyticsItem copyWith({
    _i2.Scrappable? scrappable,
    int? successTotalCount,
    int? clientErrorTotalCount,
    int? serverErrorTotalCount,
    int? insufficientCreditsTotalCount,
    int? maxConcurrencyExceededTotalCount,
    List<_i3.ScrappableRequestPerTimeScope>? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'scrappable': scrappable.toJson(),
      'successTotalCount': successTotalCount,
      'clientErrorTotalCount': clientErrorTotalCount,
      'serverErrorTotalCount': serverErrorTotalCount,
      'insufficientCreditsTotalCount': insufficientCreditsTotalCount,
      'maxConcurrencyExceededTotalCount': maxConcurrencyExceededTotalCount,
      'data': data.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'scrappable': scrappable.toJsonForProtocol(),
      'successTotalCount': successTotalCount,
      'clientErrorTotalCount': clientErrorTotalCount,
      'serverErrorTotalCount': serverErrorTotalCount,
      'insufficientCreditsTotalCount': insufficientCreditsTotalCount,
      'maxConcurrencyExceededTotalCount': maxConcurrencyExceededTotalCount,
      'data': data.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ScrappableRequestsAnalyticsItemImpl
    extends ScrappableRequestsAnalyticsItem {
  _ScrappableRequestsAnalyticsItemImpl({
    required _i2.Scrappable scrappable,
    required int successTotalCount,
    required int clientErrorTotalCount,
    required int serverErrorTotalCount,
    required int insufficientCreditsTotalCount,
    required int maxConcurrencyExceededTotalCount,
    required List<_i3.ScrappableRequestPerTimeScope> data,
  }) : super._(
          scrappable: scrappable,
          successTotalCount: successTotalCount,
          clientErrorTotalCount: clientErrorTotalCount,
          serverErrorTotalCount: serverErrorTotalCount,
          insufficientCreditsTotalCount: insufficientCreditsTotalCount,
          maxConcurrencyExceededTotalCount: maxConcurrencyExceededTotalCount,
          data: data,
        );

  /// Returns a shallow copy of this [ScrappableRequestsAnalyticsItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableRequestsAnalyticsItem copyWith({
    _i2.Scrappable? scrappable,
    int? successTotalCount,
    int? clientErrorTotalCount,
    int? serverErrorTotalCount,
    int? insufficientCreditsTotalCount,
    int? maxConcurrencyExceededTotalCount,
    List<_i3.ScrappableRequestPerTimeScope>? data,
  }) {
    return ScrappableRequestsAnalyticsItem(
      scrappable: scrappable ?? this.scrappable.copyWith(),
      successTotalCount: successTotalCount ?? this.successTotalCount,
      clientErrorTotalCount:
          clientErrorTotalCount ?? this.clientErrorTotalCount,
      serverErrorTotalCount:
          serverErrorTotalCount ?? this.serverErrorTotalCount,
      insufficientCreditsTotalCount:
          insufficientCreditsTotalCount ?? this.insufficientCreditsTotalCount,
      maxConcurrencyExceededTotalCount: maxConcurrencyExceededTotalCount ??
          this.maxConcurrencyExceededTotalCount,
      data: data ?? this.data.map((e0) => e0.copyWith()).toList(),
    );
  }
}
