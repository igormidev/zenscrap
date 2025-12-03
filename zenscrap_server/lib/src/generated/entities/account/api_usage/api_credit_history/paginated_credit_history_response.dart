/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../../entities/account/api_usage/api_credit_history/api_creadit_history_item.dart'
    as _i2;
import '../../../../entities/marketplace/pagination_metadata.dart' as _i3;

abstract class PaginatedCreditHistoryResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaginatedCreditHistoryResponse._({
    required this.data,
    required this.pagination,
  });

  factory PaginatedCreditHistoryResponse({
    required List<_i2.CreditHistoryItem> data,
    required _i3.PaginationMetadata pagination,
  }) = _PaginatedCreditHistoryResponseImpl;

  factory PaginatedCreditHistoryResponse.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PaginatedCreditHistoryResponse(
      data: (jsonSerialization['data'] as List)
          .map((e) =>
              _i2.CreditHistoryItem.fromJson((e as Map<String, dynamic>)))
          .toList(),
      pagination: _i3.PaginationMetadata.fromJson(
          (jsonSerialization['pagination'] as Map<String, dynamic>)),
    );
  }

  List<_i2.CreditHistoryItem> data;

  _i3.PaginationMetadata pagination;

  /// Returns a shallow copy of this [PaginatedCreditHistoryResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaginatedCreditHistoryResponse copyWith({
    List<_i2.CreditHistoryItem>? data,
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'data': data.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'pagination': pagination.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PaginatedCreditHistoryResponseImpl
    extends PaginatedCreditHistoryResponse {
  _PaginatedCreditHistoryResponseImpl({
    required List<_i2.CreditHistoryItem> data,
    required _i3.PaginationMetadata pagination,
  }) : super._(
          data: data,
          pagination: pagination,
        );

  /// Returns a shallow copy of this [PaginatedCreditHistoryResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaginatedCreditHistoryResponse copyWith({
    List<_i2.CreditHistoryItem>? data,
    _i3.PaginationMetadata? pagination,
  }) {
    return PaginatedCreditHistoryResponse(
      data: data ?? this.data.map((e0) => e0.copyWith()).toList(),
      pagination: pagination ?? this.pagination.copyWith(),
    );
  }
}
