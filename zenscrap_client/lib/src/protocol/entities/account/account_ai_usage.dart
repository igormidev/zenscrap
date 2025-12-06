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
import '../../entities/account/account.dart' as _i2;

abstract class AccountAIUsage implements _i1.SerializableModel {
  AccountAIUsage._({
    this.id,
    this.userOpenAiApiKey,
    required this.totalDollarsSpentFromTotalInUSD,
    this.accountInfo,
  });

  factory AccountAIUsage({
    int? id,
    String? userOpenAiApiKey,
    required double totalDollarsSpentFromTotalInUSD,
    _i2.AccountInfo? accountInfo,
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
          : _i2.AccountInfo.fromJson(
              (jsonSerialization['accountInfo'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? userOpenAiApiKey;

  double totalDollarsSpentFromTotalInUSD;

  _i2.AccountInfo? accountInfo;

  /// Returns a shallow copy of this [AccountAIUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountAIUsage copyWith({
    int? id,
    String? userOpenAiApiKey,
    double? totalDollarsSpentFromTotalInUSD,
    _i2.AccountInfo? accountInfo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userOpenAiApiKey != null) 'userOpenAiApiKey': userOpenAiApiKey,
      'totalDollarsSpentFromTotalInUSD': totalDollarsSpentFromTotalInUSD,
      if (accountInfo != null) 'accountInfo': accountInfo?.toJson(),
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
  }) : super._(
          id: id,
          userOpenAiApiKey: userOpenAiApiKey,
          totalDollarsSpentFromTotalInUSD: totalDollarsSpentFromTotalInUSD,
          accountInfo: accountInfo,
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
  }) {
    return AccountAIUsage(
      id: id is int? ? id : this.id,
      userOpenAiApiKey: userOpenAiApiKey is String?
          ? userOpenAiApiKey
          : this.userOpenAiApiKey,
      totalDollarsSpentFromTotalInUSD: totalDollarsSpentFromTotalInUSD ??
          this.totalDollarsSpentFromTotalInUSD,
      accountInfo: accountInfo is _i2.AccountInfo?
          ? accountInfo
          : this.accountInfo?.copyWith(),
    );
  }
}
