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

abstract class TestEndpointCalledSuccessResponse extends _i1.ChatResponse
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  TestEndpointCalledSuccessResponse._({
    required super.role,
    required super.expectsFollowUp,
    required this.inputPayload,
    required this.responseData,
    required this.timestamp,
    required this.referenceTestData,
  });

  factory TestEndpointCalledSuccessResponse({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String inputPayload,
    required String responseData,
    required DateTime timestamp,
    required _i5.ReferenceTestData referenceTestData,
  }) = _TestEndpointCalledSuccessResponseImpl;

  factory TestEndpointCalledSuccessResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TestEndpointCalledSuccessResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      inputPayload: jsonSerialization['inputPayload'] as String,
      responseData: jsonSerialization['responseData'] as String,
      timestamp: _i2.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      referenceTestData: _i6.Protocol().deserialize<_i5.ReferenceTestData>(
        jsonSerialization['referenceTestData'],
      ),
    );
  }

  String inputPayload;

  String responseData;

  DateTime timestamp;

  _i5.ReferenceTestData referenceTestData;

  /// Returns a shallow copy of this [TestEndpointCalledSuccessResponse]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  TestEndpointCalledSuccessResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? inputPayload,
    String? responseData,
    DateTime? timestamp,
    _i5.ReferenceTestData? referenceTestData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TestEndpointCalledSuccessResponse',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'inputPayload': inputPayload,
      'responseData': responseData,
      'timestamp': timestamp.toJson(),
      'referenceTestData': referenceTestData.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TestEndpointCalledSuccessResponse',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'inputPayload': inputPayload,
      'responseData': responseData,
      'timestamp': timestamp.toJson(),
      'referenceTestData': referenceTestData.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _TestEndpointCalledSuccessResponseImpl
    extends TestEndpointCalledSuccessResponse {
  _TestEndpointCalledSuccessResponseImpl({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String inputPayload,
    required String responseData,
    required DateTime timestamp,
    required _i5.ReferenceTestData referenceTestData,
  }) : super._(
         role: role,
         expectsFollowUp: expectsFollowUp,
         inputPayload: inputPayload,
         responseData: responseData,
         timestamp: timestamp,
         referenceTestData: referenceTestData,
       );

  /// Returns a shallow copy of this [TestEndpointCalledSuccessResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  TestEndpointCalledSuccessResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? inputPayload,
    String? responseData,
    DateTime? timestamp,
    _i5.ReferenceTestData? referenceTestData,
  }) {
    return TestEndpointCalledSuccessResponse(
      role: role ?? this.role,
      expectsFollowUp: expectsFollowUp ?? this.expectsFollowUp,
      inputPayload: inputPayload ?? this.inputPayload,
      responseData: responseData ?? this.responseData,
      timestamp: timestamp ?? this.timestamp,
      referenceTestData: referenceTestData ?? this.referenceTestData.copyWith(),
    );
  }
}
