/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../chat_response.dart';

abstract class CreditLimitReachedResponse extends _i1.ChatResponse
    implements _i2.SerializableModel {
  CreditLimitReachedResponse._({
    required super.role,
    required super.expectsFollowUp,
    required this.messageText,
    required this.creditsSpent,
    required this.creditsLimit,
    required this.canUseOwnApiKey,
  });

  factory CreditLimitReachedResponse({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    required double creditsSpent,
    required double creditsLimit,
    required bool canUseOwnApiKey,
  }) = _CreditLimitReachedResponseImpl;

  factory CreditLimitReachedResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return CreditLimitReachedResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      messageText: jsonSerialization['messageText'] as String,
      creditsSpent: (jsonSerialization['creditsSpent'] as num).toDouble(),
      creditsLimit: (jsonSerialization['creditsLimit'] as num).toDouble(),
      canUseOwnApiKey: jsonSerialization['canUseOwnApiKey'] as bool,
    );
  }

  String messageText;

  double creditsSpent;

  double creditsLimit;

  bool canUseOwnApiKey;

  /// Returns a shallow copy of this [CreditLimitReachedResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  CreditLimitReachedResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    double? creditsSpent,
    double? creditsLimit,
    bool? canUseOwnApiKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      'creditsSpent': creditsSpent,
      'creditsLimit': creditsLimit,
      'canUseOwnApiKey': canUseOwnApiKey,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _CreditLimitReachedResponseImpl extends CreditLimitReachedResponse {
  _CreditLimitReachedResponseImpl({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    required double creditsSpent,
    required double creditsLimit,
    required bool canUseOwnApiKey,
  }) : super._(
          role: role,
          expectsFollowUp: expectsFollowUp,
          messageText: messageText,
          creditsSpent: creditsSpent,
          creditsLimit: creditsLimit,
          canUseOwnApiKey: canUseOwnApiKey,
        );

  /// Returns a shallow copy of this [CreditLimitReachedResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  CreditLimitReachedResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    double? creditsSpent,
    double? creditsLimit,
    bool? canUseOwnApiKey,
  }) {
    return CreditLimitReachedResponse(
      role: role ?? this.role,
      expectsFollowUp: expectsFollowUp ?? this.expectsFollowUp,
      messageText: messageText ?? this.messageText,
      creditsSpent: creditsSpent ?? this.creditsSpent,
      creditsLimit: creditsLimit ?? this.creditsLimit,
      canUseOwnApiKey: canUseOwnApiKey ?? this.canUseOwnApiKey,
    );
  }
}
