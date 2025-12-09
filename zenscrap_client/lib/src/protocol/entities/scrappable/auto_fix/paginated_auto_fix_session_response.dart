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
import '../../../entities/scrappable/auto_fix/auto_fix_session.dart' as _i2;
import '../../../entities/marketplace/pagination_metadata.dart' as _i3;

abstract class PaginatedAutoFixSessionResponse
    implements _i1.SerializableModel {
  PaginatedAutoFixSessionResponse._({
    required this.data,
    required this.pagination,
  });

  factory PaginatedAutoFixSessionResponse({
    required List<_i2.AutoFixSession> data,
    required _i3.PaginationMetadata pagination,
  }) = _PaginatedAutoFixSessionResponseImpl;

  factory PaginatedAutoFixSessionResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PaginatedAutoFixSessionResponse(
      data: (jsonSerialization['data'] as List)
          .map((e) => _i2.AutoFixSession.fromJson((e as Map<String, dynamic>)))
          .toList(),
      pagination: _i3.PaginationMetadata.fromJson(
          (jsonSerialization['pagination'] as Map<String, dynamic>)),
    );
  }

  List<_i2.AutoFixSession> data;

  _i3.PaginationMetadata pagination;

  /// Returns a shallow copy of this [PaginatedAutoFixSessionResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaginatedAutoFixSessionResponse copyWith({
    List<_i2.AutoFixSession>? data,
    _i3.PaginationMetadata? pagination,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(valueToJson: (v) => v.toJson()),
      'pagination': pagination.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PaginatedAutoFixSessionResponseImpl
    extends PaginatedAutoFixSessionResponse {
  _PaginatedAutoFixSessionResponseImpl({
    required List<_i2.AutoFixSession> data,
    required _i3.PaginationMetadata pagination,
  }) : super._(
          data: data,
          pagination: pagination,
        );

  /// Returns a shallow copy of this [PaginatedAutoFixSessionResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaginatedAutoFixSessionResponse copyWith({
    List<_i2.AutoFixSession>? data,
    _i3.PaginationMetadata? pagination,
  }) {
    return PaginatedAutoFixSessionResponse(
      data: data ?? this.data.map((e0) => e0.copyWith()).toList(),
      pagination: pagination ?? this.pagination.copyWith(),
    );
  }
}
