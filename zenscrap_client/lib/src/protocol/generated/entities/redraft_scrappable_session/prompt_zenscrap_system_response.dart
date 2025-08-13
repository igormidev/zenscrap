/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of 'zen_scrap_redraft_state.dart';

abstract class PromptZenScrapSystemResponse extends _i1.ZenScrapRedraftState
    implements _i2.SerializableModel {
  PromptZenScrapSystemResponse._({
    required super.name,
    required this.automaticSystemTextMessage,
  });

  factory PromptZenScrapSystemResponse({
    required String name,
    required String automaticSystemTextMessage,
  }) = _PromptZenScrapSystemResponseImpl;

  factory PromptZenScrapSystemResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PromptZenScrapSystemResponse(
      name: jsonSerialization['name'] as String,
      automaticSystemTextMessage:
          jsonSerialization['automaticSystemTextMessage'] as String,
    );
  }

  String automaticSystemTextMessage;

  /// Returns a shallow copy of this [PromptZenScrapSystemResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  PromptZenScrapSystemResponse copyWith({
    String? name,
    String? automaticSystemTextMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'automaticSystemTextMessage': automaticSystemTextMessage,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _PromptZenScrapSystemResponseImpl extends PromptZenScrapSystemResponse {
  _PromptZenScrapSystemResponseImpl({
    required String name,
    required String automaticSystemTextMessage,
  }) : super._(
          name: name,
          automaticSystemTextMessage: automaticSystemTextMessage,
        );

  /// Returns a shallow copy of this [PromptZenScrapSystemResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  PromptZenScrapSystemResponse copyWith({
    String? name,
    String? automaticSystemTextMessage,
  }) {
    return PromptZenScrapSystemResponse(
      name: name ?? this.name,
      automaticSystemTextMessage:
          automaticSystemTextMessage ?? this.automaticSystemTextMessage,
    );
  }
}
