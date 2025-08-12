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
import '../entities/scrappable_target_request.dart' as _i2;

abstract class Scrappable implements _i1.SerializableModel {
  Scrappable._({
    this.id,
    required this.name,
    required this.description,
    required this.scrappingRules,
    required this.isActive,
    this.targetRequest,
    required this.targetRequestId,
  });

  factory Scrappable({
    int? id,
    required String name,
    required String description,
    required String scrappingRules,
    required bool isActive,
    _i2.ScrappableTargetRequestStructure? targetRequest,
    required int targetRequestId,
  }) = _ScrappableImpl;

  factory Scrappable.fromJson(Map<String, dynamic> jsonSerialization) {
    return Scrappable(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      scrappingRules: jsonSerialization['scrappingRules'] as String,
      isActive: jsonSerialization['isActive'] as bool,
      targetRequest: jsonSerialization['targetRequest'] == null
          ? null
          : _i2.ScrappableTargetRequestStructure.fromJson(
              (jsonSerialization['targetRequest'] as Map<String, dynamic>)),
      targetRequestId: jsonSerialization['targetRequestId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String description;

  String scrappingRules;

  bool isActive;

  _i2.ScrappableTargetRequestStructure? targetRequest;

  int targetRequestId;

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Scrappable copyWith({
    int? id,
    String? name,
    String? description,
    String? scrappingRules,
    bool? isActive,
    _i2.ScrappableTargetRequestStructure? targetRequest,
    int? targetRequestId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'scrappingRules': scrappingRules,
      'isActive': isActive,
      if (targetRequest != null) 'targetRequest': targetRequest?.toJson(),
      'targetRequestId': targetRequestId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableImpl extends Scrappable {
  _ScrappableImpl({
    int? id,
    required String name,
    required String description,
    required String scrappingRules,
    required bool isActive,
    _i2.ScrappableTargetRequestStructure? targetRequest,
    required int targetRequestId,
  }) : super._(
          id: id,
          name: name,
          description: description,
          scrappingRules: scrappingRules,
          isActive: isActive,
          targetRequest: targetRequest,
          targetRequestId: targetRequestId,
        );

  /// Returns a shallow copy of this [Scrappable]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Scrappable copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    String? scrappingRules,
    bool? isActive,
    Object? targetRequest = _Undefined,
    int? targetRequestId,
  }) {
    return Scrappable(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      scrappingRules: scrappingRules ?? this.scrappingRules,
      isActive: isActive ?? this.isActive,
      targetRequest: targetRequest is _i2.ScrappableTargetRequestStructure?
          ? targetRequest
          : this.targetRequest?.copyWith(),
      targetRequestId: targetRequestId ?? this.targetRequestId,
    );
  }
}
