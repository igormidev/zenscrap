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

abstract class AnonymousIpSpending implements _i1.SerializableModel {
  AnonymousIpSpending._({
    this.id,
    required this.ipAddress,
    required this.totalSpentUsd,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory AnonymousIpSpending({
    int? id,
    required String ipAddress,
    required double totalSpentUsd,
    required DateTime createdAt,
    required DateTime lastUpdatedAt,
  }) = _AnonymousIpSpendingImpl;

  factory AnonymousIpSpending.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnonymousIpSpending(
      id: jsonSerialization['id'] as int?,
      ipAddress: jsonSerialization['ipAddress'] as String,
      totalSpentUsd: (jsonSerialization['totalSpentUsd'] as num).toDouble(),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastUpdatedAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['lastUpdatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String ipAddress;

  double totalSpentUsd;

  DateTime createdAt;

  DateTime lastUpdatedAt;

  /// Returns a shallow copy of this [AnonymousIpSpending]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnonymousIpSpending copyWith({
    int? id,
    String? ipAddress,
    double? totalSpentUsd,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'ipAddress': ipAddress,
      'totalSpentUsd': totalSpentUsd,
      'createdAt': createdAt.toJson(),
      'lastUpdatedAt': lastUpdatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnonymousIpSpendingImpl extends AnonymousIpSpending {
  _AnonymousIpSpendingImpl({
    int? id,
    required String ipAddress,
    required double totalSpentUsd,
    required DateTime createdAt,
    required DateTime lastUpdatedAt,
  }) : super._(
          id: id,
          ipAddress: ipAddress,
          totalSpentUsd: totalSpentUsd,
          createdAt: createdAt,
          lastUpdatedAt: lastUpdatedAt,
        );

  /// Returns a shallow copy of this [AnonymousIpSpending]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnonymousIpSpending copyWith({
    Object? id = _Undefined,
    String? ipAddress,
    double? totalSpentUsd,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return AnonymousIpSpending(
      id: id is int? ? id : this.id,
      ipAddress: ipAddress ?? this.ipAddress,
      totalSpentUsd: totalSpentUsd ?? this.totalSpentUsd,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
