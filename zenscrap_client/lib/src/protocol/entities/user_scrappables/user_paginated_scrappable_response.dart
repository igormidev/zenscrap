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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../entities/scrappable/scrappable.dart' as _i2;
import '../../entities/marketplace/pagination_metadata.dart' as _i3;
import 'package:zenscrap_client/src/protocol/protocol.dart' as _i4;

abstract class UserPaginatedScrappableResponse
    implements _i1.SerializableModel {
  UserPaginatedScrappableResponse._({
    required this.data,
    required this.pagination,
  });

  factory UserPaginatedScrappableResponse({
    required List<_i2.Scrappable> data,
    required _i3.PaginationMetadata pagination,
  }) = _UserPaginatedScrappableResponseImpl;

  factory UserPaginatedScrappableResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserPaginatedScrappableResponse(
      data: _i4.Protocol().deserialize<List<_i2.Scrappable>>(
        jsonSerialization['data'],
      ),
      pagination: _i4.Protocol().deserialize<_i3.PaginationMetadata>(
        jsonSerialization['pagination'],
      ),
    );
  }

  List<_i2.Scrappable> data;

  _i3.PaginationMetadata pagination;

  /// Returns a shallow copy of this [UserPaginatedScrappableResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPaginatedScrappableResponse copyWith({
    List<_i2.Scrappable>? data,
    _i3.PaginationMetadata? pagination,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserPaginatedScrappableResponse',
      'data': data.toJson(valueToJson: (v) => v.toJson()),
      'pagination': pagination.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UserPaginatedScrappableResponseImpl
    extends UserPaginatedScrappableResponse {
  _UserPaginatedScrappableResponseImpl({
    required List<_i2.Scrappable> data,
    required _i3.PaginationMetadata pagination,
  }) : super._(
         data: data,
         pagination: pagination,
       );

  /// Returns a shallow copy of this [UserPaginatedScrappableResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPaginatedScrappableResponse copyWith({
    List<_i2.Scrappable>? data,
    _i3.PaginationMetadata? pagination,
  }) {
    return UserPaginatedScrappableResponse(
      data: data ?? this.data.map((e0) => e0.copyWith()).toList(),
      pagination: pagination ?? this.pagination.copyWith(),
    );
  }
}
