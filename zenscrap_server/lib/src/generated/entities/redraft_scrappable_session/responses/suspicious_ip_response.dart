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

abstract class SuspiciousIpResponse extends _i1.ChatResponse
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  SuspiciousIpResponse._({
    required super.role,
    required super.expectsFollowUp,
    required this.messageText,
    required this.blockReason,
    required this.blockReasonEnums,
    required this.isVpn,
    required this.isProxy,
    required this.isTor,
    required this.isDatacenter,
    required this.isAbuser,
    this.countryCode,
  });

  factory SuspiciousIpResponse({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    required String blockReason,
    required List<_i8.IpBlockReason> blockReasonEnums,
    required bool isVpn,
    required bool isProxy,
    required bool isTor,
    required bool isDatacenter,
    required bool isAbuser,
    String? countryCode,
  }) = _SuspiciousIpResponseImpl;

  factory SuspiciousIpResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SuspiciousIpResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      messageText: jsonSerialization['messageText'] as String,
      blockReason: jsonSerialization['blockReason'] as String,
      blockReasonEnums: _i6.Protocol().deserialize<List<_i8.IpBlockReason>>(
        jsonSerialization['blockReasonEnums'],
      ),
      isVpn: jsonSerialization['isVpn'] as bool,
      isProxy: jsonSerialization['isProxy'] as bool,
      isTor: jsonSerialization['isTor'] as bool,
      isDatacenter: jsonSerialization['isDatacenter'] as bool,
      isAbuser: jsonSerialization['isAbuser'] as bool,
      countryCode: jsonSerialization['countryCode'] as String?,
    );
  }

  String messageText;

  String blockReason;

  List<_i8.IpBlockReason> blockReasonEnums;

  bool isVpn;

  bool isProxy;

  bool isTor;

  bool isDatacenter;

  bool isAbuser;

  String? countryCode;

  /// Returns a shallow copy of this [SuspiciousIpResponse]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SuspiciousIpResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    String? blockReason,
    List<_i8.IpBlockReason>? blockReasonEnums,
    bool? isVpn,
    bool? isProxy,
    bool? isTor,
    bool? isDatacenter,
    bool? isAbuser,
    String? countryCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SuspiciousIpResponse',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      'blockReason': blockReason,
      'blockReasonEnums': blockReasonEnums.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'isVpn': isVpn,
      'isProxy': isProxy,
      'isTor': isTor,
      'isDatacenter': isDatacenter,
      'isAbuser': isAbuser,
      if (countryCode != null) 'countryCode': countryCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SuspiciousIpResponse',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      'blockReason': blockReason,
      'blockReasonEnums': blockReasonEnums.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'isVpn': isVpn,
      'isProxy': isProxy,
      'isTor': isTor,
      'isDatacenter': isDatacenter,
      'isAbuser': isAbuser,
      if (countryCode != null) 'countryCode': countryCode,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _SuspiciousIpResponseImpl extends SuspiciousIpResponse {
  _SuspiciousIpResponseImpl({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    required String blockReason,
    required List<_i8.IpBlockReason> blockReasonEnums,
    required bool isVpn,
    required bool isProxy,
    required bool isTor,
    required bool isDatacenter,
    required bool isAbuser,
    String? countryCode,
  }) : super._(
         role: role,
         expectsFollowUp: expectsFollowUp,
         messageText: messageText,
         blockReason: blockReason,
         blockReasonEnums: blockReasonEnums,
         isVpn: isVpn,
         isProxy: isProxy,
         isTor: isTor,
         isDatacenter: isDatacenter,
         isAbuser: isAbuser,
         countryCode: countryCode,
       );

  /// Returns a shallow copy of this [SuspiciousIpResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SuspiciousIpResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    String? blockReason,
    List<_i8.IpBlockReason>? blockReasonEnums,
    bool? isVpn,
    bool? isProxy,
    bool? isTor,
    bool? isDatacenter,
    bool? isAbuser,
    Object? countryCode = _Undefined,
  }) {
    return SuspiciousIpResponse(
      role: role ?? this.role,
      expectsFollowUp: expectsFollowUp ?? this.expectsFollowUp,
      messageText: messageText ?? this.messageText,
      blockReason: blockReason ?? this.blockReason,
      blockReasonEnums:
          blockReasonEnums ?? this.blockReasonEnums.map((e0) => e0).toList(),
      isVpn: isVpn ?? this.isVpn,
      isProxy: isProxy ?? this.isProxy,
      isTor: isTor ?? this.isTor,
      isDatacenter: isDatacenter ?? this.isDatacenter,
      isAbuser: isAbuser ?? this.isAbuser,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
    );
  }
}
