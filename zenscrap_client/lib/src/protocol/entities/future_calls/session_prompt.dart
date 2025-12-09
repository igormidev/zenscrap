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

abstract class SessionPrompt implements _i1.SerializableModel {
  SessionPrompt._({
    required this.userPrompt,
    required this.sessionId,
    required this.thinkingSessionId,
    this.clientIpAddress,
  });

  factory SessionPrompt({
    required String userPrompt,
    required String sessionId,
    required String thinkingSessionId,
    String? clientIpAddress,
  }) = _SessionPromptImpl;

  factory SessionPrompt.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionPrompt(
      userPrompt: jsonSerialization['userPrompt'] as String,
      sessionId: jsonSerialization['sessionId'] as String,
      thinkingSessionId: jsonSerialization['thinkingSessionId'] as String,
      clientIpAddress: jsonSerialization['clientIpAddress'] as String?,
    );
  }

  String userPrompt;

  String sessionId;

  String thinkingSessionId;

  String? clientIpAddress;

  /// Returns a shallow copy of this [SessionPrompt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SessionPrompt copyWith({
    String? userPrompt,
    String? sessionId,
    String? thinkingSessionId,
    String? clientIpAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'userPrompt': userPrompt,
      'sessionId': sessionId,
      'thinkingSessionId': thinkingSessionId,
      if (clientIpAddress != null) 'clientIpAddress': clientIpAddress,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionPromptImpl extends SessionPrompt {
  _SessionPromptImpl({
    required String userPrompt,
    required String sessionId,
    required String thinkingSessionId,
    String? clientIpAddress,
  }) : super._(
          userPrompt: userPrompt,
          sessionId: sessionId,
          thinkingSessionId: thinkingSessionId,
          clientIpAddress: clientIpAddress,
        );

  /// Returns a shallow copy of this [SessionPrompt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SessionPrompt copyWith({
    String? userPrompt,
    String? sessionId,
    String? thinkingSessionId,
    Object? clientIpAddress = _Undefined,
  }) {
    return SessionPrompt(
      userPrompt: userPrompt ?? this.userPrompt,
      sessionId: sessionId ?? this.sessionId,
      thinkingSessionId: thinkingSessionId ?? this.thinkingSessionId,
      clientIpAddress:
          clientIpAddress is String? ? clientIpAddress : this.clientIpAddress,
    );
  }
}
