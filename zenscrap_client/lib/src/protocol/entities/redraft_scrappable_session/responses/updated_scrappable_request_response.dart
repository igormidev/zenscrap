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

abstract class UpdatedScrappableRequestResponse extends _i1.ChatResponse
    implements _i2.SerializableModel {
  UpdatedScrappableRequestResponse._({
    required super.role,
    required super.expectsFollowUp,
    required this.messageText,
    required this.url,
    required this.queryParams,
    required this.pathParams,
    this.scrappableRequest,
  });

  factory UpdatedScrappableRequestResponse({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    required String url,
    required Map<String, String?> queryParams,
    required List<String> pathParams,
    _i7.ScrappableRequest? scrappableRequest,
  }) = _UpdatedScrappableRequestResponseImpl;

  factory UpdatedScrappableRequestResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UpdatedScrappableRequestResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      messageText: jsonSerialization['messageText'] as String,
      url: jsonSerialization['url'] as String,
      queryParams: _i6.Protocol().deserialize<Map<String, String?>>(
        jsonSerialization['queryParams'],
      ),
      pathParams: _i6.Protocol().deserialize<List<String>>(
        jsonSerialization['pathParams'],
      ),
      scrappableRequest: jsonSerialization['scrappableRequest'] == null
          ? null
          : _i6.Protocol().deserialize<_i7.ScrappableRequest>(
              jsonSerialization['scrappableRequest'],
            ),
    );
  }

  String messageText;

  String url;

  Map<String, String?> queryParams;

  List<String> pathParams;

  _i7.ScrappableRequest? scrappableRequest;

  /// Returns a shallow copy of this [UpdatedScrappableRequestResponse]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  UpdatedScrappableRequestResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    String? url,
    Map<String, String?>? queryParams,
    List<String>? pathParams,
    _i7.ScrappableRequest? scrappableRequest,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UpdatedScrappableRequestResponse',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      'url': url,
      'queryParams': queryParams.toJson(),
      'pathParams': pathParams.toJson(),
      if (scrappableRequest != null)
        'scrappableRequest': scrappableRequest?.toJson(),
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
    required bool expectsFollowUp,
    required String messageText,
    required String url,
    required Map<String, String?> queryParams,
    required List<String> pathParams,
    _i7.ScrappableRequest? scrappableRequest,
  }) : super._(
         role: role,
         expectsFollowUp: expectsFollowUp,
         messageText: messageText,
         url: url,
         queryParams: queryParams,
         pathParams: pathParams,
         scrappableRequest: scrappableRequest,
       );

  /// Returns a shallow copy of this [UpdatedScrappableRequestResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  UpdatedScrappableRequestResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    String? url,
    Map<String, String?>? queryParams,
    List<String>? pathParams,
    Object? scrappableRequest = _Undefined,
  }) {
    return UpdatedScrappableRequestResponse(
      role: role ?? this.role,
      expectsFollowUp: expectsFollowUp ?? this.expectsFollowUp,
      messageText: messageText ?? this.messageText,
      url: url ?? this.url,
      queryParams:
          queryParams ??
          this.queryParams.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      pathParams: pathParams ?? this.pathParams.map((e0) => e0).toList(),
      scrappableRequest: scrappableRequest is _i7.ScrappableRequest?
          ? scrappableRequest
          : this.scrappableRequest?.copyWith(),
    );
  }
}
