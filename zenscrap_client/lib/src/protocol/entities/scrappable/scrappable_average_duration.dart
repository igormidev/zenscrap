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

abstract class ScrappableAverageDuration implements _i1.SerializableModel {
  ScrappableAverageDuration._({
    this.id,
    required this.updatedAt,
    required this.averageDuration,
  });

  factory ScrappableAverageDuration({
    int? id,
    required DateTime updatedAt,
    required Duration averageDuration,
  }) = _ScrappableAverageDurationImpl;

  factory ScrappableAverageDuration.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ScrappableAverageDuration(
      id: jsonSerialization['id'] as int?,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      averageDuration: _i1.DurationJsonExtension.fromJson(
        jsonSerialization['averageDuration'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime updatedAt;

  Duration averageDuration;

  /// Returns a shallow copy of this [ScrappableAverageDuration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableAverageDuration copyWith({
    int? id,
    DateTime? updatedAt,
    Duration? averageDuration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScrappableAverageDuration',
      if (id != null) 'id': id,
      'updatedAt': updatedAt.toJson(),
      'averageDuration': averageDuration.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableAverageDurationImpl extends ScrappableAverageDuration {
  _ScrappableAverageDurationImpl({
    int? id,
    required DateTime updatedAt,
    required Duration averageDuration,
  }) : super._(
         id: id,
         updatedAt: updatedAt,
         averageDuration: averageDuration,
       );

  /// Returns a shallow copy of this [ScrappableAverageDuration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableAverageDuration copyWith({
    Object? id = _Undefined,
    DateTime? updatedAt,
    Duration? averageDuration,
  }) {
    return ScrappableAverageDuration(
      id: id is int? ? id : this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      averageDuration: averageDuration ?? this.averageDuration,
    );
  }
}
