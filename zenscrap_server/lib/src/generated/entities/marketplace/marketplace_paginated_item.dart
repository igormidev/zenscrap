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
import '../../entities/scrappable/scrappable.dart' as _i2;
import 'package:zenscrap_server/src/generated/protocol.dart' as _i3;

abstract class MarketPlacePaginatedItem
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MarketPlacePaginatedItem._({
    required this.scrappable,
    required this.usageCount,
  });

  factory MarketPlacePaginatedItem({
    required _i2.Scrappable scrappable,
    required int usageCount,
  }) = _MarketPlacePaginatedItemImpl;

  factory MarketPlacePaginatedItem.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MarketPlacePaginatedItem(
      scrappable: _i3.Protocol().deserialize<_i2.Scrappable>(
        jsonSerialization['scrappable'],
      ),
      usageCount: jsonSerialization['usageCount'] as int,
    );
  }

  _i2.Scrappable scrappable;

  int usageCount;

  /// Returns a shallow copy of this [MarketPlacePaginatedItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MarketPlacePaginatedItem copyWith({
    _i2.Scrappable? scrappable,
    int? usageCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MarketPlacePaginatedItem',
      'scrappable': scrappable.toJson(),
      'usageCount': usageCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MarketPlacePaginatedItem',
      'scrappable': scrappable.toJsonForProtocol(),
      'usageCount': usageCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _MarketPlacePaginatedItemImpl extends MarketPlacePaginatedItem {
  _MarketPlacePaginatedItemImpl({
    required _i2.Scrappable scrappable,
    required int usageCount,
  }) : super._(
         scrappable: scrappable,
         usageCount: usageCount,
       );

  /// Returns a shallow copy of this [MarketPlacePaginatedItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MarketPlacePaginatedItem copyWith({
    _i2.Scrappable? scrappable,
    int? usageCount,
  }) {
    return MarketPlacePaginatedItem(
      scrappable: scrappable ?? this.scrappable.copyWith(),
      usageCount: usageCount ?? this.usageCount,
    );
  }
}
