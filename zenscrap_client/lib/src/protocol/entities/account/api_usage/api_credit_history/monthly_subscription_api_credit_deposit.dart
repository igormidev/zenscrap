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
import '../../../../entities/account/plan_tier.dart' as _i2;

abstract class MonthlySubscriptionApiCreditDeposit
    implements _i1.SerializableModel {
  MonthlySubscriptionApiCreditDeposit._({
    this.id,
    required this.creditsAmount,
    required this.planTier,
  });

  factory MonthlySubscriptionApiCreditDeposit({
    int? id,
    required int creditsAmount,
    required _i2.PlanTier planTier,
  }) = _MonthlySubscriptionApiCreditDepositImpl;

  factory MonthlySubscriptionApiCreditDeposit.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MonthlySubscriptionApiCreditDeposit(
      id: jsonSerialization['id'] as int?,
      creditsAmount: jsonSerialization['creditsAmount'] as int,
      planTier: _i2.PlanTier.fromJson((jsonSerialization['planTier'] as int)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int creditsAmount;

  _i2.PlanTier planTier;

  /// Returns a shallow copy of this [MonthlySubscriptionApiCreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonthlySubscriptionApiCreditDeposit copyWith({
    int? id,
    int? creditsAmount,
    _i2.PlanTier? planTier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MonthlySubscriptionApiCreditDeposit',
      if (id != null) 'id': id,
      'creditsAmount': creditsAmount,
      'planTier': planTier.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MonthlySubscriptionApiCreditDepositImpl
    extends MonthlySubscriptionApiCreditDeposit {
  _MonthlySubscriptionApiCreditDepositImpl({
    int? id,
    required int creditsAmount,
    required _i2.PlanTier planTier,
  }) : super._(
         id: id,
         creditsAmount: creditsAmount,
         planTier: planTier,
       );

  /// Returns a shallow copy of this [MonthlySubscriptionApiCreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonthlySubscriptionApiCreditDeposit copyWith({
    Object? id = _Undefined,
    int? creditsAmount,
    _i2.PlanTier? planTier,
  }) {
    return MonthlySubscriptionApiCreditDeposit(
      id: id is int? ? id : this.id,
      creditsAmount: creditsAmount ?? this.creditsAmount,
      planTier: planTier ?? this.planTier,
    );
  }
}
