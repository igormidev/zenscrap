/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i2;
import '../../entities/account/account_api_key.dart' as _i3;

abstract class AccountInfo implements _i1.SerializableModel {
  AccountInfo._({
    this.id,
    required this.userInfoId,
    this.userInfo,
    required this.accountApiKeyId,
    this.accountApiKey,
  });

  factory AccountInfo({
    int? id,
    required int userInfoId,
    _i2.UserInfo? userInfo,
    required int accountApiKeyId,
    _i3.AccountApiKey? accountApiKey,
  }) = _AccountInfoImpl;

  factory AccountInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountInfo(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i2.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
      accountApiKeyId: jsonSerialization['accountApiKeyId'] as int,
      accountApiKey: jsonSerialization['accountApiKey'] == null
          ? null
          : _i3.AccountApiKey.fromJson(
              (jsonSerialization['accountApiKey'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  _i2.UserInfo? userInfo;

  int accountApiKeyId;

  _i3.AccountApiKey? accountApiKey;

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountInfo copyWith({
    int? id,
    int? userInfoId,
    _i2.UserInfo? userInfo,
    int? accountApiKeyId,
    _i3.AccountApiKey? accountApiKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
      'accountApiKeyId': accountApiKeyId,
      if (accountApiKey != null) 'accountApiKey': accountApiKey?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountInfoImpl extends AccountInfo {
  _AccountInfoImpl({
    int? id,
    required int userInfoId,
    _i2.UserInfo? userInfo,
    required int accountApiKeyId,
    _i3.AccountApiKey? accountApiKey,
  }) : super._(
          id: id,
          userInfoId: userInfoId,
          userInfo: userInfo,
          accountApiKeyId: accountApiKeyId,
          accountApiKey: accountApiKey,
        );

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountInfo copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    Object? userInfo = _Undefined,
    int? accountApiKeyId,
    Object? accountApiKey = _Undefined,
  }) {
    return AccountInfo(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      userInfo:
          userInfo is _i2.UserInfo? ? userInfo : this.userInfo?.copyWith(),
      accountApiKeyId: accountApiKeyId ?? this.accountApiKeyId,
      accountApiKey: accountApiKey is _i3.AccountApiKey?
          ? accountApiKey
          : this.accountApiKey?.copyWith(),
    );
  }
}
