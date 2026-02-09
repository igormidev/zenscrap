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

abstract class EmailIdpCleanupFutureCallRunModel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  EmailIdpCleanupFutureCallRunModel._({required this._});

  factory EmailIdpCleanupFutureCallRunModel({required bool? _}) =
      _EmailIdpCleanupFutureCallRunModelImpl;

  factory EmailIdpCleanupFutureCallRunModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailIdpCleanupFutureCallRunModel(
      _: jsonSerialization['_'] as bool?,
    );
  }

  bool? _;

  /// Returns a shallow copy of this [EmailIdpCleanupFutureCallRunModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailIdpCleanupFutureCallRunModel copyWith({bool? _});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailIdpCleanupFutureCallRunModel',
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

class _EmailIdpCleanupFutureCallRunModelImpl
    extends EmailIdpCleanupFutureCallRunModel {
  _EmailIdpCleanupFutureCallRunModelImpl({required bool? _}) : super._(_: _);

  /// Returns a shallow copy of this [EmailIdpCleanupFutureCallRunModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailIdpCleanupFutureCallRunModel copyWith({Object? _ = _Undefined}) {
    return EmailIdpCleanupFutureCallRunModel(_: _ is bool? ? _ : this._);
  }
}
