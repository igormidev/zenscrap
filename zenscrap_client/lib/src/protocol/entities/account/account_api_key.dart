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

abstract class AccountApiKey implements _i1.SerializableModel {
  AccountApiKey._({
    this.id,
    required this.apiKey,
  });

  factory AccountApiKey({
    int? id,
    required String apiKey,
  }) = _AccountApiKeyImpl;

  factory AccountApiKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountApiKey(
      id: jsonSerialization['id'] as int?,
      apiKey: jsonSerialization['apiKey'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String apiKey;

  /// Returns a shallow copy of this [AccountApiKey]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountApiKey copyWith({
    int? id,
    String? apiKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'apiKey': apiKey,
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
  }) : super._(
          id: id,
          apiKey: apiKey,
        );

  /// Returns a shallow copy of this [AccountApiKey]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountApiKey copyWith({
    Object? id = _Undefined,
    String? apiKey,
  }) {
    return AccountApiKey(
      id: id is int? ? id : this.id,
      apiKey: apiKey ?? this.apiKey,
    );
  }
}
