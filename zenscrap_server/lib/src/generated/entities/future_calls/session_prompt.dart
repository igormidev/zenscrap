/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class SessionPrompt
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SessionPrompt._({
    required this.userPrompt,
    required this.sessionId,
    required this.thinkingSessionId,
  });

  factory SessionPrompt({
    required String userPrompt,
    required String sessionId,
    required String thinkingSessionId,
  }) = _SessionPromptImpl;

  factory SessionPrompt.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionPrompt(
      userPrompt: jsonSerialization['userPrompt'] as String,
      sessionId: jsonSerialization['sessionId'] as String,
      thinkingSessionId: jsonSerialization['thinkingSessionId'] as String,
    );
  }

  String userPrompt;

  String sessionId;

  String thinkingSessionId;

  /// Returns a shallow copy of this [SessionPrompt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SessionPrompt copyWith({
    String? userPrompt,
    String? sessionId,
    String? thinkingSessionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'userPrompt': userPrompt,
      'sessionId': sessionId,
      'thinkingSessionId': thinkingSessionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'userPrompt': userPrompt,
      'sessionId': sessionId,
      'thinkingSessionId': thinkingSessionId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SessionPromptImpl extends SessionPrompt {
  _SessionPromptImpl({
    required String userPrompt,
    required String sessionId,
    required String thinkingSessionId,
  }) : super._(
          userPrompt: userPrompt,
          sessionId: sessionId,
          thinkingSessionId: thinkingSessionId,
        );

  /// Returns a shallow copy of this [SessionPrompt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SessionPrompt copyWith({
    String? userPrompt,
    String? sessionId,
    String? thinkingSessionId,
  }) {
    return SessionPrompt(
      userPrompt: userPrompt ?? this.userPrompt,
      sessionId: sessionId ?? this.sessionId,
      thinkingSessionId: thinkingSessionId ?? this.thinkingSessionId,
    );
  }
}
