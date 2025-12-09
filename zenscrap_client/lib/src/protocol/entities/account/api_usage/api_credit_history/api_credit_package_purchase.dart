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

abstract class ApiCreditPackagePurchase implements _i1.SerializableModel {
  ApiCreditPackagePurchase._({
    this.id,
    required this.value,
    this.stripePurchaseId,
  });

  factory ApiCreditPackagePurchase({
    int? id,
    required double value,
    String? stripePurchaseId,
  }) = _ApiCreditPackagePurchaseImpl;

  factory ApiCreditPackagePurchase.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ApiCreditPackagePurchase(
      id: jsonSerialization['id'] as int?,
      value: (jsonSerialization['value'] as num).toDouble(),
      stripePurchaseId: jsonSerialization['stripePurchaseId'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  double value;

  String? stripePurchaseId;

  /// Returns a shallow copy of this [ApiCreditPackagePurchase]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiCreditPackagePurchase copyWith({
    int? id,
    double? value,
    String? stripePurchaseId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiCreditPackagePurchase',
      if (id != null) 'id': id,
      'value': value,
      if (stripePurchaseId != null) 'stripePurchaseId': stripePurchaseId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiCreditPackagePurchaseImpl extends ApiCreditPackagePurchase {
  _ApiCreditPackagePurchaseImpl({
    int? id,
    required double value,
    String? stripePurchaseId,
  }) : super._(
         id: id,
         value: value,
         stripePurchaseId: stripePurchaseId,
       );

  /// Returns a shallow copy of this [ApiCreditPackagePurchase]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiCreditPackagePurchase copyWith({
    Object? id = _Undefined,
    double? value,
    Object? stripePurchaseId = _Undefined,
  }) {
    return ApiCreditPackagePurchase(
      id: id is int? ? id : this.id,
      value: value ?? this.value,
      stripePurchaseId: stripePurchaseId is String?
          ? stripePurchaseId
          : this.stripePurchaseId,
    );
  }
}
