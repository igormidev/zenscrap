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
import '../../../../entities/account/api_usage/api_creadit_history/monthly_subscription_credit_deposit.dart'
    as _i2;
import '../../../../entities/account/api_usage/api_creadit_history/credit_package_purchase.dart'
    as _i3;
import '../../../../entities/account/api_usage/account_api_usage.dart' as _i4;

abstract class CreditHistoryItem implements _i1.SerializableModel {
  CreditHistoryItem._({
    this.id,
    this.monthlySubscriptionCreditDepositId,
    this.monthlySubscriptionCreditDeposit,
    this.creaditPackagePurchaseId,
    this.creaditPackagePurchase,
    required this.accountApiUsageId,
    this.accountApiUsage,
  });

  factory CreditHistoryItem({
    int? id,
    int? monthlySubscriptionCreditDepositId,
    _i2.MonthlySubscriptionCreditDeposit? monthlySubscriptionCreditDeposit,
    int? creaditPackagePurchaseId,
    _i3.CreditPackagePurchase? creaditPackagePurchase,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  }) = _CreditHistoryItemImpl;

  factory CreditHistoryItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CreditHistoryItem(
      id: jsonSerialization['id'] as int?,
      monthlySubscriptionCreditDepositId:
          jsonSerialization['monthlySubscriptionCreditDepositId'] as int?,
      monthlySubscriptionCreditDeposit:
          jsonSerialization['monthlySubscriptionCreditDeposit'] == null
              ? null
              : _i2.MonthlySubscriptionCreditDeposit.fromJson(
                  (jsonSerialization['monthlySubscriptionCreditDeposit']
                      as Map<String, dynamic>)),
      creaditPackagePurchaseId:
          jsonSerialization['creaditPackagePurchaseId'] as int?,
      creaditPackagePurchase:
          jsonSerialization['creaditPackagePurchase'] == null
              ? null
              : _i3.CreditPackagePurchase.fromJson(
                  (jsonSerialization['creaditPackagePurchase']
                      as Map<String, dynamic>)),
      accountApiUsageId: jsonSerialization['accountApiUsageId'] as int,
      accountApiUsage: jsonSerialization['accountApiUsage'] == null
          ? null
          : _i4.AccountApiUsage.fromJson(
              (jsonSerialization['accountApiUsage'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? monthlySubscriptionCreditDepositId;

  _i2.MonthlySubscriptionCreditDeposit? monthlySubscriptionCreditDeposit;

  int? creaditPackagePurchaseId;

  _i3.CreditPackagePurchase? creaditPackagePurchase;

  int accountApiUsageId;

  _i4.AccountApiUsage? accountApiUsage;

  /// Returns a shallow copy of this [CreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CreditHistoryItem copyWith({
    int? id,
    int? monthlySubscriptionCreditDepositId,
    _i2.MonthlySubscriptionCreditDeposit? monthlySubscriptionCreditDeposit,
    int? creaditPackagePurchaseId,
    _i3.CreditPackagePurchase? creaditPackagePurchase,
    int? accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (monthlySubscriptionCreditDepositId != null)
        'monthlySubscriptionCreditDepositId':
            monthlySubscriptionCreditDepositId,
      if (monthlySubscriptionCreditDeposit != null)
        'monthlySubscriptionCreditDeposit':
            monthlySubscriptionCreditDeposit?.toJson(),
      if (creaditPackagePurchaseId != null)
        'creaditPackagePurchaseId': creaditPackagePurchaseId,
      if (creaditPackagePurchase != null)
        'creaditPackagePurchase': creaditPackagePurchase?.toJson(),
      'accountApiUsageId': accountApiUsageId,
      if (accountApiUsage != null) 'accountApiUsage': accountApiUsage?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreditHistoryItemImpl extends CreditHistoryItem {
  _CreditHistoryItemImpl({
    int? id,
    int? monthlySubscriptionCreditDepositId,
    _i2.MonthlySubscriptionCreditDeposit? monthlySubscriptionCreditDeposit,
    int? creaditPackagePurchaseId,
    _i3.CreditPackagePurchase? creaditPackagePurchase,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  }) : super._(
          id: id,
          monthlySubscriptionCreditDepositId:
              monthlySubscriptionCreditDepositId,
          monthlySubscriptionCreditDeposit: monthlySubscriptionCreditDeposit,
          creaditPackagePurchaseId: creaditPackagePurchaseId,
          creaditPackagePurchase: creaditPackagePurchase,
          accountApiUsageId: accountApiUsageId,
          accountApiUsage: accountApiUsage,
        );

  /// Returns a shallow copy of this [CreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CreditHistoryItem copyWith({
    Object? id = _Undefined,
    Object? monthlySubscriptionCreditDepositId = _Undefined,
    Object? monthlySubscriptionCreditDeposit = _Undefined,
    Object? creaditPackagePurchaseId = _Undefined,
    Object? creaditPackagePurchase = _Undefined,
    int? accountApiUsageId,
    Object? accountApiUsage = _Undefined,
  }) {
    return CreditHistoryItem(
      id: id is int? ? id : this.id,
      monthlySubscriptionCreditDepositId:
          monthlySubscriptionCreditDepositId is int?
              ? monthlySubscriptionCreditDepositId
              : this.monthlySubscriptionCreditDepositId,
      monthlySubscriptionCreditDeposit: monthlySubscriptionCreditDeposit
              is _i2.MonthlySubscriptionCreditDeposit?
          ? monthlySubscriptionCreditDeposit
          : this.monthlySubscriptionCreditDeposit?.copyWith(),
      creaditPackagePurchaseId: creaditPackagePurchaseId is int?
          ? creaditPackagePurchaseId
          : this.creaditPackagePurchaseId,
      creaditPackagePurchase:
          creaditPackagePurchase is _i3.CreditPackagePurchase?
              ? creaditPackagePurchase
              : this.creaditPackagePurchase?.copyWith(),
      accountApiUsageId: accountApiUsageId ?? this.accountApiUsageId,
      accountApiUsage: accountApiUsage is _i4.AccountApiUsage?
          ? accountApiUsage
          : this.accountApiUsage?.copyWith(),
    );
  }
}
