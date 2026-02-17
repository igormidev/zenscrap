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
  EmailIdpCleanupFutureCallRunModel._({required this.placeholder});

  factory EmailIdpCleanupFutureCallRunModel({required bool? placeholder}) =
      _EmailIdpCleanupFutureCallRunModelImpl;

  factory EmailIdpCleanupFutureCallRunModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailIdpCleanupFutureCallRunModel(
      placeholder: jsonSerialization['placeholder'] as bool?,
    );
  }

  bool? placeholder;

  /// Returns a shallow copy of this [EmailIdpCleanupFutureCallRunModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailIdpCleanupFutureCallRunModel copyWith({bool? placeholder});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmailIdpCleanupFutureCallRunModel',
      if (placeholder != null) 'placeholder': placeholder,
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
  _EmailIdpCleanupFutureCallRunModelImpl({required bool? placeholder})
    : super._(placeholder: placeholder);

  /// Returns a shallow copy of this [EmailIdpCleanupFutureCallRunModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailIdpCleanupFutureCallRunModel copyWith({
    Object? placeholder = _Undefined,
  }) {
    return EmailIdpCleanupFutureCallRunModel(
      placeholder: placeholder is bool? ? placeholder : this.placeholder,
    );
  }
}
