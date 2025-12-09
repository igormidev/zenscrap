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

abstract class CandidateExtractLogicUpdate extends _i1.ChatResponse
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  CandidateExtractLogicUpdate._({
    required super.role,
    required super.expectsFollowUp,
    required this.messageText,
    required this.thinkingSentences,
    required this.scrappingBeeExtractLogic,
    required this.referenceTestData,
  });

  factory CandidateExtractLogicUpdate({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    required List<String> thinkingSentences,
    required _i4.ScrappingBeeExtractLogic scrappingBeeExtractLogic,
    required _i5.ReferenceTestData referenceTestData,
  }) = _CandidateExtractLogicUpdateImpl;

  factory CandidateExtractLogicUpdate.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CandidateExtractLogicUpdate(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      messageText: jsonSerialization['messageText'] as String,
      thinkingSentences: _i6.Protocol().deserialize<List<String>>(
        jsonSerialization['thinkingSentences'],
      ),
      scrappingBeeExtractLogic: _i6.Protocol()
          .deserialize<_i4.ScrappingBeeExtractLogic>(
            jsonSerialization['scrappingBeeExtractLogic'],
          ),
      referenceTestData: _i6.Protocol().deserialize<_i5.ReferenceTestData>(
        jsonSerialization['referenceTestData'],
      ),
    );
  }

  String messageText;

  List<String> thinkingSentences;

  _i4.ScrappingBeeExtractLogic scrappingBeeExtractLogic;

  _i5.ReferenceTestData referenceTestData;

  /// Returns a shallow copy of this [CandidateExtractLogicUpdate]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  CandidateExtractLogicUpdate copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    List<String>? thinkingSentences,
    _i4.ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    _i5.ReferenceTestData? referenceTestData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CandidateExtractLogicUpdate',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      'thinkingSentences': thinkingSentences.toJson(),
      'scrappingBeeExtractLogic': scrappingBeeExtractLogic.toJson(),
      'referenceTestData': referenceTestData.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CandidateExtractLogicUpdate',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      'thinkingSentences': thinkingSentences.toJson(),
      'scrappingBeeExtractLogic': scrappingBeeExtractLogic.toJsonForProtocol(),
      'referenceTestData': referenceTestData.toJsonForProtocol(),
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
    required bool expectsFollowUp,
    required String messageText,
    required List<String> thinkingSentences,
    required _i4.ScrappingBeeExtractLogic scrappingBeeExtractLogic,
    required _i5.ReferenceTestData referenceTestData,
  }) : super._(
         role: role,
         expectsFollowUp: expectsFollowUp,
         messageText: messageText,
         thinkingSentences: thinkingSentences,
         scrappingBeeExtractLogic: scrappingBeeExtractLogic,
         referenceTestData: referenceTestData,
       );

  /// Returns a shallow copy of this [CandidateExtractLogicUpdate]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  CandidateExtractLogicUpdate copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    List<String>? thinkingSentences,
    _i4.ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    _i5.ReferenceTestData? referenceTestData,
  }) {
    return CandidateExtractLogicUpdate(
      role: role ?? this.role,
      expectsFollowUp: expectsFollowUp ?? this.expectsFollowUp,
      messageText: messageText ?? this.messageText,
      thinkingSentences:
          thinkingSentences ?? this.thinkingSentences.map((e0) => e0).toList(),
      scrappingBeeExtractLogic:
          scrappingBeeExtractLogic ?? this.scrappingBeeExtractLogic.copyWith(),
      referenceTestData: referenceTestData ?? this.referenceTestData.copyWith(),
    );
  }
}
