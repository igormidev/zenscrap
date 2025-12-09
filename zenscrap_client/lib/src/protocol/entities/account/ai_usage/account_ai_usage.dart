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
import '../../../entities/account/account.dart' as _i2;
import '../../../entities/account/ai_usage/ai_credit_history/ai_usage_history_item.dart'
    as _i3;
import 'package:zenscrap_client/src/protocol/protocol.dart' as _i4;

abstract class AccountAIUsage implements _i1.SerializableModel {
  AccountAIUsage._({
    this.id,
    this.userOpenAiApiKey,
    required this.totalDollarsSpentFromTotalInUSD,
    this.accountInfo,
    this.history,
  });

  factory AccountAIUsage({
    int? id,
    String? userOpenAiApiKey,
    required double totalDollarsSpentFromTotalInUSD,
    _i2.AccountInfo? accountInfo,
    List<_i3.AICreditHistoryItem>? history,
  }) = _AccountAIUsageImpl;

  factory AccountAIUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountAIUsage(
      id: jsonSerialization['id'] as int?,
      userOpenAiApiKey: jsonSerialization['userOpenAiApiKey'] as String?,
      totalDollarsSpentFromTotalInUSD:
          (jsonSerialization['totalDollarsSpentFromTotalInUSD'] as num)
              .toDouble(),
      accountInfo: jsonSerialization['accountInfo'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.AccountInfo>(
              jsonSerialization['accountInfo'],
            ),
      history: jsonSerialization['history'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i3.AICreditHistoryItem>>(
              jsonSerialization['history'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? userOpenAiApiKey;

  double totalDollarsSpentFromTotalInUSD;

  _i2.AccountInfo? accountInfo;

  List<_i3.AICreditHistoryItem>? history;

  /// Returns a shallow copy of this [AccountAIUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountAIUsage copyWith({
    int? id,
    String? userOpenAiApiKey,
    double? totalDollarsSpentFromTotalInUSD,
    _i2.AccountInfo? accountInfo,
    List<_i3.AICreditHistoryItem>? history,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountAIUsage',
      if (id != null) 'id': id,
      if (userOpenAiApiKey != null) 'userOpenAiApiKey': userOpenAiApiKey,
      'totalDollarsSpentFromTotalInUSD': totalDollarsSpentFromTotalInUSD,
      if (accountInfo != null) 'accountInfo': accountInfo?.toJson(),
      if (history != null)
        'history': history?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountAIUsageImpl extends AccountAIUsage {
  _AccountAIUsageImpl({
    int? id,
    String? userOpenAiApiKey,
    required double totalDollarsSpentFromTotalInUSD,
    _i2.AccountInfo? accountInfo,
    List<_i3.AICreditHistoryItem>? history,
  }) : super._(
         id: id,
         userOpenAiApiKey: userOpenAiApiKey,
         totalDollarsSpentFromTotalInUSD: totalDollarsSpentFromTotalInUSD,
         accountInfo: accountInfo,
         history: history,
       );

  /// Returns a shallow copy of this [AccountAIUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountAIUsage copyWith({
    Object? id = _Undefined,
    Object? userOpenAiApiKey = _Undefined,
    double? totalDollarsSpentFromTotalInUSD,
    Object? accountInfo = _Undefined,
    Object? history = _Undefined,
  }) {
    return AccountAIUsage(
      id: id is int? ? id : this.id,
      userOpenAiApiKey: userOpenAiApiKey is String?
          ? userOpenAiApiKey
          : this.userOpenAiApiKey,
      totalDollarsSpentFromTotalInUSD:
          totalDollarsSpentFromTotalInUSD ??
          this.totalDollarsSpentFromTotalInUSD,
      accountInfo: accountInfo is _i2.AccountInfo?
          ? accountInfo
          : this.accountInfo?.copyWith(),
      history: history is List<_i3.AICreditHistoryItem>?
          ? history
          : this.history?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
