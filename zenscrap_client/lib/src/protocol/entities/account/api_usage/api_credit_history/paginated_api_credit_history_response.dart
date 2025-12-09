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
import '../../../../entities/account/api_usage/api_credit_history/api_credit_history_item.dart'
    as _i2;
import '../../../../entities/marketplace/pagination_metadata.dart' as _i3;
import 'package:zenscrap_client/src/protocol/protocol.dart' as _i4;

abstract class PaginatedApiCreditHistoryResponse
    implements _i1.SerializableModel {
  PaginatedApiCreditHistoryResponse._({
    required this.data,
    required this.pagination,
  });

  factory PaginatedApiCreditHistoryResponse({
    required List<_i2.ApiCreditHistoryItem> data,
    required _i3.PaginationMetadata pagination,
  }) = _PaginatedApiCreditHistoryResponseImpl;

  factory PaginatedApiCreditHistoryResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PaginatedApiCreditHistoryResponse(
      data: _i4.Protocol().deserialize<List<_i2.ApiCreditHistoryItem>>(
        jsonSerialization['data'],
      ),
      pagination: _i4.Protocol().deserialize<_i3.PaginationMetadata>(
        jsonSerialization['pagination'],
      ),
    );
  }

  List<_i2.ApiCreditHistoryItem> data;

  _i3.PaginationMetadata pagination;

  /// Returns a shallow copy of this [PaginatedApiCreditHistoryResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaginatedApiCreditHistoryResponse copyWith({
    List<_i2.ApiCreditHistoryItem>? data,
    _i3.PaginationMetadata? pagination,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaginatedApiCreditHistoryResponse',
      'data': data.toJson(valueToJson: (v) => v.toJson()),
      'pagination': pagination.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PaginatedApiCreditHistoryResponseImpl
    extends PaginatedApiCreditHistoryResponse {
  _PaginatedApiCreditHistoryResponseImpl({
    required List<_i2.ApiCreditHistoryItem> data,
    required _i3.PaginationMetadata pagination,
  }) : super._(
         data: data,
         pagination: pagination,
       );

  /// Returns a shallow copy of this [PaginatedApiCreditHistoryResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaginatedApiCreditHistoryResponse copyWith({
    List<_i2.ApiCreditHistoryItem>? data,
    _i3.PaginationMetadata? pagination,
  }) {
    return PaginatedApiCreditHistoryResponse(
      data: data ?? this.data.map((e0) => e0.copyWith()).toList(),
      pagination: pagination ?? this.pagination.copyWith(),
    );
  }
}
