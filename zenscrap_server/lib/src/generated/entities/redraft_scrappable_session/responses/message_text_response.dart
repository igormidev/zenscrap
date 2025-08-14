/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../zen_scrap_redraft_state.dart';

abstract class MessageTextResponse extends _i1.ChatResponse
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  MessageTextResponse._({
    required super.role,
    required this.messageText,
  });

  factory MessageTextResponse({
    required _i3.PromptRole role,
    required String messageText,
  }) = _MessageTextResponseImpl;

  factory MessageTextResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return MessageTextResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      messageText: jsonSerialization['messageText'] as String,
    );
  }

  String messageText;

  /// Returns a shallow copy of this [MessageTextResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  MessageTextResponse copyWith({
    _i3.PromptRole? role,
    String? messageText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'messageText': messageText,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'role': role.toJson(),
      'messageText': messageText,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _MessageTextResponseImpl extends MessageTextResponse {
  _MessageTextResponseImpl({
    required _i3.PromptRole role,
    required String messageText,
  }) : super._(
          role: role,
          messageText: messageText,
        );

  /// Returns a shallow copy of this [MessageTextResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  MessageTextResponse copyWith({
    _i3.PromptRole? role,
    String? messageText,
  }) {
    return MessageTextResponse(
      role: role ?? this.role,
      messageText: messageText ?? this.messageText,
    );
  }
}
