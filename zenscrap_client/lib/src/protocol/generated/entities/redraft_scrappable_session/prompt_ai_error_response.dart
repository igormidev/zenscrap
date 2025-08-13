/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of 'zen_scrap_redraft_state.dart';

abstract class PromptAiErrorResponse extends _i1.ZenScrapRedraftState
    implements _i2.SerializableModel {
  PromptAiErrorResponse._({
    required super.name,
    required this.aiGeneratedErrorMessage,
  });

  factory PromptAiErrorResponse({
    required String name,
    required String aiGeneratedErrorMessage,
  }) = _PromptAiErrorResponseImpl;

  factory PromptAiErrorResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PromptAiErrorResponse(
      name: jsonSerialization['name'] as String,
      aiGeneratedErrorMessage:
          jsonSerialization['aiGeneratedErrorMessage'] as String,
    );
  }

  String aiGeneratedErrorMessage;

  /// Returns a shallow copy of this [PromptAiErrorResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  PromptAiErrorResponse copyWith({
    String? name,
    String? aiGeneratedErrorMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'aiGeneratedErrorMessage': aiGeneratedErrorMessage,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _PromptAiErrorResponseImpl extends PromptAiErrorResponse {
  _PromptAiErrorResponseImpl({
    required String name,
    required String aiGeneratedErrorMessage,
  }) : super._(
          name: name,
          aiGeneratedErrorMessage: aiGeneratedErrorMessage,
        );

  /// Returns a shallow copy of this [PromptAiErrorResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  PromptAiErrorResponse copyWith({
    String? name,
    String? aiGeneratedErrorMessage,
  }) {
    return PromptAiErrorResponse(
      name: name ?? this.name,
      aiGeneratedErrorMessage:
          aiGeneratedErrorMessage ?? this.aiGeneratedErrorMessage,
    );
  }
}
