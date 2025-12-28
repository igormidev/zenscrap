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

abstract class HeartbeatResponse extends _i1.ChatResponse
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  HeartbeatResponse._({
    required super.role,
    required super.expectsFollowUp,
    required this.timestamp,
  });

  factory HeartbeatResponse({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required DateTime timestamp,
  }) = _HeartbeatResponseImpl;

  factory HeartbeatResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return HeartbeatResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      timestamp: _i2.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  DateTime timestamp;

  /// Returns a shallow copy of this [HeartbeatResponse]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  HeartbeatResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HeartbeatResponse',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HeartbeatResponse',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _HeartbeatResponseImpl extends HeartbeatResponse {
  _HeartbeatResponseImpl({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required DateTime timestamp,
  }) : super._(
         role: role,
         expectsFollowUp: expectsFollowUp,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [HeartbeatResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  HeartbeatResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    DateTime? timestamp,
  }) {
    return HeartbeatResponse(
      role: role ?? this.role,
      expectsFollowUp: expectsFollowUp ?? this.expectsFollowUp,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
