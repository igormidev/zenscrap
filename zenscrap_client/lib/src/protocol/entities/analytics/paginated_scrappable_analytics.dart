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
import '../../entities/scrappable/scrappable.dart' as _i2;
import '../../entities/scrappable/scrappable_analytics.dart' as _i3;

abstract class PaginatedScrappableAnalytics implements _i1.SerializableModel {
  PaginatedScrappableAnalytics._({
    required this.scrappable,
    required this.items,
    required this.hasNextPage,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
  });

  factory PaginatedScrappableAnalytics({
    required _i2.Scrappable scrappable,
    required List<_i3.ScrappableAnalytics> items,
    required bool hasNextPage,
    required int totalCount,
    required int currentPage,
    required int pageSize,
  }) = _PaginatedScrappableAnalyticsImpl;

  factory PaginatedScrappableAnalytics.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PaginatedScrappableAnalytics(
      scrappable: _i2.Scrappable.fromJson(
          (jsonSerialization['scrappable'] as Map<String, dynamic>)),
      items: (jsonSerialization['items'] as List)
          .map((e) =>
              _i3.ScrappableAnalytics.fromJson((e as Map<String, dynamic>)))
          .toList(),
      hasNextPage: jsonSerialization['hasNextPage'] as bool,
      totalCount: jsonSerialization['totalCount'] as int,
      currentPage: jsonSerialization['currentPage'] as int,
      pageSize: jsonSerialization['pageSize'] as int,
    );
  }

  _i2.Scrappable scrappable;

  List<_i3.ScrappableAnalytics> items;

  bool hasNextPage;

  int totalCount;

  int currentPage;

  int pageSize;

  /// Returns a shallow copy of this [PaginatedScrappableAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaginatedScrappableAnalytics copyWith({
    _i2.Scrappable? scrappable,
    List<_i3.ScrappableAnalytics>? items,
    bool? hasNextPage,
    int? totalCount,
    int? currentPage,
    int? pageSize,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'scrappable': scrappable.toJson(),
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'hasNextPage': hasNextPage,
      'totalCount': totalCount,
      'currentPage': currentPage,
      'pageSize': pageSize,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PaginatedScrappableAnalyticsImpl extends PaginatedScrappableAnalytics {
  _PaginatedScrappableAnalyticsImpl({
    required _i2.Scrappable scrappable,
    required List<_i3.ScrappableAnalytics> items,
    required bool hasNextPage,
    required int totalCount,
    required int currentPage,
    required int pageSize,
  }) : super._(
          scrappable: scrappable,
          items: items,
          hasNextPage: hasNextPage,
          totalCount: totalCount,
          currentPage: currentPage,
          pageSize: pageSize,
        );

  /// Returns a shallow copy of this [PaginatedScrappableAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaginatedScrappableAnalytics copyWith({
    _i2.Scrappable? scrappable,
    List<_i3.ScrappableAnalytics>? items,
    bool? hasNextPage,
    int? totalCount,
    int? currentPage,
    int? pageSize,
  }) {
    return PaginatedScrappableAnalytics(
      scrappable: scrappable ?? this.scrappable.copyWith(),
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      hasNextPage: hasNextPage ?? this.hasNextPage,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
