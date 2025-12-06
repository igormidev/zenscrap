/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../chat_response.dart';

abstract class ApiKeyUpdatedResponse extends _i1.ChatResponse
    implements _i2.SerializableModel {
  ApiKeyUpdatedResponse._({
    required super.role,
    required super.expectsFollowUp,
    required this.messageText,
  });

  factory ApiKeyUpdatedResponse({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
  }) = _ApiKeyUpdatedResponseImpl;

  factory ApiKeyUpdatedResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ApiKeyUpdatedResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      messageText: jsonSerialization['messageText'] as String,
    );
  }

  String messageText;

  /// Returns a shallow copy of this [ApiKeyUpdatedResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  ApiKeyUpdatedResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _ApiKeyUpdatedResponseImpl extends ApiKeyUpdatedResponse {
  _ApiKeyUpdatedResponseImpl({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
  }) : super._(
          role: role,
          expectsFollowUp: expectsFollowUp,
          messageText: messageText,
        );

  /// Returns a shallow copy of this [ApiKeyUpdatedResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ApiKeyUpdatedResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
  }) {
    return ApiKeyUpdatedResponse(
      role: role ?? this.role,
      expectsFollowUp: expectsFollowUp ?? this.expectsFollowUp,
      messageText: messageText ?? this.messageText,
    );
  }
}
