/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../chat_response.dart';

abstract class TestEndpointCalledSuccessResponse extends _i1.ChatResponse
    implements _i2.SerializableModel {
  TestEndpointCalledSuccessResponse._({
    required super.role,
    required this.inputPayload,
    required this.responseData,
    required this.timestamp,
  });

  factory TestEndpointCalledSuccessResponse({
    required _i3.PromptRole role,
    required String inputPayload,
    required String responseData,
    required DateTime timestamp,
  }) = _TestEndpointCalledSuccessResponseImpl;

  factory TestEndpointCalledSuccessResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return TestEndpointCalledSuccessResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      inputPayload: jsonSerialization['inputPayload'] as String,
      responseData: jsonSerialization['responseData'] as String,
      timestamp:
          _i2.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  String inputPayload;

  String responseData;

  DateTime timestamp;

  /// Returns a shallow copy of this [TestEndpointCalledSuccessResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  TestEndpointCalledSuccessResponse copyWith({
    _i3.PromptRole? role,
    String? inputPayload,
    String? responseData,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'inputPayload': inputPayload,
      'responseData': responseData,
      'timestamp': timestamp.toJson(),
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
    required String inputPayload,
    required String responseData,
    required DateTime timestamp,
  }) : super._(
          role: role,
          inputPayload: inputPayload,
          responseData: responseData,
          timestamp: timestamp,
        );

  /// Returns a shallow copy of this [TestEndpointCalledSuccessResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  TestEndpointCalledSuccessResponse copyWith({
    _i3.PromptRole? role,
    String? inputPayload,
    String? responseData,
    DateTime? timestamp,
  }) {
    return TestEndpointCalledSuccessResponse(
      role: role ?? this.role,
      inputPayload: inputPayload ?? this.inputPayload,
      responseData: responseData ?? this.responseData,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
