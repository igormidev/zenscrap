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
import '../../../entities/account/account.dart' as _i2;
import '../../../entities/account/api_usage/api_creadit_history/api_creadit_history_item.dart'
    as _i3;
import '../../../entities/account/account_api_key.dart' as _i4;

abstract class AccountApiUsage implements _i1.SerializableModel {
  AccountApiUsage._({
    this.id,
    required this.remainingCredits,
    this.accountInfo,
    this.history,
    this.apiKeys,
  });

  factory AccountApiUsage({
    int? id,
    required int remainingCredits,
    _i2.AccountInfo? accountInfo,
    List<_i3.CreditHistoryItem>? history,
    List<_i4.AccountApiKey>? apiKeys,
  }) = _AccountApiUsageImpl;

  factory AccountApiUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountApiUsage(
      id: jsonSerialization['id'] as int?,
      remainingCredits: jsonSerialization['remainingCredits'] as int,
      accountInfo: jsonSerialization['accountInfo'] == null
          ? null
          : _i2.AccountInfo.fromJson(
              (jsonSerialization['accountInfo'] as Map<String, dynamic>)),
      history: (jsonSerialization['history'] as List?)
          ?.map((e) =>
              _i3.CreditHistoryItem.fromJson((e as Map<String, dynamic>)))
          .toList(),
      apiKeys: (jsonSerialization['apiKeys'] as List?)
          ?.map((e) => _i4.AccountApiKey.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int remainingCredits;

  _i2.AccountInfo? accountInfo;

  List<_i3.CreditHistoryItem>? history;

  List<_i4.AccountApiKey>? apiKeys;

  /// Returns a shallow copy of this [AccountApiUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountApiUsage copyWith({
    int? id,
    int? remainingCredits,
    _i2.AccountInfo? accountInfo,
    List<_i3.CreditHistoryItem>? history,
    List<_i4.AccountApiKey>? apiKeys,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'remainingCredits': remainingCredits,
      if (accountInfo != null) 'accountInfo': accountInfo?.toJson(),
      if (history != null)
        'history': history?.toJson(valueToJson: (v) => v.toJson()),
      if (apiKeys != null)
        'apiKeys': apiKeys?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountApiUsageImpl extends AccountApiUsage {
  _AccountApiUsageImpl({
    int? id,
    required int remainingCredits,
    _i2.AccountInfo? accountInfo,
    List<_i3.CreditHistoryItem>? history,
    List<_i4.AccountApiKey>? apiKeys,
  }) : super._(
          id: id,
          remainingCredits: remainingCredits,
          accountInfo: accountInfo,
          history: history,
          apiKeys: apiKeys,
        );

  /// Returns a shallow copy of this [AccountApiUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountApiUsage copyWith({
    Object? id = _Undefined,
    int? remainingCredits,
    Object? accountInfo = _Undefined,
    Object? history = _Undefined,
    Object? apiKeys = _Undefined,
  }) {
    return AccountApiUsage(
      id: id is int? ? id : this.id,
      remainingCredits: remainingCredits ?? this.remainingCredits,
      accountInfo: accountInfo is _i2.AccountInfo?
          ? accountInfo
          : this.accountInfo?.copyWith(),
      history: history is List<_i3.CreditHistoryItem>?
          ? history
          : this.history?.map((e0) => e0.copyWith()).toList(),
      apiKeys: apiKeys is List<_i4.AccountApiKey>?
          ? apiKeys
          : this.apiKeys?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
