/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../zen_scrap_redraft_state.dart';

abstract class NewExtractRuleResponse extends _i1.ChatResponse
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  NewExtractRuleResponse._({
    required super.role,
    required this.messageText,
    required this.referenceTestData,
  });

  factory NewExtractRuleResponse({
    required _i3.PromptRole role,
    required String messageText,
    required _i4.ReferenceTestData referenceTestData,
  }) = _NewExtractRuleResponseImpl;

  factory NewExtractRuleResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return NewExtractRuleResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      messageText: jsonSerialization['messageText'] as String,
      referenceTestData: _i4.ReferenceTestData.fromJson(
          (jsonSerialization['referenceTestData'] as Map<String, dynamic>)),
    );
  }

  String messageText;

  _i4.ReferenceTestData referenceTestData;

  /// Returns a shallow copy of this [NewExtractRuleResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  NewExtractRuleResponse copyWith({
    _i3.PromptRole? role,
    String? messageText,
    _i4.ReferenceTestData? referenceTestData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'messageText': messageText,
      'referenceTestData': referenceTestData.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'role': role.toJson(),
      'messageText': messageText,
      'referenceTestData': referenceTestData.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _NewExtractRuleResponseImpl extends NewExtractRuleResponse {
  _NewExtractRuleResponseImpl({
    required _i3.PromptRole role,
    required String messageText,
    required _i4.ReferenceTestData referenceTestData,
  }) : super._(
          role: role,
          messageText: messageText,
          referenceTestData: referenceTestData,
        );

  /// Returns a shallow copy of this [NewExtractRuleResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  NewExtractRuleResponse copyWith({
    _i3.PromptRole? role,
    String? messageText,
    _i4.ReferenceTestData? referenceTestData,
  }) {
    return NewExtractRuleResponse(
      role: role ?? this.role,
      messageText: messageText ?? this.messageText,
      referenceTestData: referenceTestData ?? this.referenceTestData.copyWith(),
    );
  }
}
