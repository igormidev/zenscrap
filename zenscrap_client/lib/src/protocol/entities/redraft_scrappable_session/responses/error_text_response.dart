/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../chat_response.dart';

abstract class ErrorTextResponse extends _i1.ChatResponse
    implements _i2.SerializableModel {
  ErrorTextResponse._({
    required super.role,
    required this.errorMessage,
  });

  factory ErrorTextResponse({
    required _i3.PromptRole role,
    required String errorMessage,
  }) = _ErrorTextResponseImpl;

  factory ErrorTextResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ErrorTextResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      errorMessage: jsonSerialization['errorMessage'] as String,
    );
  }

  String errorMessage;

  /// Returns a shallow copy of this [ErrorTextResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  ErrorTextResponse copyWith({
    _i3.PromptRole? role,
    String? errorMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'errorMessage': errorMessage,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _ErrorTextResponseImpl extends ErrorTextResponse {
  _ErrorTextResponseImpl({
    required _i3.PromptRole role,
    required String errorMessage,
  }) : super._(
          role: role,
          errorMessage: errorMessage,
        );

  /// Returns a shallow copy of this [ErrorTextResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ErrorTextResponse copyWith({
    _i3.PromptRole? role,
    String? errorMessage,
  }) {
    return ErrorTextResponse(
      role: role ?? this.role,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
