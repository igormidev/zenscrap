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
import '../../../../entities/account/plan_tier.dart' as _i2;

abstract class MonthlySubscriptionAICreditDeposit
    implements _i1.SerializableModel {
  MonthlySubscriptionAICreditDeposit._({
    this.id,
    required this.creditsAmountInDollars,
    required this.planTier,
  });

  factory MonthlySubscriptionAICreditDeposit({
    int? id,
    required double creditsAmountInDollars,
    required _i2.PlanTier planTier,
  }) = _MonthlySubscriptionAICreditDepositImpl;

  factory MonthlySubscriptionAICreditDeposit.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return MonthlySubscriptionAICreditDeposit(
      id: jsonSerialization['id'] as int?,
      creditsAmountInDollars:
          (jsonSerialization['creditsAmountInDollars'] as num).toDouble(),
      planTier: _i2.PlanTier.fromJson((jsonSerialization['planTier'] as int)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  double creditsAmountInDollars;

  _i2.PlanTier planTier;

  /// Returns a shallow copy of this [MonthlySubscriptionAICreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonthlySubscriptionAICreditDeposit copyWith({
    int? id,
    double? creditsAmountInDollars,
    _i2.PlanTier? planTier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'creditsAmountInDollars': creditsAmountInDollars,
      'planTier': planTier.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MonthlySubscriptionAICreditDepositImpl
    extends MonthlySubscriptionAICreditDeposit {
  _MonthlySubscriptionAICreditDepositImpl({
    int? id,
    required double creditsAmountInDollars,
    required _i2.PlanTier planTier,
  }) : super._(
          id: id,
          creditsAmountInDollars: creditsAmountInDollars,
          planTier: planTier,
        );

  /// Returns a shallow copy of this [MonthlySubscriptionAICreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonthlySubscriptionAICreditDeposit copyWith({
    Object? id = _Undefined,
    double? creditsAmountInDollars,
    _i2.PlanTier? planTier,
  }) {
    return MonthlySubscriptionAICreditDeposit(
      id: id is int? ? id : this.id,
      creditsAmountInDollars:
          creditsAmountInDollars ?? this.creditsAmountInDollars,
      planTier: planTier ?? this.planTier,
    );
  }
}
