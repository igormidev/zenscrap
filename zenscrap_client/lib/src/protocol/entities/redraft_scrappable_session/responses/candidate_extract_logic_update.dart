/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../chat_response.dart';

abstract class CandidateExtractLogicUpdate extends _i1.ChatResponse
    implements _i2.SerializableModel {
  CandidateExtractLogicUpdate._({
    required super.role,
    required this.messageText,
    required this.scrappingBeeExtractLogic,
    required this.scrapperRequest,
  });

  factory CandidateExtractLogicUpdate({
    required _i3.PromptRole role,
    required String messageText,
    required _i4.ScrappingBeeExtractLogic scrappingBeeExtractLogic,
    required _i5.ScrappableRequest scrapperRequest,
  }) = _CandidateExtractLogicUpdateImpl;

  factory CandidateExtractLogicUpdate.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return CandidateExtractLogicUpdate(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      messageText: jsonSerialization['messageText'] as String,
      scrappingBeeExtractLogic: _i4.ScrappingBeeExtractLogic.fromJson(
          (jsonSerialization['scrappingBeeExtractLogic']
              as Map<String, dynamic>)),
      scrapperRequest: _i5.ScrappableRequest.fromJson(
          (jsonSerialization['scrapperRequest'] as Map<String, dynamic>)),
    );
  }

  String messageText;

  _i4.ScrappingBeeExtractLogic scrappingBeeExtractLogic;

  _i5.ScrappableRequest scrapperRequest;

  /// Returns a shallow copy of this [CandidateExtractLogicUpdate]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  CandidateExtractLogicUpdate copyWith({
    _i3.PromptRole? role,
    String? messageText,
    _i4.ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    _i5.ScrappableRequest? scrapperRequest,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'messageText': messageText,
      'scrappingBeeExtractLogic': scrappingBeeExtractLogic.toJson(),
      'scrapperRequest': scrapperRequest.toJson(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _CandidateExtractLogicUpdateImpl extends CandidateExtractLogicUpdate {
  _CandidateExtractLogicUpdateImpl({
    required _i3.PromptRole role,
    required String messageText,
    required _i4.ScrappingBeeExtractLogic scrappingBeeExtractLogic,
    required _i5.ScrappableRequest scrapperRequest,
  }) : super._(
          role: role,
          messageText: messageText,
          scrappingBeeExtractLogic: scrappingBeeExtractLogic,
          scrapperRequest: scrapperRequest,
        );

  /// Returns a shallow copy of this [CandidateExtractLogicUpdate]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  CandidateExtractLogicUpdate copyWith({
    _i3.PromptRole? role,
    String? messageText,
    _i4.ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    _i5.ScrappableRequest? scrapperRequest,
  }) {
    return CandidateExtractLogicUpdate(
      role: role ?? this.role,
      messageText: messageText ?? this.messageText,
      scrappingBeeExtractLogic:
          scrappingBeeExtractLogic ?? this.scrappingBeeExtractLogic.copyWith(),
      scrapperRequest: scrapperRequest ?? this.scrapperRequest.copyWith(),
    );
  }
}
