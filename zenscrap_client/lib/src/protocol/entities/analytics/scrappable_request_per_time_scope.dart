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

abstract class ScrappableRequestPerTimeScope implements _i1.SerializableModel {
  ScrappableRequestPerTimeScope._({
    required this.start,
    required this.end,
    required this.successCount,
    required this.clientErrorCount,
    required this.serverErrorCount,
    required this.insufficientCreditsCount,
    required this.maxConcurrencyExceededCount,
  });

  factory ScrappableRequestPerTimeScope({
    required DateTime start,
    required DateTime end,
    required int successCount,
    required int clientErrorCount,
    required int serverErrorCount,
    required int insufficientCreditsCount,
    required int maxConcurrencyExceededCount,
  }) = _ScrappableRequestPerTimeScopeImpl;

  factory ScrappableRequestPerTimeScope.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ScrappableRequestPerTimeScope(
      start: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['start']),
      end: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['end']),
      successCount: jsonSerialization['successCount'] as int,
      clientErrorCount: jsonSerialization['clientErrorCount'] as int,
      serverErrorCount: jsonSerialization['serverErrorCount'] as int,
      insufficientCreditsCount:
          jsonSerialization['insufficientCreditsCount'] as int,
      maxConcurrencyExceededCount:
          jsonSerialization['maxConcurrencyExceededCount'] as int,
    );
  }

  DateTime start;

  DateTime end;

  int successCount;

  int clientErrorCount;

  int serverErrorCount;

  int insufficientCreditsCount;

  int maxConcurrencyExceededCount;

  /// Returns a shallow copy of this [ScrappableRequestPerTimeScope]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableRequestPerTimeScope copyWith({
    DateTime? start,
    DateTime? end,
    int? successCount,
    int? clientErrorCount,
    int? serverErrorCount,
    int? insufficientCreditsCount,
    int? maxConcurrencyExceededCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'start': start.toJson(),
      'end': end.toJson(),
      'successCount': successCount,
      'clientErrorCount': clientErrorCount,
      'serverErrorCount': serverErrorCount,
      'insufficientCreditsCount': insufficientCreditsCount,
      'maxConcurrencyExceededCount': maxConcurrencyExceededCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ScrappableRequestPerTimeScopeImpl extends ScrappableRequestPerTimeScope {
  _ScrappableRequestPerTimeScopeImpl({
    required DateTime start,
    required DateTime end,
    required int successCount,
    required int clientErrorCount,
    required int serverErrorCount,
    required int insufficientCreditsCount,
    required int maxConcurrencyExceededCount,
  }) : super._(
          start: start,
          end: end,
          successCount: successCount,
          clientErrorCount: clientErrorCount,
          serverErrorCount: serverErrorCount,
          insufficientCreditsCount: insufficientCreditsCount,
          maxConcurrencyExceededCount: maxConcurrencyExceededCount,
        );

  /// Returns a shallow copy of this [ScrappableRequestPerTimeScope]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableRequestPerTimeScope copyWith({
    DateTime? start,
    DateTime? end,
    int? successCount,
    int? clientErrorCount,
    int? serverErrorCount,
    int? insufficientCreditsCount,
    int? maxConcurrencyExceededCount,
  }) {
    return ScrappableRequestPerTimeScope(
      start: start ?? this.start,
      end: end ?? this.end,
      successCount: successCount ?? this.successCount,
      clientErrorCount: clientErrorCount ?? this.clientErrorCount,
      serverErrorCount: serverErrorCount ?? this.serverErrorCount,
      insufficientCreditsCount:
          insufficientCreditsCount ?? this.insufficientCreditsCount,
      maxConcurrencyExceededCount:
          maxConcurrencyExceededCount ?? this.maxConcurrencyExceededCount,
    );
  }
}
