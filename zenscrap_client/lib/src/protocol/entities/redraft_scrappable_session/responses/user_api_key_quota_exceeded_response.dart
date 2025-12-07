/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../chat_response.dart';

abstract class UserApiKeyQuotaExceededResponse extends _i1.ChatResponse
    implements _i2.SerializableModel {
  UserApiKeyQuotaExceededResponse._({
    required super.role,
    required super.expectsFollowUp,
    required this.messageText,
    this.openAiErrorMessage,
  });

  factory UserApiKeyQuotaExceededResponse({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    String? openAiErrorMessage,
  }) = _UserApiKeyQuotaExceededResponseImpl;

  factory UserApiKeyQuotaExceededResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return UserApiKeyQuotaExceededResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      messageText: jsonSerialization['messageText'] as String,
      openAiErrorMessage: jsonSerialization['openAiErrorMessage'] as String?,
    );
  }

  String messageText;

  String? openAiErrorMessage;

  /// Returns a shallow copy of this [UserApiKeyQuotaExceededResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  UserApiKeyQuotaExceededResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    String? openAiErrorMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      if (openAiErrorMessage != null) 'openAiErrorMessage': openAiErrorMessage,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _UserApiKeyQuotaExceededResponseImpl
    extends UserApiKeyQuotaExceededResponse {
  _UserApiKeyQuotaExceededResponseImpl({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    String? openAiErrorMessage,
  }) : super._(
          role: role,
          expectsFollowUp: expectsFollowUp,
          messageText: messageText,
          openAiErrorMessage: openAiErrorMessage,
        );

  /// Returns a shallow copy of this [UserApiKeyQuotaExceededResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  UserApiKeyQuotaExceededResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    Object? openAiErrorMessage = _Undefined,
  }) {
    return UserApiKeyQuotaExceededResponse(
      role: role ?? this.role,
      expectsFollowUp: expectsFollowUp ?? this.expectsFollowUp,
      messageText: messageText ?? this.messageText,
      openAiErrorMessage: openAiErrorMessage is String?
          ? openAiErrorMessage
          : this.openAiErrorMessage,
    );
  }
}
