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
import '../../../entities/account/api_usage/account_api_usage.dart' as _i2;

abstract class CreditUsage implements _i1.SerializableModel {
  CreditUsage._({
    this.id,
    required this.subscriptionCredits,
    required this.purchasedCredits,
    this.accountApiUsage,
  });

  factory CreditUsage({
    int? id,
    required int subscriptionCredits,
    required int purchasedCredits,
    _i2.AccountApiUsage? accountApiUsage,
  }) = _CreditUsageImpl;

  factory CreditUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return CreditUsage(
      id: jsonSerialization['id'] as int?,
      subscriptionCredits: jsonSerialization['subscriptionCredits'] as int,
      purchasedCredits: jsonSerialization['purchasedCredits'] as int,
      accountApiUsage: jsonSerialization['accountApiUsage'] == null
          ? null
          : _i2.AccountApiUsage.fromJson(
              (jsonSerialization['accountApiUsage'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int subscriptionCredits;

  int purchasedCredits;

  _i2.AccountApiUsage? accountApiUsage;

  /// Returns a shallow copy of this [CreditUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CreditUsage copyWith({
    int? id,
    int? subscriptionCredits,
    int? purchasedCredits,
    _i2.AccountApiUsage? accountApiUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'subscriptionCredits': subscriptionCredits,
      'purchasedCredits': purchasedCredits,
      if (accountApiUsage != null) 'accountApiUsage': accountApiUsage?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreditUsageImpl extends CreditUsage {
  _CreditUsageImpl({
    int? id,
    required int subscriptionCredits,
    required int purchasedCredits,
    _i2.AccountApiUsage? accountApiUsage,
  }) : super._(
          id: id,
          subscriptionCredits: subscriptionCredits,
          purchasedCredits: purchasedCredits,
          accountApiUsage: accountApiUsage,
        );

  /// Returns a shallow copy of this [CreditUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CreditUsage copyWith({
    Object? id = _Undefined,
    int? subscriptionCredits,
    int? purchasedCredits,
    Object? accountApiUsage = _Undefined,
  }) {
    return CreditUsage(
      id: id is int? ? id : this.id,
      subscriptionCredits: subscriptionCredits ?? this.subscriptionCredits,
      purchasedCredits: purchasedCredits ?? this.purchasedCredits,
      accountApiUsage: accountApiUsage is _i2.AccountApiUsage?
          ? accountApiUsage
          : this.accountApiUsage?.copyWith(),
    );
  }
}
