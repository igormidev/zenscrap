/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../chat_response.dart';

abstract class TestEndpointCalledErrorResponse extends _i1.ChatResponse
    implements _i2.SerializableModel {
  TestEndpointCalledErrorResponse._({
    required super.role,
    required this.errorTitle,
    required this.errorDescription,
    required this.inputPayload,
    required this.timestamp,
  });

  factory TestEndpointCalledErrorResponse({
    required _i3.PromptRole role,
    required String errorTitle,
    required String errorDescription,
    required String inputPayload,
    required DateTime timestamp,
  }) = _TestEndpointCalledErrorResponseImpl;

  factory TestEndpointCalledErrorResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return TestEndpointCalledErrorResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      errorTitle: jsonSerialization['errorTitle'] as String,
      errorDescription: jsonSerialization['errorDescription'] as String,
      inputPayload: jsonSerialization['inputPayload'] as String,
      timestamp:
          _i2.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  String errorTitle;

  String errorDescription;

  String inputPayload;

  DateTime timestamp;

  /// Returns a shallow copy of this [TestEndpointCalledErrorResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  TestEndpointCalledErrorResponse copyWith({
    _i3.PromptRole? role,
    String? errorTitle,
    String? errorDescription,
    String? inputPayload,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'errorTitle': errorTitle,
      'errorDescription': errorDescription,
      'inputPayload': inputPayload,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _TestEndpointCalledErrorResponseImpl
    extends TestEndpointCalledErrorResponse {
  _TestEndpointCalledErrorResponseImpl({
    required _i3.PromptRole role,
    required String errorTitle,
    required String errorDescription,
    required String inputPayload,
    required DateTime timestamp,
  }) : super._(
          role: role,
          errorTitle: errorTitle,
          errorDescription: errorDescription,
          inputPayload: inputPayload,
          timestamp: timestamp,
        );

  /// Returns a shallow copy of this [TestEndpointCalledErrorResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  TestEndpointCalledErrorResponse copyWith({
    _i3.PromptRole? role,
    String? errorTitle,
    String? errorDescription,
    String? inputPayload,
    DateTime? timestamp,
  }) {
    return TestEndpointCalledErrorResponse(
      role: role ?? this.role,
      errorTitle: errorTitle ?? this.errorTitle,
      errorDescription: errorDescription ?? this.errorDescription,
      inputPayload: inputPayload ?? this.inputPayload,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
