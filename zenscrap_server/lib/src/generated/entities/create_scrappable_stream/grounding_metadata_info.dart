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
import '../../entities/create_scrappable_stream/grounding_source_info.dart'
    as _i2;
import 'package:zenscrap_server/src/generated/protocol.dart' as _i3;

abstract class GroundingMetadataInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  GroundingMetadataInfo._({
    required this.searchQueries,
    required this.sources,
  });

  factory GroundingMetadataInfo({
    required List<String> searchQueries,
    required List<_i2.GroundingSourceInfo> sources,
  }) = _GroundingMetadataInfoImpl;

  factory GroundingMetadataInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GroundingMetadataInfo(
      searchQueries: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['searchQueries'],
      ),
      sources: _i3.Protocol().deserialize<List<_i2.GroundingSourceInfo>>(
        jsonSerialization['sources'],
      ),
    );
  }

  List<String> searchQueries;

  List<_i2.GroundingSourceInfo> sources;

  /// Returns a shallow copy of this [GroundingMetadataInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GroundingMetadataInfo copyWith({
    List<String>? searchQueries,
    List<_i2.GroundingSourceInfo>? sources,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GroundingMetadataInfo',
      'searchQueries': searchQueries.toJson(),
      'sources': sources.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GroundingMetadataInfo',
      'searchQueries': searchQueries.toJson(),
      'sources': sources.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _GroundingMetadataInfoImpl extends GroundingMetadataInfo {
  _GroundingMetadataInfoImpl({
    required List<String> searchQueries,
    required List<_i2.GroundingSourceInfo> sources,
  }) : super._(
         searchQueries: searchQueries,
         sources: sources,
       );

  /// Returns a shallow copy of this [GroundingMetadataInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GroundingMetadataInfo copyWith({
    List<String>? searchQueries,
    List<_i2.GroundingSourceInfo>? sources,
  }) {
    return GroundingMetadataInfo(
      searchQueries:
          searchQueries ?? this.searchQueries.map((e0) => e0).toList(),
      sources: sources ?? this.sources.map((e0) => e0.copyWith()).toList(),
    );
  }
}
