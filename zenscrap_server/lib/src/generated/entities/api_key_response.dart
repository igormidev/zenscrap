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
import '../entities/account/account_api_key.dart' as _i2;

abstract class ApiKeyResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ApiKeyResponse._({
    required this.apiKeys,
    required this.usageStats,
  });

  factory ApiKeyResponse({
    required List<_i2.AccountApiKey> apiKeys,
    required Map<int, int> usageStats,
  }) = _ApiKeyResponseImpl;

  factory ApiKeyResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiKeyResponse(
      apiKeys: (jsonSerialization['apiKeys'] as List)
          .map((e) => _i2.AccountApiKey.fromJson((e as Map<String, dynamic>)))
          .toList(),
      usageStats: (jsonSerialization['usageStats'] as List).fold<Map<int, int>>(
          {}, (t, e) => {...t, e['k'] as int: e['v'] as int}),
    );
  }

  List<_i2.AccountApiKey> apiKeys;

  Map<int, int> usageStats;

  /// Returns a shallow copy of this [ApiKeyResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiKeyResponse copyWith({
    List<_i2.AccountApiKey>? apiKeys,
    Map<int, int>? usageStats,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'apiKeys': apiKeys.toJson(valueToJson: (v) => v.toJson()),
      'usageStats': usageStats.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'apiKeys': apiKeys.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'usageStats': usageStats.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ApiKeyResponseImpl extends ApiKeyResponse {
  _ApiKeyResponseImpl({
    required List<_i2.AccountApiKey> apiKeys,
    required Map<int, int> usageStats,
  }) : super._(
          apiKeys: apiKeys,
          usageStats: usageStats,
        );

  /// Returns a shallow copy of this [ApiKeyResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiKeyResponse copyWith({
    List<_i2.AccountApiKey>? apiKeys,
    Map<int, int>? usageStats,
  }) {
    return ApiKeyResponse(
      apiKeys: apiKeys ?? this.apiKeys.map((e0) => e0.copyWith()).toList(),
      usageStats: usageStats ??
          this.usageStats.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
    );
  }
}
