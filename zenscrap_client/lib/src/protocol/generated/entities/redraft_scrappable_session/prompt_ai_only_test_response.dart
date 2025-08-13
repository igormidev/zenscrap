/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of 'zen_scrap_redraft_state.dart';

abstract class PromptAiOnlyTextResponse extends _i1.ZenScrapRedraftState
    implements _i2.SerializableModel {
  PromptAiOnlyTextResponse._({
    required super.name,
    required this.aiGeneratedTextMessage,
  });

  factory PromptAiOnlyTextResponse({
    required String name,
    required String aiGeneratedTextMessage,
  }) = _PromptAiOnlyTextResponseImpl;

  factory PromptAiOnlyTextResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PromptAiOnlyTextResponse(
      name: jsonSerialization['name'] as String,
      aiGeneratedTextMessage:
          jsonSerialization['aiGeneratedTextMessage'] as String,
    );
  }

  String aiGeneratedTextMessage;

  /// Returns a shallow copy of this [PromptAiOnlyTextResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  PromptAiOnlyTextResponse copyWith({
    String? name,
    String? aiGeneratedTextMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'aiGeneratedTextMessage': aiGeneratedTextMessage,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _PromptAiOnlyTextResponseImpl extends PromptAiOnlyTextResponse {
  _PromptAiOnlyTextResponseImpl({
    required String name,
    required String aiGeneratedTextMessage,
  }) : super._(
          name: name,
          aiGeneratedTextMessage: aiGeneratedTextMessage,
        );

  /// Returns a shallow copy of this [PromptAiOnlyTextResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  PromptAiOnlyTextResponse copyWith({
    String? name,
    String? aiGeneratedTextMessage,
  }) {
    return PromptAiOnlyTextResponse(
      name: name ?? this.name,
      aiGeneratedTextMessage:
          aiGeneratedTextMessage ?? this.aiGeneratedTextMessage,
    );
  }
}
