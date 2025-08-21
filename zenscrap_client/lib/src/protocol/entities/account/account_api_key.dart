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
import '../../entities/account/api_usage/account_api_usage.dart' as _i2;

abstract class AccountApiKey implements _i1.SerializableModel {
  AccountApiKey._({
    this.id,
    required this.apiKey,
    required this.name,
    required this.createdAt,
    required this.accountApiUsageId,
    this.accountApiUsage,
  });

  factory AccountApiKey({
    int? id,
    required String apiKey,
    required String name,
    required DateTime createdAt,
    required int accountApiUsageId,
    _i2.AccountApiUsage? accountApiUsage,
  }) = _AccountApiKeyImpl;

  factory AccountApiKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountApiKey(
      id: jsonSerialization['id'] as int?,
      apiKey: jsonSerialization['apiKey'] as String,
      name: jsonSerialization['name'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      accountApiUsageId: jsonSerialization['accountApiUsageId'] as int,
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

  String apiKey;

  String name;

  DateTime createdAt;

  int accountApiUsageId;

  _i2.AccountApiUsage? accountApiUsage;

  /// Returns a shallow copy of this [AccountApiKey]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountApiKey copyWith({
    int? id,
    String? apiKey,
    String? name,
    DateTime? createdAt,
    int? accountApiUsageId,
    _i2.AccountApiUsage? accountApiUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'apiKey': apiKey,
      'name': name,
      'createdAt': createdAt.toJson(),
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

class _AccountApiKeyImpl extends AccountApiKey {
  _AccountApiKeyImpl({
    int? id,
    required String apiKey,
    required String name,
    required DateTime createdAt,
    required int accountApiUsageId,
    _i2.AccountApiUsage? accountApiUsage,
  }) : super._(
          id: id,
          apiKey: apiKey,
          name: name,
          createdAt: createdAt,
          accountApiUsageId: accountApiUsageId,
          accountApiUsage: accountApiUsage,
        );

  /// Returns a shallow copy of this [AccountApiKey]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountApiKey copyWith({
    Object? id = _Undefined,
    String? apiKey,
    String? name,
    DateTime? createdAt,
    int? accountApiUsageId,
    Object? accountApiUsage = _Undefined,
  }) {
    return AccountApiKey(
      id: id is int? ? id : this.id,
      apiKey: apiKey ?? this.apiKey,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      accountApiUsageId: accountApiUsageId ?? this.accountApiUsageId,
      accountApiUsage: accountApiUsage is _i2.AccountApiUsage?
          ? accountApiUsage
          : this.accountApiUsage?.copyWith(),
    );
  }
}
