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

abstract class CreateSessionResponse implements _i1.SerializableModel {
  CreateSessionResponse._({
    required this.sessionId,
    required this.expiresIn,
  });

  factory CreateSessionResponse({
    required String sessionId,
    required Duration expiresIn,
  }) = _CreateSessionResponseImpl;

  factory CreateSessionResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return CreateSessionResponse(
      sessionId: jsonSerialization['sessionId'] as String,
      expiresIn:
          _i1.DurationJsonExtension.fromJson(jsonSerialization['expiresIn']),
    );
  }

  String sessionId;

  Duration expiresIn;

  /// Returns a shallow copy of this [CreateSessionResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CreateSessionResponse copyWith({
    String? sessionId,
    Duration? expiresIn,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'expiresIn': expiresIn.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CreateSessionResponseImpl extends CreateSessionResponse {
  _CreateSessionResponseImpl({
    required String sessionId,
    required Duration expiresIn,
  }) : super._(
          sessionId: sessionId,
          expiresIn: expiresIn,
        );

  /// Returns a shallow copy of this [CreateSessionResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CreateSessionResponse copyWith({
    String? sessionId,
    Duration? expiresIn,
  }) {
    return CreateSessionResponse(
      sessionId: sessionId ?? this.sessionId,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }
}
