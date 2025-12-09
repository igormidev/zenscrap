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

abstract class PaginationMetadata implements _i1.SerializableModel {
  PaginationMetadata._({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.totalUserScrappables,
  });

  factory PaginationMetadata({
    required int currentPage,
    required int pageSize,
    required int totalCount,
    required int totalPages,
    required bool hasNextPage,
    required bool hasPreviousPage,
    int? totalUserScrappables,
  }) = _PaginationMetadataImpl;

  factory PaginationMetadata.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaginationMetadata(
      currentPage: jsonSerialization['currentPage'] as int,
      pageSize: jsonSerialization['pageSize'] as int,
      totalCount: jsonSerialization['totalCount'] as int,
      totalPages: jsonSerialization['totalPages'] as int,
      hasNextPage: jsonSerialization['hasNextPage'] as bool,
      hasPreviousPage: jsonSerialization['hasPreviousPage'] as bool,
      totalUserScrappables: jsonSerialization['totalUserScrappables'] as int?,
    );
  }

  int currentPage;

  int pageSize;

  int totalCount;

  int totalPages;

  bool hasNextPage;

  bool hasPreviousPage;

  int? totalUserScrappables;

  /// Returns a shallow copy of this [PaginationMetadata]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaginationMetadata copyWith({
    int? currentPage,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    int? totalUserScrappables,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaginationMetadata',
      'currentPage': currentPage,
      'pageSize': pageSize,
      'totalCount': totalCount,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
      if (totalUserScrappables != null)
        'totalUserScrappables': totalUserScrappables,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaginationMetadataImpl extends PaginationMetadata {
  _PaginationMetadataImpl({
    required int currentPage,
    required int pageSize,
    required int totalCount,
    required int totalPages,
    required bool hasNextPage,
    required bool hasPreviousPage,
    int? totalUserScrappables,
  }) : super._(
         currentPage: currentPage,
         pageSize: pageSize,
         totalCount: totalCount,
         totalPages: totalPages,
         hasNextPage: hasNextPage,
         hasPreviousPage: hasPreviousPage,
         totalUserScrappables: totalUserScrappables,
       );

  /// Returns a shallow copy of this [PaginationMetadata]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaginationMetadata copyWith({
    int? currentPage,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    Object? totalUserScrappables = _Undefined,
  }) {
    return PaginationMetadata(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      totalUserScrappables: totalUserScrappables is int?
          ? totalUserScrappables
          : this.totalUserScrappables,
    );
  }
}
