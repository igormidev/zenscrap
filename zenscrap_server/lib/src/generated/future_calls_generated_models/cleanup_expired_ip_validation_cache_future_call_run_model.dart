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

abstract class CleanupExpiredIpValidationCacheFutureCallRunModel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CleanupExpiredIpValidationCacheFutureCallRunModel._({required this._});

  factory CleanupExpiredIpValidationCacheFutureCallRunModel({
    required bool? _,
  }) = _CleanupExpiredIpValidationCacheFutureCallRunModelImpl;

  factory CleanupExpiredIpValidationCacheFutureCallRunModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CleanupExpiredIpValidationCacheFutureCallRunModel(
      _: jsonSerialization['_'] as bool?,
    );
  }

  bool? _;

  /// Returns a shallow copy of this [CleanupExpiredIpValidationCacheFutureCallRunModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CleanupExpiredIpValidationCacheFutureCallRunModel copyWith({bool? _});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CleanupExpiredIpValidationCacheFutureCallRunModel',
      if (_ != null) '_': _,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CleanupExpiredIpValidationCacheFutureCallRunModelImpl
    extends CleanupExpiredIpValidationCacheFutureCallRunModel {
  _CleanupExpiredIpValidationCacheFutureCallRunModelImpl({required bool? _})
    : super._(_: _);

  /// Returns a shallow copy of this [CleanupExpiredIpValidationCacheFutureCallRunModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CleanupExpiredIpValidationCacheFutureCallRunModel copyWith({
    Object? _ = _Undefined,
  }) {
    return CleanupExpiredIpValidationCacheFutureCallRunModel(
      _: _ is bool? ? _ : this._,
    );
  }
}
