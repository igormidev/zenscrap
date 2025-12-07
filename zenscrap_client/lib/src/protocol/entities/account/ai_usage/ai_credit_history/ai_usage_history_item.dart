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
import '../../../../entities/account/ai_usage/ai_credit_history/monthly_subscription_ai_credit_deposit.dart'
    as _i2;
import '../../../../entities/account/ai_usage/account_ai_usage.dart' as _i3;

abstract class AICreditHistoryItem implements _i1.SerializableModel {
  AICreditHistoryItem._({
    this.id,
    required this.date,
    this.monthlySubscriptionAICreditDepositId,
    this.monthlySubscriptionAICreditDeposit,
    required this.accountAIUsageId,
    this.accountAIUsage,
  });

  factory AICreditHistoryItem({
    int? id,
    required DateTime date,
    int? monthlySubscriptionAICreditDepositId,
    _i2.MonthlySubscriptionAICreditDeposit? monthlySubscriptionAICreditDeposit,
    required int accountAIUsageId,
    _i3.AccountAIUsage? accountAIUsage,
  }) = _AICreditHistoryItemImpl;

  factory AICreditHistoryItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return AICreditHistoryItem(
      id: jsonSerialization['id'] as int?,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      monthlySubscriptionAICreditDepositId:
          jsonSerialization['monthlySubscriptionAICreditDepositId'] as int?,
      monthlySubscriptionAICreditDeposit:
          jsonSerialization['monthlySubscriptionAICreditDeposit'] == null
              ? null
              : _i2.MonthlySubscriptionAICreditDeposit.fromJson(
                  (jsonSerialization['monthlySubscriptionAICreditDeposit']
                      as Map<String, dynamic>)),
      accountAIUsageId: jsonSerialization['accountAIUsageId'] as int,
      accountAIUsage: jsonSerialization['accountAIUsage'] == null
          ? null
          : _i3.AccountAIUsage.fromJson(
              (jsonSerialization['accountAIUsage'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime date;

  int? monthlySubscriptionAICreditDepositId;

  _i2.MonthlySubscriptionAICreditDeposit? monthlySubscriptionAICreditDeposit;

  int accountAIUsageId;

  _i3.AccountAIUsage? accountAIUsage;

  /// Returns a shallow copy of this [AICreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AICreditHistoryItem copyWith({
    int? id,
    DateTime? date,
    int? monthlySubscriptionAICreditDepositId,
    _i2.MonthlySubscriptionAICreditDeposit? monthlySubscriptionAICreditDeposit,
    int? accountAIUsageId,
    _i3.AccountAIUsage? accountAIUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date.toJson(),
      if (monthlySubscriptionAICreditDepositId != null)
        'monthlySubscriptionAICreditDepositId':
            monthlySubscriptionAICreditDepositId,
      if (monthlySubscriptionAICreditDeposit != null)
        'monthlySubscriptionAICreditDeposit':
            monthlySubscriptionAICreditDeposit?.toJson(),
      'accountAIUsageId': accountAIUsageId,
      if (accountAIUsage != null) 'accountAIUsage': accountAIUsage?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AICreditHistoryItemImpl extends AICreditHistoryItem {
  _AICreditHistoryItemImpl({
    int? id,
    required DateTime date,
    int? monthlySubscriptionAICreditDepositId,
    _i2.MonthlySubscriptionAICreditDeposit? monthlySubscriptionAICreditDeposit,
    required int accountAIUsageId,
    _i3.AccountAIUsage? accountAIUsage,
  }) : super._(
          id: id,
          date: date,
          monthlySubscriptionAICreditDepositId:
              monthlySubscriptionAICreditDepositId,
          monthlySubscriptionAICreditDeposit:
              monthlySubscriptionAICreditDeposit,
          accountAIUsageId: accountAIUsageId,
          accountAIUsage: accountAIUsage,
        );

  /// Returns a shallow copy of this [AICreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AICreditHistoryItem copyWith({
    Object? id = _Undefined,
    DateTime? date,
    Object? monthlySubscriptionAICreditDepositId = _Undefined,
    Object? monthlySubscriptionAICreditDeposit = _Undefined,
    int? accountAIUsageId,
    Object? accountAIUsage = _Undefined,
  }) {
    return AICreditHistoryItem(
      id: id is int? ? id : this.id,
      date: date ?? this.date,
      monthlySubscriptionAICreditDepositId:
          monthlySubscriptionAICreditDepositId is int?
              ? monthlySubscriptionAICreditDepositId
              : this.monthlySubscriptionAICreditDepositId,
      monthlySubscriptionAICreditDeposit: monthlySubscriptionAICreditDeposit
              is _i2.MonthlySubscriptionAICreditDeposit?
          ? monthlySubscriptionAICreditDeposit
          : this.monthlySubscriptionAICreditDeposit?.copyWith(),
      accountAIUsageId: accountAIUsageId ?? this.accountAIUsageId,
      accountAIUsage: accountAIUsage is _i3.AccountAIUsage?
          ? accountAIUsage
          : this.accountAIUsage?.copyWith(),
    );
  }
}
