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

abstract class MonthlySubscriptionCreditDeposit
    implements _i1.SerializableModel {
  MonthlySubscriptionCreditDeposit._({
    this.id,
    required this.value,
  });

  factory MonthlySubscriptionCreditDeposit({
    int? id,
    required double value,
  }) = _MonthlySubscriptionCreditDepositImpl;

  factory MonthlySubscriptionCreditDeposit.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return MonthlySubscriptionCreditDeposit(
      id: jsonSerialization['id'] as int?,
      value: (jsonSerialization['value'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  double value;

  /// Returns a shallow copy of this [MonthlySubscriptionCreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonthlySubscriptionCreditDeposit copyWith({
    int? id,
    double? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'value': value,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MonthlySubscriptionCreditDepositImpl
    extends MonthlySubscriptionCreditDeposit {
  _MonthlySubscriptionCreditDepositImpl({
    int? id,
    required double value,
  }) : super._(
          id: id,
          value: value,
        );

  /// Returns a shallow copy of this [MonthlySubscriptionCreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonthlySubscriptionCreditDeposit copyWith({
    Object? id = _Undefined,
    double? value,
  }) {
    return MonthlySubscriptionCreditDeposit(
      id: id is int? ? id : this.id,
      value: value ?? this.value,
    );
  }
}
