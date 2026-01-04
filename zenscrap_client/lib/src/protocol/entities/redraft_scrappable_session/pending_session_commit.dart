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

abstract class PendingSessionCommit implements _i1.SerializableModel {
  PendingSessionCommit._({
    this.id,
    required this.sessionId,
    required this.scrappableId,
    required this.createdAt,
  });

  factory PendingSessionCommit({
    int? id,
    required String sessionId,
    required int scrappableId,
    required DateTime createdAt,
  }) = _PendingSessionCommitImpl;

  factory PendingSessionCommit.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PendingSessionCommit(
      id: jsonSerialization['id'] as int?,
      sessionId: jsonSerialization['sessionId'] as String,
      scrappableId: jsonSerialization['scrappableId'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String sessionId;

  int scrappableId;

  DateTime createdAt;

  /// Returns a shallow copy of this [PendingSessionCommit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PendingSessionCommit copyWith({
    int? id,
    String? sessionId,
    int? scrappableId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PendingSessionCommit',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'scrappableId': scrappableId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PendingSessionCommitImpl extends PendingSessionCommit {
  _PendingSessionCommitImpl({
    int? id,
    required String sessionId,
    required int scrappableId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         sessionId: sessionId,
         scrappableId: scrappableId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PendingSessionCommit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PendingSessionCommit copyWith({
    Object? id = _Undefined,
    String? sessionId,
    int? scrappableId,
    DateTime? createdAt,
  }) {
    return PendingSessionCommit(
      id: id is int? ? id : this.id,
      sessionId: sessionId ?? this.sessionId,
      scrappableId: scrappableId ?? this.scrappableId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
