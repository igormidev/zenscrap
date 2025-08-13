/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../zen_scrap_redraft_state.dart';

abstract class MessageTextAndNewExtractRulesResponse
    extends _i1.ZenScrapRedraftState
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  MessageTextAndNewExtractRulesResponse._({
    required super.role,
    required this.messageText,
    required this.newExtractRules,
  });

  factory MessageTextAndNewExtractRulesResponse({
    required _i3.PromptRole role,
    required String messageText,
    required String newExtractRules,
  }) = _MessageTextAndNewExtractRulesResponseImpl;

  factory MessageTextAndNewExtractRulesResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return MessageTextAndNewExtractRulesResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      messageText: jsonSerialization['messageText'] as String,
      newExtractRules: jsonSerialization['newExtractRules'] as String,
    );
  }

  String messageText;

  String newExtractRules;

  /// Returns a shallow copy of this [MessageTextAndNewExtractRulesResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  MessageTextAndNewExtractRulesResponse copyWith({
    _i3.PromptRole? role,
    String? messageText,
    String? newExtractRules,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'messageText': messageText,
      'newExtractRules': newExtractRules,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'role': role.toJson(),
      'messageText': messageText,
      'newExtractRules': newExtractRules,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _MessageTextAndNewExtractRulesResponseImpl
    extends MessageTextAndNewExtractRulesResponse {
  _MessageTextAndNewExtractRulesResponseImpl({
    required _i3.PromptRole role,
    required String messageText,
    required String newExtractRules,
  }) : super._(
          role: role,
          messageText: messageText,
          newExtractRules: newExtractRules,
        );

  /// Returns a shallow copy of this [MessageTextAndNewExtractRulesResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  MessageTextAndNewExtractRulesResponse copyWith({
    _i3.PromptRole? role,
    String? messageText,
    String? newExtractRules,
  }) {
    return MessageTextAndNewExtractRulesResponse(
      role: role ?? this.role,
      messageText: messageText ?? this.messageText,
      newExtractRules: newExtractRules ?? this.newExtractRules,
    );
  }
}
