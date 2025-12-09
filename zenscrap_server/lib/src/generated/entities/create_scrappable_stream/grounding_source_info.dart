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

abstract class GroundingSourceInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  GroundingSourceInfo._({
    required this.uri,
    required this.title,
  });

  factory GroundingSourceInfo({
    required String uri,
    required String title,
  }) = _GroundingSourceInfoImpl;

  factory GroundingSourceInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return GroundingSourceInfo(
      uri: jsonSerialization['uri'] as String,
      title: jsonSerialization['title'] as String,
    );
  }

  String uri;

  String title;

  /// Returns a shallow copy of this [GroundingSourceInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GroundingSourceInfo copyWith({
    String? uri,
    String? title,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GroundingSourceInfo',
      'uri': uri,
      'title': title,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GroundingSourceInfo',
      'uri': uri,
      'title': title,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _GroundingSourceInfoImpl extends GroundingSourceInfo {
  _GroundingSourceInfoImpl({
    required String uri,
    required String title,
  }) : super._(
         uri: uri,
         title: title,
       );

  /// Returns a shallow copy of this [GroundingSourceInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GroundingSourceInfo copyWith({
    String? uri,
    String? title,
  }) {
    return GroundingSourceInfo(
      uri: uri ?? this.uri,
      title: title ?? this.title,
    );
  }
}
