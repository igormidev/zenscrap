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
import '../../../../entities/account/api_usage/api_credit_history/monthly_subscription_api_credit_deposit.dart'
    as _i2;
import '../../../../entities/account/api_usage/api_credit_history/api_credit_package_purchase.dart'
    as _i3;
import '../../../../entities/account/api_usage/account_api_usage.dart' as _i4;

abstract class ApiCreditHistoryItem implements _i1.SerializableModel {
  ApiCreditHistoryItem._({
    this.id,
    required this.date,
    this.monthlySubscriptionApiCreditDepositId,
    this.monthlySubscriptionApiCreditDeposit,
    this.apiCreditPackagePurchaseId,
    this.apiCreditPackagePurchase,
    required this.accountApiUsageId,
    this.accountApiUsage,
  });

  factory ApiCreditHistoryItem({
    int? id,
    required DateTime date,
    int? monthlySubscriptionApiCreditDepositId,
    _i2.MonthlySubscriptionApiCreditDeposit?
        monthlySubscriptionApiCreditDeposit,
    int? apiCreditPackagePurchaseId,
    _i3.ApiCreditPackagePurchase? apiCreditPackagePurchase,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  }) = _ApiCreditHistoryItemImpl;

  factory ApiCreditHistoryItem.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ApiCreditHistoryItem(
      id: jsonSerialization['id'] as int?,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      monthlySubscriptionApiCreditDepositId:
          jsonSerialization['monthlySubscriptionApiCreditDepositId'] as int?,
      monthlySubscriptionApiCreditDeposit:
          jsonSerialization['monthlySubscriptionApiCreditDeposit'] == null
              ? null
              : _i2.MonthlySubscriptionApiCreditDeposit.fromJson(
                  (jsonSerialization['monthlySubscriptionApiCreditDeposit']
                      as Map<String, dynamic>)),
      apiCreditPackagePurchaseId:
          jsonSerialization['apiCreditPackagePurchaseId'] as int?,
      apiCreditPackagePurchase:
          jsonSerialization['apiCreditPackagePurchase'] == null
              ? null
              : _i3.ApiCreditPackagePurchase.fromJson(
                  (jsonSerialization['apiCreditPackagePurchase']
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

  DateTime date;

  int? monthlySubscriptionApiCreditDepositId;

  _i2.MonthlySubscriptionApiCreditDeposit? monthlySubscriptionApiCreditDeposit;

  int? apiCreditPackagePurchaseId;

  _i3.ApiCreditPackagePurchase? apiCreditPackagePurchase;

  int accountApiUsageId;

  _i4.AccountApiUsage? accountApiUsage;

  /// Returns a shallow copy of this [ApiCreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiCreditHistoryItem copyWith({
    int? id,
    DateTime? date,
    int? monthlySubscriptionApiCreditDepositId,
    _i2.MonthlySubscriptionApiCreditDeposit?
        monthlySubscriptionApiCreditDeposit,
    int? apiCreditPackagePurchaseId,
    _i3.ApiCreditPackagePurchase? apiCreditPackagePurchase,
    int? accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date.toJson(),
      if (monthlySubscriptionApiCreditDepositId != null)
        'monthlySubscriptionApiCreditDepositId':
            monthlySubscriptionApiCreditDepositId,
      if (monthlySubscriptionApiCreditDeposit != null)
        'monthlySubscriptionApiCreditDeposit':
            monthlySubscriptionApiCreditDeposit?.toJson(),
      if (apiCreditPackagePurchaseId != null)
        'apiCreditPackagePurchaseId': apiCreditPackagePurchaseId,
      if (apiCreditPackagePurchase != null)
        'apiCreditPackagePurchase': apiCreditPackagePurchase?.toJson(),
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

class _ApiCreditHistoryItemImpl extends ApiCreditHistoryItem {
  _ApiCreditHistoryItemImpl({
    int? id,
    required DateTime date,
    int? monthlySubscriptionApiCreditDepositId,
    _i2.MonthlySubscriptionApiCreditDeposit?
        monthlySubscriptionApiCreditDeposit,
    int? apiCreditPackagePurchaseId,
    _i3.ApiCreditPackagePurchase? apiCreditPackagePurchase,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  }) : super._(
          id: id,
          date: date,
          monthlySubscriptionApiCreditDepositId:
              monthlySubscriptionApiCreditDepositId,
          monthlySubscriptionApiCreditDeposit:
              monthlySubscriptionApiCreditDeposit,
          apiCreditPackagePurchaseId: apiCreditPackagePurchaseId,
          apiCreditPackagePurchase: apiCreditPackagePurchase,
          accountApiUsageId: accountApiUsageId,
          accountApiUsage: accountApiUsage,
        );

  /// Returns a shallow copy of this [ApiCreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiCreditHistoryItem copyWith({
    Object? id = _Undefined,
    DateTime? date,
    Object? monthlySubscriptionApiCreditDepositId = _Undefined,
    Object? monthlySubscriptionApiCreditDeposit = _Undefined,
    Object? apiCreditPackagePurchaseId = _Undefined,
    Object? apiCreditPackagePurchase = _Undefined,
    int? accountApiUsageId,
    Object? accountApiUsage = _Undefined,
  }) {
    return ApiCreditHistoryItem(
      id: id is int? ? id : this.id,
      date: date ?? this.date,
      monthlySubscriptionApiCreditDepositId:
          monthlySubscriptionApiCreditDepositId is int?
              ? monthlySubscriptionApiCreditDepositId
              : this.monthlySubscriptionApiCreditDepositId,
      monthlySubscriptionApiCreditDeposit: monthlySubscriptionApiCreditDeposit
              is _i2.MonthlySubscriptionApiCreditDeposit?
          ? monthlySubscriptionApiCreditDeposit
          : this.monthlySubscriptionApiCreditDeposit?.copyWith(),
      apiCreditPackagePurchaseId: apiCreditPackagePurchaseId is int?
          ? apiCreditPackagePurchaseId
          : this.apiCreditPackagePurchaseId,
      apiCreditPackagePurchase:
          apiCreditPackagePurchase is _i3.ApiCreditPackagePurchase?
              ? apiCreditPackagePurchase
              : this.apiCreditPackagePurchase?.copyWith(),
      accountApiUsageId: accountApiUsageId ?? this.accountApiUsageId,
      accountApiUsage: accountApiUsage is _i4.AccountApiUsage?
          ? accountApiUsage
          : this.accountApiUsage?.copyWith(),
    );
  }
}
