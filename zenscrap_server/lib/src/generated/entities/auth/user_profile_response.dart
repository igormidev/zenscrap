/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Response containing authenticated user's profile information.
abstract class UserProfileResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserProfileResponse._({
    this.email,
    this.fullName,
    this.userName,
    this.imageUrl,
  });

  factory UserProfileResponse({
    String? email,
    String? fullName,
    String? userName,
    String? imageUrl,
  }) = _UserProfileResponseImpl;

  factory UserProfileResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfileResponse(
      email: jsonSerialization['email'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      userName: jsonSerialization['userName'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
    );
  }

  /// The user's email address.
  String? email;

  /// The user's full name.
  String? fullName;

  /// The user's display name (username).
  String? userName;

  /// URL to the user's profile image.
  String? imageUrl;

  /// Returns a shallow copy of this [UserProfileResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfileResponse copyWith({
    String? email,
    String? fullName,
    String? userName,
    String? imageUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfileResponse',
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (userName != null) 'userName': userName,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserProfileResponse',
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (userName != null) 'userName': userName,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileResponseImpl extends UserProfileResponse {
  _UserProfileResponseImpl({
    String? email,
    String? fullName,
    String? userName,
    String? imageUrl,
  }) : super._(
         email: email,
         fullName: fullName,
         userName: userName,
         imageUrl: imageUrl,
       );

  /// Returns a shallow copy of this [UserProfileResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfileResponse copyWith({
    Object? email = _Undefined,
    Object? fullName = _Undefined,
    Object? userName = _Undefined,
    Object? imageUrl = _Undefined,
  }) {
    return UserProfileResponse(
      email: email is String? ? email : this.email,
      fullName: fullName is String? ? fullName : this.fullName,
      userName: userName is String? ? userName : this.userName,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
    );
  }
}
