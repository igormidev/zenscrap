/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of '../chat_response.dart';

abstract class NewExtractRuleResponse extends _i1.ChatResponse
    implements _i2.SerializableModel {
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
    required _i7.ScrappableRequest scrapperRequest,
  }) = _NewExtractRuleResponseImpl;

  factory NewExtractRuleResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NewExtractRuleResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      messageText: jsonSerialization['messageText'] as String,
      referenceTestData: _i6.Protocol().deserialize<_i5.ReferenceTestData>(
        jsonSerialization['referenceTestData'],
      ),
      scrappingBeeExtractLogic: _i6.Protocol()
          .deserialize<_i4.ScrappingBeeExtractLogic>(
            jsonSerialization['scrappingBeeExtractLogic'],
          ),
      scrapperRequest: _i6.Protocol().deserialize<_i7.ScrappableRequest>(
        jsonSerialization['scrapperRequest'],
      ),
    );
  }

  String messageText;

  _i5.ReferenceTestData referenceTestData;

  _i4.ScrappingBeeExtractLogic scrappingBeeExtractLogic;

  _i7.ScrappableRequest scrapperRequest;

  /// Returns a shallow copy of this [NewExtractRuleResponse]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  NewExtractRuleResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    _i5.ReferenceTestData? referenceTestData,
    _i4.ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    _i7.ScrappableRequest? scrapperRequest,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NewExtractRuleResponse',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      'referenceTestData': referenceTestData.toJson(),
      'scrappingBeeExtractLogic': scrappingBeeExtractLogic.toJson(),
      'scrapperRequest': scrapperRequest.toJson(),
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
    required _i7.ScrappableRequest scrapperRequest,
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
    _i7.ScrappableRequest? scrapperRequest,
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
