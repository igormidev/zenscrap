/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of '../chat_response.dart';

abstract class UpdatedScrappableRequestResponse extends _i1.ChatResponse
    implements _i2.SerializableModel {
  UpdatedScrappableRequestResponse._({
    required super.role,
    required this.messageText,
    required this.url,
    required this.queryParams,
    required this.pathParams,
  });

  factory UpdatedScrappableRequestResponse({
    required _i3.PromptRole role,
    required String messageText,
    required String url,
    required Map<String, String?> queryParams,
    required List<String> pathParams,
  }) = _UpdatedScrappableRequestResponseImpl;

  factory UpdatedScrappableRequestResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return UpdatedScrappableRequestResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      messageText: jsonSerialization['messageText'] as String,
      url: jsonSerialization['url'] as String,
      queryParams:
          (jsonSerialization['queryParams'] as Map).map((k, v) => MapEntry(
                k as String,
                v as String?,
              )),
      pathParams: (jsonSerialization['pathParams'] as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  String messageText;

  String url;

  Map<String, String?> queryParams;

  List<String> pathParams;

  /// Returns a shallow copy of this [UpdatedScrappableRequestResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  UpdatedScrappableRequestResponse copyWith({
    _i3.PromptRole? role,
    String? messageText,
    String? url,
    Map<String, String?>? queryParams,
    List<String>? pathParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'messageText': messageText,
      'url': url,
      'queryParams': queryParams.toJson(),
      'pathParams': pathParams.toJson(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _UpdatedScrappableRequestResponseImpl
    extends UpdatedScrappableRequestResponse {
  _UpdatedScrappableRequestResponseImpl({
    required _i3.PromptRole role,
    required String messageText,
    required String url,
    required Map<String, String?> queryParams,
    required List<String> pathParams,
  }) : super._(
          role: role,
          messageText: messageText,
          url: url,
          queryParams: queryParams,
          pathParams: pathParams,
        );

  /// Returns a shallow copy of this [UpdatedScrappableRequestResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  UpdatedScrappableRequestResponse copyWith({
    _i3.PromptRole? role,
    String? messageText,
    String? url,
    Map<String, String?>? queryParams,
    List<String>? pathParams,
  }) {
    return UpdatedScrappableRequestResponse(
      role: role ?? this.role,
      messageText: messageText ?? this.messageText,
      url: url ?? this.url,
      queryParams: queryParams ??
          this.queryParams.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      pathParams: pathParams ?? this.pathParams.map((e0) => e0).toList(),
    );
  }
}
