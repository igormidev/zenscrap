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

abstract class IpLimitReachedResponse extends _i1.ChatResponse
    implements _i2.SerializableModel {
  IpLimitReachedResponse._({
    required super.role,
    required super.expectsFollowUp,
    required this.messageText,
    required this.timeUntilReset,
    required this.totalSpentUsd,
    required this.spendingLimitUsd,
  });

  factory IpLimitReachedResponse({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    required Duration timeUntilReset,
    required double totalSpentUsd,
    required double spendingLimitUsd,
  }) = _IpLimitReachedResponseImpl;

  factory IpLimitReachedResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return IpLimitReachedResponse(
      role: _i3.PromptRole.fromJson((jsonSerialization['role'] as String)),
      expectsFollowUp: jsonSerialization['expectsFollowUp'] as bool,
      messageText: jsonSerialization['messageText'] as String,
      timeUntilReset: _i2.DurationJsonExtension.fromJson(
        jsonSerialization['timeUntilReset'],
      ),
      totalSpentUsd: (jsonSerialization['totalSpentUsd'] as num).toDouble(),
      spendingLimitUsd: (jsonSerialization['spendingLimitUsd'] as num)
          .toDouble(),
    );
  }

  String messageText;

  Duration timeUntilReset;

  double totalSpentUsd;

  double spendingLimitUsd;

  /// Returns a shallow copy of this [IpLimitReachedResponse]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  IpLimitReachedResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    Duration? timeUntilReset,
    double? totalSpentUsd,
    double? spendingLimitUsd,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IpLimitReachedResponse',
      'role': role.toJson(),
      'expectsFollowUp': expectsFollowUp,
      'messageText': messageText,
      'timeUntilReset': timeUntilReset.toJson(),
      'totalSpentUsd': totalSpentUsd,
      'spendingLimitUsd': spendingLimitUsd,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _IpLimitReachedResponseImpl extends IpLimitReachedResponse {
  _IpLimitReachedResponseImpl({
    required _i3.PromptRole role,
    required bool expectsFollowUp,
    required String messageText,
    required Duration timeUntilReset,
    required double totalSpentUsd,
    required double spendingLimitUsd,
  }) : super._(
         role: role,
         expectsFollowUp: expectsFollowUp,
         messageText: messageText,
         timeUntilReset: timeUntilReset,
         totalSpentUsd: totalSpentUsd,
         spendingLimitUsd: spendingLimitUsd,
       );

  /// Returns a shallow copy of this [IpLimitReachedResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  IpLimitReachedResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
    String? messageText,
    Duration? timeUntilReset,
    double? totalSpentUsd,
    double? spendingLimitUsd,
  }) {
    return IpLimitReachedResponse(
      role: role ?? this.role,
      expectsFollowUp: expectsFollowUp ?? this.expectsFollowUp,
      messageText: messageText ?? this.messageText,
      timeUntilReset: timeUntilReset ?? this.timeUntilReset,
      totalSpentUsd: totalSpentUsd ?? this.totalSpentUsd,
      spendingLimitUsd: spendingLimitUsd ?? this.spendingLimitUsd,
    );
  }
}
