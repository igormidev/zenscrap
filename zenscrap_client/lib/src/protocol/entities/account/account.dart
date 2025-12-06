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
import '../../entities/scrappable/scrappable.dart' as _i2;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i3;
import '../../entities/account/api_usage/account_api_usage.dart' as _i4;
import '../../entities/account/plan_tier.dart' as _i5;
import '../../entities/account/account_ai_usage.dart' as _i6;

abstract class AccountInfo implements _i1.SerializableModel {
  AccountInfo._({
    this.id,
    this.scrappables,
    required this.userInfoId,
    this.userInfo,
    required this.accountApiUsageId,
    this.accountApiUsage,
    required this.planTier,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
    this.subscriptionStatus,
    this.subscriptionEndDate,
    required this.accountAIUsageId,
    this.accountAIUsage,
  });

  factory AccountInfo({
    int? id,
    List<_i2.Scrappable>? scrappables,
    required int userInfoId,
    _i3.UserInfo? userInfo,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
    required _i5.PlanTier planTier,
    String? stripeCustomerId,
    String? stripeSubscriptionId,
    String? subscriptionStatus,
    DateTime? subscriptionEndDate,
    required int accountAIUsageId,
    _i6.AccountAIUsage? accountAIUsage,
  }) = _AccountInfoImpl;

  factory AccountInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountInfo(
      id: jsonSerialization['id'] as int?,
      scrappables: (jsonSerialization['scrappables'] as List?)
          ?.map((e) => _i2.Scrappable.fromJson((e as Map<String, dynamic>)))
          .toList(),
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i3.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
      accountApiUsageId: jsonSerialization['accountApiUsageId'] as int,
      accountApiUsage: jsonSerialization['accountApiUsage'] == null
          ? null
          : _i4.AccountApiUsage.fromJson(
              (jsonSerialization['accountApiUsage'] as Map<String, dynamic>)),
      planTier: _i5.PlanTier.fromJson((jsonSerialization['planTier'] as int)),
      stripeCustomerId: jsonSerialization['stripeCustomerId'] as String?,
      stripeSubscriptionId:
          jsonSerialization['stripeSubscriptionId'] as String?,
      subscriptionStatus: jsonSerialization['subscriptionStatus'] as String?,
      subscriptionEndDate: jsonSerialization['subscriptionEndDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['subscriptionEndDate']),
      accountAIUsageId: jsonSerialization['accountAIUsageId'] as int,
      accountAIUsage: jsonSerialization['accountAIUsage'] == null
          ? null
          : _i6.AccountAIUsage.fromJson(
              (jsonSerialization['accountAIUsage'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  List<_i2.Scrappable>? scrappables;

  int userInfoId;

  _i3.UserInfo? userInfo;

  int accountApiUsageId;

  _i4.AccountApiUsage? accountApiUsage;

  _i5.PlanTier planTier;

  String? stripeCustomerId;

  String? stripeSubscriptionId;

  String? subscriptionStatus;

  DateTime? subscriptionEndDate;

  int accountAIUsageId;

  _i6.AccountAIUsage? accountAIUsage;

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountInfo copyWith({
    int? id,
    List<_i2.Scrappable>? scrappables,
    int? userInfoId,
    _i3.UserInfo? userInfo,
    int? accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
    _i5.PlanTier? planTier,
    String? stripeCustomerId,
    String? stripeSubscriptionId,
    String? subscriptionStatus,
    DateTime? subscriptionEndDate,
    int? accountAIUsageId,
    _i6.AccountAIUsage? accountAIUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (scrappables != null)
        'scrappables': scrappables?.toJson(valueToJson: (v) => v.toJson()),
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
      'accountApiUsageId': accountApiUsageId,
      if (accountApiUsage != null) 'accountApiUsage': accountApiUsage?.toJson(),
      'planTier': planTier.toJson(),
      if (stripeCustomerId != null) 'stripeCustomerId': stripeCustomerId,
      if (stripeSubscriptionId != null)
        'stripeSubscriptionId': stripeSubscriptionId,
      if (subscriptionStatus != null) 'subscriptionStatus': subscriptionStatus,
      if (subscriptionEndDate != null)
        'subscriptionEndDate': subscriptionEndDate?.toJson(),
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

class _AccountInfoImpl extends AccountInfo {
  _AccountInfoImpl({
    int? id,
    List<_i2.Scrappable>? scrappables,
    required int userInfoId,
    _i3.UserInfo? userInfo,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
    required _i5.PlanTier planTier,
    String? stripeCustomerId,
    String? stripeSubscriptionId,
    String? subscriptionStatus,
    DateTime? subscriptionEndDate,
    required int accountAIUsageId,
    _i6.AccountAIUsage? accountAIUsage,
  }) : super._(
          id: id,
          scrappables: scrappables,
          userInfoId: userInfoId,
          userInfo: userInfo,
          accountApiUsageId: accountApiUsageId,
          accountApiUsage: accountApiUsage,
          planTier: planTier,
          stripeCustomerId: stripeCustomerId,
          stripeSubscriptionId: stripeSubscriptionId,
          subscriptionStatus: subscriptionStatus,
          subscriptionEndDate: subscriptionEndDate,
          accountAIUsageId: accountAIUsageId,
          accountAIUsage: accountAIUsage,
        );

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountInfo copyWith({
    Object? id = _Undefined,
    Object? scrappables = _Undefined,
    int? userInfoId,
    Object? userInfo = _Undefined,
    int? accountApiUsageId,
    Object? accountApiUsage = _Undefined,
    _i5.PlanTier? planTier,
    Object? stripeCustomerId = _Undefined,
    Object? stripeSubscriptionId = _Undefined,
    Object? subscriptionStatus = _Undefined,
    Object? subscriptionEndDate = _Undefined,
    int? accountAIUsageId,
    Object? accountAIUsage = _Undefined,
  }) {
    return AccountInfo(
      id: id is int? ? id : this.id,
      scrappables: scrappables is List<_i2.Scrappable>?
          ? scrappables
          : this.scrappables?.map((e0) => e0.copyWith()).toList(),
      userInfoId: userInfoId ?? this.userInfoId,
      userInfo:
          userInfo is _i3.UserInfo? ? userInfo : this.userInfo?.copyWith(),
      accountApiUsageId: accountApiUsageId ?? this.accountApiUsageId,
      accountApiUsage: accountApiUsage is _i4.AccountApiUsage?
          ? accountApiUsage
          : this.accountApiUsage?.copyWith(),
      planTier: planTier ?? this.planTier,
      stripeCustomerId: stripeCustomerId is String?
          ? stripeCustomerId
          : this.stripeCustomerId,
      stripeSubscriptionId: stripeSubscriptionId is String?
          ? stripeSubscriptionId
          : this.stripeSubscriptionId,
      subscriptionStatus: subscriptionStatus is String?
          ? subscriptionStatus
          : this.subscriptionStatus,
      subscriptionEndDate: subscriptionEndDate is DateTime?
          ? subscriptionEndDate
          : this.subscriptionEndDate,
      accountAIUsageId: accountAIUsageId ?? this.accountAIUsageId,
      accountAIUsage: accountAIUsage is _i6.AccountAIUsage?
          ? accountAIUsage
          : this.accountAIUsage?.copyWith(),
    );
  }
}
