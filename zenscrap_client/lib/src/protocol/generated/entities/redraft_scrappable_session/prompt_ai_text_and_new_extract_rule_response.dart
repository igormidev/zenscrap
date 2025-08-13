/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of 'zen_scrap_redraft_state.dart';

abstract class PromptAiTextAndNewExtractRulesResponse
    extends _i1.ZenScrapRedraftState implements _i2.SerializableModel {
  PromptAiTextAndNewExtractRulesResponse._({
    required super.name,
    required this.aiGeneratedTextMessage,
    required this.newExtractRules,
  });

  factory PromptAiTextAndNewExtractRulesResponse({
    required String name,
    required String aiGeneratedTextMessage,
    required String newExtractRules,
  }) = _PromptAiTextAndNewExtractRulesResponseImpl;

  factory PromptAiTextAndNewExtractRulesResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PromptAiTextAndNewExtractRulesResponse(
      name: jsonSerialization['name'] as String,
      aiGeneratedTextMessage:
          jsonSerialization['aiGeneratedTextMessage'] as String,
      newExtractRules: jsonSerialization['newExtractRules'] as String,
    );
  }

  String aiGeneratedTextMessage;

  String newExtractRules;

  /// Returns a shallow copy of this [PromptAiTextAndNewExtractRulesResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  PromptAiTextAndNewExtractRulesResponse copyWith({
    String? name,
    String? aiGeneratedTextMessage,
    String? newExtractRules,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'aiGeneratedTextMessage': aiGeneratedTextMessage,
      'newExtractRules': newExtractRules,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _PromptAiTextAndNewExtractRulesResponseImpl
    extends PromptAiTextAndNewExtractRulesResponse {
  _PromptAiTextAndNewExtractRulesResponseImpl({
    required String name,
    required String aiGeneratedTextMessage,
    required String newExtractRules,
  }) : super._(
          name: name,
          aiGeneratedTextMessage: aiGeneratedTextMessage,
          newExtractRules: newExtractRules,
        );

  /// Returns a shallow copy of this [PromptAiTextAndNewExtractRulesResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  PromptAiTextAndNewExtractRulesResponse copyWith({
    String? name,
    String? aiGeneratedTextMessage,
    String? newExtractRules,
  }) {
    return PromptAiTextAndNewExtractRulesResponse(
      name: name ?? this.name,
      aiGeneratedTextMessage:
          aiGeneratedTextMessage ?? this.aiGeneratedTextMessage,
      newExtractRules: newExtractRules ?? this.newExtractRules,
    );
  }
}
