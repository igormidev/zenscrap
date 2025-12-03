/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../chat_response.dart';

abstract class NewExtractRuleResponse extends _i1.ChatResponse
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  NewExtractRuleResponse._({
    required super.role,
    required super.expectsFollowUp,
    required this.messageText,
    required this.referenceTestData,
    required this.scrappingBeeExtractLogic,
    required this.scrapperRequest,
  });

  factory NewExtractRuleResponse({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    required _i5.ReferenceTestData referenceTestData,
    required _i4.ScrappingBeeExtractLogic scrappingBeeExtractLogic,
    required _i6.ScrappableRequest scrapperRequest,
  }) = _NewExtractRuleResponseImpl;

  factory NewExtractRuleResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return NewExtractRuleResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      messageText: jsonSerialization['messageText'] as String,
      referenceTestData: _i5.ReferenceTestData.fromJson(
          (jsonSerialization['referenceTestData'] as Map<String, dynamic>)),
      scrappingBeeExtractLogic: _i4.ScrappingBeeExtractLogic.fromJson(
          (jsonSerialization['scrappingBeeExtractLogic']
              as Map<String, dynamic>)),
      scrapperRequest: _i6.ScrappableRequest.fromJson(
          (jsonSerialization['scrapperRequest'] as Map<String, dynamic>)),
    );
  }

  String messageText;

  _i5.ReferenceTestData referenceTestData;

  _i4.ScrappingBeeExtractLogic scrappingBeeExtractLogic;

  _i6.ScrappableRequest scrapperRequest;

  /// Returns a shallow copy of this [NewExtractRuleResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  NewExtractRuleResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    _i5.ReferenceTestData? referenceTestData,
    _i4.ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    _i6.ScrappableRequest? scrapperRequest,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      'referenceTestData': referenceTestData.toJson(),
      'scrappingBeeExtractLogic': scrappingBeeExtractLogic.toJson(),
      'scrapperRequest': scrapperRequest.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      'referenceTestData': referenceTestData.toJsonForProtocol(),
      'scrappingBeeExtractLogic': scrappingBeeExtractLogic.toJsonForProtocol(),
      'scrapperRequest': scrapperRequest.toJsonForProtocol(),
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
    required bool expectsFollowUp,
    required String messageText,
    required _i5.ReferenceTestData referenceTestData,
    required _i4.ScrappingBeeExtractLogic scrappingBeeExtractLogic,
    required _i6.ScrappableRequest scrapperRequest,
  }) : super._(
          role: role,
          expectsFollowUp: expectsFollowUp,
          messageText: messageText,
          referenceTestData: referenceTestData,
          scrappingBeeExtractLogic: scrappingBeeExtractLogic,
          scrapperRequest: scrapperRequest,
        );

  /// Returns a shallow copy of this [NewExtractRuleResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  NewExtractRuleResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    _i5.ReferenceTestData? referenceTestData,
    _i4.ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    _i6.ScrappableRequest? scrapperRequest,
  }) {
    return NewExtractRuleResponse(
      role: role ?? this.role,
      expectsFollowUp: expectsFollowUp ?? this.expectsFollowUp,
      messageText: messageText ?? this.messageText,
      referenceTestData: referenceTestData ?? this.referenceTestData.copyWith(),
      scrappingBeeExtractLogic:
          scrappingBeeExtractLogic ?? this.scrappingBeeExtractLogic.copyWith(),
      scrapperRequest: scrapperRequest ?? this.scrapperRequest.copyWith(),
    );
  }
}
